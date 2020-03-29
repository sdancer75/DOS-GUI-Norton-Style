Uses Crt,GeneralObj;
type
   Str80    = String[80];

   PDynText = ^DynText;
   DynText  = Record
       TextLine        :^Str80;
       TLineColor,
       TLineBackGround :Byte;
       NextTextLine    :PDynText;
       PrevTextLine    :PDynText;
   End;

   PTopicHelpXY = ^TopicHelpXY;
   TopicHelpXY  = Record
       X,Y       :Byte;
       Topic     :String;
       Reference :Word;
       Active    :Boolean;
       Next      :PTopicHelpXY;
   End;

Var
   FileHlp      :File;
   Er           :Integer;

   TopicSize    :Longint;
   StartFilePos :LongInt;
Const
   HelpData                 :Pointer  = Nil;
   HeadHelpData             :PDynText = Nil;
   TailHelpData             :PDynText = Nil;
   CurHelpData              :PDynText = Nil;

   HeadTopicHelpXY          :PTopicHelpXY = Nil;
   CurTopicHelpXY           :PTopicHelpXY = Nil;

   HelpNormBckColor         :Byte    = 4;
   HelpRevBckColor          :Byte    = 1;
   HelpNormTxtColor         :Byte    = 15;
   HelpRevTxtColor          :Byte    = 14;

Var
   HelpX1,HelpX2,HelpY1,
   HelpY2                   :Byte;
   InternY,InternX          :Byte;



Procedure HelpWindow(X1,Y1,X2,Y2 :Byte);
Var
   J    :Byte;
Begin
     TextColor(15);
     For J:=X1 to X2 do
     Begin
         Gotoxy(J,Y1);Write('Í');
         Gotoxy(J,Y2);Write('Í');
     End;


     For J:=Y1 to Y2 do
     Begin
         Gotoxy(X1,j);Write('º');
         Gotoxy(X2,j);Write('º');
     End;

     Gotoxy(X1,Y1);Write('É');
     Gotoxy(X2,Y1);Write('»');
     Gotoxy(X1,Y2);Write('È');
     Gotoxy(X2,Y2);Write('¼');

     HelpX1:=X1;HelpY1:=Y1;
     HelpX2:=X2;HelpY2:=Y2;
     InternY:=HelpY1+1;

End;


Procedure OpenFile;
Var
   OrdChar      :Byte;
Begin
    Assign(FileHlp,'C:\bp7\myobj\help\george.hlp');
{$I-}
    Reset(FileHlp,1); {$I+}
    IF IOResult<>0 Then
    Begin
        Writeln('I can''t open the given file');
        Halt(1);
    End;

    Repeat
       BlockRead(FileHlp,OrdChar,1,Er);
    Until OrdChar=$1A;

    StartFilePos:=FilePos(FileHlp);

End;

Function UnCoded(TakeByte :Byte) :Char;
Begin
   TakeByte:=Not(TakeByte+10);
   UnCoded:=Chr(TakeByte);
End;

Procedure ConvertHelpData;
Var
   TextLine           :String;
   HelpSeg,HelpOfs    :Word;
   MyChar             :Char;
   I,StartPoint       :Word;

Begin
    IF HelpData = Nil Then
       Exit;

    HelpSeg:=Seg(HelpData^);
    HelpOfs:=Ofs(HelpData^);


    {Trought out the header such :".2"}
    StartPoint:=0;
    Repeat
       MyChar:=UnCoded(Mem[HelpSeg:HelpOfs+StartPoint]);
       Inc(StartPoint);
    Until MyChar=#10;


    TextLine:='';
    For I:=StartPoint To TopicSize-1 do
    Begin
        MyChar:=UnCoded(Mem[HelpSeg:HelpOfs+I]);
        TextLine:=TextLine+MyChar;
        IF MyChar=#10 Then
        Begin
          New(CurHelpData);
          GetMem(CurHelpData^.TextLine,Length(TextLine)+1);
          CurHelpData^.TextLine^:=TextLine;
          CurHelpData^.TLineColor:=HelpNormTxtColor;
          CurHelpData^.TLineBackGround:=HelpNormBckColor;

          CurHelpData^.NextTextLine:=Nil;
          CurHelpData^.PrevTextLine:=TailHelpData;
          TailHelpData^.NextTextLine:=CurHelpData;

          IF HeadHelpData = Nil Then
             HeadHelpData:=CurHelpData;

          TailHelpData:=CurHelpData;

          TextLine:='';
        End;
    End;




