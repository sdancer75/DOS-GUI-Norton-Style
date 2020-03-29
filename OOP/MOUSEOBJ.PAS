{=======================================================================}
{Programmer :George Papaioannoy     1992 Thessaloniki                   }
{This is the MOUSE unit for Turbo Pascal 6.0                            }
{Warning :It works only in 80x25 text mode                              }
{=======================================================================}

UNIT MouseObj;

INTERFACE

Uses VarConstObj,Dos,Crt;
Type

    MouseArrayType = array[1..16] of byte;

    const

      VgaMouse        :Boolean = False;

      msIDLE          =   0;
      msLEFT          =   1;
      msRIGHT         =   2;
      msCENTER        =   4;

      FreeForControl         :Byte    = 0;
      MsLeftDoubleClick      :Boolean = False;

      UserDoubleClickTimer   :Byte    = 5; {5/18 of Second}
      DoubleClickTimer       :Byte    = 0;

      UserInterrupt          :Boolean =False; {Flag for User Interrupt For $1C}
      UserTimerInterruptPtr  :Pointer = Nil; {Here is the Actual Code}


      {Ž  ascii ®˜¨˜¡«ž¨œª §¦¬ Ÿ˜ ®¨ž© £¦§¦ žŸ¦¬¤ š ˜ «¦ §¦¤« ¡ }

      MouseChar1     =   241;
      MouseChar2     =   242;
      MouseChar3     =   243;
      MouseChar4     =   244;

      MouseArray : MouseArrayType =
                   ( ( 0 ),
                     ( 64 ),
                     ( 64+32 ),
                     ( 64+32+16 ),
                     ( 64+32+16+8 ),
                     ( 64+32+16+8+4 ),
                     ( 64+32+16+8+4+2 ),
                     ( 64+32+16+8+4+2 ),
                     ( 64+32+16+8 ),
                     ( 64+8+4 ),
                     ( 8+4 ),
                     ( 4 ),
                     ( 4+2 ),
                     ( 4+2 ),
                     ( 0 ),
                     ( 0 ) );

       {You can also use the bigger mouse shape 8x16 by replacing MouseArray}
       {const variable with the follow values.                              }
       { 128,192,224,240,248,252,254,255,252,216,12,12,6,6,3,0              }

             Procedure MouseInit;
             Procedure ShowMouseCursor;
             Procedure HiddenMouseCursor;
             Procedure GetMousePosition;
             Procedure GetVirtualMousePosition;
             Procedure SetMousePosition(X1,Y1 :Word);
             Procedure SetVgaMousePosition(X1,Y1 :Byte);
             Procedure DetermineMouseMovementValues;
             Procedure GetMousePressInfo(Button :Word);
             Procedure GetMouseReleaseInfo(Button :Word);
             Procedure SetMouseMinMaxX(X1,X2 :word);
             Procedure SetMouseMinMaxY(Y1,Y2 :word);
             Procedure DefineMouseTextCursor(Select,Specify1,Specify2 :Word);
             Procedure MouseSensitivity(Horiz,Vertic :Word);
             Procedure ConMouseHidden(Up1,Left1,Down1,Right1 :word);
             Procedure PcMouse;
             Procedure MicroSoftMouse;
             Procedure InstallMouseEvent(Seg1,Ofs1     :Integer);
             Procedure DisableMouseDriver;
             Procedure EnableMouseDriver;
             Procedure MouseDone;
             Procedure ResetVgaMouse;


             Procedure GetFontAccess;
             Procedure ReleaseFontAccess;

    type
      BitplaneFontMatrix = array[1..32] of byte;
      BitplaneFontArray = array[0..255] of BitplaneFontMatrix;

