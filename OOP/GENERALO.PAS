{*************************************************************************}
{UNIT GENERALOBJ                                                          }
{Ñ†§ò† û ò§ò§ú‡£ú§û ú°õ¶©û ´û™ General °ò† ßú®†úÆú† öú§†°ú™ ®¶¨´†§ú™      }
{Æú†®†©£¶¨ (ß¢û°´®¶¢¶ö†¶¨,¶ü¶§û™)                                         }
{                                                                         }
{CopyRight 1993 By George Papaioannou                                     }
{*************************************************************************}



UNIT GENERALObj;


INTERFACE
Uses Crt,Dos,VarConstObj,MouseObj;

{$L C:\bp7\obj\cpu.obj}

Type
     BasicColors = Record
         Red,
         Green,
         Blue  :Byte;
     End;

     RGBColors   = Array [0..767] Of Byte;
     RGBType     = Array [0..255] of BasicColors;


Var

    CurColumn,CurRow,ColumnsNum,
    SScanL,EScanL,ScreenPage     :Byte;
    VideoMode,CurrentPage        :Byte;

    WriteTextColor,
    WriteTextBackground          :Byte;

    KBScanCode,KBAsciiCode       :Byte;
    Ctrl,Ascii                   :Char;

    TextPalette                  :Array[0..16] of Byte;
Const
     TextCursorShown              :Boolean = False;

     LEFTJUSTIFY        = 1;
     RIGHTJUSTIFY       = 2;

     i8088              = 0;
     i8086              = 1;
     NEC_V20            = 2;
     NEC_V30            = 3;
     i80188             = 4;
     i80186             = 5;
     i286               = 6;
     i386               = 7;
     i486               = 8;

     No_Coprocessor     = 0;
     i8087              = 1;
     i80287             = 2;
     i80387_80487       = 3;

     KbArrowLeft          = 75;
     KbArrowRight         = 77;
     KbArrowUp            = 72;
     KbArrowDown          = 80;
     KbPageUp             = 73;
     KbPageDown           = 81;
     KbHome               = 71;
     KbEnd                = 79;
     KbInsert             = 82;
     KbDelete             = 83;
     KbTab                = 9;
     KbShiftTab           = 15;

Const
     TextCheckSnow              :Boolean = False;
     SoundFx                    :Boolean = False;
     On                         :Boolean = True;
     Off                        :Boolean = False;
     DosVer                     :String  = '';
     TextCursorSSL              :Byte = 0;
     TextCursorESL              :Byte = 0;




{ê¶¨´†§ú™ ö†ò ´¶§ cursor}

Procedure SetBiosKeybRate(KbRate,KbDelay :Byte);
Procedure HalfCur;
Procedure CurOff;
Procedure BlockCur;
Procedure CurOn;

{ê¶¨´†§ú™ ¶ü¶§û™ -öú§†°ú™-}

Procedure ReadCurPositHeight;
Procedure SetVideoPage(ScreenPage2 :Byte);
Procedure ReadVideoStatus;
Procedure SetVideoMode(Mode:Byte);
Procedure SetCurPositionXY (X1,Y1 :Byte);
Procedure SetCurLength (SScan2,EScan2 :byte);
Procedure CopyPage0ToPageX(PageNum :Word);
{ê¶¨´†§ú™ ú£≠ò§†©û™}

Procedure WriteChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);
Procedure WriteOut(X1,Y1 :Word; ST:String);
Procedure WriteWinChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);
Procedure WriteWinOut(X1,Y1 :Word; ST:String);
Procedure MakeBackGround(TxtColor,BackColor,AsciiCode :Byte);
Procedure DrawLine(X1,Y1,X2     :Byte);
Procedure DrawFilledBox(X1,Y1,X2,Y2,TxtColor,BckColor :Byte);
Function  BroadCastChar(Name :String) :Byte;
Function  SetString(A :String;Size,Params :Byte) :String;

{ê¶¨´†§ú™ ¨ß¶¢¶ö†©£‡§}

Function  Power(number,dyn:real):real;
Function  TextMaxX :Byte;
Function  TextMaxY :Byte;

{ê¶¨´†§ú™ ò°¶¨©´†°ú™ - ûÆ¶¨ -}

Procedure Fx;


{ê¶¨´†§ú™ ß¢û°´®¶¢¶ö†¶¨}

Function  BiosKeyPressed : Boolean;
Procedure ReadKbd(var InChr, InCtl : Char);
Procedure WaitForEvent;
Procedure InsertKbChar(InChar :Word);

{Ñ†õ†°ú™ ®¶¨´†§ú™}

Procedure SetClock(X,Y,TxtColor,BckColor :Byte);
Procedure CrystalDelay(DelayNum :Word);
Procedure RetraceDelay(RetrNum :Word);
Procedure VerticalRetrace;
Procedure HorizontalRetrace;
Procedure ScrollUp(UX1,UY1,DX2,DY2,ROW,Col :byte);
Procedure ScrollDown(UX1,UY1,DX2,DY2,ROW,Col :byte);
Function  GrUpCase(CharIn :Byte) :Byte;
Function  GreekUpCase(C :Char) : Char;
Function  UpCaseString(S :String) :String;

{ê¶¨´†§ú™ ßò¢¢ú´ò™}

Procedure SavePalette;
Procedure RestorePalette;
Procedure ChangePalette(SourceDac,DestDac :Byte);
Procedure ReadRGBColors(Var Pal :RGBType);
Procedure SetRGBColors(Var Pal :RGBType);

