{***************************************************************************}
{UNIT WindowsObj                                                            }
{FileName        :WindowsO.Pas                                              }
{èú®†úÆú† ´†™ ®¶¨´†§ú™ ß¶¨ Æú†®†ù¶§´ò† ´ò ßò®òü¨®ò °ò† ß¶¨ °ò¢ú† ¶          }
{†õ†¶™ ¶ Æ®û©´û™.                                                           }
{***************************************************************************}


UNIT WindowsObj;

INTERFACE

Uses VarConstObj,GeneralObj,SavRstObj,MouseObj,ErrorDlg,Crt;
Const
     WinClip      :Boolean = False;  {Set the Clip On or Off}
     WinClipX1    :Word = 0;
     WinClipY1    :Word = 0;
     WinClipX2    :Word = 0;
     WinClipY2    :Word = 0;

     PushButton   = 1;
     VgaButton    = 2;
     OvalButton   = 3;

     Buttons      = 1;
     RadioButtons = 2;
     CheckBoxes   = 3;
     InputLines   = 4;
     VerScrollBars= 5;
     HorScrollBars= 6;
     MenuBoxes    = 7;
     DropDowns    = 8;
     HelpBoxes    = 9;
     TextBoxes    = 10;

     MoveWin      = 20;
     CloseWin     = 21;

     WTitleTextColor            :Byte = 0;
     WTitleTextBackGround       :Byte = 0;

Type

    CommandsRange = Set Of Byte;

    PStrNode = ^StrNode;
    StrNode  = Record
       Name  :Str40;
       Next  :PStrNode;
    End;

    PMenuNode= ^MenuNode;
    MenuNode = Record
       X1,Y1,
       X2,Y2    :Byte;
       IDByte   :Byte;
       Broadcast:Byte;
       Disabled :Boolean;
       NodePtr  :Pointer;
       Back     :PMenuNode;
       Next     :PMenuNode;
    End;

    PWinFunc  = ^WinFunc;
    WinFunc   = object (WinBasics)
          X1,Y1,X2,Y2               :Byte;    {Coords}
          Title                     :Str40;   {Title}
          CurrentMessageLine        :Str80;   {Message Line for Status line}
          WinCurX,WinCurY           :Byte;    {Current coord from text cursor in the window}
          WinSScanL,WinEScanL       :Byte;    {The height of the text cursor}
          TitleTextColor,                     {Title txt color}
          TitleTextBackground       :Byte;    {Title text background color}
          Params                    :Word;    {Parametres like shadow,move..}
          WinNumber                 :Byte;    {Window number}
          MaskScreen                :^ScreenImage;  {For overlaping}
          WTextColor,WTextBackGround:Byte;     {Window Text and background color}
          HeadMenusSeq,CurMenusSeq  :PMenuNode;{The start object and the current object}
          TailMenusSeq              :PMenuNode;{The last object}
          Next                      :PWinFunc; {Pointer to next window}

          CloseCommand              :Word; {Esc when Pressed}
          EnterCommand              :Word; {Enter When Pressed}

          Procedure Init(InX1,InY1,InX2,InY2 :Byte;InTitle :Str80;InParams :Word);
          Procedure DrawFrameWin;
          Procedure DrawPysFrameWin;
          Procedure DrawIcons;
          Procedure DrawShadowWin;
          Procedure OpenFxWin;
          Procedure CloseFxWin;
          Procedure ClearWin(BackgrColor :Byte);
          Procedure DisplayTitleWin;

          Procedure InitMaskImage;
          Procedure DisposeMaskImage;
          Procedure MakeMaskImage;
          Procedure ShowPartOfShadow(InX1,InY1,InX2,InY2 :Byte);
          Procedure ShowMaskImage;
          Procedure ShowWindowImage;
          Procedure SavePartOfWindowImage(InX1,InY1,InX2,InY2 :Byte);
          Procedure ShowPartOfMaskImage(InX1,InY1,InX2,InY2 :Byte);
          Procedure MoveWin;
          Procedure MoveMsWin;
          Procedure ActivateWin(WindowNumber :Byte);

    End;


    View         = object (WinFunc)
      CommandsArray           :CommandsRange;
      ObjectX1,ObjectY1,
      ObjectX2,ObjectY2       :Byte;

      Procedure   ClearEvent;
      Procedure   AssignXY( InX1, InY1, InX2, InY2 :Byte);

      Procedure   EnableCommand(Cmds  :CommandsRange);
      Procedure   DisableCommand(Cmds :CommandsRange);
      Procedure   EnableAllCommands;
      Procedure   ShowHelpCtx(Point :Str80);
    End;

Const

  ErrorWinFarCallPtr    :Pointer        = Nil;{Call an Error Message <Not enough memory>}
  ErrorWinUserFarCallPtr:Pointer        = Nil;{IF WinCounter =0 and not enougth memory call user}
  ErrorMoveFarCallPtr   :Pointer        = Nil;{Not enough memory to move window}
  DoneWinObjFarCallPtr  :Pointer        = Nil;{Delete all objects in the window}

  Win             :PWinFunc       = Nil;
  WinHead         :PWinFunc       = Nil;
  NewMoreSubsFlag :Byte           = 0;  {Set 1 if we have sub to sub}

Var
     SRVar              :WinBasics;
     HiddenMouse        :Boolean;

     {------- internal varibales for the window movement ------------}

     MoveWColumns,MoveWRows       :Byte;
     MoveWWDOfs,MoveWWDSeg        :Word;
     MoveWOffsetInData            :Word;
     MoveWJumpBytes               :Byte;
     MoveWScreenX,MoveWScreenY    :Byte;
     MoveWOldX1,MoveWOldX2,
     MoveWOldY1,MoveWOldY2        :Byte;
     MoveWNewX1,MoveWNewX2,
     MoveWNewY1,MoveWNewY2        :Byte;

     {---------------------------------------------------------------}

Procedure SetWindowClipOff;
Procedure SetWindowClip(X1,Y1,X2,Y2 :Word);
Procedure WriteVirtWinOut(X1,Y1 :Word; ST:String);
Procedure WriteWindow(X1,Y1 :Word; ST:String);
Procedure WriteVirtWinChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);
Procedure WriteStrAndMark(X1,Y1 :Byte;Title :Str40);
Procedure WriteWithOutMark(X1,Y1 :Byte;Title :Str40);
Procedure CentreWinMessage(YPosit :Byte;Message :String);
Procedure SetVirtCursorPositHeight(X1,Y1,SSL,ESL :Byte);
Procedure SetVirtCursorPosit(X1,Y1 :Byte);

Function  GetWindowMaxX :Byte;
Function  GetWindowMaxY :Byte;

Procedure InterSection(WinSource,WinDest :WinCoord;Var WinInterSection :WinCoord);
Procedure FindWindowInList(WindowNum :Byte;Var WinRecord:PWinFunc);
Procedure ActivateWindow(WindowNumber :Byte);
Procedure ActivateNext;
Procedure OpenWindow(InX1,InY1,InX2,InY2 :Byte;InTitle :Str80;Params :Word);
Procedure CloseWindow;
Procedure MoveWindow;



IMPLEMENTATION

{***************************************************************}
{Procedure Setwindowclipoff                                     }
{Sets the clip off                                              }
{***************************************************************}

Procedure SetWindowClipOff;
Begin
    WinClip:=False;
End;

{**************************************************************}
{Procedure SetWindowClip                                       }
{Sets the clip on                                              }
{**************************************************************}

Procedure SetWindowClip(X1,Y1,X2,Y2 :Word);
Begin
    WinClipX1:=X1;
    WinClipY1:=Y1;
    WinClipX2:=X2;
    WinClipY2:=Y2;
    WinClip:=True;
End;


{************************************************************************}
{Procedure WriteVirtWinOut                                               }
{Write a string onto the video buffer & to MaskScreen for virtual use    }
{************************************************************************}

Procedure WriteVirtWinOut(X1,Y1 :Word; ST:String);
Var
  I,StartOffset,XLength :Word;
  TakeChar              :String[1];
  CX1,CY1               :Word;
  VisClipLen            :Byte;
Begin
    IF WinClip Then
    Begin
         IF (Y1 < (WinClipY1+Win^.Y1)) or (Y1 > (WinClipY2+Win^.Y1)) Then
            Exit;

         IF (X1 > (WinClipX2+Win^.X1)) or ( (X1+Length(St)) < (WinClipX1+Win^.X1)) Then
            Exit;

         IF X1 < (WinClipX1+Win^.X1) Then
         Begin
            X1:=Win^.X1+WinClipX1;
            ST:=Copy(St,WinClipX1,Length(ST));
         End;

         IF ( X1+Length(St) ) > ( WinClipX2+Win^.X1) Then
            ST:=Copy(ST,1,(WinClipX2-WinClipX1)+1);
    End;

    WriteWinOut(X1,Y1,ST);

    IF ( ((Win^.Params and OverLap) = OverLap) Or ((Win^.Params and Movement) = Movement) )
        AND (Win^.MaskScreen <> Nil) Then
    Begin
      CX1:=X1-Win^.X1;
      CY1:=Y1-Win^.Y1;
      XLength:=(Win^.X2-Win^.X1)+1;
      XLength:=XLength shl 1;
      StartOffset:=(CY1*XLength)+(CX1 shl 1);
      For I:=1 to Length(ST) do
      Begin
        TakeChar:=Copy(ST,I,1);
        Win^.MaskScreen^[StartOffset]:=ord(TakeChar[1]);
        Win^.MaskScreen^[StartOffset+1]:=(WriteTextBackGround shl 4) or WriteTextColor;
        Inc(StartOffset,2);
      End;
    End;
End;

Procedure WriteWindow(X1,Y1 :Word; ST:String);
Var
   L    :Byte;