var
    MouseX,MouseY :Word;
    InterMX,
    InterMY       :Word;
    Status        :Integer;
    NumberBut     :Word;
    PressNum      :Word;
    ReleaseNum    :Word;
    ReturnV       :Byte;


    MouseCondition : Boolean;
    MouseShown     : Boolean;
    MouseButton    : Word;
    OldMouseButton : Word;
    MouseMoved     : Boolean;
    InternalX,
    InternalY      : Integer;
    MoveHoriz,
    MoveVert       : Integer;
    MouseXMax,
    MouseYMax      : Word;
    MouseXMin,
    MouseYMin      :Word;

    OldMouseEventSeg,
    OldMouseEventOfs  : Word;
    OldMouseEventMask : Word;
    MouseMapUp        : Word;
    MouseMapDn        : Word;
    BitplaneFont      : BitplaneFontArray absolute $A000:0000;

    MsFlags           :Word;

    Old1CInt          :Pointer;


IMPLEMENTATION

{$L C:\bp7\obj\MousePA}
{$F+}                                                  { FAR function }
Procedure AssmHand; external ;              { Assembler event handler }
{$F-}                            { FAR functions no longer accessible }

Procedure GetFontAccess;
Begin
       Asm CLI End;
{       portw[ $3C4 ] := $0300;} {out}
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;
  {     portw[ $3C4 ] := $0300; }{out}

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006; {0406}
       Asm STI End;
End;

Procedure ReleaseFontAccess;
Begin
       Asm; CLI End;
{       portw[ $3C4 ] := $0300;} {out}
       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;
{       portw[ $3C4 ] := $0300;} {out}

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm; STI End;
End;

Procedure WriteMouseChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);assembler;
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

@Cont:
     mov es:[si],ah
     mov es:[si+1],al

@OutOfScreen:
End;



{********************************************************************}
{Procedure DoubleClicksTimer                                         }
{Interrupt 1Ch handler.It used for mouse double click timer and      }
{for delay counter.                                                  }
{********************************************************************}

{$F+}
Procedure DoubleClicksTimer; Interrupt;
Begin
    IF DoubleClickTimer > 0 Then
       Dec(DoubleClickTimer);

    IF SystemDelay > 0  Then
       Dec(SystemDelay);

    IF ShowClock = True Then
    Begin
        Inc(Ticks);
        IF Ticks = 18 Then
        Begin
           Inc(Seconds);
           Ticks:=0;
           IF Seconds = 60 Then
           Begin
             Inc(Minutes);
             Seconds:=0;
             IF Minutes = 60 Then
             Begin
               Inc(Hours);
               Minutes:=0;
               IF Hours = 24 Then
                  Hours:=0;
             End;
             HiddenMouseCursor;
             WriteMouseChar(ClockX,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Hours/10));
             WriteMouseChar(ClockX+1,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Hours mod 10));

             WriteMouseChar(ClockX+2,ClockY,ClockTxtColor,ClockBckColor,Ord(':'));

             WriteMouseChar(ClockX+3,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Minutes/10));
             WriteMouseChar(ClockX+4,ClockY,ClockTxtColor,ClockBckColor,48+Trunc(Minutes mod 10));
             ShowMouseCursor;
           End;
        End;
    End;

    IF UserInterrupt Then
    Begin
        Asm;
           call UserTimerInterruptPtr
        End;
    End;

    Asm;
        pushf
        call Old1CInt
    End;

End;
{$F-}

Procedure MouEventHandler( EvFlags, ButState, Horiz, Vert: Integer );
Var
  RestX,RestY,I,J: byte;
  LU,RU,
  LD,RD          : BitplaneFontMatrix;
  ScreenWidth    : Byte;
