{***************************************************************************}
{UNIT DEMOFX                                                                }
{èú®†úÆú† ¶¢ú™ ´†™ ®¶¨´†§ú™ ö†ò õ†ò≠¶®ò ¶ß´†°ò ú≠ú.                         }
{                                                                           }
{èòßò†‡ò§§¶¨ Çú‡®ö†¶™ áú©©ò¢¶§†°û 1994                                      }
{***************************************************************************}

UNIT DEMOFX;

INTERFACE

Uses GeneralObj,VarConstObj;

Const
     DelayNumber  :Word = 1000;
type
     VideoArraySize  = array [0..3999] of byte;
     PVideoArraySize = ^VideoArraySize;

     PPicsSeries = ^PicsSeries;
     PicsSeries  = Record
         Title     :String[40];
         SnapShot  :VideoArraySize;
         Next      :PPicsSeries;
     End;

    ScreenBasics = object
       BX1,BY1,BX2,BY2    :Byte;
       WinSize            :Word;
       SnapShot           :^ScreenImage;
       Procedure Init(InX1,InY1,InX2,InY2 :Byte);
       Procedure SaveArea(InX1,InY1,InX2,InY2 :Byte);
       Procedure RestoreArea;
    End;

Const
     Pics     :PPicsSeries = Nil;
     HeadPics :PPicsSeries = Nil;

Procedure SavePic(Name :String;Var ErrorCode :Byte);
Procedure SearchPic(Name :String);
Procedure DisposePics;
Procedure DisposeLastPic;

procedure Curoff;
Procedure From_Down_to_up(y:byte);
procedure Fx1;
procedure Fx2;
procedure Fx3;
procedure Fx4;
procedure Fx5;
procedure Fx6;
procedure Fx7;
procedure Fx8;
procedure Fx9;
procedure Fx10;
Procedure Fx11;

IMPLEMENTATION


{************************************************************************}
{Procedure ScreenBasics.Init                                             }
{ò®Æ†°¶ß¶†û©û ´‡§ £ú´òô¢û´‡§ :úßò§‡ ò®†©´ú®û™ ö‡§†ò™,°ò´‡ õú•†ò™ ö‡§†ò™  }
{°ò† ´¶§ õú†°´û ¶ß¶¨ ©‡ù¶¨£ú ´ò õúõ¶£ú§ò                                 }
{************************************************************************}

Procedure ScreenBasics.Init;
Begin
    BX1:=InX1;BY1:=InY1;
    BX2:=InX2;BY2:=InY2;
    SnapShot:=Nil
End;

{**************************************************************************}
{Procedure ScreenBasics.SaveArea                                           }
{ë‡ù¶¨£ú ú§ò °¶£ò´† ´û™ £§û£û™ ©´û§ õ†ú¨ü¨§©û ´¶¨ SnapShot.è®úßú† ß®¶û-    }
{ö¶¨£ú§¶™ §ò úÆ¶¨£ú °ò§ú† New.A≠¶¨ ô®¶¨£ú ´¶ segment °ò† ´¶ offset ´¶¨     }
{SnapShot ò¢¢òù¶¨£ú ©¨§úÆ‡™ ´¶§ Es £†ò ≠¶®ò £ú VideoSeg °ò† £†ò £ú SnapShotSeg}
{**************************************************************************}

Procedure ScreenBasics.SaveArea;
Var
    StartX,XSize,YSize      :Word;
    Offs,Segment            :Word;
    TraceX,TraceY           :Word;
Begin
    ScreenBasics.Init(InX1,InY1,InX2,InY2);

    TraceX:=InX1-1;
    TraceY:=InY1-1;

    XSize:=(InX2-InX1)+1;
    XSize:=XSize*2;
    YSize:=(InY2-InY1)+1;
    WinSize:=YSize * XSize;

    GetMem(SnapShot,WinSize);


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
          mov  al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop


          mov  Cx,XSize

@ChangeX:
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
          loop @ChangeX

          mov ax,BiosColumns
          add StartX,ax
          mov si,StartX

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

Procedure ScreenBasics.RestoreArea;
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

          xor ax,ax
          mov al,ds:BiosRows
          dec  al
          cmp  TraceY,ax
          ja  @CancelXLoop

          mov  Cx,XSize

@ChangeX:
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


