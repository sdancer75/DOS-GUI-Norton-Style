{*************************************************************************}
{UNIT SavRstObj                                                           }
{FileName :SavRstOb.Pas                                                   }
{èú®†úÆú† ´†™ ®¶¨´†§ú™ ö†ò ©‡©†£¶ ö†ò ú£≠ò§†©û °ò† ò§ò°´û©û £†ò™ ßú®†¶Æû™ }
{ï®û©†£¶ß¶†¶¨§´ò† ôò©†°ò ©´ò ßò®òü¨®ò.                                    }
{Ä¨´¶ ´¶ unit Æ®û©†£¶ß¶†û´ò† ©ú ©¨§õ†ò©£¶ £ú úß¶£ú§ò objects              }
{*************************************************************************}


UNIT SAVRSTOBJ;

INTERFACE
Uses VarConstObj,ErrorDlg;

Type
    PWinBasics=^WinBasics;
    WinBasics = object
       BX1,BY1,BX2,BY2    :Byte;
       WinSize            :Word;
       SnapShot           :^ScreenImage;
       Procedure Init(InX1,InY1,InX2,InY2 :Byte);
       Procedure SaveArea(InX1,InY1,InX2,InY2 :Byte);
       Procedure ShowArea;
       Procedure ShowPart(InX1,InY1,InX2,InY2 :Byte);
       Procedure ShowPartAndColor(InX1,InY1,InX2,InY2,InColor :Byte);
       Procedure SavePart(InX1,InY1,InX2,InY2 :Byte);
       Procedure MoveData(InX1,InY1,InX2,InY2,ToX1,ToY1 :Byte);
       Procedure RestoreArea;
    End;


IMPLEMENTATION


{************************************************************************}
{Procedure WinBasics.Init                                                }
{ò®Æ†°¶ß¶†û©û ´‡§ £ú´òô¢û´‡§ :úßò§‡ ò®†©´ú®û™ ö‡§†ò™,°ò´‡ õú•†ò™ ö‡§†ò™  }
{°ò† ´¶§ õú†°´û ¶ß¶¨ ©‡ù¶¨£ú ´ò õúõ¶£ú§ò                                 }
{************************************************************************}

Procedure WinBasics.Init;
Begin
    BX1:=InX1;BY1:=InY1;
    BX2:=InX2;BY2:=InY2;
    SnapShot:=Nil
End;

{**************************************************************************}
{Procedure WinBasics.SaveArea                                              }
{ë‡ù¶¨£ú ú§ò °¶£ò´† ´û™ £§û£û™ ©´û§ õ†ú¨ü¨§©û ´¶¨ SnapShot.è®úßú† ß®¶û-    }
{ö¶¨£ú§¶™ §ò úÆ¶¨£ú °ò§ú† New.A≠¶¨ ô®¶¨£ú ´¶ segment °ò† ´¶ offset ´¶¨     }
{SnapShot ò¢¢òù¶¨£ú ©¨§úÆ‡™ ´¶§ Es £†ò ≠¶®ò £ú VideoSeg °ò† £†ò £ú SnapShotSeg}
{**************************************************************************}

Procedure WinBasics.SaveArea;
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceX1                 :Word;
Begin
    WinBasics.Init(InX1,InY1,InX2,InY2);

    TraceX:=BX1-1;
    TraceX1:=BX1-1;
    TraceY:=BY1-1;

    XSize:=(InX2-InX1)+1;
    XSize:=XSize*2;
    YSize:=(InY2-InY1)+1;
    WinSize:=YSize * XSize;

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;

    SnapShot:=EdsGetMem(SnapShot,WinSize);
    IF HeapErrorCode=0 Then
    Begin

      Dec(Bx1);
      Dec(Bx2);
      Dec(By1);
      Dec(By2);

      StartX:=(BY1*BiosColumns)+(2*BX1);
      XSize:=(BX2-BX1)+1;
      YSize:=(BY2-BY1)+1;


      Offs:=Ofs(SnapShot^);
      Segment:=Seg(SnapShot^);


      Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es



        mov Si,StartX

        mov di,Offs
        mov cx,YSize