Begin
       IF FreeForControl<>0 Then
          Exit;


       IF (EvFlags and 1 = 1) and (VgaMouse=True)  and (FreeForControl=0) Then
       Begin
          asm CLI end;
          MsFlags:=EvFlags;
          EvFlags := EvFlags xor 1;
          ScreenWidth:=(BiosColumns div 2);


          IF MouseShown then
          Begin
             mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] := hi(MouseMapUp);
             mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ] := lo(MouseMapUp);

             mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] := hi(MouseMapDn);
             mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ] := lo(MouseMapDn);
          End;

          MouseMoved := True;

          InternalX := InternalX + (Horiz - MoveHoriz);
          InternalY := InternalY + (Vert - MoveVert);
          MoveHoriz := Horiz;
          MoveVert := Vert;
          IF InternalX < MouseXMin then InternalX := MouseXMin;
          IF InternalX > MouseXMax then InternalX := MouseXMax;
          IF InternalY < MouseYMin then InternalY := MouseYMin;
          IF InternalY > MouseYMax then InternalY := MouseYMax;

          InterMX := InternalX shr 3;
          InterMY := InternalY shr 3;

          IF MouseShown then
          Begin
             MouseMapUp := mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] shl 8 +
                           mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ];
             MouseMapDn := mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] shl 8 +
                           mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ];


             GetFontAccess;
             LU := BitplaneFont[ hi(MouseMapUp) ];
             LD := BitplaneFont[ hi(MouseMapDn) ];
             RU := BitplaneFont[ lo(MouseMapUp) ];
             RD := BitplaneFont[ lo(MouseMapDn) ];
             ReleaseFontAccess;

             RestX := InternalX mod 8;
             IF RestX = 0 then InternalX := InterMX shl 3;
             RestY := (InternalY mod 8) shl 1;
             IF RestY = 0 then InternalY := InterMY shl 3;


             J := 1;
             For I := RestY+1 to 16 do
             Begin
                LU[I] := LU[I] or (MouseArray[J] shr RestX);
                RU[I] := RU[I] or (255 and (MouseArray[J] shl (8-RestX)));
                Inc( J );
             End;

             For I := 1 to RestY do
             Begin
                LD[I] := LD[I] or (MouseArray[J] shr RestX);
                RD[I] := RD[I] or (255 and (MouseArray[J] shl (8-RestX)));
                inc( J );
             End;

             GetFontAccess;
             BitplaneFont[ MouseChar1 ] := LU;
             BitplaneFont[ MouseChar2 ] := RU;
             BitplaneFont[ MouseChar3 ] := LD;
             BitplaneFont[ MouseChar4 ] := RD;
             ReleaseFontAccess;

             mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] := MouseChar1;
             mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ] := MouseChar2;
             mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] := MouseChar3;
             mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ] := MouseChar4;
          End;
          asm STI end;
          MouseX:=InterMX+1;
          MouseY:=InterMY+1;
       End
       Else
       IF (EvFlags and 1 = 1) and (VgaMouse=False) then
          GetMousePosition;

       MouseButton:=ButState;
       MsLeftDoubleClick:=False;

       IF ((MouseButton and msLEFT) = 0) and ((OldMouseButton and msLEFT) = msLEFT) Then
       Begin
          IF DoubleClickTimer > 0 Then
          Begin
             msLeftDoubleClick:=True;
             DoubleClickTimer:=0;
          End
          Else
          Begin
             msLeftDoubleClick:=False;
             DoubleClickTimer:=UserDoubleClickTimer;
          End;
          OldMouseButton:=ButState;
       End;

       IF (MouseButton and msLEFT) = msLEFT Then
          OldMouseButton:=ButState;
End;

Procedure MouButEventHandler( EvFlags, ButState, Horiz, Vert: Integer );
Begin
    MouseButton:=ButState;
End;

Procedure ReCallOldMouseEvent; assembler;
Asm;
   cmp  MouseCondition,False
   je   @1

   push ax
   push cx
   push dx

   push es

   mov  ax,0Ch
   mov  cx,OldMouseEventMask
   mov  es,OldMouseEventSeg
   mov  dx,OldMouseEventOfs
   int  33h

   pop es

   pop dx
   pop cx
   pop ax
@1:
End;



{================================================}
{Check whether the mouse installed or not}
{Successful return -1,Fail Return 0}
{OutPut :Status,NumberBut}

