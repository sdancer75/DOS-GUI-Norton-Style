{***********************************************************************}
{UNIT WinApplObj                                                        }
{FileName    :WinApplO.Pas                                              }
{èú®†úÆú† ®¶¨´†§ú™ ß¶¨ ò≠¶®¶¨§ ú£≠ò§†©û ò§´†°ú†£ú§‡§ £ú©ò ©ú ú§ò ûõû    }
{ò§¶†ö£ú§¶ ßò®òü¨®¶.                                                    }
{***********************************************************************}

UNIT WINAPPLOBJ;

INTERFACE

Uses Crt,GeneralObj,VarConstObj,WindowsObj,MouseObj;

Const
     DoubleLines  = 1;
     SingleLines  = 2;

Type
        ProgressBar = Object
           X1,    {Start X coordinate}
           Y1,    {Start Y coordinate}
           XLen,  {Length of the bar in characters}
           PercentageColor :Byte; {The TextColor of the Printable percentage - 100% -}
           FinalValue      :Word; {Max Value of the countable quantity}
           Step            :Real; {The progess step -- internal --}
           Carry           :Byte; {The remained quanity --internal --}
           FColor,BColor   :Byte; {The ForeGround and BackGround color}
           InternalCount   :Word; {InternalCount}
           PercX           :Byte; {X Coord of Percentage}
           PercStr         :String[4];
           DivPerc         :Real;

           Procedure InitProgressBar(InX1,InY1,InXLen,InPercentageColor :Byte;InFinalValue :Word);
           Procedure ReDrawProgressBar;
           Procedure UpDateProgressBar(Value:Word);
           Procedure FullProgressBar;
           Procedure FinishProgressBar(DelayValue :Word);
        End;



Procedure HorizontalLine(X1,Y1,X2,CharCode :Byte);
Procedure VerticalLine(X1,Y1,Y2,CharCode :Byte);
Procedure TextBox(X1,Y1,X2,Y2,X :Byte);
Procedure TextPaint(X1,Y1,X2,Y2,MiniShadow :Byte);
Procedure InfoBox(X1,Y1,X2,Y2 :Byte;InLabel :String;LabelTxtColor :Byte);
Procedure MakeInfoBar(X1,Y1,MTextColor,MTextBackGround :Byte);



IMPLEMENTATION


Procedure ProgressBar.InitProgressBar;
Begin
     X1:=InX1;
     Y1:=InY1;
     XLen:=InXLen;
     FColor:=WriteTextColor;
     BColor:=WriteTextBackGround;
     PercentageColor:=InPercentageColor;
     FinalValue:=InFinalValue;
     InternalCount:=0;
     PercX:=0;
     PercStr:='0%';
     DivPerc:=100 / FinalValue;
     ReDrawProgressBar;
End;

Procedure ProgressBar.ReDrawProgressBar;
Var
   XValue       :Word;
Begin
    TextPaint(X1,Y1,X1+XLen,Y1,0);
    XValue:=Trunc( (XLen-Length('0%')) / 2);
    PercX:=XValue;
    WriteTextColor:=PercentageColor;
    WriteWindow(X1+XValue,Y1,'0%');
    IF Xlen < FinalValue Then
    Begin
       Step:=FinalValue / Xlen;
       Carry:=FinalValue mod XLen;
    End
    Else
    Begin
        XValue:=Trunc(XLen / FinalValue);
        Step:=XValue;
        Carry:=XLen mod FinalValue;
    End;
End;

Procedure ProgressBar.UpDateProgressBar;
Var
   Trace        :Real;
   TraceB       :Word;
   Trace2       :Real;
   Ch           :String[1];
   I            :Byte;
Begin

     Inc(InternalCount,Value);
     IF XLen <= FinalValue Then
        Trace:=InternalCount / Step
     Else
        Trace:=InternalCount * Step;

     IF InternalCount >= FinalValue Then
        InternalCount:=FinalValue;


     {Wait of the final value to finish with it}
     IF InternalCount >= FinalValue Then
     Begin
         FullProgressBar;
         Exit;
     End
     Else
     {IF we have finished with the hard word}
     {Then wait for The final value to finish this job}
     IF (Round(Trace)  >= Xlen) Then
        Exit;

    {Draw the bar}
    IF (Int(Trace) > 0)  Then
    Begin
      HiddenMouseCursor;
      For I:=X1 to X1+(Trunc(Trace)-1) do
          WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,BColor,FColor,32);
      ShowMouseCursor;
    End;

    {Print the percentage}
    WriteTextColor:=PercentageColor;

    TraceB:=Trunc(DivPerc * InternalCount);

    IF TraceB >= 100 Then
       Exit;

    Str(TraceB,PercStr);
    PercStr:=PercStr+'%';

    For I:=1 to Length(PercStr) do
    Begin
        ch:=Copy(PercStr,I,1);
        IF X1+PercX+(I-1) <= X1+(Int(Trace)-1) Then
           WriteTextBackGround:=FColor
        Else
           WriteTextBackGround:=BColor;

        WriteWindow(X1+PercX+(I-1),Y1,ch);
    End;