{ê¶¨´†§ú™ ú¢úöÆ‡§}
Function  DosVer5 :Boolean;
Function  MicroSoftWindows :Boolean;
{$F+}
Function   GetProz :Integer;
Function   GetCo   :Integer;
{$F-}
Procedure SetPreferences;
Procedure CheckLength(Var Str :String;X1,X2 :Byte);

IMPLEMENTATION

{ê¶¨´†§ú™ ö†ò ´¶§ Cursor}


{***********************************************************************}
{Procedure SetBiosKeybRate                                              }
{Characters per second.                                                 }
{KbRate :0=30c/p,1,2,4,8,$0A=10c/p,$0D,$10h,$14,$1F=2c/p                }
{KbDelay:0=250ms,1=500ms,2=750ms,3=1000ms                               }
{It works only with the AT-enchanced MFII 102 keyboard panel.           }
{***********************************************************************}

Procedure SetBiosKeybRate(KbRate,KbDelay :Byte);Assembler;
Asm;
    mov ah,03h
    mov al,05h
    mov bl,KbRate
    mov bh,KbDelay
    int 16h
End;


{************************************************************************}
{Procedure HalfCur                                                       }
{é °ú®©¶®ò™ ú£≠ò§†ùú´ò† £¶§¶ £ú ´¶ °ò´‡ £†©¶ block                       }
{************************************************************************}

Procedure HalfCur;Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,1
   mov ch,4
   mov cl,7
   int 10h

   mov TextCursorShown,True

   pop dx
   pop cx
   pop bx
   pop ax
End;


{*************************************************************************}
{Procedure CurOff                                                         }
{Ñ•ò≠ò§†©û ´¶¨ °ú®©¶®ò òß¶ ´û§ ¶ü¶§û                                      }
{*************************************************************************}

Procedure CurOff;Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,01h
   mov ch,30h
   mov cl,00h
   int 10h

   mov TextCursorShown,False

   pop dx
   pop cx
   pop bx
   pop ax
End;


{************************************************************************}
{Procedure BlockCur                                                      }
{Ñ£≠ò§†ùú´ò† ¶¢¶°¢û®¶ ´¶ block ´¶¨ °ú®©¶®ò                               }
{************************************************************************}

Procedure BlockCur;Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,1
   mov ch,0
   mov cl,7
   mov TextCursorSSL,ch
   mov TextCursorESL,cl
   int 10h

   mov TextCursorShown,True

   pop dx
   pop cx
   pop bx
   pop ax

End;

Procedure CurOn;assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   push es

   mov ax,0040h
   mov es,ax
   mov al,es:[0049h]
   cmp al,7
   jz  @Mono

   mov ch,6
   mov cl,7
   mov TextCursorSSL,ch
   mov TextCursorESL,cl
   jmp @Cont

@Mono:
   mov ch,11
   mov cl,12
   mov TextCursorSSL,ch
   mov TextCursorESL,cl

@Cont:
   mov ah,1
   int 10h

   mov TextCursorShown,True

   pop es

   pop dx
   pop cx
   pop bx
   pop ax

End;



{ê¶¨´†§ú™ ¶ü¶§û™ -öú§†°ú™-}


{************************************************************************}
{Procedure ReadCurPosit&Height                                           }
{ë‡©†£¶ ´‡§ Æ °ò† Ø °òü‡™ °ò† ´¶ ¨Ø¶™ ´¶¨ block ´¶¨ °ú®©¶®ò.             }
{ë‡ùú† ©´†™ £ú´òô¢û´ú™ CurColumn ´û§ ´®úÆ¶¨©ò ©´û¢û ´¶¨ °ú®©¶®ò ©´û £ú´òô}
{¢û´û CurRow ´û§ ´®úÆ¶¨©ò ö®ò££û ©´û SScanL û ò®Æû ´¶¨ Scan Line °ò† ©´û }
{ÑScanL ´¶ ´ú¢¶™ ´û™ Scan Line.Eß†©û™ ©´û £ú´òô¢û´û ScreenPage ©‡ùú´ò†   }
{û ´®úÆ¶¨©ò ©ú¢†õò ¶ü¶§û™                                                }
{************************************************************************}

Procedure ReadCurPositHeight;Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,3
   mov bh,0
   int 10h
   mov CurColumn,dl
   mov CurRow,dh
   mov SScanL,ch
   mov EScanL,cl
   mov ScreenPage,bh

   pop dx
   pop cx
   pop bx
   pop ax
End;


{************************************************************************}
{Procedure SetVideoPage                                                  }
{Ñ§ú®ö¶ß¶†¶¨£ú £†ò ©ú¢†õò ¶ü¶§û™                                         }
{************************************************************************}

Procedure SetVideoPage(ScreenPage2 :Byte);Assembler;
Asm
   push ax
   push bx
   push cx
   push dx

   mov ah,5
   mov al,ScreenPage2
   int 10h

   pop dx
   pop cx
   pop bx
   pop ax
End;

{*********************************************************************}
{Procedure ReadVideoStatus                                            }
{Ñß†©´®ú≠ú† ´û§ ´®úÆ¶¨©ò ©ú¢†õò ©´û £ú´òô¢û´û CurrentPage,´‡§ ò®†ü£¶  }
{´‡§ ©´û¢‡§ ©´û £ú´òô¢û´û ColumnsNum °ò† ´¶ ´®úÆ¶§ mode ©´û £ú´òô¢û´û }
{VideoMode                                                            }
{*********************************************************************}

Procedure ReadVideoStatus;Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,0Fh
   int 10h
   mov ColumnsNum,ah
   mov VideoMode,al
   mov CurrentPage,bh

   pop dx
   pop cx
   pop bx
   pop ax
End;