Procedure SavePic(Name :String;Var ErrorCode :Byte);
Var
   Count        :Word;
   row,Column   :Byte;
Begin
    IF MaxAvail > SizeOf(PicsSeries) Then
    Begin
       New(Pics);
       Count:=0;
       For row:=1 to 25 do
          For Column:=1 to 80 do
          Begin
            Pics^.SnapShot[Count]:=Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)];
            Pics^.SnapShot[Count+1]:=Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)+1];
            Count:=Count+2;
         End;
       Pics^.Title:=Name;
       Pics^.Next:=HeadPics;
       HeadPics:=Pics;
       ErrorCode:=0;
   End {IF}
   Else
       ErrorCode:=1;
End;


Procedure SearchPic(Name :String);
Var
   Trace  :PPicsSeries;
Begin
     Trace:=HeadPics;
     repeat

          IF Trace^.Title<>Name Then
             Trace:=Trace^.Next;

     Until (Trace^.Title=Name) or (Trace=Nil);

     IF Trace^.Title=Name Then
         Pics:=Trace;
End;

Procedure DisposePics;
Var
   Trace  :PPicsSeries;
Begin
     Pics:=HeadPics;
     IF Pics<>Nil Then
     Begin
       Trace:=Pics;
       repeat
            Trace:=Trace^.Next;
            Dispose(Pics);
            Pics:=Trace;

       Until (Trace=Nil);
     End;
End;

Procedure DisposeLastPic;
Var
   Trace  :PPicsSeries;
Begin
     Pics:=HeadPics;
     IF Pics<>Nil Then
     Begin
       Trace:=Pics;
       Trace:=Trace^.Next;
       Dispose(Pics);
       Pics:=Trace;
       HeadPics:=Pics;
     End;
End;


procedure Curoff;assembler;
asm;
   mov ah,1
   mov ch,30h
   mov cl,0
   int 10h
End;

Procedure From_Down_to_up(y:byte);assembler;
asm;
   mov ah,6
   mov al,1
   mov bh,1
   mov ch,00
   mov cl,00
   dec y
   mov dh,y
   mov dl,79
   int 10h
End;

procedure Fx1;
Var
   row,Column :Byte;
   Count      :integer;
Begin
  IF Pics<>Nil Then
  Begin
     Count:=0;
     For row:=1 to 25 do Begin
       For Column:=1 to 80 do Begin
         Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
         Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
         Count:=Count+2;
       End;
     End;
  End;
End;


procedure Fx2;
Var
   Count,Start_Count  :integer;
   Column,row,T       :integer;
   met                :byte;

Begin
   {Form Up to Down}
  IF Pics<>Nil Then
  Begin
    Count:=3840;
    Start_Count:=3840;
    For row:=1 to 25 do
    Begin
     For T:=1 to row do
     Begin
        For Column:=1 to 40 do
        Begin
           Mem[VideoSeg:BiosColumns*(t-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
           Mem[VideoSeg:BiosColumns*(t-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
           Count:=Count+2;
         End;
         Count:=Count-80+160;
      End;
      RetraceDelay(DelayNumber);
      Count:=Start_Count-(160*row);
    End;

     {From Down to Up}

    Count:=80;
    Start_Count:=80;
    met:=0;
    For row:=25 downto 1 do
    Begin

        For T:=25 downto row do
        Begin

          For Column:=41 to 80 do
          Begin
             Mem[VideoSeg:BiosColumns*(t-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
             Mem[VideoSeg:BiosColumns*(t-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
             Count:=Count+2;
           End;
           Count:=Count-80-160;
        End;
        met:=met+1;
        Count:=Start_Count+(160*met);
        RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure Fx3;
Var
    Count,Start_Count :integer;
    met,T,row,Column  :Byte;
    Count2,met2       :integer;

Begin
  IF Pics<>Nil Then
  Begin
    Count:=158;
    Start_Count:=158;
    For Column:=1 to 80 do
    Begin
       For row:=1 to 25 do
       Begin
          For T:=1 to Column do
          Begin
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)]:=Pics^.SnapShot[Count];
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)+1]:=Pics^.SnapShot[Count+1];
           Count:=Count+2;
          End;
          Count:=Start_Count+(160*row);
       End;
       Start_Count:=Start_Count-2;
       Count:=Start_Count;
       RetraceDelay(DelayNumber);
    End;
  End;
End;


Procedure Fx4;
Var
    Count,Start_Count :integer;
    T,row,Column      :Byte;
    T_Help            :Byte;

Begin
  IF Pics<>Nil Then
  Begin
    Count:=0;
    Start_Count:=0;
    For Column:=1 to 80 do
    Begin
     For row:=1 to 25 do
     Begin
        For T:=1 to Column do
        Begin
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)]:=Pics^.SnapShot[Count];
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)+1]:=Pics^.SnapShot[Count+1];
           Count:=Count-2;
           T_Help:=T_Help-1;
        End;
        Count:=Start_Count+(160*row);
        T_Help:=80;
     End;
     Start_Count:=Start_Count+2;
     Count:=Start_Count;
     RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure Fx5;