End;

{**************************************************************}
{Procedure FullProgressBar                                     }
{Just Fill it with 100%                                        }
{**************************************************************}

Procedure ProgressBar.FullProgressBar;
Var
   I    :Byte;
Begin
    HiddenMouseCursor;
    For I:=X1 to X1+XLen do
        WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,BColor,FColor,32);
    ShowMouseCursor;

    WriteTextColor:=PercentageColor;
    WriteTextBackGround:=FColor;
    WriteWindow(X1+PercX,Y1,'100%');
    Carry:=0;
End;

Procedure ProgressBar.FinishProgressBar;
Var
   Trace        :Real;
   TraceB       :Word;
   Ch           :String[1];
   I,J          :Byte;
Begin
     For J:=FinalValue Downto 1 do
     Begin
         Inc(InternalCount,1);
         Trace:=InternalCount / Step;

         {IF we have a carry and we have finished with the hard word}
         {just fill all bar and print the 100% at the center}
         IF (Int(Trace) >= Xlen) Then
         Begin
            HiddenMouseCursor;
            For I:=X1 to X1+Trunc(Trace) do
                WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,BColor,FColor,32);
            ShowMouseCursor;

            WriteTextColor:=PercentageColor;
            WriteWindow(X1+PercX,Y1,'100%');
            Carry:=0;
            Exit;
         End;

        {Draw the bar}
        IF (Int(Trace) > 0)  Then
        Begin
          HiddenMouseCursor;
          For I:=X1 to X1+(Trunc(Trace)-1) do
              WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,BColor,FColor,32);
          ShowMouseCursor;
        End;

        {Print the percentage}
        WriteTextColor:=PercentageColor;

        TraceB:=Trunc(DivPerc * InternalCount);
        Str(TraceB,PercStr);
        PercStr:=PercStr+'%';

        For I:=1 to Length(PercStr) do
        Begin
           ch:=Copy(PercStr,I,1);
           IF X1+PercX+(I-1) <= X1+(Int(Trace)-1) Then
             WriteTextBackGround:=FColor
           Else
             WriteTextBackGround:=BColor;

             WriteWindow(X1+PercX+(I-1),Y1,ch);
        End;

        RetraceDelay(DelayValue);
     End;

     FullProgressBar;
End;

Procedure HorizontalLine(X1,Y1,X2,CharCode :Byte);
Var
   I    :Byte;
Begin
    HiddenMouseCursor;
    For I:=X1 to X2 do
        WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,CharCode);
    ShowMouseCursor;
End;

Procedure VerticalLine(X1,Y1,Y2,CharCode :Byte);
Var
   I    :Byte;
Begin
    HiddenMouseCursor;
    For I:=Y1 to Y2 do
        WriteVirtWinChar(Win^.X1+X1,Win^.Y1+I,WriteTextColor,WriteTextBackGround,CharCode);
    ShowMouseCursor;
End;


Procedure TextBox(X1,Y1,X2,Y2,X :Byte);
Var
    UpHor,DnHor,LfVer,RgVer     :Byte;
    DnRgCorner,DnLfCorner       :Byte;
    UpRgCorner,UpLfCorner       :Byte;
    I                           :Byte;
