{***************************************************************************}
{                           HELP COMPILER  ver 3.00                         }
{                                                                           }
{’¦ §¨¦š¨˜££˜ ˜¬«¦ › ˜™˜œ  œ¤˜ text ˜¨®œ ¦ ¡˜  ›ž£ ¦¬¨šœ  œ¤˜ ˜¨®œ ¦ *.Hlp }
{„§ ©žª ›ž£ ¦¬¨šœ  ¡˜  œ¤˜ ˜¨®œ ¦ *.pas «¦ ¦§¦ ¦ œ ¤˜  Unit ¡˜  Ÿ˜ §¨œ§œ  ¤˜}
{š ¤œ  compile ¡˜  ¤˜ œ¤©à£˜«àŸœ  £œ «¦ ™˜© ¡¦ ˜¨®œ ¦.                      }
{                                                                           }
{  Input  :€>HelpComp <FileName>                                            }
{  Output :FileName.Hlp,FileName.Pas                                        }
{                                                                           }
{ For Turbo Pascal 7.0 compiler                                             }
{                                                                           }
{George Papaioannou Thessaloniki 1993.                                      }
{***************************************************************************}

Uses Crt;
Const
        HelpHeader = 'Digital Toolworks help file (c) Thessaloniki 1994'+#13+#$1A;
Type
        BString         = Array [1..255] of Char;
        Str20           = String[20];

Var
   TextFile,TextFilePas             :Text;
   TextFileHlp                      :File;
   LineLimit                        :String;
   FileName,FileNamePas,FileNameHlp :String[12];
   Er                               :Integer;

   TopicSize                        :LongInt;
   TopicSizeArray                   :Array [1..1000] of LongInt;
   MaxTopics                        :Word;
   CurFilePos                       :LongInt;

   Labels                           :Array [0..2000] of Str20;
   LabelCount                       :Word;
   LineCounter                      :Word;
   YRow                             :Byte;


Procedure ConvertString(Str :String;Var BtypeString :BString);
Var
   I    :Byte;
   Str1 :String[1];
Begin
    For I:=1 to Length(Str) do
    Begin
       Str1:=Copy(Str,I,1);
       BTypeString[I]:=Str1[1];
    End;

    Inc(I);
    BTypeString[I]:='$';

End;

Function LengthBString(Str :BString) :Byte;
Var
   I    :Byte;
Begin
    I:=1;
    Repeat
       IF Str[I] <> '$' Then
          Inc(I);
    Until Str[I]='$';

    Dec(I);
    LengthBString:=I;
End;


Procedure InitMessages;
Begin
    TextColor(15);
    TextBackground(4);
    Writeln('HELP COMPILER ver 3.00            Copyright (c) 1994,96 By George Papaioannou  ');
    Writeln('-------------------------------------------------------------------------------');
    TextBackGround(0);
    TextColor(7);
    Writeln;

End;

Procedure PrintErrorMessage1;
Begin

     Writeln('No parameters...');
     Writeln('The right syntax is :HelpComp <FileName>.');
     Writeln;

     Halt(1);

End;

Procedure PrintErrorMessage2(FileName :String);
Begin

     Writeln('Error opening the file ',FileName);
     Writeln;

     Halt(1);

End;

Procedure PrintErrorMessage3;
Begin

     Writeln('FileName does not exist');
     Writeln;

     Halt(1);

End;

Procedure MakeOtherFileNames;
Var
  Position      :Byte;
Begin
    IF Length(FileName)=0 Then
       PrintErrorMessage3;

    Position:=Pos('.',FileName);
    IF Position=0 Then
       Position:=Length(FileName)+1;

    FileNamePas:=Copy(FileName,1,Position-1)+'.Pas';
    FileNameHlp:=Copy(FileName,1,Position-1)+'.Hlp';
End;

Procedure OpenFile;
Begin
{$I-}
     Assign(TextFile,FileName);
     Reset(TextFile);   {$I+}
     IF IOResult<>0 Then
         PrintErrorMessage2(FileName);


{$I-}
     Assign(TextFilePas,'TopicHlp.Pas');
     Rewrite(TextFilePas);     {$I+}
     IF IOResult<>0 Then
         PrintErrorMessage2(FileNamePas);