Procedure MouseInit;
Var
    HandlePtr          : Pointer;
Begin
  MouseShown := False;
  HandlePtr := @AssmHand;

  GetIntVec($1C,Old1CInt);
  SetIntVec($1C,@DoubleClicksTimer);

  Asm;
   push ax
   push bx
   push dx
   push cx

   push es

   mov ax,0
   int 33h
   mov status,ax
   mov NumberBut,bx
   cmp ax,0
   Je  @2

   cmp  VgaMouse,True
   jne  @1

   mov  ax,07h
   mov  cx,0
   mov  dx,MouseXMax
   int  33h

   mov  ax,08h
   mov  cx,0
   mov  dx,MouseYMax
   int  33h
@1:
   MOV  AX,14h
   MOV  CX,255
   mov  dx,seg HandlePtr
   mov  es,dx
   les  dx,HandlePtr
   INT  33h

   mov  OldMouseEventMask,CX
   mov  OldMouseEventSeg,es
   mov  OldMouseEventOfs,dx

   mov  al,True
   mov  MouseCondition,al
@2:
   pop es

   pop cx
   pop dx
   pop bx
   pop ax
  End;
  SetMousePosition(1,1);
End;

{================================================================}
{This function is used to show the Cursor in the current Position}

Procedure ShowMouseCursor;
Var
   RestX,RestY,I,J : byte;
   LU,RU,
   LD,RD           : BitplaneFontMatrix;
   ScreenWidth     : Byte;
Begin
  IF FreeForControl=1 Then
     Exit;

  IF VgaMouse Then
  Begin
       IF (MouseCondition) and (MouseShown=False) then
       begin
          asm CLI end;
          FreeForControl:=1;
          MouseShown:=True;

          ScreenWidth:=(BiosColumns div 2);

          MouseMapUp := mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] shl 8 +
                        mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ];
          MouseMapDn := mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] shl 8 +
                        mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ];

          GetFontAccess;
          LU := BitplaneFont[ hi(MouseMapUp) ];
          LD := BitplaneFont[ hi(MouseMapDn) ];
          RU := BitplaneFont[ lo(MouseMapUp) ];
          RD := BitplaneFont[ lo(MouseMapDn) ];
          ReleaseFontAccess;

          RestX := InternalX mod 8;
          if RestX = 0 then InternalX := InterMX shl 3;
          RestY := (InternalY mod 8) shl 1;
          if RestY = 0 then InternalY := InterMY shl 3;

          J := 1;
          For I := RestY+1 to 16 do
          Begin
                LU[I] := LU[I] or (MouseArray[J] shr RestX);
                RU[I] := RU[I] or (255 and (MouseArray[J] shl (8-RestX)));
                Inc( J );
          End;

          For I := 1 to RestY do
          Begin
                LD[I] := LD[I] or (MouseArray[J] shr RestX);
                RD[I] := RD[I] or (255 and (MouseArray[J] shl (8-RestX)));
                inc( J );
          End;


          GetFontAccess;
          BitplaneFont[ MouseChar1 ] := LU;
          BitplaneFont[ MouseChar2 ] := RU;
          BitplaneFont[ MouseChar3 ] := LD;
          BitplaneFont[ MouseChar4 ] := RD;
          ReleaseFontAccess;

          mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] := MouseChar1;
          mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ] := MouseChar2;
          mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] := MouseChar3;
          mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ] := MouseChar4;

          asm
             STI
          end;
          FreeForControl:=0;
       End;
  End
  Else
    Asm;
     push ax

     mov ax,1
     int 33h

     pop ax
  End;
End;


{=======================================================}
{This Function removes cursor from the screen}

Procedure HiddenMouseCursor;
Var
   RestX,RestY,I,J : byte;
   LU,RU,
   LD,RD           : BitplaneFontMatrix;
   ScreenWidth     : Byte;
