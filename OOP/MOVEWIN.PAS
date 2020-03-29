Uses Crt;
Type
    WindowArray  = Array [0..3999] of Byte;

    WinCoord = Record
       X1,X2,Y1,Y2 :Byte;
    End;
Var
    WindowData      :^WindowArray;
    WindowImage     :^WindowArray;
    WindowReserved  :^WindowArray;
    W1,W2,W3,W4     :Byte;
    D1,D2,D3,D4     :Byte;
    Storage         :Word;
    CurrentCol,CurrentRow        :Byte;


    Columns,Rows                 :Byte;
    WDOfs,WDSeg                  :Word;
    OffsetInData                 :Word;
    JumpBytes                    :Byte;
    ScreenX,ScreenY              :Byte;


Procedure WriteVideoBuffer;assembler;
asm;
    push ds

    mov ax,0b800h
    mov es,ax

    mov ch,W4
    mov cl,W2
    sub ch,cl
    inc ch
    mov bh,ch  {How many lines     BH }

    mov ch,W3
    mov cl,W1
    sub ch,cl
    inc ch
    mov bl,ch  {How many columns,  BL }

    mov dh,W2
    dec dh
    xor ah,ah
    mov al,160
    mul dh
    mov dx,ax


@AddColumns:
    xor ax,ax
    mov al,W1
    dec al
    shl al,1          {mul x2 CharByte+AttributeByte}
    add dx,ax         {Now we have the final offset    }

    mov si,dx
    mov di,offset WindowImage
    push ds

    push dx
    mov dx,[di]

    mov ax,[di+2]
    mov ds,ax

    mov di,dx
    pop dx

    xor cx,cx
    mov cl,bh

@Lo1:
    push cx
    xor cx,cx
    mov cl,bl
@Lo2:
    mov ax,ds:[di]
    mov es:[si],ax

    inc si
    inc si
    inc di
    inc di

    loop @Lo2

    add dx,160
    mov si,dx

    pop cx
    loop @Lo1

    pop ds

    pop  ds
End;

Procedure ReadVideoBuffer;
Var
   I,J  :Byte;
   Index      :Word;

Begin
    Index:=0;
    For I:=W2 to W4 do
    Begin
      For J:=W1 to W3 do
      Begin
          WindowData^[Index]:=Mem[$B800:160*(I-1)+2*(J-1)];
          WindowData^[Index+1]:=Mem[$B800:160*(I-1)+2*(J-1)+1];

          Inc(Index,2);
      End;
    End;

End;

Procedure Window;
Var
   I,J  :Byte;
   Index      :Word;
Begin

    Storage:=(W4-W2)+1;
    Storage:=Storage*((W3-W1)+1);
    Storage:=Storage shl 1;

    GetMem(WindowData,Storage);
    GetMem(WindowImage,Storage);
{    GetMem(WindowReserved,Storage);}

    ReadVideoBuffer;
    Index:=0;

    For I:=W2 to W4 do
    Begin
      For J:=W1 to W3 do
      Begin
          Mem[$B800:160*(I-1)+2*(J-1)]:=32;
          Mem[$B800:160*(I-1)+2*(J-1)+1]:=0+(7 shl 4)+15;

          WindowImage^[Index]:=Mem[$B800:160*(I-1)+2*(J-1)];
          WindowImage^[Index+1]:=Mem[$B800:160*(I-1)+2*(J-1)+1];

          Inc(Index,2);
      End;
    End;

End;

Procedure ShowSavedRegion;
Var
   I,J          :Byte;
   Index        :Word;
Begin
    Index:=0;
    For I:=W2 to W4 do
      For J:=W1 to W3 do
      Begin
          Mem[$B800:160*(I-1)+2*(J-1)]:=WindowData^[Index];
          Mem[$B800:160*(I-1)+2*(J-1)+1]:=WindowData^[Index+1];
          Index:=Index+2;
      End;

      FreeMem(WindowData,Storage);
      FreeMem(WindowImage,Storage);

End;

Procedure ShowImage;
Var
   I,J          :Byte;
   Index        :Word;
