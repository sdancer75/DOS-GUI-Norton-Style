UNIT WinObjB;

INTERFACE
Uses SavRstObj,WindowsObj,VarConstObj,GeneralObj,MouseObj,PullDnMenus,
              ErrorDlg,WinApplObj,WinObjA,HelpObj,Crt;

Const
     AutoNext   = 2;

Type

   PMenuBox     = ^MenuBox;
   MenuBox      = Object (VerScrollBar)

       MBX1,MBX2,
       MBY1,MBY2     :Byte;
       MBHelpCtx     :^Str80;
       MBDiskHelp    :Word;
       MBDisabled    :Boolean;
       MBText        :PDynText;
       MBTitle       :Str40;
       MBCommand     :Word;
       MBVerScrBar   :PVerScrollBar;
       MBStatus      :Byte;        {Bit 0 => 1 úò§ ©Æúõ†ò©¶¨£ú ´û§ õú•†¶´ú®û °òüú´û ö®ò££û}
                                   {Bit 1 => 1   >>      >>    ´û§ °ò´‡´ú®û ¶®†ù. ö®ò££û  }
                                   {Ñ•'¶®†©£¶¨ ú†§ò† °ò† ´ò õ¨¶ ©ú °ò´ò©´ò©û Set=1        }
       MBHeadTextLine:PDynText;
       MBRearTextLine:PDynText;

       MBVisualYPosit :Byte;        {Y ©¨§´ú´òö£ú§û ©´û§ ¶ü¶§û}
       MBVirtualYPosit:Word;        {í®úÆ‡§ ò®†ü£¶™ úß†¢¶öû™}
       MBMaxChoise    :Word;
       MBMenuBoxAutoNext :Boolean;  {To increment by one after the}
                                                   {selection}


       MMenuBoxNormTxtColor      :Byte;
       MMenuBoxNormBckColor      :Byte;
       MMenuBoxRevTxtColor       :Byte;
       MMenuBoxRevBckColor       :Byte;
       MMenuBoxSelectBckColor    :Byte;
       MMenuBoxSelectTxtColor    :Byte;
       MMenuBoxNoSelectTxtColor  :Byte;
       MMenuBoxDesktopColor      :Byte;


       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Function    InitMenuBox(InTitle:Str40;InParams :Byte;InCommand :Word) :PMenuNode;
       Procedure   MenuBoxHelp(InHelpCtx :Str80;InDiskHelp :Word);
       Procedure   ShowSelectedMenuText(StartPoint :Word);
       Procedure   ShowMenuText(HeadPtr,TailPtr :PDynText;StartPoint :Word);
       Procedure   MenuBoxClearArea;
       Procedure   AdjustMenuBox;

       Procedure   NormalMenuBoxColor;
       Procedure   ActiveMenuBoxColor;
       Procedure   DefaultMenuBoxColor;

       Procedure   DisableMenuBox;
       Procedure   EnableMenuBox;

       Procedure   HandleMenuBoxEvent;

       Procedure   MenuBoxDeleteAllText;
   End;



   PHelpBox     = ^HelpBox;
   HelpBox      = Object (MenuBox)

       HBX1,HBY1,
       HBX2,HBY2        :Byte;
       HBVerScrBar      :PVerScrollBar;
       HBMaxLines       :Word;
       HBVisualYPosit   :Word;
       HBVirtualYPosit  :Word;

       Procedure   InitHelpBox;
       Procedure   WriteHelpStr(Str :String);
       Procedure   UnActiveTopic;
       Procedure   CheckTopic;
       Procedure   ShowHelpText;
       Procedure   FindReference(Ref :Word);
       Procedure   HandleHelpBoxEvent;
   End;



   PDropDown   = ^DropDown;
   DropDown    = Object (HelpBox)

       DDX1,DDY1,DDX2,DDY2       :Byte;
       DDCommand                 :Word;
       DDDisabled                :Boolean;
       DDHelpCtx                 :^Str80;
       DDDiskHelp                :Word;
       DDText                    :PDynText;
       DDSavText                 :PDynText;
       DDHeadTextLine            :PDynText;
       DDRearTextLine            :PDynText;
       DDTable                   :Boolean; {Determine whenever the table have}
                                           {to be printed upwards or downwards}
                                           {from the main Drop Down Line.    }
                                           {Default is DownWard.               }

       DDVirtualY                :Word;
       DDVisualY                 :Byte;
       DDLabel                   :Str40;
       DDLabX1,DDLabY1           :Byte;
       DDMaxLines                :Word;
       DDTableWindow             :PWinBasics;

       DDNormTxtColor            :Byte;
       DDNormBckColor            :Byte;
       DDRevTxtColor             :Byte;
       DDRevBckColor             :Byte;
       DDTableColor              :Byte;
       DDNormLabelColor          :Byte;
       DDRevLabelColor           :Byte;


       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Function    InitDropDown(InCommand :Word) :PMenuNode;
       Procedure   DropDownHelp(InHelpCtx:Str80;InDiskHelp:Word);
       Procedure   DisableDropDown;
       Procedure   EnableDropDown;
       Procedure   DropDownLabel(InX1,InY1:Byte;InLabel:Str40);
       Procedure   DropDownDownArrow;
       Procedure   DropDownUpArrow;
       Procedure   ShowDropDownText(HeadPtr,TailPtr :PDynText;StartPoint :Word);
       Procedure   DropDownDeleteAllText;
       Procedure   DefaultDropDownColor;
       Procedure   NormalDropDownColor;
       Procedure   DropDownDrawTable;
       Procedure   DropDownTableDefaultColor(MY :Byte;Str:String);
       Procedure   DropDownTableNormalColor(MY :Byte;Str:String);
       Procedure   DropDownShowTableText;
       Procedure   DropDownCloseTable;
       Procedure   HandleDropDownEvent;

   End;

{$F+}
Procedure InternalHandleCommand;
{$F-}
Procedure DisableWinCommand(Cmd :CommandsRange);
Procedure EnableWinCommand(Cmd :CommandsRange);
Function  OpenAndFindTopic(TopicNum :Word) :Byte;


Var
  TMenuBox          :PMenuBox;
  TDropDown         :PDropDown;
  THelpBox          :PHelpBox;


IMPLEMENTATION

{********************************************************************}
{Procedure InternalHandleCommand                                     }
{Is a critical piece of code and its purpose is the handle over all  }
{the internal processing that my API uses.I have the ability to send }
{the program control to my routine by setting a new address into the }
{ErrorProcessPtr.After this the program automatically reset this pointer}
{**********************************************************************}

{$F+}
Procedure InternalHandleCommand;
Begin
   IF (ActiveErrorWindow=True) and (Event >= ReservedCmOk) and (Event <= ReservedCmFail) Then
   Begin
    HeapErrorCode:=0;    {No Errors now}
    CloseErrorWindow;    {Close Error Window}
    AccessPDMenus:=PrevPDState; {Back again to normal access}
    IF ErrorProcessPtr <> Nil Then
      Asm;
        Call ErrorProcessPtr  {General Variable.We fill it only if it's absolute necessary}
      End;
    ErrorProcessPtr:=Nil;
   End
   Else
   IF (HelpWindowIsNotOpen = False) and (Event >= ReservedCmHelpStart) and (Event <= ReservedCmHelpEnd) Then
   Begin
      Case Event Of
        ReservedCmHelpCancel :Begin
                                   HelpWindowIsNotOpen:=True;
                                   CurrentHelpHistory:=0;
                                   DisposeHelp;
                                   CloseWindow;
                                   AccessPDMenus:=True; {Back again to normal access}
                              End;
        ReservedCmHelpIndex  :Begin
                                   IF CurrentHelpPtr = 0 Then
                                      Exit;
                                   MakeHistory;
                                   THelpBox^.FindReference(0);
                                   TVerScrollBar:=THelpBox^.HBVerScrBar;
                                   THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
                              End;
        ReservedCmHelpPrev   :Begin
                                   IF CurrentHelpHistory < 1 Then
                                      Exit;
                                   BackHistory;
                                   THelpBox^.FindReference(CurrentHelpPtr);
                                   TVerScrollBar:=THelpBox^.HBVerScrBar;
                                   THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
                              End;
      End;
   End;
End;
{$F-}


{***************************************************************************}
{Procedure DisableWinCommand                                                }
{ëô¨§ú† ú§ò ò§´†°ú†£ú§¶ (¶Æ† ú§ú®ö¶).                                       }
{***************************************************************************}

Procedure DisableWinCommand(Cmd :CommandsRange);
Var
    SearchPtr :PMenuNode;
Begin
   SearchPtr:=Win^.HeadMenusSeq;
   Repeat
      Case SearchPtr^.IDByte OF
         Buttons    :Begin
                       TButton:=SearchPtr^.NodePtr;
                       IF TButton^.BCommand in Cmd Then
                       Begin
                          TButton^.DisableButton;
                          SearchPtr^.Disabled:=True;
                       End;
                     End;
         InputLines  :Begin
                       TInputLine:=SearchPtr^.NodePtr;
                       IF TInputLine^.ILCommand in Cmd Then
                       Begin
                          TInputLine^.DisableInputLine;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;
        CheckBoxes   :Begin
                       TCheckBox:=SearchPtr^.NodePtr;
                       IF TCheckBox^.CBCommand in Cmd Then
                       Begin
                          TCheckBox^.DisableCheckBox;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;
       RadioButtons  :Begin
                       TRadioButton:=SearchPtr^.NodePtr;
                       IF TRadioButton^.RBCommand in Cmd Then
                       Begin
                          TRadioButton^.DisableRadioButton;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;
       VerScrollBars :Begin
                       TVerScrollBar:=SearchPtr^.NodePtr;
                       IF TVerScrollBar^.VSBCommand in Cmd Then
                       Begin
                          TVerScrollBar^.DisableVerScrollBar;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;
       MenuBoxes     :Begin
                       TMenuBox:=SearchPtr^.NodePtr;
                       IF TMenuBox^.MBCommand in Cmd Then
                       Begin
                          TMenuBox^.DisableMenuBox;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;
       DropDowns     :Begin
                       TDropDown:=SearchPtr^.NodePtr;
                       IF TDropDown^.DDCommand in Cmd Then
                       Begin
                          TDropDown^.DisableDropDown;
                          SearchPtr^.Disabled:=True;
                       End;
                      End;

      End;
      SearchPtr:=SearchPtr^.Next;
   Until (SearchPtr=Nil);
End;

{**************************************************************************}
{Procedure EnableWinCommand                                                }
{Ñ§ú®ö¶ß¶†ûú† •ò§ò ú§ò ò§´†°ú†£ú§¶                                         }
{**************************************************************************}

Procedure EnableWinCommand(Cmd :CommandsRange);
Var
    SearchPtr :PMenuNode;
Begin
   SearchPtr:=Win^.HeadMenusSeq;
   Repeat
      Case SearchPtr^.IDByte OF
         Buttons     :Begin
                       TButton:=SearchPtr^.NodePtr;
                       IF TButton^.BCommand in Cmd Then
                       Begin
                          TButton^.EnableButton;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
         InputLines  :Begin
                       TInputLine:=SearchPtr^.NodePtr;
                       IF TInputLine^.ILCommand in Cmd Then
                       Begin
                          TInputLine^.EnableInputLine;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
         CheckBoxes  :Begin
                       TCheckBox:=SearchPtr^.NodePtr;
                       IF TCheckBox^.CBCommand in Cmd Then
                       Begin
                          TCheckBox^.EnableCheckBox;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
         RadioButtons:Begin
                       TRadioButton:=SearchPtr^.NodePtr;
                       IF TRadioButton^.RBCommand in Cmd Then
                       Begin
                          TRadioButton^.EnableRadioButton;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
         VerScrollBars:Begin
                       TVerScrollBar:=SearchPtr^.NodePtr;
                       IF TVerScrollBar^.VSBCommand in Cmd Then
                       Begin
                          TVerScrollBar^.EnableVerScrollBar;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
       MenuBoxes     :Begin
                       TMenuBox:=SearchPtr^.NodePtr;
                       IF TMenuBox^.MBCommand in Cmd Then
                       Begin
                          TMenuBox^.EnableMenuBox;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;
       DropDowns     :Begin
                       TDropDown:=SearchPtr^.NodePtr;
                       IF TDropDown^.DDCommand in Cmd Then
                       Begin
                          TDropDown^.EnableDropDown;
                          SearchPtr^.Disabled:=False;
                       End;
                      End;

      End;
      SearchPtr:=SearchPtr^.Next;
   Until (SearchPtr=Nil);
End;


{---------------------------------------------------------------------------}
{-------------------------------MENU BOX------------------------------------}
{---------------------------------------------------------------------------}

Procedure MenuBox.HandleCommand;
Begin

End;

Procedure MenuBox.WinHandleEvent;
Begin

End;

Function MenuBox.InitMenuBox;
Var
   VS           :PVerScrollBar;
   ObjectX1H    :Byte;


  {******************************************************************}
  {Procedure DrawMenuBox                                             }
  {Ñ†§ò† ú©‡´ú®†°û ®¶¨´†§ò ´û™ MenuBox.InitMenuBox.ëÆúõ†òùú† ´¶ °¶¨´†}
  {úß†¢¶ö‡§.                                                         }
  {******************************************************************}
  Procedure DrawMenuBox;
  Var
     I,J          :Byte;
     DestX        :Byte;
     TraceTitle   :Str40;
     Position     :Byte;
  Begin

    IF MenuBoxDesktopColor=255 Then
       TMenuBox^.MMenuBoxDeskTopColor:=Win^.WTextBackGround;

    IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
        (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
       ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
           (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    {Clear Box}

    For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
         For J:=Win^.X1+TMenuBox^.MBX1+1 to Win^.X1+TMenuBox^.MBX2-1 do
            WriteVirtWinChar(J,I,TMenuBox^.MMenuBoxNormTxtColor,TMenuBox^.MMenuBoxDeskTopColor,32);

    {Make Title Bar}

    IF TMenuBox^.MBVerScrBar <> Nil Then
       DestX:=Win^.X1+TMenuBox^.MBX2+1+Byte(VgaExist)
    Else
       DestX:=Win^.X1+TMenuBox^.MBX2;

    IF TMenuBox^.MBTitle<>'' Then
       For I:=Win^.X1+TMenuBox^.MBX1 to DestX do
           WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,0,TMenuBox^.MMenuBoxNormBckColor,32);

    {Only for Vga cards}

    IF VgaExist=True Then
    Begin

       {Make Vertical Lines}

       For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
       Begin
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,I,TMenuBox^.MMenuBoxNormTxtColor,
                TMenuBox^.MMenuBoxDeskTopColor,WCLfVerLineS);
           IF TMenuBox^.MBVerScrBar = Nil Then
               WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,I,TMenuBox^.MMenuBoxNormTxtColor,
                    TMenuBox^.MMenuBoxDeskTopColor,WCRgVerLineS);
       End;

       {Horizontal Lines}

        For I:=Win^.X1+TMenuBox^.MBX1+1 to DestX do
        Begin
            WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
                 TMenuBox^.MMenuBoxDeskTopColor,WCDnHorLineS);
            IF TMenuBox^.MBTitle='' Then
               WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
                 TMenuBox^.MMenuBoxDeskTopColor,WCUpHorLineS);
        End;

       {And.... Corners}

        WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
             TMenuBox^.MMenuBoxDeskTopColor,WCDnLfCornerS);

        IF TMenuBox^.MBVerScrBar = Nil Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
                                TMenuBox^.MMenuBoxDeskTopColor,WCDnRgCornerS);

        IF TMenuBox^.MBTitle='' Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
               TMenuBox^.MMenuBoxDeskTopColor,WCUpLfCornerS);
    End
    Else

    {Now for the Older Video Cards}

    Begin

       {Vertical Lines}

       For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
       Begin
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,I,TMenuBox^.MMenuBoxNormTxtColor,
               TMenuBox^.MMenuBoxDeskTopColor,SCLfVerLine);
           IF (TMenuBox^.MBStatus and VerRightDrawing) = VerRightDrawing Then
               WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,I,TMenuBox^.MMenuBoxNormTxtColor,
                    TMenuBox^.MMenuBoxDeskTopColor,SCRgVerLine);
       End;

       {Horizontal Line}

        For I:=Win^.X1+TMenuBox^.MBX1+1 to DestX do
        Begin
            WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
                 TMenuBox^.MMenuBoxDeskTopColor,SCDnHorLine);
            IF TMenuBox^.MBTitle='' Then
              WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
                 TMenuBox^.MMenuBoxDeskTopColor,SCDnHorLine);
        End;

       {And Corners}

        WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
             TMenuBox^.MMenuBoxDeskTopColor,SCDnLfCorner);
        IF TMenuBox^.MBVerScrBar = Nil Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,Win^.Y1+TMenuBox^.MBY2,TMenuBox^.MMenuBoxNormTxtColor,
                TMenuBox^.MMenuBoxDeskTopColor,SCDnRgCorner);
        IF TMenuBox^.MBTitle='' Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
              TMenuBox^.MMenuBoxDeskTopColor,SCUpLfCorner);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    Position:=Pos('~',TMenuBox^.MBTitle);
    IF Position<>0 Then
    Begin
      TraceTitle:=Copy(TMenuBox^.MBTitle,1,Position-1);
      TraceTitle:=TraceTitle+Copy(TMenuBox^.MBTitle,Position+1,Length(TMenuBox^.MBTitle));
    End
    Else
      TraceTitle:=TMenuBox^.MBTitle;

    IF TMenuBox^.MBTitle <> '' Then
    Begin
      X1:=Win^.X1+TMenuBox^.MBX1;
      X2:=DestX;
      DestX:=Round( ( (X2-X1)-Length(TraceTitle) ) div 2 );

      WriteTextBackGround:=TMenuBox^.MMenuBoxNormBckColor;
      WriteTextColor:=0;
      WriteStrandMark(X1+DestX,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MBTitle);
    End;
  End;