Begin
  IF FreeForControl=1 Then
     Exit;

  IF VgaMouse Then
  Begin
       IF (MouseCondition) and (MouseShown=True) then
       Begin
          FreeForControl:=1;
          asm CLI end;
          MouseShown:=False;

          ScreenWidth:=(BiosColumns shr 1);

          mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 ] := hi(MouseMapUp);
          mem[ $B800 : (ScreenWidth*InterMY+InterMX) shl 1 + 2 ] := lo(MouseMapUp);

          mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 ] := hi(MouseMapDn);
          mem[ $B800 : (ScreenWidth*(InterMY+1)+InterMX) shl 1 + 2 ] := lo(MouseMapDn);
          asm
             STI
          end;
          FreeForControl:=0;
       End;
  End
  Else
    Asm;
       push ax

       mov ax,2
       int 33h

       pop ax
    End;
End;

{=======================================================}
{Get mouse position and Button status}
{OutPut :X,Y,Buttons}
{Buttons 1:First Butt,2:Second Butt,3:Third Butt - 0 No butt pressed}
{This function refers for 80x25 text mode}

Procedure GetMousePosition;

Procedure GetPosit;assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   cmp  MouseCondition,False
   je   @1

   mov ax,3
   int 33h
   mov MouseX,cx
   mov MouseY,dx
   mov MouseButton,bx
@1:
   pop cx
   pop dx
   pop bx
   pop ax
End;

Begin
   IF MouseCondition Then
   Begin
     GetPosit;
     MouseX:=round(MouseX/8);
     MouseY:=round(MouseY/FontHeight);
     inc(MouseX);
     inc(MouseY);
   End;
End;

Procedure GetVirtualMousePosition; assembler;
asm;
   push ax
   push bx
   push cx
   push dx

   cmp  MouseCondition,False
   je   @1
   mov  ax,0003h
   int  33h
   mov  InternalX,cx
   mov  InternalY,dx
   mov  MoveHoriz,cx
   mov  MoveVert,dx

   shr  cx,1
   shr  cx,1
   shr  cx,1

   shr  dx,1
   shr  dx,1
   shr  dx,1

   mov  InterMX,cx
   mov  InterMY,dx

@1:pop dx
   pop cx
   pop bx
   pop ax

End;

{==========================================================}
{Set mouse Cursor position}

Procedure SetMousePosition(X1,Y1 :Word);

Procedure SetPosit(X2,Y2 :Word);assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   cmp  MouseCondition,False
   je   @1

   mov ax,4
   mov cx,x2
   mov dx,y2
   int 33h

@1:
   pop cx
   pop dx
   pop bx
   pop ax
End;

Begin
   IF MouseCondition Then
   Begin
     dec(x1);
     dec(y1);
     X1:=X1*8;
     Y1:=Y1*8;
     SetPosit(X1,Y1);
   End;
End;

Procedure DetermineMouseMovementValues;assembler;
Asm;
   push ax
   push cx
   push dx

   mov ax,0bh
   int 33h
   mov InterMX,cx
   mov InterMY,dx

   pop dx
   pop cx
   pop ax
End;

{***********************************************************************}
{Procedure SetVgaMousePosition                                          }
{***********************************************************************}

Procedure SetVgaMousePosition(X1,Y1 :Byte);
Var
  RestX,RestY   :Byte;
Procedure SetPosit(X2,Y2 :Word);assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   cmp  MouseCondition,False
   je   @1

   mov ax,4
   mov cx,x2
   mov dx,y2
   int 33h

@1:
   pop cx
   pop dx
   pop bx
   pop ax
End;
Begin
   IF (MouseCondition) and (VgaMouse) Then
   Begin
     Dec(X1);
     Dec(Y1);
     HiddenMouseCursor;
     RestX:=InternalX mod 8;
     RestY:=(InternalY mod 8);
     InterMX:=X1;
     InterMY:=Y1;
     MoveHoriz:=X1 shl 3;
     MoveVert:=Y1 shl 3;
     InternalX:=MoveHoriz+RestX;
     InternalY:=MoveVert+RestY;
     MoveHoriz:=InternalX;
     MoveVert:=InternalY;
     ShowMouseCursor;
   End
    Else
      SetMousePosition(X1,Y1);

