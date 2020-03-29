Uses Crt;
Const
   SectionNumber :String[5] = '';
   HeaderSize    = 50;

Type
   HelpRec      = Record
      StrLine   :String;
   End;

Var
   FileHlp      :File of HelpRec;
   ReadedBytes  :HelpRec;
   UnCodedLine  :String;

Procedure OpenFile;
Begin
    Assign(FileHlp,'C:\tp7\MyHelp\George.hlp');
{$I-}
    Reset(FileHlp); {$I+}
    IF IOResult<>0 Then
    Begin
        Writeln('I can''t open the given file');
        Halt(1);
    End;

End;

Procedure UnCode;
Var
   TestB   :Byte;
   TakeByte:String[1];
   I                  :Byte;
Begin
   For I:=1 to Length(ReadedBytes.StrLine) do
   Begin
     TakeByte:=Copy(ReadedBytes.StrLine,i,1);
{     TakeByte[1]:=Chr( Not(Ord(TakeByte[1])+10) );}
     UnCodedLine:=UnCodedLine+TakeByte[1];
   End;
End;
{
Procedure PrintSection(FileSeek :LongInt);
Begin
     Seek(FileHlp,FileSeek);
     Repeat
         Read(FileHlp,ReadedBytes);
         IF ReadedBytes <> 0 Then
            Write(UnCode(ReadedBytes));
     Until (Eof(FileHlp)) Or (ReadedBytes = 0);

End;
}

Procedure UnCodeReadedBytes;Assembler;
Asm;
    mov si,Offset ReadedBytes.StrLine
    mov di,Offset UnCodedLine
    xor cx,cx
    mov cl,[si]
    inc si
    inc di
@Lo1:
    mov al,[si]
    add al,10
    not al
    mov [di],al
    inc si
    inc di
    loop @lo1
End;

Procedure Find(Number :Word);
Var
   Err                   :Integer;
   FileSeek              :LongInt;
   SectionRealNum        :Word;
   EndOfSecNum           :Boolean;

Begin
    Clrscr;

    FileSeek:=0;

    Read(FileHlp,ReadedBytes);
    Writeln(ReadedBytes.StrLine);

    Repeat
{$I-}
       Read(FileHlp,ReadedBytes); {$I+}
       Err:=IOResult;

       UnCodedLine:='';
       UnCode;
       Writeln(UnCodedLine);

    Until (Eof(FileHlp));
{
       IF  UnCode(ReadedBytes) = '.' Then
       Begin
           EndOfSecNum:=False;
           While (Not Eof(FileHlp)) And (EndOfSecNum=False) do
           Begin
              Read(FileHlp,ReadedBytes);
              IF (UnCode(ReadedBytes) >= '0') And (UnCode(ReadedBytes) <= '9') Then
                 SectionNumber:=SectionNumber+UnCode(ReadedBytes)
              Else
                EndOfSecNum:=True;
           End;

           Val(SectionNumber,SectionRealNum,Err);

           IF SectionRealNum = Number Then
              FileSeek:=FilePos(FileHlp)-1
           Else
              SectionNumber:='';
       End;}

{    PrintSection(FileSeek);}

End;

Procedure CloseFile;
Begin
    Close(FileHlp);
End;

Begin
    OpenFile;
    Find(1);
    CloseFile;
End.