{********************************************************************}
{Procedure SetVideoMode                                              }
{Ñ§ú®ö¶ß¶†ú† ú§ò mode                                                }
{********************************************************************}

Procedure SetVideoMode(Mode:Byte);Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   mov ah,0
   mov al,Mode
   int 10h

   pop dx
   pop cx
   pop bx
   pop ax
End;

{**********************************************************************}
{Procedure SetCurPosition                                              }
{í¶ß¶üú´ú† ´¶§ °ú®©¶®ò ©´†™ ï1 °ò† ì1 ©´û§ ©ú¢†õò ß¶¨ õ†§¶¨£ú ö†ò      }
{ßò®ò£ú´®¶.                                                            }
{**********************************************************************}

Procedure SetCurPositionXY (X1,Y1 :Byte);Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   push es

   mov ax,0040h
   mov es,ax
   mov bh,es:[0062h]


   mov ah,2
   mov dh,Y1
   mov dl,X1
   int 10h

   pop es

   pop dx
   pop cx
   pop bx
   pop ax
End;


{***********************************************************************}
{Procedure SetCurLength                                                 }
{Ä¢¢òù¶¨£ú ´¶ £û°¶™ Block ´¶¨ °ú®©¶®ò                                   }
{***********************************************************************}

Procedure SetCurLength (SScan2,EScan2 :byte);Assembler;
Asm;
   push ax
   push bx
   push cx
   push dx

   cmp ch,30h
   jz @NoCursor
   mov TextCursorShown,True
   jmp @Cont

@NoCursor:
   mov TextCursorShown,False

@Cont:
   mov ah,1
   mov ch,SScan2
   mov cl,EScan2
   int 10h

   pop dx
   pop cx
   pop bx
   pop ax
End;


Procedure CopyPage0ToPageX(PageNum :Word);assembler;
asm;
    push ax
    push bx
    push cx
    push si
    push di

    push es
    push ds

    mov ax,VideoSeg
    mov ds,ax
    mov si,0

    push ax

    mov ax,100h
    mov bx,PageNum

    mul bx

    pop bx

    add ax,bx
    mov es,ax
    mov di,0

    mov cx,2000
    cld

    rep movsw

    pop ds
    pop es

    pop di
    pop si
    pop cx
    pop bx
    pop ax

End;


{ê¶¨´†§ú™ ú£≠ò§†©û™}

{***********************************************************************}
{PROCEDURE WriteChar                                                    }
{Ç®ò≠ú† ú§ò Æò®ò°´û®ò ©´û ï1 °ò† ì1 £ú °òü¶®†©£ú§¶ textcolor °ò† back   }
{ground £ú ´û§ ú§´¶¢û Mem                                               }
{***********************************************************************}

Procedure WriteChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);assembler;
Asm;

     mov ax,X1
     mov bx,BiosColumns
     shr bx,1
     cmp ax,bx
     ja  @OutOfScreen

     mov ax,Y1
     xor bx,bx
     mov bl,BiosRows
     cmp ax,bx
     ja  @OutOfScreen

     {********************************************************************************
     Mem[VideoSeg:160*(Y1-1)+2*(X1-1)]:=InChar;
     Mem[VideoSeg:160*(Y1-1)+2*(X1-1)+1]:=0+(InBackgroundColor shl 4)+InTextColor;
     **********************************************************************************}

     dec  x1
     dec  y1

     mov ax,VideoSeg
     mov es,ax

     mov ax,BiosColumns
     mov bx,y1

     push dx
     mul bx
     pop dx

     mov bx,word ptr x1   {X offset            }
     shl bx,1             {BX=BX*2             }

     add ax,bx

     mov si,ax
     mov ah,InChar
     mov al,InBackGroundColor

     shl al,1
     shl al,1
     shl al,1
     shl al,1
     or  al,InTextColor

     cmp TextCheckSnow,True
     jnz @Cont

     push ax
     Call HorizontalRetrace
     pop  ax

@Cont:
     mov es:[si],ah
     mov es:[si+1],al

@OutOfScreen:
End;


{***********************************************************************}
{PROCEDURE WriteWinChar                                                 }
{Ç®ò≠ú† ú§ò Æò®ò°´û®ò ©´û ï1 °ò† ì1 £ú °òü¶®†©£ú§¶ textcolor °ò† back   }
{ground £ú ´û§ ú§´¶¢û Mem                                               }
{***********************************************************************}

Procedure WriteWinChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);assembler;
Asm;


     mov ax,X1
     mov bx,BiosColumns
     shr bx,1
     cmp ax,bx
     ja  @OutOfScreen

     mov ax,Y1
     xor bx,bx
     mov bl,BiosRows
     cmp ax,bx
     ja  @OutOfScreen

     mov ax,X1
     xor bx,bx
     mov bl,SetWindowX2
     cmp ax,bx
     ja  @OutOfScreen

     mov ax,Y1
     xor bx,bx
     mov bl,SetWindowY2
     cmp ax,bx
     ja  @OutOfScreen

     dec  x1
     dec  y1

     mov ax,VideoSeg
     mov es,ax

     mov ax,BiosColumns
     mov bx,y1

     push dx
     mul bx
     pop dx

     mov bx,word ptr x1   {X offset            }
     shl bx,1             {BX=BX*2             }

     add ax,bx

     mov si,ax
     mov ah,InChar
     mov al,InBackGroundColor
     shl al,1
     shl al,1
     shl al,1
     shl al,1
     or  al,InTextColor

     cmp TextCheckSnow,True
     jnz @Cont

     push ax
     Call HorizontalRetrace
     pop  ax

@Cont:
     mov es:[si],ah
     mov es:[si+1],al