End;

{=============================================================}
{Get mouse Press informations}
{OutPut :Buttons (Similarly with the function 3),PressNum (How many- }
{times we pressed one butt), X , Y)}

Procedure GetMousePressInfo(Button :Word);

Procedure GetPressInfoAsm(Button2 :word);assembler;
asm;

    push ax
    push bx
    push dx
    push cx

    mov ax,5
    mov bx,button2
    int 33h
    mov MouseButton,ax
    mov PressNum,bx
    mov MouseX,cx
    mov MouseY,dx

   pop cx
   pop dx
   pop bx
   pop ax
End;

Begin
   IF MouseCondition Then
   Begin
     GetPressInfoAsm(Button);

     MouseX:=round(MouseX/8);
     MouseY:=round(MouseY/8);
     Inc(MouseX);
     Inc(MouseY);
   End;
End;

{===================================================================}
{Get Button Release info}
{OutPut: Buttons,ReleaseNum,X,Y}

Procedure GetMouseReleaseInfo(Button :Word);

Procedure GetReleaseInfoAsm(Button2 :word);assembler;
asm;

    push ax
    push bx
    push dx
    push cx

    mov ax,6
    mov bx,Button2
    int 33h
    mov MouseButton,ax
    mov ReleaseNum,bx
    mov Button2,cx
    mov Button2,dx

    pop cx
    pop dx
    pop bx
    pop ax
End;
Begin
   IF MouseCondition Then
   Begin
     GetReleaseInfoAsm(Button);

     MouseX:=Round(MouseX/8);
     MouseY:=Round(MouseY/8);
     Inc(MouseX);
     Inc(MouseY);
   End;
End;

{================================================================}
{Set Min & Max X position}

Procedure SetMouseMinMaxX(X1,X2 :word);

Procedure SetMinMaxXAsm(X1B,X2B :Word);assembler;
asm;
    push ax
    push bx
    push dx
    push cx

    mov ax,7
    mov cx,x1b
    mov dx,x2b
    int 33h

    pop cx
    pop dx
    pop bx
    pop ax
End;

Begin
   IF (MouseCondition) and (VgaMouse) Then
   Begin
     Dec(X1);
     Dec(X2);
     MouseXMin:=X1 shl 3;
     MouseXMax:=X2 shl 3;
   End
   Else
   Begin
     Dec(x1);
     Dec(x2);
     X1:=X1*8;
     X2:=X2*8;
     SetMinMaxXAsm(X1,X2);
   End;
End;

{================================================================}
{Set Min & Max Y position}

Procedure SetMouseMinMaxY(Y1,Y2 :word);

Procedure SetMinMaxYAsm(Y1B,Y2B :Word);assembler;
asm;

    push ax
    push bx
    push dx
    push cx

    mov ax,8
    mov cx,y1b
    mov dx,y2b
    int 33h

    pop cx
    pop dx
    pop bx
    pop ax
End;

Begin
   IF (MouseCondition) and (VgaMouse) Then
   Begin
     Dec(Y1);
     Dec(Y2);
     MouseYMin:=Y1 shl 3;
     MouseYMax:=Y2 shl 3;
   End
   Else
   Begin
     Dec(Y1);
     Dec(Y2);
     Y1:=Y1*8;
     Y2:=Y2*8;
     SetMinMaxYAsm(Y1,Y2);
   End;
End;

{=================================================================}
{Define text Cursor}

Procedure DefineMouseTextCursor(Select,Specify1,Specify2 :Word);assembler;
asm;
    push ax
    push bx
    push dx
    push cx

    cmp MouseCondition,False
    Je  @1
    mov ax,10
    mov bx,Select
    mov cx,Specify1
    mov dx,Specify2
    int 33h