@ChangeY:
          push cx

          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja   @CancelXLoop

          xor  ax,ax
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja   @CancelXLoop


          mov  Cx,XSize

@ChangeX:

          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec ax
          cmp TraceX,ax
          ja @NoPrint

          mov ax,VideoSeg
          mov es,ax
          mov bx,es:[si]

          mov ax,Segment
          mov es,ax
          mov es:[di],bx
@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX
          mov ax,TraceX1
          mov TraceX,ax
          inc TraceY

          pop cx
          loop @ChangeY
@CancelXLoop:
          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

      End;



      Inc(Bx1);
      Inc(Bx2);
      Inc(By1);
      Inc(By2);
    End;
End;

Procedure WinBasics.ShowArea;
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
Begin
  IF SnapShot<>Nil Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;


    Dec(Bx1);
    Dec(Bx2);
    Dec(By1);
    Dec(By2);

    StartX:=(BY1*BiosColumns)+(2*BX1);
    XSize:=(BX2-BX1)+1;
    YSize:=(BY2-BY1)+1;
    TraceX:=BX1;
    TraceY:=BY1;
    TraceBX1:=BX1;

    Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es


        mov si,StartX

        mov di,Offs

        mov cx,YSize

@ChangeY:
          push cx
          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          xor  ax,ax
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec ax
          cmp TraceX,ax
          ja @NoPrint

          mov ax,Segment
          mov es,ax
          mov bx,es:[di]

          mov ax,VideoSeg
          mov es,ax
          mov es:[si],bx
@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

          pop cx
          loop @ChangeY

          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

    End;

    Inc(Bx1);
    Inc(Bx2);
    Inc(By1);
    Inc(By2);
  End;

End;

Procedure WinBasics.ShowPart(InX1,InY1,InX2,InY2 :Byte);
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
    XDataSize,
    StartDataX              :Word;
Begin
  IF SnapShot<>Nil Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;


    Dec(InX1);
    Dec(InX2);
    Dec(InY1);
    Dec(InY2);

    Dec(BX1);
    Dec(BX2);
    Dec(BY1);
    Dec(BY2);


    XDataSize:=(BX2-BX1)+1;
    XDataSize:=XDataSize shl 1;
    StartDataX:=((InY1-BY1)*XDataSize)+(2*(InX1-BX1));

    StartX:=(InY1*BiosColumns)+(2*InX1);
    XSize:=(InX2-InX1)+1;
    YSize:=(InY2-InY1)+1;
    TraceX:=InX1;
    TraceY:=InY1;
    TraceBX1:=InX1;

    Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es


        mov si,StartX

        mov di,Offs
        add di,StartDataX

        mov cx,YSize

@ChangeY:
          push cx

          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          xor  ax,ax
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec ax
          cmp TraceX,ax
          ja @NoPrint

          mov ax,Segment
          mov es,ax
          mov bx,es:[di]

          mov ax,VideoSeg
          mov es,ax
          mov es:[si],bx
@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax

          mov ax,XDataSize
          add StartDataX,ax
          mov di,Offs
          add di,StartDataX

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

          pop cx
          loop @ChangeY

          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

    End;

    Inc(Bx1);
    Inc(Bx2);
    Inc(By1);
    Inc(By2);
  End;

End;

Procedure WinBasics.ShowPartAndColor(InX1,InY1,InX2,InY2,InColor:Byte);
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
    XDataSize,
    StartDataX              :Word;