@OutOfScreen:
End;



{**********************************************************************}
{Procedure WriteOut                                                    }
{í¨ß‡§ú† ú§ò string ©´†™ ï1,ì1 £ú textcolor ß¶¨ °òü¶®†ùú´ò† òß¶ ´û§    }
{£ú´òô¢û´û WriteTextColor °ò† background òß¶  ´û§ £ú´òô¢û´û            }
{WriteTextBackGround                                                   }
{**********************************************************************}


Procedure WriteOut(X1,Y1 :Word;ST:String);
Var
  AsmSt         :String;
  STSeg,STOfs   :Word;
  XTrace        :Word;
Begin

   IF ST='' Then
      Exit;

   AsmSt:=St;
   STSeg:=Seg(AsmSt);
   STOfs:=Ofs(AsmSt);

   IF X1 > (BiosColumns shr 1) Then
      Exit;

   IF Y1 > BiosRows Then
      Exit;

   XTrace:=X1;

   Asm;
   {***************************************************************************************************
   I:=1;
   HiddenMouseCursor;
   While (I<=Length(St)) do
   Begin
      Mem[VideoSeg:160*(Y1-1)+2*((X1+I-1)-1)]:=Ord(ST[i]);
      Mem[VideoSeg:160*(Y1-1)+2*((X1+I-1)-1)+1]:=0+(WriteTextBackground shl 4)+WriteTextColor;
      Inc(i);
   End;
   ShowMouseCursor;
   *****************************************************************************************************}

     push ds

     dec  x1
     dec  y1

     mov ax,VideoSeg
     mov es,ax

     mov ax,BiosColumns
     mov bx, word ptr y1

     cmp ax,160
     jnz @ClasicMul

     shl bx,1    {Bx:=Bx*16}
     shl bx,1
     shl bx,1
     shl bx,1

     mov ax,bx

     shl bx,1  {Bx:=Bx*64}
     shl bx,1

     add ax,bx
     shl ax,1 {80*2}

     jmp @Co1

@ClasicMul:
     mul bx               {AX=AX*BX = 80 * Y1-1}


@Co1:
     mov bx,word ptr x1   {X offset            }
     shl bx,1             {BX=BX*2             }

     add ax,bx            {Now we have the real coords X,Y}

     {Ax points the start in to the video Buffer          }
     mov di,ax

     mov ah,WriteTextBackGround

     shl ah,1
     shl ah,1
     shl ah,1
     shl ah,1

     or ah,WriteTextColor

     mov dx,BiosColumns
     shr dx,1
     mov bx,XTrace
     push bx

     mov bx,StOfs
     push bx

     mov bx,StSeg      {ST[0]=Length                   }
     mov ds,bx

     pop bx
     xor cx,cx
     mov cl,ds:[bx]

     inc bx
     mov si,bx

     pop bx

     cmp TextCheckSnow,True
     jnz @LoopCont

     push ax
     push dx
     Call VerticalRetrace
     pop  dx
     pop  ax

 @LoopCont:
     lodsb
     mov es:[di],al
     mov es:[di+1],ah
     inc di
     inc di

     inc bx
     cmp bx,dx
     ja  @StopLoop

     loop @LoopCont

@StopLoop:

     pop ds
   End;
End;


{**********************************************************************}
{Procedure WriteWinOut                                                 }
{í¨ß‡§ú† ú§ò string ©´†™ ï1,ì1 £ú textcolor ß¶¨ °òü¶®†ùú´ò† òß¶ ´û§    }
{£ú´òô¢û´û WriteTextColor °ò† background òß¶  ´û§ £ú´òô¢û´û            }
{WriteTextBackGround                                                   }
{**********************************************************************}


Procedure WriteWinOut(X1,Y1 :Word;ST:String);
Var
  AsmSt          :String;
  STSeg,STOfs    :Word;
  XTrace         :Word;
  MaxSizeX2      :Word;
  MaxScreenSizeX2:Word;
Begin

   IF ST='' Then
      Exit;

   AsmSt:=St;
   STSeg:=Seg(AsmSt);
   STOfs:=Ofs(AsmSt);

   IF (X1 > (BiosColumns shr 1)) or (X1 >SetWindowX2) Then
      Exit;

   IF (Y1 > BiosRows) or (Y1 > SetWindowY2) Then
      Exit;

   XTrace:=X1;

   Asm;

     push ds

     dec  x1
     dec  y1

     mov ax,VideoSeg
     mov es,ax

     mov ax,BiosColumns
     mov bx, word ptr y1

     cmp ax,160
     jnz @ClasicMul

     shl bx,1    {Bx:=Bx*16}
     shl bx,1
     shl bx,1
     shl bx,1

     mov ax,bx

     shl bx,1  {Bx:=Bx*64}
     shl bx,1

     add ax,bx
     shl ax,1 {80*2}

     jmp @Co1

@ClasicMul:
     mul bx               {AX=AX*BX = 80 * Y1-1}

