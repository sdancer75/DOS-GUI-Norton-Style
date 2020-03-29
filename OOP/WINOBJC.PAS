UNIT WinObjC;

INTERFACE
Uses WindowsObj,VarConstObj,GeneralObj,MouseObj,
            ErrorDlg,WinApplObj,WinObjA,WinObjB;

Const
     Simple     = 0;
     Box        = 1;

Type

   PTxtBox   = ^TxtBox;
   TxtBox    = Object (DropDown)
       TBX1,TBY1,
       TBX2,TBY2        :Byte;
       TBBaseYPosit     :Byte;{internal variables}
       TBVerScrBar      :PVerScrollBar;
       TBMaxLines       :Word;
       TBVisualYPosit   :Word;
       TBVirtualYPosit  :Word;
       TBCommand        :Word;
       TBHelpCtx        :^Str80;  {Status Line Help                  }
       TBDiskHelp       :Word;    {On Line Help number               }
       TBHeadText,
       TBTailText,
       TBCurText        :PDynText;
       TBBox            :Boolean; {Flag to see if we have drawn a Ascii Box}
       TBTextBoxNormTxtColor,
       TBTextBoxNormBckColor,
       TBTextBoxRevTxtColor,
       TBTextBoxRevBckColor    :Byte; {Yeap ! The colors}


       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitTextBox(InParams :Word);
       Procedure   TextBoxHelp(InHelpCtx:Str80;InDiskHelp:Word);
       Procedure   ShowTextBox(HeadPtr,TailPtr :PDynText);
       Procedure   WriteTextStr(YVal :Byte;A:String);
       Procedure   AdjustTxtBox;
       Procedure   TextBoxDeleteAllText;

       Procedure   HandleTextBoxEvent;

   End;



Var

   TTxtBox   :PTxtBox;


IMPLEMENTATION


Procedure TxtBox.HandleCommand;
Begin

End;

Procedure TxtBox.WinHandleEvent;
Begin

End;


Procedure TxtBox.InitTextBox;
Var
   SaveObjX1    :Byte;
   VS           :PVerScrollBar;
   A,B,C,D      :Byte;
Begin
    SaveObjX1:=ObjectX1;
    ObjectX1:=ObjectX2;

    IF HeapErrorCode=1 Then
    Begin
        TTxtBox:=Nil;
        Exit;
    End;

    A:=ScrollBarNormTxtColor;
    B:=ScrollBarNormBckColor;
    C:=ScrollBarRevTxtColor;
    D:=ScrollBarRevBckColor;

    ScrollBarNormTxtColor    := $FF;
    ScrollBarNormBckColor    := 6;
    ScrollBarRevTxtColor     := 0;
    ScrollBarRevBckColor     := 6;
    VS:=InitVerScrollBar(NoCm);

    ScrollBarNormTxtColor    := A;
    ScrollBarNormBckColor    := B;
    ScrollBarRevTxtColor     := C;
    ScrollBarRevBckColor     := D;

    New(TTxtBox);

    IF TTxtBox=Nil Then
       Exit;

    ObjectX1:=SaveObjX1;

    TTxtBox^.TBX1:=ObjectX1;
    TTxtBox^.TBY1:=ObjectY1;
    TTxtBox^.TBX2:=ObjectX2;
    TTxtBox^.TBY2:=ObjectY2;
    TTxtBox^.TBVerScrBar:=VS;
    TTxtBox^.TBMaxLines:=0;

    TTxtBox^.TBVisualYPosit:=1;
    TTxtBox^.TBVirtualYPosit:=1;
    TTxtBox^.TBBox:=False;
    TTxtBox^.TBHeadText:=Nil;
    TTxtBox^.TBTailText:=Nil;
    TTxtBox^.TBCurText:=Nil;
    TTxtBox^.TBHelpCtx:=Nil;
    TTxtBox^.TBDiskHelp:=0;
    TTxtBox^.TBCommand:=0;
    TTxtBox^.TBBaseYPosit:=0;

    TTxtBox^.TBTextBoxNormTxtColor:=TextBoxNormTxtColor;
    TTxtBox^.TBTextBoxNormBckColor:=TextBoxNormBckColor;
    TTxtBox^.TBTextBoxRevTxtColor:=TextBoxRevTxtColor;
    TTxtBox^.TBTextBoxRevBckColor:=TextBoxRevBckColor;


    Win^.TailMenusSeq^.IDByte:=TextBoxes;
    Win^.TailMenusSeq^.NodePtr:=TTxtBox;
    Win^.TailMenusSeq^.X1:=ObjectX1;
    Win^.TailMenusSeq^.Y1:=ObjectY1;
    Win^.TailMenusSeq^.X2:=ObjectX2+Abs(ObjectX2-TTxtBox^.TBVerScrBar^.VSBX2);
    Win^.TailMenusSeq^.Y2:=ObjectY2;
    Win^.TailMenusSeq^.BroadCast:=0;

    IF (InParams and Box) = Box Then
    Begin
      TTxtBox^.TBBox:=True;
      WriteTextColor:=15;
      WriteTextBackGround:=Win^.WTextBackGround;
      TextBox(ObjectX1,ObjectY1,ObjectX2-1-Byte(VgaExist),ObjectY2,SingleLines);
    End;