{*********************************************************************}
{From here starts the real object routine.                            }
{*********************************************************************}

Begin

    IF (InParams and VerScr) = VerScr Then
    Begin
      ObjectX1H:=ObjectX1;
      ObjectX1:=ObjectX2-1;

      IF InTitle <> '' Then
         Inc(ObjectY1);
      VS:=InitVerScrollBar(NoCm);
      ObjectX1:=ObjectX1H;

      IF InTitle <> '' Then
         Dec(ObjectY1);
    End
    Else
        VS:=Nil;

    IF HeapErrorCode=1 Then
    Begin
        TMenuBox:=Nil;
        Exit;
    End;

    New(TMenuBox);

    IF TMenuBox=Nil Then
       Exit;


    TMenuBox^.MBVerScrBar:=VS;
    TMenuBox^.MBX1:=ObjectX1;
    TMenuBox^.MBY1:=ObjectY1;
    IF VS <> Nil Then
       TMenuBox^.MBX2:=ObjectX2-Abs(ObjectX2-TMenuBox^.MBVerScrBar^.VSBX1)-Byte(VgaExist)
    Else
       TMenuBox^.MBX2:=ObjectX2;
    TMenuBox^.MBY2:=ObjectY2;
    TMenuBox^.MBHelpCtx:=Nil;
    TMenuBox^.MBDiskHelp:=0;
    TMenuBox^.MBDisabled:=False;
    TMenuBox^.MBText:=Nil;
    TMenuBox^.MBStatus:=Status;
    TMenuBox^.MBTitle:=InTitle;
    TMenuBox^.MBMaxChoise:=0;
    TMenuBox^.MBCommand:=InCommand;
    TMenuBox^.MBMenuBoxAutoNext:=Boolean((InParams and AutoNext) = AutoNext);

    TMenuBox^.MBHeadTextLine:=Nil;
    TMenuBox^.MBRearTextLine:=Nil;

    TMenuBox^.MBVisualYPosit:=1;
    TMenuBox^.MBVirtualYPosit:=1;

    TMenuBox^.MMenuBoxNormTxtColor      :=MenuBoxNormTxtColor;
    TMenuBox^.MMenuBoxNormBckColor      :=MenuBoxNormBckColor;
    TMenuBox^.MMenuBoxRevTxtColor       :=MenuBoxRevTxtColor;
    TMenuBox^.MMenuBoxRevBckColor       :=MenuBoxRevBckColor;
    TMenuBox^.MMenuBoxSelectBckColor    :=MenuBoxSelectBckColor;
    TMenuBox^.MMenuBoxSelectTxtColor    :=MenuBoxSelectTxtColor;
    TMenuBox^.MMenuBoxNoSelectTxtColor  :=MenuBoxNoSelectTxtColor;
    TMenuBox^.MMenuBoxDeskTopColor      :=MenuBoxDesktopColor;

    {If we have at least one scroll bar (either Vertical or Horizontal) then}
    {don't make new MenuSeq,just change the boundaries.                     }

    IF TMenuBox^.MBVerScrBar<>Nil Then
    Begin
      Win^.TailMenusSeq^.IDByte:=MenuBoxes;
      Win^.TailMenusSeq^.NodePtr:=TMenuBox;
      Win^.TailMenusSeq^.X1:=ObjectX1;
      Win^.TailMenusSeq^.Y1:=ObjectY1;
      Win^.TailMenusSeq^.X2:=ObjectX2+Abs(ObjectX2-TMenuBox^.MBVerScrBar^.VSBX2);
      Win^.TailMenusSeq^.Y2:=ObjectY2;
      Win^.TailMenusSeq^.BroadCast:=BroadCastChar(InTitle);
    End
    Else

    {If haven't any scrollers then just go ahead with the usual way}

    NewMenusSeq(MenuBoxes,TMenuBox,BroadCastChar(InTitle),ObjectX1,ObjectY1,ObjectX2,ObjectY2);

    DrawMenuBox;


    {Users read only variables}
    MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
    MenuBoxCurrentStr:='';

    {Return the pointer to the caller}

    InitMenuBox:=Win^.TailMenusSeq;

End;

Procedure MenuBox.MenuBoxClearArea;
Begin
    WriteTextColor:=Win^.WTextColor;
    WriteTextBackGround:=Win^.WTextBackGround;
    TextPaint(TMenuBox^.MBX1+1,TMenuBox^.MBY1+1,TMenuBox^.MBX2-1,TMenuBox^.MBY2-1,0);
End;

Procedure MenuBox.MenuBoxHelp;
Begin
    IF (TMenuBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TMenuBox^.MBHelpCtx:=Nil
    Else
    Begin
        New(TMenuBox^.MBHelpCtx);
        IF TMenuBox^.MBHelpCtx=Nil Then
           Exit;
        TMenuBox^.MBHelpCtx^:=InHelpCtx;
    End;

    TMenuBox^.MBDiskHelp:=InDiskHelp;
End;

Procedure MenuBox.MenuBoxDeleteAllText;
Begin
    TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

    Repeat
         IF (TMenuBox^.MBText<>Nil) Then
         Begin
             FreeMem(TMenuBox^.MBText^.TextLine,Length(TMenuBox^.MBText^.TextLine^)+1);
             TMenuBox^.MBHeadTextLine:=TMenuBox^.MBText;
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
             Dispose(TMenuBox^.MBHeadTextLine);
         End;
    Until TMenuBox^.MBText = Nil;

    TMenuBox^.MBHeadTextLine:=Nil;
    TMenuBox^.MBRearTextLine:=Nil;
    TMenuBox^.MBText:=Nil;

End;

Procedure MenuBox.ShowSelectedMenuText(StartPoint :Word);
Var
    MaxVisualTexts :Word; {Max menus available}
    I              :Word;
    LenDif         :Integer;
    XVision        :Word; {How many chars in X dimension}
    CurrentChoise  :LongInt;
    YVOffset       :Word;
    TraceText      :PDynText;

    Procedure PrintChoises;
    Var
       K        :Word;
    Begin
           LenDif:=XVision - Length(TMenuBox^.MBText^.TextLine^);
           {Ñò§ ´¶ £úöúü¶™ ´¶¨ string ú†§ò† £úöò¢¨´ú®¶ òß¶ ´¶ ßò®òü¨®¶}
           {úß†¢¶öû™ ´¶´ú Æ®û©†£¶ß¶†û©ú ´û§ Copy.                     }

           IF LenDif <= 0 Then
              WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),
                       Copy(TMenuBox^.MBText^.TextLine^,1,XVision))
           Else
           Begin
              WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),
                       TMenuBox^.MBText^.TextLine^);

              For K:=Win^.X1+TMenuBox^.MBX1+1+(Length(TMenuBox^.MBText^.TextLine^))
                     To Win^.X1+TMenuBox^.MBX1+XVision Do
                  WriteVirtWinChar(K,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),WriteTextColor,WriteTextBackGround,32);
           End;

    End;

Begin

     {è¶©ú™ úß†¢¶öú™ ©´¶§ ì ò•¶§ò}
      MaxVisualTexts:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
      Inc(MaxVisualTexts);

      XVision:=(TMenuBox^.MBX2) - (TMenuBox^.MBX1+1);

      {Print it }

      IF (StartPoint < 1) Or (StartPoint > TMenuBox^.MBMaxChoise) Then
         StartPoint:=1;

      CurrentChoise:=StartPoint;
      TMenuBox^.MBVisualYPosit:=1;


      {âò§ú £ú®†°¶¨™ ú¢úöÆ¶¨™ ö†ò ´û§ ß®‡´û úß†¢¶öû ß¶¨ üò ò®Æ†©¶¨£ú §ò}
      {´¨ß‡§¶¨£ú.                                                      }

      IF StartPoint <> 1  Then
      Begin
         IF (StartPoint + (MaxVisualTexts-1)) > (TMenuBox^.MBMaxChoise) Then
         Begin
            StartPoint:=TMenuBox^.MBMaxChoise - (MaxVisualTexts-1);
            IF StartPoint <= 0 Then
            Begin
               StartPoint:=1;
               TMenuBox^.MBVisualYPosit:=CurrentChoise;
            End
            Else
               TMenuBox^.MBVisualYPosit:=(CurrentChoise-StartPoint)+1;
         End
         Else
         IF (StartPoint < 0) OR (StartPoint > TMenuBox^.MBMaxChoise) Then
         Begin
            StartPoint:=1;
            TMenuBox^.MBVisualYPosit:=CurrentChoise;
         End;

      End;

      {*********** Now Starts the Printing Process **********************}

      YVOffset:=1;
      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      {Find The right MBText                                            }

      IF StartPoint > 1 Then
         For I:=1 to StartPoint-1 do
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;


      I:=StartPoint;
      TraceText:=TMenuBox^.MBText;
      TMenuBox^.MBVirtualYPosit:=CurrentChoise;
      Repeat

         {Come Here To Show The Current Choise}
         IF I=CurrentChoise Then
         Begin

           {BackGround Color}
           IF TMenuBox^.MBText^.TLineBackGround = $FF Then
               WriteTextBackGround:=TMenuBox^.MMenuBoxDeskTopColor
           Else
               WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

           {TextColor}
           IF TMenuBox^.MBText^.TLineColor = $FF Then
               WriteTextColor:=TMenuBox^.MMenuBoxNoSelectTxtColor
           Else
               WriteTextColor:=TMenuBox^.MBText^.TLineColor;

           PrintChoises;


         End
         Else

         {For all other choises come here}
         Begin

           {BackGround Color}
           IF TMenuBox^.MBText^.TLineBackGround = $FF Then
               WriteTextBackGround:=TMenuBox^.MMenuBoxDeskTopColor
           Else
               WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

           {TextColor}
           IF TMenuBox^.MBText^.TLineColor = $FF Then
               WriteTextColor:=TMenuBox^.MMenuBoxNormTxtColor
           Else
               WriteTextColor:=TMenuBox^.MBText^.TLineColor;

           PrintChoises;

         End;

         Inc(YVOffset);
         Inc(I);
         TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

      Until (StartPoint+MaxVisualTexts <= I) or (TMenuBox^.MBText=Nil);

      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      {Find The right MBText                                            }

      IF CurrentChoise > 1 Then
         For I:=1 to CurrentChoise-1 do
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;


End;

{*************************************************************************}
{Procedure MenuBox.ShowMenuText                                           }
{í¨ß‡§ú† ´†™ úß†¢¶öú™ òß¶ £†ò ©¨ö°ú°®†£ú§û úß†¢¶öû.ï®û©†£¶ß¶†ú†´ò† £¶§¶   }
{ö†ò ´û§ ß®‡´û ≠¶®ò £†ò™ °ò† °ò§ú† °ò† initialize.                        }
{*************************************************************************}

Procedure MenuBox.ShowMenuText;
Var
    I      :Word;
Begin
    IF TMenuBox = Nil Then
       Exit;

    MenuBoxClearArea;

    TMenuBox^.MBHeadTextLine:=HeadPtr;
    TMenuBox^.MBRearTextLine:=TailPtr;

    TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

    IF TMenuBox^.MBText <> Nil Then
    Begin


      I:=0; {Count how many texts we have}
      Repeat
         IF TMenuBox^.MBText<>Nil Then
         Begin
           Inc(I);
           TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
         End;
      Until (TMenuBox^.MBText=Nil);

      TMenuBox^.MBMaxChoise:=I;

      IF TMenuBox^.MBVerScrBar <> Nil Then
      Begin
         TMenuBox^.MBVerScrBar^.VSBMaxChoises:=I; {VerScrollBar needs this number}
                                                  {If we don't pass this number automacally}
                                                  {we must pass it manually.               }
         TMenuBox^.MBVerScrBar^.VSBPointerStep:=Trunc(I / ( (TMenuBox^.MBVerScrBar^.VSBY2-1) -
                                                    (TMenuBox^.MBVerScrBar^.VSBY1)) );
      End;

      IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
          (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
             (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
      Begin
        HiddenMouseCursor;
        HiddenMouse:=True;
      End;

      ShowSelectedMenuText(StartPoint);
      IF TMenuBox^.MBVerScrBar<>Nil Then
      Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=StartPoint;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
      End;

      IF HiddenMouse Then
      Begin
        ShowMouseCursor;
        HiddenMouse:=False;
      End;

      MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
      MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

      IF TMenuBox^.MBVerScrBar = Nil Then
         Exit;

      IF (TMenuBox^.MBVerScrBar^.VSBMaxChoises < ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1+1)+1)) Then
          TMenuBox^.MBVerScrBar^.ClearVerScrollBarPointer
      Else
          TMenuBox^.MBVerScrBar^.NormalVerSCrollBarColor;

    End; {IF MBText<>nil}
End;

Procedure PrintCurrentChoise;
Var
   K               :Word;
   LenDif          :Integer;
   XVision         :Byte;
Begin
    XVision:=(TMenuBox^.MBX2) - (TMenuBox^.MBX1+1);

    IF TMenuBox^.MBText<>Nil Then
    Begin

        LenDif:=XVision - Length(TMenuBox^.MBText^.TextLine^);
       {Ñò§ ´¶ £úöúü¶™ ´¶¨ string ú†§ò† £úöò¢¨´ú®¶ òß¶ ´¶ ßò®òü¨®¶}
       {úß†¢¶öû™ ´¶´ú Æ®û©†£¶ß¶†û©ú ´û§ Copy.                     }


        IF LenDif <= 0 Then
           WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,
                    Copy(TMenuBox^.MBText^.TextLine^,1,XVision))
        Else
        Begin
           WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,
                    TMenuBox^.MBText^.TextLine^);

           For K:=Win^.X1+TMenuBox^.MBX1+1+(Length(TMenuBox^.MBText^.TextLine^))
               To Win^.X1+TMenuBox^.MBX1+XVision Do
                   WriteVirtWinChar(K,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,WriteTextColor,WriteTextBackGround,32);
        End;

    End;

End;



Procedure MenuBox.ActiveMenuBoxColor;
Begin

    {BackGround Color}
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=TMenuBox^.MMenuBoxDeskTopColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    {TextColor}
    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=TMenuBox^.MMenuBoxNoSelectTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;

    IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
        (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
       ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
           (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    PrintCurrentChoise;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

Procedure MenuBox.NormalMenuBoxColor;
Begin

    {BackGround Color}
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=TMenuBox^.MMenuBoxDeskTopColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    {TextColor}
    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=TMenuBox^.MMenuBoxNormTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;

    IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
        (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
       ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
           (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    PrintCurrentChoise;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

End;


Procedure MenuBox.DefaultMenuBoxColor;
Begin
    {BackGround Color}
    WriteTextBackGround:=TMenuBox^.MMenuBoxSelectBckColor;

    {TextColor}
    WriteTextColor:=TMenuBox^.MMenuBoxSelectTxtColor;

    {No changes in the default color are allowed}

    {
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=TMenuBox^.MMenuBoxSelectBckColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=TMenuBox^.MMenuBoxSelectTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;
    }

    IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
        (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
       ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
           (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    PrintCurrentChoise;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

End;

Procedure MenuBox.DisableMenuBox;
Var
   DestX,I        :Byte;
   Position       :Byte;
Begin
     NormalMenuBoxColor;

    IF TMenuBox^.MBVerScrBar <> Nil Then
    Begin
       TVerScrollBar:=TMenuBox^.MBVerScrBar;
       TMenuBox^.MBVerScrBar^.DisableVerScrollBar;
    End;

    IF TMenuBox^.MBVerScrBar <> Nil Then
       DestX:=Win^.X1+TMenuBox^.MBX2+1+Byte(VgaExist)
    Else
       DestX:=Win^.X1+TMenuBox^.MBX2;

    HiddenMouseCursor;
    For I:=Win^.X1+TMenuBox^.MBX1 to DestX do
        WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,0,DisableColor,32);
    ShowMouseCursor;

End;

Procedure MenuBox.EnableMenuBox;
Var
   DestX,I        :Byte;
   Position       :Byte;
   TraceTitle     :String;
   MX1,MX2        :Byte;
Begin

    ActiveMenuBoxColor;

    IF TMenuBox^.MBVerScrBar <> Nil Then
    Begin
       TVerScrollBar:=TMenuBox^.MBVerScrBar;
       TMenuBox^.MBVerScrBar^.EnableVerScrollBar;
    End;

    IF TMenuBox^.MBVerScrBar <> Nil Then
       DestX:=Win^.X1+TMenuBox^.MBX2+1+Byte(VgaExist)
    Else
       DestX:=Win^.X1+TMenuBox^.MBX2;

    IF TMenuBox^.MBTitle <> '' Then
       For I:=Win^.X1+TMenuBox^.MBX1 to DestX do
        WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,0,TMenuBox^.MMenuBoxNormBckColor,32)
    Else
    Begin
       For I:=Win^.X1+TMenuBox^.MBX1 to DestX do
           WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
                        TMenuBox^.MMenuBoxDeskTopColor,WCUpHorLineS);

       WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
                    TMenuBox^.MMenuBoxDeskTopColor,WCUpLfCornerS);

       IF TMenuBox^.MBVerScrBar = Nil Then
          WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MMenuBoxNormTxtColor,
                TMenuBox^.MMenuBoxDeskTopColor,WCUpRgCornerS)
       Else
       Begin
          WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2+1,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MBVerScrBar^.SScrollBarNormTxtColor,
              TMenuBox^.MBVerScrBar^.SScrollBarNormBckColor,WCUpArrow1);
          WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2+2,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MBVerScrBar^.SScrollBarNormTxtColor,
              TMenuBox^.MBVerScrBar^.SScrollBarNormBckColor,WCUpArrow2);
       End;

    End;


    Position:=Pos('~',TMenuBox^.MBTitle);
    IF Position<>0 Then
    Begin
      TraceTitle:=Copy(TMenuBox^.MBTitle,1,Position-1);
      TraceTitle:=TraceTitle+Copy(TMenuBox^.MBTitle,Position+1,Length(TMenuBox^.MBTitle));
    End
    Else
      TraceTitle:=TMenuBox^.MBTitle;

    MX1:=Win^.X1+TMenuBox^.MBX1;
    MX2:=DestX;
    DestX:=Round( ( (MX2-MX1)-Length(TraceTitle) ) div 2 );

    WriteTextBackGround:=TMenuBox^.MMenuBoxNormBckColor;
    WriteTextColor:=0;
    WriteStrandMark(MX1+DestX,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MBTitle);