Begin
     IF VgaExist Then
     Begin
         Case X of
           DoubleLines:Begin
                        UpHor:=WCUpHorLine;DnHor:=WCDnHorLine;
                        LfVer:=WCLfVerLine;RgVer:=WCRgVerLine;
                        DnRgCorner:=WCDnRgCorner;DnLfCorner:=WCDnLfCorner;
                        UpRgCorner:=WCUpRgCorner;UpLfCorner:=WCUpLfCorner;
                       End;
           SingleLines:Begin
                        UpHor:=WCUpHorLineS;DnHor:=WCDnHorLineS;
                        LfVer:=WCLfVerLineS;RgVer:=WCRgVerLineS;
                        DnRgCorner:=WCDnRgCornerS;DnLfCorner:=WCDnLfCornerS;
                        UpRgCorner:=WCUpRgCornerS;UpLfCorner:=WCUpLfCornerS;
                       End;
         End;


     End
     Else
     Begin
        UpHor:=SCUpHorLine;DnHor:=SCDnHorLine;
        LfVer:=SCLfVerLine;RgVer:=SCRgVerLine;
        DnRgCorner:=SCDnRgCorner;DnLfCorner:=SCDnLfCorner;
        UpRgCorner:=SCUpRgCorner;UpLfCorner:=SCUpLfCorner;
     End;

     HiddenMouseCursor;

     For I:=(Win^.X1+X1)+1 to (Win^.X1+X2)-1 do
     Begin
        WriteVirtWinChar(I,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,UpHor);
        WriteVirtWinChar(I,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,DnHor);
     End;


     For I:=(Win^.Y1+Y1)+1 to (Win^.Y1+Y2)-1 do
     Begin
        WriteVirtWinChar(Win^.X1+X1,I,WriteTextColor,WriteTextBackGround,LfVer);
        WriteVirtWinChar(Win^.X1+X2,I,WriteTextColor,WriteTextBackGround,RgVer);
     End;

     WriteVirtWinChar(Win^.X1+X1,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,UpLfCorner);
     WriteVirtWinChar(Win^.X1+X2,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,UpRgCorner);
     WriteVirtWinChar(Win^.X1+X1,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,DnLfCorner);
     WriteVirtWinChar(Win^.X1+X2,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,DnRgCorner);

     ShowMouseCursor;

End;

Procedure TextPaint(X1,Y1,X2,Y2,MiniShadow :Byte);
Var
   I,J  :Byte;
Begin
    HiddenMouseCursor;

    For I:=Y1 to Y2 do
      For J:=X1 to X2 do
        WriteVirtWinChar(Win^.X1+J,Win^.Y1+I,WriteTextColor,WriteTextBackGround,32);

    IF (MiniShadow and Shadow) = Shadow Then
    Begin
        For I:=Y1+1 to Y2 do
          WriteVirtWinChar(Win^.X1+X2+1,Win^.Y1+I,0,0,32);

        For I:=X1+1 to X2+1 do
          WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y2+1,0,Win^.WTextBackGround,223);
    End;

    ShowMouseCursor;

End;


Procedure InfoBox(X1,Y1,X2,Y2 :Byte;InLabel :String;LabelTxtColor :Byte);
Var
   I    :Byte;
Begin
     HiddenMouseCursor;
     For I:=Y1 to Y2 do
     Begin
         WriteVirtWinChar(Win^.X1+X1,Win^.Y1+I,WriteTextColor,WriteTextBackGround,SCLfVerLine);
         WriteVirtWinChar(Win^.X1+X2,Win^.Y1+I,WriteTextColor,WriteTextBackGround,SCLfVerLine);
     End;

     For I:=X1+1+Length(InLabel) to X2-1 do
         WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,SCUpHorLine);

     For I:=X1+1 to X2-1 do
         WriteVirtWinChar(Win^.X1+I,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,SCUpHorLine);

     WriteVirtWinChar(Win^.X1+X1,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,SCUpLfCorner);
     WriteVirtWinChar(Win^.X1+X2,Win^.Y1+Y1,WriteTextColor,WriteTextBackGround,SCUpRgCorner);
     WriteVirtWinChar(Win^.X1+X1,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,SCDnLfCorner);
     WriteVirtWinChar(Win^.X1+X2,Win^.Y1+Y2,WriteTextColor,WriteTextBackGround,SCDnRgCorner);

     WriteTextColor:=LabelTxtColor;
     WriteVirtWinOut(Win^.X1+X1+1,Win^.Y1+Y1,InLabel);
     ShowMouseCursor;

End;

Procedure MakeInfoBar(X1,Y1,MTextColor,MTextBackGround :Byte);
Var
   I            :Byte;
Begin
    HiddenMouseCursor;
    For I:=X1 to (BiosColumns shr 1) do
        WriteChar(I,Y1,MTextColor,MTextBackGround,32);
    ShowMouseCursor;
End;


END.