Begin
    Index:=0;
    For I:=W2 to W4 do
      For J:=W1 to W3 do
      Begin
          Mem[$B800:160*(I-1)+2*(J-1)]:=WindowImage^[Index];
          Mem[$B800:160*(I-1)+2*(J-1)+1]:=WindowImage^[Index+1];
          Index:=Index+2;
      End;

End;

Procedure BackGround;
Var
   I,J  :Byte;
Begin
{    For I:=1 to 20 do
    Begin
      For J:=1 to 80 do
      Begin
          Mem[$B800:160*(I-1)+2*(J-1)]:=Ord(Random(255));
          Mem[$B800:160*(I-1)+2*(J-1)+1]:=0+(1 shl 4)+15;
      End;
    End;}

    TextBackGround(4);
    Gotoxy(9,2);Write('George Papaioannou Larrisa 1994 Thessaliniki ,Test the program of moving');
    Gotoxy(9,3);Write('Computer TDK the original home micros');
    Gotoxy(9,10);Write('If this program works correctly and show the results');
    Gotoxy(9,15);Write('If this program works correctly and show the results');

End;


Procedure SavePart;assembler;
Var
        WholeMove               :Byte;
        XOffset                 :Byte;
        LeftOrRight             :Byte;  {Flag to Know if we had Right=FF or}
                                        {Left=0 move.                      }

     {*************************************************************}
     {Procedure ReadFromScreen                                     }
     {It used from ShowPart procedure to write something to screen.}
     {It is general routine.We can use it for Horizontial or Vertic}
     {al purposes.                                                 }
     {*************************************************************}
     Procedure ReadFromScreen;assembler;
     Asm;
          mov bh,Rows  {How many lines     BH }

          mov bl,Columns  {How many columns,  BL }

          mov dh,ScreenY
          xor ah,ah
          mov al,160
          mul dh
          mov dx,ax

   @AddColumns:
           xor ax,ax
           mov al,ScreenX
           shl al,1          {mul x2 CharByte+AttributeByte}
           add dx,ax         {Now we have the final offset    }

           mov si,dx
           mov di,WDOfs
           mov ax,OffsetInData
           add di,ax


           xor cx,cx
           mov cl,bh

   @Lo1:
           push cx
           xor cx,cx
           mov cl,bl
   @Lo2:

           mov ax,0B800h
           mov es,ax
           mov ax,es:[si]

           push ax
           mov ax,WDSeg
           mov es,ax
           pop ax
           mov es:[di],ax

           inc si
           inc si
           inc di
           inc di

           loop @Lo2

           add dx,160
           mov si,dx

           xor ax,ax
           mov al,JumpBytes
           add di,ax

           pop cx
           loop @Lo1

     End;


Asm;
   push ds

   {-------------first make a test for horizontal offset (if exist)------}

   {Notation:                                                            }
   {Horizontial routines write to screen vertical while Vertical routines}
   {write to screen horizontial.                                         }

   mov WholeMove,0
   mov XOffset,0
   mov LeftOrRight,0   {we suppose that we have a left move}

   mov al,W1
   cmp D1,al
   ja  @RightMove
   jb  @LeftMove

   jmp @CheckYMove

@RightMove:
         {-------------------- Right X Move ---------------}

   mov LeftOrRight,0FFh

   mov al,W3          {Check if we have a whole move of the window}
   cmp D1,al
   ja  @SetValue
   jmp @EverythingOk  {No ? Then go ahead}