Var
    Count,Start_Count :integer;
    T,row,Column      :Byte;
    T_Help            :Byte;
    Start_Count2      :Integer;

Begin
  IF Pics<>Nil Then
  Begin
    Count:=0;
    Start_Count:=0;
    For Column:=1 to 80 do
    Begin
     For row:=1 to 12 do
     Begin
        For T:=1 to Column do
        Begin
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)]:=Pics^.SnapShot[Count];
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)+1]:=Pics^.SnapShot[Count+1];
           Count:=Count-2;
           T_Help:=T_Help-1;
        End;
        Count:=Start_Count+(160*row);
        T_Help:=80;
     End;
     Start_Count:=Start_Count+2;
     Count:=Start_Count;
     RetraceDelay(DelayNumber);
    End;

    Count:=(11*160)+162;
    Start_Count:=158;
    Start_Count2:=Count;
    For Column:=1 to 80 do
    Begin
     For row:=13 to 25 do
     Begin
        For T:=1 to Column do
        Begin
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)]:=Pics^.SnapShot[Count];
           Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)+1]:=Pics^.SnapShot[Count+1];
           Count:=Count+2;
        End;
        Count:=Start_Count+(160*row);
     End;
     Start_Count:=Start_Count-2;
     Count:=Start_Count2-2;
     RetraceDelay(DelayNumber);
    End;
  End;
End;


Procedure Fx6;
Var
    Count,Start_Count   :integer;
    met,T,row,Column    :Byte;
    Count2,met2         :integer;
    Start_Count2,T_Help :integer;
Begin
  IF Pics<>Nil Then
  Begin
    Count:=158;
    Count2:=160;
    Start_Count2:=160;
    Start_Count:=158;
    T_Help:=80;

    For Column:=1 to 80 do
    Begin
     For row:=1 to 25 do
     Begin
       If (row/2)<>round(row/2) Then
       Begin
          For T:=1 to Column do
          Begin
             Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)]:=Pics^.SnapShot[Count];
             Mem[VideoSeg:BiosColumns*(row-1)+2*(T-1)+1]:=Pics^.SnapShot[Count+1];
             Count:=Count+2;
          End;
          Count:=Start_Count+(160*row);
          RetraceDelay(DelayNumber);
       End
       else

       Begin
          For T:=1 to Column do
          Begin
             Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)]:=Pics^.SnapShot[Count2];
             Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)+1]:=Pics^.SnapShot[Count2+1];
             Count2:=Count2-2;
             T_Help:=T_Help-1;
          End;
          Count2:=Start_Count2+(160*row);
          Count:=Start_Count+(160*row);
          T_Help:=80;
       End;
     End;
     Start_Count:=Start_Count-2;
     Count:=Start_Count;
     Start_Count2:=Start_Count2+2;
     Count2:=Start_Count2;
     RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure Fx7;
Var
   row,Column        :Byte;
   Count,Start_Count :integer;
   T_Help,Start_help :Byte;

Begin
  IF Pics<>Nil Then
  Begin
    Count:=0;
    Start_Count:=0;
    T_Help:=1;
    Start_Help:=1;

    While T_Help<5 do
    Begin
      For row:=1 to 25 do
      Begin
        For Column:=1 to 20 do
        Begin
          Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)]:=Pics^.SnapShot[Count];
          Mem[VideoSeg:BiosColumns*(row-1)+2*(T_help-1)+1]:=Pics^.SnapShot[Count+1];
          Count:=Count+8;
          T_Help:=T_help+4;
        End;
        Count:=Start_Count+(160*row);
        T_Help:=Start_Help;
      End;
      Start_Help:=Start_Help+1;
      Start_Count:=Start_Count+2;
      Count:=Start_Count;
      T_help:=Start_help;
      RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure Fx8;