Begin
  IF SnapShot<>Nil Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;


    Dec(InX1);
    Dec(InY1);
    Dec(InX2);
    Dec(InY2);

    Dec(BX1);
    Dec(BX2);
    Dec(BY1);
    Dec(BY2);

    XDataSize:=(BX2-BX1)+1;
    XDataSize:=XDataSize shl 1;
    StartDataX:=((InY1-BY1)*XDataSize)+(2*(InX1-BX1));

    StartX:=(InY1*BiosColumns)+(2*InX1);
    XSize:=(InX2-InX1)+1;
    YSize:=(InY2-InY1)+1;
    TraceX:=InX1;
    TraceY:=InY1;
    TraceBX1:=InX1;

    Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es


        mov si,StartX

        mov di,Offs
        add di,StartDataX

        mov cx,YSize

@ChangeY:
          push cx

          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          xor  ax,ax
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec ax
          cmp TraceX,ax
          ja @NoPrint

          mov ax,Segment
          mov es,ax
          mov bx,es:[di]

          mov bh,InColor

          mov ax,VideoSeg
          mov es,ax
          mov es:[si],bx
@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax

          mov ax,XDataSize
          add StartDataX,ax
          mov di,Offs
          add di,StartDataX

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

          pop cx
          loop @ChangeY

          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

    End;

    Inc(Bx1);
    Inc(Bx2);
    Inc(By1);
    Inc(By2);
  End;

End;


Procedure WinBasics.SavePart(InX1,InY1,InX2,InY2 :Byte);
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
    XDataSize,
    StartDataX              :Word;
Begin
  IF SnapShot<>Nil Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;


    Dec(InX1);
    Dec(InX2);
    Dec(InY1);
    Dec(InY2);

    Dec(BX1);
    Dec(BX2);
    Dec(BY1);
    Dec(BY2);


    XDataSize:=(BX2-BX1)+1;
    XDataSize:=XDataSize shl 1;
    StartDataX:=((InY1-BY1)*XDataSize)+(2*(InX1-BX1));

    StartX:=(InY1*BiosColumns)+(2*InX1);
    XSize:=(InX2-InX1)+1;
    YSize:=(InY2-InY1)+1;
    TraceX:=InX1;
    TraceY:=InY1;
    TraceBX1:=InX1;

    Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es


        mov si,StartX

        mov di,Offs
        add di,StartDataX

        mov cx,YSize

@ChangeY:
          push cx

          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          xor  ax,ax
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec ax
          cmp TraceX,ax
          ja @NoPrint

          mov ax,VideoSeg
          mov es,ax
          mov bx,es:[si]

          mov ax,Segment
          mov es,ax
          mov es:[di],bx

@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax

          mov ax,XDataSize
          add StartDataX,ax
          mov di,Offs
          add di,StartDataX

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

          pop cx
          loop @ChangeY

          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

    End;

    Inc(Bx1);
    Inc(Bx2);
    Inc(By1);
    Inc(By2);
  End;

End;

Procedure WinBasics.MoveData;
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
    XDataSize,
    StartDataX              :Word;
    TempData                :^ScreenImage;
    OffsTempData,SegTempData:Word;
    WinSizeVar              :Word;
Begin
  IF (SnapShot<>Nil) and (MemAvail>WinSize) Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    TempData:=EdsGetMem(TempData,WinSize);

    If HeapErrorCode=0 Then
    Begin

      OffsTempData:=Ofs(TempData^);
      SegTempData:=Seg(TempData^);

      Dec(InX1);
      Dec(InX2);
      Dec(InY1);
      Dec(InY2);

      Dec(ToX1);
      Dec(ToY1);

      Dec(BX1);
      Dec(BX2);
      Dec(BY1);
      Dec(BY2);


      XDataSize:=(BX2-BX1)+1;
      XDataSize:=XDataSize shl 1;
      StartDataX:=((InY1-BY1)*XDataSize)+(2*(InX1-BX1));

      StartX:=((ToY1-BY1)*XDataSize)+(2*(ToX1-BX1));;
      XSize:=(InX2-InX1)+1;
      YSize:=(InY2-InY1)+1;
      TraceX:=InX1;
      TraceY:=InY1;
      TraceBX1:=InX1;
      WinSizeVar:=WinSize;

      Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es
        push ds

        mov si,OffsTempData
        add si,StartX

        mov di,Offs
        add di,StartDataX

        mov cx,YSize