@Co1:
     mov bx,word ptr x1   {X offset            }
     shl bx,1             {BX=BX*2             }

     add ax,bx            {Now we have the real coords X,Y}

     {Ax points the start in to the video Buffer          }
     mov di,ax

     mov ah,WriteTextBackGround

     shl ah,1
     shl ah,1
     shl ah,1
     shl ah,1

     or ah,WriteTextColor

     mov dx,ds
     push dx

     mov dx,BiosColumns
     shr dx,1
     mov MaxScreenSizeX2,dx

     xor cx,cx
     mov cl,SetWindowX2
     mov MaxSizeX2,cx

     mov dx,XTrace

     mov bx,StOfs
     push bx

     mov bx,StSeg      {ST[0]=Length                   }
     mov ds,bx

     pop bx
     xor cx,cx
     mov cl,ds:[bx]

     inc bx
     mov si,bx

     xchg dx,bx

     cmp TextCheckSnow,True
     jnz @LoopCont

     push ax
     push dx
     Call VerticalRetrace
     pop  dx
     pop  ax

 @LoopCont:
     lodsb
     mov es:[di],al
     mov es:[di+1],ah
     inc di
     inc di

     inc bx

     pop dx
     push ds
     mov ds,dx

     cmp bx,MaxScreenSizeX2
     ja  @StopLoop

     cmp bx,MaxSizeX2
     ja  @StopLoop

     pop ds
     push dx

     loop @LoopCont

     pop dx
     jmp @Finish

@StopLoop:
     pop ds
@Finish:

     pop ds
   End;
End;
{************************************************************************}
{Procedure MakeBackGround                                                }
{Çú£†ùú† ´û§ ¶ü¶§û £ú ´¶ Æò®ò°´û®ò ß¶¨ õ†§¶¨£ú ©ò§ ßò®ò£ú´®¶             }
{************************************************************************}


Procedure MakeBackGround(TxtColor,BackColor,AsciiCode :Byte);assembler;
Asm;
     push ax
     push cx
     push di

     push es

     mov ax,BiosColumns
     xor dh,dh
     mov dl,BiosRows
     mul dx
     mov cx,ax

     mov ax,VideoSeg
     mov es,ax
     xor ax,ax
     mov ah,BackColor
     mov cl,4
     shl ah,cl
     or  ah,TxtColor
     mov al,AsciiCode
     mov di,0
     cld

     rep stosw

     pop es

     pop di
     pop cx
     pop ax

End;

{************************************************************************}
{Procedure DrawLine                                                      }
{ëÆúõ†òùú† £†ò ö®ò££û                                                    }
{************************************************************************}

Procedure DrawLine(X1,Y1,X2     :Byte);
Var
   I            :Byte;
   AsciiC       :Char;
Begin
     AsciiC:='ƒ';
     For I:=X1 to X2 do
         WriteChar(I,Y1,WriteTextColor,WriteTextBackGround,ord(AsciiC));

End;


Procedure DrawFilledBox(X1,Y1,X2,Y2,TxtColor,BckColor :Byte);
Var
   I,j  :Byte;
Begin
    For I:=Y1 to Y2 do
      For J:=X1 to X2 do
        WriteChar(J,I,TxtColor,BckColor,32);
End;


{*********************************************************************}
{Function BroadCastChar                                               }
{ñòÆ§ú† ©ú ú§ò string §ò ô®ú† ´¶§ Æò®ò°´û®ò " ~ " .Ñò§ ´¶§ ô®ú† ´¶´ú  }
{¶ ò£ú©¶™ úß¶£ú§¶™ Æò®ò°´û®ò™ ú†§ò† BroadCast character.Å®†©°ú† ´¶§   }
{Ascii Æò®ò°´û®ò °ò† ´¶§ úß†©´®ú≠ú†.                                  }
{*********************************************************************}

Function BroadCastChar(Name :String) :Byte;
Var
  I                    :Byte;
  TakeChar             :String[1];
  OrdChar              :Byte;
Begin
  IF Name<>'' Then
  Begin
    For I:=1 To Length(Name) do
    Begin
        TakeChar:=Copy(Name,I,1);

        IF TakeChar[1]='~' Then
        Begin
          TakeChar:=Copy(Name,I+1,1);

          {Ñò§ ò§û°ú† ©ú ú¢¢û§†°¶¨™ Æò®ò°´û®ú™ ´¶´ú ú¢ò úõ‡.    }

          IF Ord(TakeChar[1]) >= 128 Then
             TakeChar[1]:=Chr(GrUpCase(Ord(TakeChar[1])));

          {Ä¢¢†‡™ òöö¢†°¶™ Æò®ò°´û®ò™                                   }
           OrdChar:=Ord(TakeChar[1]);
           IF OrdChar >= 97 Then
              OrdChar:=OrdChar-32;
           BroadCastChar:=(OrdChar-65)+1;
           Exit;
        End;
    End;
  End
  Else
    BroadCastChar:=255;
End;

{**************************************************************}
{Function SetString                                            }
{Fill a string with blanks.In Params we pass these values :    }
{ Left  justify = 1                                            }
{ Right justify = 2                                            }
{**************************************************************}
Function SetString(A :String;Size,Params :Byte) :String;
Var
   I    :Byte;
Begin
    IF Length(A) >= Size Then
    Begin
       A:=Copy(A,1,Size);
    End
    Else
    Begin
       IF (Params and LeftJustify) = LeftJustify Then
       Begin
           For I:=Length(A)+1 To Size Do
               A:=A+' ';
       End
       Else
       Begin
           For I:=Length(A)+1 To Size Do
               A:=' '+A;
       End;
    End;

    SetString:=A;
End;



{ê¶¨´†§ú™ ¨ß¶¢¶ö†©£‡§}

{*************************************************************************}
{Procedure Power                                                          }
{ìß¶¢¶ö†ùú† ´û§ õ¨§ò£û °òß¶†¶¨ ò®†ü£¶¨   (¨Ø‡©û ©ú õ¨§ò£û)                }
{*************************************************************************}

Function Power(Number,Dyn:Real):Real;
Begin
     Power:=Exp(Dyn*Ln(Number));
End;

Function TextMaxX :Byte;
Begin
     TextMaxX:=Mem[$0040:$004A];
End;