Begin
    L:=Length(ST);
    IF ( (InterMX+1 in [Win^.X1+X1..Win^.X1+X1+L]) or (InterMX+2 in [Win^.X1+X1..Win^.X1+X1+L]) ) AND
       ( (InterMY+1 in [Win^.Y1+Y1..Win^.Y1+Y1]) or (InterMY+2 in [Win^.Y1+Y1..Win^.Y1+Y1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteVirtWinOut(Win^.X1+X1,Win^.Y1+Y1,ST);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

{**************************************************************************}
{Procedure WriteVirtWinChar                                                }
{Writes a character onto the screen & to Screen Mask for virtual use       }
{**************************************************************************}

Procedure WriteVirtWinChar(X1,Y1:Word;InTextColor,InBackgroundColor,InChar :Byte);
Var
  I,StartOffset,XLength :Word;
  CX1,CY1               :Word;
Begin
    IF WinClip Then
    Begin
         IF (Y1 < (WinClipY1+Win^.Y1)) or (Y1 > (WinClipY2+Win^.Y1)) Then
            Exit;

         IF (X1 > (WinClipX2+Win^.X1)) or (X1 < (WinClipX1+Win^.X1)) Then
            Exit;
    End;

    WriteWinChar(X1,Y1,InTextColor,InBackgroundColor,InChar);
    IF (((Win^.Params and OverLap) = OverLap) Or ((Win^.Params and Movement) = Movement))
       AND (Win^.MaskScreen <> Nil) Then
    Begin
      CX1:=X1-Win^.X1;
      CY1:=Y1-Win^.Y1;
      XLength:=(Win^.X2-Win^.X1)+1;
      XLength:=XLength shl 1;
      StartOffset:=(CY1*XLength)+(CX1 shl 1);
      Win^.MaskScreen^[StartOffset]:=InChar;
      Win^.MaskScreen^[StartOffset+1]:=(InBackGroundColor shl 4) or InTextColor;
    End;
End;



{**************************************************************************}
{Procedure WriteStrAndMark                                                 }
{í¨ß‡§ú† ú§ò £¨§û£ò ú¢úöÆ¶§´ò™ ö†ò MarkChar                                }
{**************************************************************************}

Procedure WriteStrAndMark(X1,Y1 :Byte;Title :Str40);
Var
  I                    :Byte;
  TakeChar             :String[1];
  BgColor              :Byte;
  L                    :Byte;
Begin
    L:=Length(Title);
    IF ( (InterMX+1 in [X1..X1+L]) or (InterMX+2 in [X1..X1+L]) ) AND
       ( (InterMY+1 in [Y1..Y1]) or (InterMY+2 in [Y1..Y1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 To Length(Title) do
    Begin
        TakeChar:=Copy(Title,I,1);
        IF TakeChar[1]='~' Then
        Begin
          TakeChar:=Copy(Title,I+1,1);

          IF MarkCharBgColor = $FF Then
             BgColor:=WriteTextBackGround
          Else
             BgColor:=MarkCharBgColor;

          WriteVirtWinChar(X1,Y1,MarkCharFgColor,BgColor,Ord(TakeChar[1]));
          I:=I+1;
        End
        Else
          WriteVirtWinChar(X1,Y1,WriteTextColor,WriteTextBackGround,Ord(TakeChar[1]));

        Inc(X1);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

{**************************************************************************}
{Procedure WriteWithoutMark                                                }
{í¨ß‡§ú† ú§ò £¨§û£ò ú•ò¢û≠¶§´ò™ ´¶ Æò®ò°´û®ò <~>                           }
{**************************************************************************}

Procedure WriteWithOutMark(X1,Y1 :Byte;Title :Str40);
Var
  I                    :Byte;
  TakeChar             :String[1];
  L                    :Byte;
Begin
    L:=Length(Title);
    IF ( (InterMX+1 in [X1..X1+L]) or (InterMX+2 in [X1..X1+L]) ) AND
       ( (InterMY+1 in [Y1..Y1]) or (InterMY+2 in [Y1..Y1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 To Length(Title) do
    Begin
        TakeChar:=Copy(Title,I,1);
        IF TakeChar[1]='~' Then
        Begin
          TakeChar:=Copy(Title,I+1,1);
          WriteVirtWinChar(X1,Y1,WriteTextColor,WriteTextBackGround,Ord(TakeChar[1]));
          I:=I+1;
        End
        Else
          WriteVirtWinChar(X1,Y1,WriteTextColor,WriteTextBackGround,Ord(TakeChar[1]));

        Inc(X1);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

{*******************************************************************}
{Procedure CentreWinMessage                                         }
{âú§´®ò®ú† ú§ò £¨§û£ò °ò† ´¶ ú£≠ò§†ùú† ©´û§ üú©û YPosit ´¶¨         }
{ßò®òü¨®¶¨.                                                         }
{*******************************************************************}

Procedure CentreWinMessage(YPosit :Byte;Message :String);
Var
    XPosit      :Byte;
Begin
    IF Length(Message) >= Win^.X2-Win^.X1 then
    Message:=Copy (Message,1,(Win^.X2-Win^.X1)-1);
    XPosit:=Round ( ( ( Win^.X2-Win^.X1 ) - Length ( Message ) ) / 2 );

    IF ( (InterMX+1 in [Win^.X1+XPosit..Win^.X1+XPosit+Length(Message)]) or
         (InterMX+2 in [Win^.X1+XPosit..Win^.X1+XPosit+Length(Message)]) ) AND
       ( (InterMY+1 in [Win^.Y1+YPosit..Win^.Y1+YPosit]) or (InterMY+2 in [Win^.Y1+YPosit..Win^.Y1+YPosit]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteVirtWinOut(Win^.X1+XPosit,YPosit+Win^.Y1,Message);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;



{***********************************************************************}
{Procedure SetVirtCursorPositHeight                                     }
{Sets Text cursor at a specific position on the screen (Supports Virtual)}
{***********************************************************************}

Procedure SetVirtCursorPositHeight(X1,Y1,SSL,ESL :Byte);
Begin
   IF (X1 <= (BiosColumns div 2)) and (X1 >= SetWindowX1) and (X1 <= SetWindowX2)
      and (Y1 <= (BiosRows)) and (Y1 >= SetWindowY1) and (Y1 <= SetWindowY2) Then
      Begin
          Dec(X1);Dec(Y1);
          SetCurPositionXY(X1,Y1);
          SetCurLength(SSL,ESL);
          Inc(X1);Inc(Y1);
      End
   Else
      CurOff;

   Win^.WinCurX:=X1;
   Win^.WinCurY:=Y1;
   Win^.WinSScanL:=SSL;
   Win^.WinEScanL:=ESL;
End;


{***********************************************************************}
{Procedure SetVirtCursorPosition                                        }
{Sets Text cursor at a specific position on the screen (Supports Virtual)}
{***********************************************************************}

Procedure SetVirtCursorPosit(X1,Y1 :Byte);
Begin
   IF (X1 <= (BiosColumns div 2)) and (X1 >= SetWindowX1) and (X1 <= SetWindowX2)
      and (Y1 <= (BiosRows)) and (Y1 >= SetWindowY1) and (Y1 <= SetWindowY2) Then
   Begin
      Dec(X1);Dec(Y1);
      SetCurPositionXY(X1,Y1);
      Inc(X1);Inc(Y1);
   End
   Else
      CurOff;

   Win^.WinCurX:=X1;
   Win^.WinCurY:=Y1;
End;

{*************************************************************************}
{Function GetWindowMaxX                                                   }
{Ñß†©´®ú≠ú† ´¶ £úö†©´¶ ß¢ò´¶™ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.                    }
{*************************************************************************}

Function GetWindowMaxX :Byte;
Begin
   GetWindowMaxX:=(Win^.X2-Win^.X1)-1;
End;

{*************************************************************************}
{Function GetWindowMaxY                                                   }
{Ñß†©´®ú≠ú† ´¶ £úö†©´¶ ¨Ø¶™ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.                      }
{*************************************************************************}

Function GetWindowMaxY :Byte;
Begin
   GetWindowMaxY:=(Win^.Y2-Win^.Y1)-1;
End;



{*************************************************************************}
{Procedure InterSection                                                   }
{Å®†©°ú† ´û§ ´¶£û õ¨¶ ´ú´®òö‡§‡§ ´¨ß¶¨ WinCoord.Ñò§ õú§ úÆ¶¨§ °òß¶†ò ´¶£û }
{´¶´ú úß†©´®ú≠ú† ´û§ ´†£û $FF ©ú ¶¢ò ´ò ßúõ†ò ´¶¨ WinCoord                }
{*************************************************************************}

Procedure InterSection(WinSource,WinDest :WinCoord;Var WinInterSection :WinCoord);
Var
   I             :Byte;
   XItsOk,YItsOk :Boolean;
Begin
     {Ñò§ ´ò x1,y1,x2,y2 ´¶¨ WinDest õú§ ô®†©°¶§´ò† £ú©ò ©´ò ò§´†©´¶†Æò ´¶¨ }
     {WinSource ´¶´ú ú•¶õ¶™ £ú WinInterSection x1,y1,x2,y2 = 255            }

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


{***********************************************************************}
{Procedure FindWindowInList                                             }
{Å®†°©¶¨£ú £ú©ò ©´û ©¨§õú£ú§û ¢†©´ò úò§ ¨ßò®Æú† ´¶ ßò®òü¨®¶ ß¶¨ ùû´û©ò£ú}
{ö†ò Øò•†£¶.Ñò§ §ò† ´¶ úß†©´®ú≠ú´ò† £ú ´û§ WinRecord úò§ ¶Æ† û WinRecord}
{ú†§ò† Nil                                                              }
{***********************************************************************}

Procedure FindWindowInList(WindowNum :Byte;Var WinRecord:PWinFunc);
Begin
       WinRecord:=WinHead;

       Repeat
           If (WinRecord^.Next<>Nil) and (WinRecord^.WinNumber<>WindowNum) then
              WinRecord:=WinRecord^.Next;

       Until (WinRecord^.WinNumber=WindowNum) OR (WinRecord^.Next=Nil);

       IF WinRecord^.WinNumber<>WindowNum then
          WinRecord:=Nil;

End;

{***************************************************************************}
{Procedure WinFunc.Init                                                     }
{Ä®Æ†°¶ß¶†û©û ´Ø§ £ú´òô¢û´‡§ ´¶¨ ßò®òü¨®¶¨                                  }
{***************************************************************************}

Procedure WinFunc.Init;
Begin
   X1:=InX1;Y1:=InY1;   {Corrdinates}
   X2:=InX2;Y2:=InY2;
   Params:=InParams;    {In line parametres}
   Title:=InTitle;      {window title}
   TitleTextColor:=WinTextColor;  {window title text color}
   TitleTextBackground:=WinTextBackGround;  {window title text background}
   WTextColor:=WinTextColor;   {window text color}
   WTextBackGround:=WinTextBackGround;  {window textbackground}
   HeadMenusSeq:=Nil;    {Objects Head}
   CurMenusSeq:=Nil;     {Current Object}
   TailMenusSeq:=Nil;    {End of Objects}
   MaskScreen:=Nil;      {A virtual Window}
   CurrentMessageLine:='';  {Keep current info bar message}
   WinCurX:=0;WinCurY:=0;   {text cursor X,Y}
   WinSScanL:=$30;WinEScanL:=0;  {text cursor start scan line & end scan line}
   CloseCommand:=0;   {close icon command}
End;


{***************************************************************************}
{Procedure WinFunc.ClearWin                                               }
{ÅòØ†£¶ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨ £ú Æ®‡£ò background ß¶¨ °òü¶®†ùú† û         }
{WinTextBackGround £ú´òô¢û´û                                                }
{***************************************************************************}

Procedure WinFunc.ClearWin;
Var
   I,J  :Byte;
Begin
  For I:=Y1+1 to Y2-1 do
    For J:=X1+1 to X2-1 do
       WriteWinChar(J,I,Win^.WTextColor,Win^.WTextBackGround,32);
End;

{***************************************************************************}
{Procedure WinFunc.DrawFrameWin                                           }
{ëÆúõ†òùú† ´†™ ú•‡´ú®†°ú™ ö®ò££ú™ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.                  }
{ÑÆ¶¨£ú ´®†‡§ ú†õ‡§ ö®ò££ú™ :1)ßòÆ†ú™ ö®ò≠†°‡§ 2)¢úß´ú™ ö®ò≠†°‡§ 3)¶† ú•    }
{¶®†©£¶¨ standard ¢úß´ú™ ö®ò££ú™ ´¶¨ Ascii Code.èò†ù¶¨§ ®¶¢¶ ´ò bit 2,3,4   }
{ - ò®Æ†ù¶§´ò™ òß¶ ´¶ £ûõú§ - ´û™ £ú´òô¢û´û™ Params                         }
{***************************************************************************}


Procedure WinFunc.DrawFrameWin;
Var
   I,J                  :Byte;
   UHL,DHL,ULC,URC,
   LVL,RVL,DLC,DRC      :Byte;
   ColorF               :Byte;
Begin
    {Ñ¢ú§Æ¶™ ö†ò ´¶ ´¨ß‡£ò Æò®ò°´û®‡§}

    If ((Params and WinChars) = WinChars) and (VgaExist) then
    Begin
        UHL:=WCUpHorLine;
        DHL:=WCDnHorLine;
        ULC:=WCUpLfCorner;
        URC:=WCUpRgCorner;
        LVL:=WCLfVerLine;
        RVL:=WCRgVerLine;
        DLC:=WCDnLfCorner;
        DRC:=WCDnRgCorner;
    End
    Else
    IF ((Params and WinChars) = WinChars) and (VgaExist=False) then
       Params:=Params and Not(WinChars);


    If (Params and  OptionChars) = OptionChars then
    Begin
        UHL:=OCUpHorLine;
        DHL:=OCDnHorLine;
        ULC:=OCUpLfCorner;
        URC:=OCUpRgCorner;
        LVL:=OCLfVerLine;
        RVL:=OCRgVerLine;
        DLC:=OCDnLfCorner;
        DRC:=OCDnRgCorner;
    End
    Else
    IF VgaExist=False Then
    Begin
        UHL:=205;{SCUpHorLine;}
        DHL:=205;{SCDnHorLine;}
        ULC:=201;{SCUpLfCorner;}
        URC:=187;{SCUpRgCorner;}
        LVL:=186;{SCLfVerLine;}
        RVL:=186;{SCRgVerLine;}
        DLC:=200;{SCDnLfCorner;}
        DRC:=188;{SCDnRgCorner;}
    End;

     {Ñò§ úÆ¶¨£ú winchars ò¢¢ò ú†§ò† ßò®òü¨®¶ ´¶´ú û ßò§‡ ö®ò££û ú†§ò†}
     {´¶ °ú§¶ #32.To †õ†¶ °ò† ¶† ßò§‡ ö‡§†ú™.                         }
     {Ñß†©û™ ´¶ background color 6 ú†§ò† õú©£ú¨£ú§¶ ö†ò ´¶ Æ®‡£ò ´û™  }
     {¶®†ù¶§´†ò™ ßò§‡ £ßò®ò™.                                         }

     IF (Params and WinCharsWindow) = WinCharsWindow Then
     Begin
         UHL:=32;
         ULC:=32;
         URC:=32;
         ColorF:=TitleTextBackGround;
         IF WTextColor=NotActiveColorFrame Then
            ColorF:=WTextColor;
     End;


     {ëÆúõ†ò©£ò ¶®†ù¶§´†‡§ ö®ò££‡§}


     For I:=X1 to X2 do
     Begin
        IF (Params and WinCharsWindow) = WinCharsWindow Then
            WriteVirtWinChar(I,Y1,0,ColorF,UHL)
        Else
            WriteVirtWinChar(I,Y1,WTextColor,WTextBackground,UHL);
          WriteVirtWinChar(I,Y2,WTextColor,WTextBackground,DHL);
     End;

     {Ñ£≠ò§†©û ö‡§†‡§ úßò§‡ ö®ò££û™}


     IF (Params and WinCharsWindow) = WinCharsWindow Then
     Begin
        WriteVirtWinChar(X1,Y1,WTextColor,ColorF,ULC);
        WriteVirtWinChar(X2,Y1,WTextColor,ColorF,URC);
    End
    Else
    Begin
        WriteVirtWinChar(X1,Y1,WTextColor,WTextBackground,ULC);
        WriteVirtWinChar(X2,Y1,WTextColor,WTextBackground,URC);
    End;

     {Ñ£≠ò§†©û °òüú´‡§ ö®ò££‡§}

     For I:=Y1+1 to Y2-1 do
     Begin
           WriteVirtWinChar(X1,I,WTextColor,WTextBackground,LVL);
           WriteVirtWinChar(X2,I,WTextColor,WTextBackground,RVL);
     End;

     {Ñ£≠ò§†©û ö‡§†‡§ °ò´‡ ö®ò££û™}

     WriteVirtWinChar(X1,Y2,WTextColor,WTextBackground,DLC);
     WriteVirtWinChar(X2,Y2,WTextColor,WTextBackground,DRC);


End;




{***************************************************************************}
{Procedure WinFunc.DrawPysFrameWin                                          }
{ëÆúõ†òùú† ´†™ ú•‡´ú®†°ú™ ö®ò££ú™ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.                  }
{ÑÆ¶¨£ú ´®†‡§ ú†õ‡§ ö®ò££ú™ :1)ßòÆ†ú™ ö®ò≠†°‡§ 2)¢úß´ú™ ö®ò≠†°‡§ 3)¶† ú•    }
{¶®†©£¶¨ standard ¢úß´ú™ ö®ò££ú™ ´¶¨ Ascii Code.èò†ù¶¨§ ®¶¢¶ ´ò bit 2,3,4   }
{ - ò®Æ†ù¶§´ò™ òß¶ ´¶ £ûõú§ - ´û™ £ú´òô¢û´û™ Params                         }
{***************************************************************************}


Procedure WinFunc.DrawPysFrameWin;
Var
   I,J                  :Byte;
   UHL,DHL,ULC,URC,
   LVL,RVL,DLC,DRC      :Byte;
   ColorF               :Byte;
Begin
    {Ñ¢ú§Æ¶™ ö†ò ´¶ ´¨ß‡£ò Æò®ò°´û®‡§}

    If ((Params and WinChars) <> 0) and (VgaExist=True) then
    Begin
        UHL:=WCUpHorLine;
        DHL:=WCDnHorLine;
        ULC:=WCUpLfCorner;
        URC:=WCUpRgCorner;
        LVL:=WCLfVerLine;
        RVL:=WCRgVerLine;
        DLC:=WCDnLfCorner;
        DRC:=WCDnRgCorner;
    End
    Else
    IF ((Params and WinChars) <> 0) and (VgaExist=False) then
       Params:=Params and Not(WinChars);



    If (Params and  OptionChars) <> 0 then
    Begin
        UHL:=OCUpHorLine;
        DHL:=OCDnHorLine;
        ULC:=OCUpLfCorner;
        URC:=OCUpRgCorner;
        LVL:=OCLfVerLine;
        RVL:=OCRgVerLine;
        DLC:=OCDnLfCorner;
        DRC:=OCDnRgCorner;
    End
    Else
    IF VgaExist=False Then
    Begin
        UHL:=205;{SCUpHorLine;}
        DHL:=205;{SCDnHorLine;}
        ULC:=201;{SCUpLfCorner;}
        URC:=187;{SCUpRgCorner;}
        LVL:=186;{SCLfVerLine;}
        RVL:=186;{SCRgVerLine;}
        DLC:=200;{SCDnLfCorner;}
        DRC:=188;{SCDnRgCorner;}
    End;

     {Ñò§ úÆ¶¨£ú winchars ò¢¢ò ú†§ò† ßò®òü¨®¶ ´¶´ú û ßò§‡ ö®ò££û ú†§ò†}
     {´¶ °ú§¶ #32.To †õ†¶ °ò† ¶† ßò§‡ ö‡§†ú™.                         }
     {Ñß†©û™ ´¶ background color 6 ú†§ò† õú©£ú¨£ú§¶ ö†ò ´¶ Æ®‡£ò ´û™  }
     {¶®†ù¶§´†ò™ ßò§‡ £ßò®ò™.                                         }

     IF (Params and WinCharsWindow) = WinCharsWindow Then
     Begin
         UHL:=32;
         ULC:=32;
         URC:=32;
         ColorF:=TitleTextBackGround;
         IF WTextColor=NotActiveColorFrame Then
            ColorF:=WTextColor;
     End;


     {ëÆúõ†ò©£ò ¶®†ù¶§´†‡§ ö®ò££‡§}


     For I:=X1 to X2 do
     Begin
        IF (Params and WinCharsWindow) = WinCharsWindow Then
            WriteWinChar(I,Y1,0,ColorF,UHL)
        Else
            WriteWinChar(I,Y1,WTextColor,WTextBackground,UHL);
          WriteWinChar(I,Y2,WTextColor,WTextBackground,DHL);
     End;

     {Ñ£≠ò§†©û ö‡§†‡§ úßò§‡ ö®ò££û™}


     IF (Params and WinCharsWindow) = WinCharsWindow Then
     Begin
        WriteWinChar(X1,Y1,WTextColor,ColorF,ULC);
        WriteWinChar(X2,Y1,WTextColor,ColorF,URC);
    End
    Else
    Begin
        WriteWinChar(X1,Y1,WTextColor,WTextBackground,ULC);
        WriteWinChar(X2,Y1,WTextColor,WTextBackground,URC);
    End;

     {Ñ£≠ò§†©û °òüú´‡§ ö®ò££‡§}

     For I:=Y1+1 to Y2-1 do
     Begin
           WriteWinChar(X1,I,WTextColor,WTextBackground,LVL);
           WriteWinChar(X2,I,WTextColor,WTextBackground,RVL);
     End;

     {Ñ£≠ò§†©û ö‡§†‡§ °ò´‡ ö®ò££û™}

     WriteWinChar(X1,Y2,WTextColor,WTextBackground,DLC);
     WriteWinChar(X2,Y2,WTextColor,WTextBackground,DRC);


End;


Procedure WinFunc.DrawIcons;
Var
    CloseIconString  : String[4];
Begin
  IF (Params and CloseIcon) = CloseIcon Then
  Begin

    IF (Params and WinChars) = WinChars Then
        CloseIconString:=Chr(WCCloseIcon1)+Chr(WCCloseIcon2)
    Else
        CloseIconString:=Chr(SCCloseIcon1)+Chr(SCCloseIcon2)+Chr(SCCloseIcon3);

    WriteTextColor:=WTextColor;
    WriteTextBackGround:=WTextBackGround;
     IF (Params and WinCharsWindow) = WinCharsWindow Then
     Begin
        IF VgaExist Then
        Begin
         WriteTextColor:=TitleTextBackGround;
         WriteTextBackGround:=0;
        End
        Else
        Begin
         WriteTextColor:=15;
         WriteTextBackGround:=TitleTextBackGround;
        End;
     End;
    WriteVirtWinOut(X1,Y1,CloseIconString);
  End;
End;


{***************************************************************************}
{Procedure WinFunc.DrawShadowWin                                            }
{Ñ£≠ò§†©û ´û™ ©°†ò™ ©´¶ ´®úÆ¶§ ßò®òü¨®¶.Bit 2 òß¶ ´û§ Params                }
{***************************************************************************}

Procedure WinFunc.DrawShadowWin;
Var
    I,J         :Byte;
Begin

     {Ñ£≠ò§†©û ©°†ò™}

     For I:=Y1+1 to Y2+1 do
     Begin
       IF I <= SetWindowY2 Then
       Begin
        IF X2+1 <= SetWindowX2 Then
           Mem[VideoSeg:BiosColumns*(I-1)+2*((X2+1)-1)+1]:=0+(0 shl 4)+8;
        IF X2+2 <= SetWindowX2 Then
           Mem[VideoSeg:BiosColumns*(I-1)+2*((X2+2)-1)+1]:=0+(0 shl 4)+8;
       End;
     End;

     IF Y2 < SetWindowY2 Then
        For I:=X1+2 to X2+2 do
          IF I <= SetWindowX2 Then
            Mem[VideoSeg:BiosColumns*((Y2+1)-1)+2*(I-1)+1]:=0+(0 shl 4)+8;

End;

Procedure WinFunc.OpenFxWin;
Var
   HY1,HY2,HX1,HX2      :Byte;
   UHL,DHL,ULC,URC,
   LVL,RVL,DLC,DRC      :Byte;
   I,AddedDelay         :Byte;
   Snow                 :Boolean;
Begin
    {Ñ¢ú§Æ¶™ ö†ò ´¶ ´¨ß‡£ò Æò®ò°´û®‡§}

    If (Params and WinChars) <> 0 then
    Begin
        UHL:=WCUpHorLine;
        DHL:=WCDnHorLine;
        ULC:=WCUpLfCorner;
        URC:=WCUpRgCorner;
        LVL:=WCLfVerLine;
        RVL:=WCRgVerLine;
        DLC:=WCDnLfCorner;
        DRC:=WCDnRgCorner;
    End
    Else
    If (Params and  OptionChars) <> 0 then
    Begin
        UHL:=OCUpHorLine;
        DHL:=OCDnHorLine;
        ULC:=OCUpLfCorner;
        URC:=OCUpRgCorner;
        LVL:=OCLfVerLine;
        RVL:=OCRgVerLine;
        DLC:=OCDnLfCorner;
        DRC:=OCDnRgCorner;
    End
    Else
    Begin
        UHL:=SCUpHorLine;
        DHL:=SCDnHorLine;
        ULC:=SCUpLfCorner;
        URC:=SCUpRgCorner;
        LVL:=SCLfVerLine;
        RVL:=SCRgVerLine;
        DLC:=SCDnLfCorner;
        DRC:=SCDnRgCorner;
    End;


    {Å®†©°¶¨£ú ´¶ £ú©¶ ´‡§ Æ °ò† Ø}

    HY1:=Y2-1; {(Round( (Y2-Y1)/2 )-1)+Y1;}
    HY2:=Y2;  {HY1+2;}
    HX1:=(Round( (X2-X1)/2 )-1)+X1;
    HX2:=HX1+2;


    IF X2-X1 < 10 Then
       AddedDelay:=30
    Else
    IF X2-X1 < 20 Then
       AddedDelay:=20
    Else
    IF X2-X1 < 60 Then
       AddedDelay:=10
    Else
       AddedDelay:=0;

    Snow:=TextCheckSnow;
    TextCheckSnow:=False;
    Repeat

       For I:=HX1+1 to HX2-1 do
       Begin
           WriteWinChar(I,HY1,WTextColor,WTextBackGround,32);
           WriteWinChar(I,HY2,WTextColor,WTextBackGround,32);
        end;

        For I:=HY1 to HY2 do
        begin
           WriteWinChar(HX1+1,I,WTextColor,WTextBackGround,32);
           WriteWinChar(HX2-1,I,WTextColor,WTextBackGround,32);
        end;


{        Show Lines while drawing zoom fx window
        ---------------------------------------

        For  I:=HX1 to HX2 do
        Begin
           WriteWinChar(I,HY1,WTextColor,WTextBackGround,UHL);
           WriteWinChar(I,HY2,WTextColor,WTextBackGround,DHL);
        End;

        For i:=HY1 to HY2 do
        Begin
           WriteWinChar(HX1,I,WTextColor,WTextBackGround,LVL);
           WriteWinChar(HX2,I,WTextColor,WTextBackGround,RVL);
        End;

        WriteWinChar(HX1,HY1,WTextColor,WTextBackGround,ULC);
        WriteWinChar(HX2,HY1,WTextColor,WTextBackGround,URC);
        WriteWinChar(HX1,HY2,WTextColor,WTextBackGround,DLC);
        WriteWinChar(HX2,HY2,WTextColor,WTextBackGround,DRC);
}
        Dec(HY1);
{       Inc(HY2);}
        Dec(HX1);
        Inc(HX2);

        If HY1<Y1+1 then
           HY1:=Y1+1;
{        If HY2>Y2 then
           HY2:=Y2;}
        If HX1<x1 then
           HX1:=X1;
        If HX2>X2 then
           HX2:=X2;

         RetraceDelay(WindowDelay+AddedDelay);


    Until (Hx2=X2) {and (Hy2=Y2)} and (Hx1=X1) and (Hy1=Y1+1);
    TextCheckSnow:=Snow;
End;

Procedure WinFunc.CloseFxWin;
Var
   HY1,HY2,HX1,HX2      :Byte;
   UHL,DHL,ULC,URC,
   LVL,RVL,DLC,DRC      :Byte;
   I,VerCenter,HorCenter:Byte;
   HLineLength          :Byte;
   Index,SnapShotSeg,
   SnapShotOfs,StartX   :Word;
   AddedDelay           :Byte;
   Snow                 :Boolean;
Begin
    {Ñ¢ú§Æ¶™ ö†ò ´¶ ´¨ß‡£ò Æò®ò°´û®‡§}

    If (Params and WinChars) <> 0 then
    Begin
        UHL:=WCUpHorLine;
        DHL:=WCDnHorLine;
        ULC:=WCUpLfCorner;
        URC:=WCUpRgCorner;
        LVL:=WCLfVerLine;
        RVL:=WCRgVerLine;
        DLC:=WCDnLfCorner;
        DRC:=WCDnRgCorner;
    End
    Else
    If (Params and  OptionChars) <> 0 then
    Begin
        UHL:=OCUpHorLine;
        DHL:=OCDnHorLine;
        ULC:=OCUpLfCorner;
        URC:=OCUpRgCorner;
        LVL:=OCLfVerLine;
        RVL:=OCRgVerLine;
        DLC:=OCDnLfCorner;
        DRC:=OCDnRgCorner;
    End
    Else
    Begin
        UHL:=SCUpHorLine;
        DHL:=SCDnHorLine;
        ULC:=SCUpLfCorner;
        URC:=SCUpRgCorner;
        LVL:=SCLfVerLine;
        RVL:=SCRgVerLine;
        DLC:=SCDnLfCorner;
        DRC:=SCDnRgCorner;
    End;

    HY1:=Y1;HY2:=Y2;
    HX1:=X1;HX2:=X2;
    HorCenter:=Round( (X2-X1)/2 );
    HorCenter:=X1+HorCenter;
    VerCenter:=Round( (Y2-Y1) /2 );
    VerCenter:=VerCenter+Y1;

    SnapShotSeg:=Seg(SnapShot^);
    SnapShotOfs:=Ofs(SnapShot^);
    HLineLength:=((BX2-BX1)+1)*2;

    IF (Params and Shadow) <> 0 Then
    Begin
      Index:=((Y2-Y1)+1) * HLineLength;


      {E•ò£≠ò§†©û ´û™ ¶®†ù¶§´†ò™ ©°†ò™}

      For I:=X1 to X2+2 do
      Begin
         WriteWinChar(I,Y2+1,SnapShot^[Index+1] and $0F,(SnapShot^[Index+1] and $F0) shr 4,SnapShot^[Index]);
         Index:=Index+2;
      End;

      {Ñ•ò£≠ò§†©û ´û™ °òüú´û™ ©°†ò™}

      Index:=HLineLength-4;
      For I:=Y1 to Y2 do
      Begin
         WriteWinChar(BX2-1,I,SnapShot^[Index+1] and $0F,(SnapShot^[Index+1] and $F0) shr 4,SnapShot^[Index]);
         Index:=Index+2;
         WriteWinChar(BX2,I,SnapShot^[Index+1] and $0F,(SnapShot^[Index+1] and $F0) shr 4,SnapShot^[Index]);
         Index:=Index+HLineLength-2;
      End;
    End;

    IF X2-X1 < 10 Then
       AddedDelay:=30
    Else
    IF X2-X1 < 20 Then
       AddedDelay:=20
    Else
    IF X2-X1 < 40 Then
       AddedDelay:=10
    Else
       AddedDelay:=0;

    Snow:=TextCheckSnow;
    TextCheckSnow:=False;
    Repeat
 {
        Show Drawings lines while zooming fxs
        --------------------------------------

        For  I:=HX1 to HX2 do
        Begin
           WriteWinChar(I,HY1,WTextColor,WTextBackGround,UHL);
           WriteWinChar(I,HY2,WTextColor,WTextBackGround,DHL);
        End;

        For I:=HY1 to HY2 do
        Begin
           WriteWinChar(HX1,I,WTextColor,WTextBackGround,LVL);
           WriteWinChar(HX2,I,WTextColor,WTextBackGround,RVL);
        End;

        WriteWinChar(HX1,HY1,WTextColor,WTextBackGround,ULC);
        WriteWinChar(HX2,HY1,WTextColor,WTextBackGround,URC);
        WriteWinChar(HX1,HY2,WTextColor,WTextBackGround,DLC);
        WriteWinChar(HX2,HY2,WTextColor,WTextBackGround,DRC);
}
        {Ü úßò§‡ ö®ò££û}

        IF HY1<HY2 {VerCenter-1} Then
        Begin
          Index:=(HY1-Y1) * HLineLength;
          For I:=X1 to X2 do
          Begin
            WriteWinChar(I,HY1,(SnapShot^[Index+1] and $0F),((SnapShot^[Index+1] and $F0) shr 4),SnapShot^[Index]);
            Index:=Index+2;
          End;
        End;


        {Ü °ò´‡ ö®ò££û}

{        IF HY2>VerCenter+1 Then
        Begin
          Index:=(HY2-Y1) * HLineLength;
          For I:=X1 to X2 do
          Begin
            WriteWinChar(I,HY2,SnapShot^[Index+1] and $0F,((SnapShot^[Index+1] and $F0) shr 4),SnapShot^[Index]);
            Index:=Index+2;
          End;
        End;
}
        IF HX1<HorCenter-1 Then
        Begin
          Index:=(HX1-X1)*2;
          For I:=Y1 to Y2 do
          Begin
            WriteWinChar(HX1,I,SnapShot^[Index+1] and $0F,((SnapShot^[Index+1] and $F0) shr 4),SnapShot^[Index]);
            Index:=Index+HLineLength;
          End;
        End;

        IF HX2>HorCenter+1 Then
        Begin
          Index:=(HX2-X1)*2;
          For I:=Y1 to Y2 do
          Begin
            WriteWinChar(HX2,I,SnapShot^[Index+1] and $0F,(SnapShot^[Index+1] and $F0) shr 4,SnapShot^[Index]);
            Index:=Index+HLineLength;
          End;
        End;

        HY1:=HY1+1;
{        HY2:=HY2-1;}
        HX1:=HX1+1;
        HX2:=HX2-1;

        IF HY1>=HY2 {VerCenter-1} then
            HY1:=HY2 {VerCenter-1};
{        IF HY2<=VerCenter+1 then
            HY2:=VerCenter+1;}
        IF HX1>=HorCenter then
            HX1:=HorCenter;
        IF HX2<=HorCenter then
            HX2:=HorCenter;

        RetraceDelay(WindowDelay+AddedDelay);

    Until (Hx2=HorCenter) and {(Hy2=VerCenter+1)} (Hx1=HorCenter) and (Hy1=HY2 {VerCenter-1});
    TextCheckSnow:=Snow;
End;

{***************************************************************************}
{Procedure WinFunc.DisplayTitleWin                                        }
{Ñ£ò§†©û ´¶¨ ´†´¢¶¨ (Title variable) ©´û§ úßò§‡ üú©û ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨}
{ëú ßú®†ß´‡©û ß¶¨ ¶ ´†´¢¶™ ú†§ò† £úöò¢¨´ú®¶™ òß¶ ´¶ ßò®òü¨®¶,òß¶°¶ß´ú´ò†    }
{***************************************************************************}

Procedure WinFunc.DisplayTitleWin;
Var
    TitleOfs      :Byte;
    InTitle       :Str80;
    SaveTColor,
    SaveBColor    :Byte;
Begin
    IF Title='' Then
       Exit;

    SaveTColor:=WriteTextColor;
    SaveBColor:=WriteTextBackGround;

    InTitle:=Title;
    IF Length(InTitle) > X2-X1 then
       InTitle:=Copy (Title,1,(X2-X1)-2);
    TitleOfs:=Round ( ( ( X2-X1 ) - Length ( InTitle ) ) / 2 );
    WriteTextColor:=WTextColor;
    WriteTextBackground:=WTextBackground;
    IF (WinCharsWindow and Params) = WinCharsWindow Then
    Begin
        WriteTextColor:=TitleTextColor;
        WriteTextBackGround:=TitleTextBackGround;
    End;
    WriteVirtWinOut(X1+TitleOfs,Y1,InTitle);

    WriteTextColor:=SaveTColor;
    WriteTextBackGround:=SaveBColor;
End;



{***********************************************************************}
{Procedure ActivateWindow                                               }
{âò§ú† ´†™ °ò´ò¢¢û¢ú™ õ†òõ†°òõ†ú™ ‡©´ú §ò ú§ú®ö¶ß¶†û©ú† ´¶ ¶ß¶†¶õûß¶´ú  }
{ßò®òü¨®¶ ß¶¨ úÆú† ûõû ò§¶†Æ´ú†                                         }
{***********************************************************************}

Procedure WinFunc.ActivateWin(WindowNumber :Byte);
Var
   CheckIfNilWin        :PWinFunc;
   ComparableWin        :PWinFunc;
   NumInTheList         :Byte;
   I                    :Byte;
   Source,Dest,Intersec :WinCoord;

Begin

     FindWindowInList(WindowNumber,CheckIfNilWin);
     IF CheckIfNilWin<>Nil Then
     Begin
        HiddenMouseCursor;
        CopyPage0ToPageX(2);
        SetVideoPage(2);

        MakeMaskImage;        {Save the previous PIC window}
        Win:=CheckIfNilWin;   {Win:=The new window}
        Win^.ShowWindowImage; {Show the saved area of the new window}
                              {Now find the position of the new window}
                              {in the list of windows}
        I:=1;
        While (WinLayer[I]<>WindowNumber) and (I<>WindowCounter+1) do
               Inc(I);

        IF (I<>WindowCounter+1) and
              (WinLayer[I]<>WinLayer[WindowCounter]) Then   {If the number exist in the list}
        Begin
            NumInTheList:=I;

            Source.X1:=Win^.BX1;
            Source.Y1:=Win^.BY1;
            Source.X2:=Win^.BX2;
            Source.Y2:=Win^.BY2;

            For I:=NumInTheList+1 to WindowCounter do
            Begin
                FindWindowInList(WinLayer[I],ComparableWin);
                Dest.X1:=ComparableWin^.BX1;
                Dest.Y1:=ComparableWin^.BY1;
                Dest.X2:=ComparableWin^.BX2;
                Dest.Y2:=ComparableWin^.BY2;

                InterSection(Source,Dest,Intersec);

                IF Intersec.X1<>$FF Then
                    With Intersec do
                    Begin
                      ComparableWin^.SavePartOfWindowImage(X1,Y1,X2,Y2);
                      ComparableWin^.ShowPartOfMaskImage(X1,Y1,X2,Y2);
                      IF (Params and Shadow) <> 0 Then
                          ComparableWin^.ShowPartOfShadow(X1,Y1,X2,Y2);
                    End;

             End;

            Win^.SavePartOfWindowImage(Source.X1,Source.Y1,Source.X2,Source.Y2);
            Win^.ShowMaskImage;
            IF (Params and Shadow) <> 0 Then
                Win^.DrawShadowWin;
            TopWindow:=WindowNumber;
            For I:=NumInTheList to WindowCounter-1 do
                WinLayer[I]:=WinLayer[I+1];
            WinLayer[WindowCounter]:=WindowNumber;
        End;
        SetVideoPage(0);
        ShowMouseCursor;
     End;

End;

Procedure ActivateWindow(WindowNumber :Byte);
Var
   T    :View;
Begin
    IF (Win^.Params and OverLap) <> 0 Then
    Begin
        CurOff;

        WinTextColor:=Win^.WTextColor;
        Win^.WTextColor:=NotActiveColorFrame;
        Win^.DrawFrameWin;
        Win^.WTextColor:=WinTextColor;

        Win^.ActivateWin(WindowNumber);

        SetCurLength(Win^.WinSScanL,Win^.WinEScanL);
        SetCurPositionXY(Win^.WinCurX+1,Win^.WinCurY+1);

        Win^.DrawFrameWin;
        Win^.DisplayTitleWin;
        Win^.DrawIcons;
        T.ShowHelpCtx(Win^.CurrentMessageLine);
    End;
End;

Procedure ActivateNext;
Var
   T    :View;
Begin
    IF ((Win^.Params and OverLap) <> 0) And (WindowCounter>1) Then
    Begin

        CurOff;
        WinTextColor:=Win^.WTextColor;
        Win^.WTextColor:=NotActiveColorFrame;
        Win^.DrawFrameWin;
        Win^.WTextColor:=WinTextColor;

        Win^.ActivateWin(WinLayer[1]);

        IF Win^.WinCurX<>255 Then
        Begin
          SetCurLength(Win^.WinSScanL,Win^.WinEScanL);
          SetCurPositionXY(Win^.WinCurX+1,Win^.WinCurY+1);
        End;

        Win^.DrawFrameWin;
        Win^.DisplayTitleWin;
        Win^.DrawIcons;
        T.ShowHelpCtx(Win^.CurrentMessageLine);
    End;
End;

Procedure WinFunc.InitMaskImage;
Begin
    MaskScreen:=EdsGetMem(MaskScreen,WinSize);
    IF HeapErrorCode=1 Then
    Begin
       MaskScreen:=Nil;
       Win^.Params:=Win^.Params and Not(OverLap);
       Win^.Params:=Win^.Params and Not(Movement);
    End;
End;
{************************************************************************}
{Procedure MakeMaskImage                                                 }
{âò´ò§¶£û ©´û§ £§û£û °ò† öú£†©£ò ´û™ £ò©°ò™ ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.     }
{âò¢ú†´ò† ©¨§ûü‡™ òß¶ ´û§ Procedure OpenWindow.                          }
{************************************************************************}

Procedure WinFunc.MakeMaskImage;
Var
   I,J,Index    :Word;
Begin

  IF MaskScreen <> Nil Then
  Begin
    IF ( (InterMX+1 in [X1..X2]) or (InterMX+2 in [X1..X2]) ) AND
       ( (InterMY+1 in [Y1..Y2]) or (InterMY+2 in [Y1..Y2]) ) Then
    Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
    End;

    Index:=0;
    For I:=Y1 to Y2 do
       For J:=X1 to X2 do
       Begin
          MaskScreen^[Index]:=Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)];
          MaskScreen^[Index+1]:=Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)+1];
          Inc(Index);
          Inc(Index);
       End;
    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
  End;
End;

Procedure WinFunc.ShowMaskImage;
Var
   I,J,Index    :Word;
Begin
  IF MaskScreen<>Nil Then
  Begin
    IF ( (InterMX+1 in [X1..X2]) or (InterMX+2 in [X1..X2]) ) AND
       ( (InterMY+1 in [Y1..Y2]) or (InterMY+2 in [Y1..Y2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;
    Index:=0;
    For I:=Y1 to Y2 do
       For J:=X1 to X2 do
       Begin
          Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)]:=MaskScreen^[Index];
          Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)+1]:=MaskScreen^[Index+1];
          Inc(Index);
          Inc(Index);
       End;
    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

  End;
End;

Procedure WinFunc.ShowPartOfShadow(InX1,InY1,InX2,InY2 :Byte);
Var
  I,J           :Byte;
Begin
     IF ( (InterMX+1 in [InX1..InX2]) or (InterMX+2 in [InX1..InX2]) ) AND
        ( (InterMY+1 in [InY1..InY2]) or (InterMY+2 in [InY1..InY2]) ) Then
     Begin
        HiddenMouseCursor;
        HiddenMouse:=True;
     End;
     For I:=Y1+1 to Y2+1 do
       IF (I in [InY1..InY2]) and (X2 in [InX1..InX2]) Then
       Begin
        Mem[VideoSeg:BiosColumns*(I-1)+2*((X2+1)-1)+1]:=0+(0 shl 4)+8;
        Mem[VideoSeg:BiosColumns*(I-1)+2*((X2+2)-1)+1]:=0+(0 shl 4)+8;
       End;

     For I:=X1+2 to X2+2 do
       IF (I in [InX1..InX2]) and (Y2 in [InY1..InY2]) Then
         Mem[VideoSeg:BiosColumns*((Y2+1)-1)+2*(I-1)+1]:=0+(0 shl 4)+8;
     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;
End;

Procedure WinFunc.ShowWindowImage;
Var
   I,J,Index    :Word;
Begin
  IF SnapShot<>Nil Then
  Begin
    IF ( (InterMX+1 in [BX1..BX2]) or (InterMX+2 in [BX1..BX2]) ) AND
       ( (InterMY+1 in [BY1..BY2]) or (InterMY+2 in [BY1..BY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;
    Index:=0;
    For I:=BY1 to BY2 do
       For J:=BX1 to BX2 do
       Begin
          Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)]:=SnapShot^[Index];
          Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)+1]:=SnapShot^[Index+1];
          Inc(Index);
          Inc(Index);
       End;
    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
  End;
End;

Procedure WinFunc.SavePartOfWindowImage(InX1,InY1,InX2,InY2 :Byte);
Var
  J,I       :Byte;
  Index     :Word;
  JumpBytes :Word;
Begin
   IF SnapShot<>Nil Then
   Begin
       IF ( (InterMX+1 in [InX1..InX2+2]) or (InterMX+2 in [InX1..InX2+2]) ) AND
          ( (InterMY+1 in [InY1..InY2+2]) or (InterMY+2 in [InY1..InY2+2]) ) Then
       Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
       End;
       Index:=(InX1-BX1)*2;
       JumpBytes:=(((BX2-InX2)*2)+Index);
       Index:=Index+( (InY1-BY1)*(((BX2-BX1)+1)*2) );
       For I:=InY1 to InY2 do
       Begin
         For J:=InX1 to InX2 do
         Begin
            SnapShot^[Index]:=Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)];
            SnapShot^[Index+1]:=Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)+1];
            Inc(Index);
            Inc(Index);
         End;
         Index:=Index+JumpBytes;
       End;
       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;
   End;