@ChangeY:
          push cx
          mov  Cx,XSize

@ChangeX:
          mov ax,Segment
          mov es,ax
          mov bx,es:[di]

          mov ax,SegTempData
          mov es,ax
          mov es:[si],bx

@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax

          mov ax,XDataSize
          add StartDataX,ax
          mov di,StartDataX
          mov ax,Offs
          add di,ax

          mov ax,XDataSize
          add StartX,ax
          mov si,StartX
          mov ax,OffsTempData
          add si,ax

          pop cx
          loop @ChangeY

          mov ax,Segment
          mov es,ax
          mov di,Offs

          mov si,OffsTempData
          mov cx,WinSizeVar
          shr cx,1
          mov ax,SegTempData
          mov ds,ax
          cld

          rep movsw

          pop ds
          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

      End;

      Inc(Bx1);
      Inc(Bx2);
      Inc(By1);
      Inc(By2);
    End;
    FreeMem(TempData,WinSizeVar);
  End;

End;

{*************************************************************************}
{Procedure WinBasics.RestoreArea                                          }
{Ñ£≠ò§†©û ´¶¨ SnapShot ©´û§ ¶ü¶§û ò≠¶¨ úÆ¶¨£ú Æ®û©†£¶ß¶†û©ú† ß®¶ûö¶¨£ú§¶™ }
{´û§ SaveArea.Éú§ Æ®úòùú´ò† ßò®ò£ú´®¶¨™ ò≠¶¨ ô®†©°ú† ´ò ¶®†ò òß¶ ´¶       }
{WinBasics object (Æ®û©†£¶ß¶†û©ò£ú ´û§ WinBasics.Init)                    }
{*************************************************************************}

Procedure WinBasics.RestoreArea;
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
    TraceBX1                :Byte;
Begin
  IF SnapShot<>Nil Then
  Begin
    Offs:=Ofs(SnapShot^);
    Segment:=Seg(SnapShot^);

    IF (BX1 > (BiosColumns shr 1)) or (BY1 > BiosRows) Then
       Exit;


    Dec(Bx1);
    Dec(Bx2);
    Dec(By1);
    Dec(By2);

    StartX:=(BY1*BiosColumns)+(2*BX1);
    XSize:=(BX2-BX1)+1;
    YSize:=(BY2-BY1)+1;
    TraceX:=BX1;
    TraceY:=BY1;
    TraceBX1:=BX1;

    Asm;
        push ax
        push cx
        push bx

        push si
        push di

        push es


        mov si,StartX

        mov di,Offs

        mov cx,YSize

@ChangeY:
          push cx
          xor  ax,ax
          mov  al,ds:SetWindowY2
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          xor ax,ax
          mov al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
          xor ax,ax
          mov al,ds:SetWindowX2
          dec al
          cmp TraceX,ax
          ja @NoPrint

          mov ax,ds:BiosColumns
          shr ax,1
          dec  ax
          cmp  TraceX,ax
          ja  @NoPrint

          mov ax,Segment
          mov es,ax
          mov bx,es:[di]

          mov ax,VideoSeg
          mov es,ax
          mov es:[si],bx
@NoPrint:
          inc si
          inc si
          inc di
          inc di
          inc TraceX

          loop @ChangeX

@CancelXLoop:
          inc TraceY
          xor ax,ax
          mov al,TraceBx1
          mov TraceX,ax
          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

          pop cx
          loop @ChangeY

          pop es

          pop di
          pop si

          pop bx
          pop cx
          pop ax

    End;

    Inc(Bx1);
    Inc(Bx2);
    Inc(By1);
    Inc(By2);

    FreeMem(SnapShot,WinSize);
    SnapShot:=Nil;
  End;
End;

END.