End;

{*************************************************************************}
{Procedure MenuBox.AdjustMenuBox                                          }
{ãú´ò´¶ß†ùú† ´¶ °ú†£ú§¶ ò§ò¢¶öò £ú ´¶§ pointer ´¶¨ VerScrollBar.          }
{*************************************************************************}
Procedure MenuBox.AdjustMenuBox;
Var
    MaxVis       :Byte;
    MaxVisPtr    :Byte;
    I            :Word;
    CurrentChoise:Word;
Begin
   IF (TMenuBox^.MBVerScrBar=Nil) OR
        (TMenuBox^.MBVerScrBar^.VSBMaxChoises < ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1+1)+1)) Then
      Exit;

   MaxVis:=(TMenuBox^.MBY2-1)-(TMenuBox^.MBY1);
   MaxVisPtr:=(TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1);
   TMenuBox^.MBVisualYPosit:=1;

   {IF VerScrollBar Pointer is on the First Position}
   IF TMenuBox^.MBVerScrBar^.VSBPointer = 1 Then
   Begin
      TMenuBox^.MBVirtualYPosit:=1;
      CurrentChoise:=1;
      TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=1;
      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
         DefaultMenuBoxColor;
         Inc(TMenuBox^.MBVisualYPosit);
         For I:=1 to MaxVis-1 do
         Begin
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
            NormalMenuBoxColor;
            Inc(TMenuBox^.MBVisualYPosit);
         End;
         TMenuBox^.MBVisualYPosit:=1;
         TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
      End;

   End
   Else
   {IF VerScrollBar Pointer is on the Last Position}

   IF TMenuBox^.MBVerScrBar^.VSBPointer = MaxVisPtr Then
   Begin
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
         CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBMaxChoises - MaxVis;
         Inc(CurrentChoise);
         TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
         TMenuBox^.MBVisualYPosit:=MaxVis;

         DefaultMenuBoxColor;
         Dec(TMenuBox^.MBVisualYPosit);
         For I:=TMenuBox^.MBVerScrBar^.VSBMaxChoises downto CurrentChoise+1 do
         Begin
            TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
            NormalMenuBoxColor;
            Dec(TMenuBox^.MBVisualYPosit);
         End;
         TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
         TMenuBox^.MBVisualYPosit:=MaxVis;
         TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
      End
      Else
      Begin
        TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
        TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
        TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
        For I:=1 to MaxVis-1 do
            TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
        CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
      End;
   End
   Else

   {IF VerScrollBar Pointer is non of the above positions}
   Begin
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep > 1 Then
      Begin
        CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBPointer * TMenuBox^.MBVerScrBar^.VSBPointerStep;
        IF CurrentChoise+MaxVis > TMenuBox^.MBVerScrBar^.VSBMaxChoises Then
        Begin
            I:=(CurrentChoise+MaxVis) - TMenuBox^.MBVerScrBar^.VSBMaxChoises;
            CurrentChoise:=CurrentChoise-I;
            IF CurrentChoise < 0 Then
               CurrentChoise:=1;
        End;
        TMenuBox^.MBVisualYPosit:=1;
        TMenuBox^.MBVirtualYPosit:=CurrentChoise;
        TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
        TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
        IF CurrentChoise > 1 Then
           For I:=1 to CurrentChoise-1 do
               TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
      End
      Else
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
          CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBPointer;
          TMenuBox^.MBVisualYPosit:=1;
          TMenuBox^.MBVirtualYPosit:=CurrentChoise;
          TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
          TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

          For I:=1 to MaxVis do
          Begin
            IF I=CurrentChoise Then
               DefaultMenuBoxColor
            Else
               NormalMenuBoxColor;
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
            Inc(TMenuBox^.MBVisualYPosit);
          End;

          TMenuBox^.MBVisualYPosit:=CurrentChoise;
          TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
          IF TMenuBox^.MBVisualYPosit > 1 Then
            For I:=1 to TMenuBox^.MBVisualYPosit-1 do
                TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

      End;
   End;


   IF TMenuBox^.MBVerScrBar^.VSBPointerStep > 1 Then
   Begin
     For I:=1 to MaxVis do
     Begin
        NormalMenuBoxColor;

        {End of the Choises? If Yes SET the Last choise}
        IF TMenuBox^.MBVerScrBar^.VSBPointer = MaxVisPtr Then
        Begin
          IF I = MaxVis Then
                DefaultMenuBoxColor;
        End
        Else
        {If not the SET the First choise}
        IF I=1 Then
           DefaultMenuBoxColor;

        Inc(TMenuBox^.MBVisualYPosit);
        TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
     End;

     Dec(TMenuBox^.MBVisualYPosit);   {Dec-1 because the For Loop inc the final result by 1}
     TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
     IF CurrentChoise > 1 Then
        For I:=1 to CurrentChoise-1 do
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

     IF CurrentChoise <> TMenuBox^.MBVerScrBar^.VSBMaxChoises Then
        TMenuBox^.MBVisualYPosit:=1
     Else
        TMenuBox^.MBVisualYPosit:=MaxVis;
   End;

End;

{*************************************************************************}
{Procedure MenuBox.HandleMenuBoxEvent                                     }
{Ñ°´ú¢ú† °òüú öúö¶§¶™ ú†´ú ß¢û°´®¶¢¶ö†¶¨ ú†´ú ß¶§´†°†¶¨.Ñ†§ò† û °ú§´®†°û  }
{®¶¨´†§ò ´¶¨ ò§´†°ú†£ú§¶¨ °ò† ßú®†¢ò£ôò§ú† ú©‡´ú®†°ò ò¢¢ú™ £†°®¶´ú®ú™     }
{õ†òõ†°ò©†ú™.                                                             }
{*************************************************************************}
Procedure MenuBox.HandleMenuBoxEvent;
Var
   Answer       :Boolean;

Procedure CallVerScrollKBEvent;
Var
   TempObjectPtr        :Pointer;
