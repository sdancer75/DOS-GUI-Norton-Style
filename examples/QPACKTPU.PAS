UNIT QPackTpu;


INTERFACE

Const
     Sign  :String = 'QPack ver 1.00a   by   Shadow Dancer';

Type
   FilesStruc = Record
      Sign        :Array [1..50] of char;
      TotalFiles  :Word;
      HeadOffset  :LongInt;
   End;

   HFileName = Record
      Name        :Array [1..12] of char;
      Size        :LongInt;
      NextFile    :LongInt;
   End;

Function GetFileSize(FileName :String) :LongInt;
Function QBlockRead(FileName :String;Var Buf :Pointer;Count :Word;var Result :Word;FilePosition :LongInt) :Byte;
Function QBlockReadNext(FilePosition :LongInt;Var Buf :Pointer;Count :Word;var Result :Word) :Byte;

IMPLEMENTATION

Function GetRealStr (A :String) :String;
Var
   S    :String;
   I    :Byte;
   SChar:String[1];
Begin
    S:='';
    For I:=1 to Length(A) do
    Begin
       SChar:=Copy(A,I,1);
       IF SChar[1] <> ' ' Then
          S:=S+SChar[1];
    End;

    GetRealStr:=S;
End;

{*********************************************************************}
Function GetFileSize(FileName :String) :LongInt;
Var
   Head         :FilesStruc;
   FHead        :HFileName;
   ReadedBytes  :Word;
   F            :File;
   Fs           :LongInt;
   S            :String;
   Found        :Boolean;
   I            :Byte;
   SChar        :String[1];

Begin
    For I:=1 to Length(FileName) Do
        FileName[I]:=UpCase(FileName[I]);

    S:=ParamStr(0);
    Assign(F,ParamStr(0));
{$I-}
    Reset (F,1);
{$I+}
    IF IOResult <> 0 Then
    Begin
       GetFileSize:=0;
       Exit;
    End;

    FS:=FileSize(F);
    FS:=FS-SizeOf(Head);
{$I-}
    Seek(F,FS);
{$I+}
    IF IOResult <> 0 Then
    Begin
       GetFileSize:=0;
       Close(F);
       Exit;
    End;
{$I-}
    BlockRead(F,Head,SizeOf(Head),ReadedBytes);
{$I+}
    IF IOResult <> 0 Then
    Begin
       GetFileSize:=0;
       Close(F);
       Exit;
    End;

    For I:=1 to Length(Sign) do
    Begin
        SChar:=Copy(Sign,I,1);
        IF SChar[1] <> Head.Sign[I] Then
        Begin
           GetFileSize:=0;
           Close(F);
           Exit;
        End
    End;

{$I-}
    Seek(F,Head.HeadOffset);
{$I+}

    IF IOResult <> 0 Then
    Begin
       GetFileSize:=0;
       Close(F);
       Exit;
    End;

    Found:=False;
    Repeat
{$I-}
       BlockRead(F,FHead,Sizeof(FHead),ReadedBytes);
{$I+}
       IF IOResult <> 0 Then
       Begin
          GetFileSize:=0;
          Close(F);
          Exit;
       End;

       IF (GetRealStr(FHead.Name) <> FileName) and (FHead.NextFile <> 0) Then
       Begin
{$I-}
          Seek(F,FHead.NextFile);
{$I+}
          IF IOResult <> 0 Then
          Begin
             GetFileSize:=0;
             Close(F);
             Exit;
          End;
       End
       Else
       IF (GetRealStr(FHead.Name) <> FileName) and (FHead.NextFile = 0) Then
       Begin
          GetFileSize:=0;
          Close(F);
          Exit;
       End
       Else
       IF (GetRealStr(FHead.Name) = FileName) Then
          Found:=True;
    Until (Found=True);

    Close(F);

    GetFileSize:=FHead.Size;

End;

{*****************************************************************************}
Function QBlockRead(FileName :String;Var Buf :Pointer;Count :Word;var Result :Word;FilePosition :LongInt) :Byte;
Var
   Head         :FilesStruc;
   FHead        :HFileName;
   ReadedBytes  :Word;
   F            :File;
   Fs           :LongInt;
   S            :String;
   Found        :Boolean;
   I            :Byte;
   SChar        :String[1];