@1:
    pop cx
    pop dx
    pop bx
    pop ax
End;

{=================================================================}
{Define Sensitivity}

Procedure MouseSensitivity(Horiz,Vertic :Word);assembler;
asm;
    push ax
    push bx
    push dx
    push cx

    cmp MouseCondition,False
    Je  @1
    mov ax,15
    mov cx,horiz
    mov dx,vertic
    int 33h
@1:
    pop cx
    pop dx
    pop bx
    pop ax
End;

{=================================================================}
{Conditional hidden cursor}

Procedure ConMouseHidden(Up1,Left1,Down1,Right1 :word);

Procedure ConHiddenAsm(Up,Left,Down,Right :Word);assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   push si
   push di

   mov ax,16
   mov dx,Up
   mov cx,Left
   mov di,Down
   mov si,Right
   int 33h

   pop di
   pop si

   pop cx
   pop dx
   pop bx
   pop ax
End;

Begin
     dec(Up1);
     dec(Left1);
     dec(Down1);
     dec(Right1);

     Up1:=Up1*8;
     Left1:=Left1*8;
     Down1:=Down1*8;
     Right1:=Right1*8;

     ConHiddenAsm(Up1,Left1,Down1,Right1);
End;


{==================================================================}
{To Work in Pc Mouse Mode}
{OutPut :Status (FAh=success,FEh=fail}

Procedure PcMouse;assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   mov ax,17
   int 33h
   mov Status,ax

   pop cx
   pop dx
   pop bx
   pop ax
End;

{==================================================================}
{To Work in MIcroSoft Mouse Mode}
{OutPut :Status (FAh=success,FEh=fail}

Procedure MicroSoftMouse;assembler;
asm;
   push ax
   push bx
   push dx
   push cx

   mov ax,18
   int 33h
   mov Status,ax

   pop cx
   pop dx
   pop bx
   pop ax
End;

Procedure InstallMouseEvent(Seg1,Ofs1     :Integer);assembler;
asm;
   push ax
   push cx
   push dx
   push es

   mov ax,0Ch
   mov cx,000Fh
   mov es,seg1
   mov dx,ofs1
   int 33h

   pop es
   pop dx
   pop cx
   pop ax
End;

Procedure DisableMouseDriver;assembler;
asm;
    push ax

    mov ax,1Fh
    int 33h

    pop ax
End;

Procedure EnableMouseDriver;assembler;
asm;
    push ax

    mov ax,20h
    int 33h

    pop ax
End;

Procedure MouseDone;
Begin
    HiddenMouseCursor;
    ReCallOldMouseEvent;
    SetIntVec($1C,Old1CInt);
End;

Procedure ResetVgaMouse;
Begin
   DetermineMouseMovementValues;

   MouseMoved     := False;
   MouseShown     := False;
   MouseButton    := msIDLE;
   OldMouseButton := msIDLE;
   MoveHoriz      := 0;
   MoveVert       := 0;
   InternalX      := 0;
   InternalY      := 0;
   MouseX         := 1;
   MouseY         := 1;
   InterMX        := 0;
   InterMY        := 0;
   MouseMapUp     := 0;
   MouseMapDn     := 0;
End;

Begin

   MouseCondition := False;
   MouseMoved     := False;
   MouseShown     := False;
   MouseButton    := msIDLE;
   OldMouseButton := msIDLE;
   MoveHoriz      := 0;
   MoveVert       := 0;
   InternalX      := 0;
   InternalY      := 0;
   MouseX         := 1; {It MUST start from this Value}
   MouseY         := 1; {It MUST Start from this Value}
   InterMX        := 0;
   InterMY        := 0;
   MouseMapUp     := 0;
   MouseMapDn     := 0;

   MouseXMax      := 633;
   MouseYMax      := 198;
   MouseXMin      := 0;
   MouseYMin      := 0;

END.