Begin
   {If we haven't any ver scroll bar then just exit                     }
   IF TMenuBox^.MBVerScrBar = Nil Then
      Exit;

   Event:=0;  {KeyBoard event}
   TempObjectPtr:=Win^.CurMenusSeq^.NodePtr; {Keep the current node somewhere temp}
   Win^.CurMenusSeq^.NodePtr:=TMenuBox^.MBVerScrBar; {Put scroller pointer into}
   TMenuBox^.MBVerScrBar^.HandleVerScrollBarEvent; {Call Scroller procedure}
   Win^.CurMenusSeq^.NodePtr:=TempObjectPtr; {And then come to previous position}
End;


Procedure HandleKBMenuBoxEvent;
Var
        TraceVY           :Byte;
        I                 :Word;
        TraceText         :PDynText;
        YDif              :Word;
        Delayer           :Word;
        Delayer2          :Word;
        TracePointer      :Byte;
        MyMouseX,MyMouseY :Byte;
        J                 :LongInt;
        MouseResponse     :Boolean;
Begin

    TMenuBox:=Win^.CurMenusSeq^.NodePtr;

    IF TMenuBox^.MBVerScrBar <> Nil Then
       TVerScrollBar:=TMenuBox^.MBVerScrBar;

    CurrentHelpPtr:=TMenuBox^.MBDiskHelp;

    {For Keyboard come here}
     IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin


        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;

        DefaultMenuBoxColor;
        IF TMenuBox^.MBVerScrBar <> Nil Then
           TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

        IF TMenuBox^.MBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
           ShowHelpCtx(TMenuBox^.MBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

        MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
        MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

    End
    Else

    {For Mouse come here}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        MouseResponse:=True;

        {Up Arrow}

        IF TMenuBox^.MBVerScrBar <> Nil Then
        Begin
          IF (InterMX+1 in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBMenuBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1);

             Repeat
               Ctrl:=#0;
               Ascii:=#72;
               HandleKBMenuBoxEvent;
               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;


               Repeat
                RetraceDelay(Delayer);
                Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Down Arrow}

          IF (InterMX+1 in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBMenuBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2);

             Repeat
               Ctrl:=#0;
               Ascii:=#80;
               HandleKBMenuBoxEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;

               Repeat
                 RetraceDelay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Get the Scroller Pointer and move it}

          IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+(TMenuBox^.MBVerScrBar^.VSBPointer)) )
              AND ((TMenuBox^.MBVerScrBar^.VSBMaxChoises)
                        >= ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1+1)+1)) Then
          Begin

            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            {Make the initials adjustments}
            IF TMenuBox^.MBVerScrBar <> Nil Then
               TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

            IF TMenuBox^.MBHelpCtx<>Nil Then
            Begin
              Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
              ShowHelpCtx(TMenuBox^.MBHelpCtx^);
            End
            Else
             Begin
               Win^.CurrentMessageLine:='';
               ShowHelpCtx('');
             End;

             IF TMenuBox^.MBVerScrBar<>Nil Then
                TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;


             NormalMenuBoxColor;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2-1);

             Repeat
                MYMouseX:=InterMX+1;MYMouseY:=InterMY+1;

                IF (MyMouseX in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
                     and (MyMouseY in [Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1..Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2-1]) Then
                Begin
                  TracePointer:=(MyMouseY-(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1))+1;
                  IF TracePointer <> TMenuBox^.MBVerScrBar^.VSBPointer Then
                  Begin
                     TMenuBox^.MBVerScrBar^.VSBPointer:=TracePointer;
                     TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;
                  End;
                End;
             Until (MouseButton=MsIdle);

             AdjustMenuBox;

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);

             MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
             MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
             Event:=TMenuBox^.MBCommand;
             HandleCommand;

          End
          Else
            MouseResponse:=False;
        End {IF MBVerScrBar <> Nil}
        Else
           MouseResponse:=False;


        {Mark the Choise}
        IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2-1])) AND (MouseResponse=False)
           AND ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1+1..Win^.Y1+TMenuBox^.MBY2-1])) Then
        Begin
            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            IF TMenuBox^.MBVerScrBar <> Nil Then
               TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

            IF TMenuBox^.MBHelpCtx<>Nil Then
            Begin
               Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
               ShowHelpCtx(TMenuBox^.MBHelpCtx^);
            End
            Else
            Begin
               Win^.CurrentMessageLine:='';
               ShowHelpCtx('');
            End;

            NormalMenuBoxColor;

            I:=(MouseY - (Win^.Y1+TMenuBox^.MBY1));
            IF (TMenuBox^.MBVirtualYPosit + (I - TMenuBox^.MBVisualYPosit) > TMenuBox^.MBMaxChoise)
                Or (TMenuBox^.MBVirtualYPosit + (I - TMenuBox^.MBVisualYPosit) < 1) Then
            Begin
                DefaultMenuBoxColor;
                MenuBoxDoubleClick:=False;
                msLeftDoubleClick:=False;
                Exit;
            End;
            TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVirtualYPosit + (I - TMenuBox^.MBVisualYPosit);
            TMenuBox^.MBVisualYPosit:=I;
            TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
             IF TMenuBox^.MBVirtualYPosit > 1 Then
                 For I:=1 to TMenuBox^.MBVirtualYPosit-1 do
                     TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

              DefaultMenuBoxColor;

              IF TMenuBox^.MBVerScrBar<>Nil Then
              Begin
                TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVirtualYPosit;
                TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
                TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
              End;

              IF  msLeftDoubleClick Then
                  MenuBoxDoubleClick := True
              Else
                  MenuBoxDoubleClick :=False;

              MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
              MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
              Event:=TMenuBox^.MBCommand;
              HandleCommand;

              NormalMenuBoxColor;
              DefaultMenuBoxColor;

        End
        Else
        IF MouseResponse=False Then
        Begin
            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            DefaultMenuBoxColor;
        End
        Else
        Begin
            Ctrl:=#$FF;
            Ascii:=#$FF;
            HandleKBMenuBoxEvent;
        End;

        MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
        MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
    End {IF Mouse}
    Else
    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TMenuBox:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TMenuBox Then
           Begin
             IF TMenuBox^.MBVerScrBar<>Nil Then
                TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
             Win^.CurMenusSeq:=CtrlPressed.Address;
             ActiveMenuBoxColor;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and  (Ascii=#77)  )Then
    Begin
         ActiveMenuBoxColor;
         IF TMenuBox^.MBVerScrBar <> Nil Then
            TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
         MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
         MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
         Event:=TMenuBox^.MBCommand;
         HandleCommand;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and  (Ascii=#75)  )Then
    Begin
         CurOff;
         ActiveMenuBoxColor;
         IF TMenuBox^.MBVerScrBar <> Nil Then
            TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
         MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
         MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
         Event:=TMenuBox^.MBCommand;
         HandleCommand;


         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    {Down Arrow come here......                                         }

    IF ((Ctrl=#0) and (Ascii=#80)) Then
    Begin
       IF TMenuBox^.MBText^.NextTextLine = Nil Then
          Exit;  {If we haven't any vertical scroller then exit}

       NormalMenuBoxColor; {Normal Colors}

       TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
       Inc(TMenuBox^.MBVisualYPosit);
       Inc(TMenuBox^.MBVirtualYPosit);

       {Scrolling Down Routine}

       IF TMenuBox^.MBVisualYPosit+TMenuBox^.MBY1 > TMenuBox^.MBY2-1 Then
       Begin
           Dec(TMenuBox^.MBVisualYPosit);
           YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
           TraceText:=TMenuBox^.MBText;
           TraceVY:=TMenuBox^.MBVisualYPosit;

           For I:=1 to YDif do
           Begin
               TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
               Dec(TMenuBox^.MBVisualYPosit);
               NormalMenuBoxColor;
           End;


           TMenuBox^.MBText:=TraceText;
           TMenuBox^.MBVisualYPosit:=TraceVY

       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Up Arrow come here.........                                        }

    IF ((Ctrl=#0) and (Ascii=#72)) Then
    Begin
       IF TMenuBox^.MBVirtualYPosit-1 = 0 Then
          Exit; {If we haven't any vertical scroller then exit}

       NormalMenuBoxColor;

       TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
       Dec(TMenuBox^.MBVisualYPosit);
       Dec(TMenuBox^.MBVirtualYPosit);

       {Scrolling Up Routine}

       IF TMenuBox^.MBVisualYPosit+TMenuBox^.MBY1 < TMenuBox^.MBY1+1 Then
       Begin
           Inc(TMenuBox^.MBVisualYPosit);
           YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
           TraceText:=TMenuBox^.MBText;
           TraceVY:=TMenuBox^.MBVisualYPosit;
           For I:=1 to YDif do
           Begin
              TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
              Inc(TMenuBox^.MBVisualYPosit);
              NormalMenuBoxColor;
           End;

           TMenuBox^.MBText:=TraceText;
           TMenuBox^.MBVisualYPosit:=TraceVY
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Page Down}
    IF ((Ctrl=#0) and (Ascii=#81)) and (TMenuBox^.MBVirtualYPosit < TMenuBox^.MBMaxChoise) Then
    Begin
       YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1);
       I:=TMenuBox^.MBVirtualYPosit + ( (YDif - TMenuBox^.MBVisualYPosit) +1);
       IF I+Ydif > TMenuBox^.MBMaxChoise Then
          I:=TMenuBox^.MBMaxChoise;

       IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
           (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
          ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
              (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;


       ShowSelectedMenuText(I);

       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;

       IF TMenuBox^.MBVerScrBar<>Nil Then
       Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVirtualYPosit;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
         TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Page Up}
    IF ((Ctrl=#0) and (Ascii=#73)) and (TMenuBox^.MBVirtualYPosit > 1) Then
    Begin
       YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1);
       IF (TMenuBox^.MBVirtualYPosit + (YDif-1)) > (TMenuBox^.MBMaxChoise) Then
          J:=TMenuBox^.MBMaxChoise - (YDif-1)
       Else
          J:=TMenuBox^.MBVirtualYPosit - (TMenuBox^.MBVisualYPosit - 1) - YDif;

       IF J < 1 Then
          J:=1;

       IF ( (InterMX+1 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) or
           (InterMX+2 in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2]) )AND
          ( (InterMY+1 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) or
              (InterMY+2 in [Win^.Y1+TMenuBox^.MBY1..Win^.Y1+TMenuBox^.MBY2]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;

       ShowSelectedMenuText(J);

       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;

       IF TMenuBox^.MBVerScrBar<>Nil Then
       Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVirtualYPosit;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
         TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Enter or Ins come here.......                              }

    IF (Ctrl=#32) Or  ( (Ctrl=#0) and (Ascii=#82) )Then
    Begin
       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
       NormalMenuBoxColor;
       DefaultMenuBoxColor;


       IF (TMenuBox^.MBMenuBoxAutoNext = True) Then
       Begin
           Ctrl:=#0;
           Ascii:=#80;
           HandleKBMenuBoxEvent;
       End;

    End;

    MsLeftDoubleClick:=False;
    MenuBoxDoubleClick:=False;
End;

Procedure HandleMsMenuBoxEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TMenuBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TMenuBox Then
           Begin
             IF TMenuBox^.MBVerScrBar<>Nil Then
             Begin
                TVerScrollBar:=TMenuBox^.MBVerScrBar;
                TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
             End;
             ActiveMenuBoxColor;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End
End;

Begin
    Case Event Of
       0:HandleKBMenuBoxEvent;
       1:HandleMsMenuBoxEvent;
    End;
End;

{-------------------------------------------------------------------------}
{----------------------------ON LINE HELP---------------------------------}
{-------------------------------------------------------------------------}
Procedure HelpBox.InitHelpBox;
Var
   SaveObjX1    :Byte;
   VS           :PVerScrollBar;
Begin
    SaveObjX1:=ObjectX1;
    ObjectX1:=ObjectX2;

    IF HeapErrorCode=1 Then
    Begin
        THelpBox:=Nil;
        Exit;
    End;

    ScrollBarNormTxtColor    := 255;
    ScrollBarNormBckColor    := 6;
    ScrollBarRevTxtColor     := 0;
    ScrollBarRevBckColor     := 6;
    VS:=InitVerScrollBar(NoCm);

    New(THelpBox);

    IF THelpBox=Nil Then
       Exit;

    ObjectX1:=SaveObjX1;

    THelpBox^.HBX1:=ObjectX1;
    THelpBox^.HBY1:=ObjectY1;
    THelpBox^.HBX2:=ObjectX2;
    THelpBox^.HBY2:=ObjectY2;
    THelpBox^.HBVerScrBar:=VS;
    THelpBox^.HBMaxLines:=0;

    THelpBox^.HBVisualYPosit:=1;
    THelpBox^.HBVirtualYPosit:=1;


    Win^.TailMenusSeq^.IDByte:=HelpBoxes;
    Win^.TailMenusSeq^.NodePtr:=THelpBox;
    Win^.TailMenusSeq^.X1:=ObjectX1;
    Win^.TailMenusSeq^.Y1:=ObjectY1;
    Win^.TailMenusSeq^.X2:=ObjectX2+Abs(ObjectX2-THelpBox^.HBVerScrBar^.VSBX2);
    Win^.TailMenusSeq^.Y2:=ObjectY2;
    Win^.TailMenusSeq^.BroadCast:=0;

    WriteTextColor:=15;
    WriteTextBackGround:=Win^.WTextBackGround;
    TextBox(ObjectX1,ObjectY1,ObjectX2-1-Byte(VgaExist),ObjectY2,SingleLines);

    HelpBorderX1:=ObjectX1;HelpBorderY1:=ObjectY1;
    HelpBorderX2:=ObjectX2-1-Byte(VgaExist);HelpBorderY2:=ObjectY2;

    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;

    ShowHelpText;

End;

{*******************************************************************}
{Procedure WriteHelpStr                                             }
{Writes a string line onto the screen taking in mind all Topic      }
{References.                                                        }
{NOTE:Characters with codes 123 and 125 ARE NOT PRINTED.            }
{*******************************************************************}

Procedure HelpBox.WriteHelpStr(Str :String);
Var
   InternX,InternTextColor,InternBackGround               :Byte;
   I                                                      :Byte;
   MyChar                                                 :String[1];
   NonPrintable                                           :Boolean;
   NewTopic,Reference                                     :Boolean;
   StrReference,StrTopic                                  :String;
   Er                                                     :Integer;
   Len                                                    :Byte;

Begin
    InternX:=Win^.X1+HelpCurX;

    InternTextColor:=HelpNormTxtColor;
    InternBackGround:=HelpNormBckColor;
    NonPrintable:=False;

    StrReference:='';
    StrTopic:='';
    NewTopic:=False;
    Reference:=False;

    For I:=1 to Length(Str) do
    Begin
        MyChar:=Copy(Str,I,1);

        IF MyChar[1]='{' Then
        Begin
                 NewTopic:=True;   {Maybe we have a new Topic...}
                 Reference:=False;
        End
        Else
        IF (MyChar[1]=':') and (NewTopic=True) Then
        Begin
            {Don't print any ":" symbol but only the Real topics}
             NonPrintable:=True;
             Reference:=True;
             NewTopic:=False;

             {If NewTopic=True and IF we encoutered ':' Then it's a}
             {new Topic for sure.Just Make the adjustments         }

             WriteTextColor:=HelpRevTxtColor;
             WriteTextBackGround:=HelpNormBckColor;

             New(CurTopicHelpXY);
             IF CurTopicHelpXY=Nil Then
                Exit;
             CurTopicHelpXY^.Next:=HeadTopicHelpXY;
             HeadTopicHelpXY:=CurTopicHelpXY;

             Len:=Length(StrTopic);
             CurTopicHelpXY^.X:=InternX-Win^.X1-Len;
             CurTopicHelpXY^.Y:=HelpCurY;

             WriteVirtWinOut(InternX-Len,Win^.Y1+HelpCurY,StrTopic);
        End
        Else
        IF MyChar[1]='}' Then
        Begin
            {If Reference topic is open then take control}
            IF Reference Then
            Begin
               CurTopicHelpXY^.Topic:=StrTopic;
               CurTopicHelpXY^.Active:=False;
               Val(StrReference,CurTopicHelpXY^.Reference,Er);
            End;

            StrTopic:='';
            Reference:=False;
            StrReference:='';
            NonPrintable:=False;
            NewTopic:=False;

        End
        Else
        IF MyChar[1]=#13 Then
        Begin

        End
        Else
        IF MyChar[1]=#10 Then
        Begin

        End
        Else
        Begin
           IF (NonPrintable=False) and (InternX > Win^.X1+HelpBorderX1) and (InternX < Win^.X1+HelpBorderX2) and
                     (Win^.Y1+HelpCurY > Win^.Y1+HelpBorderY1) and (Win^.Y1+HelpCurY < Win^.Y1+HelpBorderY2) Then
           Begin
              WriteVirtWinChar(InternX,Win^.Y1+HelpCurY,InternTextColor,InternBackGround,ord(MyChar[1]));
              Inc(InternX);
              IF NewTopic Then
                 StrTopic:=StrTopic+MyChar;
           End
           Else
           IF NonPrintable=True Then
           Begin
               StrReference:=StrReference+MyChar;
           End;

        End;
    End; {FOR}

    {Put blanks to the rest of the line ('til the end)}
    IF (InternX < Win^.X1+HelpBorderX2) and (Win^.Y1+HelpCurY > Win^.Y1+HelpBorderY1) and
             (Win^.Y1+HelpCurY < Win^.Y1+HelpBorderY2) Then
    Begin
       For I:=InternX to Win^.X1+HelpBorderX2-1 do
           WriteVirtWinChar(I,Win^.Y1+HelpCurY,InternTextColor,InternBackGround,32);
    End;

End;

Procedure HelpBox.UnActiveTopic;
Begin
    IF (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil) Then
    Begin
       CurTopicHelpXY^.Active:=False;
       WriteTextColor:=HelpRevTxtColor;
       WriteTextBackGround:=HelpNormBckColor;
       IF ( (InterMX+1 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) or
          (InterMX+2 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) )AND
         ( (InterMY+1 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) or
             (InterMY+2 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;

       WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);

       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;

       CurTopicHelpXY:=Nil;
    End;
End;

Procedure HelpBox.CheckTopic;
Var
   Found              :Boolean;
   TempTopicHelpXY    :PTopicHelpXY;
Begin
    IF CurTopicHelpXY <> Nil Then
      IF (HelpCurX >= CurTopicHelpXY^.X) and (HelpCurX < (CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)))
         and (HelpCurY = CurTopicHelpXY^.Y) and (CurTopicHelpXY^.Active=True) Then
              Exit;

     Found:=False;
     TempTopicHelpXY:=HeadTopicHelpXY;
     Repeat
          IF TempTopicHelpXY <> Nil Then
          Begin
             IF (HelpCurX >= TempTopicHelpXY^.X) and (HelpCurX < (TempTopicHelpXY^.X+Length(TempTopicHelpXY^.Topic)))
                and (HelpCurY = TempTopicHelpXY^.Y) Then
             Begin
                 WriteTextColor:=HelpRevTxtColor;
                 WriteTextBackGround:=HelpRevBckColor;
                 IF ( (InterMX+1 in [Win^.X1+TempTopicHelpXY^.X..Win^.X1+TempTopicHelpXY^.X+Length(TempTopicHelpXY^.Topic)]) or
                    (InterMX+2 in [Win^.X1+TempTopicHelpXY^.X..Win^.X1+TempTopicHelpXY^.X+Length(TempTopicHelpXY^.Topic)]) )AND
                   ( (InterMY+1 in [Win^.Y1+TempTopicHelpXY^.Y..Win^.Y1+TempTopicHelpXY^.Y]) or
                       (InterMY+2 in [Win^.Y1+TempTopicHelpXY^.Y..Win^.Y1+TempTopicHelpXY^.Y]) ) Then
                 Begin
                   HiddenMouseCursor;
                   HiddenMouse:=True;
                 End;


                 WriteVirtWinOut(Win^.X1+TempTopicHelpXY^.X,Win^.Y1+TempTopicHelpXY^.Y,TempTopicHelpXY^.Topic);

                 IF HiddenMouse Then
                 Begin
                   ShowMouseCursor;
                   HiddenMouse:=False;
                 End;

                 TempTopicHelpXY^.Active:=True;
                 Found:=True;

                 IF (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil) Then
                 Begin
                    CurTopicHelpXY^.Active:=False;
                    WriteTextColor:=HelpRevTxtColor;
                    WriteTextBackGround:=HelpNormBckColor;
                    IF ( (InterMX+1 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) or
                       (InterMX+2 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) )AND
                      ( (InterMY+1 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) or
                          (InterMY+2 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) ) Then
                    Begin
                      HiddenMouseCursor;
                      HiddenMouse:=True;
                    End;


                    WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);

                    IF HiddenMouse Then
                    Begin
                      ShowMouseCursor;
                      HiddenMouse:=False;
                    End;
                 End;

                 CurTopicHelpXY:=TempTopicHelpXY;
             End;
             TempTopicHelpXY:=TempTopicHelpXY^.Next;
          End;
     Until (Found=True) or (TempTopicHelpXY=Nil);


     IF (Found=False) and (CurTopicHelpXY<>Nil) Then
     Begin
       IF CurTopicHelpXY^.Active=True Then
       Begin
          CurTopicHelpXY^.Active:=False;
          WriteTextColor:=HelpRevTxtColor;
          WriteTextBackGround:=HelpNormBckColor;

          IF ( (InterMX+1 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) or
             (InterMX+2 in [Win^.X1+CurTopicHelpXY^.X..Win^.X1+CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)]) )AND
            ( (InterMY+1 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) or
                (InterMY+2 in [Win^.Y1+CurTopicHelpXY^.Y..Win^.Y1+CurTopicHelpXY^.Y]) ) Then
          Begin
            HiddenMouseCursor;
            HiddenMouse:=True;
          End;


          WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);

          IF HiddenMouse Then
          Begin
            ShowMouseCursor;
            HiddenMouse:=False;
          End;

          CurTopicHelpXY^.Active:=False;
          CurTopicHelpXY:=Nil;
       End;
     End;
End;

Procedure HelpBox.ShowHelpText;
Var
   I                  :Word;
   X,Y                :Word;
   HelpSeg,HelpOfs    :Word;
   MyChar             :Char;
Begin
    CurHelpData:=HeadHelpData;

    IF CurHelpData = Nil Then
       Exit;

    THelpBox^.HBMaxLines:=0;

    IF ( (InterMX+1 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) or
       (InterMX+2 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) )AND
      ( (InterMY+1 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) or
          (InterMY+2 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;



    For Y:=Win^.Y1+HelpBorderY1+1 to Win^.Y1+HelpBorderY2-1 do
        For X:=Win^.X1+HelpBorderX1+1 to Win^.X1+HelpBorderX2-1 do
            WriteVirtWinChar(X,Y,HelpNormTxtColor,HelpNormBckColor,32);


    Repeat
       If CurHelpData <> Nil Then
       Begin
         WriteHelpStr(CurHelpData^.TextLine^);
         CurHelpData:=CurHelpData^.NextTextLine;
         Inc(THelpBox^.HBMaxLines);
         Inc(HelpCurY);
       End;
    Until CurHelpData = Nil;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    TVerScrollBar:=THelpBox^.HBVerScrBar;
    THelpBox^.HBVerScrBar^.SetVerScrBarMaximumChoises(THelpBox^.HBMaxLines);
    THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;

    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;
    CurTopicHelpXY:=Nil;
    CurHelpData:=HeadHelpData;
End;

{**********************************************************}
{Procedure Error_CloseHelp                                 }
{It used From internal error process and called from the   }
{ErrorProcessPtr.                                          }
{**********************************************************}
{$F+}
Procedure Error_CloseHelp;
Begin
    HelpWindowIsNotOpen:=True;
    AccessPDMenus:=True; {Back again to normal access}
    CloseWindow;
End;
{$F-}

Procedure HelpBox.FindReference(Ref :Word);
Var
   Err  :Byte;
Begin

    DisposeHelp;
    CurrentHelpPtr:=Ref;

    Err:=OpenHelpFile;
    IF Err=1 Then
    Begin
       ErrorMessage(' I can''t open the help file on disk.'+#10+
                    ' On line help window will close immediately.',bfOk);
       ErrorProcessPtr:=@Error_CloseHelp;
       Exit;
    End;

    Err:=FindTopic(Ref);

    IF Err=1 Then
    Begin
       Err:=FindTopic(HelpHistory[CurrentHelpHistory]);
       IF Err = 1 Then
       Begin
           ErrorMessage(' Fatal Error while trying to load Help file.'+#10+
                        ' On line help window will close immediately.',bfOk);
           ErrorProcessPtr:=@Error_CloseHelp;
           Close(FileHlp);
           Exit;
       End;
       CurrentHelpPtr:=HelpHistory[CurrentHelpHistory];
    End;

    Close(FileHlp);


    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;

    THelpBox^.HBVisualYPosit:=1;
    THelpBox^.HBVirtualYPosit:=1;
    THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;


    CurOff;
    ShowHelpText;
    SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);

    THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;

End;

{*************************************************************************}
{Procedure HelpBox.HandleMenuBoxEvent                                     }
{Ñ°´ú¢ú† °òüú öúö¶§¶™ ú†´ú ß¢û°´®¶¢¶ö†¶¨ ú†´ú ß¶§´†°†¶¨.Ñ†§ò† û °ú§´®†°û  }
{®¶¨´†§ò ´¶¨ ò§´†°ú†£ú§¶¨ °ò† ßú®†¢ò£ôò§ú† ú©‡´ú®†°ò ò¢¢ú™ £†°®¶´ú®ú™     }
{õ†òõ†°ò©†ú™.                                                             }
{*************************************************************************}
Procedure HelpBox.HandleHelpBoxEvent;
Var
   Answer       :Boolean;

Procedure CallVerScrollKBEvent;
Var
   TempObjectPtr        :Pointer;
   CurHlpPtr            :Word;
Begin
   CurHlpPtr:=CurrentHelpPtr;
   Event:=0;  {KeyBoard event}
   TempObjectPtr:=Win^.CurMenusSeq^.NodePtr; {Keep the current node somewhere temp}
   Win^.CurMenusSeq^.NodePtr:=THelpBox^.HBVerScrBar; {Put scroller pointer into}
   THelpBox^.HBVerScrBar^.HandleVerScrollBarEvent; {Call Scroller procedure}
   Win^.CurMenusSeq^.NodePtr:=TempObjectPtr; {And then come to previous position}
   CurrentHelpPtr:=CurHlpPtr;
End;


Procedure HandleKBHelpBoxEvent;
Var
        I                 :Integer;
        TraceText         :PDynText;
        YDif              :Byte;
        Delayer           :Word;
        Delayer2          :Word;
        TracePointer      :Byte;
        MyMouseX,MyMouseY :Byte;
        J                 :Integer;
        MouseResponse     :Boolean;
        Stepper           :ShortInt;

{**********************************}
{Procedure ShowTextDownWards       }
{Ñ£≠ò§†ùú† òß¶ ´û§ TraceText °ò†   }
{ò§‡ ´ò õúõ¶£ú§ò ´û™ ô¶ûüú†ò™.     }
{èêÑèÑà §ò õ†§¶¨£ú ò®Æ†°û ´†£û ©´û§}
{tracetext.                        }
{**********************************}

Procedure ShowTextDownWards;
Var
        TraceVY,TraceVX   :Byte;
        I                 :Word;
        YDif              :Byte;
Begin
    YDif:=(HelpBorderY2) - (HelpBorderY1);
    Dec(YDif);

    DisposeTopicHelpXY;
    WriteTextColor:=HelpNormTxtColor;
    WriteTextBackGround:=HelpNormBckColor;

    TraceVX:=HelpCurX;
    TraceVY:=HelpCurY;

    HelpCurX:=HelpBorderX1+1;
    CurOff;
    IF ( (InterMX+1 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) or
       (InterMX+2 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) )AND
      ( (InterMY+1 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) or
          (InterMY+2 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 to YDif do
    Begin
      WriteHelpStr(TraceText^.TextLine^);
      TraceText:=TraceText^.PrevTextLine;
      Dec(HelpCurY);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    HelpCurX:=TraceVX;
    HelpCurY:=TraceVY;
    CurTopicHelpXY:=Nil;
    CheckTopic;
End;


{**********************************}
{Procedure ShowTextUpWards         }
{Ñ£≠ò§†ùú† òß¶ ´û§ TraceText °ò†   }
{°ò´‡ ´ò õúõ¶£ú§ò ´û™ ô¶ûüú†ò™.    }
{èêÑèÑà §ò õ†§¶¨£ú ò®Æ†°û ´†£û ©´û§}
{tracetext.                        }
{**********************************}

Procedure ShowTextUpWards;
Var
        TraceVX,TraceVY   :Byte;
        I                 :Integer;
        YDif              :Byte;
Begin
    YDif:=(HelpBorderY2) - (HelpBorderY1);
    Dec(YDif);

    DisposeTopicHelpXY;
    WriteTextColor:=HelpNormTxtColor;
    WriteTextBackGround:=HelpNormBckColor;

    TraceVX:=HelpCurX;
    TraceVY:=HelpCurY;

    HelpCurX:=HelpBorderX1+1;
    CurOff;

    IF ( (InterMX+1 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) or
       (InterMX+2 in [Win^.X1+HelpBorderX1+1..Win^.X1+HelpBorderX2-1]) )AND
      ( (InterMY+1 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) or
          (InterMY+2 in [Win^.Y1+HelpBorderY1+1..Win^.Y1+HelpBorderY2-1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 to YDif do
    Begin
       WriteHelpStr(TraceText^.TextLine^);
       TraceText:=TraceText^.NextTextLine;
       Inc(HelpCurY);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
    HelpCurX:=TraceVX;
    HelpCurY:=TraceVY;
    CurTopicHelpXY:=Nil;
    CheckTopic;

End;

{**************************************************************}
{Procedure AdjustHelpBox                                       }
{Adjusts text lines in proportion with the VerScrollBar Pointer}
{**************************************************************}

Procedure AdjustHelpBox;
Var
   MaxVisPtr            :Byte;
   CurrentChoise        :Integer;
   YDif                 :Byte;
   I                    :Integer;
Begin

   MaxVisPtr:=(THelpBox^.HBVerScrBar^.VSBY2-1)-(THelpBox^.HBVerScrBar^.VSBY1);
   YDif:=(HelpBorderY2) - (HelpBorderY1);
   Dec(YDif);

   {IF VerScrollBar Pointer is on the First Position}
   IF (THelpBox^.HBVerScrBar^.VSBPointer = 1) Then
   Begin
       TraceText:=HeadHelpData;
       CurHelpData:=HeadHelpData;

       HelpCurY:=HelpBorderY1+1;
       ShowTextUpWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=1;
       THelpBox^.HBVirtualYPosit:=1;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;
   End
   Else
   {IF VerScrollBar Pointer is on the Last Position}
   IF THelpBox^.HBVerScrBar^.VSBPointer = MaxVisPtr Then
   Begin
       TraceText:=TailHelpData;
       CurHelpData:=TailHelpData;

       HelpCurY:=HelpBorderY2-1;
       ShowTextDownWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=YDif;
       THelpBox^.HBVirtualYPosit:=THelpBox^.HBMaxLines;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBMaxLines;
   End
   Else
   {Anywhere but Step > 1 Then}
   IF (THelpBox^.HBVerScrBar^.VSBPointerStep >= 1) Then
   Begin
       CurrentChoise:=THelpBox^.HBVerScrBar^.VSBPointer * THelpBox^.HBVerScrBar^.VSBPointerStep;
       IF ((CurrentChoise+YDif) <= THelpBox^.HBMaxLines) or
          ((CurrentChoise-YDif) < 1) and (THelpBox^.HBVerScrBar^.VSBPointerStep >1) Then
       Begin
            IF CurrentChoise+YDif > THelpBox^.HBMaxLines Then
               CurrentChoise:=1;

            THelpBox^.HBVisualYPosit:=1;
            THelpBox^.HBVirtualYPosit:=CurrentChoise;
            THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
            CurHelpData:=HeadHelpData;
            IF CurrentChoise > 1 Then
               For I:=1 to CurrentChoise-1 do
                   CurHelpData:=CurHelpData^.NextTextLine;

           TraceText:=CurHelpData;
           HelpCurY:=HelpBorderY1+1;
           ShowTextUpWards;
           SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
           CurOn;
       End
       Else
       IF ((CurrentChoise+YDif) > THelpBox^.HBMaxLines) or
          (THelpBox^.HBVerScrBar^.VSBPointerStep =1) Then
       Begin
            IF (THelpBox^.HBVerScrBar^.VSBPointerStep =1) Then
            Begin
               THelpBox^.HBVisualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               THelpBox^.HBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               CurHelpData:=TailHelpData;

               TraceText:=CurHelpData;
               HelpCurY:=HelpBorderY2-1;
               ShowTextDownWards;

               CurHelpData:=HeadHelpData;
               For I:=1 to THelpBox^.HBVerScrBar^.VSBPointerStep-1 do
                   CurHelpData:=CurHelpData^.NextTextLine;

               HelpCurY:=HelpBorderY1+THelpBox^.HBVerScrBar^.VSBPointerStep;
            End
            Else
            Begin
               THelpBox^.HBVisualYPosit:=YDif;
               THelpBox^.HBVirtualYPosit:=CurrentChoise;
               THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
               CurHelpData:=HeadHelpData;
               IF CurrentChoise > 1 Then
                  For I:=1 to CurrentChoise-1 do
                      CurHelpData:=CurHelpData^.NextTextLine;

               TraceText:=CurHelpData;
               HelpCurY:=HelpBorderY2-1;
               ShowTextDownWards;
            End;

            SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
            CurOn;
       End;
   End
   Else
   {Anywhere but Step = 1 Then}
   IF (THelpBox^.HBVerScrBar^.VSBPointerStep > 1) Then
   Begin
       CurHelpData:=HeadHelpData;
       For I:=1 to THelpBox^.HBVerScrBar^.VSBPointerStep-1 do
          CurHelpData:=CurHelpData^.NextTextLine;

       TraceText:=CurHelpData;
       HelpCurY:=HelpBorderY1+1;
       ShowTextUpWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
       THelpBox^.HBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;

   End;


End;


Begin

    THelpBox:=Win^.CurMenusSeq^.NodePtr;
    TVerScrollBar:=THelpBox^.HBVerScrBar;
    IF CurHelpData = Nil Then
       Exit;

    {For Keyboard come here}
     IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        Win^.CurrentMessageLine:='';
        ShowHelpCtx('');
        SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
        CurOn;

        {Save Cursor Start and End scan lines into our window}
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;

        TVerScrollBar:=THelpBox^.HBVerScrBar;
        THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
        CheckTopic;
    End
    Else

    {For Mouse come here}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        MouseResponse:=True;

        {Up Arrow}

        IF THelpBox^.HBVerScrBar <> Nil Then
        Begin
          IF (InterMX+1 in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1);

             Repeat
               Ctrl:=#0;
               Ascii:=#72;
               HandleKBHelpBoxEvent;
               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;


               Repeat
                RetraceDelay(Delayer);
                Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Down Arrow}

          IF (InterMX+1 in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2);

             Repeat
               Ctrl:=#0;
               Ascii:=#80;
               HandleKBHelpBoxEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;

               Repeat
                 RetraceDelay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Get the Scroller Pointer and move it}

          IF ( (InterMX+1 in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (InterMY+1 = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+(THelpBox^.HBVerScrBar^.VSBPointer)) )
              AND ((THelpBox^.HBVerScrBar^.VSBMaxChoises)
                        >= ((THelpBox^.HBVerScrBar^.VSBY2-1)-(THelpBox^.HBVerScrBar^.VSBY1)+1)) Then
          Begin
            Win^.CurrentMessageLine:='';
            ShowHelpCtx('');
            SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
            CurOn;
            {Save Cursor Start and End scan lines into our window}
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;


            {Make the initials adjustments}
            THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;

            SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
            SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2-1);

            Repeat
                MYMouseX:=InterMX+1;MYMouseY:=InterMY+1;

                IF (MyMouseX in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
                     and (MyMouseY in [Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1..Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2-1]) Then
                Begin
                  TracePointer:=(MyMouseY-(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1))+1;
                  IF TracePointer <> THelpBox^.HBVerScrBar^.VSBPointer Then
                  Begin
                     THelpBox^.HBVerScrBar^.VSBPointer:=TracePointer;
                     THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
                  End;
                End;
            Until (MouseButton=MsIdle);

            AdjustHelpBox;

            SetMouseMinMaxX(1,80);
            SetMouseMinMaxY(1,25);
          End
          Else
            MouseResponse:=False;
        End; {IF HBVerScrBar <> Nil}


        {Mark the Choise}
        IF ( (InterMX+1 in [Win^.X1+THelpBox^.HBX1+1..Win^.X1+THelpBox^.HBX2-1-Byte(VGAExist)])) AND (MouseResponse=False)
           AND ( (InterMY+1 in [Win^.Y1+THelpBox^.HBY1+1..Win^.Y1+THelpBox^.HBY2-1]))Then
        Begin
             Win^.CurrentMessageLine:='';
             ShowHelpCtx('');
             THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
             YDif:=(HelpBorderY2) - (HelpBorderY1);
             Dec(YDif);


             HelpCurX:=HelpBorderX1+((InterMX+1)-(Win^.X1+THelpBox^.HBX1));
             HelpCurY:=HelpBorderY1+((InterMY+1)-(Win^.Y1+THelpBox^.HBY1));

             IF HelpCurY-HelpBorderY1 > THelpBox^.HBMaxLines Then
                HelpCurY:=HelpBorderY1+THelpBox^.HBMaxLines;

             SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);

             Stepper:=THelpBox^.HBVisualYPosit;
             THelpBox^.HBVisualYPosit:=HelpCurY-HelpBorderY1;
             Stepper:=THelpBox^.HBVisualYPosit-Stepper;

             THelpBox^.HBVirtualYPosit:=THelpBox^.HBVirtualYPosit+Stepper;
             THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVirtualYPosit;

             THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
             THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;


             I:=1;
             CurHelpData:=HeadHelpData;
             While (I < THelpBox^.HBVirtualYPosit) and (CurHelpData <> Nil) do
             Begin
                  IF CurHelpData <> Nil Then
                     CurHelpData:=CurHelpData^.NextTextLine;
                  Inc(I);
             End;

             CurOn;
             {Save Cursor Start and End scan lines into our window}
             ReadCurPositHeight;
             Win^.WinSScanL:=SScanL;
             Win^.WinEScanL:=EScanL;

             CheckTopic;

             IF (MsLeftDoubleClick)  Then
             Begin
               Ctrl:=#13;
               Ascii:=#0;
               HandleKBHelpBoxEvent;
             End;
        End
        Else
        IF MouseResponse=False Then
        Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
        End;

    End {IF Mouse}
    Else
    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           THelpBox:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>THelpBox Then
           Begin
             TVerScrollBar:=THelpBox^.HBVerScrBar;
             THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
             UnActiveTopic;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF  (Ctrl=Chr(KbTab)) and (Ascii=#0) Then
    Begin
         THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
         UnActiveTopic;
         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF (Ctrl=#0) and (Ascii=Chr(KbShiftTab)) Then
    Begin
         THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
         UnActiveTopic;
         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    {Right Arrow}

    IF  (Ctrl=#0) and  (Ascii=Chr(KbArrowRight))   Then
    Begin
       IF Win^.X1+HelpCurX < Win^.X1+HelpBorderX2 Then
       Begin
           Inc(HelpCurX);
           SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
           CheckTopic;
       End;
    End
    Else

    {Left Arrow}

    IF ( (Ctrl=#0) and  (Ascii=Chr(KbArrowLeft))  ) Then
    Begin
       IF Win^.X1+HelpCurX > Win^.X1+HelpBorderX1+1 Then
       Begin
           Dec(HelpCurX);
           SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
           CheckTopic;
       End;
    End
    Else

    {Down Arrow come here......                                         }

    IF ((Ctrl=#0) and (Ascii=Chr(KbArrowDown))) and (CurHelpData <> Nil) Then
    Begin

       IF THelpBox^.HBVirtualYPosit >= THelpBox^.HBMaxLines Then
          Exit;

       IF HelpCurY < HelpBorderY2-1 Then
       Begin
         Inc(HelpCurY);
         Inc(THelpBox^.HBVirtualYPosit);
         Inc(THelpBox^.HBVisualYPosit);
         SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
         CheckTopic;
         CurHelpData:=CurHelpData^.NextTextLine;
       End
       Else
       IF (HelpCurY >= HelpBorderY2-1) and (THelpBox^.HBVirtualYPosit < THelpBox^.HBMaxLines) Then
       Begin

         Inc(THelpBox^.HBVirtualYPosit);
         CurHelpData:=CurHelpData^.NextTextLine;
         TraceText:=CurHelpData;

         {Scrolling Down Routine}
         ShowTextDownWards;
         HelpCurY:=HelpBorderY2-1;
         SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
       End; {ELSE IF}

       CallVerScrollKBEvent;
    End
    Else

    {Up Arrow come here.........                                        }

    IF ((Ctrl=#0) and (Ascii=Chr(KbArrowUp))) and (THelpBox^.HBVirtualYPosit > 1) Then
    Begin

       IF THelpBox^.HBVirtualYPosit <=1 Then
          Exit;

       IF HelpCurY > HelpBorderY1+1 Then
       Begin
         Dec(HelpCurY);
         Dec(THelpBox^.HBVirtualYPosit);
         Dec(THelpBox^.HBVisualYPosit);
         SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
         CheckTopic;
         CurHelpData:=CurHelpData^.PrevTextLine;
       End
       Else
       IF (HelpCurY <= HelpBorderY1+1) and (THelpBox^.HBVirtualYPosit > 1) Then
       Begin

         Dec(THelpBox^.HBVirtualYPosit);
         CurHelpData:=CurHelpData^.PrevTextLine;
         TraceText:=CurHelpData;

         {Scrolling Down Routine}
         ShowTextUpWards;
         HelpCurY:=HelpBorderY1+1;
         SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
       End; {End IF}

       CallVerScrollKBEvent;
    End
    Else

    {Page Down}
    IF ((Ctrl=#0) and (Ascii=Chr(KbPageDown))) and (THelpBox^.HBVirtualYPosit < THelpBox^.HBMaxLines) Then
    Begin
       YDif:=(HelpBorderY2) - (HelpBorderY1);
       Dec(YDif);

       IF THelpBox^.HBMaxLines <= YDif Then
          Exit;

       I:=THelpBox^.HBVirtualYPosit + ( (YDif - THelpBox^.HBVisualYPosit)+1);
       IF I+Ydif > THelpBox^.HBMaxLines Then
       Begin
          TraceText:=TailHelpData;
          CurHelpData:=TailHelpData;
          HelpCurY:=HelpBorderY2-1;
          ShowTextDownWards;
          HelpCurY:=HelpBorderY2-1;
          SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
          THelpBox^.HBVirtualYPosit:=THelpBox^.HBMaxLines;
          THelpBox^.HBVisualYPosit:=YDif;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBMaxLines;
       End
       Else
       Begin
          For J:=THelpBox^.HBVirtualYPosit to I-1 do
               CurHelpData:=CurHelpData^.NextTextLine;

          TraceText:=CurHelpData;
          HelpCurY:=HelpBorderY1+1;
          ShowTextUpWards;
          HelpCurY:=HelpBorderY1+1;
          SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
          THelpBox^.HBVirtualYPosit:=I;
          THelpBox^.HBVisualYPosit:=1;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=I;
       End;

       CheckTopic;
       THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
       THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
       CallVerScrollKBEvent;

    End
    Else

    {Page Up}
    IF ((Ctrl=#0) and (Ascii=Chr(KbPageUp))) and (THelpBox^.HBVirtualYPosit > 1) Then
    Begin

       YDif:=(HelpBorderY2) - (HelpBorderY1);
       Dec(YDif);

       I:=THelpBox^.HBVirtualYPosit-THelpBox^.HBVisualYPosit;
       IF I-YDif < 1 Then
       Begin
          TraceText:=HeadHelpData;
          CurHelpData:=HeadHelpData;
          HelpCurY:=HelpBorderY1+1;
          ShowTextUpWards;
          HelpCurY:=HelpBorderY1+1;
          SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
          THelpBox^.HBVirtualYPosit:=1;
          THelpBox^.HBVisualYPosit:=1;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;
       End
       Else
       Begin
          For J:=THelpBox^.HBVirtualYPosit Downto I+1 do
               CurHelpData:=CurHelpData^.PrevTextLine;

          TraceText:=CurHelpData;
          HelpCurY:=HelpBorderY2-1;
          ShowTextDownWards;
          HelpCurY:=HelpBorderY2-1;
          SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
          THelpBox^.HBVirtualYPosit:=I;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=I;
          THelpBox^.HBVisualYPosit:=YDif-1;
       End;

       CheckTopic;

       THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
       THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
       CallVerScrollKBEvent;

    End
    Else

    {End}

    IF (Ctrl=#0) and (Ascii=Chr(KbEnd)) Then
    Begin
        HelpCurX:=HelpBorderX1+Length(CurHelpData^.TextLine^)-1;
        IF HelpCurX >= HelpBorderX2 Then
           HelpCurX:=HelpBorderX2-1;
        SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
        CheckTopic;
    End
    Else

    {Home}

    IF (Ctrl=#0) and (Ascii=Chr(KbHome)) Then
    Begin
        HelpCurX:=HelpBorderX1+1;
        SetVirtCursorPositHeight(Win^.X1+HelpCurX,Win^.Y1+HelpCurY,TextCursorSSL,TextCursorESL);
        CheckTopic;
    End
    Else

    {Enter}

    IF (Ctrl=#13) and (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil)
         and (CurHelpData <> Nil) Then
    Begin
        MakeHistory;
        IF CurTopicHelpXY^.Reference = CurrentHelpPtr Then
        Begin
            BackHistory;
            Exit;
        End;
        FindReference(CurTopicHelpXY^.Reference);
        TVerScrollBar:=THelpBox^.HBVerScrBar;
        THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
        CheckTopic;
        CurOn;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsHelpBoxEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           THelpBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>THelpBox Then
           Begin
             TVerScrollBar:=THelpBox^.HBVerScrBar;
             THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
             UnActiveTopic;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End



End;

Begin
    Case Event Of
       0:HandleKBHelpBoxEvent;
       1:HandleMsHelpBoxEvent;
    End;
End;



Function OpenAndFindTopic(TopicNum :Word) :Byte;
Var
   Err  :Integer;
Begin
    Err:=OpenHelpFile;
    IF Err = 1 Then
    Begin
      ErrorMessage('     No help available.   ',bfOk);
      OpenAndFindTopic:=1;
      Exit;
    End;

    Err:=FindTopic(TopicNum);
    IF (Err = 1) and (HeapErrorCode=0) Then
    Begin
       ErrorMessage('No help available for this'+#10+
                   'topic.',BfOk);
       OpenAndFindTopic:=1;
       Close(FileHlp);
       Exit;
    End
    Else
    IF (Err = 1) and (HeapErrorCode=1) Then
    Begin
       Close(FileHlp);
       OpenAndFindTopic:=1;
       Exit;
    End;

    OpenAndFindTopic:=0;
    Close(FileHlp);
End;



{---------------------------------------------------------------------------}
{-------------------------- Drop Down --------------------------------------}
{---------------------------------------------------------------------------}

{*************************************************************************}
{Procedure HandleCommand                                                  }
{It is a virtual method which it means that it must be rewritten from the }
{programmer in the main current program.It contains all the commands from }
{every object and it is unique.                                           }
{*************************************************************************}


Procedure DropDown.HandleCommand;
Begin

End;

{************************************************************************}
{Procedure WinHandleEvent                                                }
{It's also a virtual method.It called from the internal functions to dete}
{rmine which object must pass every time.                                }
{************************************************************************}

Procedure DropDown.WinHandleEvent;
Begin


End;

{**********************************************************************}
{Procedure InitDropDown                                                }
{The initialization routine.It called from the programmer to initialize}
{a drop down object.Sets the initials vars and draw the object on the  }
{screen.                                                               }
{**********************************************************************}

Function DropDown.InitDropDown(InCommand :Word) :PMenuNode;

  Procedure DrawDropDown;
  Var
     I          :Byte;
  Begin
      IF DropDownNormTxtColor = 255 Then
         TDropDown^.DDNormTxtColor:=Win^.WTextColor;

      IF DropDownNormBckColor = 255 Then
         TDropDown^.DDNormBckColor:=Win^.WTextBackGround;

      IF DropDownRevTxtColor = 255 Then
         TDropDown^.DDRevTxtColor:=Win^.WTextColor;

      IF DropDownRevBckColor = 255 Then
         TDropDown^.DDRevBckColor:=Win^.WTextBackGround;

      IF DropDownTableColor = 255 Then
         TDropDown^.DDTableColor:=Win^.WTextBackGround;

      IF DropDownNormLabelColor = 255 Then
         TDropDown^.DDNormLabelColor:=Win^.WTextColor;

      IF DropDownRevLabelColor = 255 Then
         TDropDown^.DDRevLabelColor:=Win^.WTextColor;

      IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
      Begin
        HiddenMouseCursor;
        HiddenMouse:=True;
      End;

      WriteVirtWinChar(Win^.X1+ObjectX1,Win^.Y1+ObjectY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,Ord('['));

      WriteVirtWinChar(Win^.X1+ObjectX2-1-Byte(VgaExist),Win^.Y1+ObjectY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,Ord(']'));


      DropDownDownArrow;
      IF VgaExist Then
      Begin

          For I:=Win^.X1+ObjectX1+1 to Win^.X1+ObjectX2-3 do
              WriteVirtWinChar(I,Win^.Y1+ObjectY1,TDropDown^.DDNormTxtColor,
                           TDropDown^.DDNormBckColor,WCInputLineFillChar);

      End
      Else
      Begin
          For I:=Win^.X1+ObjectX1+1 to Win^.X1+ObjectX2-2 do
              WriteVirtWinChar(I,Win^.Y1+ObjectY1,TDropDown^.DDNormTxtColor,
                           TDropDown^.DDNormBckColor,SCInputLineFillChar);

      End;

      IF HiddenMouse Then
      Begin
        ShowMouseCursor;
        HiddenMouse:=False;
      End;


  End;

Begin
    IF HeapErrorCode=1 Then
    Begin
        TDropDown:=Nil;
        Exit;
    End;

    New(TDropDown);

    IF TDropDown=Nil Then
       Exit;

    TDropDown^.DDX1:=ObjectX1;
    TDropDown^.DDY1:=ObjectY1;
    TDropDown^.DDX2:=ObjectX2;
    TDropDown^.DDY2:=ObjectY2;

    NewMenusSeq(DropDowns,TDropDown,255,ObjectX1,ObjectY1,ObjectX2,ObjectY1);

    TDropDown^.DDLabel:='';
    TDropDown^.DDCommand:=InCommand;
    TDropDown^.DDDisabled:=False;
    TDropDown^.DDHelpCtx:=Nil;
    TDropDown^.DDDiskHelp:=0;
    TDropDown^.DDVirtualY:=1;
    TDropDown^.DDVisualY:=1;
    TDropDown^.DDMaxLines:=1;
    TDropDown^.DDLabel:='';
    TDropDown^.DDLabX1:=0;
    TDropDown^.DDLabY1:=0;
    TDropDown^.DDText:=Nil;
    TDropDown^.DDSavText:=Nil;
    TDropDown^.DDHeadTextLine:=Nil;
    TDropDown^.DDRearTextLine:=Nil;


    IF Win^.Y1+ObjectY2 > Win^.Y2 Then
       TDropDown^.DDTable:=UpWard
    Else
       TDropDown^.DDTable:=DownWard;

    TDropDown^.DDTableWindow:=Nil;

    TDropDown^.DDNormTxtColor:=DropDownNormTxtColor;
    TDropDown^.DDNormBckColor:=DropDownNormBckColor;
    TDropDown^.DDRevTxtColor:=DropDownRevTxtColor;
    TDropDown^.DDRevBckColor:=DropDownRevBckColor;
    TDropDown^.DDTableColor:=DropDownTableColor;
    TDropDown^.DDNormLabelColor:=DropDownNormLabelColor;
    TDropDown^.DDRevLabelColor:=DropDownRevLabelColor;

    DrawDropDown;

    InitDropDown:=Win^.TailMenusSeq;

End;

Procedure DropDown.DropDownHelp;
Begin

    IF (TDropDown=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TDropDown^.DDHelpCtx:=Nil
    Else
    Begin
        New(TDropDown^.DDHelpCtx);
        IF TDropDown^.DDHelpCtx = Nil Then
           Exit;
        TDropDown^.DDHelpCtx^:=InHelpCtx;
    End;

    TDropDown^.DDDiskHelp:=InDiskHelp;
End;

Procedure DropDown.DisableDropDown;
Var
  PText           :String;
  I               :Byte;
Begin
     IF (TDropDown=Nil) or (HeapErrorCode=1) Then
         Exit;

     WriteTextColor:=DisableWinColor;
     WriteTextBackGround:=TDropDown^.DDNormBckColor;

     IF TDropDown^.DDText <> Nil Then
     Begin
       IF Length(TDropDown^.DDText^.TextLine^) > ((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)) Then
          PText:=Copy(TDropDown^.DDText^.TextLine^,1,((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)))
       Else
          PText:=TDropDown^.DDText^.TextLine^;

        IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
             (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
           ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;
        WriteVirtWinOut(Win^.X1+TDropDown^.DDX1+1,Win^.Y1+TDropDown^.DDY1,PText);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

     End
     Else
        PText:='';

     IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     For I:=Length(PText)+1 to ((TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1)) do
            WriteVirtWinChar(Win^.X1+TDropDown^.DDX1+I,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                     WriteTextBackGround,WCInputLineFillChar);


     IF VgaExist Then
     Begin
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-1,Win^.Y1+TDropDown^.DDY1,DisableWinColor,
                          TDropDown^.DDNormBckColor,WCDownArrow1);

         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,DisableWinColor,
                          TDropDown^.DDNormBckColor,WCDownArrow2);
     End
     Else
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,DisableWinColor,
                          TDropDown^.DDNormBckColor,SCDownArrow);


     WriteVirtWinChar(Win^.X1+TDropDown^.DDX1,Win^.Y1+TDropDown^.DDY1,DisableWinColor,
                      TDropDown^.DDNormBckColor,Ord('['));

     WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-2,Win^.Y1+TDropDown^.DDY1,DisableWinColor,
                      TDropDown^.DDNormBckColor,Ord(']'));

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

     IF TDropDown^.DDLabel <> '' Then
     Begin
        IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
             (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
           ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteWithOutMark(Win^.X1+TDropDown^.DDLabX1,Win^.Y1+TDropDown^.DDLabY1,TDropDown^.DDLabel);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

     End;


     TDropDown^.DDDisabled:=True;
End;


Procedure DropDown.EnableDropDown;
Var
  PText           :String;
  I               :Byte;
Begin
     IF (TDropDown=Nil) or (HeapErrorCode=1) Then
         Exit;

     WriteTextColor:=TDropDown^.DDNormTxtColor;;
     WriteTextBackGround:=TDropDown^.DDNormBckColor;

     IF TDropDown^.DDText <> Nil Then
     Begin
       IF Length(TDropDown^.DDText^.TextLine^) > ((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)) Then
          PText:=Copy(TDropDown^.DDText^.TextLine^,1,((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)))
       Else
          PText:=TDropDown^.DDText^.TextLine^;

        IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
             (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
           ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;
        WriteVirtWinOut(Win^.X1+TDropDown^.DDX1+1,Win^.Y1+TDropDown^.DDY1,PText);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
     End
     Else
        PText:='';

     IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;
     For I:=Length(PText)+1 to ((TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1)) do
            WriteVirtWinChar(Win^.X1+TDropDown^.DDX1+I,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                     WriteTextBackGround,WCInputLineFillChar);


     IF VgaExist Then
     Begin
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-1,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                          TDropDown^.DDNormBckColor,WCDownArrow1);

         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                          TDropDown^.DDNormBckColor,WCDownArrow2);
     End
     Else
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                          TDropDown^.DDNormBckColor,SCDownArrow);


     WriteVirtWinChar(Win^.X1+TDropDown^.DDX1,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                      TDropDown^.DDNormBckColor,Ord('['));

     WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-2,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                      TDropDown^.DDNormBckColor,Ord(']'));

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;


     IF TDropDown^.DDLabel <> '' Then
     Begin
        WriteTextColor:=DropDownNormLabelColor;
        WriteTextBackGround:=Win^.WTextBackGround;
        IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
              (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
             ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
                 (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteStrAndMark(Win^.X1+TDropDown^.DDLabX1,Win^.Y1+TDropDown^.DDLabY1,TDropDown^.DDLabel);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
     End;

     TDropDown^.DDDisabled:=False;
End;


Procedure DropDown.DropDownLabel(InX1,InY1:Byte;InLabel:Str40);
Begin

    IF (TDropDown=Nil) or (HeapErrorCode=1) Then
       Exit;

    TDropDown^.DDLabel:=InLabel;

    TDropDown^.DDLabX1:=InX1;
    TDropDown^.DDLabY1:=InY1;

    WriteTextColor:=DropDownNormLabelColor;
    WriteTextBackGround:=Win^.WTextBackGround;
    IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;
    WriteStrAndMark(InX1+Win^.X1,InY1+Win^.Y1,InLabel);
    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    Win^.TailMenusSeq^.BroadCast:=BroadCastChar(InLabel);
End;


Procedure DropDown.DropDownDownArrow;
Begin
  IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
  Begin
    HiddenMouseCursor;
    HiddenMouse:=True;
  End;

  IF VgaExist Then
  Begin
      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-1,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,WCDownArrow1);

      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,WCDownArrow2);
  End
  Else
      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,SCDownArrow);

  IF HiddenMouse Then
  Begin
    ShowMouseCursor;
    HiddenMouse:=False;
  End;
End;

Procedure DropDown.DropDownUpArrow;
Begin
  IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then

  Begin
    HiddenMouseCursor;
    HiddenMouse:=True;
  End;

  IF VgaExist Then
  Begin
      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2-1,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,WCUpArrow1);

      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,WCUpArrow2);
  End
  Else
      WriteVirtWinChar(Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1,TDropDown^.DDNormTxtColor,
                       TDropDown^.DDNormBckColor,SCUpArrow);

  IF HiddenMouse Then
  Begin
    ShowMouseCursor;
    HiddenMouse:=False;
  End;
End;


{**************************************************************************}
{Procedure ShowDropDownText                                                }
{Links The Head and Tail Vars which they returned from the InsertText proc }
{and Then search to find the default choise so it display it,on the screen.}
{**************************************************************************}

Procedure DropDown.ShowDropDownText(HeadPtr,TailPtr :PDynText;StartPoint :Word);
Var
   I            :Word;
   PText        :String;
   TraceText    :PDynText;
Begin
     IF TDropDown=Nil Then
        Exit;

     TDropDown^.DDHeadTextLine:=HeadPtr;
     TDropDown^.DDRearTextLine:=TailPtr;
     TraceText:=HeadPtr;
     TDropDown^.DDText:=TraceText;

     IF (HeadPtr=Nil) or (TailPtr=Nil) Then
        Exit;

     {Find The Proper StartPoint in list and Count the Texts}
      I:=1;
      While (TraceText <> Nil)  do
      Begin
         IF I = StartPoint Then
            TDropDown^.DDText:=TraceText;

         IF (TraceText <> Nil) Then
         Begin
            TraceText:=TraceText^.NextTextLine;
            Inc(I);
         End;

      End;

     TDropDown^.DDMaxLines:=I-1;
     TDropDown^.DDVirtualY:=StartPoint;
     TDropDown^.DDVisualY:=1;

     WriteTextColor:=TDropDown^.DDNormTxtColor;
     WriteTextBackGround:=TDropDown^.DDNormBckColor;

     IF TDropDown^.DDText <> Nil Then
     Begin
       IF Length(TDropDown^.DDText^.TextLine^) > ((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)) Then
          PText:=Copy(TDropDown^.DDText^.TextLine^,1,((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)))
       Else
          PText:=TDropDown^.DDText^.TextLine^;
     End
     Else
         PText:='';

     IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteVirtWinOut(Win^.X1+TDropDown^.DDX1+1,Win^.Y1+TDropDown^.DDY1,PText);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

     HiddenMouseCursor;
     IF Length(PText) < ( (TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1) ) Then
         For I:=Length(PText)+1 to ((TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1)) do
             WriteVirtWinChar(Win^.X1+TDropDown^.DDX1+I,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                     WriteTextBackGround,WCInputLineFillChar);
     ShowMouseCursor;

End;

{*************************************************************************}
{Procedure DropDownDeleteText                                             }
{It Deletes All Dynamic Texts which they allocated by the InsertText.     }
{*************************************************************************}

Procedure DropDown.DropDownDeleteAllText;
Begin
    TDropDown^.DDText:=TDropDown^.DDHeadTextLine;

    IF TDropDown^.DDText = Nil Then
       Exit;

    Repeat
         IF (TDropDown^.DDText<>Nil) Then
         Begin
             FreeMem(TDropDown^.DDText^.TextLine,Length(TDropDown^.DDText^.TextLine^)+1);
             TDropDown^.DDHeadTextLine:=TDropDown^.DDText;
             TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
             Dispose(TDropDown^.DDHeadTextLine);
         End;
    Until TDropDown^.DDText = Nil;

    TDropDown^.DDHeadTextLine:=Nil;
    TDropDown^.DDRearTextLine:=Nil;
    TDropDown^.DDText:=Nil;
    TDropDown^.DDSavText:=Nil;
End;

Procedure DropDown.DefaultDropDownColor;
Var
   PText        :String;
   I            :Byte;
Begin
     WriteTextColor:=TDropDown^.DDNormTxtColor;
     WriteTextBackGround:=TDropDown^.DDRevBckColor;

     IF TDropDown^.DDText <> Nil Then
     Begin
       IF Length(TDropDown^.DDText^.TextLine^) > ((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)) Then
          PText:=Copy(TDropDown^.DDText^.TextLine^,1,((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)))
       Else
          PText:=TDropDown^.DDText^.TextLine^;
     End
     Else
         PText:='';

     IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;
     WriteVirtWinOut(Win^.X1+TDropDown^.DDX1+1,Win^.Y1+TDropDown^.DDY1,PText);

     For I:=Length(PText)+1 to ((TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1)) do
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX1+I,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                   WriteTextBackGround,WCInputLineFillChar);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;
End;

Procedure DropDown.NormalDropDownColor;
Var
   PText        :String;
   I            :Byte;
Begin
     WriteTextColor:=TDropDown^.DDNormTxtColor;
     WriteTextBackGround:=TDropDown^.DDNormBckColor;


     IF TDropDown^.DDText <> Nil Then
     Begin
       IF Length(TDropDown^.DDText^.TextLine^) > ((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)) Then
          PText:=Copy(TDropDown^.DDText^.TextLine^,1,((TDropDown^.DDX2-1-1-Byte(VgaExist))-(TDropDown^.DDX1)))
       Else
          PText:=TDropDown^.DDText^.TextLine^;
     End
     Else
         PText:='';

     IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteVirtWinOut(Win^.X1+TDropDown^.DDX1+1,Win^.Y1+TDropDown^.DDY1,PText);

     For I:=Length(PText)+1 to ((TDropDown^.DDX2-1-Byte(VgaExist))-(TDropDown^.DDX1+1)) do
         WriteVirtWinChar(Win^.X1+TDropDown^.DDX1+I,Win^.Y1+TDropDown^.DDY1,WriteTextColor,
                   WriteTextBackGround,WCInputLineFillChar);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

End;

Procedure DropDown.DropDownDrawTable;
Var
    I,J                  :Byte;

Begin
  IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
  Begin
    HiddenMouseCursor;
    HiddenMouse:=True;
  End;

  For I:=TDropDown^.DDTableWindow^.BY1 to TDropDown^.DDTableWindow^.BY2 do
      For J:=TDropDown^.DDTableWindow^.BX1 to TDropDown^.DDTableWindow^.BX2 do
          WriteWinChar(J,I,TDropDown^.DDRevBckColor,TDropDown^.DDTableColor,32);


  IF TDropDown^.DDTableWindow^.BY1 = TDropDown^.DDTableWindow^.BY2 Then
     Exit;

  IF VgaExist Then
  Begin
      WriteWinChar(TDropDown^.DDTableWindow^.BX2-1,TDropDown^.DDTableWindow^.BY1,TDropDown^.DDRevBckColor,
           TDropDown^.DDTableColor,WCUpArrow1);

      WriteWinChar(TDropDown^.DDTableWindow^.BX2,TDropDown^.DDTableWindow^.BY1,TDropDown^.DDRevBckColor,
           TDropDown^.DDTableColor,WCUpArrow2);

      WriteWinChar(TDropDown^.DDTableWindow^.BX2-1,TDropDown^.DDTableWindow^.BY2,TDropDown^.DDRevBckColor,
           TDropDown^.DDTableColor,WCDownArrow1);

      WriteWinChar(TDropDown^.DDTableWindow^.BX2,TDropDown^.DDTableWindow^.BY2,TDropDown^.DDRevBckColor,
           TDropDown^.DDTableColor,WCDownArrow2);


  End
  Else
  Begin
       WriteWinChar(TDropDown^.DDTableWindow^.BX2,TDropDown^.DDTableWindow^.BY1,TDropDown^.DDNormTxtColor,
           TDropDown^.DDTableColor,SCUpArrow);

       WriteWinChar(TDropDown^.DDTableWindow^.BX2,TDropDown^.DDTableWindow^.BY2,TDropDown^.DDNormTxtColor,
           TDropDown^.DDTableColor,SCDownArrow);
  End;

  IF HiddenMouse Then
  Begin
    ShowMouseCursor;
    HiddenMouse:=False;
  End;
End;

Procedure DropDown.DropDownTableDefaultColor(MY :Byte;Str :String);
Var
   I            :Byte;
   PText        :String;
   WX1,WX2      :Byte;
Begin
     WriteTextColor:=TDropDown^.DDNormTxtColor;
     WriteTextBackGround:=TDropDown^.DDRevBckColor;

     WX1:=TDropDown^.DDTableWindow^.BX1;
     WX2:=TDropDown^.DDTableWindow^.BX2;


     IF TDropDown^.DDText <> Nil Then
     Begin
        PText:=Str;
        CheckLength(PText,WX1+1,WX2-1-1-Byte(VgaExist));
     End
     Else
         PText:='';

     IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteWinChar(WX1,MY,WriteTextColor,
         WriteTextBackGround,32);

     WriteWinOut(WX1+1,MY,PText);

     I:=WX1+Length(PText)+1;
     While I < WX1+(WX2-(WX1+1)) do
     Begin
         WriteWinChar(I,MY,WriteTextColor,
                   WriteTextBackGround,32);
         Inc(I);
     End;

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

End;

Procedure DropDown.DropDownTableNormalColor(MY :Byte;Str :String);
Var
   WX1,WX2      :Byte;
   PText        :String;
   I            :Byte;
Begin
     WriteTextColor:=TDropDown^.DDRevBckColor;
     WriteTextBackGround:=TDropDown^.DDTableColor;

     WX1:=TDropDown^.DDTableWindow^.BX1;
     WX2:=TDropDown^.DDTableWindow^.BX2;

     IF TDropDown^.DDText <> Nil Then
     Begin
        PText:=Str;
        CheckLength(PText,WX1+1,WX2-1-1-Byte(VgaExist));
     End
     Else
         PText:='';

     IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteWinChar(WX1,MY,WriteTextColor,
         WriteTextBackGround,32);

     WriteWinOut(WX1+1,MY,PText);

     I:=WX1+Length(PText)+1;
     While I < WX1+(WX2-(WX1+1)) do
     Begin
         WriteWinChar(I,MY,WriteTextColor,
                   WriteTextBackGround,32);
         Inc(I);
     End;

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

End;


Procedure DropDown.DropDownShowTableText;
Var
   TraceStr     :String;
   WX1,WX2,
   WY1,WY2      :Byte;
Begin
  IF TDropDown^.DDTableWindow = Nil Then
     Exit;

  WX1:=TDropDown^.DDTableWindow^.BX1;
  WX2:=TDropDown^.DDTableWindow^.BX2;
  WY1:=TDropDown^.DDTableWindow^.BY1;
  WY2:=TDropDown^.DDTableWindow^.BY2;

  TDropDown^.DDSavText:=TDropDown^.DDText;
  TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
  IF TDropDown^.DDText = Nil Then
     Exit;

  WriteTextColor:=TDropDown^.DDRevBckColor;
  WriteTextBackGround:=TDropDown^.DDTableColor;

  IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
  Begin
    HiddenMouseCursor;
    HiddenMouse:=True;
  End;

  Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
           TraceStr:=TDropDown^.DDText^.TextLine^;
           CheckLength(TraceStr,WX1+1,WX2-1-1-Byte(VgaExist));
           WriteWinOut(WX1+1,WY1,TraceStr);
           Inc(WY1);
           TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
  Until (TDropDown^.DDText = Nil) or (WY1=WY2+1);

  IF HiddenMouse Then
  Begin
    ShowMouseCursor;
    HiddenMouse:=False;
  End;

  TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
  TDropDown^.DDVirtualY:=1;
  TDropDown^.DDVisualY:=1;

  DropDownTableDefaultColor(TDropDown^.DDTableWindow^.BY1,TDropDown^.DDText^.TextLine^);
End;

Procedure DropDown.DropDownCloseTable;
Var
   CX1,CY1,XLength,StartOffset :Word;
   InCharColor                 :Word;
   MSeg,MOfs                   :Word;
   Index                       :Word;
   I,J                         :Word;
Begin
  {If we have no MaskScreen get out}
  IF ( ((Win^.Params and OverLap) = OverLap) Or ((Win^.Params and Movement) = Movement) )
      AND (Win^.MaskScreen <> Nil) Then
  Begin
        MSeg:=Seg(TDropDown^.DDTableWindow^.SnapShot^);
        MOfs:=Ofs(TDropDown^.DDTableWindow^.SnapShot^);
        Index:=0;

        For I:=TDropDown^.DDTableWindow^.BY1 to TDropDown^.DDTableWindow^.BY2 do
            For J:=TDropDown^.DDTableWindow^.BX1 to TDropDown^.DDTableWindow^.BX2 do
            Begin
               IF (I<= SetWindowY2) and (I<=BiosRows) and
                  (J<= SetWindowX2) and (J<=(BiosColumns shr 1)) Then
               Begin
                 InCharColor:=MemW[MSeg:MOfs+Index];
                 CX1:=J-Win^.X1;
                 CY1:=I-Win^.Y1;
                 XLength:=(Win^.X2-Win^.X1)+1;
                 XLength:=XLength shl 1;
                 StartOffset:=(CY1*XLength)+(CX1 shl 1);
                 Win^.MaskScreen^[StartOffset]:=Lo(InCharColor);
                 Win^.MaskScreen^[StartOffset+1]:=Hi(InCharColor);
               End;
               Inc(Index);Inc(Index);
            End;
  End;

End;


{*****************************************************************}
{Procedure HadleDropDownEvent                                     }
{Handles Drop Down Events                                         }
{*****************************************************************}

Procedure DropDown.HandleDropDownEvent;
Var
    TraceMenu            :PMenuNode;
    Answer               :Boolean;


Procedure HandleKbDropDownEvent;
Var
    StartNode,MaxNodes   :Byte;
    WX1,WY1,WX2,WY2      :Byte;
    YDif                 :Byte;
    I                    :Integer;
    J                    :Word;
    Delayer2             :Byte;
    Delayer              :Word;

Procedure ShowTextDownWards(TraceText :PDynText);
Var
        TraceVY,TraceVX   :Byte;
        I                 :Word;
        YDif              :Byte;
        YOfs              :Byte;
Begin
    WriteTextColor:=TDropDown^.DDRevBckColor;
    WriteTextBackGround:=TDropDown^.DDTableColor;
    YDif:=TDropDown^.DDTableWindow^.BY2-TDropDown^.DDTableWindow^.BY1;
    Inc(YDif);

    YOfs:=TDropDown^.DDTableWindow^.BY2-1;

    IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 to YDif-1 do
    Begin
      DropDownTableNormalColor(YOfs,TraceText^.TextLine^);
      TraceText:=TraceText^.PrevTextLine;
      Dec(YOfs);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;


{**********************************}
{Procedure ShowTextUpWards         }
{Ñ£≠ò§†ùú† òß¶ ´û§ TraceText °ò†   }
{°ò´‡ ´ò õúõ¶£ú§ò ´û™ ô¶ûüú†ò™.    }
{èêÑèÑà §ò õ†§¶¨£ú ò®Æ†°û ´†£û ©´û§}
{tracetext.                        }
{**********************************}

Procedure ShowTextUpWards(TraceText :PDynText);
Var
        TraceVX,TraceVY   :Byte;
        I                 :Integer;
        YDif              :Byte;
        YOfs              :Byte;
Begin
    WriteTextColor:=TDropDown^.DDRevBckColor;
    WriteTextBackGround:=TDropDown^.DDTableColor;
    YDif:=TDropDown^.DDTableWindow^.BY2-TDropDown^.DDTableWindow^.BY1;
    Inc(YDif);

    YOfs:=TDropDown^.DDTableWindow^.BY1+1;

    IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
          (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
         ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
             (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=1 to YDif-1 do
    Begin
      DropDownTableNormalColor(YOfs,TraceText^.TextLine^);
      TraceText:=TraceText^.NextTextLine;
      Inc(YOfs);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;


Begin
    TDropDown:=Win^.CurMenusSeq^.NodePtr;
    CurrentHelpPtr:=TDropDown^.DDDiskHelp;

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;


        DefaulTDropDownColor;
        IF TDropDown^.DDHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TDropDown^.DDHelpCtx^;
           ShowHelpCtx(TDropDown^.DDHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

        IF TDropDown^.DDLabel<>'' Then
        Begin
           WriteTextColor:=TDropDown^.DDRevLabelColor;
           WriteTextBackGround:=Win^.WTextBackGround;
          IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
              (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
             ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
               (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
           Begin
             HiddenMouseCursor;
             HiddenMouse:=True;
           End;
           WriteStrAndMark(TDropDown^.DDLabX1+Win^.X1,TDropDown^.DDLabY1+Win^.Y1,TDropDown^.DDLabel);
           IF HiddenMouse Then
           Begin
             ShowMouseCursor;
             HiddenMouse:=False;
           End;
        End;


    End
    Else


    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin

         {Pressing on the Current Choise without the Arrow}
         IF (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2-1-Byte(VgaExist)]) and
             (InterMY+1 = Win^.Y1+TDropDown^.DDY1) And (TDropDown^.DDTableWindow = Nil) Then
         Begin

             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBDropDownEvent;

             Repeat
             Until MouseButton=MsIdle;
         End
         Else
         {Pressing The Arrow}
         IF (InterMX+1 in [Win^.X1+TDropDown^.DDX2-Byte(VgaExist)..Win^.X1+TDropDown^.DDX2]) and
             (InterMY+1 = Win^.Y1+TDropDown^.DDY1) And (TDropDown^.DDTableWindow = Nil)  Then
         Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBDropDownEvent;

             Ctrl:=#0;
             Ascii:=Chr(KbInsert);
             HandleKBDropDownEvent;

             Repeat
             Until MouseButton=MsIdle;
         End
         Else
         {Mouse Table Up Arrow}

         IF (TDropDown^.DDTableWindow <> Nil) and
            (InterMX+1 in [TDropDown^.DDTableWindow^.BX2-Byte(VgaExist)..TDropDown^.DDTableWindow^.BX2]) and
             (InterMY+1 = TDropDown^.DDTableWindow^.BY1)   Then
         Begin
             Delayer2:=1;

             SetMouseMinMaxX(TDropDown^.DDTableWindow^.BX2-Byte(VgaExist),TDropDown^.DDTableWindow^.BX2);
             SetMouseMinMaxY(TDropDown^.DDTableWindow^.BY1,TDropDown^.DDTableWindow^.BY1);

             Repeat
               Ctrl:=#0;
               Ascii:=Chr(KbArrowUp);
               HandleKBDropDownEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;


               Repeat
                 RetraceDelay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);

         End
         Else
         {Mouse Table Down Arrow}
         IF (TDropDown^.DDTableWindow <> Nil) and
            (InterMX+1 in [TDropDown^.DDTableWindow^.BX2-Byte(VgaExist)..TDropDown^.DDTableWindow^.BX2]) and
             (InterMY+1 = TDropDown^.DDTableWindow^.BY2)   Then
         Begin
             Delayer2:=1;

             SetMouseMinMaxX(TDropDown^.DDTableWindow^.BX2-Byte(VgaExist),TDropDown^.DDTableWindow^.BX2);
             SetMouseMinMaxY(TDropDown^.DDTableWindow^.BY2,TDropDown^.DDTableWindow^.BY2);

             Repeat
               Ctrl:=#0;
               Ascii:=Chr(KbArrowDown);
               HandleKBDropDownEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;

               Repeat
                 RetraceDelay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);


         End
         Else
         {Pressing any Choise just accept it and Close it}
         IF (TDropDown^.DDTableWindow <> Nil) and
            (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2-1-Byte(VgaExist)]) and
             (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2])   Then
         Begin
            I:=((InterMY+1) - (TDropDown^.DDTableWindow^.BY1))+1;
            IF (TDropDown^.DDVirtualY + (I - TDropDown^.DDVisualY) > TDropDown^.DDMaxLines)
                Or (TDropDown^.DDVirtualY + (I - TDropDown^.DDVisualY) < 1) Then
                    Exit;

            WY1:=TDropDown^.DDTableWindow^.BY1;
            DropDownTableNormalColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);

            TDropDown^.DDVirtualY:=TDropDown^.DDVirtualY + (I - TDropDown^.DDVisualY);
            TDropDown^.DDVisualY:=I;
            TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
             IF TDropDown^.DDVirtualY > 1 Then
                 For I:=1 to TDropDown^.DDVirtualY-1 do
                     TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;

            DropDownTableDefaultColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);

            Ctrl:=#32;
            HandleKBDropDownEvent;

         End
         Else

         {Pressing everything out of Table,Cancels the marked Choise}
         IF (TDropDown^.DDTableWindow <> Nil) Then
         Begin
             Ctrl:=#27;
             HandleKBDropDownEvent;

             Repeat
             Until MouseButton=MsIdle;
         End;

    End
    Else

    {Down Arrow when table window is on}

    IF (Ctrl=#0) and (Ascii=Chr(KbArrowDown)) and (TDropDown^.DDTableWindow <> Nil )
      And (TDropDown^.DDVirtualY < TDropDown^.DDMaxLines) Then
    Begin

         WX1:=TDropDown^.DDTableWindow^.BX1;
         WX2:=TDropDown^.DDTableWindow^.BX2;
         WY1:=TDropDown^.DDTableWindow^.BY1;
         WY2:=TDropDown^.DDTableWindow^.BY2;

         IF WY1+(TDropDown^.DDVisualY-1) < WY2 Then
         Begin
             DropDownTableNormalColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
             Inc(TDropDown^.DDVisualY);
             Inc(TDropDown^.DDVirtualY);
             TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
             DropDownTableDefaultColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
         End
         Else
         IF (WY1+(TDropDown^.DDVisualY-1) >= WY2) and (TDropDown^.DDVirtualY < TDropDown^.DDMaxLines) Then
         Begin
             Inc(TDropDown^.DDVirtualY);
             ShowTextDownWards(TDropDown^.DDText);

             TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
             DropDownTableDefaultColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
         End;

    End
    Else

    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TDropDown:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TDropDown Then
           Begin

             IF TDropDown^.DDLabel<>'' Then
             Begin
                WriteTextColor:=TDropDown^.DDNormLabelColor;
                WriteTextBackGround:=Win^.WTextBackGround;
                IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
                   (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
                   ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
                   (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
                Begin
                  HiddenMouseCursor;
                  HiddenMouse:=True;
                End;
                WriteStrAndMark(TDropDown^.DDLabX1+Win^.X1,TDropDown^.DDLabY1+Win^.Y1,TDropDown^.DDLabel);
                IF HiddenMouse Then
                Begin
                  ShowMouseCursor;
                  HiddenMouse:=False;
                End;
             End;

             NormalDropDownColor;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {Up Arrow when table window is on}
    IF (Ctrl=#0) and (Ascii=Chr(KbArrowUp)) and (TDropDown^.DDTableWindow <> Nil )
      And (TDropDown^.DDVirtualY > 1) Then
    Begin
         WX1:=TDropDown^.DDTableWindow^.BX1;
         WX2:=TDropDown^.DDTableWindow^.BX2;
         WY1:=TDropDown^.DDTableWindow^.BY1;
         WY2:=TDropDown^.DDTableWindow^.BY2;

         IF WY1+(TDropDown^.DDVisualY-1) > WY1 Then
         Begin
             DropDownTableNormalColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
             Dec(TDropDown^.DDVisualY);
             Dec(TDropDown^.DDVirtualY);
             TDropDown^.DDText:=TDropDown^.DDText^.PrevTextLine;
             DropDownTableDefaultColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
         End
         Else
         IF (WY1+(TDropDown^.DDVisualY-1) <= WY1) and (TDropDown^.DDVirtualY > 1 ) Then
         Begin
             Dec(TDropDown^.DDVirtualY);
             ShowTextUpWards(TDropDown^.DDText);

             TDropDown^.DDText:=TDropDown^.DDText^.PrevTextLine;
             DropDownTableDefaultColor(WY1+(TDropDown^.DDVisualY-1),TDropDown^.DDText^.TextLine^);
         End;

    End
    Else
    {If page down and Window table is on}
    IF (Ctrl=#0) and (Ascii=Chr(KbPageDown)) and (TDropDown^.DDTableWindow <> Nil )
       And (TDropDown^.DDVirtualY < TDropDown^.DDMaxLines) Then
    Begin

         WX1:=TDropDown^.DDTableWindow^.BX1;
         WX2:=TDropDown^.DDTableWindow^.BX2;
         WY1:=TDropDown^.DDTableWindow^.BY1;
         WY2:=TDropDown^.DDTableWindow^.BY2;

         YDif:=(WY2) - (WY1);
         Inc(YDif);

         {IF Y Size > MaxLines then exit}
         IF TDropDown^.DDMaxLines <= YDif Then
            Exit;

         I:=TDropDown^.DDVirtualY + (YDif - TDropDown^.DDVisualY);
         IF I+Ydif > TDropDown^.DDMaxLines Then
         Begin
            TDropDown^.DDText:=TDropDown^.DDRearTextLine;
            ShowTextDownWards(TDropDown^.DDText^.PrevTextLine);
            DropDownTableDefaultColor(WY2,TDropDown^.DDText^.TextLine^);

            TDropDown^.DDVirtualY:=TDropDown^.DDMaxLines;
            TDropDown^.DDVisualY:=YDif;
         End
         Else
         Begin
            For J:=TDropDown^.DDVirtualY to I do
                 TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;

            ShowTextUpWards(TDropDown^.DDText^.NextTextLine);
            DropDownTableDefaultColor(WY1,TDropDown^.DDText^.TextLine^);

            TDropDown^.DDVirtualY:=I+1;
            TDropDown^.DDVisualY:=1;
         End;

    End
    Else
    {If Page up and window table is on}
    IF (Ctrl=#0) and (Ascii=Chr(KbPageUp)) and (TDropDown^.DDTableWindow <> Nil )
    And (TDropDown^.DDVirtualY > 1) Then
    Begin
         WX1:=TDropDown^.DDTableWindow^.BX1;
         WX2:=TDropDown^.DDTableWindow^.BX2;
         WY1:=TDropDown^.DDTableWindow^.BY1;
         WY2:=TDropDown^.DDTableWindow^.BY2;

         YDif:=(WY2) - (WY1);
         Inc(YDif);

         {IF Y Size > MaxLines then exit}
         IF TDropDown^.DDMaxLines <= YDif Then
            Exit;

         I:=TDropDown^.DDVirtualY - ((WY1+(TDropDown^.DDVisualY - 1))-WY1)-1;
         IF (I-YDif)+1 < 1 Then
         Begin
            TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
            ShowTextUpWards(TDropDown^.DDText^.NextTextLine);
            DropDownTableDefaultColor(WY1,TDropDown^.DDText^.TextLine^);

            TDropDown^.DDVirtualY:=1;
            TDropDown^.DDVisualY:=1;
         End
         Else
         Begin
            I:=(I-YDif)+1;
            For J:=TDropDown^.DDVirtualY Downto I+1 do
                 TDropDown^.DDText:=TDropDown^.DDText^.PrevTextLine;

            ShowTextUpWards(TDropDown^.DDText^.NextTextLine);
            DropDownTableDefaultColor(WY1,TDropDown^.DDText^.TextLine^);

            TDropDown^.DDVirtualY:=I;
            TDropDown^.DDVisualY:=1;
         End;

    End
    Else


    {Page Down and table window is off,Just show the next text}
    IF (Ctrl=#0) and (Ascii=Chr(KbPageDown)) and (TDropDown^.DDTableWindow = Nil ) Then
    Begin
       TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       Inc(TDropDown^.DDVirtualY);
       IF TDropDown^.DDText = Nil Then
       Begin
          TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
          TDropDown^.DDVirtualY:=1;
       End;


       DefaultDropDownColor;

       DropDownCurrentNum:=TDropDown^.DDVirtualY;
       DropDownCurrentStr:=TDropDown^.DDText^.TextLine^;
       Event:=TDropDown^.DDCommand;
       HandleCommand;

    End
    Else

    {Page Up and table window is off,Just show the prev text}
    IF (Ctrl=#0) and (Ascii=Chr(KbPageUp)) and (TDropDown^.DDTableWindow = Nil ) Then
    Begin

       TDropDown^.DDText:=TDropDown^.DDText^.PrevTextLine;
       Dec(TDropDown^.DDVirtualY);
       IF TDropDown^.DDText = Nil Then
       Begin
          TDropDown^.DDText:=TDropDown^.DDRearTextLine;
          TDropDown^.DDVirtualY:=TDropDown^.DDMaxLines;
       End;

       DefaultDropDownColor;

       DropDownCurrentNum:=TDropDown^.DDVirtualY;
       DropDownCurrentStr:=TDropDown^.DDText^.TextLine^;
       Event:=TDropDown^.DDCommand;
       HandleCommand;

    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF  ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and ( (Ascii=#77) or ((Ascii=#80) and
                 (TDropDown^.DDTableWindow = Nil) ) ) )  Then
    Begin
         IF TDropDown^.DDTableWindow <> Nil Then
         Begin
             Ctrl:=#27;
             HandleKBDropDownEvent;
         End;

         IF TDropDown^.DDLabel<>'' Then
         Begin
            WriteTextColor:=TDropDown^.DDNormLabelColor;
            WriteTextBackGround:=Win^.WTextBackGround;
            IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
              (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
              ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
               (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
            Begin
              HiddenMouseCursor;
              HiddenMouse:=True;
            End;
            WriteStrAndMark(TDropDown^.DDLabX1+Win^.X1,TDropDown^.DDLabY1+Win^.Y1,TDropDown^.DDLabel);
            IF HiddenMouse Then
            Begin
              ShowMouseCursor;
              HiddenMouse:=False;
            End;
         End;


         NormalDropDownColor;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and ( (Ascii=#75) or ((Ascii=#72)
       and (TDropDown^.DDTableWindow = Nil )) ) ) Then
    Begin
         IF TDropDown^.DDTableWindow <> Nil Then
         Begin
             Ctrl:=#27;
             HandleKBDropDownEvent;
         End;

         IF TDropDown^.DDLabel<>'' Then
         Begin
            WriteTextColor:=TDropDown^.DDNormLabelColor;
            WriteTextBackGround:=Win^.WTextBackGround;

            IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
               (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
               ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
               (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
            Begin
              HiddenMouseCursor;
              HiddenMouse:=True;
            End;
            WriteStrAndMark(TDropDown^.DDLabX1+Win^.X1,TDropDown^.DDLabY1+Win^.Y1,TDropDown^.DDLabel);
            IF HiddenMouse Then
            Begin
              ShowMouseCursor;
              HiddenMouse:=False;
            End;
         End;


         NormalDropDownColor;
         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    IF  ( ((Ctrl=#0) and (Ascii=Chr(KbInsert))) OR
        (Ctrl=#32) ) And (TDropDown^.DDTableWindow=Nil) And
        ((Win^.X1+TDropDown^.DDX2-Win^.X1+TDropDown^.DDX1) >= Length(TDropDown^.DDHeadTextLine^.TextLine^)) And
        ((Win^.Y1+TDropDown^.DDY2-Win^.Y1+TDropDown^.DDY1) >= (TDropDown^.DDY1+2)) Then
    Begin
       New(TDropDown^.DDTableWindow);
       IF TDropDown^.DDTableWindow = Nil Then
          Exit;

       IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) or
          (InterMX+2 in [Win^.X1+TDropDown^.DDX1..Win^.X1+TDropDown^.DDX2]) )AND
         ( (InterMY+1 in [Win^.Y1+TDropDown^.DDY1-1-(TDropDown^.DDY2-TDropDown^.DDY1)..Win^.Y1+TDropDown^.DDY2]) or
             (InterMY+2 in [Win^.Y1+TDropDown^.DDY1..Win^.Y1+TDropDown^.DDY2]) ) Then
       Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
       End;

       IF TDropDown^.DDTable=DownWard Then
          TDropDown^.DDTableWindow^.SaveArea(Win^.X1+TDropDown^.DDX1,Win^.Y1+TDropDown^.DDY1+1,
               Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY2)
       Else
          TDropDown^.DDTableWindow^.SaveArea(Win^.X1+TDropDown^.DDX1,Win^.Y1+TDropDown^.DDY1-
                (TDropDown^.DDY2-TDropDown^.DDY1),Win^.X1+TDropDown^.DDX2,Win^.Y1+TDropDown^.DDY1-1);

       IF HiddenMouse Then
       Begin
         ShowMouseCursor;
         HiddenMouse:=False;
       End;

       DropDownDrawTable;
       NormalDropDownColor;
       DropDownUpArrow;
       DropDownShowTableText;
       DoCheckEveryThing:=False;
    End
    Else

    {Just Cancel the marked Choise}
    IF (Ctrl=#27) And (TDropDown^.DDTableWindow<>Nil) Then
    Begin

        IF ( (InterMX+1 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
           (InterMX+2 in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
           ( (InterMY+1 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
           (InterMY+2 in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then

        Begin
          HiddenMouseCursor ;
          HiddenMouse:=True;
        End;
        DropDownCloseTable;
        TDropDown^.DDTableWindow^.RestoreArea;

        IF HiddenMouse Then
        Begin
           ShowMouseCursor;
           HiddenMouse:=False;
        End;
        Dispose(TDropDown^.DDTableWindow);
        TDropDown^.DDTableWindow:=Nil;
        TDropDown^.DDText:=TDropDown^.DDSavText;

        DefaultDropDownColor;
        DropDownDownArrow;
        DoCheckEveryThing:=True;
    End
    Else

    {Accept the marked Choise}
    IF ( (Ctrl=#32) Or ( (Ctrl=#0) and (Ascii=Chr(KbInsert)) ) And (TDropDown^.DDTableWindow<>Nil) ) Then
    Begin
        IF TDropDown^.DDTableWindow = Nil Then
           Exit;

        IF ( ((InterMX+1) in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) or
           ((InterMX+2) in [TDropDown^.DDTableWindow^.BX1..TDropDown^.DDTableWindow^.BX2]) )AND
           (((InterMY+1) in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) or
           ((InterMY+2) in [TDropDown^.DDTableWindow^.BY1..TDropDown^.DDTableWindow^.BY2]) ) Then

        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;
        DropDownCloseTable;
        TDropDown^.DDTableWindow^.RestoreArea;

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
        Dispose(TDropDown^.DDTableWindow);
        TDropDown^.DDTableWindow:=Nil;

        DefaultDropDownColor;
        DropDownDownArrow;
        DoCheckEveryThing:=True;

        DropDownCurrentNum:=TDropDown^.DDVirtualY;
        DropDownCurrentStr:=TDropDown^.DDText^.TextLine^;

        Event:=TDropDown^.DDCommand;
        HandleCommand;
    End;

    DropDownCurrentNum:=TDropDown^.DDVirtualY;
    DropDownCurrentStr:=TDropDown^.DDText^.TextLine^;
    MsLeftDoubleClick:=False;
End;

Procedure HandleMsDropDownEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;

     IF DoCheckEveryThing Then
     Begin
           Trace:=Win^.HeadMenusSeq;

           WX1:=Trace^.X1+Win^.X1;
           WX2:=Trace^.X2+Win^.X1;
           WY1:=Trace^.Y1+Win^.Y1;
           WY2:=Trace^.Y2+Win^.Y1;

           Repeat
                IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
                   Found:=True
                Else
                Begin
                   Trace:=Trace^.Next;
                   WX1:=Trace^.X1+Win^.X1;
                   WX2:=Trace^.X2+Win^.X1;
                   WY1:=Trace^.Y1+Win^.Y1;
                   WY2:=Trace^.Y2+Win^.Y1;
                End;
           Until (Trace=Nil) or (Found=True);
     End
     Else
     Begin
          {We have already the Table Window Open,so check the Topic}
          {Mouse Coordinates and execute the event.                }
          Found:=True;
          Trace:=Win^.CurMenusSeq;
     End;


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TDropDown:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TDropDown Then
           Begin

             IF TDropDown^.DDLabel<>'' Then
             Begin
                WriteTextColor:=TDropDown^.DDNormLabelColor;
                WriteTextBackGround:=Win^.WTextBackGround;
                IF ( (InterMX+1 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) or
                   (InterMX+2 in [Win^.X1+TDropDown^.DDLabX1..Win^.X1+TDropDown^.DDLabX1+Length(TDropDown^.DDLabel)]) )AND
                   ( (InterMY+1 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) or
                   (InterMY+2 in [Win^.Y1+TDropDown^.DDLabY1..Win^.Y1+TDropDown^.DDLabY1]) ) Then
                Begin
                  HiddenMouseCursor;
                  HiddenMouse:=True;
                End;
                WriteStrAndMark(TDropDown^.DDLabX1+Win^.X1,TDropDown^.DDLabY1+Win^.Y1,TDropDown^.DDLabel);
                IF HiddenMouse Then
                Begin
                  ShowMouseCursor;
                  HiddenMouse:=False;
                End;
             End;

             NormalDropDownColor;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End


End;
Begin
   Case Event Of
       0:HandleKBDropDownEvent;
       1:HandleMsDropDownEvent;
   End;

End;



BEGIN

END.