End;


Procedure TxtBox.TextBoxHelp;
Begin
    IF (TTxtBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
       TTxtBox^.TBHelpCtx:=Nil
    Else
    Begin
        New(TTxtBox^.TBHelpCtx);
        IF TTxtBox^.TBHelpCtx=Nil Then
           Exit;
        TTxtBox^.TBHelpCtx^:=InHelpCtx;
    End;

    TTxtBox^.TBDiskHelp:=InDiskHelp;
End;


Procedure TxtBox.WriteTextStr(YVal :Byte;A:String);
Var
   I    :Byte;
Begin
    IF ((TTxtBox^.TBY1+YVal+Byte(TTxtBox^.TBBox)) > (TTxtBox^.TBY2-Byte(TTxtBox^.TBBox)) ) Or
       ((TTxtBox^.TBY1+YVal+Byte(TTxtBox^.TBBox)) < ( TTxtBox^.TBY1 + Byte(TTxtBox^.TBBox) ) ) Then
          Exit;

    IF Length(A) > ( (TTxtBox^.TBX2-1-Byte(VgaExist)) - (TTxtBox^.TBX1+Byte(TTxtBox^.TBBox)) ) Then
       A:=Copy(A,1,(TTxtBox^.TBX2-1-Byte(VgaExist)) - (TTxtBox^.TBX1+Byte(TTxtBox^.TBBox)) );

    WriteTextColor:=TTxtBox^.TBTextBoxNormTxtColor;
    WriteTextBackGround:=TTxtBox^.TBTextBoxNormBckColor;

    IF WriteTextColor=$FF Then
       WriteTextColor:=Win^.WTextColor;
    IF WriteTextBackGround=$FF Then
       WriteTextBackGround:=Win^.WTextBackGround;

    WriteWindow(TTxtBox^.TBX1+Byte(TTxtBox^.TBBox),TTxtBox^.TBY1+Byte(TTxtBox^.TBBox)+YVal,A);

    IF Length(A) < ( (TTxtBox^.TBX2-1-Byte(VgaExist)) - (TTxtBox^.TBX1+Byte(TTxtBox^.TBBox)) ) Then
    Begin
        HiddenMouseCursor;
        For I:=Length(A) to ( (TTxtBox^.TBX2-1-Byte(VgaExist)) - (TTxtBox^.TBX1+Byte(TTxtBox^.TBBox)) ) do
            WriteVirtWinChar(Win^.X1+TTxtBox^.TBX1+Byte(TTxtBox^.TBBox)+I,Win^.Y1+
               TTxtBox^.TBY1+Byte(TTxtBox^.TBBox)+YVal,WriteTextColor,WriteTextBackGround,32);
        ShowMouseCursor;

    End;

End;

Procedure TxtBox.ShowTextBox;
Var
   I                  :Word;
   X,Y                :Word;
   HelpSeg,HelpOfs    :Word;
   MyChar             :Char;
   R                  :Byte;
   CurrentY           :Byte;
Begin

    TTxtBox^.TBHeadText:=HeadPtr;
    TTxtBox^.TBTailText:=TailPtr;

    TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;

    IF TTxtBox^.TBCurText = Nil Then
       Exit;

    TTxtBox^.TBMaxLines:=0;

    IF ( (InterMX+1 in [Win^.X1+TTxtBox^.TBX1..Win^.X1+TTxtBox^.TBX2]) or
       (InterMX+2 in [Win^.X1+TTxtBox^.TBX1..Win^.X1+TTxtBox^.TBX2]) )AND
      ( (InterMY+1 in [Win^.Y1+TTxtBox^.TBY1..Win^.Y1+TTxtBox^.TBY2]) or
          (InterMY+2 in [Win^.Y1+TTxtBox^.TBY1..Win^.Y1+TTxtBox^.TBY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    WriteTextColor:=TTxtBox^.TBTextBoxNormTxtColor;
    WriteTextBackGround:=TTxtBox^.TBTextBoxNormBckColor;

    IF WriteTextColor=$FF Then
       WriteTextColor:=Win^.WTextColor;
    IF WriteTextBackGround=$FF Then
       WriteTextBackGround:=Win^.WTextBackGround;

    R:=Byte(TTxtBox^.TBBox);
    For Y:=Win^.Y1+TTxtBox^.TBY1+R to Win^.Y1+TTxtBox^.TBY2-R do
        For X:=Win^.X1+TTxtBox^.TBX1+R to Win^.X1+TTxtBox^.TBX2-1-Byte(VgaExist) do
            WriteVirtWinChar(X,Y,WriteTextColor,WriteTextBackGround,32);

    CurrentY:=0;
    Repeat
       If TTxtBox^.TBCurText <> Nil Then
       Begin
         WriteTextStr(CurrentY,TTxtBox^.TBCurText^.TextLine^);
         TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
         Inc(TTxtBox^.TBMaxLines);
         Inc(CurrentY);
       End;
    Until TTxtBox^.TBCurText = Nil;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    IF (TTxtBox^.TBY1+R+TTxtBox^.TBMaxLines) > (TTxtBox^.TBY2-R) Then
    Begin
        TTxtBox^.TBVisualYPosit:=((TTxtBox^.TBY2-R)-(TTxtBox^.TBY1+R))+1;
        TTxtBox^.TBVirtualYPosit:=((TTxtBox^.TBY2-R)-(TTxtBox^.TBY1+R))+1;
    End
    Else
    Begin
        TTxtBox^.TBVisualYPosit:=TTxtBox^.TBMaxLines;
        TTxtBox^.TBVirtualYPosit:=TTxtBox^.TBMaxLines;
    End;

    IF TTxtBox^.TBVisualYPosit > 1 Then
    Begin
      TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;
      For I:=1 To TTxtBox^.TBVisualYPosit-1 Do
          TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
    End;

    TTxtBox^.TBBaseYPosit:=TTxtBox^.TBVisualYPosit;

    TVerScrollBar:=TTxtBox^.TBVerScrBar;
    IF TTxtBox^.TBMaxLines > TTxtBox^.TBBaseYPosit Then
       TTxtBox^.TBVerScrBar^.SetVerScrBarMaximumChoises(TTxtBox^.TBMaxLines-TTxtBox^.TBBaseYPosit)
    Else
      TTxtBox^.TBVerScrBar^.SetVerScrBarMaximumChoises(TTxtBox^.TBMaxLines);

    TTxtBox^.TBVerScrBar^.NormalVerScrollBarColor;
    TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=1;

End;


Procedure TxtBox.TextBoxDeleteAllText;
Begin
    TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;

    IF TTxtBox^.TBCurText = Nil Then
       Exit;

    Repeat
         IF (TTxtBox^.TBCurText<>Nil) Then
         Begin
             FreeMem(TTxtBox^.TBCurText^.TextLine,Length(TTxtBox^.TBCurText^.TextLine^)+1);
             TTxtBox^.TBHeadText:=TTxtBox^.TBCurText;
             TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
             Dispose(TTxtBox^.TBHeadText);
         End;
    Until TTxtBox^.TBCurText = Nil;

    TTxtBox^.TBHeadText:=Nil;
    TTxtBox^.TBTailText:=Nil;
    TTxtBox^.TBCurText:=Nil;
End;

{*************************************************************************}
{Procedure TxtBox.AdjustMenuBox                                          }
{ãú´ò´¶ß†ùú† ´¶ °ú†£ú§¶ ò§ò¢¶öò £ú ´¶§ pointer ´¶¨ VerScrollBar.          }
{*************************************************************************}
Procedure TxtBox.AdjustTxtBox;
Var
    MaxVis       :Byte;
    MaxVisPtr    :Byte;
    I            :Word;
    CurrentChoise:Word;
Begin
   IF (TTxtBox^.TBVerScrBar^.VSBMaxChoises < ((TTxtBox^.TBVerScrBar^.VSBY2-Byte(TTxtBox^.TBBox))-
          (TTxtBox^.TBVerScrBar^.VSBY1+Byte(TTxtBox^.TBBox))+1)) Then
      Exit;

   MaxVis:=(TTxtBox^.TBY2-Byte(TTxtBox^.TBBox))-(TTxtBox^.TBY1+Byte(TTxtBox^.TBBox))+1;
   MaxVisPtr:=(TTxtBox^.TBVerScrBar^.VSBY2-1)-(TTxtBox^.TBVerScrBar^.VSBY1);
   TTxtBox^.TBVisualYPosit:=1;

   {IF VerScrollBar Pointer is on the First Position}
   IF TTxtBox^.TBVerScrBar^.VSBPointer = 1 Then
   Begin
      TTxtBox^.TBVirtualYPosit:=1;
      CurrentChoise:=1;
      TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=1;
      TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;

      For I:=1 to MaxVis do
      Begin
         WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
         IF I<>MaxVis Then
         Begin
           TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
           Inc(TTxtBox^.TBVisualYPosit);
           Inc(TTxtBox^.TBVirtualYPosit);
         End;
      End;

      TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=1;
   End
   Else
   {IF VerScrollBar Pointer is on the Last Position}

   IF TTxtBox^.TBVerScrBar^.VSBPointer = MaxVisPtr Then
   Begin
         TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=TTxtBox^.TBVerScrBar^.VSBMaxChoises;
         CurrentChoise:=TTxtBox^.TBVerScrBar^.VSBMaxChoises - MaxVis;
         Inc(CurrentChoise);
         TTxtBox^.TBCurText:=TTxtBox^.TBTailText;
         TTxtBox^.TBVisualYPosit:=MaxVis;
         TTxtBox^.TBVirtualYPosit:=TTxtBox^.TBMaxLines;

         For I:=TTxtBox^.TBVerScrBar^.VSBMaxChoises downto CurrentChoise do
         Begin
            WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
            IF I<>CurrentChoise Then
            Begin
              TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.PrevTextLine;
              Dec(TTxtBox^.TBVisualYPosit);
            End;
         End;
         TTxtBox^.TBCurText:=TTxtBox^.TBTailText;
         TTxtBox^.TBVirtualYPosit:=TTxtBox^.TBMaxLines;
         TTxtBox^.TBVisualYPosit:=MaxVis;
   End
   Else

   {IF VerScrollBar Pointer is non of the above positions}
   Begin
        CurrentChoise:=TTxtBox^.TBVerScrBar^.VSBPointer * TTxtBox^.TBVerScrBar^.VSBPointerStep;
        IF CurrentChoise+MaxVis > TTxtBox^.TBMaxLines Then
        Begin
            I:=(CurrentChoise+MaxVis) - TTxtBox^.TBVerScrBar^.VSBMaxChoises;
            CurrentChoise:=CurrentChoise-I;
            IF CurrentChoise < 0 Then
               CurrentChoise:=1;
        End;
        TTxtBox^.TBVisualYPosit:=1;
        TTxtBox^.TBVirtualYPosit:=CurrentChoise;
        TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
        TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;
        IF CurrentChoise > 1 Then
           For I:=1 to CurrentChoise-1 do
               TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;

        For I:=1 to MaxVis do
        Begin
           WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
           IF I<>MaxVis Then
           Begin
             TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
             Inc(TTxtBox^.TBVisualYPosit);
             Inc(TTxtBox^.TBVirtualYPosit);
           End;
        End;
   End;
End;

{*******************************************************************}
{Procedure HandleTextBoxEvent                                       }
{*******************************************************************}

Procedure TxtBox.HandleTextBoxEvent;
Var
   Answer       :Boolean;

Procedure CallVerScrollKBEvent;
Var
   TempObjectPtr        :Pointer;
Begin
   {If we haven't any ver scroll bar then just exit                     }
   IF TTxtBox^.TBVerScrBar = Nil Then
      Exit;

   Event:=0;  {KeyBoard event}
   TempObjectPtr:=Win^.CurMenusSeq^.NodePtr; {Keep the current node somewhere temp}
   Win^.CurMenusSeq^.NodePtr:=TTxtBox^.TBVerScrBar; {Put scroller pointer into}
   TTxtBox^.TBVerScrBar^.HandleVerScrollBarEvent; {Call Scroller procedure}
   Win^.CurMenusSeq^.NodePtr:=TempObjectPtr; {And then come to previous position}
End;


Procedure HandleKBTxtBoxEvent;
Var
        TraceVY           :Byte;
        TraceVirY         :Byte;
        I                 :Integer;
        TraceText         :PDynText;
        YDif              :Byte;
        Delayer           :Word;
        Delayer2          :Word;
        TracePointer      :Byte;
        MyMouseX,MyMouseY :Byte;
        J                 :Integer;
        MouseResponse     :Boolean;
        MaxVis            :Byte;
Begin

    TTxtBox:=Win^.CurMenusSeq^.NodePtr;
    TVerScrollBar:=TTxtBox^.TBVerScrBar;

    CurrentHelpPtr:=TTxtBox^.TBDiskHelp;

    {For Keyboard come here}
    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;

        TTxtBox^.TBVerScrBar^.DefaultVerScrollBarColor;

        IF TTxtBox^.TBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TTxtBox^.TBHelpCtx^;
           ShowHelpCtx(TTxtBox^.TBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

    End
    Else

    {For Mouse come here}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        MouseResponse:=True;

        {Up Arrow}

        IF (InterMX+1 in [Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1..Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2])
            and (InterMY+1 = Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1) Then
        Begin
          Ctrl:=#$FF;
          Ascii:=#$FF;
          HandleKBTxtBoxEvent;
          Delayer2:=1;

          SetMouseMinMaxX(Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1,Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2);
          SetMouseMinMaxY(Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1,Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1);

          Repeat
            Ctrl:=#0;
            Ascii:=#72;
            HandleKBTxtBoxEvent;

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

       IF (InterMX+1 in [Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1..Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2])
           and (InterMY+1 = Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY2) Then
       Begin
          Ctrl:=#$FF;
          Ascii:=#$FF;
          HandleKBTxtBoxEvent;
          Delayer2:=1;

          SetMouseMinMaxX(Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1,Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2);
          SetMouseMinMaxY(Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY2,Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY2);

          Repeat
            Ctrl:=#0;
            Ascii:=#80;
            HandleKBTxtBoxEvent;

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

       IF ( (InterMX+1 in [Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1..Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2])
           and (InterMY+1 = Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1+(TTxtBox^.TBVerScrBar^.VSBPointer)) )
           AND ((TTxtBox^.TBVerScrBar^.VSBMaxChoises)
                     >= ((TTxtBox^.TBVerScrBar^.VSBY2-1)-(TTxtBox^.TBVerScrBar^.VSBY1+1)+1)) Then
       Begin

         CurOff;
         ReadCurPositHeight;
         Win^.WinSScanL:=SScanL;
         Win^.WinEScanL:=EScanL;
         Win^.WinCurX:=1;
         Win^.WinCurY:=1;

         {Make the initials adjustments}
          TTxtBox^.TBVerScrBar^.DefaultVerScrollBarColor;

         IF TTxtBox^.TBHelpCtx<>Nil Then
         Begin
           Win^.CurrentMessageLine:=TTxtBox^.TBHelpCtx^;
           ShowHelpCtx(TTxtBox^.TBHelpCtx^);
         End
         Else
          Begin
            Win^.CurrentMessageLine:='';
            ShowHelpCtx('');
          End;

          SetMouseMinMaxX(Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1,Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2);
          SetMouseMinMaxY(Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1+1,Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY2-1);

          Repeat
             MYMouseX:=InterMX+1;MYMouseY:=InterMY+1;

             IF (MyMouseX in [Win^.X1+TTxtBox^.TBVerScrBar^.VSBX1..Win^.X1+TTxtBox^.TBVerScrBar^.VSBX2])
                  and (MyMouseY in [Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1+1..Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY2-1]) Then
             Begin
               TracePointer:=(MyMouseY-(Win^.Y1+TTxtBox^.TBVerScrBar^.VSBY1+1))+1;
               IF TracePointer <> TTxtBox^.TBVerScrBar^.VSBPointer Then
               Begin
                  TTxtBox^.TBVerScrBar^.VSBPointer:=TracePointer;
                  TTxtBox^.TBVerScrBar^.DefaultVerScrollBarColor;
               End;
             End;
          Until (MouseButton=MsIdle);

          AdjustTxtBox;

          SetMouseMinMaxX(1,80);
          SetMouseMinMaxY(1,25);
       End;
    End
    Else
    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TTxtBox:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TTxtBox Then
           Begin
             TTxtBox^.TBVerScrBar^.NormalVerScrollBarColor;
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

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and  (Ascii=#77)  )Then
    Begin
         TTxtBox^.TBVerScrBar^.NormalVerScrollBarColor;
         Event:=TTxtBox^.TBCommand;
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
         TTxtBox^.TBVerScrBar^.NormalVerScrollBarColor;
         Event:=TTxtBox^.TBCommand;
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
       IF TTxtBox^.TBCurText^.NextTextLine = Nil Then
          Exit;  {If we haven't any vertical scroller then exit}


       TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
       Inc(TTxtBox^.TBVisualYPosit);
       Inc(TTxtBox^.TBVirtualYPosit);

       {Scrolling Down Routine}

       Dec(TTxtBox^.TBVisualYPosit);
       YDif:=(TTxtBox^.TBY2-Byte(TTxtBox^.TBBox)) - (TTxtBox^.TBY1+Byte(TTxtBox^.TBBox))+1;
       TraceText:=TTxtBox^.TBCurText;
       TraceVY:=TTxtBox^.TBVisualYPosit;

       For I:=1 to YDif do
       Begin
           TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.PrevTextLine;
           Dec(TTxtBox^.TBVisualYPosit);
           WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
       End;


       TTxtBox^.TBCurText:=TraceText;
       TTxtBox^.TBVisualYPosit:=TraceVY;
       WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);

       CallVerScrollKBEvent;
       Event:=TTxtBox^.TBCommand;
       HandleCommand;
    End
    Else

    {Up Arrow}

    IF ((Ctrl=#0) and (Ascii=#72)) Then
    Begin
       IF TTxtBox^.TBVirtualYPosit-1 < TTxtBox^.TBBaseYPosit Then
          Exit;


       TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.PrevTextLine;
       Dec(TTxtBox^.TBVirtualYPosit);

       TraceText:=TTxtBox^.TBCurText;
       TraceVY:=TTxtBox^.TBVisualYPosit;
       TraceVirY:=TTxtBox^.TBVirtualYPosit;

       YDif:=(TTxtBox^.TBY2-Byte(TTxtBox^.TBBox)) - (TTxtBox^.TBY1+Byte(TTxtBox^.TBBox))+1;
       For I:=1 to YDif do
       Begin
          WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
          TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.PrevTextLine;
          Dec(TTxtBox^.TBVisualYPosit);
          Dec(TTxtBox^.TBVirtualYPosit);
       End;

       WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
       TTxtBox^.TBCurText:=TraceText;
       TTxtBox^.TBVisualYPosit:=TraceVY;
       TTxtBox^.TBVirtualYPosit:=TraceVirY;

       CallVerScrollKBEvent;
       Event:=TTxtBox^.TBCommand;
       HandleCommand;
    End
    Else

    {Page Down}
    IF ((Ctrl=#0) and (Ascii=#81)) and (TTxtBox^.TBVirtualYPosit < TTxtBox^.TBMaxLines) Then
    Begin
       YDif:=1;
       MaxVis:=(TTxtBox^.TBY2-Byte(TTxtBox^.TBBox))-(TTxtBox^.TBY1+Byte(TTxtBox^.TBBox))+1;
       I:=TTxtBox^.TBVirtualYPosit + YDif;
       IF I+MaxVis > TTxtBox^.TBMaxLines Then
       Begin
          I:=TTxtBox^.TBMaxLines-(MaxVis-1);
          IF I < 1 Then
             I:=1;
       End;

       TTxtBox^.TBVisualYPosit:=1;
       TTxtBox^.TBVirtualYPosit:=I;
       TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;

       IF I > 1 Then
          For J:=1 to I-1 do
              TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;

       For J:=1 to MaxVis do
       Begin
          WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
          IF J<>MaxVis Then
          Begin
            TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
            Inc(TTxtBox^.TBVisualYPosit);
            Inc(TTxtBox^.TBVirtualYPosit);
          End;
       End;


       TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=TTxtBox^.TBVirtualYPosit-TTxtBox^.TBBaseYPosit;
       TTxtBox^.TBVerScrBar^.AdjustVerScrollPointer;
       TTxtBox^.TBVerScrBar^.DefaultVerSCrollBarColor;


       CallVerScrollKBEvent;
       Event:=TTxtBox^.TBCommand;
       HandleCommand;
    End
    Else

    {Page Up}
    IF ((Ctrl=#0) and (Ascii=#73)) and (TTxtBox^.TBVirtualYPosit > TTxtBox^.TBBaseYPosit) Then
    Begin
       YDif:=1;
       MaxVis:=(TTxtBox^.TBY2-Byte(TTxtBox^.TBBox))-(TTxtBox^.TBY1+Byte(TTxtBox^.TBBox))+1;
       I:=TTxtBox^.TBVirtualYPosit - (MaxVis * 2) +1;
       IF I < 1 Then
          I:=1;

       TTxtBox^.TBVisualYPosit:=1;
       TTxtBox^.TBVirtualYPosit:=I;
       TTxtBox^.TBCurText:=TTxtBox^.TBHeadText;

       IF I > 1 Then
          For J:=1 to I-1 do
              TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;

       For J:=1 to MaxVis do
       Begin
          WriteTextStr(TTxtBox^.TBVisualYPosit-1,TTxtBox^.TBCurText^.TextLine^);
          IF J<>MaxVis Then
          Begin
            TTxtBox^.TBCurText:=TTxtBox^.TBCurText^.NextTextLine;
            Inc(TTxtBox^.TBVisualYPosit);
            Inc(TTxtBox^.TBVirtualYPosit);
          End;
       End;


       TTxtBox^.TBVerScrBar^.VSBVirtualYPosit:=(TTxtBox^.TBVirtualYPosit-TTxtBox^.TBBaseYPosit)+1;
       TTxtBox^.TBVerScrBar^.AdjustVerScrollPointer;
       TTxtBox^.TBVerScrBar^.DefaultVerSCrollBarColor;


       CallVerScrollKBEvent;
       Event:=TTxtBox^.TBCommand;
       HandleCommand;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsTxtBoxEvent;
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
           TTxtBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TTxtBox Then
           Begin
             TVerScrollBar:=TTxtBox^.TBVerScrBar;
             TTxtBox^.TBVerScrBar^.NormalVerScrollBarColor;
             Win^.CurMenusSeq:=Trace;
             {ActiveMenuBoxColor;}
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
       0:HandleKBTxtBoxEvent;
       1:HandleMsTxtBoxEvent;
   End;

End;


Begin


End.