Var
   CounterX,CounterY :byte;
   Count             :integer;
   row,Column        :Byte;
   Start_Count,Met   :Byte;
   Met2,Help_Count   :Byte;

Begin
  IF Pics<>Nil Then
  Begin
   CounterX:=80;CounterY:=25;
   Count:=0;
   Start_Count:=0;
   met:=1;
   met2:=0;
   While CounterY>0 do
   Begin
       For row:=CounterY to 25 do
       Begin
           For Column:=80 downto CounterX do
           Begin
              Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
              Mem[VideoSeg:BiosColumns*(row-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
              Count:=Count-2;
           End;
           Count:=(160*Met)+Help_Count;
           Met:=Met+1;
       End;
       CounterY:=CounterY-1;
       If CounterY>17 Then
       Begin
          CounterX:=CounterX-4;
          Start_Count:=Start_Count+8;
       End
       else
       Begin
          CounterX:=CounterX-3;
          Start_Count:=Start_Count+6;
       End;
       Count:=Start_Count;
       Help_Count:=Start_Count;
       Met:=1;
       RetraceDelay(DelayNumber);
   End;
  End;
End;

Procedure Fx9;
Var
    row,Column,met,T  :Byte;
    Count,Start_Count :integer;

Begin
  IF Pics<>Nil Then
  Begin
    Met:=1;
    Count:=0;
    Start_Count:=0;
    For row:=25 downto 1 do
    Begin
       From_Down_to_up(row);
       For T:=row to 25 do
       Begin
         For Column:=1 to 80 do
         Begin
            Mem[VideoSeg:BiosColumns*(T-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
            Mem[VideoSeg:BiosColumns*(T-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
            Count:=Count+2;
         End;
         Count:=Start_Count+(160*Met);
         Met:=Met+1;
       End;
       Met:=1;
       Count:=0;
       RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure fx10;
Var
    row,Column,met,T  :Byte;
    Count,Start_Count :integer;

Begin
  IF Pics<>Nil Then
  Begin
    Met:=1;
    Count:=0;
    Start_Count:=0;
    For row:=25 downto 1 do
    Begin
       For T:=row to 25 do
       Begin
         For Column:=1 to 80 do
         Begin
            Mem[VideoSeg:BiosColumns*(T-1)+2*(Column-1)]:=Pics^.SnapShot[Count];
            Mem[VideoSeg:BiosColumns*(T-1)+2*(Column-1)+1]:=Pics^.SnapShot[Count+1];
            Count:=Count+2;
         End;
         Count:=Start_Count+(160*Met);
         Met:=Met+1;
       End;
       Met:=1;
       Count:=0;
       RetraceDelay(DelayNumber);
    End;
  End;
End;

Procedure Fx11;assembler; {SlowBackGround}

{This procedure search first For the color 15     }
{reduce this by 1 and Then search For the color 14}
{reduce this and do this For 15 times             }
{If you want to reduce all colors at the same time}
{Then play with the Variable k.Change this order :}
{   mov dh,k                                      }
{   cmp Attrb,dh to                               }
{   cmp Attrb,0 and delete all the relatives      }

Var
   attrb :byte;
   k     :Byte;
asm;
   mov cx,15
   mov ax,0b800h
   mov es,ax
   mov si,1
   mov k,0fh

@con4:
      push cx
      mov cx,1560
@delayZ:
      loop @delayZ
      mov cx,24
      mov si,1
      dec k
@con3:
     push cx
     mov cx,80
@con1:
   mov bh,es:[si]
   mov bl,bh
   and bh,00001111b
   mov Attrb,bh
   and bl,11110000b
   mov dh,k
   cmp Attrb,dh
   jnz @con2
   Dec Attrb
   add bl,Attrb
   mov es:[si],bl
@con2:
   add si,2
   loop @con1
   pop cx
   loop @con3
   pop cx
   loop @con4

End;
Begin

   IF (Mem[$0040:$0063]=$3B4) or (Mem[$0040:$0049]=7) Then
       VideoSeg:=$B000;
End.