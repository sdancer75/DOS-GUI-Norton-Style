{************************************************************************}
{Unit HelpObj                                                            }
{It contains all the necessary procedures and functions to implement an  }
{entire Help Link For Objects seperate units.                            }
{                                                                        }
{Copyright (c) 1993,96  By   George Papaioannou    Thessaloniki          }
{                                                                        }
{                                                                        }
{NOTE:THIS HELP SYSTEM DOESN'T PRINT THE CHARACTERS WITH CODES 123 AND 125 }
{MAX characters per line = 65                                            }
{************************************************************************}

UNIT HelpObj;

INTERFACE


Uses VarConstObj,TopicHlp,ErrorDlg;

Type

   PTopicHelpXY = ^TopicHelpXY;
   TopicHelpXY  = Record
       X,Y       :Byte;
       Topic     :String;
       Reference :Word;
       Active    :Boolean;
       Next      :PTopicHelpXY;
   End;


Const
  HelpData                 :Pointer  = Nil;    {Temporary storage}
  HeadHelpData             :PDynText = Nil;    {Head of text lines}
  TailHelpData             :PDynText = Nil;    {Tail of text lines}
  CurHelpData              :PDynText = Nil;    {Current text line}

  HeadTopicHelpXY          :PTopicHelpXY = Nil;  {Head of Topic}
  CurTopicHelpXY           :PTopicHelpXY = Nil;  {Current Topic}

  HelpNormBckColor         :Byte    = 5;
  HelpRevBckColor          :Byte    = 1;
  HelpNormTxtColor         :Byte    = 15;
  HelpRevTxtColor          :Byte    = 14;

  HelpWinX1                 :Byte    = 2;
  HelpWinX2                 :Byte    = 77;

  HelpBorderX1              :Byte    = 2;
  HelpBorderX2              :Byte    = 67;
  HelpBorderY1              :Byte    = 2;
  HelpBorderY2              :Byte    = 14;

  HelpCurX                  :Byte    = 2+1;
  HelpCurY                  :Byte    = 2+1;

  MaxHistories                       = 255;

  CurrentHelpHistory        :Integer = 0;

Var
   TopicSize    :Longint;  {Length of the current topic.Used in BlockRead}
   StartFilePos :LongInt;  {Real data without the header.}
   FileHlp      :File;
   HelpHistory  :Array [1..MaxHistories-1] Of Word;


Function  OpenHelpFile :Byte;
Function  UnCoded(TakeByte :Byte) :Char;
Procedure ConvertHelpData;
Function  FindTopic(TopicNum :Word) :Byte;
Procedure MakeHistory;
Procedure BackHistory;
Procedure DisposeTopicHelpXY;
Procedure DisposeHelp;

IMPLEMENTATION

{*********************** HELP ROUTINES ************************************}
{**************************************************************************}

Function OpenHelpFile :Byte;
Var
   OrdChar      :Byte;
   Er           :Integer;
Begin
    Assign(FileHlp,HelpFileName);
    Reset(FileHlp,1);
    IF IOResult<>0 Then
    Begin
      OpenHelpFile:=1;
      Exit;
    End;

    Repeat
       BlockRead(FileHlp,OrdChar,1,Er);
    Until OrdChar=$1A;

    StartFilePos:=FilePos(FileHlp);
    OpenHelpFile:=0;
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


          IF HeadHelpData = Nil Then
             HeadHelpData:=CurHelpData;

          TailHelpData^.NextTextLine:=CurHelpData;
          TailHelpData:=CurHelpData;
          TextLine:='';
        End;
    End;
End;


Function FindTopic(TopicNum :Word) :Byte;
Var
   TraceSeekNumber :LongInt;
   I               :Word;
   Er              :Integer;
Begin
      TraceSeekNumber:=StartFilePos;
      Seek(FileHlp,TraceSeekNumber);

      IF TopicNum > 0 Then
      Begin
        I:=0;
        Er:=4;
        While (I<TopicNum) and (Er=4) do
        Begin
           BlockRead(FileHlp,TopicSize,4,Er);
           TraceSeekNumber:=TraceSeekNumber+TopicSize;
           Seek(FileHlp,TraceSeekNumber);
           Inc(I);
        End;

        IF (I<>TopicNum) or (Er<>4) Then
        Begin
           FindTopic:=1;
           Exit;
        End;

        BlockRead(FileHlp,TopicSize,4,Er);
      End
      Else
           BlockRead(FileHlp,TopicSize,4,Er);

    IF Er<>4 Then
    Begin
        FindTopic:=1;
        Exit;
    End;

    TopicSize:=TopicSize-4;
    HelpData:=EdsGetMem(HelpData,TopicSize);
    IF HeapErrorCode = 1 Then
    Begin
       FindTopic:=1;
       Exit;
    End;
    BlockRead(FileHlp,HelpData^,TopicSize,Er);
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



Procedure MakeHistory;
Var
   I    :Word;
Begin
   Inc(CurrentHelpHistory);

   IF CurrentHelpHistory = MaxHistories Then
      For I:=1 to MaxHistories-2 do
          HelpHistory[I]:=HelpHistory[I+1];

   HelpHistory[CurrentHelpHistory]:=CurrentHelpPtr;
End;


Procedure BackHistory;
Begin
   IF CurrentHelpHistory > 0 Then
   Begin
      CurrentHelpPtr:=HelpHistory[CurrentHelpHistory];
      Dec(CurrentHelpHistory);
   End;
End;

Procedure DisposeTopicHelpXY;
Var
   TempTopicHelpXY        :PTopicHelpXY;
Begin
    CurTopicHelpXY:=HeadTopicHelpXY;

    IF CurTopicHelpXY = Nil Then
       Exit;

    Repeat
       TempTopicHelpXY:=CurTopicHelpXY;
       CurTopicHelpXY:=CurTopicHelpXY^.Next;
       Dispose(TempTopicHelpXY);
    Until CurTopicHelpXY = Nil;

    HeadTopicHelpXY  := Nil;  {Head of Topic}
    CurTopicHelpXY   := Nil;  {Current Topic}
End;

Procedure DisposeHelp;
Var
   TempHelpData :PDynText;
Begin

    DisposeTopicHelpXY;

    CurHelpData:=HeadHelpData;
    Repeat
       TempHelpData:=CurHelpData;
       CurHelpData:=CurHelpData^.NextTextLine;
       FreeMem(TempHelpData^.TextLine,Length(TempHelpData^.TextLine^)+1);
       Dispose(TempHelpData);
    Until CurHelpData = Nil;

   HelpData     :=Nil;    {Temporary storage}
   HeadHelpData :=Nil;    {Head of text lines}
   TailHelpData :=Nil;    {Tail of text lines}
   CurHelpData  :=Nil;    {Current text line}

   HeadTopicHelpXY :=Nil;  {Head of Topic}
   CurTopicHelpXY  :=Nil;  {Current Topic}

End;


Begin




End.