@SetValue:            {If we have a whole move then do these}
   mov al,W3
   sub al,W1
   inc al
   mov Columns,al
   mov WholeMove,0FFh  {It's a Flag that means that we have a whole move}
   jmp @Continue1

@EverythingOk:

   mov al,D1
   sub al,W1        {Now al:=NewX1-OldX1 = XDif}
   mov Columns,al   {The total Columns}


@Continue1:
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al  {The toal Rows}

   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov JumpBytes,0
   mov OffsetInData,0
   mov al,Columns
   mov Xoffset,al

   cmp WholeMove,0FFh
   jz  @EndRight

   mov ah,Columns
   add ah,W1          {AH:=W1+Columns}
   mov al,W3
   sub al,ah          {AL:=W3-AH}
   inc al             {Inc the result}
   shl al,1           {mul the result x2 because attribute byte}
   mov JumpBytes,al
   xor ah,ah
   mov OffsetInData,ax

@EndRight:

   mov al,D3
   mov ah,Columns
   dec ah
   sub al,ah
   dec al
   mov ScreenX,al

   mov al,D2
   dec al
   mov ScreenY,al

   pushf
   Call ReadFromScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove

@LeftMove:
         {--------------------- Left X Move ---------------}


   mov al,W1          {Check if we have a whole move of the window}
   cmp D3,al
   jb  @SetValueL
   jmp @EverythingOkL  {No ? Then go ahead}

@SetValueL:            {If we have a whole move then do these}
   mov al,W3
   sub al,W1
   inc al
   mov Columns,al
   mov WholeMove,0FFh  {It's a Flag that means that we have a whole move}
   jmp @Continue2

@EverythingOkL:

   mov al,W1
   sub al,D1        {Now al:=OldX1-NewX1 = XDif}
   mov Columns,al   {The total Columns}


@Continue2:
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al  {The toal Rows}

   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov JumpBytes,0
   mov OffsetInData,0
   mov al,Columns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndLeft

   mov ah,Columns
   add ah,W1          {AH:=W1+Columns}
   mov al,W3
   sub al,ah          {AL:=W3-AH}
   inc al             {Inc the result}
   shl al,1           {mul the result x2 because attribute byte}
   mov JumpBytes,al

@EndLeft:

   mov al,D1
   dec al
   mov ScreenX,al

   mov al,D2
   dec al
   mov ScreenY,al

   pushf
   Call ReadFromScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove


   {=======================  Y MOVE OFFSET ============================}

@CheckYMove:

   mov al,W2
   cmp D2,al
   ja  @DownMove
   jb  @UpMove

   jmp @NoYMove


@DownMove:
      {-------------------- Down Y Move --------------------}

   mov al,W4          {Check if we have a whole move of the window}
   cmp D2,al
   ja  @SetValueD
   jmp @EveryThingOkD      {No ? Then go ahead}

@SetValueD:            {If we have a whole move then do these}
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al
   mov WholeMove,0FFh
   jmp @Continue3

@EveryThingOkD:
   mov al,D2
   sub al,W2
   mov Rows,al  {The total Rows}

@Continue3:
   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndDown

   mov dl,XOffset
   shl dl,1
   mov JumpBytes,dl    {Jump Bytes}

   mov dl,D4
   mov dh,D2
   sub dl,dh
   inc dl              {How many rows in total}
   sub dl,Rows

   mov al,D3
   mov ah,D1
   sub al,ah
   inc al
   mov cl,al           {Keep Line length temp to CL}
   shl al,1            {One line length -in bytes-}

   xor ah,ah
   mul dl              {We reached to the desired row}

   cmp LeftOrRight,0FFh
   jz  @NoColumnsToAdd

   xor dh,dh
   mov dl,JumpBytes
   add ax,dx


@NoColumnsToAdd:
   mov OffsetInData,ax

   sub cl,XOffset     {Take Line Length from cl}
   mov Columns,cl


@EndDown:

   mov al,W1
   dec al

   cmp LeftOrRight,0h
   jz  @Go1

   mov ah,JumpBytes
   shr ah,1
   add al,ah

@Go1:
   mov ScreenX,al

   mov al,D4
   dec al
   mov ah,Rows
   dec ah
   sub al,ah
   mov ScreenY,al

   pushf
   Call ReadFromScreen



   jmp @NoYMove
@UpMove:
      {-------------------- Up Y Move -----------------------}

   mov al,D4          {Check if we have a whole move of the window}
   cmp W2,al
   ja  @SetValueU
   jmp @EveryThingOkU      {No ? Then go ahead}

@SetValueU:            {If we have a whole move then do these}
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al
   mov WholeMove,0FFh
   jmp @Continue4

@EveryThingOkU:
   mov al,W2
   sub al,D2
   mov Rows,al  {The total Rows}

@Continue4:
   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndUp

   mov dl,XOffset
   shl dl,1
   mov JumpBytes,dl    {Jump Bytes}
   mov ax,0

   cmp LeftOrRight,0FFh
   jz  @NoColumnsToAdd2

   xor dh,dh
   mov dl,JumpBytes
   add ax,dx


@NoColumnsToAdd2:
   mov OffsetInData,ax

   mov dh,D3
   mov dl,D1
   sub dh,dl
   inc dh
   sub dh,XOffset
   mov Columns,dh


@EndUp:

   mov al,W1
   dec al

   cmp LeftOrRight,0h
   jz  @Go2

   mov ah,JumpBytes
   shr ah,1
   add al,ah

@Go2:
   mov ScreenX,al


   mov al,W2
   dec al
   sub al,Rows
   mov ScreenY,al

   pushf
   Call ReadFromScreen


@NoYMove:
      {===================== END OF PROCEDURE ========================}


   pop ds

End;


Procedure ShowPart;assembler;
Var
        WholeMove          :Byte;
        XOffset            :Byte;
        LeftOrRight        :Byte;

     {*************************************************************}
     {Procedure WriteToScreen                                      }
     {It used from ShowPart procedure to write something to screen.}
     {It is general routine.We can use it for Horizontial or Vertic}
     {al purposes.                                                 }
     {*************************************************************}
     Procedure WriteToScreen;assembler;
     Asm;
          mov bh,Rows  {How many lines     BH }

          mov bl,Columns  {How many columns,  BL }

          {==== Find physical address into video buffer ====}

          mov dh,ScreenY
          xor ah,ah
          mov al,160
          mul dh
          mov dx,ax



   @AddColumns:
           xor ax,ax
           mov al,ScreenX
           shl al,1          {mul x2 CharByte+AttributeByte}
           add dx,ax         {Now we have the final offset    }

           mov si,dx
           mov di,WDOfs
           add di,OffsetInData

           xor cx,cx
           mov cl,bh

   @Lo1:
           push cx
           xor cx,cx
           mov cl,bl
   @Lo2:
           mov ax,WDSeg
           mov es,ax
           mov ax,es:[di]

           push ax
           mov ax,0B800h
           mov es,ax
           pop ax
           mov es:[si],ax

           inc si
           inc si
           inc di
           inc di

           loop @Lo2

           add dx,160
           mov si,dx

           xor ax,ax
           mov al,JumpBytes
           add di,ax

           pop cx
           loop @Lo1

     End;


Asm;
   push ds

   {-------------first make a test for horizontal offset (if exist)------}

   {Notation:                                                            }
   {Horizontial routines write to screen vertical while Vertical routines}
   {write to screen horizontial.                                         }

   mov WholeMove,0
   mov XOffset,0
   mov LeftOrRight,0

   mov al,W1
   cmp D1,al
   ja  @RightMove
   jb  @LeftMove

   jmp @CheckYMove

@RightMove:
         {-------------------- Right X Move ---------------}

   mov LeftOrRight,0FFh

   mov al,W3          {Check if we have a whole move of the window}
   cmp D1,al
   ja  @SetValue
   jmp @EverythingOk  {No ? Then go ahead}

@SetValue:            {If we have a whole move then do these}
   mov al,W3
   sub al,W1
   inc al
   mov Columns,al
   mov WholeMove,0FFh
   jmp @Continue1

@EverythingOk:

   mov al,D1
   sub al,W1        {Now al:=NewX1-OldX1 = XDif}
   mov Columns,al   {The total Columns}


@Continue1:
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al  {The toal Rows}

   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0
   mov al,Columns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndRight

   mov ah,Columns
   add ah,W1         { AH:=W1+Columns}
   mov al,W3
   sub al,ah         { AL:=W3-AH}
   inc al            { Inc the result}
   shl al,1          { mul the result x2 because attribute byte}
   mov JumpBytes,al

@EndRight:

   mov al,W1
   dec al
   mov ScreenX,al
   mov al,W2
   dec al
   mov ScreenY,al

   pushf
   Call WriteToScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove

@LeftMove:
         {--------------------- Left X Move ---------------}


   mov al,W1          {Check if we have a whole move of the window}
   cmp D3,al
   jb  @SetValueL
   jmp @EverythingOkL  {No ? Then go ahead}

@SetValueL:            {If we have a whole move then do these}
   mov al,W3
   sub al,W1
   inc al
   mov Columns,al
   mov WholeMove,0FFh
   jmp @Continue2

@EverythingOkL:

   mov al,W1
   sub al,D1        {Now al:=OldX1-NewX1 = XDif}
   mov Columns,al   {The total Columns}


@Continue2:
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al  {The toal Rows}

   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0
   mov al,Columns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndLeft

   mov ah,Columns
   add ah,W1         { AH:=W1+Columns}
   mov al,W3
   sub al,ah         { AL:=W3-AH}
   inc al            { Inc the result}
   shl al,1          { mul the result x2 because attribute byte}
   mov JumpBytes,al
   xor ah,ah
   mov OffsetInData,ax

@EndLeft:

   mov al,W3
   dec al
   mov ah,Columns
   sub al,ah
   inc al
   mov ScreenX,al
   mov al,W2
   dec al
   mov ScreenY,al

   pushf
   Call WriteToScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove


   {=======================  Y MOVE OFFSET ============================}

@CheckYMove:

   mov al,W2
   cmp D2,al
   ja  @DownMove
   jb  @UpMove

   jmp @NoYMove


@DownMove:
      {-------------------- Down Y Move --------------------}

   mov al,W4          {Check if we have a whole move of the window}
   cmp D2,al
   ja  @SetValueD
   jmp @EveryThingOkD      {No ? Then go ahead}

@SetValueD:            {If we have a whole move then do these}
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al
   mov WholeMove,0FFh
   jmp @Continue3

@EveryThingOkD:
   mov al,D2
   sub al,W2
   mov Rows,al  {The total Rows}

@Continue3:
   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndDown

   mov dl,XOffset
   shl dl,1
   mov JumpBytes,dl
   xor dh,dh

   cmp LeftOrRight,0h
   jz  @Cont21
   mov OffsetInData,dx

@Cont21:
   mov ah,D3
   mov al,D1
   sub ah,al
   inc ah
   sub ah,XOffset
   mov Columns,ah


@EndDown:

   mov ah,W1
   dec ah
   cmp LeftOrRight,0h
   jz  @Cont22

   mov al,JumpBytes
   shr al,1
   add ah,al
@Cont22:
   mov ScreenX,ah

   mov al,W2
   dec al
   mov ScreenY,al

   pushf
   Call WriteToScreen


   jmp @NoYMove
@UpMove:
      {-------------------- Up Y Move -----------------------}

   mov al,D4          {Check if we have a whole move of the window}
   cmp W2,al
   ja  @SetValueU
   jmp @EveryThingOkU      {No ? Then go ahead}

@SetValueU:            {If we have a whole move then do these}
   mov al,D4
   sub al,D2
   inc al
   mov Rows,al
   mov WholeMove,0FFh
   jmp @Continue4

@EveryThingOkU:
   mov al,W2
   sub al,D2
   mov Rows,al  {The total Rows}

@Continue4:
   mov si,Offset WindowData {Address in Data Segment}
   mov ax,[si]
   mov WDOfs,ax      {Offset of the pointer Data in the Heap}
   mov ax,[si+2]
   mov WDSeg,ax      {Segment of the pointer Data in the Heap}

   mov OffsetInData,0 {No Offset}
   mov JumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndUp

   mov dl,XOffset
   shl dl,1
   mov JumpBytes,dl
   xor dh,dh

   push dx         {ax contains the XOffset }

   mov ah,D3
   mov al,D1
   sub ah,al
   inc ah
   mov dh,ah      {Keep this value for later use}
   sub ah,XOffset
   mov Columns,ah

   shl dh,1       {mul x2}
   mov ah,D4
   mov al,D2
   sub ah,al
   inc ah
   sub ah,Rows
   xchg ah,al
   xor ah,ah
   mul dh        {now ax contain the start into Data buffer}

   pop dx

   mov cl,LeftOrRight
   cmp cl,0      {If Left move then don't add anything}
   jz @Cont1

   add ax,dx     {If Right then add the XOffset}

@Cont1:
   mov OffsetInData,ax

@EndUp:

   mov al,W1
   dec al
   cmp LeftOrRight,0
   jz  @Cont2
   mov ah,JumpBytes
   shr ah,1
   add al,ah
@Cont2:
   mov ScreenX,al

   mov al,W4
   dec al
   sub al,Rows
   inc al
   mov ScreenY,al

   pushf
   Call WriteToScreen


@NoYMove:
      {===================== END OF PROCEDURE ========================}


   pop ds

End;

Procedure InterSection(WinSource,WinDest :WinCoord;Var WinInterSection :WinCoord);
Var
   I             :Byte;
   XItsOk,YItsOk :Boolean;
Begin
     {„˜¤ «˜ x1,y1,x2,y2 «¦¬ WinDest ›œ¤ ™¨ ©¡¦¤«˜  £œ©˜ ©«˜ ˜¤« ©«¦ ®˜ «¦¬ }
     {WinSource «¦«œ œ¥¦›¦ª £œ WinInterSection x1,y1,x2,y2 = 255            }

     XItsOk:=False;
     YItsOk:=False;

     I:=WinDest.X1;
     Repeat
        IF I in [WinSource.X1..WinSource.X2] Then
             XItsOk:=True;
        Inc(I);
     Until (I=WinDest.X2+1) OR (XItsOk=True);

     I:=WinDest.Y1;
     Repeat
        IF I in [WinSource.Y1..WinSource.Y2] Then
             YItsOk:=True;
        Inc(I);
     Until (I=WinDest.Y2+1) OR (YItsOk=True);

     IF (XItsOk=True) and (YItsOk=True) Then
     Begin
       IF WinSource.X1 in [WinDest.X1..WinDest.X2] then
          WinInterSection.X1:=WinSource.X1                    {X1}
       Else
          WinInterSection.X1:=WinDest.X1;

       IF WinSource.X2 in [WinDest.X1..WinDest.X2] then       {X2}
          WinInterSection.X2:=WinSource.X2
       Else
          WinInterSection.X2:=WinDest.X2;

       IF WinSource.Y1 in [WinDest.Y1..WinDest.Y2] then       {Y1}
          WinInterSection.Y1:=WinSource.Y1
       Else
          WinInterSection.Y1:=WinDest.Y1;

       IF WinSource.Y2 in [WinDest.Y1..WinDest.Y2] then       {Y2}
          WinInterSection.Y2:=WinSource.Y2
       Else
          WinInterSection.Y2:=WinDest.Y2;
     End
     Else
     Begin
         WinInterSection.X1:=$FF;
         WinInterSection.X2:=$FF;
         WinInterSection.Y1:=$FF;
         WinInterSection.Y2:=$FF;
     End
End;


Procedure InternalCopy(Intern :WinCoord);
Var
   Storage      :Word;
   WRSeg,WROfs  :Word;
   ColumnLen    :Byte;
Begin
    Storage:=(Intern.Y2-Intern.Y1)+1;
    Storage:=Storage*((Intern.X2-Intern.X1)+1);
    Storage:=Storage shl 1;

    GetMem(WindowReserved,Storage);        {Get Mem for internal use}
    Asm;
       push ds

       mov ah,Intern.X2
       mov al,Intern.X1
       sub ah,al
       inc ah
       mov Columns,ah     {Total Columns}

       mov ah,Intern.Y2
       mov al,Intern.Y1
       sub ah,al
       inc ah
       mov Rows,ah        {Total Rows}

       mov si,Offset WindowData
       mov dx,[si]
       mov WDOfs,dx
       mov dx,[si+2]
       mov WDSeg,dx        {Window Data}

       mov ah,Intern.X1
       mov al,W1
       sub ah,al
       shl ah,1
       xchg ah,al
       xor ah,ah
       mov OffsetInData,ax    {Start for current line}

       mov ah,W3
       mov al,W1
       sub ah,al
       inc ah
       shl ah,1
       xchg ah,al
       xor ah,ah
       mov ColumnLen,al

       mov ah,Columns
       shl ah,1
       sub al,ah
       mov JumpBytes,al

       mov dh,Intern.Y1
       mov dl,W2
       sub dh,dl
       xor ax,ax
       mov al,ColumnLen
       mul dh          {Ax:=dh*Ax}
       mov dx,OffsetInData
       add ax,dx

       mov si,WDOfs
       add si,ax            {Offset into WindowData}

       mov di,Offset WindowReserved
       mov dx,[di]
       mov WROfs,dx
       mov dx,[di+2]
       mov WRSeg,dx

       mov di,WROfs

       xor cx,cx
       mov cl,Rows

@Lo1:  push cx
       xor cx,cx
       mov cl,Columns
@Lo2:
       mov ax,WDSeg
       mov es,ax
       mov ax,es:[si]

       push ax
       mov ax,WRSeg
       mov es,ax
       pop ax
       mov es:[di],ax

       inc si
       inc si

       inc di
       inc di

       loop @Lo2

       xor ax,ax
       mov al,JumpBytes
       add si,ax
       pop cx
       loop @Lo1

       {---------------Now recopy from ReservedData to new WindowData-------}

       mov si,Offset WindowData
       mov dx,[si]
       mov WDOfs,dx
       mov dx,[si+2]
       mov WDSeg,dx
       mov si,WDOfs

       mov dl,D2
       mov dh,Intern.Y1
       sub dh,dl
       xor ah,ah
       mov al,ColumnLen
       mul dh           {Now ax:=YOffset}

       mov dl,D1
       mov dh,Intern.X1
       sub dh,dl
       shl dh,1
       xor dl,dl
       xchg dl,dh
       add ax,dx         {Now Ax:=YOffset+XOffset}
       mov si,ax         {The actual Start}



       mov di,Offset WindowReserved
       mov dx,[di]
       mov WROfs,dx
       mov dx,[di+2]
       mov WRSeg,dx
       mov di,WROfs


       xor cx,cx
       mov cl,Rows

@Lo11: push cx
       xor cx,cx
       mov cl,Columns
@Lo21:
       mov ax,WRSeg
       mov es,ax
       mov ax,es:[di]

       push ax
       mov ax,WDSeg
       mov es,ax
       pop ax
       mov es:[si],ax

       inc si
       inc si

       inc di
       inc di

       loop @Lo21

       xor ax,ax
       mov al,JumpBytes
       add si,ax

       pop cx
       loop @Lo11



       pop  ds
    End;

    FreeMem(WindowReserved,Storage);

End;


Procedure WriteBufXY(X1,Y1      :Byte);
Var
   XDif,YDif    :Byte;
   Old,New,Over :WinCoord;
Begin

   XDif:=W3-W1;
   YDif:=W4-W2;

   D1:=X1;D2:=Y1;
   D3:=X1+XDif;D4:=Y1+YDif;

   ShowPart;

   Old.X1:=W1;Old.Y1:=W2;
   Old.X2:=W3;Old.Y2:=W4;

   New.X1:=D1;New.Y1:=D2;
   New.X2:=D3;New.Y2:=D4;

   InterSection(New,Old,Over);
   IF Over.X1<>$FF Then
      InternalCopy(Over);

   SavePart;

   W1:=D1;W2:=D2;
   W3:=D3;W4:=D4;

   WriteVideoBuffer;
End;

Procedure Move;
Var
   Ch   :Char;
   X1,Y1:Byte;
Begin
    Repeat
        Ch:=readkey;
        IF ch='l' Then
           WriteBufXY(W1+1,W2)
        Else
        IF ch='j' Then
           WriteBufXY(W1-1,W2+1)
        Else
        If ch='i' Then
           WriteBufXY(W1,W2-1)
        Else
        If ch='k' then
           WriteBufXY(W1,W2+1);
        IF ch=#13 Then
        Begin
            Gotoxy(1,24);Write('Give Coordinates:');
            Readln(X1,Y1);
            Gotoxy(1,24);Write('                 ');
            WriteBufXY(X1,Y1);
        End;

    Until Ch=#27;
End;

Begin

    W1:=10;W2:=2;W3:=20;W4:=14;
    TextBackGround(0);
    Clrscr;
    Background;
    Window;
    Move;
    ShowSavedRegion;
    Readln;

End.