End;

Procedure WinFunc.ShowPartOfMaskImage(InX1,InY1,InX2,InY2 :Byte);
Var
  J,I       :Byte;
  Index     :Word;
  JumpBytes :Word;
Begin
  IF MaskScreen<>Nil Then
  Begin
       IF ( (InterMX+1 in [InX1..InX2+2]) or (InterMX+2 in [InX1..InX2+2]) ) AND
          ( (InterMY+1 in [InY1..InY2+2]) or (InterMY+2 in [InY1..InY2+2]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;
       IF InX2>X2 Then
          InX2:=X2;
       IF InY2>Y2 Then
          InY2:=Y2;
       Index:=(InX1-X1)*2;
       JumpBytes:=(((X2-InX2)*2)+Index);
       Index:=Index+( (InY1-Y1)*(((X2-X1)+1)*2) );
       For I:=InY1 to InY2 do
       Begin
         For J:=InX1 to InX2 do
         Begin
            Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)]:=MaskScreen^[Index];
            Mem[VideoSeg:BiosColumns*(I-1)+2*(J-1)+1]:=MaskScreen^[Index+1];
            Inc(Index);
            Inc(Index);
         End;
         Index:=Index+JumpBytes;
       End;
       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;
  End;
End;
{***********************************************************************}
{Procedure DisposeMaskImage                                             }
{Aßú¢ú¨üú®‡§ú† òß¶ ´û§ £§û£û ´¶ °¶££ò´† ß¶¨ ú†Æò£ú õú©£ú¨©ú† £ú ´û§     }
{procedure InitMaskImage                                                }
{***********************************************************************}