Function TextMaxY :Byte;
Begin
     TextMaxY:=Mem[$0040:$0084]+1;
End;

{ê¶¨´†§ú™ ò°¶¨©´†°ú™ - ûÆ¶¨ -}

{***********************************************************************}
{Procedure Fx                                                           }
{Éû£†¶¨®öú† ú§ò Æò®ò°´û®†©´†°¶ ûÆ¶                                      }
{***********************************************************************}

Procedure Fx;
Begin
     Sound(6500);Delay(10);Nosound;
     Sound(3000);Delay(5);Nosound;
     Sound(2000);Delay(4);Nosound;
     Sound(2000);Delay(4);Nosound;
     Sound(500); Delay(2);Nosound;
     Sound(250); Delay(2);Nosound;
End;

{ê¶¨´†§ú™ ß¢û°´®¶¢¶ö†¶¨}

{*************************************************************************}
{Procedure ReadKbd                                                        }
{É†òôòùú† ú§ò ß¢û°´®¶ òß¶ ´¶ ß¢û°´®¶¢¶ö†¶ °ò† úß†©´®ú≠ú† ´¶ Scan °ò† Ascii}
{°‡õ†°¶                                                                   }
{*************************************************************************}

{Procedure ReadKbd(var InChr, InCtl : Char);
Begin
      InCtl := #0;
      InChr := ReadKey;
      IF (InChr = #0) then
        InCtl := ReadKey
      Else
      IF  (InChr in [#1..#31,#127]) then
          InCtl := InChr;
End;}

Procedure ReadKbd(Var InChr,InCtl :Char);
Begin
     Asm;
          push ax

          mov ah,0
          int 16h

          mov KBScanCode,ah
          mov KBAsciiCode,al

          pop ax
     End;
     IF KBAsciiCode=0 Then
     Begin
         InChr:=#0;
         InCtl:=Chr(KBScanCode);
     End
     Else
     Begin
         InChr:=Chr(KBAsciiCode);
         InCtl:=#0;
     End
End;

Function BiosKeyPressed :Boolean;
Begin
  IF Mem[$0040:$001C]=Mem[$0040:$001A] Then
     BiosKeyPressed:=False
  Else
     BiosKeyPressed:=True;
End;

Procedure WaitForEvent;
Var
    KeyPres     :Boolean;
Begin
    Repeat
        KeyPres:=BiosKeyPressed;
    Until (KeyPres) or (MouseButton=MsLeft) or (MouseButton=MsRight) or (MsLeftDoubleClick=True);


    IF KeyPres Then
    Begin
       ReadKbd(Ctrl,Ascii);
       MouseButton:=MouseButton and 0;
       Event:=0; {KeyBoard}
       KeyPres:=False;
    End
    Else
    Begin
        Ctrl:=#0;
        Ascii:=#0;
        KBScanCode:=0;
        KbAsciiCode:=0;
        Event:=1; {Mouse}
        KeyPres:=False;
    End;
End;

{*************************************************************************}
{Procedure InsertKbChar                                                   }
{Inserts an Ascii-Scan Code into the Keyboard Buffer.                     }
{*************************************************************************}

Procedure InsertKbChar(InChar :Word);
Begin
     Mem[$0040:$001a]:=$001E;
     Mem[$0040:$001c]:=$0020;
     Mem[$0040:$001E]:=InChar;
End;

{Ñ†õ†°ú™ ê¶¨´†§ú™}


{********************************************************************}
{Procdure SetClock                                                   }
{This routine Display the current time in to the XY position.        }
{********************************************************************}

Procedure SetClock(X,Y,TxtColor,BckColor :Byte);
Var
   Sec200       :Word;
Begin
    GetTime(Hours,Minutes,Seconds,Sec200);
    ClockX:=X;ClockY:=Y;
    ClockTxtColor:=TxtColor;
    ClockBckColor:=BckColor;

    HiddenMouseCursor;
    WriteChar(ClockX,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Hours/10));
    WriteChar(ClockX+1,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Hours mod 10));

    WriteChar(ClockX+2,ClockY,ClockTxtColor,ClockBckColor,Ord(':'));

    WriteChar(ClockX+3,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Minutes/10));
    WriteChar(ClockX+4,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Minutes mod 10));
    ShowMouseCursor;

    ShowClock:=True;
End;

