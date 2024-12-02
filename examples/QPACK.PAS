Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinInit,GeneralObj,Crt,
      ErrorDlg,MouseObj,WinApplObj,Palette,Dos;

{$I C:\include\gothic.Inc}

Const
     CmQuit             = 1;
     cmMainMenu         = 2;
     cmOptions          = 3;
     cmAbout            = 4;
     cmCloseWin         = 5;
     cmPackStart        = 6;
     cmAskMask          = 7;
     cmInclude          = 8;
     cmExclude          = 9;
     cmAskExMask        = 10;
     cmChangeDir        = 11;
     cmMarkFile         = 12;
     cmChangePath       = 13;
     cmDestDrive        = 14;
     cmReturnMain       = 15;
     cmPackComplete     = 16;


     GPathX1            = 2;
     GPathX2            = 32;
     GPathXLen          = GPathX2-GPathX1-3;

     NoDirs       :Boolean = False;
     Sign         :String = 'QPack ver 1.00a   by   Shadow Dancer';


Type

   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure MainMenu;
      Procedure About;
      Procedure DoEffect;
      Function  ReadDiskStruc :Byte;
      Procedure IncludeFiles;
      Procedure ExcludeFiles;
      Procedure AskMask;
      Procedure AskExMask;
      Procedure PackStart;
      Procedure ReadError;
      Procedure WriteError;
      Procedure SetParameters(Size :LongInt;Name,MainExe :String;Files :LongInt;Path :String);
      Procedure PackComplete;
   End;

   FilesStruc = Record
      Sign        :Array [1..50] of char;
      TotalFiles  :Word;
      HeadOffset  :LongInt;
   End;

   FileName = Record
      Name        :Array [1..12] of char;
      Size        :LongInt;
      NextFile    :LongInt;
   End;

Procedure HaltApplication; Forward;

Var
   Regs         :Registers;
   MaxDrives    :Byte;
   CDRom        :Byte;
   MaxHardDisks :Byte;
   CurrentDrv   :Byte;
   MBoxPtr      :PMenuNode;
   OldTMenuBox  :PMenuNode;
   Txt          :LinkText;
   GHT,GTT      :Pointer;
   UsrInterrupt :Boolean;
   TotalFiles   :Word;
   TotalSize    :LongInt;
   SelectedPaths:LinkText;

   CurrentFile  :String[12];
   CurrentPath  :String;
   CurrentSize  :String[10];
   TestPath     :String;
   IncludeMask  :String[12];
   ExcludeMask  :String[12];
   MainExe      :String[12];
   R            :ProgressBar;
   {***************************}
   Rec          :FileName;
   Head         :FilesStruc;
   DiskBuffer   :Pointer;
   F,F2         :File;
   TIOResult    :Integer;
   ReadedBytes  :Word;
   SFilesSize   :LongInt;


   DestDrive    :Byte;

   MyApp        :TMyApp;


Procedure InputText(A,B:String;TC,BC :Byte);
Var
   I            :Byte;
   NotEnd       :Boolean;
Begin
    IF Length(A+B) <= GPathXLen Then
       InsertText(A+B,TC,BC)
    Else
    Begin
       NotEnd:=False;
       IF A[1]='≥' Then
          NotEnd:=True;

       B:='...'+B;

       For I:=1 To (GPathXLen-Length(B)-Byte(NotEnd)) do
           B:=' '+B;

       IF NotEnd Then
          B:='≥'+B;

       InsertText(B,TC,BC);
    End;
End;

{************************************************************}
{Procedure InitTreeText                                      }
{Inserts to the current menu box the tree directory          }
{************************************************************}
Procedure InitTreeText;
Var
   MyDirInfo      :SearchRec;
   Er             :Byte;
   P,D,N,E        :String;
   TotalDirs      :Longint;
   CharCode       :Array [1..20] of Char; {Keeps seperated characters}

        {******************************************************}
        {Function AddSpace = subfunction                       }
        {******************************************************}
        Function AddSpace(Num  :Byte) :String;
        Var
           TStr         :String;
           I            :Byte;
        Begin
            TStr:='';

            IF Num > 1 Then
            Begin
              For I:=1 to Num-1 do
                  TStr:=TStr+' '+CharCode[I];
              IF Num > 1 Then
                  TStr:=TStr+' ';
            End
            Else
              TStr:=TStr+' ';


            AddSpace:=TStr;
        End;

        {************************************************************}
        {Function OneOrMoreDirs = subFunction                        }
        {Check to see if exists other subdirectories in the current  }
        {directory. True = If Yes exist,False = No more Dirs         }
        {************************************************************}
        Function OneOrMoreDirs(Path,CurrentDir :String) :Boolean;
        Var
           A           :SearchRec;
           C           :Byte; {Count}
           WeFoundIt   :Boolean;
        Begin
            C:=0;
            WeFoundIt:=False;
            FindFirst(Path, Directory, A);
            IF DosError <> 0 Then
            Begin
                  OneOrMoreDirs:=False;  {Only one subdir in current directory}
                  Exit;
            End
            Else
                While (DosError = 0) and (C < 2) DO
                Begin
                    IF (A.Attr = Directory) and (A.Name[1] <> '.')  Then
                       IF (A.Name=CurrentDir) or (WeFoundIt=True) Then
                       Begin
                          Inc(C); {Inc count}
                          WeFoundIt:=True;
                       End;

                    FindNext(A);

                End;


            IF (C >= 2) Then
                OneOrMoreDirs:=True
            Else
                OneOrMoreDirs:=False;
        End;