Procedure WinFunc.DisposeMaskImage;
Begin
   IF MaskScreen<>Nil Then
      FreeMem(MaskScreen,WinSize);
    MaskScreen:=Nil;
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
     Var
        TraceX,TraceX1,TraceY   :Word;
     Asm;

          xor ah,ah
          mov al,MoveWScreenX
          mov TraceX,ax
          mov TraceX1,ax

          mov al,MoveWScreenY
          mov TraceY,ax

          mov bh,MoveWRows  {How many lines     BH }

          mov bl,MoveWColumns  {How many MoveWColumns,  BL }

          xor dh,dh
          mov dl,MoveWScreenY
          mov ax,BiosColumns
          mul dx
          mov dx,ax

   @AddMoveWColumns:
           xor ax,ax
           mov al,MoveWScreenX
           shl al,1          {mul x2 CharByte+AttributeByte}
           add dx,ax         {Now we have the final offset    }

           mov si,dx
           mov di,MoveWWDOfs
           mov ax,MoveWOffsetInData
           add di,ax


           xor cx,cx
           mov cl,bh

   @Lo1:

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

           push cx
           xor cx,cx
           mov cl,bl
   @Lo2:

           mov ax,VideoSeg
           mov es,ax
           mov ax,es:[si]

           push ax
           mov ax,MoveWWDSeg
           mov es,ax
           pop ax
           mov es:[di],ax

           inc si
           inc si
           inc di
           inc di
           inc TraceX

           loop @Lo2

           add dx,BiosColumns
           mov si,dx

           xor ax,ax
           mov al,MoveWJumpBytes
           add di,ax

           mov ax,TraceX1
           mov TraceX,ax
           inc TraceY


           pop cx
           loop @Lo1