Begin
    For I:=1 to Length(FileName) Do
        FileName[I]:=UpCase(FileName[I]);

    Assign(F,ParamStr(0));
{$I-}
    Reset (F,1);
{$I+}
    IF IOResult <> 0 Then
    Begin
       QBlockRead:=1;
       Exit;
    End;

    FS:=FileSize(F);
    FS:=FS-SizeOf(Head);
{$I-}
    Seek(F,FS);
{$I+}
    IF IOResult <> 0 Then
    Begin
       QBlockRead:=1;
       Close(F);
       Exit;
    End;
{$I-}
    BlockRead(F,Head,SizeOf(Head),ReadedBytes);
{$I+}

    IF IOResult <> 0 Then
    Begin
       QBlockRead:=1;
       Close(F);
       Exit;
    End;

    For I:=1 to Length(Sign) do
    Begin
        SChar:=Copy(Sign,I,1);
        IF SChar[1] <> Head.Sign[I] Then
        Begin
           QBlockRead:=2;
           Close(F);
           Exit;
        End
    End;

{$I-}
    Seek(F,Head.HeadOffset);
{$I+}

    IF IOResult <> 0 Then
    Begin
       QBlockRead:=1;
       Close(F);
       Exit;
    End;

    Found:=False;
    Repeat
{$I-}
       BlockRead(F,FHead,Sizeof(FHead),ReadedBytes);
{$I+}
       IF IOResult <> 0 Then
       Begin
          QBlockRead:=1;
          Close(F);
          Exit;
       End;

       IF (GetRealStr(FHead.Name) <> FileName) and (FHead.NextFile <> 0) Then
       Begin
{$I-}
          Seek(F,FHead.NextFile);
{$I+}
          IF IOResult <> 0 Then
          Begin
             QBlockRead:=1;
             Close(F);
             Exit;
          End;
       End
       Else
       IF (GetRealStr(FHead.Name) <> FileName) and (FHead.NextFile = 0) Then
       Begin
          QBlockRead:=2;
          Close(F);
          Exit;
       End
       Else
       IF (GetRealStr(FHead.Name) = FileName) Then
          Found:=True;
    Until (Found=True);

    {We found the file.Now load the data}


{$I-}
    BlockRead(F,Buf^,Count,Result);
{$I+}

   IF IOResult <> 0 Then
   Begin
      QBlockRead:=3;
      Close(F);
      Exit;
   End;

  Close(F);
  QBlockRead:=0;
End;

{*****************************************************************************}
Function QBlockReadNext(FilePosition :LongInt;Var Buf :Pointer;Count :Word;var Result :Word) :Byte;
Var
   Head         :FilesStruc;
   FHead        :HFileName;
   ReadedBytes  :Word;
   F            :File;
   Fs           :LongInt;
   S            :String;
   Found        :Boolean;
   I            :Byte;
   SChar        :String[1];

Begin
    Assign(F,ParamStr(0));
{$I-}
    Reset (F,1);
{$I+}
    IF IOResult <> 0 Then
    Begin
       QBlockReadNext:=1;
       Exit;
    End;

    FS:=FileSize(F);
    FS:=FS-SizeOf(Head);
{$I-}
    Seek(F,FS);
{$I+}
    IF IOResult <> 0 Then
    Begin
       QBlockReadNext:=2;
       Close(F);
       Exit;
    End;
{$I-}
    BlockRead(F,Head,SizeOf(Head),ReadedBytes);
{$I+}

    IF IOResult <> 0 Then
    Begin
       QBlockReadNext:=2;
       Close(F);
       Exit;
    End;

    For I:=1 to Length(Sign) do
    Begin
        SChar:=Copy(Sign,I,1);
        IF SChar[1] <> Head.Sign[I] Then
        Begin
           QBlockReadNext:=3;
           Close(F);
           Exit;
        End
    End;


{$F-}
    Seek(F,FilePosition);
{$F+}

   IF IOResult <> 0 Then
   Begin
      QBlockReadNext:=4;
      Close(F);
      Exit;
   End;


    {We found the file.Now load the data}

{$I-}
    BlockRead(F,Buf^,Count,Result);
{$I+}

   IF IOResult <> 0 Then
   Begin
      QBlockReadNext:=3;
      Close(F);
      Exit;
   End;

  Close(F);
  QBlockReadNext:=0;
End;

Begin

End.