{ Here starts the main procedure's code}
Var
   CStr            :String;
   Prev            :String;
   Count           :Byte;
   TraceStr        :String;
   Final           :Boolean;
   CharStr         :String[1];

Begin
    Count:=0;
    Prev:='';
    CStr:='';
    Count:=0;
    TraceStr:='';
    CharStr:='';
    Final:=False;

    Txt.FindNodeNum(1);
    CStr:=Txt.GetText;
    InputText('',CStr,$FF,$FF);
    Repeat
        IF CStr <> '' Then
           Prev:=Prev+CStr+'\';
        Txt.NextText;

        IF Txt.Text = Nil Then
           Exit;

        CStr:=Txt.GetText;
        Er:=Pos(Prev,CStr);

        IF Er <> 0 Then
        Begin
           CStr:=Copy(CStr,Length(Prev)+1,Length(CStr));

           Final:=OneOrMoreDirs(Prev+'*.*',CStr);
           IF (Prev=Chr((CurrentDrv-1)+65)+':\') and (Final=True) Then
           Begin
              CharStr:='≥';
              InputText('√ƒ',CStr,$FF,$FF);
           End
           Else
           IF (Prev=Chr((CurrentDrv-1)+65)+':\') and (Final=False) Then
           Begin
              CharStr:=' ';
              InputText('¿ƒ',CStr,$FF,$FF);
           End
           Else
           Begin
              Inc(Count);
              Final:=OneOrMoreDirs(Prev+'*.*',CStr);

              IF Final=True Then
                 CharCode[Count]:='≥'
              Else
                 CharCode[Count]:=' ';

              IF (Final = True)  Then
                 InputText(CharStr+AddSpace(Count)+'√ƒ',CStr,$FF,$FF)
              Else
                 InputText(CharStr+AddSpace(Count)+'¿ƒ',CStr,$FF,$FF);

              Txt.NextText;
              IF Txt.Text = Nil Then
                 Exit;

              Er:=Pos(Prev+CStr,Txt.GetText);
              IF (Er=0) Or ((Prev+CStr) <> Txt.GetText) Then
              Begin
                 CStr:='';
                 TraceStr:=Txt.GetText;
                 Count:=0;
                 Repeat
                       Er:=Pos('\',TraceStr);
                       IF Er<>0 Then
                       Begin
                           Inc(Count);
                           CStr:=CStr+Copy(TraceStr,1,Er);
                           TraceStr:=Copy(TraceStr,Er+1,Length(TraceStr));
                           Er:=Pos(CStr,Prev);
                       End;
                 Until Er=0;

                 IF Count > 2 Then
                    Dec(Count,2)
                 Else
                    Count:=0;

                 IF CStr<>'C:\' Then
                    Prev:=CStr
                 Else
                   Prev:='';

                 CStr:='';

              End;

              Txt.PrevText;
           End;
        End
        Else
        Begin
           CStr:=Copy(CStr,Length(Chr((CurrentDrv-1)+65)+':\')+1,Length(CStr));
           Count:=0;
           Prev:=Chr((CurrentDrv-1)+65)+':\';

           Final:=OneOrMoreDirs(Prev+'*.*',CStr);
           IF (Prev=Chr((CurrentDrv-1)+65)+':\') and (Final=True) and (CStr<>'') Then
           Begin
              CharStr:='≥';
              InputText('√ƒ',CStr,$FF,$FF);
           End
           Else
           IF (Prev=Chr((CurrentDrv-1)+65)+':\') and (Final=False) and (CStr<>'') Then
           Begin
              CharStr:=' ';
              InputText('¿ƒ',CStr,$FF,$FF);
           End;
        End;


    Until (Txt.Edge = True);

End;

{$F+}
Procedure HandleError;
Begin
     Event:=CmMainMenu;
     MyApp.HandleCommand;
End;
{$F-}

Procedure TMyApp.ReadError;
Begin
    ErrorMessage('ä·ü¶™ °ò´· ´û§ ò§·ö§‡©û ´‡§ õúõ¶£‚§‡§.'+#10+
                 'Ü õ†òõ†°ò©Âò ò°Á®‡§ú´ò†.',bfOk);
    ErrorProcessPtr:=@HandleError;
    Release(DiskBuffer);
    Close(F);
    Close(F2);
End;


Procedure TMyApp.WriteError;
Begin
    ErrorMessage('ä·ü¶™ °ò´· ´û§ úöö®ò≠„ ´‡§ õúõ¶£‚§‡§.'+#10+
                 'Ü õ†òõ†°ò©Âò ò°Á®‡§ú´ò†.',bfOk);
    ErrorProcessPtr:=@HandleError;
    Release(DiskBuffer);
    Close(F);
    Close(F2);
End;

Procedure TMyApp.SetParameters(Size :LongInt;Name,MainExe :String;Files :LongInt;Path :String);
Var
   XCoord       :Byte;
   S            :String;
   Er,I         :Byte;
Begin
    WriteTextColor:=14;
    WriteTextBackGround:=4;
    XCoord:=(GetWindowMaxX div 2)+3+1+17;
    Str(Size,S);
    WriteWindow(XCoord,11,SetString(S,9,RightJustify));

    {exclude all spaces of the file names if Ext='');}
    Er:=Pos('.',Name);
    IF Er=0 Then
    Begin
      S:='';
      For I:=1 to Length(Name) Do
         IF Name[I]<>' ' Then
             S:=S+Name[I];
                End
    Else
       S:=Name;

    WriteWindow(XCoord,12,SetString(S,12,RightJustify));
    WriteWindow(XCoord,13,SetString(MainExe,12,RightJustify));
    WriteTextBackGround:=5;
    WriteTextColor:=14;
    Str(Files,S);
    WriteWindow(19,11,SetString(S,6,RightJustify));

    WriteTextBackGround:=1;
    SetWindowClip(2,2,GetWindowMaxX-1,8);
    HiddenMouseCursor;
    ScrollUp(Win^.X1+3,Win^.Y1+3,Win^.X1+GetWindowMaxX-2,Win^.Y1+7,
            1,(1 shl 4) + 15);
    ShowMouseCursor;
    WriteWindow(3,7,Path);
    SetWindowClipOff;
End;


Procedure TMyApp.PackStart;
Var
   S,D,N,E      :String;
   RealPath     :String;
   Found        :Boolean;
   PathName     :String[12];
   I,I2         :Byte;
   SChar        :String[1];
   DirInfo      :SearchRec;
Begin

    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(5,3,75,21,'É†òõ†°ò©Âò ßò°ú´ò®Â©£ò´¶™',WinChars+OpenFx+CloseFx+
                        WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    WriteTextColor:=11;
    WriteTextBackGround:=WinTextBackGround;
    HorizontalLine(2,GetWindowMaxY-1,GetWindowMaxX-1,196);

    WriteTextColor:=15;
    WriteTextBackGround:=1;
    TextPaint(2,2,GetWindowMaxX-1,8,Shadow);
    TextBox(2,2,GetWindowMaxX-1,8,SingleLines);

    WriteTextColor:=15;
    WriteTextBackGround:=5;
    TextPaint(2,10,GetWindowMaxX div 2,GetWindowMaxY-3,Shadow);
    TextBox(2,10,GetWindowMaxX div 2,GetWindowMaxY-3,SingleLines);

    WriteTextColor:=15;
    WriteTextBackGround:=4;
    TextPaint((GetWindowMaxX div 2)+3,10,GetWindowMaxX-1,GetWindowMaxY-3,Shadow);
    TextBox((GetWindowMaxX div 2)+3,10,GetWindowMaxX-1,GetWindowMaxY-3,SingleLines);

    WriteTextColor:=6;
    WriteTextBackGround:=7;
    R.InitProgressBar(3,13,30,0,TotalFiles-1);

    WriteTextColor:=15;
    WriteTextBackGround:=5;
    WriteWindow(3,11,'ëÁ§¶¢¶ ò®ÆúÂ‡§ [      ]');

    WriteTextColor:=15;
    WriteTextBackGround:=4;
    WriteWindow((GetWindowMaxX div 2)+3+1,11,'ã‚öúü¶™         [         ]  B');
    WriteWindow((GetWindowMaxX div 2)+3+1,12,'Ä®ÆúÂ¶ ß®¶™ Ñ•. [            ]');
    WriteWindow((GetWindowMaxX div 2)+3+1,13,'Åò©†°¶ Exe Ä®Æ. [            ]');

    UsrInterrupt:=False;
    WriteTextBackGround:=WinTextBackGround;
    WriteTextColor:=14;
    CentreWinMessage(GetWindowMaxY,'QPack ver 1.00a by Shadow Dancer a.k.a George Papaioannou');

    SelectedPaths.GoStart;
    RealPath:='';
    Found:=False;
    Repeat
      IF SelectedPaths.Text <> Nil Then
      Begin
        S:=SelectedPaths.GetText;
        FSplit(S,D,N,E);
        IF (N+E) = MainExe Then
        Begin
           RealPath:=S;
           Found:=True;
        End;

        SelectedPaths.NextText;
      End;
    Until (Found=True) or (SelectedPaths.Text=Nil);

    IF (SelectedPaths.Text=Nil) and (Found=False) Then
       HaltApplication;

    Dec(TotalFiles);
    Head.TotalFiles:=TotalFiles;
    SetParameters(0,' ',MainExe,TotalFiles,' ');

    Assign(F,RealPath);
{$I-}
    Reset(F,1);
{$I+}
    TIOResult:=IOResult;
    IF TIOResult <> 0 Then
    Begin
          ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                       ' '+#10+
                       'Dos Error Report :'+#10+
                        TDosErrorMessage(TIOResult),bfOk);
          ErrorProcessPtr:=@HandleError;
          Exit;
    End;

    If MaxAvail < $FFFF Then
    Begin
        ErrorMessage('éÆ† ò®°ú´„ £§„£û ö†ò ´û õû£†¶¨®öÂò ´¶¨'+#10+
                     'File data area.Ü õ†òõ†°ò©Âò qpack ò°Á®‡§ú´ò†.',bfOk);
        ErrorProcessPtr:=@HandleError;
        Close(F);
        Exit;
    End
    Else
       GetMem(DiskBuffer,$FFFF);

{$I-}
    Seek(F,FileSize(F)); {Go to end of the file}
{$I+}
    TIOResult:=IOResult;
    IF TIOResult <> 0 Then
    Begin
       ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                    ' '+#10+
                    'Dos Error Report :'+#10+
                     TDosErrorMessage(TIOResult),bfOk);
       ErrorProcessPtr:=@HandleError;
{$I-}
       Close(F);
{$I+}
       Release(DiskBuffer);
       Exit;
    End;

    Head.HeadOffset:=FileSize(F);
    SelectedPaths.GoStart;
    Repeat
       IF (SelectedPaths.Text<>Nil) Then
       Begin
          S:=SelectedPaths.GetText;
          FSplit(S,D,N,E);
          IF (N+E) <> MainExe Then
          Begin
{$I-}
               Seek(F,FileSize(F));
{$I+}
               TIOResult:=IOResult;
               IF TIOResult <> 0 Then
               Begin
                  ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                               ' '+#10+
                               'Dos Error Report :'+#10+
                                TDosErrorMessage(TIOResult),bfOk);
                  ErrorProcessPtr:=@HandleError;
           {$I-}
                  Close(F);
           {$I+}
                  Release(DiskBuffer);
                  Exit;
               End;


               FindFirst(S,Archive,DirInfo);
               Dec(TotalFiles);
               SetParameters(DirInfo.Size,N+E,MainExe,TotalFiles,S);
               R.UpDateProgressBar(1);
               Assign(F2,S);
     {$I-}
               Reset(F2,1);
     {$I+}
               TIOResult:=IOResult;
               IF TIOResult <> 0 Then
               Begin
                  ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                               ' '+#10+
                               'Dos Error Report :'+#10+
                                TDosErrorMessage(TIOResult),bfOk);
                  ErrorProcessPtr:=@HandleError;
{$I-}
                  Close(F);
                  Close(F2);
{$I+}
                  Release(DiskBuffer);
                  Exit;
               End;

               PathName:=N+E;
               I2:=1;
               For I:=1 to Length(PathName) do
               Begin
                  SChar:=Copy(PathName,I,1);
                  IF SChar <> ' ' Then
                  Begin
                     Rec.Name[I2]:=UpCase(SChar[1]);
                     Inc(I2);
                  End;
               End;

               For I:=I2 to 12 do
                   Rec.Name[I]:=' '; {Make spaces}


               IF TotalFiles <> 0 Then
                  Rec.NextFile:=Head.HeadOffset+SizeOf(Rec)+DirInfo.Size
               Else
                  Rec.NextFile:=0;
               Rec.Size:=DirInfo.Size;
     {$I-}
               BlockWrite(F,Rec,SizeOf(Rec),ReadedBytes);
     {$I+}     TIOResult:=IOResult;
               IF (TIOResult <> 0) or (ReadedBytes <> SizeOf(Rec)) Then
               Begin
                   MyApp.WriteError;
                   Exit;
               End;

               SFilesSize:=FileSize(F2);
               IF SFilesSize > $FFFF Then
               Begin
                   For I:=1 to (SFilesSize div $FFFF) do
                   Begin
     {$I-}
                      BlockRead(F2,DiskBuffer^,$FFFF,ReadedBytes);
                      TIOResult:=IOResult;
                      IF (TIOResult <> 0) or (ReadedBytes<>$FFFF) Then
                      Begin
                          MyApp.ReadError;
                          Exit;
                      End;
                      BlockWrite(F,DiskBuffer^,$FFFF,ReadedBytes);
     {$I+}
                      TIOResult:=IOResult;
                      IF (TIOResult <> 0) or (ReadedBytes <> $FFFF) Then
                      Begin
                          MyApp.WriteError;
                          Exit;
                      End;

                   End;
     {$I-}
                   BlockRead(F2,DiskBuffer^,$FFFF,ReadedBytes);
                   TIOResult:=IOResult;
                   IF (TIOResult <> 0) Then
                   Begin
                       MyApp.ReadError;
                       Exit;
                   End;
                   BlockWrite(F,DiskBuffer^,ReadedBytes,ReadedBytes);
     {$I+}
                   TIOResult:=IOResult;
                   IF (TIOResult <> 0) Then
                   Begin
                       MyApp.WriteError;
                       Exit;
                   End;

               End
               Else
               Begin
     {$I-}
                   BlockRead(F2,DiskBuffer^,$FFFF,ReadedBytes);
                   TIOResult:=IOResult;
                   IF (TIOResult <> 0) Then
                   Begin
                       MyApp.ReadError;
                       Exit;
                   End;
                   BlockWrite(F,DiskBuffer^,ReadedBytes,ReadedBytes);
                   TIOResult:=IOResult;
                   IF (TIOResult <> 0) Then
                   Begin
                       MyApp.WriteError;
                       Exit;
                   End;
               End;
               Close(F2);
     {$I+}
               TIOResult:=IOResult;
               IF TIOResult <> 0 Then
               Begin
                   MyApp.WriteError;
                   Exit;
               End;

          End;

          SelectedPaths.NextText;
       End


    Until (SelectedPaths.Text = Nil);

    For I:=1 to Length(Sign) do
    Begin
       SChar:=Copy(Sign,I,1);
       Head.Sign[I]:=SChar[1];
    End;

{$I-}
    BlockWrite(F,Head,SizeOf(Head),ReadedBytes);
    TIOResult:=IOResult;
    IF (TIOResult <> 0) or (ReadedBytes <> SizeOf(Head)) Then
    Begin
        MyApp.WriteError;
        Exit;
    End;

    Release(DiskBuffer);
    Close(F);
{$I+}
    TIOResult:=IOResult;
    IF TIOResult <> 0 Then
    Begin
        MyApp.WriteError;
        Exit;
    End;

    Event:=cmPackComplete;
    HandleCommand;

End;

Procedure TMyApp.PackComplete;
Begin
    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(13,8,67,15,'> Ñ†õ¶ß¶Âû©û <',WinChars+OpenFx+CloseFx+CloseIcon+Movement+Shadow+WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    Win^.CloseCommand:=cmReturnMain;

    WriteTextColor:=1;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'Ü õ†òõ†°ò©Âò ´ú¢úÂ‡©ú úß†´¨ÆÈ™.');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmReturnMain,PushButton,BfDefault);
End;


{****************************************************************}
{Procedure ReadDiskStruc                                         }
{****************************************************************}
Function TMyApp.ReadDiskStruc :Byte;
Var
   MyDirInfo      :SearchRec;
   Er             :Byte;
   P,D,N,E        :String;
   TotalDirs      :Longint;
   TotalFiles     :LongInt;


      {************** Internal procedure ****************}
      {Searches the disk directory.                      }
      {**************************************************}
      Function Searcher(Path :String;A :SearchRec) : Byte;
      Begin

          FindFirst(Path, Directory, A);
          IF DosError <> 0 Then
                Searcher := DosError
          Else
          Begin
              While (DosError = 0) and (UsrInterrupt=False) DO
              Begin

                  Inc(TotalFiles);
                  Gotoxy(Win^.X1+22,Win^.Y1+GetWindowMaxY-3);
                  HiddenMouseCursor;
                  Write(TotalFiles :10);
                  ShowMouseCursor;

                  IF A.Attr = Directory Then
                  Begin

                     IF A.Name[1] <> '.' Then
                     Begin

                       Inc(TotalDirs);
                       Gotoxy(Win^.X1+22,Win^.Y1+GetWindowMaxY-2);
                       HiddenMouseCursor;
                       Write(TotalDirs :10);
                       ShowMouseCursor;


                       FSplit(Path,D,N,E);
                       HiddenMouseCursor;
                       ScrollUp(Win^.X1+1,Win^.Y1+2,Win^.X1+GetWindowMaxX,Win^.Y1+(GetWindowMaxY-5),
                               1,(WriteTextBackGround shl 4) + WriteTextColor);
                       ShowMouseCursor;
                       WriteWindow(1,GetWindowMaxY-5,D+A.Name);
                       Txt.InsertText(D+A.Name,$FF,$FF);
                       P:=D+A.Name+'\*.*';
                       Er:=Searcher(P,MyDirInfo);
                     End;
                  End;

                  IF BiosKeyPressed Then
                  Begin
                      ReadKbd(Ctrl,Ascii);
                      IF (Ctrl=Chr(27)) Then
                         UsrInterrupt:=True;
                  End;

                  FindNext(A);
              End;

              IF DosError = 18 Then
                 Searcher := 0
              Else
              IF UsrInterrupt Then
                 Searcher:=$FF
              Else
                 Searcher := DosError;
          End;

      End;

Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,4,70,22,'Reading Disk Structure',WinChars+OpenFx+CloseFx+Shadow+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;
      Win^.CloseCommand:=cmMainMenu;

      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      HorizontalLine(1,GetWindowMaxY-4,GetWindowMaxX,196);

      WriteWindow(1,GetWindowMaxY-3,'ëÁ§¶¢¶ Ä®ÆúÂ‡§      [          ]');
      WriteWindow(1,GetWindowMaxY-2,'ëÁ§¶¢¶ ìß¶°ò´ò¢Êö‡§ [          ]');
      WriteTextColor:=14;

      CentreWinMessage(GetWindowMaxY,'è·´û©ú Esc ö†ò ò°Á®‡©û.');
      WriteTextColor:=15;

      SetWindowClip(1,1,GetWindowMaxX,GetWindowMaxY-4);

      TextColor(WinTextColor);
      TextBackGround(WinTextBackGround);
      WriteTextColor:=WinTextColor;
      WriteTextBackGround:=WinTextBackGround;

      UsrInterrupt:=False;
      TotalDirs:=0;
      TotalFiles:=0;
      P:=Char((CurrentDrv-1)+65)+':\*.*';
      FSplit(P,D,N,E);
      Txt.DeInitText;
      Txt.InitText;
      Txt.InsertText(Chr((CurrentDrv-1)+65)+':',$FF,$FF);
      Er:=Searcher(P,MyDirInfo);
      IF Er<>0 Then
         UsrInterrupt:=True;
      SetWindowClipOff;
      TotalFiles:=0;

      IF (UsrInterrupt=True) or (Er<>0) Then
      Begin
          Txt.DeInitText;
          InitText;
          GHT:=GeneralHeadText;
          GTT:=GeneralTailText;
          NoDirs:=True;
          CloseWindow;
      End
      Else
      Begin
         {********* Do tree *******}
         CloseWindow;
         WinTextColor:=15;
         WinTextBackGround:=2;
         OpenWindow(10,11,70,16,'',OpenFx+CloseFx+WinChars+Shadow);
         IF HeapErrorCode <> 0 Then
            HaltApplication;

         WriteTextColor:=WinTextColor;
         WriteTextBackGround:=WinTextBackGround;
         CentreWinMessage(1,'î´†·Æ§‡ ´¶ Directory Tree .....');
         CentreWinMessage(3,'èò®ò°ò¢È ßú®†£‚§ú´ú ö†ò ¢Âöò õú¨´ú®Ê¢úß´ò');

         InitText;
         InitTreeText;
         GHT:=GeneralHeadText;
         GTT:=GeneralTailText;
         NoDirs:=False;

         CloseWindow;
      End;

      IF (Er<>255) and (Er<>0) Then
         ReadDiskStruc:=Er
      Else
         ReadDiskStruc:=0;

End;

Procedure ReadAllFiles(Path :String);
Var
   FileInfo: SearchRec;
   DT      : DateTime;
   S       : String;
   Year,
   Day,
   Month   :String;
   R       :Byte;
   Name,
   Ext     :String[20];
   DiskIcon:String[2];
   I       :Integer;
   FileName:String[12];
Begin
   InitText;
   FindFirst(Path+'\*.*', Archive, FileInfo); { Same as DIR *.* }
   While DosError = 0 do
   Begin
     Str(FileInfo.Size,S);
     UnPackTime(FileInfo.Time,DT);
     Str(DT.Year,Year);
     Str(DT.Month,Month);
     Str(DT.Day,Day);
     R:=Pos('.',FileInfo.Name);
     IF R<>0 Then
     Begin
       Name:=Copy(FileInfo.Name,1,R-1);
       Ext:='.'+Copy(FileInfo.Name,R+1,Length(FileInfo.Name));
     End
     Else
     Begin
         Name:=FileInfo.Name;
         Ext:='';
     End;

     IF (Ext='.EXE') or (Ext='.COM') or (Ext='.BAT') Then
        DiskIcon:=Chr(WCExeFile1)+Chr(WCExeFile2)
     Else
        DiskIcon:=Chr(WCFile1)+Chr(WCFile2);

     FileName:=SetString(Name,8,LeftJustify)+SetString(Ext,4,LeftJustify);
     SelectedPaths.FindText(CurrentPath+FileName);
     IF SelectedPaths.GetText = (CurrentPath+FileName) Then
            InsertText(Chr(WCCheckIcon)+' '+DiskIcon+' '+FileName+'≥'+
                     SetString(S,9,RightJustify)+'≥'+Day+'/'+Month+'/'+Year,$FF,7)
     Else
            InsertText('  '+DiskIcon+' '+FileName+'≥'+
                     SetString(S,9,RightJustify)+'≥'+Day+'/'+Month+'/'+Year,$FF,$FF);

     FindNext(FileInfo);
   End;

   I:=DosError;
End;

Function CheckWildCard(WildCard,FileName :String) :Boolean;
Var
   S1,S2        :String[1];
   Er           :Byte;
   FName,WName  :String[8];
   FExt,WExt    :String[3];
   FinalName    :String[8];
   FinalExt     :String[3];
   SStr         :String[12];
   I,J,WildLen  :Byte;
Begin
    For I:= 1 to Length(FileName) Do
      FileName[I] := UpCase(FileName[I]);

    For I:= 1 to Length(WildCard) Do
      WildCard[I] := UpCase(WildCard[I]);

    Er:=Pos('.',FileName);
    IF Er=0 Then
    Begin
       FName:=FileName;
       FExt:='   ';
    End
    Else
    Begin
        FName:=Copy(FileName,1,Er-1);
        FExt:=Copy(FileName,Er+1,Length(FileName));
    End;

    Er:=Pos('.',WildCard);
    IF Er=0 Then
    Begin
       WName:=WildCard;
       WExt:='   ';
    End
    Else
    Begin
        WName:=Copy(WildCard,1,Er-1);
        WExt:=Copy(WildCard,Er+1,Length(WildCard));
    End;


    FinalName:=WName;
    For I:=1 to Length(WName) do
    Begin
      S1:=Copy(WName,I,1);
      IF S1='*' Then
      Begin
          WildLen:=(8-Length(FinalName))+1;
          SStr:='';
          For J:=1 to WildLen do
            SStr:=SStr+'?';
          Delete(FinalName,I,1);
          Insert(SStr,FinalName,I);
      End
    End;

    FinalExt:=WExt;
    For I:=1 to Length(WExt) do
    Begin
      S1:=Copy(WExt,I,1);
      IF S1='*' Then
      Begin
          WildLen:=(8-Length(FinalExt))+1;
          SStr:='';
          For J:=1 to WildLen do
            SStr:=SStr+'?';
          Delete(FinalExt,I,1);
          Insert(SStr,FinalExt,I);
      End;
    End;

    IF Length(FName) < 8 Then
       For I:=Length(FName) To 8 Do
           FName:=FName+' ';

    IF Length(FExt) < 3 Then
       For I:=Length(FExt) To 3 Do
           FExt:=FExt+' ';

    SStr:='';
    For I:=1 to Length(FName+'.'+FExt) do
    Begin
        S1:=Copy(FName+'.'+FExt,I,1);
        S2:=Copy(FinalName+'.'+FinalExt,I,1);

        IF S2='?' Then
        Begin
              SStr:=SStr+S1;
        End
        Else
        IF (S2='.') and (FExt='   ') Then
            SStr:=SStr+' '
        Else
            SStr:=SStr+S2;
    End;

    IF SStr = FileName Then
       CheckWildCard:=True
    Else
      CheckWildCard:=False;
End;




Procedure TMyApp.IncludeFiles;
Var
   I            :Word;
   S            :String;
   ArSize       :LongInt;
   Er           :Integer;
Begin

   OldTMenuBox:=Win^.CurMenusSeq;
   TMenuBox:=MBoxPtr^.NodePtr;
   CurMenusSeq:=MBoxPtr;


   IF TMenuBox^.MBMaxChoise=0 Then
      Exit;

   TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

   For I:=1 to TMenuBox^.MBMaxChoise Do
   Begin
       IF TMenuBox^.MBText^.TLineBackGround=$FF Then
       Begin
          TMenuBox^.MBText^.TextLine^:=Copy(TMenuBox^.MBText^.TextLine^,2,
                     Length(TMenuBox^.MBText^.TextLine^));

          {Insert A File into the Selected list}
          CurrentFile:=Copy(TMenuBox^.MBText^.TextLine^,5,14);
          CurrentSize:=Copy(TMenuBox^.MBText^.TextLine^,18,9);

          IF (CheckWildCard(IncludeMask,CurrentFile) = True) Then
          Begin
            IF ((Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') and (MainExe='') ) OR
               (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) <> 'EXE') Then
            Begin
              IF (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') and (MainExe='') Then
              Begin
                 MainExe:=CurrentFile;
                 WriteTextColor:=15;
                 WriteTextBackGround:=7;
                 WriteWindow(44,3,MainExe);
              End;
              SelectedPaths.InsertText(CurrentPath+'\'+CurrentFile,$FF,$FF);
              TMenuBox^.MBText^.TLineBackGround:=7;
              TMenuBox^.MBText^.TextLine^:=Chr(WCCheckIcon)+TMenuBox^.MBText^.TextLine^;
              Inc(TotalFiles);

              Val(CurrentSize,ArSize,Er);
              ArSize:=ArSize div 1024;
              TotalSize:=TotalSize+ArSize;
            End
            Else
              TMenuBox^.MBText^.TextLine^:=' '+TMenuBox^.MBText^.TextLine^;
          End
          Else
            TMenuBox^.MBText^.TextLine^:=' '+TMenuBox^.MBText^.TextLine^;
       End;
       TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
   End;

   GeneralHeadText:=TMenuBox^.MBHeadTextLine;
   GeneralTailText:=TMenuBox^.MBRearTextLine;
   ShowMenuText(GeneralHeadText,GeneralTailText,1);
   InitText;

   Win^.CurMenusSeq:=OldTMenuBox;
   TMenuBox:=OldTMenuBox^.NodePtr;

   WriteTextColor:=11;
   WriteTextBackGround:=Win^.WTextBackGround;
   Str(TotalFiles,S);
   WriteWindow(18,GetWindowMaxY-3,SetString(S,5,RightJustify));

   Str(TotalSize,S);
   WriteWindow(37,GetWindowMaxY-3,SetString(S,13,RightJustify));

   IF TotalFiles > 0 Then
      EnableWinCommand([cmPackStart])
   Else
      DisableWinCommand([cmPackStart]);
End;


Procedure TMyApp.ExcludeFiles;
Var
   I            :Word;
   S            :String;
   ArSize       :LongInt;
   Er           :Integer;
Begin

   OldTMenuBox:=Win^.CurMenusSeq;
   TMenuBox:=MBoxPtr^.NodePtr;
   CurMenusSeq:=MBoxPtr;


   IF TMenuBox^.MBMaxChoise=0 Then
      Exit;

   TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

   For I:=1 to TMenuBox^.MBMaxChoise Do
   Begin
       IF TMenuBox^.MBText^.TLineBackGround=7 Then
       Begin
          TMenuBox^.MBText^.TextLine^:=Copy(TMenuBox^.MBText^.TextLine^,2,
                     Length(TMenuBox^.MBText^.TextLine^));

          {Deletes A File into the Selected list}
          CurrentFile:=Copy(TMenuBox^.MBText^.TextLine^,5,14);
          CurrentSize:=Copy(TMenuBox^.MBText^.TextLine^,18,9);

          IF CheckWildCard(ExcludeMask,CurrentFile) = True Then
          Begin
            IF (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') and (MainExe<>'') Then
            Begin
               MainExe:='';
               WriteTextColor:=15;
               WriteTextBackGround:=7;
               WriteWindow(44,3,'              ');
            End;
            SelectedPaths.FindText(CurrentPath+'\'+CurrentFile);
            IF SelectedPaths.Text<>Nil Then
               SelectedPaths.DeleteText;
            TMenuBox^.MBText^.TLineBackGround:=$FF;
            TMenuBox^.MBText^.TextLine^:=' '+TMenuBox^.MBText^.TextLine^;
            Dec(TotalFiles);

            Val(CurrentSize,ArSize,Er);
            ArSize:=ArSize div 1024;
            TotalSize:=TotalSize-ArSize;
          End
          Else
            TMenuBox^.MBText^.TextLine^:=Chr(WCCheckIcon)+TMenuBox^.MBText^.TextLine^;
       End;
       TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
   End;

   GeneralHeadText:=TMenuBox^.MBHeadTextLine;
   GeneralTailText:=TMenuBox^.MBRearTextLine;
   ShowMenuText(GeneralHeadText,GeneralTailText,1);
   InitText;

   Win^.CurMenusSeq:=OldTMenuBox;
   TMenuBox:=OldTMenuBox^.NodePtr;

   WriteTextColor:=11;
   WriteTextBackGround:=Win^.WTextBackGround;
   Str(TotalFiles,S);
   WriteWindow(18,GetWindowMaxY-3,SetString(S,5,RightJustify));

   Str(TotalSize,S);
   WriteWindow(37,GetWindowMaxY-3,SetString(S,13,RightJustify));

   IF TotalFiles > 0 Then
      EnableWinCommand([cmPackStart])
   Else
      DisableWinCommand([cmPackStart]);
End;

Procedure TMyApp.AskMask;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(15,5,65,15,'Include',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;
      Win^.CloseCommand:=cmCloseWin;

      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;

      AssignXY(3,4,GetWindowMaxX-3,5);
      InitInputLine(NoCm,12,IncludeMask);
      InputLineLabel(3,3,'~ã·©°ò ò®ÆúÂ‡§');

      Win^.EnterCommand:=CmInclude;

      AssignXY(2,GetWindowMaxY-1,2,0);
      InitButton('    ~Ñ§´·•ú†    ',CmInclude,PushButton,BfDefault);

      AssignXY(20,GetWindowMaxY-1,0,0);
      InitButton('    ~Ä°Á®‡©û    ',CmCloseWin,PushButton,BfNormal);


End;

Procedure TMyApp.AskExMask;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(15,5,65,15,'Exclude',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;
      Win^.CloseCommand:=cmCloseWin;
      Win^.EnterCommand:=cmExclude;

      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;

      AssignXY(3,4,GetWindowMaxX-3,5);
      InitInputLine(NoCm,12,ExcludeMask);
      InputLineLabel(3,3,'~ã·©°ò ò®ÆúÂ‡§');

      AssignXY(2,GetWindowMaxY-1,2,0);
      InitButton('    ~Ñ§´·•ú†    ',CmExclude,PushButton,BfDefault);

      AssignXY(20,GetWindowMaxY-1,0,0);
      InitButton('    ~Ä°Á®‡©û    ',CmCloseWin,PushButton,BfNormal);


End;


Procedure TMyApp.DoEffect;
Begin
    Asm;
      mov  dx,3d4h
      mov  al,9h

      out  dx,al
      inc  dx
      in   al,dx
      and  al,00011111b
@D:
      push ax
      push dx
      Call VerticalRetrace
      pop  dx
      pop  ax
      out  dx,al
      dec  al

      cmp  al,0
      jnz  @D

    End;

    MakeBackGround(7,0,32);

    Asm;
      mov  dx,3d4h
      mov  al,9h
      out  dx,al
      inc  dx
      mov  al,00001111b
      out  dx,al
    End;


End;

Procedure TMyApp.HandleCommand;
Var
   S            :String;
   ArSize       :LongInt;
   Er           :Integer;
   I            :Byte;
Begin
   Case Event of

      CmQuit       :Begin
                      ExitFromProgram:=True;
                      CloseWindow;
                    End;
      CmMainMenu   :Begin
                        CloseWindow;
                        Er:=ReadDiskStruc;
                        SelectedPaths.DeInitText;
                        MainMenu;
                    End;
      cmCloseWin   :CloseWindow;
     cmAskMask     :AskMask;
     cmAskExMask   :AskExMask;
     cmChangeDir   :Begin
                        IF CurrentDrv <> DropDownCurrentNum Then
                        Begin
                            CurrentDrv:=DropDownCurrentNum;
                            Regs.Ah:=$0E;
                            Regs.Dl:=CurrentDrv-1;
                            Intr($21,Regs);
                        End;
                        CloseWindow;
                        Er:=ReadDiskStruc;
                        MainMenu;

                    End;
     cmMarkFile    :Begin
                       IF ( ( Ctrl=#0) and (Ascii=#82) ) Or
                          (MenuBoxDoubleClick) Then
                       Begin
                            {Here Select}
                            IF TMenuBox^.MBText^.TLineBackGround=$FF Then
                            Begin
                               TMenuBox^.MBText^.TLineBackGround:=7;
                               TMenuBox^.MBText^.TextLine^:=Copy(TMenuBox^.MBText^.TextLine^,2,
                                          Length(TMenuBox^.MBText^.TextLine^));

                               {Insert A File into the Selected list}
                               CurrentFile:=Copy(TMenuBox^.MBText^.TextLine^,5,14);
                               IF (MainExe<>'') and (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') Then
                               Begin
                                  TMenuBox^.MBText^.TLineBackGround:=$FF;
                                  TMenuBox^.MBText^.TextLine^:=' '+TMenuBox^.MBText^.TextLine^;
                                  Exit;
                               End
                               Else
                               IF (MainExe='') and (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') Then
                               Begin
                                  MainExe:=CurrentFile;
                                  WriteTextColor:=15;
                                  WriteTextBackGround:=7;
                                  WriteWindow(44,3,MainExe);
                               End;
                               CurrentSize:=Copy(TMenuBox^.MBText^.TextLine^,18,9);
                               SelectedPaths.InsertText(CurrentPath+'\'+CurrentFile,$FF,$FF);

                               TMenuBox^.MBText^.TextLine^:=Chr(WCCheckIcon)+TMenuBox^.MBText^.TextLine^;
                               Inc(TotalFiles);
                               Val(CurrentSize,ArSize,Er);
                               ArSize:=ArSize div 1024;
                               TotalSize:=TotalSize+ArSize;
                            End
                            Else
                            {Here DeSelect}
                            Begin
                               TMenuBox^.MBText^.TLineBackGround:=$FF;
                               TMenuBox^.MBText^.TextLine^:=Copy(TMenuBox^.MBText^.TextLine^,2,
                                          Length(TMenuBox^.MBText^.TextLine^));

                               CurrentFile:=Copy(TMenuBox^.MBText^.TextLine^,5,14);
                               CurrentSize:=Copy(TMenuBox^.MBText^.TextLine^,18,9);
                               IF (MainExe<>'') and (Copy(CurrentFile,Pos('.',CurrentFile)+1,3) = 'EXE') Then
                               Begin
                                  MainExe:='';
                                  WriteTextColor:=15;
                                  WriteTextBackGround:=7;
                                  WriteWindow(44,3,'             ');
                               End;
                               SelectedPaths.FindText(CurrentPath+'\'+CurrentFile);
                               IF SelectedPaths.Text<>Nil Then
                                  SelectedPaths.DeleteText;

                               TMenuBox^.MBText^.TextLine^:=' '+TMenuBox^.MBText^.TextLine^;
                               Dec(TotalFiles);
                               Val(CurrentSize,ArSize,Er);
                               ArSize:=ArSize div 1024;
                               TotalSize:=TotalSize-ArSize;
                            End;

                            WriteTextColor:=11;
                            WriteTextBackGround:=Win^.WTextBackGround;
                            Str(TotalFiles,S);
                            WriteWindow(18,GetWindowMaxY-3,SetString(S,5,RightJustify));

                            Str(TotalSize,S);
                            WriteWindow(37,GetWindowMaxY-3,SetString(S,13,RightJustify));

                            IF TotalFiles > 0 Then
                               EnableWinCommand([cmPackStart])
                            Else
                               DisableWinCommand([cmPackStart])
                       End;

                    End;
     cmChangePath  :Begin
                             IF UsrInterrupt=True Then
                                Exit;

                             IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and  (Ascii=#77)  )Then
                                 Exit;

                             IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and  (Ascii=#75)  )Then
                                 Exit;

                             OldTMenuBox:=Win^.CurMenusSeq;
                             TMenuBox:=MBoxPtr^.NodePtr;
                             CurMenusSeq:=MBoxPtr;

                             EnableWinCommand([cmMarkFile]);
                             MenuBoxDeleteAllText;
                             Txt.FindNodeNum(MenuBoxCurrentNum);
                             CurrentPath:=Txt.GetText;
                             ReadAllFiles(Txt.GetText);
                             WriteTextColor:=11;
                             WriteTextBackGround:=Win^.WTextBackGround;
                             WriteWindow(2,5,'Path :'+SetString(Txt.GetText,70,LeftJustify));

                             IF GeneralTailText=Nil Then
                             Begin
                                MenuBoxClearArea;
                                DisableWinCommand([cmMarkFile]);
                                WriteTextColor:=12;
                                WriteTextBackGround:=Win^.WTextBackGround;
                                WriteWindow(43,11,'Éú§ ¨ß·®Æ¶¨§ ò®ÆúÂò !!');
                             End
                             Else
                                ShowMenuText(GeneralHeadText,GeneralTailText,1);

                             Win^.CurMenusSeq:=OldTMenuBox;
                             TMenuBox:=OldTMenuBox^.NodePtr;
                             InitText;
                    End;
     cmInclude      :Begin
                       CloseWindow;
                       IncludeMask:=InputLineStr;
                       IncludeFiles;
                     End;
     cmExclude      :Begin
                       CloseWindow;
                       ExcludeMask:=InputLineStr;
                       ExcludeFiles;
                     End;
     cmDestDrive    :DestDrive:=DropDownCurrentNum;
     cmPackStart    :Begin
                       CloseWindow;
                       PackStart;
                     End;
     cmPackComplete :PackComplete;
     cmReturnMain   :Begin
                        CloseWindow;
                        Event:=cmMainMenu;
                        HandleCommand;
                     End;

   End;
End;

Procedure TMyApp.MainMenu;
Var
   MB   :Pointer;
   I    :Byte;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(1,2,80,24,'Quick Pack Process',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode = 1 Then
         HaltApplication;
      Win^.CloseCommand:=cmQuit;

      WriteTextColor:=11;
      WriteTextBackGround:=WinTextBackGround;

      HorizontalLine(2,GetWindowMaxY-2,GetWindowMaxX-1,196);
      DestDrive:=1;

      InitText;
      IF MaxDrives <> 0 Then
         For I:=1 to MaxDrives do
             InsertText(' '+Chr(WCDriveA1)+Chr(WCDriveA2)+Chr(WCDriveA3)+' Drive '+Chr((I-1)+65)+' ',$FF,$FF);
      IF MaxHardDisks <> 0 Then
         For I:=1 to MaxHardDisks do
             InsertText(' '+Chr(WCDriveC1)+Chr(WCDriveC2)+Chr(WCDriveC3)+' Disk  '+Chr(65+MaxDrives+(I-1))+' ',$FF,$FF);
      IF CdRom <> 0 then
            InsertText(' '+Chr(WCDriveC1)+Chr(WCDriveC2)+Chr(WCDriveC3)+' Disk  '+Chr(65+CdRom)+' ',$FF,$FF);

      AssignXY(2,3,18,3+MaxDrives+MaxHardDisks+Byte(CdRom > 0));
      InitDropDown(cmChangeDir);
      ShowDropDownText(GeneralHeadText,GeneralTailText,CurrentDrv);
      DropDownLabel(2,2,'~Source Drive');
      DropDownHelp('',0);

      WriteTextColor:=14;
      WriteTextBackGround:=7;
      TextPaint(22,2,GetWindowMaxX-2,3,Shadow);

      WriteWindow(23,3,'Åò©†°Ê *.Exe ò®ÆúÂ¶ :');
      WriteTextColor:=0;
      WriteWindow(31,2,'< è·´û©ú ´¶ ß¢„°´®¶ F1 ö†ò ô¶„üú†ò >');

      WriteTextColor:=11;
      WriteTextBackGround:=WinTextBackGround;
      WriteWindow(2,5,'Path :'+Chr((CurrentDrv-1)+65)+':');


      AssignXY(GPathX1,6,GPathX2,16);
      MBoxPtr:=InitMenuBox('~É†òõ®¶£„',VerScr,cmChangePath);
      IF UsrInterrupt=False Then
         ShowMenuText(GHT,GTT,1)
      Else
      Begin
        WriteTextColor:=12;
        WriteTextBackGround:=Win^.WTextBackGround;
        WriteWindow(GPathX1+2,11,'É†ò°Êß´û°ú òß¶ ´¶§ Æ®„©´û');
        WriteWindow(GPathX1+2,12,'„ òß¶ ´¶ Âõ†¶ ´¶ ©Á©´û£ò.');
        DisableWinCommand([cmChangePath]);
      End;

      AssignXY(34,6,GetWindowMaxX-1,16);
      MBoxPtr:=InitMenuBox('é§¶£ò ~ò®ÆúÂ¶¨     ã‚öúü¶™   Ü£ú®¶£û§Âò ',VerScr+AutoNext,CmMarkFile);
      IF UsrInterrupt=False Then
      Begin
        Txt.FindNodeNum(MenuBoxCurrentNum);
        ReadAllFiles(Txt.GetText);
        ShowMenuText(GeneralHeadText,GeneralTailText,1);
      End
      Else
      Begin
        WriteTextColor:=12;
        WriteTextBackGround:=Win^.WTextBackGround;
        WriteWindow(42,11,'É†ò°Êß´û°ú òß¶ ´¶§ Æ®„©´û');
        WriteWindow(42,12,'„ òß¶ ´¶ Âõ†¶ ´¶ ©Á©´û£ò.');
        DisableWinCommand([cmMarkFile]);
      End;

      WriteTextColor:=11;
      WriteTextBackGround:=WinTextBackGround;
      WriteWindow(2,GetWindowMaxY-3,'ëÁ§¶¢¶ ò®ÆúÂ‡§ [    0]    ã‚öúü¶™ [            0] KB');

      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('    ~Ñ§´·•ú†    ',CmPackStart,PushButton,BfNormal);

      IncludeMask:='*.*';
      AssignXY(19,GetWindowMaxY-1,0,0);
      InitButton('    ~Include    ',CmAskMask,PushButton,BfNormal);

      ExcludeMask:='*.*';
      AssignXY(36,GetWindowMaxY-1,0,0);
      InitButton('    E~xclude    ',CmAskExMask,PushButton,BfNormal);

      AssignXY(53,GetWindowMaxY-1,0,0);
      InitButton('    Ñ~•¶õ¶™     ',CmQuit,PushButton,BfDefault);

      IF UsrInterrupt Then
         DisableWinCommand([CmPackStart,CmAskMask,CmAskExMask])
      Else
        DisableWinCommand([CmPackStart]);

      SelectedPaths.InitText;
      CurrentPath:=Chr((CurrentDrv-1)+65)+':';
      TotalFiles:=0;
      TotalSize:=0;
      IncludeMask:='*.*';
      ExcludeMask:='*.*';
      MainExe:='';

End;

Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,5,70,15,'ëÆú´†°·',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmMainMenu;
      If HeapErrorCode = 1 Then
         HaltApplication;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'Quick Pack ');
      CentreWinMessage(3,'‚°õ¶©û 1.00a * ShareWare *');

      WriteTextColor:=1;
      CentreWinMessage(5,'˚ ìß·®Æ¶¨§ '+KBytes+'KB ©´¶ ©Á©´û£ò ú¢úÁüú®ò.');
      CentreWinMessage(6,'˚ Ü ‚°õ¶©û ´¶¨ Dos úÂ§ò† '+DosVer);


      AssignXY((GetWindowMaxX-Length('  ~Ñ§´·•ú† ')) div 2,GetWindowMaxY-1,0,0);
      InitButton('  ~Ñ§´·•ú† ',CmMainMenu,PushButton,BfDefault);
      ButtonHelp('',0);
End;

Procedure CheckFDrives;
Begin
    Intr($11,Regs);
    IF (Regs.Ax and 1) = 1 Then
    Begin
       Regs.Al:=Regs.Al and (128+64);
       Regs.Al:=Regs.Al shr 6;
       MaxDrives:=Regs.Al+1;
    End
    Else
      MaxDrives:=0;

    Regs.ax:=$1500;
    Regs.bx:=0;
    Intr($2F, Regs);
    case Regs.AL of
      $00 : CDRom:=0;
      $01 : CDRom:=0;
      $FF : CDRom:=Regs.cx;
      Else
         CDRom:=0;
    End;

    MaxHardDisks:=Mem[$0040:$0075];

    Regs.Ah:=$19;
    Intr($21,Regs);
    CurrentDrv:=Regs.Al+1;
End;

{$F+}
Procedure HaltApplication;
Begin
    SelectedPaths.DeInitText;
    MyApp.Done;
    TextColor(7);
    TextBackGround(0);
    Clrscr;
    Writeln('QPack  ver 1.00a   * Evaluation * ');
    Writeln('(c) Copyright 1993,96  by Digital ToolWorks');
    Writeln;
    Writeln('An unexpected error has occured that program can not handle.');
    Writeln('Refer to your manual for any recommendations.');
    Writeln;
    Writeln('Debug Info:');
    Writeln('    HeapErrorCode       = ',HeapErrorCode:2);
    Writeln('    ActiveErrorWindow   = ',ActiveErrorWindow);
    Halt(0);
End;
{$F-}


Var
   TextPal      :RGBType;
   I            :Byte;


Begin

    CheckFDrives;
    ExclusiveVga:=True;
    DosFonts:=True;
    SetBackGround:=False;
    AllowHelpCtx:=False;

    MyApp.Init;
    MyApp.About;
    MyApp.Run;
    MyApp.Done;

    MyApp.DoEffect;
    MakeBackGround(7,0,32);
    Gotoxy(1,1);
    TextBackGround(0);
    TextColor(15);
    ReadRGBColors(TextPal);
    ZeroRGBPalette;
    (*
    For I:=1 to 18 do
       Writeln(Message[I]);

       *)

    TextColor(13);
    Gotoxy(1,9);Write('OnLY QUaLitY');
    Gotoxy(1,10);Write('PRoDuCTs !!!');

    TextColor(14);
    Gotoxy(66,8);Write('dO yOu WaNNa');
    Gotoxy(66,9);Write('CoNtUcT wItH');
    Gotoxy(66,10);Write('mE ?   hMmm...');

    TextColor(1);
    Gotoxy(1,12);Write('wAtCH oUt fOr');
    Gotoxy(1,13);Write('oUr DEmoS aNd');
    Gotoxy(1,14);Write('OuR aWsoMe nEw');
    Gotoxy(1,15);Write('gAmE !!!');

    TextColor(10);
    Gotoxy(66,15);Write('GReeTings aRe');
    Gotoxy(66,16);Write('gOinG tO ......');
    Gotoxy(66,17);Write('dYno & PaLaDiN');

    TextColor(7);
    Gotoxy(1,19);Writeln('YOu cAn cOnTact wIth mE bY wRitTing aT :');
    Writeln('  ˙˙ƒÕ˛ G.Papaioannou');
    Writeln('  ˙˙ƒÕ˛ 23 Oktobriou 61');
    Writeln('  ˙˙ƒÕ˛ Larrisa - Greece');
    Writeln('  ˙˙ƒÕ˛ Tk 41221');
    FadeMax;
    FadeInPalette(TextPal);

    Gotoxy(1,24);
    TextBackGround(0);
    TextColor(7);

End.