@CancelXLoop:

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

   mov al,MoveWOldX1
   cmp MoveWNewX1,al
   ja  @RightMove
   jb  @LeftMove

   jmp @CheckYMove

@RightMove:
         {-------------------- Right X Move ---------------}

   mov LeftOrRight,0FFh

   mov al,MoveWOldX2          {Check if we have a whole move of the window}
   cmp MoveWNewX1,al
   ja  @SetValue
   jmp @EverythingOk  {No ? Then go ahead}

@SetValue:            {If we have a whole move then do these}
   mov al,MoveWOldX2
   sub al,MoveWOldX1
   inc al
   mov MoveWColumns,al
   mov WholeMove,0FFh  {It's a Flag that means that we have a whole move}
   jmp @Continue1

@EverythingOk:

   mov al,MoveWNewX1
   sub al,MoveWOldX1        {Now al:=NewX1-OldX1 = XDif}
   mov MoveWColumns,al   {The total MoveWColumns}


@Continue1:
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al  {The toal MoveWRows}


   mov MoveWJumpBytes,0
   mov MoveWOffsetInData,0
   mov al,MoveWColumns
   mov Xoffset,al

   cmp WholeMove,0FFh
   jz  @EndRight

   mov ah,MoveWColumns
   add ah,MoveWOldX1          {AH:=MoveWOldX1+MoveWColumns}
   mov al,MoveWOldX2
   sub al,ah          {AL:=MoveWOldX2-AH}
   inc al             {Inc the result}
   shl al,1           {mul the result x2 because attribute byte}
   mov MoveWJumpBytes,al
   xor ah,ah
   mov MoveWOffsetInData,ax

@EndRight:

   mov al,MoveWNewX2
   mov ah,MoveWColumns
   dec ah
   sub al,ah
   dec al
   mov MoveWScreenX,al

   mov al,MoveWNewY1
   dec al
   mov MoveWScreenY,al

   pushf
   Call ReadFromScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove

@LeftMove:
         {--------------------- Left X Move ---------------}


   mov al,MoveWOldX1          {Check if we have a whole move of the window}
   cmp MoveWNewX2,al
   jb  @SetValueL
   jmp @EverythingOkL  {No ? Then go ahead}

@SetValueL:            {If we have a whole move then do these}
   mov al,MoveWOldX2
   sub al,MoveWOldX1
   inc al
   mov MoveWColumns,al
   mov WholeMove,0FFh  {It's a Flag that means that we have a whole move}
   jmp @Continue2

@EverythingOkL:

   mov al,MoveWOldX1
   sub al,MoveWNewX1        {Now al:=OldX1-NewX1 = XDif}
   mov MoveWColumns,al   {The total MoveWColumns}


@Continue2:
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al  {The toal MoveWRows}


   mov MoveWJumpBytes,0
   mov MoveWOffsetInData,0
   mov al,MoveWColumns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndLeft

   mov ah,MoveWColumns
   add ah,MoveWOldX1          {AH:=MoveWOldX1+MoveWColumns}
   mov al,MoveWOldX2
   sub al,ah          {AL:=MoveWOldX2-AH}
   inc al             {Inc the result}
   shl al,1           {mul the result x2 because attribute byte}
   mov MoveWJumpBytes,al

@EndLeft:

   mov al,MoveWNewX1
   dec al
   mov MoveWScreenX,al

   mov al,MoveWNewY1
   dec al
   mov MoveWScreenY,al

   pushf
   Call ReadFromScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove


   {=======================  Y MOVE OFFSET ============================}

@CheckYMove:

   mov al,MoveWOldY1
   cmp MoveWNewY1,al
   ja  @DownMove
   jb  @UpMove

   jmp @NoYMove


@DownMove:
      {-------------------- Down Y Move --------------------}

   mov al,MoveWOldY2          {Check if we have a whole move of the window}
   cmp MoveWNewY1,al
   ja  @SetValueD
   jmp @EveryThingOkD      {No ? Then go ahead}

@SetValueD:            {If we have a whole move then do these}
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al
   mov WholeMove,0FFh
   jmp @Continue3

@EveryThingOkD:
   mov al,MoveWNewY1
   sub al,MoveWOldY1
   mov MoveWRows,al  {The total MoveWRows}

@Continue3:

   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndDown

   mov dl,XOffset
   shl dl,1
   mov MoveWJumpBytes,dl    {Jump Bytes}

   mov dl,MoveWNewY2
   mov dh,MoveWNewY1
   sub dl,dh
   inc dl              {How many MoveWRows in total}
   sub dl,MoveWRows

   mov al,MoveWNewX2
   mov ah,MoveWNewX1
   sub al,ah
   inc al
   mov cl,al           {Keep Line length temp to CL}
   shl al,1            {One line length -in bytes-}

   xor ah,ah
   mul dl              {We reached to the desired row}

   cmp LeftOrRight,0FFh
   jz  @NoMoveWColumnsToAdd

   xor dh,dh
   mov dl,MoveWJumpBytes
   add ax,dx


@NoMoveWColumnsToAdd:
   mov MoveWOffsetInData,ax

   sub cl,XOffset     {Take Line Length from cl}
   mov MoveWColumns,cl


@EndDown:

   mov al,MoveWOldX1
   dec al

   cmp LeftOrRight,0h
   jz  @Go1

   mov ah,MoveWJumpBytes
   shr ah,1
   add al,ah

@Go1:
   mov MoveWScreenX,al

   mov al,MoveWNewY2
   dec al
   mov ah,MoveWRows
   dec ah
   sub al,ah
   mov MoveWScreenY,al

   pushf
   Call ReadFromScreen



   jmp @NoYMove
@UpMove:
      {-------------------- Up Y Move -----------------------}

   mov al,MoveWNewY2          {Check if we have a whole move of the window}
   cmp MoveWOldY1,al
   ja  @SetValueU
   jmp @EveryThingOkU      {No ? Then go ahead}

@SetValueU:            {If we have a whole move then do these}
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al
   mov WholeMove,0FFh
   jmp @Continue4

@EveryThingOkU:
   mov al,MoveWOldY1
   sub al,MoveWNewY1
   mov MoveWRows,al  {The total MoveWRows}

@Continue4:

   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndUp

   mov dl,XOffset
   shl dl,1
   mov MoveWJumpBytes,dl    {Jump Bytes}
   mov ax,0

   cmp LeftOrRight,0FFh
   jz  @NoMoveWColumnsToAdMoveWNewY1

   xor dh,dh
   mov dl,MoveWJumpBytes
   add ax,dx


@NoMoveWColumnsToAdMoveWNewY1:
   mov MoveWOffsetInData,ax

   mov dh,MoveWNewX2
   mov dl,MoveWNewX1
   sub dh,dl
   inc dh
   sub dh,XOffset
   mov MoveWColumns,dh


@EndUp:

   mov al,MoveWOldX1
   dec al

   cmp LeftOrRight,0h
   jz  @Go2

   mov ah,MoveWJumpBytes
   shr ah,1
   add al,ah

@Go2:
   mov MoveWScreenX,al


   mov al,MoveWOldY1
   dec al
   sub al,MoveWRows
   mov MoveWScreenY,al

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
     Var
        TraceX,TraceX1,TraceY   :Word;
     Asm;

          xor ah,ah
          mov al,MoveWScreenX
          mov TraceX,ax
          mov TraceX1,ax

          mov al,MoveWScreenY
          mov TraceY,ax


          mov bh,MoveWRows  {How many lines     BH }

          mov bl,MoveWColumns  {How many MoveWColumns,  BL }

          {==== Find physical address into video buffer ====}

          xor dh,dh
          mov dl,MoveWScreenY
          mov ax,BiosColumns
          mul dx
          mov dx,ax



   @AddMoveWColumns:
           xor ax,ax
           mov al,MoveWScreenX
           shl al,1          {mul x2 CharByte+AttributeByte}
           add dx,ax         {Now we have the final offset    }

           mov si,dx
           mov di,MoveWWDOfs
           add di,MoveWOffsetInData

           xor cx,cx
           mov cl,bh

   @Lo1:
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

           push cx
           xor cx,cx
           mov cl,bl
   @Lo2:
           mov ax,MoveWWDSeg
           mov es,ax
           mov ax,es:[di]

           push ax
           mov ax,VideoSeg
           mov es,ax
           pop ax
           mov es:[si],ax

           inc si
           inc si
           inc di
           inc di
           inc TraceX

           loop @Lo2

           add dx,BiosColumns
           mov si,dx

           xor ax,ax
           mov al,MoveWJumpBytes
           add di,ax

           mov ax,TraceX1
           mov TraceX,ax

           inc TraceY

           pop cx
           loop @Lo1

@CancelXLoop:
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

   mov al,MoveWOldX1
   cmp MoveWNewX1,al
   ja  @RightMove
   jb  @LeftMove

   jmp @CheckYMove

@RightMove:
         {-------------------- Right X Move ---------------}

   mov LeftOrRight,0FFh

   mov al,MoveWOldX2          {Check if we have a whole move of the window}
   cmp MoveWNewX1,al
   ja  @SetValue
   jmp @EverythingOk  {No ? Then go ahead}

@SetValue:            {If we have a whole move then do these}
   mov al,MoveWOldX2
   sub al,MoveWOldX1
   inc al
   mov MoveWColumns,al
   mov WholeMove,0FFh
   jmp @Continue1

@EverythingOk:

   mov al,MoveWNewX1
   sub al,MoveWOldX1        {Now al:=NewX1-OldX1 = XDif}
   mov MoveWColumns,al   {The total MoveWColumns}


@Continue1:
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al  {The toal MoveWRows}


   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0
   mov al,MoveWColumns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndRight

   mov ah,MoveWColumns
   add ah,MoveWOldX1         { AH:=MoveWOldX1+MoveWColumns}
   mov al,MoveWOldX2
   sub al,ah         { AL:=MoveWOldX2-AH}
   inc al            { Inc the result}
   shl al,1          { mul the result x2 because attribute byte}
   mov MoveWJumpBytes,al

@EndRight:

   mov al,MoveWOldX1
   dec al
   mov MoveWScreenX,al
   mov al,MoveWOldY1
   dec al
   mov MoveWScreenY,al

   pushf
   Call WriteToScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove

@LeftMove:
         {--------------------- Left X Move ---------------}


   mov al,MoveWOldX1          {Check if we have a whole move of the window}
   cmp MoveWNewX2,al
   jb  @SetValueL
   jmp @EverythingOkL  {No ? Then go ahead}

@SetValueL:            {If we have a whole move then do these}
   mov al,MoveWOldX2
   sub al,MoveWOldX1
   inc al
   mov MoveWColumns,al
   mov WholeMove,0FFh
   jmp @Continue2

@EverythingOkL:

   mov al,MoveWOldX1
   sub al,MoveWNewX1        {Now al:=OldX1-NewX1 = XDif}
   mov MoveWColumns,al   {The total MoveWColumns}


@Continue2:
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al  {The toal MoveWRows}


   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0
   mov al,MoveWColumns
   mov XOffset,al

   cmp WholeMove,0FFh
   jz  @EndLeft

   mov ah,MoveWColumns
   add ah,MoveWOldX1         { AH:=MoveWOldX1+MoveWColumns}
   mov al,MoveWOldX2
   sub al,ah         { AL:=MoveWOldX2-AH}
   inc al            { Inc the result}
   shl al,1          { mul the result x2 because attribute byte}
   mov MoveWJumpBytes,al
   xor ah,ah
   mov MoveWOffsetInData,ax

@EndLeft:

   mov al,MoveWOldX2
   dec al
   mov ah,MoveWColumns
   sub al,ah
   inc al
   mov MoveWScreenX,al
   mov al,MoveWOldY1
   dec al
   mov MoveWScreenY,al

   pushf
   Call WriteToScreen

   cmp WholeMove,0FFh
   jz  @NoYMove

   jmp @CheckYMove


   {=======================  Y MOVE OFFSET ============================}

@CheckYMove:

   mov al,MoveWOldY1
   cmp MoveWNewY1,al
   ja  @DownMove
   jb  @UpMove

   jmp @NoYMove


@DownMove:
      {-------------------- Down Y Move --------------------}

   mov al,MoveWOldY2          {Check if we have a whole move of the window}
   cmp MoveWNewY1,al
   ja  @SetValueD
   jmp @EveryThingOkD      {No ? Then go ahead}

@SetValueD:            {If we have a whole move then do these}
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al
   mov WholeMove,0FFh
   jmp @Continue3

@EveryThingOkD:
   mov al,MoveWNewY1
   sub al,MoveWOldY1
   mov MoveWRows,al  {The total MoveWRows}

@Continue3:

   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndDown

   mov dl,XOffset
   shl dl,1
   mov MoveWJumpBytes,dl
   xor dh,dh

   cmp LeftOrRight,0h
   jz  @Cont21
   mov MoveWOffsetInData,dx

@Cont21:
   mov ah,MoveWNewX2
   mov al,MoveWNewX1
   sub ah,al
   inc ah
   sub ah,XOffset
   mov MoveWColumns,ah


@EndDown:

   mov ah,MoveWOldX1
   dec ah
   cmp LeftOrRight,0h
   jz  @Cont22

   mov al,MoveWJumpBytes
   shr al,1
   add ah,al
@Cont22:
   mov MoveWScreenX,ah

   mov al,MoveWOldY1
   dec al
   mov MoveWScreenY,al

   pushf
   Call WriteToScreen


   jmp @NoYMove
@UpMove:
      {-------------------- Up Y Move -----------------------}

   mov al,MoveWNewY2          {Check if we have a whole move of the window}
   cmp MoveWOldY1,al
   ja  @SetValueU
   jmp @EveryThingOkU      {No ? Then go ahead}

@SetValueU:            {If we have a whole move then do these}
   mov al,MoveWNewY2
   sub al,MoveWNewY1
   inc al
   mov MoveWRows,al
   mov WholeMove,0FFh
   jmp @Continue4

@EveryThingOkU:
   mov al,MoveWOldY1
   sub al,MoveWNewY1
   mov MoveWRows,al  {The total MoveWRows}

@Continue4:

   mov MoveWOffsetInData,0 {No Offset}
   mov MoveWJumpBytes,0

   cmp WholeMove,0FFh
   jz  @EndUp

   mov dl,XOffset
   shl dl,1
   mov MoveWJumpBytes,dl
   xor dh,dh

   push dx         {ax contains the XOffset }

   mov ah,MoveWNewX2
   mov al,MoveWNewX1
   sub ah,al
   inc ah
   mov dh,ah      {Keep this value for later use}
   sub ah,XOffset
   mov MoveWColumns,ah

   shl dh,1       {mul x2}
   mov ah,MoveWNewY2
   mov al,MoveWNewY1
   sub ah,al
   inc ah
   sub ah,MoveWRows
   xchg ah,al
   xor ah,ah
   mul dh        {now ax contain the start into Data buffer}

   pop dx

   mov cl,LeftOrRight
   cmp cl,0      {If Left move then don't add anything}
   jz @Cont1

   add ax,dx     {If Right then add the XOffset}

@Cont1:
   mov MoveWOffsetInData,ax

@EndUp:

   mov al,MoveWOldX1
   dec al
   cmp LeftOrRight,0
   jz  @Cont2
   mov ah,MoveWJumpBytes
   shr ah,1
   add al,ah
@Cont2:
   mov MoveWScreenX,al

   mov al,MoveWOldY2
   dec al
   sub al,MoveWRows
   inc al
   mov MoveWScreenY,al

   pushf
   Call WriteToScreen


@NoYMove:
      {===================== END OF PROCEDURE ========================}


   pop ds

End;


Procedure InternalCopy(Intern :WinCoord);
Var
   Storage        :Word;
   WRSeg,WROfs    :Word;
   ColumnLen      :Byte;
   WindowReserved :^ScreenImage;
Begin
    Storage:=(Intern.Y2-Intern.Y1)+1;
    Storage:=Storage*((Intern.X2-Intern.X1)+1);
    Storage:=Storage shl 1;

    GetMem(WindowReserved,Storage);        {Get Mem for internal use}
    WRSeg:=Seg(WindowReserved^);
    WROfs:=Ofs(WindowReserved^);
    Asm;
       push ds

       mov ah,Intern.X2
       mov al,Intern.X1
       sub ah,al
       inc ah
       mov MoveWColumns,ah     {Total MoveWColumns}

       mov ah,Intern.Y2
       mov al,Intern.Y1
       sub ah,al
       inc ah
       mov MoveWRows,ah        {Total MoveWRows}

       mov ah,Intern.X1
       mov al,MoveWOldX1
       sub ah,al
       shl ah,1
       xchg ah,al
       xor ah,ah
       mov MoveWOffsetInData,ax    {Start for current line}

       mov ah,MoveWOldX2
       mov al,MoveWOldX1
       sub ah,al
       inc ah
       shl ah,1
       xchg ah,al
       xor ah,ah
       mov ColumnLen,al

       mov ah,MoveWColumns
       shl ah,1
       sub al,ah
       mov MoveWJumpBytes,al

       mov dh,Intern.Y1
       mov dl,MoveWOldY1
       sub dh,dl
       xor ax,ax
       mov al,ColumnLen
       mul dh          {Ax:=dh*Ax}
       mov dx,MoveWOffsetInData
       add ax,dx

       mov si,MoveWWDOfs
       add si,ax            {Offset into WindowData}

       mov di,WROfs

       xor cx,cx
       mov cl,MoveWRows

@Lo1:  push cx
       xor cx,cx
       mov cl,MoveWColumns
@Lo2:
       mov ax,MoveWWDSeg
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
       mov al,MoveWJumpBytes
       add si,ax
       pop cx
       loop @Lo1

       {---------------Now recopy from ReservedData to new WindowData-------}

       mov si,MoveWWDSeg

       mov dl,MoveWNewY1
       mov dh,Intern.Y1
       sub dh,dl
       xor ah,ah
       mov al,ColumnLen
       mul dh           {Now ax:=YOffset}

       mov dl,MoveWNewX1
       mov dh,Intern.X1
       sub dh,dl
       shl dh,1
       xor dl,dl
       xchg dl,dh
       add ax,dx         {Now Ax:=YOffset+XOffset}
       mov si,ax         {The actual Start}

       mov di,WROfs

       xor cx,cx
       mov cl,MoveWRows

@Lo11: push cx
       xor cx,cx
       mov cl,MoveWColumns
@Lo21:
       mov ax,WRSeg
       mov es,ax
       mov ax,es:[di]

       push ax
       mov ax,MoveWWDSeg
       mov es,ax
       pop ax
       mov es:[si],ax

       inc si
       inc si

       inc di
       inc di

       loop @Lo21

       xor ax,ax
       mov al,MoveWJumpBytes
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
   HiddenMouseCursor;
   FreeForControl:=1;


   XDif:=Win^.BX2-Win^.BX1;
   YDif:=Win^.BY2-Win^.BY1;

   MoveWOldX1:=Win^.BX1;MoveWOldX2:=Win^.BX2;
   MoveWOldY1:=Win^.BY1;MoveWOldY2:=Win^.BY2;

   MoveWNewX1:=X1;MoveWNewY1:=Y1;
   MoveWNewX2:=X1+XDif;MoveWNewY2:=Y1+YDif;

   MoveWWDSeg:=Seg(Win^.SnapShot^);
   MoveWWDOfs:=Ofs(Win^.SnapShot^);

   ShowPart;

   Old.X1:=MoveWOldX1;Old.Y1:=MoveWOldY1;
   Old.X2:=MoveWOldX2;Old.Y2:=MoveWOldY2;

   New.X1:=MoveWNewX1;New.Y1:=MoveWNewY1;
   New.X2:=MoveWNewX2;New.Y2:=MoveWNewY2;

   InterSection(New,Old,Over);
   IF Over.X1<>$FF Then
      InternalCopy(Over);

   SavePart;

   Win^.BX1:=MoveWNewX1;Win^.BY1:=MoveWNewY1;
   Win^.BX2:=MoveWNewX2;Win^.BY2:=MoveWNewY2;

   Win^.X1:=Win^.BX1;Win^.Y1:=Win^.BY1;
   Win^.X2:=Win^.BX2;Win^.Y2:=Win^.BY2;


   SRVar.BX1:=Win^.BX1;SRVar.BY1:=Win^.BY1;
   SRVar.BX2:=Win^.BX2;SRVar.BY2:=Win^.BY2;
   SRVar.ShowArea;

   ShowMouseCursor;


End;

{**********************************************************************}
{Procedure ReadWriteButToXY                                            }
{ãú´ò°†§ú† ´¶ ´®úÆ‡§ ßò®òü¨®¶ ©´û üú©û ï,ì ´û™ ¶ü¶§û™.Éú§ ú†§ò† ®¶¨´†§ò}
{´û™ †ú®ò®Æ†ò™ ´‡§ objects.âò¢ú†´ò† òß¶ ´†™ ®¶¨´†§ú™ †ú®ò®Æ†ò™ movewin }
{ö†ò ß¢û°´®¶¢¶ö†¶ °ò† ß¶§´†°†.                                         }
{**********************************************************************}

Procedure ReadWriteBufToXY(InX,InY :Byte);
var
   XDif,YDif                    :ShortInt;
   OldCoords,NewCoords,InterSec :WinCoord;
   OneX,OneY                    :Byte;
   AbsXDif,AbsYDif              :Byte;
   WholeWindowMove              :Boolean;
Begin

     OldCoords.X1:=Win^.BX1;
     OldCoords.Y1:=Win^.BY1;
     OldCoords.X2:=Win^.BX2;
     OldCoords.Y2:=Win^.BY2;

     XDif:=0;
     YDif:=0;

     IF InY<>Win^.Y1 Then
     Begin
         YDif:=(InY-Win^.Y1);
         SRVar.BY1:=SRVar.BY1+YDif;
         SRVar.BY2:=SRVar.BY2+YDif;

         Win^.BY1:=Win^.BY1+YDif;
         Win^.BY2:=Win^.BY2+YDif;
         Win^.Y1:=Win^.Y1+YDif;
         Win^.Y2:=Win^.Y2+YDif;
     End;

     IF InX <> Win^.X1 Then
     Begin
         XDif:=(InX-Win^.X1);
         SRVar.BX1:=SRVar.BX1+XDif;
         SRVar.BX2:=SRVar.BX2+XDif;

         Win^.BX1:=Win^.BX1+XDif;
         Win^.BX2:=Win^.BX2+XDif;
         Win^.X1:=Win^.X1+XDif;
         Win^.X2:=Win^.X2+XDif;
     End;

     AbsXDif:=Abs(XDif);
     AbsYDif:=Abs(YDif);
     WholeWindowMove:=False;

     IF XDif > 0 Then
     Begin
       IF (Win^.BX1+AbsXDif >= Win^.BX2) Then
          WholeWindowMove:=True;
     End
     Else
     IF XDif < 0 Then
       IF Win^.BX2-AbsXDif <= Win^.BX1 Then
          WholeWindowMove:=True;

     IF YDif > 0 Then
     Begin
       IF (Win^.BY1+AbsYDif >= Win^.BY2) Then
          WholeWindowMove:=True;
     End
     Else
     IF YDif < 0 Then
       IF Win^.BY2+YDif <= Win^.BY1 Then
          WholeWindowMove:=True;



     IF WholeWindowMove  Then
     Begin
         Win^.BX1:=OldCoords.X1;
         Win^.BY1:=OldCoords.Y1;
         Win^.BX2:=OldCoords.X2;
         Win^.BY2:=OldCoords.Y2;

         Win^.ShowArea;
         HiddenMouseCursor;
         SRVar.ShowArea;
         ShowMouseCursor;

         Win^.BX1:=Win^.BX1+XDif;
         Win^.BY1:=Win^.BY1+YDif;
         Win^.BX2:=Win^.BX2+XDif;
         Win^.BY2:=Win^.BY2+YDif;
     End
     Else
     Begin
       IF (XDif<>0) or (YDif<>0) Then
       Begin

         Win^.BX1:=OldCoords.X1;
         Win^.BY1:=OldCoords.Y1;
         Win^.BX2:=OldCoords.X2;
         Win^.BY2:=OldCoords.Y2;

         HiddenMouseCursor;

         IF XDif>0 Then
         Begin
            {â†§û©û ß®¶™ ´ò õú•†ò.Ñ£≠ò§†ù¶¨£ú ´†™ ò®†©´ú®¶´ú®ú™ ö®ò££ú™}

            Win^.ShowPart(Win^.BX1,Win^.BY1,Win^.BX1+(XDif-1),Win^.BY2);
            IF ((Win^.Params and Shadow) = Shadow) and (YDif=0) Then

               {Ñ•ò≠ò§†ù¶¨£ú òß¶ ´û§ ¶®†ù¶§´†ò ©°†ò ´¶©¶¨™ Æò®ò°. ¶©¶ û °†§û©û}
               {©ú Æò®ò°,ò®Æ†ù¶§´ò™ òß¶ ´ò ò®†©´ú®ò (Left).                   }
               Win^.ShowPart(Win^.BX1+2,Win^.BY2,(Win^.BX1+2+XDif)-1,Win^.BY2);
         End
         Else
         IF XDif<0 Then
         Begin
            {â†§û©û ß®¶™ ´ò ò®©´ú®ò (Left).Ñ£≠ò§†ù¶¨£ú ´†™ õú•†¶´ú®ú™ ö®ò££ú™}

            Win^.ShowPart(Win^.BX2-(Abs(XDif)-1),Win^.BY1,Win^.BX2,Win^.BY2);

            IF ((Win^.Params and Shadow) = Shadow) and (AbsXDif=1) Then
            Begin

                {Ñò§ û °†§û©û ú†§ò† ú§ò™ Æò®ò°´û®ò™ ´¶´ú ú¢ò úõ‡.            }
                {Äß¶ ´û§ ßò¢†ò ©¨§´ú´òö.- 2 ´¨ß‡©ú ´û§ ©°†ò.è®‡´ò ´¶§ original}
                {Æò®ò°´.(1 Æò®ò°´û®ò ´¶§ ß®‡´¶) °ò† £ú´ò ´û§ ©°†ò (2 Æò®ò°-´ú¢¶™)}

                Win^.ShowPart(Win^.BX2-(AbsXDif-1)-2,Win^.BY1,Win^.BX2-(AbsXDif-1)-2,Win^.BY1);
                Win^.ShowPartAndColor(Win^.BX2-(AbsXDif-1)-2,Win^.BY1+1,Win^.BX2-(AbsXDif-1)-2,
                                    Win^.BY2,0+(0 shl 4)+7);
            End
            Else
            IF ((Win^.Params and Shadow) = Shadow) and (AbsXDif>1) Then
            Begin
                {Ñò§ û °†§û©û ú†§ò† ßò§‡ òß¶ 2 Æò®ò°. ´¶´ú ú¢ò úõ‡.            }

                {âò§ú ©°†ò 2 ©´û¢ú™.è®‡´ò ´†™ °¶®¨≠ú™ (2 ß®‡´¶¨™ Æò®ò°) °ò† £ú´ò}
                {¶¢¶¨™ ´¶¨™ ò¢¢¶¨™ Æò®ò°´û®ú™ ôò≠¶§´ò™ £ú ´¶ Æ®‡£ò ´û™ ©°†ò™     }
                Win^.ShowPart(Win^.BX2-(AbsXDif-1)-2,Win^.BY1,Win^.BX2-(AbsXDif-1)-1,Win^.BY1);
                Win^.ShowPartAndColor(Win^.BX2-(AbsXDif-1)-2,Win^.BY1+1,Win^.BX2-(AbsXDif-1)-1,
                                      Win^.BY2,0+(0 shl 4)+7);
            End;
         End;

         IF YDif>0 Then
         Begin
            {Ñò§ úÆ¶¨£ú °†§û©û ß®¶™ ´ò °ò´‡ ´¶´ú ú¢ò úõ‡                }

            {Ñ£≠ò§†©ú ´†™ ßò§‡ ö®ò££ú™ ´¶¨ ßò®òü¨®¶¨ ò§ò¢¶öò £ú ´¶ ß¶©ú™}
            {°†§û©ú†™ °ò§ò£ú ß®¶™ ´ò °ò´‡.ï °†§û©ú†™ ? ´¶´ú ï ö®ò££ú™.  }

            Win^.ShowPart(Win^.BX1,Win^.BY1,Win^.BX2,Win^.BY1+(YDif-1));
            IF (Win^.Params and Shadow) = Shadow Then
                {Ñ£≠ò§†©ú ´¶¨™ °ú§¶¨™ Æò®ò°. ´û™ ©°†ò™ (õ¨¶ ß®‡´¶¨™).íû§ }
                {¶®†ù¶§´†ò ©°†ò ´û§ ©Æúõ†òùú† û ®¶¨´†§ò ©´¶ ´ú¢¶™ ´û™ proc}
                Win^.ShowPart(Win^.BX2-AbsXDif-1,Win^.BY1+AbsYDif,Win^.BX2,Win^.BY1+AbsYDif);
         End
         Else
         IF YDif<0 Then
         Begin
            {Ñò§ úÆ¶¨£ú °†§û©û ß®¶™ ´ò úßò§‡ ´¶´ú ú¢ò úõ‡.              }

            {Ñ£≠ò§†©ú ´†™ ´ú¢ú¨´ò†ú™ ö®ò££ú™ ´¶¨ ßò®òü¨®¶¨.             }

            Win^.ShowPart(Win^.BX1,Win^.BY2-(AbsYDif-1),Win^.BX2,Win^.BY2);

            {Ñ¢ò úõ‡ £¶§¶ úò§ õú§ úÆ¶¨£ú ï £ú´ò´¶ß†©û „ úÆ¶¨£ú üú´†°û £ú´ò´.}

            IF ((Win^.Params and Shadow) = Shadow) and ( (XDif>0) or (XDif=0)) Then
            Begin
                {Ñ£≠ò§†©û ´û™ ©°†ò™ ©´û§ °ò´ò¢¢û¢û ö®ò££û.è®‡´ò ´¶¨™ °ú§¶¨™}
                {Æò®ò°. °ò† £ú´ò ´¶¨™ Æ®‡£ò´†©£ú§¶¨™.                      }
                Win^.ShowPart(Win^.BX1,Win^.BY2-AbsYDif,Win^.BX1+1+AbsXDif,Win^.BY2-AbsYDif);
                Win^.ShowPartAndColor(Win^.BX1+XDif+2,Win^.BY2-AbsYDif,Win^.BX2,Win^.BY2-AbsYDif,
                                         0+(0 shl 4)+7);
            End
            Else

            {Ç†ò ò®§û´†°û ï £ú´ò´¶ß†©û ú¢ò úõ‡.                         }

            IF ((Win^.Params and Shadow) = Shadow) and (XDif<0) Then
            Begin

                {Ñò§ ´¶ ôû£ò ú†§ò† ú§ò ´¶´ú ú¢ò úõ‡.                    }

                IF AbsXDif=1 Then
                Begin
                    Win^.ShowPart(Win^.BX1,Win^.BY2-AbsYDif,Win^.BX1,Win^.BY2-AbsYDif);
                    Win^.ShowPartAndColor(Win^.BX1+1,Win^.BY2-AbsYDif,Win^.BX2-AbsXDif,Win^.BY2-AbsYDif,
                                         0+(0 shl 4)+7);
                End
                Else

                {èò§‡ òß¶ ú§ò ôû£ò ú¢ò úõ‡.                             }

                IF AbsXDif>1 Then
                Win^.ShowPartAndColor(Win^.BX1,Win^.BY2-AbsYDif,Win^.BX2-AbsXDif,Win^.BY2-AbsYDif,
                                         0+(0 shl 4)+7);
            End;
         End;
         ShowMouseCursor;


         Win^.BX1:=Win^.BX1+XDif;
         Win^.BY1:=Win^.BY1+YDif;
         Win^.BX2:=Win^.BX2+XDif;
         Win^.BY2:=Win^.BY2+YDif;


       End;


       NewCoords.X1:=Win^.BX1;
       NewCoords.X2:=Win^.BX2;
       NewCoords.Y1:=Win^.BY1;
       NewCoords.Y2:=Win^.BY2;

       InterSection(OldCoords,NewCoords,InterSec);

       IF InterSec.X1<>$FF Then
       Begin
         Win^.BX1:=OldCoords.X1;
         Win^.BY1:=OldCoords.Y1;
         Win^.BX2:=OldCoords.X2;
         Win^.BY2:=OldCoords.Y2;

         OneX:=0;OneY:=0;

         IF XDif>0 Then
            OneX:=XDif;

         IF YDif>0 Then
            OneY:=YDif;

         Win^.MoveData(InterSec.X1,InterSec.Y1,InterSec.X2,InterSec.Y2,
           OldCoords.X1+abs(NewCoords.X1-OldCoords.X1)-OneX,OldCoords.Y1+abs(NewCoords.Y1-OldCoords.Y1)-OneY);


         Win^.BX1:=Win^.BX1+XDif;
         Win^.BY1:=Win^.BY1+YDif;
         Win^.BX2:=Win^.BX2+XDif;
         Win^.BY2:=Win^.BY2+YDif;


       End;

       HiddenMouseCursor;
       IF XDif>0 Then
          Win^.SavePart(OldCoords.X2+1,Win^.BY1,Win^.BX2,Win^.BY2)
       Else
       IF XDif<0 Then
          Win^.SavePart(Win^.BX1,Win^.BY1,OldCoords.X1-1,Win^.BY2);

       IF YDif>0 Then
          Win^.SavePart(Win^.BX1,OldCoords.Y2+1,Win^.BX2,Win^.BY2)
       Else
       IF YDif<0 Then
          Win^.SavePart(Win^.BX1,Win^.BY1,Win^.BX2,OldCoords.Y1-1);

       SRVar.ShowArea;

       IF ((Win^.Params and shadow) = Shadow)  Then
             Win^.DrawShadowWin;

       ShowMouseCursor;
     End;

End;

Procedure CopyFromMaskToVar;
Var
    XSize,YSize,I       :Word;
Begin

    SRVar.BX1:=Win^.X1;SRVar.BY1:=Win^.Y1;
    SRVar.BX2:=Win^.X2;SRVar.BY2:=Win^.Y2;
    SRVar.SnapShot:=Nil;
    XSize:=(Win^.X2-Win^.X1)+1;
    XSize:=XSize*2;
    YSize:=(Win^.Y2-Win^.Y1)+1;
    SRVar.WinSize:=YSize * XSize;


    SRVar.SnapShot:=EdsGetMem(SRVar.SnapShot,SRVar.WinSize);
    IF HeapErrorCode=0 Then
       For I:=0 to SRVar.WinSize-1 do
           SRVar.SnapShot^[I]:=Win^.MaskScreen^[I];

End;

Procedure WinFunc.MoveWin;
Const
     MoveStep           :Byte = 1;
Var
     Scan,Ascii         :Char;
     SaveTextColor      :Byte;
Begin

   IF MemAvail < (3 * Win^.WinSize) Then
      HeapErrorCode:=1;

   IF HeapErrorCode=0 Then
   Begin
     HiddenMouseCursor;
     SaveTextColor:=Win^.WTextColor;
     Win^.WTextColor:=MoveColor;
     Win^.DrawFrameWin;

     CopyFromMaskToVar;

     ShowMouseCursor;

     IF HeapErrorCode=0 Then
     Begin

       Repeat

         ReadKbd(Scan,Ascii);

         If (Scan=#0) and (Ascii=#77)  and (Win^.BX1+MoveStep < MoveX2Limit) then
         Begin
           ReadWriteBufToXY(Win^.BX1+MoveStep,Win^.BY1);
           Inc(Win^.WinCurX);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End
         Else

         If (Scan=#0) and (Ascii=#75)  and (abs(Win^.BX1-MoveStep) >= MoveX1Limit) then
         Begin
           ReadWriteBufToXY(Win^.BX1-MoveStep,Win^.BY1);
           Dec(Win^.WinCurX);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End
         Else

         If (Scan=#0) and (Ascii=#72)  and (abs(Win^.BY1-MoveStep) >= MoveY1Limit) then
         Begin
           ReadWriteBufToXY(Win^.BX1,Win^.BY1-MoveStep);
           Dec(Win^.WinCurY);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End
         Else

         If (Scan=#0) and (Ascii=#80)  and ((Win^.BY1+MoveStep) <= MoveY2Limit) then
         Begin
           ReadWriteBufToXY(Win^.BX1,Win^.BY1+MoveStep);
           Inc(Win^.WinCurY);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End;
       Until (Scan=#13);

       HiddenMouseCursor;
       SRVar.RestoreArea;
       ShowMouseCursor;

     End;

     HiddenMouseCursor;
     Win^.WTextColor:=SaveTextColor;
     Win^.DrawFrameWin;
     Win^.DrawIcons;
     Win^.DisplayTitleWin;
     ShowMouseCursor;
   End;


   IF (HeapErrorCode=1) and (ErrorMoveFarCallPtr<>Nil) Then
     Asm
        Call ErrorMoveFarCallPtr
     End;


End;

Procedure WinFunc.MoveMsWin;
Var

     SaveTextColor      :Byte;
     OldX,OldY          :ShortInt;
     ParamX,ParamY      :ShortInt;
     CurMX,CurMY        :Byte;

Begin


 IF MemAvail < (3 * Win^.WinSize) Then
    HeapErrorCode:=1;

 IF HeapErrorCode=0 Then
 Begin
   SaveTextColor:=Win^.WTextColor;
   Win^.WTextColor:=MoveColor;
   HiddenMouseCursor;
   Win^.DrawFrameWin;

   CopyFromMaskToVar;

   ShowMouseCursor;

   IF HeapErrorCode=0 Then
   Begin
     OldX:=MouseX;
     OldY:=MouseY;

     SetMouseMinMaxX(MouseX-(Win^.BX1-SetWindowX1),SetWindowX2);
     SetMouseMinMaxY(SetWindowY1+1,SetWindowY2);
     SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);

     Repeat
       Repeat
       Until (OldX<>MouseX) OR (OldY<>MouseY) OR  (MouseButton=MsIdle);

       CurMX:=MouseX;CurMY:=MouseY;

       IF MouseButton<>MsIdle Then
       Begin

         IF (CurMX > OldX) and (Win^.BX1 < MoveX2Limit) then
         Begin
           OldX:=CurMX-OldX;
           Win^.WinCurX:=Win^.WinCurX+abs(OldX);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End
         Else
         IF (CurMX < OldX)  and (Win^.BX1 > MoveX1Limit) then
         Begin
           OldX:=CurMX-OldX;
           Win^.WinCurX:=abs(Win^.WinCurX-abs(OldX));
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End;

         IF (CurMY < OldY)  and (Win^.BY1 > MoveY1Limit) then
         Begin
           OldY:=CurMY-OldY;
           Win^.WinCurY:=abs(Win^.WinCurY-abs(OldY));
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End
         Else
         IF (CurMY > OldY)  and (Win^.BY1 < MoveY2Limit) then
         Begin
           OldY:=CurMY-OldY;
           Win^.WinCurY:=Win^.WinCurY+abs(OldY);
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
         End;

         IF OldX=CurMX Then
            OldX:=0;
         IF OldY=CurMY Then
            OldY:=0;

         ParamX:=Win^.BX1+OldX;
         ParamY:=Win^.BY1+OldY;

         IF Win^.BX1+OldX < SetWindowX1 Then
            ParamX:=SetWindowX1
         Else
         IF Win^.BX1+OldX > SetWindowX2 Then
            ParamX:=SetWindowX2;

         IF Win^.BY1+OldY < SetWindowY1 Then
            ParamY:=SetWindowY1
         Else
         IF Win^.BY1+OldY > SetWindowY2 Then
            ParamY:=SetWindowY2;


         ReadWriteBufToXY(ParamX,ParamY);
         OldX:=CurMX;OldY:=CurMY;
       End;

     Until (MouseButton=MsIdle);

     SetMouseMinMaxX(1,80);
     SetMouseMinMaxY(1,25);

     HiddenMouseCursor;
     SRVar.RestoreArea;
     ShowMouseCursor;
   End;

   HiddenMouseCursor;
   Win^.WTextColor:=SaveTextColor;
   Win^.DrawFrameWin;
   Win^.DrawIcons;
   Win^.DisplayTitleWin;
   ShowMouseCursor;
 End;



 IF (HeapErrorCode=1) and (ErrorMoveFarCallPtr<>Nil) Then
 Asm
    Call ErrorMoveFarCallPtr
 End;

End;


{***********************************************************************}
{Procedure AssignXY                                                     }
{Ñ†§ò† ¶† ©¨§´ú´òö£ú§ú™ ß¶¨ Æ®û©†£¶ß¶†¶¨§ ¶¢ò ´ò ò§´†°ú†£ú§ò ú§¶™ ßò®òü¨}
{®¶¨.                                                                   }
{***********************************************************************}

Procedure View.AssignXY;
Begin
    ObjectX1:=InX1;
    ObjectY1:=InY1;
    ObjectX2:=InX2;
    ObjectY2:=InY2;
End;


{**********************************************************************}
{Procedure ClearEvent                                                  }
{ãûõú§†ù£¶™ ´û™ £ú´òô¢û´û™ Event ---> command                          }
{**********************************************************************}

Procedure View.ClearEvent;
Begin
    Event:=0;
End;


{************************************************************************}
{Procedure View. <Procedure Name>                                        }
{Procedures ö†ò ú°ö¨®û ú£≠ò§†©û ´‡§ õúõ¶£ú§‡§ û ¶Æ†.                     }
{************************************************************************}

Procedure View.EnableCommand(Cmds :CommandsRange);
Begin
     CommandsArray:=CommandsArray-Cmds;
End;


Procedure View.EnableAllCommands;
Begin
     CommandsArray:=[];
End;

Procedure View.DisableCommand(Cmds :CommandsRange);
Begin
     CommandsArray:=CommandsArray+Cmds;
End;


{***************************************************}
{Procedure ShowHelpCtx                              }
{Ñ£≠ò§†ùú† ´û§ ö®ò££û ´¶¨ Help ¶ß¶¨ Æ®úò†ùú´ò†      }
{***************************************************}

Procedure View.ShowHelpCtx(Point :Str80);
Var
    I           :Byte;
Begin
  IF AllowHelpCtx=True Then
  Begin
   IF  (Point<>'') Then
   Begin
       IF ( (InterMX+1 in [StatLineStartChar..StatLineStartChar+StatLineMaxChars])
         or (InterMX+2 in [StatLineStartChar..StatLineStartChar+StatLineMaxChars]) ) AND
          ( (InterMY+1 in [BottomLine..BottomLine]) or (InterMY+2 in [BottomLine..BottomLine]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;
       WriteTextColor:=StatLineTxtColor;
       WriteTextBackGround:=StatLineBckColor;
       WriteOut(StatLineStartChar,BottomLine,Copy(Point,1,StatLineMaxChars-StatLineStartChar+1));

       IF StatLineMaxChars > StatLineStartChar+Length(Point) Then
          For I:=StatLineStartChar+Length(Point) to StatLineMaxChars do
            WriteChar(I,BottomLine,StatLineTxtColor,StatLineBckColor,32);
       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;
   End
   Else
   IF (Point='') Then
   Begin
     IF ( (InterMX+1 in [StatLineStartChar..StatLineStartChar+StatLineMaxChars])
       or (InterMX+2 in [StatLineStartChar..StatLineStartChar+StatLineMaxChars]) ) AND
        ( (InterMY+1 in [BottomLine..BottomLine]) or (InterMY+2 in [BottomLine..BottomLine]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;
     IF StatLineMaxChars > StatLineStartChar Then
        For I:=StatLineStartChar to StatLineMaxChars do
          WriteChar(I,BottomLine,StatLineTxtColor,StatLineBckColor,32);
     IF HiddenMouse Then
     Begin
        ShowMouseCursor;
        HiddenMouse:=False;
     End;

   End;
  End;
End;

{**************************************************************************}
{Procedure OpenWindow                                                      }
{Ä§¶†öú† ú§ò ßò®òü¨®¶ ©¨£≠‡§ò £ú ´†™ ßò®ò£ú´®¶¨™                           }
{**************************************************************************}
Procedure OpenWindow(InX1,InY1,InX2,InY2 :Byte;InTitle :Str80;Params :Word);
Var
   TempWin      :PWinFunc;
   T            :View;

Procedure ErrorCloseWindow;
Begin
         IF Win<>Nil Then
            FreeMem(Win,SizeOf(WinFunc));
         Win:=TempWin;
         Dec(WindowCounter);

         IF (Win<>Nil) and (WindowCounter>0) and (PDActive=False) Then
         Begin
            IF Win^.WinCurX<>255 Then
            Begin
              SetCurLength(Win^.WinSScanL,Win^.WinEScanL);
              SetCurPositionXY(Win^.WinCurX+1,Win^.WinCurY+1);
            End;
             IF ( (InterMX+1 in [InX1..InX2+2]) or (InterMX+2 in [InX1..InX2+2]) ) AND
                ( (InterMY+1 in [InY1..InY2+2]) or (InterMY+2 in [InY1..InY2+2]) ) Then
             Begin
               HiddenMouseCursor;
               HiddenMouse:=True;
             End;
             Win^.DrawFrameWin;
             Win^.DisplayTitleWin;
             Win^.DrawIcons;
             IF (Win^.Params and Shadow) = Shadow Then
                Win^.DrawShadowWin;

             IF HiddenMouse Then
             Begin
               ShowMouseCursor;
               HiddenMouse:=False;
             End;

             T.ShowHelpCtx(Win^.CurrentMessageLine);
         End
         Else
         IF (Win<>Nil) and (WindowCounter>0) and (PDActive=True) Then
             T.ShowHelpCtx(PullDownCurrentHelpCtx);

         IF (HeapErrorCode<>0) and (ErrorWinUserFarCallPtr<>Nil) and (WindowCounter = 0) Then
            Asm;
               Call ErrorWinUserFarCallPtr
            End;

         IF (HeapErrorCode<>0) and (ErrorWinFarCallPtr<>Nil) Then
            Asm;
               Call ErrorWinFarCallPtr
            End;


End;

Begin

    IF ( (InX1 in [1..75])  AND (InY1 in [1..23]) AND
              ( (InX2>InX1) and (InX2<81) ) AND ( (InY2>InY1) and (InY2<26) ) ) AND
              (WindowCounter < MaxWindows)  Then
    Begin

      {ëÆúõ†ò©ú £ú òßò¢¶ Æ®‡£ò ´¶ frame ´¶¨ ß®¶ûö¶¨£ú§¶¨ ßò®òü¨®¶¨}
      IF (WindowCounter>0) and (PDActive = False) Then
      Begin
         HiddenMouseCursor;

         WinTextColor:=Win^.WTextColor;
         Win^.WTextColor:=NotActiveColorFrame;
         Win^.DrawFrameWin;

         ShowMouseCursor;

         Win^.WTextColor:=WinTextColor;
         IF (Params and OverLap) <> 0 Then
             Win^.MakeMaskImage;

        {ReadCurPositHeight;
         Win^.WinCurX:=CurColomn+1;
         Win^.WinCurY:=CurRow+1;
         Win^.WinSScanL:=SScanL;
         Win^.WinEScanL:=EScanL;}

         CurOff;
      End;

      TempWin:=Win;
      Inc(WindowCounter);
      Win:=EdsGetMem(Win,SizeOf(WinFunc));

      IF MemAvail < 20000 Then
         HeapErrorCode:=1;

      IF HeapErrorCode = 0 Then
      Begin
        IF MonoCard Then
           Params:=Params and Not(Shadow);

        HiddenMouseCursor;

        Win^.Init(InX1,InY1,InX2,InY2,InTitle,Params);

        IF (Params and Shadow) <> 0 Then
           Win^.SaveArea(InX1,InY1,InX2+2,InY2+1)
        Else
           Win^.SaveArea(InX1,InY1,InX2,InY2);
        IF HeapErrorCode = 0 Then
        Begin
          IF (Params and OpenFx) <> 0 Then
            Win^.OpenFxWin;

          Win^.TitleTextColor:=WTitleTextColor;
          Win^.TitleTextBackGround:=WTitleTextBackGround;

          Win^.DrawFrameWin;
          Win^.DrawIcons;
          Win^.ClearWin(WinTextBackground);

          Win^.DisplayTitleWin;
          IF ((Params and Shadow) <> 0) Then
              Win^.DrawShadowWin;

          ShowMouseCursor;

          {í¶ß¶üú´û©ú ©´û§ ¶¨®ò ´‡§ ßò®òü¨®‡§ ´¶ °ò†§¶¨®ö†¶ ßò®òü¨®¶}
          {°ò† °ò§´¶ topwindow.                                     }

          WinLayer[WindowCounter]:=WindowCounter;
          TopWindow:=WindowCounter;
          Win^.WinNumber:=WindowCounter;
          Win^.CloseCommand:=0;
          Win^.EnterCommand:=0;
          Win^.WinCurX:=0;
          Win^.WinCurY:=0;
          Win^.WinSScanL:=$30;
          Win^.WinEScanL:=0;


          IF ((Params and OverLap) = OverLap)  OR ((Params and Movement) = Movement) Then
          Begin
            Win^.InitMaskImage;
            Win^.MakeMaskImage;
          End;

          Win^.Next:=WinHead;
          WinHead:=Win;
        End
        Else
          ErrorCloseWindow;
      End
      Else
         ErrorCloseWindow;
    End;
End;

{**************************************************************************}
{Procedure CloseWindow                                                     }
{â¢ú†§ú† ú§ò ßò®òü¨®¶.                                                     }
{**************************************************************************}

Procedure CloseWindow;
Var
   TakeWinNum,I,J      :Byte;
   NextWin,PreviousWin,
   Temp                :PWinFunc;
   T                   :View;
Begin

   IF WindowCounter>0 then
   Begin
     CurOff;
     TakeWinNum:=Win^.WinNumber;

     IF TakeWinNum<>WindowCounter then
     Begin
       FindWindowInList(TakeWinNum+1,NextWin);
       IF TakeWinNum<>1 Then
          FindWindowInList(TakeWinNum-1,PreviousWin)
       Else
          PreviousWin:=Nil;

       NextWin^.Next:=PreviousWin;
     End
     Else
     IF TopWindow=WindowCounter Then
        WinHead:=Win^.Next;


     IF (Win^.Params and CloseFx) <> 0 Then
     Begin
         HiddenMouseCursor;

         Win^.CloseFxWin;

         ShowMouseCursor;
     End;

     IF DoneWinObjFarCallPtr<>Nil Then
        Asm;
           Call DoneWinObjFarCallPtr
        End;

     HiddenMouseCursor;

     Win^.RestoreArea;

     ShowMouseCursor;

     IF (((Win^.Params and OverLap) = OverLap) Or ((Win^.Params and Movement) = Movement))
         AND (Win^.MaskScreen <> nil) Then
        Win^.DisposeMaskImage;

     Dispose(Win);
     Win:=WinHead;
     Dec(WindowCounter);
     TopWindow:=WindowCounter;

     IF (WindowCounter>0) AND ((Win^.Params and OverLap) = OverLap) Then
     Begin

       Temp:=WinHead;
       For I:=WindowCounter downto 1 do
       Begin
          IF TakeWinNum < WinLayer[I] Then
            WinLayer[I]:=WinLayer[I]-1;
          Temp^.WinNumber:=I;
          Temp:=Temp^.Next;
       End;


       TopWindow:=WinLayer[WindowCounter];
       FindWindowInList(TopWindow,Win);

       IF PDActive = False Then
       Begin
          SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
          HiddenMouseCursor;
          Win^.DrawFrameWin;
          Win^.DisplayTitleWin;
          Win^.DrawIcons;
          IF (Win^.Params and Shadow) = Shadow Then
             Win^.DrawShadowWin;
          ShowMouseCursor;
          T.ShowHelpCtx(Win^.CurrentMessageLine);
       End
       Else
          T.ShowHelpCtx(PullDownCurrentHelpCtx);

     End
     Else
     Begin
        IF WindowCounter=0 Then
        Begin
           TopWindow:=0;
           IF PDActive=True Then
              T.ShowHelpCtx(PullDownCurrentHelpCtx);
        End
        Else
        {âò§ú •ò§ò ú§´¶§ò ´ò Æ®‡£ò´ò ©´¶ °ò†§¶¨®ö. ú§ú®ö¶ ßò®òü¨®¶}

        IF (WindowCounter>0) and (PDActive = False) Then
        Begin
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
           HiddenMouseCursor;
           Win^.DrawFrameWin;
           Win^.DrawIcons;
           Win^.DisplayTitleWin;
           ShowMouseCursor;
           T.ShowHelpCtx(Win^.CurrentMessageLine);
        End
        Else
           T.ShowHelpCtx(PullDownCurrentHelpCtx);
     End;
   End;
End;

Procedure MoveWindow;
Var
   T    :View;
Begin
    IF (WindowCounter > 0) and ((Win^.Params and Movement) <> 0) Then
    Begin
       T.ShowHelpCtx(MoveHelpCtx);
       Win^.MoveWin;
       T.ShowHelpCtx(Win^.CurrentMessageLine);
    End;
End;


END.