End;


Function FindTopic(TopicNum :Word) :Byte;
Var
   TraceSeekNumber :LongInt;
   I               :Word;
Begin
    TraceSeekNumber:=StartFilePos;
{$I-}
      IF TopicNum > 0 Then
      Begin
        For I:=1 to TopicNum do
        Begin
           BlockRead(FileHlp,TopicSize,4,Er);
           TraceSeekNumber:=TraceSeekNumber+TopicSize;
           Seek(FileHlp,TraceSeekNumber);
        End;
        BlockRead(FileHlp,TopicSize,4,Er);
      End
      Else
           BlockRead(FileHlp,TopicSize,4,Er);

    TopicSize:=TopicSize-4;
    GetMem(HelpData,TopicSize);
    BlockRead(FileHlp,HelpData^,TopicSize,Er);
{$I+}
    IF Er <> TopicSize Then
    Begin
       FindTopic:=1;
       FreeMem(HelpData,TopicSize);
       Exit;
    End;

    ConvertHelpData;

    FreeMem(HelpData,TopicSize);

    FindTopic:=0;
End;

Procedure WriteHelpStr(Str :String);
Var
   InternX,InternTextColor,InternBackGround               :Byte;
   I                                                      :Byte;
   MyChar                                                 :String[1];
   NonPrintable                                           :Boolean;
   FoundTopic,NewTopic                                    :Boolean;
   StrReference,StrTopic                                  :String;

Begin
    InternX:=HelpX1+1;
    InternTextColor:=HelpNormTxtColor;
    InternBackGround:=HelpNormBckColor;
    NonPrintable:=False;
    StrReference:='';
    StrTopic:='';
    NewTopic:=False;
    FoundTopic:=False;

    For I:=1 to Length(Str) do
    Begin
        MyChar:=Copy(Str,I,1);
        Case MyChar[1] of
        '{' :Begin
                 FoundTopic:=True;
                 NewTopic:=True;
                 InternTextColor:=HelpRevTxtColor;
                 InternBackGround:=HelpNormBckColor;
                 New(CurTopicHelpXY);
                 CurTopicHelpXY^.Next:=HeadTopicHelpXY;
                 HeadTopicHelpXY:=CurTopicHelpXY;

                 CurTopicHelpXY^.X:=InternX;
                 CurTopicHelpXY^.Y:=InternY;
             End;
        ':' :Begin
                 NonPrintable:=True;
                 NewTopic:=False;
             End;
        '}' :Begin
                 InternTextColor:=HelpNormTxtColor;
                 InternBackGround:=HelpNormBckColor;
                 NonPrintable:=False;
                 NewTopic:=False;
             End;
        #13 :;
        #10 :Inc(InternY);
             Else
             Begin
                IF (NonPrintable=False) and (InternX > HelpX1) and (InternX < HelpX2) and
                          (InternY > HelpY1) and (InternY < HelpY2) Then
                Begin
                   WriteChar(InternX,InternY,InternTextColor,InternBackGround,ord(MyChar[1]));
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
        End;
    End; {FOR}

    IF FoundTopic Then
    Begin
         CurTopicHelpXY^.Topic:=StrTopic;
         CurTopicHelpXY^.Active:=False;
         Val(StrReference,CurTopicHelpXY^.Reference,Er);
    End;

End;

Procedure CheckTopic;
Var
   Found              :Boolean;
   TempTopicHelpXY    :PTopicHelpXY;