{$I-}
     Assign(TextFileHlp,FileNameHlp);
     Rewrite(TextFileHlp,1);     {$I+}
     IF IOResult<>0 Then
         PrintErrorMessage2(FileNameHlp);
End;

{******************************************************************}
Procedure ProcessFile;
Var
   Position :Byte;
   I        :Word;
   Remainer :Byte;

   Function CodeChar(TakeChar:Char) :Char;
   Var
      TestC     :Char;
   Begin
       TestC:=TakeChar;
       TestC:=Chr(Not(Ord(TakeChar)));
       TestC:=Chr(Ord(TestC)-10);
       CodeChar:=TestC;
   End;


   Function LockLine : String;
   Var
      I,J               :Byte;
      AsciiCode         :String[1];
      CodedLine         :String;
      TakeReference     :String;
      CodeReference     :String;
      OpenTopic,
      OpenReference     :Boolean;

   Begin
       AsciiCode:='';
       I:=1;
       CodedLine:='';

       IF LineLimit[1]<>'.' Then
       Begin
         LineLimit:=LineLimit+#13+#10;

         OpenTopic:=False;
         OpenReference:=False;
         TakeReference:='';

         Repeat
            AsciiCode:=Copy(LineLimit,I,1);
            Case AsciiCode[1] of
              '{' :OpenTopic:=True;
              ':' :OpenReference:=True;
              '}' :Begin
                     OpenTopic:=False;
                     OpenReference:=False;
                   End;
            End;
            IF (OpenTopic=True) and (OpenReference=True) Then
            Begin
               IF AsciiCode[1] = ':' Then
                 CodedLine:=CodedLine+CodeChar(AsciiCode[1])
               Else
                  TakeReference:=TakeReference+AsciiCode
            End
            Else
            Begin
               IF TakeReference <> '' Then
               Begin
                  J:=0;
                  Repeat
                     IF TakeReference <> Labels[J] Then
                        Inc(J);
                  Until (TakeReference = Labels[J]) or (J=LabelCount);

                  CodeReference:='';

                  IF (J <> LabelCount) Then
                  Begin
                     Str(J,TakeReference);
                     For J:=1 to Length(TakeReference) do
                     Begin
                         AsciiCode:=Copy(TakeReference,J,1);
                         CodeReference:=CodeReference+CodeChar(AsciiCode[1]);
                     End;
                  End
                  Else
                  Begin
                     Gotoxy(1,YRow);
                     Writeln(' > Label {',TakeReference,'} was not found in Line ..',LineCounter:5);
                     Inc(YRow,2);
                     Delay(20);
                  End;


                  TakeReference:='';
                  CodedLine:=CodedLine+CodeReference+CodeChar('}');

               End
               Else
                 CodedLine:=CodedLine+CodeChar(AsciiCode[1]);
            End;
            Inc(I);
         Until AsciiCode[1]=#10;

       End
       Else
       Begin
           IF TopicSize<>0 Then
           Begin
               Inc(MaxTopics);
               TopicSizeArray[MaxTopics]:=TopicSize;
           End;
           LineLimit:=LineLimit+#13+#10;
           For I:=1 to Length(LineLimit) do
           Begin
                AsciiCode:=Copy(LineLimit,I,1);
                CodedLine:=CodedLine+CodeChar(AsciiCode[1]);
           End;
           CodedLine:='    '+CodedLine;
           {Keep four blank bytes for the topic size which will be filling up on }
           { the second pass.                                                    }
           TopicSize:=0;
       End;

       TopicSize:=TopicSize+Length(CodedLine);
       LockLine:=CodedLine;
   End;
   Procedure CheckIfHelpLabel;
   Var
      NewStr    :String;
      NumStr    :String;
      Num       :Word;
      Position  :Byte;
      ErCode    :Integer;
   Begin
       IF LineLimit[1]='.' Then
       Begin
          LineLimit:=Copy(LineLimit,2,Length(LineLimit));
          NewStr:='hc'+LineLimit;

          Writeln(TextFilePas,' ',NewStr:20,' = ',LabelCount:5,';');

          Labels[LabelCount]:=LineLimit;
          Inc(LabelCount);
       End;
   End;
Var
   MyChar     :String[1];
   MYStr      :BString;