{********************************************************************}
{Procedure SystemDelay                                               }
{Cristal dependent delayer.It executes 18.2 times every second in all}
{hardware systems (from the old XT 'till the new Fastest i486        }
{Every delay keeps 1/18.2 = 55ms                                     }
{********************************************************************}

Procedure CrystalDelay(DelayNum :Word);assembler;
Asm;
      cli
      mov ax,DelayNum
      mov SystemDelay,ax
      sti
 @Lo1:cmp SystemDelay,0
      jne @Lo1
End;

{*********************************************************************}
{Procedure RetraceDelay                                               }
{Another Delay type.RetrNum is the Counter number which it count the  }
{number of Horizontal retraces have done 'til now.                    }
{*********************************************************************}

Procedure RetraceDelay(RetrNum :Word);assembler;
Asm;
    mov cx,RetrNum
@OutLoop:
    mov ax,0040h
    mov es,ax
    mov dx,es:[0063h]
    add dx,6
    {Horizontal Retrace}
@L02:
    in al,dx
    test al,1
    jz @L02

@L03:
    in al,dx
    test al,1
    jnz @L03

    Loop @OutLoop

End;

Procedure VerticalRetrace;assembler;
Asm;
    push es
    push ax
    push dx

    mov ax,0040h
    mov es,ax
    mov dx,es:[0063h]   {Vertival Retrace}
    add dx,6
@L02:
    in al,dx
    test al,8
    jz @L02

@L03:
    in al,dx
    test al,8
    jnz @L03

    pop dx
    pop ax
    pop es
End;


Procedure HorizontalRetrace;assembler;
Asm;
    push es
    push ax
    push dx

    mov ax,0040h
    mov es,ax
    mov dx,es:[0063h]   {Horizontal Retrace}
    add dx,6
@L02:
    in al,dx
    test al,1
    jz @L02

@L03:
    in al,dx
    test al,1
    jnz @L03

    pop dx
    pop ax
    pop es
End;


{*************************************************************************}
{Procedure ScrollUp                                                       }
{ãú´ò≠ú®ú† ´ò ßú®†úÆ¶£ú§ò ´¶¨ ßò®òü¨®¶¨ òß¶ °ò´‡ ß®¶™ ´ò úßò§‡ ROW ö®ò££ú™}
{*************************************************************************}

Procedure ScrollUp(UX1,UY1,DX2,DY2,ROW,Col :byte);Assembler;
Asm;
   mov ah,6
   mov al,row
   mov bh,Col
   mov ch,UY1
   dec ch
   mov cl,UX1
   dec cl
   mov dh,DY2
   dec dh
   mov dl,DX2
   dec dl
   int 10h
End;

{*************************************************************************}
{Procedure ScrollDown                                                     }
{ãú´ò≠ú®ú† ´ò ßú®†úÆ¶£ú§ò ´¶¨ ßò®òü¨®¶¨ òß¶ ßò§‡ ß®¶™ ´ò °ò´‡  ROW ö®ò££ú™}
{*************************************************************************}

Procedure ScrollDown(UX1,UY1,DX2,DY2,ROW,Col :byte);assembler;
Asm;

   mov ah,7
   mov al,row
   mov bh,Col
   mov ch,UY1
   dec ch
   mov cl,UX1
   dec cl
   mov dh,DY2
   dec dh
   mov dl,DX2
   dec dl
   int 10h
End;

{*************************************************************}
{Function GrUpCase                                            }
{ãú´ò´®úßú† ´ò ú¢¢û§†°ò ö®ò££ò´ò ©ú °ú≠ò¢ò†ò                  }
{*************************************************************}

Function GrUpCase(CharIn :Byte) :Byte;
Const
    {¶† ò§´†©´¶†Æ¶† ú¢¢û§†°¶† °‡õ†°¶† ©ú ©Æú©û £ú ´¶ Äöö¢†°¶ ß¢û°´®¶¢¶ö†¶}
    {òß¶ 128 ú‡™ 174}
    GrVsEng1 :Array[1..48] Of Char =
          ('A','B','G','D','E','Z','H','U','I','K','L','M','N','J','O','P',
           'R','S','T','Y','F','X','C','V','a','b','g','d','e','z','h','u','i',
           'k','l','m','n','j','o','p','r','s','w','t','y','f','x','c');

    {¶† ò§´†©´¶†Æ¶† ú¢¢û§†°¶† °‡õ†°¶† ©ú ©Æú©û £ú ´¶ Äöö¢†°¶ ß¢û°´®¶¢¶ö†¶}
    {òß¶ 224 ú‡™ 233}
    GrVsEng2 :Array[1..10] Of Char =
          ('v','a','e','h','i','i','o','y','y','v');

Begin
    IF CharIn<128 then
    Begin
        CharIn:=0;
        GrUpCase:=CharIn;
        Exit;
    End;

    IF (CharIn>=128) and (CharIn<=175) Then
        CharIn:=Ord(GrVsEng1[CharIn-127])
    Else
    IF (CharIn>=224) and (CharIn<=233) Then
        CharIn:=Ord(GrVsEng2[CharIn-223])
    Else
        CharIn:=0;

    GrUpCase:=CharIn;
End;

Function GreekUpCase(C :Char) : Char;
Var
   C2   :Char;
Begin
    IF (Ord(C) >= 152) and (Ord(C) <=169) Then
       C2:=Char( Ord(C)-24 )
    Else
    Begin
        Case Ord(C) Of
          170 :C2:=Char(145);
          171 :C2:=Char(146);
          172 :C2:=Char(147);
          173 :C2:=Char(148);
          174 :C2:=Char(149);
          175 :C2:=Char(150);
          224 :C2:=Char(151);
          225 :C2:=Char(128);
          226 :C2:=Char(132);
          227 :C2:=Char(134);
          228 :C2:=Char(136);
          229 :C2:=Char(136);
          230 :C2:=Char(142);
          231 :C2:=Char(147);
          232 :C2:=Char(147);
          233 :C2:=Char(151);
          Else
             C2:=C;
        End;
    End;

    GreekUpCase:=C2;
End;

Function UpCaseString(S :String) :String;
Var
   I            :Byte;
   NewStr       :String;
   S1           :String[1];
Begin
    NewStr:='';
    For I:=1 to Length(S) do
    Begin
        S1:=Copy(S,I,1);
        IF Ord(S1[1]) >= 128 Then
           NewStr:=NewStr+GreekUpCase(S1[1])
        Else
           NewStr:=NewStr+UpCase(S1[1]);
    End;

    UpCaseString:=NewStr;
End;

{PALETTES}

Procedure RestorePalette;assembler;
asm;
        call VerticalRetrace
        mov ah,10h
        mov al,02h
        mov bx,ds
        mov es,bx
        mov dx,offset TextPalette
        int 10h

End;

Procedure SavePalette;assembler;
asm;
        call VerticalRetrace
        mov ah,10h
        mov al,09h
        mov bx,ds
        mov es,bx
        mov dx,offset TextPalette
        int 10h

End;


Procedure ChangePalette(SourceDac,DestDac :Byte);assembler;
asm;
        call VerticalRetrace
        mov ah,10h
        mov al,0
        mov bh,SourceDac
        mov bl,DestDac
        int 10h

End;

Procedure SetRGBColors(Var Pal :RGBType);assembler;
asm;
    call VerticalRetrace

    push ds

    mov dx,03c8h   {prepare for write}
    mov al,0
    out dx,al      {send the signal}
    mov cx,256    {cx = 256 DAC colors}
    mov dx,03c9h   {send data when ready}
    lds bx,Pal

@Lo1:
    mov al,[bx]
    out dx,al         {send R}

    inc bx
    mov al,[bx]
    out dx,al         {send G}

    inc bx
    mov al,[bx]
    out dx,al         {Send B}

    inc bx
    loop @lo1

    pop ds

End;

Procedure ReadRGBColors(Var Pal :RGBType);assembler;
asm;
    call VerticalRetrace

    push ds

    mov dx,03c7h   {prepare for write}
    mov al,0
    out dx,al      {send the signal}
    mov cx,256    {cx = 256 DAC colors}
    mov dx,03c9h   {send data when ready}
    lds bx,Pal

@Lo1:
    in  al,dx
    mov [bx],al {read R}

    inc bx
    in  al,dx
    mov [bx],al {Read G}

    inc bx
    in  al,dx
    mov [bx],al {Read B}

    inc bx
    loop @lo1

    pop ds

End;



{ê¶¨´†§ú™ ú¢úöÆ‡§}

{**********************************************************************}
{Function DosVer5                                                      }
{Ñß†©´ú≠ú† £ú©‡ ´û™ õ†ò°¶ßû™ 21h True úò§ úÆ¶¨£ú Dos >=5               }
{**********************************************************************}

Function DosVer5 :Boolean;
Var
   Major,SubVer :Byte;
   TraceVer     :String;
Begin
  Asm;
    mov ah,30h
    int 21h
    mov Major,al
    mov SubVer,ah
  End;
  IF Major >=5 Then
     DosVer5:=True
  Else
     DosVer5:=False;

  Str(Major,TraceVer);
  DosVer:=TraceVer+'.';
  Str(SubVer,TraceVer);
  DosVer:=DosVer+TraceVer;

End;

{*********************************************************************}
{Function MicroSoftWindows                                            }
{It checks to see if MicroSoft Windows in any version are active which}
{it means that we run MsDos program under windows shell.              }
{Returns True If Windows are active and False if not.                 }
{*********************************************************************}

Function MicroSoftWindows :Boolean;
Var
   State        :Word;
Begin
    Asm
       mov ax,1600h
       int 2Fh
       mov State,ax
    End;

    MicroSoftWindows:=False;

    Case (Lo(State)) Of
      $01,
      $FF  :MicroSoftWindows:=True;
      $00,
      $80  :Begin
              Asm
                 mov ax,4680h
                 int 2Fh
                 mov State,ax
              End;

              IF Lo(State) = $80 Then
                 MicroSoftWindows:=False
              Else
                 MicroSoftWindows:=True;
            End;
      Else
            MicroSoftWindows:=True;
    End;
End;

{***************************************************************}
{Function :GetProz                                              }
{Returns the processor number installed in the tested machine   }
{    i8088              = 0;                                    }
{    i8086              = 1;                                    }
{    NEC_V20            = 2;                                    }
{    NEC_V30            = 3;                                    }
{    i80188             = 4;                                    }
{    i80186             = 5;                                    }
{    i286               = 6;                                    }
{    i386               = 7;                                    }
{    i486               = 8;                                    }
{***************************************************************}

{$F+}
Function   GetProz :Integer;External;
{$F-}

{***************************************************************}
{Function :GetCo                                                }
{Returns the co-processor number installed in the tested machine}
{    No_Coprocessor     = 0;                                    }
{    i8087              = 1;                                    }
{    i80287             = 2;                                    }
{    i80387_80487       = 3;                                    }
{***************************************************************}

{$F+}
Function   GetCo   :Integer;External;
{$F-}

Procedure SetPreferences;
Var
   Processor    :Integer;
Begin

     SetBiosKeybRate(0,0);

     Processor:=GetProz;

     Case Processor of
      i8088,
      i8086,
      NEC_V20,
      NEC_V30,
      i80188,
      i80186   :Begin
                  ProDelay1:=200;
                  ProDelay2:=100;
                  ProDelay3:=50;
                  ProDelay4:=50;
                  ProDelay5:=5;
                  WindowDelay:=0;
                End;
      i286     :Begin
                  ProDelay1:=2000;
                  ProDelay2:=1000;
                  ProDelay3:=500;
                  ProDelay4:=300;
                  ProDelay5:=100;
                  WindowDelay:=10;
                End;
      i386     :Begin
                  ProDelay1:=4000;
                  ProDelay2:=2000;
                  ProDelay3:=1000;
                  ProDelay4:=400;
                  ProDelay5:=200;
                  WindowDelay:=10;
                End;
      i486     :Begin
                  ProDelay1:=5000;
                  ProDelay2:=2000;
                  ProDelay3:=1300;
                  ProDelay4:=500;
                  ProDelay5:=50;
                  WindowDelay:=50;
                End;
      End;
End;

Procedure CheckLength(Var Str :String;X1,X2 :Byte);
Begin
    IF (Length(Str)+X1)-1 > X2 Then
       Str:=Copy(Str,1,(X2-X1)+1)
    Else
       Str:=Str;
End;


BEGIN

END.