Begin
    IF CurTopicHelpXY <> Nil Then
      IF (InternX >= CurTopicHelpXY^.X) and (InternX < (CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)))
         and (InternY = CurTopicHelpXY^.Y) and (CurTopicHelpXY^.Active=True) Then
              Exit;

     Found:=False;
     TempTopicHelpXY:=HeadTopicHelpXY;
     Repeat
          IF TempTopicHelpXY <> Nil Then
          Begin
             IF (InternX >= TempTopicHelpXY^.X) and (InternX < (TempTopicHelpXY^.X+Length(TempTopicHelpXY^.Topic)))
                and (InternY = TempTopicHelpXY^.Y) Then
             Begin
                 WriteTextColor:=HelpRevTxtColor;
                 WriteTextBackGround:=HelpRevBckColor;
                 WriteOut(TempTopicHelpXY^.X,TempTopicHelpXY^.Y,TempTopicHelpXY^.Topic);
                 TempTopicHelpXY^.Active:=True;
                 Found:=True;

                 IF (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil) Then
                 Begin
                    CurTopicHelpXY^.Active:=False;
                    WriteTextColor:=HelpRevTxtColor;
                    WriteTextBackGround:=HelpNormBckColor;
                    WriteOut(CurTopicHelpXY^.X,CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);
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
          WriteOut(CurTopicHelpXY^.X,CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);
          CurTopicHelpXY^.Active:=False;
          CurTopicHelpXY:=Nil;
       End;
     End;
End;

Procedure EditMode;
Begin
{    Writeln;
    CurTopicHelpXY:=HeadTopicHelpXY;
    Repeat
       IF CurTopicHelpXY<> Nil Then
       Begin
          Writeln(CurTopicHelpXY^.Topic,' ',CurTopicHelpXY^.Reference);
          CurTopicHelpXY:=CurTopicHelpXY^.Next;
       End;

    Until CurTopicHelpXY=NIl;}


    SetCurPositionXY(HelpX1,HelpY1);
    InternX:=HelpX1;InternY:=HelpY1;

    Repeat
         ReadKbd(Ctrl,Ascii);

         IF (Ctrl=#0) and (Ascii=Chr(KbArrowLeft)) and (InternX > HelpX1) Then
         Begin
             Dec(InternX);
             SetCurPositionXY(InternX-1,InternY-1);
             CheckTopic;
         End
         Else
         IF (Ctrl=#0) and (Ascii=Chr(KbArrowRight)) and (InternX <  HelpX2-2) Then
         Begin
             Inc(InternX);
             SetCurPositionXY(InternX-1,InternY-1);
             CheckTopic;
         End
         Else
         IF (Ctrl=#0) and (Ascii=Chr(KbArrowUp)) and (InternY > HelpY1) Then
         Begin
             Dec(InternY);
             SetCurPositionXY(InternX-1,InternY-1);
             CheckTopic;
         End
         Else
         IF (Ctrl=#0) and (Ascii=Chr(KbArrowDown)) and (InternY <  HelpY2-2) Then
         Begin
             Inc(InternY);
             SetCurPositionXY(InternX-1,InternY-1);
             CheckTopic;
         End

    Until Ctrl=#27;
End;

Procedure DisposeHelp;
Var
   TempHelpData :PDynText;
Begin
    CurHelpData:=HeadHelpData;
    Repeat
       TempHelpData:=CurHelpData;
       CurHelpData:=CurHelpData^.NextTextLine;
       FreeMem(TempHelpData^.TextLine,Length(TempHelpData^.TextLine^)+1);
       Dispose(TempHelpData);
    Until CurHelpData = Nil;
End;

Procedure ShowHelpData;
Var
   I                  :Word;
   HelpSeg,HelpOfs    :Word;
   MyChar             :Char;
Begin
    IF HelpData = Nil Then
    Begin
       Gotoxy(1,1);Write('An error was occured.I can''t find my help in memory');
       Exit;
    End;


    CurHelpData:=HeadHelpData;
    Repeat
       WriteHelpStr(CurHelpData^.TextLine^);
       CurHelpData:=CurHelpData^.NextTextLine;
    Until CurHelpData = Nil;

    CurTopicHelpXY:=Nil;

    EditMode;

    DisposeHelp;


End;


Procedure CloseFile;
Begin
    Close(FileHlp);
End;

Var
   Result :Byte;

Begin
    TextBackGround(HelpNormBckColor);
    Clrscr;
    OpenFile;
    HelpWindow(2,1,70,20);
    Result:=FindTopic(2);
    IF Result <> 0 Then
    Begin
        Writeln('I cant find the topic');
        CloseFile;
        Halt(0);
    End;
    ShowHelpData;
    CloseFile;
End.