Begin

   Writeln('Working...........(PLEASE WAIT)');
   TopicSize:=0;
   MaxTopics:=0;
   LabelCount:=0;


   {*********** *.Pas *********}

   Reset(TextFile);
   Writeln(TextFilePas,'{******************************** HELP **************************************}');
   Writeln(TextFilePas,'{‘œ ˜¬«¦ «¦ unit ¬§˜¨®¦¬¤ ¦  ¡à› ¡¦  ˜§¦ «¦ ˜¨®œ ¦ ',FileName,'.‡˜ §¨œ§œ  ¤˜   }');
   Writeln(TextFilePas,'{š ¤œ  compile ¡˜  ¤˜ «¦§¦Ÿœ«žŸœ  ©˜¤ unit ©«¦ ¡¬¨ àª §¨¦š¨˜££˜.             }');
   Writeln(TextFilePas,'{                                                                            }');
   Writeln(TextFilePas,'{George Papaioannou Thessaloniki 1996   (c) Digital ToolWorks  Ver 3.00   !! }');
   Writeln(TextFilePas,'{****************************************************************************}');
   Writeln(TextFilePas);
   Writeln(TextFilePas);
   Writeln(TextFilePas,'UNIT TopicHlp;');
   Writeln(TextFilePas);
   Writeln(TextFilePas,'INTERFACE');
   Writeln(TextFilePas);

   Writeln(TextFilePas,'Const');
   Writeln(TextFilePas);
   Writeln(TextFilePas,'  { * The constants that added from the Original Help Text * }');
   Writeln(TextFilePas);
   Writeln(TextFilePas,' ','HelpFileName':20,' =     ','''',FileNameHlp,'''',';');
   Writeln(TextFilePas);
   Writeln(TextFilePas);

   Repeat
       Readln(TextFile,LineLimit);
       CheckIFHelpLabel;
   Until Eof(TextFile);

   Writeln(TextFilePas);
   Writeln(TextFilePas);


   Writeln(TextFilePas);
   Writeln(TextFilePas,'IMPLEMENTATION');
   Writeln(TextFilePas);
   Writeln(TextFilePas,'End.');


   {*********** *.Hlp *********}

   {Write The Header}
   ConvertString(HelpHeader,MyStr);
   BlockWrite(TextFileHlp,MyStr,LengthBString(MyStr),Er);
   Reset(TextFile);

   LineCounter:=1;
   Repeat
        Readln(TextFile,LineLimit);
        IF (LineLimit[1]<>';') and (Not Eof(TextFile)) Then
        Begin

           LineLimit:=LockLine;
           ConvertString(LineLimit,MyStr);
           BlockWrite(TextFileHlp,MyStr,LengthBString(MyStr),Er);
           Gotoxy(1,YRow);
           Write('Coded ',LineCounter:5,' lines by now');
           Inc(LineCounter);
        End;
   Until Eof(TextFile);

   Inc(MaxTopics);
   TopicSizeArray[MaxTopics]:=TopicSize;

   Close(TextFileHlp);
   {****** Now make the Second pass ***********}
{$I-}
     Assign(TextFileHlp,FileNameHlp);
     Reset(TextFileHlp,1);     {$I+}
     IF IOResult<>0 Then
         PrintErrorMessage2(FileNameHlp);

     Seek(TextFileHlp,Length(HelpHeader));
     CurFilePos:=FilePos(TextFileHlp);
     For I:=1 to MaxTopics do
     Begin
         BlockWrite(TextFileHlp,TopicSizeArray[I],4,Er);
         CurFilePos:=CurFilePos+TopicSizeArray[I];
         Seek(TextFileHlp,CurFilePos);
     End;

End;

Procedure CloseFile;
Begin
    Close(TextFile);
    Close(TextFilePas);
    Close(TextFileHlp);
End;

Procedure EndMessage;
Begin

     Writeln;
     Writeln('Ok well done........');
     Writeln;

End;

Begin
     TextColor(7);
     TextBackground(0);
     Clrscr;

     YRow:=6;

     InitMessages;
     IF ParamCount = 0 Then
        PrintErrorMessage1;

     FileName:=ParamStr(1);
     MakeOtherFileNames;
     OpenFile;
     ProcessFile;
     CloseFile;
     EndMessage;
End.