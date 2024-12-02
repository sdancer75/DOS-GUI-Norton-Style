Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinInit,GeneralObj,Crt,Dos,
      ErrorDlg,MouseObj,WinApplObj;

Const

     CmQuit             = 1;
     cmMainMenu         = 2;
     cmOptions          = 3;
     cmAbout            = 4;
     cmCloseWin         = 5;
     cmCompress         = 6;
     cmReportPath       = 7;
     cmFileReport       = 9;
     cmPrnReport        = 10;
     cmReport           = 11;
     cmBackup           = 12;
     cmRestore          = 13;
     cmAskMask          = 14;
     cmChangeDir        = 15;
     cmMarkFile         = 16;
     cmChangePath       = 17;
     cmBackUpStart      = 18;
     cmAskExMask        = 19;
     cmExclude          = 20;
     cmInclude          = 21;
     cmDestDrive        = 22;
     cmBackupName       = 23;
     cmDoBackUp         = 24;
     cmSetPassWord      = 25;
     cmPassWord         = 26;
     cmNextVol          = 27;
     cmTaskCompleted    = 28;
     cmUserAbort        = 29;
     cmContinueBackup   = 30;
     cmCancelBackup     = 31;
     cmInitMain         = 32;


     GPathX1            = 2;
     GPathX2            = 32;
     GPathXLen          = GPathX2-GPathX1-3;


Type

   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure MainMenu;
      Procedure Options;
      Procedure About;
      Procedure Backup;
      Procedure AskMask;
      Procedure AskExMask;
      Function  ReadDiskStruc :Byte;
      Procedure IncludeFiles;
      Procedure ExcludeFiles;
      Procedure StartBackup;
      Procedure InsertDisk;
      Procedure InsertNextDisk;
      Procedure InsertPassWord;
      Procedure InformError;
      Procedure ContinueBackupInNextVol;
      Procedure ReadError;
      Procedure WriteError;
      Procedure SetParameters(Size :LongInt;Name :String;Status :Byte;Files :LongInt;Path :String);
      Procedure TaskCompleted;
      Procedure UserAbort;
      Procedure ContinueBackup;
      Procedure CancelBackup;
   End;

   BString = Array [1..255] of Char;

   PSelectedFiles = ^SelectedFiles;
   SelectedFiles  = Record
         Name    :String[12];
         Next    :PSelectedFiles;
   End;

   {The head for every backup file.It is always on the first disk}

   HeadFileStruc = Record
       Sign        :BString; {Company's name}
       TotalSize   :LongInt;  {Total Size}
       TotalFiles  :Word;     {Total Files}
       UsedDisks   :Byte;     {Backup disks used}
       PassWord    :BString; {Password}
       BackUpDate  :BString;  {Backup date}
       DiskOfFiles :Byte;  {Number of the disk that contains the files}
       FilesOffset :LongInt; {Offset of this disk (Start Point in bytes)}
   End;

   {The structure for every file that backup-ed in the disks}
   {We can find these informations at the end of the backuped diskfile}
   {The start of this record can obtained from the header's eternal field}
   {FilesOffset.                                                         }
   DiskFileStruc = Record
        Path      :BString;  {Full pathname including the filename}
        Size      :LongInt; {size of the file}
   End;

   {Every disk contain this struc at the top of the buckup-ed file unless}
   {the First Disk.                                                      }
   HeadForEachDisk = Record
        Sign       :BString; {Company's name}
        DiskNum    :Byte;
   End;




Const

   NoDirs       :Boolean = False;
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

   DestDrive    :Byte;
   BackupName   :String;
   UsePassWord  :Byte;
   PassWord     :String[50];
   {***************************}
   R            :ProgressBar;
   DiskBuffer   :Pointer;
   DiskCount    :Byte;
   FileHead     :HeadFileStruc;
   DiskFile     :DiskFileStruc;
   DiskHead     :HeadForEachDisk;
   BackUpFile   :File;
   TIOResult    :Integer;
   ReadedBytes  :Word;
   SFiles       :File;
   SFilesSize   :LongInt;
   SizeDif      :LongInt;
   Path         :String;


   MyApp        :TMyApp;

Procedure HaltApplication; forward;


Procedure ConvertString(Str :String; Var BTypeString :BString);
Var
   I            :Byte;
   Str1         :String[1];
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


{$F+}
Procedure HandleError;
Begin
     Event:=CmMainMenu;
     MyApp.HandleCommand;
End;
{$F-}


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
     SelectedPaths.FindText(CurrentPath+'\'+FileName);
     IF SelectedPaths.GetText = (CurrentPath+'\'+FileName) Then
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

          IF CheckWildCard(IncludeMask,CurrentFile) = True Then
          Begin
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
      EnableWinCommand([cmBackupStart])
   Else
      DisableWinCommand([cmBackupStart]);
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
      EnableWinCommand([cmBackupStart])
   Else
      DisableWinCommand([cmBackupStart]);
End;

Procedure TMyApp.ReadError;
Begin
    IF CriticalError=0 Then
       ErrorMessage('ä·ü¶™ °ò´· ´û§ ò§·ö§‡©û ´‡§ õúõ¶£‚§‡§.'+#10+
                    'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                    'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk)
    Else
       ErrorMessage('ä·ü¶™ °ò´· ´û§ ò§·ö§‡©û ´‡§ õúõ¶£‚§‡§.'+#10+
                    'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                    'Dos Critical Error :'+CriticalErrorMessage,bfOk);

    ErrorProcessPtr:=@HandleError;
    Release(DiskBuffer);
{$I-}
    Close(BackUpFile);
    Close(SFiles);
{$I+}
    TIOResult:=$FF;
End;


Procedure TMyApp.WriteError;
Begin
    IF CriticalError=0 Then
       ErrorMessage('ä·ü¶™ °ò´· ´û§ úöö®ò≠„ ´‡§ õúõ¶£‚§‡§.'+#10+
                    'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                    'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk)
    Else
       ErrorMessage('ä·ü¶™ °ò´· ´û§ úöö®ò≠„ ´‡§ õúõ¶£‚§‡§.'+#10+
                    'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                    'Dos Critical Error :'+CriticalErrorMessage,bfOk);

    ErrorProcessPtr:=@HandleError;
    Release(DiskBuffer);
{$I-}
    Close(BackUpFile);
    Close(SFiles);
{$I+}
    TIOResult:=$FF;
End;


Procedure WriteBackupFile;
Begin

{$I-}
     SizeDif:=0;
     BlockRead(SFiles,DiskBuffer^,$FFFF,ReadedBytes);
     TIOResult:=IOResult;
     IF TIOResult <> 0 Then
     Begin
         MyApp.ReadError;
         Exit;
     End;
     BlockWrite(BackupFile,DiskBuffer^,$FFFF,ReadedBytes);
     SizeDif:=ReadedBytes;
     TIOResult:=IOResult;
     IF (TIOResult <> 0) or (ReadedBytes < $FFFF) Then
     Begin
         SFilesSize:=DiskFree(DestDrive);
         IF SFilesSize < $FFFF Then
         Begin
             SizeDif:=$FFFF-SFilesSize;
             BlockWrite(BackupFile,DiskBuffer^,SFilesSize,ReadedBytes);
             TIOResult:=IOResult;
             IF (TIOResult <> 0) or (ReadedBytes < SFilesSize) Then
             Begin
               MyApp.WriteError;
               Exit;
             End;
             Close(BackupFile);
             TIOResult:=IOResult;
             IF TIOResult <> 0 Then
             Begin
                 MyApp.WriteError;
                 Exit;
             End;
             TIOResult:=$FF;
             MyApp.InsertNextDisk;
             Exit;
         End
         Else
         Begin
           MyApp.WriteError;
           Exit;
         End;
     End;
{$I+}
End;

Procedure WriteRestBytesInBackupFile;
Var
   ActualRestSize       :Word;
Begin
{$I-}
     SizeDif:=0;
     BlockRead(SFiles,DiskBuffer^,$FFFF,ActualRestSize);
     TIOResult:=IOResult;
     IF TIOResult <> 0 Then
     Begin
         MyApp.ReadError;
         Exit;
     End;
     BlockWrite(BackupFile,DiskBuffer^,ActualRestSize,ReadedBytes);
     TIOResult:=IOResult;
     IF (TIOResult <> 0) or (ReadedBytes <> ActualRestSize) Then
     Begin
         SFilesSize:=DiskFree(DestDrive);
         IF SFilesSize < ActualRestSize Then
         Begin
             SizeDif:=ActualRestSize-SFilesSize;
             BlockWrite(BackupFile,DiskBuffer^,SFilesSize,ReadedBytes);
             TIOResult:=IOResult;
             IF (TIOResult <> 0) or (ReadedBytes < SFilesSize) Then
             Begin
               MyApp.WriteError;
               Exit;
             End;
             Close(BackupFile);
             TIOResult:=IOResult;
             IF TIOResult <> 0 Then
             Begin
                 MyApp.WriteError;
                 Exit;
             End;
             TIOResult:=$FF;
             MyApp.InsertNextDisk;
             Exit;
         End
         Else
         Begin
           MyApp.WriteError;
           Exit;
         End;
     End;
{$I+}
End;

Procedure BackupMarkedFiles;
Var
   Dir,Name,
   Ext          :String;
   I            :Word;
   DirInfo      :SearchRec;
   BStr         :BString;
   DiskSize     :LongInt;
Begin

{$I-}
      IF TotalFiles > 0 Then
      Begin
           IF (SelectedPaths.Text = Nil) Then
           Begin
               Close(BackupFile);
               HaltApplication;
           End;

           Path:=SelectedPaths.GetText;
           FindFirst(Path,Archive,DirInfo);
           ConvertString(Path,BStr);
           DiskFile.Path:=BStr;
           DiskFile.Size:=DirInfo.Size;
           DiskSize:=DiskFree(DestDrive);
           IF DiskSize < SizeOf(DiskFile) Then
           Begin
              Close(BackUpFile);
              MyApp.InsertNextDisk;
              Exit;
           End;
           SizeDif:=SizeOf(DiskSize);
           BlockWrite(BackupFile,DiskFile,SizeOf(DiskFile),ReadedBytes);
           TIOResult:=IOResult;
           IF (TIOResult <> 0) or (ReadedBytes <> SizeOf(DiskFile)) Then
           Begin
             MyApp.WriteError;
             Exit;
           End;
      End;

      Repeat
         IF (SelectedPaths.Text <> Nil) and (TotalFiles > 0) Then
         Begin
            Path:=SelectedPaths.GetText;
            Dec(TotalFiles);
            FSplit(Path,Dir,Name,Ext);
            SizeDif:=0;
            Assign(SFiles,Path);
            Reset(SFiles,1);
            TIOResult:=IOResult;
            IF TIOResult = 0 Then
            Begin
               Status:=0;
               SFilesSize:=FileSize(SFiles);
               IF SFilesSize > $FFFF Then
               Begin
                   For I:=1 to (SFilesSize div $FFFF) do
                   Begin
                      WriteBackupFile;
                      IF TIOResult = $FF Then {Disk full}
                         Exit;
                   End;

                   IF (SFilesSize mod $FFFF) <> 0 Then
                   Begin
                      WriteRestBytesInBackUpFile;
                      IF TIOResult=$FF Then   {Disk Full}
                         Exit;
                   End;
               End
               Else
               Begin
                   WriteRestBytesInBackUpFile;
                   IF TIOResult=$FF Then {Disk full}
                      Exit;
               End;
            End
            Else
              Status:=1;

            IF Status=0 Then
            Begin
              FindFirst(Path,Archive,DirInfo);
              TotalSize:=TotalSize-(DirInfo.Size div 1024);
              Close(SFiles);
              TIOResult:=IOResult;
              IF TIOResult <> 0 Then
              Begin
                  MyApp.WriteError;
                  Exit;
              End;
            End;

            MyApp.SetParameters(TotalSize,Name+Ext,Status,TotalFiles,Path);
            R.UpDateProgressBar(1);
         End
         Else
         IF (SelectedPaths.Text = Nil) And (TotalFiles > 0)Then
         Begin
             Close(BackupFile);
             HaltApplication;
         End;
{$I+}
         IF BiosKeyPressed Then
         Begin
           ReadKbd(Ctrl,Ascii);
           IF (Ctrl=Chr(27)) Then
              UsrInterrupt:=True;
         End;

         SelectedPaths.NextText;

      Until (TotalFiles=0) or (UsrInterrupt=True);

      IF UsrInterrupt=True Then
      Begin
          Event:=cmCancelBackup;
          MyApp.HandleCommand;
          Exit;
      End;

{$I-}
      Close(BackUpFile);
{$I+}
      TIOResult:=IOResult;
      IF TIOResult <> 0 Then
      Begin
          MyApp.WriteError;
          Exit;
      End;
      R.FullProgressBar;
      Release(DiskBuffer);
      UsrInterrupt:=False;
      Event:=cmTaskCompleted;
      MyApp.HandleCommand;

End;

Procedure TMyApp.SetParameters(Size :LongInt;Name :String;Status :Byte;Files :LongInt;Path :String);
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
    Case Status of
         0:S:='âò§‚§ò ¢·ü¶™';
         1:S:='ä·ü¶™';
    End;
    WriteWindow(XCoord,13,SetString(S,12,RightJustify));
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


Procedure TMyApp.StartBackup;

Var
   Status       :Byte;
   CFile        :String[12];
   I            :Word;
   S            :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(5,3,75,21,'É†òõ†°ò©Âò Backup ©´¶§ ¶õûöÊ '+Chr((DestDrive-1)+65)+':',WinChars+OpenFx+CloseFx+
                          CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;
      Win^.CloseCommand:=cmMainMenu;

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
      R.InitProgressBar(3,13,30,0,TotalFiles);

      WriteTextColor:=15;
      WriteTextBackGround:=5;
      WriteWindow(3,11,'ëÁ§¶¢¶ ò®ÆúÂ‡§ [      ]');

      WriteTextColor:=15;
      WriteTextBackGround:=4;
      WriteWindow((GetWindowMaxX div 2)+3+1,11,'ë.ã‚öúü¶™       [         ] KB');
      WriteWindow((GetWindowMaxX div 2)+3+1,12,'Ä®ÆúÂ¶ ß®¶™ Ñ•. [            ]');
      WriteWindow((GetWindowMaxX div 2)+3+1,13,'âò´·©´. Ä®ÆúÂ¶¨ [            ]');

      UsrInterrupt:=False;
      WriteTextBackGround:=WinTextBackGround;
      WriteTextColor:=14;
      CentreWinMessage(GetWindowMaxY,'è·´û©ú ´¶ ß¢„°´®¶ Esc ö†ò ò°Á®‡©û');

      Status:=0;
      I:=1;
      DiskCount:=1;
      SetParameters(TotalSize,'',Status,TotalFiles,'');

      Str(DiskCount,S);
      IF Length(S) < 3 Then
        For I:=Length(S)+1 to 3 do
              S:='0'+S;

      Assign(BackupFile,Chr((DestDrive-1)+65)+':'+BackupName+'.'+S);
{$I-} Rewrite(BackUpFile,1); {$I+}
      TIOResult:=IOResult;
      IF CriticalError<>0 Then
      Begin
          ErrorMessage('Ü ©¨©°úÁû ßò®¶¨©†·ùú† °·ß¶†¶ ß®Êô¢û£ò.'+#10+
                       'Dos Critical Error :'+CriticalErrorMessage,bfOk);
          ErrorProcessPtr:=@HandleError;
          Exit;
      End
      Else
      IF TIOResult <> 0 Then
      Begin
          ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                       'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);
          ErrorProcessPtr:=@HandleError;
          Exit;
      End;

      SFilesSize:=DiskFree(DestDrive);
      IF (SFilesSize div 1024) < 10 Then
      Begin
          ErrorMessage('Éú§ ¨ß·®Æú† ò®°ú´Ê™ ÆÈ®¶™ ©´¶§ ¶õûöÊ.'+#10+
                       'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.',bfOk);
          ErrorProcessPtr:=@HandleError;
          Exit;
      End;


      If MaxAvail < $FFFF Then
      Begin
          ErrorMessage('éÆ† ò®°ú´„ £§„£û ö†ò ´û õû£†¶¨®öÂò ´¶¨'+#10+
                       'File data area.Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.',bfOk);
          ErrorProcessPtr:=@HandleError;
{$I-}
          Close(BackUpFile);
{$I+}
          TIOResult:=IOResult;
          Exit;
      End
      Else
         GetMem(DiskBuffer,$FFFF);

      ConvertString('Digital Toolworks backup file (c) Thessaloniki 1996'+#13+#$1A,FileHead.Sign);
      FileHead.TotalSize:=TotalSize;
      FileHead.TotalFiles:=TotalFiles;
{$I-} BlockWrite(BackupFile,FileHead,SizeOf(FileHead),ReadedBytes); {$I+}
      TIOResult:=IOResult;
      IF (TIOResult <> 0) or (ReadedBytes < SizeOf(FileHead)) Then
      Begin
          ErrorMessage('ä·ü¶™ °ò´· ´û§ úöö®ò≠„ ´û™ úß†°ú≠ò¢Âõò™ ©´¶§'+#10+
                       '¶õûöÊ.Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                       'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);
          ErrorProcessPtr:=@HandleError;
{$I-}
          Close(BackUpFile); {$I+}
          TIOResult:=IOResult;
          Exit;
      End;

      SelectedPaths.GoStart;
      BackUpMarkedFiles;
End;

Procedure TMyApp.ContinueBackUpInNextVol;
Var
   I            :Word;
   S            :String[3];
   FP           :LongInt;
   DiskSize     :LongInt;
Begin

   DiskSize:=DiskFree(DestDrive);
   IF (DiskSize div 1024) < 10 Then
   Begin
       Event:=cmNextVol;
       HandleCommand;
       Exit;
   End;

   Inc(DiskCount); {Increment disks}
   Str(DiskCount,S);
   IF Length(S) < 3 Then
     For I:=Length(S)+1 to 3 do
           S:='0'+S;

   Assign(BackupFile,Chr((DestDrive-1)+65)+':'+BackupName+'.'+S);
{$I-} Rewrite(BackUpFile,1); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin

       ErrorMessage('ä·ü¶™ °ò´· ´¶ ·§¶†ö£ò ´¶¨ ò®ÆúÂ¶¨.'+#10+
                    'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);
       ErrorProcessPtr:=@HandleError;
       Exit;
   End;

   ConvertString('Digital Toolworks backup file (c) Thessaloniki 1996'+#13+#$1A,DiskHead.Sign);
   DiskHead.DiskNum:=DiskCount;
   BlockWrite(BackUpFile,DiskHead,SizeOf(DiskHead),ReadedBytes);
   TIOResult:=IOResult;
   IF (TIOResult<>0) or (ReadedBytes <> SizeOf(DiskHead)) Then
   Begin
       ErrorMessage('ä·ü¶™ °ò´· ´û§ úöö®ò≠„ ´‡§ õúõ¶£‚§‡§ ´û™ úß†°ú≠ò¢Âõò™.'+#10+
                    'Ü õ†òõ†°ò©Âò backup ò°Á®‡§ú´ò†.'+#10+
                    'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);
       ErrorProcessPtr:=@HandleError;
{$I-}
       Close(BackUpFile);
       Close(SFiles);
{$I+}
       TIOResult:=IOResult;
       Exit;
   End;


   IF SizeDif <> 0 Then
   Begin
{$I-}
     BlockWrite(BackupFile,Mem[Seg(DiskBuffer^):Ofs(DiskBuffer^)+SizeDif],SizeDif,ReadedBytes); {$I+}
     TIOResult:=IOResult;
     IF (TIOResult <> 0) or (ReadedBytes < SizeDif) Then
     Begin
       WriteError;
       Exit;
     End;

{$I-}
     FP:=FilePos(SFiles);
{$I+}
     TIOResult:=IOResult;
     IF TIOResult <> 0 Then
     Begin
         MyApp.ReadError;
         Exit;
     End;

     SFilesSize:=FileSize(SFiles);
     SFilesSize:=SFilesSize-FP;
     IF SFilesSize > $FFFF Then
     Begin
         For I:=1 to (SFilesSize div $FFFF) do
         Begin
            WriteBackupFile;
            IF TIOResult = $FF Then
               Exit;
         End;

         IF (SFilesSize mod $FFFF) <> 0 Then
         Begin
             WriteRestBytesInBackUpFile;
             IF TIOResult = $FF Then
                Exit;
         End;
     End
     Else
     Begin
        WriteRestBytesInBackUpFile;
        IF TIOResult = $FF Then
           Exit;
     End;
   End;

   BackupMarkedFiles;
End;

Procedure TMyApp.UserAbort;
Begin
{$I-}
    UsrInterrupt:=False;
    Close(BackUpFile); {$I+}
    TIOResult:=IOResult;
    CloseWindow;
    Event:=cmMainMenu;
    HandleCommand;
End;

Procedure TMyApp.ContinueBackup;
Begin
    CloseWindow;
    UsrInterrupt:=False;
    BackupMarkedFiles;
End;

Procedure TMyApp.CancelBackup;
Begin
    UsrInterrupt:=False;

    WinTextColor:=15;
    WinTextBackGround:=4;
    OpenWindow(19,7,61,17,'',WinChars+OpenFx+CloseFx+Movement+Shadow);
    Win^.CloseCommand:=cmContinueBackup;
    If HeapErrorCode <> 0 Then
       HaltApplication;

    WriteTextColor:=14;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'Ü É†òõ†°ò©Âò õ†ò°Êß´û°ú òß¶ ´¶§ Æ®„©´û.');

    WriteTextColor:=15;
    CentreWinMessage(4,'á‚¢ú†™ §ò ò°¨®È©‡ ´û§ õ†òõ†°ò©Âò');
    CentreWinMessage(5,'„ §ò ©¨§úÆÂ©‡;');

    AssignXY(2,GetWindowMaxY-1,0,0);
    InitButton('   ~Ä°Á®‡©û   ',cmUserAbort,PushButton,BfDefault);

    AssignXY(27,GetWindowMaxY-1,0,0);
    InitButton('   ~ë¨§‚Æú†ò  ',cmContinueBackup,PushButton,BfNormal);
End;


Procedure TMyApp.TaskCompleted;
Begin
    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(15,8,65,15,'> Ñ†õ¶ß¶Âû©û <',WinChars+OpenFx+CloseFx+Movement+Shadow+WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    SizeDif:=0;

    TotalFiles:=0;
    TotalSize:=0;

    WriteTextColor:=1;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'Ü õ†òõ†°ò©Âò ¶¢¶°¢û®Èüû°ú úß†´¨ÆÈ™');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmInitMain,PushButton,BfDefault);

End;


Procedure TMyApp.InsertDisk;
Begin
    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(15,8,65,15,'> Ñ†õ¶ß¶Âû©û <',WinChars+OpenFx+CloseFx+Movement+Shadow+WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    WriteTextColor:=1;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'èò®ò°ò¢È ô·¢´ú £†ò õ†©°‚´ò ©´¶§ ¶õûöÊ '+Chr((DestDrive-1)+65)+':');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmDoBackup,PushButton,BfDefault);
End;


Procedure TMyApp.InsertNextDisk;
Begin
    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(15,8,65,15,'> Ñ†õ¶ß¶Âû©û <',WinChars+OpenFx+CloseFx+Movement+Shadow+WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    WriteTextColor:=1;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'èò®ò°ò¢È ô·¢´ú ´û§ úßÊ£ú§û õ†©°‚´ò ©´¶§ ¶õûöÊ '+Chr((DestDrive-1)+65)+':');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmNextVol,PushButton,BfDefault);
End;

Procedure TMyApp.InformError;
Begin
    WinTextColor:=15;
    WinTextBackGround:=4;
    OpenWindow(13,8,67,15,'> Ñ†õ¶ß¶Âû©û <',WinChars+OpenFx+CloseFx+CloseIcon+Movement+Shadow+WinCharsWindow);
    IF HeapErrorCode <> 0 Then
       HaltApplication;

    Win^.CloseCommand:=cmCloseWin;

    WriteTextColor:=14;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'èò®¶¨©†·©´û°ú ¢·ü¶™ °ò´· ´û§ ò§·ö§‡©û ´‡§ ò®ÆúÂ‡§.');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmCloseWin,PushButton,BfDefault);
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
                        SelectedPaths.DeInitText;
                        MainMenu;
                    End;
      CmOptions    :Begin
                        CloseWindow;
                        Options;
                    End;
      cmAbout      :About;
      cmCloseWin   :CloseWindow;
      cmReport     :Begin
                       IF CheckBoxActive=1 Then
                          EnableWinCommand([cmReportPath,cmFileReport,cmPrnReport])
                       Else
                          DisableWinCommand([cmReportPath,cmFileReport,cmPrnReport]);
                    End;
      cmBackup      :Begin
                          CloseWindow;
                          Er:=ReadDiskStruc;
                          SelectedPaths.DeInitText;
                          Backup;
                          IF Er<>0 Then
                             InformError;
                     End;
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
                         BackUp;
                         IF Er<>0 Then
                            InformError;

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
                                EnableWinCommand([cmBackupStart])
                             Else
                                DisableWinCommand([cmBackupStart])
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
      cmBackupName   :BackupName:=InputLineStr;
      cmBackupStart  :Begin
                         CloseWindow;
                         IF DestDrive <= 2 Then
                            InsertDisk
                         Else
                         IF UsePassWord = 0 Then
                            StartBackup
                         Else
                            InsertPassWord;
                      End;
      cmDoBackup     :Begin
                         CloseWindow;
                         IF UsePassWord = 0 Then
                            StartBackup
                         Else
                            InsertPassWord;
                      End;
      cmPassWord     :UsePassWord:=CheckBoxActive;
      cmSetPassWord  :Begin
                         CloseWindow;
                         PassWord:=InputLineStr;
                         For I:=1 to Length(PassWord) Do
                             PassWord[I]:=UpCase(PassWord[I]);
                         StartBackUp;
                      End;
      cmNextVol      :Begin
                         CloseWindow;
                         ContinueBackUpInNextVol;
                      End;
      cmTaskCompleted:TaskCompleted;
      cmUserAbort    :UserAbort;
      cmContinueBackup:ContinueBackup;
      cmCancelBackUp  :CancelBackup;
      cmInitMain      :Begin
                          CloseWindow;
                          Event:=cmMainMenu;
                          HandleCommand;
                       End;
   End;
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

Procedure TMyApp.Backup;
Var
   I    :Byte;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(1,2,80,24,'Backup',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;
      Win^.CloseCommand:=cmMainMenu;

      WriteTextColor:=11;
      WriteTextBackGround:=WinTextBackGround;

      HorizontalLine(2,GetWindowMaxY-2,GetWindowMaxX-1,196);


      BackUpName:='Backup';
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

      InitText;
      IF MaxDrives <> 0 Then
         For I:=1 to MaxDrives do
             InsertText(' '+Chr(WCDriveA1)+Chr(WCDriveA2)+Chr(WCDriveA3)+' Drive '+Chr((I-1)+65)+' ',$FF,$FF);
      IF MaxHardDisks <> 0 Then
         For I:=1 to MaxHardDisks do
             InsertText(' '+Chr(WCDriveC1)+Chr(WCDriveC2)+Chr(WCDriveC3)+' Disk  '+Chr(65+MaxDrives+(I-1))+' ',$FF,$FF);

      AssignXY(25,3,41,3+MaxDrives+MaxHardDisks);
      InitDropDown(cmDestDrive);
      ShowDropDownText(GeneralHeadText,GeneralTailText,DestDrive);
      DropDownLabel(25,2,'~Destination Drive');
      DropDownHelp('',0);


      AssignXY(47,3,GetWindowMaxX-1,3);
      InitInputLine(cmBackupName,8,BackupName);
      InputLineLabel(47,2,'~é§¶£ò');

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
      InitButton('    ~Ñ§´·•ú†    ',CmBackUpStart,PushButton,BfNormal);

      IncludeMask:='*.*';
      AssignXY(19,GetWindowMaxY-1,0,0);
      InitButton('    ~Include    ',CmAskMask,PushButton,BfNormal);

      ExcludeMask:='*.*';
      AssignXY(36,GetWindowMaxY-1,0,0);
      InitButton('    E~xclude    ',CmAskExMask,PushButton,BfNormal);

      AssignXY(53,GetWindowMaxY-1,0,0);
      InitButton('    ~Ä°Á®‡©û    ',CmMainMenu,PushButton,BfDefault);

      IF UsrInterrupt Then
         DisableWinCommand([CmBackupStart,CmAskMask,CmAskExMask])
      Else
        DisableWinCommand([CmBackUpStart]);

      SelectedPaths.InitText;
      CurrentPath:=Chr((CurrentDrv-1)+65)+':';
      TotalFiles:=0;
      TotalSize:=0;
      IncludeMask:='*.*';
      ExcludeMask:='*.*';

End;

Procedure TMyApp.Options;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(10,3,70,22,'Ñß†¢¶ö‚™',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      Win^.CloseCommand:=cmMainMenu;

      WriteTextColor:=14;
      WriteTextBackGround:=Win^.WTextBackGround;

      TextBox(1,2,40,GetWindowMaxY-1,SingleLines);

      WriteTextColor:=15;

      AssignXY(2,3,0,0);
      InitCheckBox('~ë¨£ßÂú©û õúõ¶£‚§‡§ (LWZ)',cmCompress,BfNormal);

      AssignXY(2,4,0,0);
      InitCheckBox('Ñ†©òö‡ö„ ~°‡õ†°¶Á ',cmPassWord,BfNormal);

      AssignXY(2,5,0,0);
      InitCheckBox('Ñ~•¶õ¶™ £ú´ò ´¶ ´‚¢¶™ ´¶¨ Backup',NoCm,BfNormal);

      AssignXY(2,6,0,0);
      InitCheckBox('~Voice and Sound',NoCm,BfDefault);

      AssignXY(2,7,0,0);
      InitCheckBox('~Ä§ò≠¶®ò õ†òõ†°ò©Âò™',cmReport,BfNormal);

      AssignXY(3,10,37,10);
      InitInputLine(CmReportPath,128,'C:');
      InputLineLabel(3,9,'~É†òõ®¶£û ò§ò≠¶®·™');


      AssignXY(2,12,2,12);
      InitRadioButton(NewRItem('Ñ•¶õ¶™ ú°´¨ß‡´„ ~LPT 1',Nocm,'',0,BfDefault,
                      NewRItem('Ñ•¶õ¶™ ú°´¨ß‡´„ L~PT 2',Nocm,'',0,BfNormal,
                      Nil)));

      AssignXY(2,15,2,15);
      InitRadioButton(NewRItem('Ñ•¶õ¶™ ©ú ~ò®ÆúÂ¶',cmFileReport,'',0,BfDefault,
                      NewRItem('Ñ•¶õ¶™ ©ú ~ú°´¨ß‡´„',cmPrnReport,'',0,BfNormal,
                      Nil)));



      AssignXY(GetWindowMaxX-Length('    ~Ñ§´·•ú†    ')-1,3,0,0);
      InitButton('    ~Ñ§´·•ú†    ',CmMainMenu,PushButton,BfDefault);

      AssignXY(GetWindowMaxX-Length('    ~Ñ§´·•ú†    ')-1,5,0,0);
      InitButton('    ~Ä°Á®‡©û    ',CmMainMenu,PushButton,BfNormal);

      DisableWinCommand([cmCompress,cmReportPath,cmFileReport,cmPrnReport]);

End;

Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(12,2,66,23,'ëÆú´†°·',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmMainMenu;
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'Quick Backup ');
      CentreWinMessage(3,'‚°õ¶©û 1.00a  * Evaluation * ');
      CentreWinMessage(5,'(c) Copyright 1993,96  by Digital ToolWorks');
      WriteTextColor:=10;
      CentreWinMessage(7,'<< This program is NOT a Public Domain so any use >>');
      CentreWinMessage(8,'<< wihtout the written permission is illegal.>>');


      WriteTextColor:=14;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,12,GetWindowMaxX,17,' Quick Hello ? ',14);

      WriteTextColor:=1;
      CentreWinMessage(14,'˚ ìß·®Æ¶¨§ '+KBytes+'KB ©´¶ ©Á©´û£ò ú¢úÁüú®ò.');
      CentreWinMessage(15,'˚ Ü ‚°õ¶©û ´¶¨ Dos úÂ§ò† '+DosVer);


      AssignXY((GetWindowMaxX-Length('  ~Ñ§´·•ú† ')) div 2,GetWindowMaxY-1,0,0);
      InitButton('  ~Ñ§´·•ú† ',CmClosewin,PushButton,BfDefault);
      ButtonHelp('',0);
End;


Procedure TMyApp.MainMenu;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(8,5,72,21,'Quick Backup',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      Win^.CloseCommand:=cmQuit;

      AssignXY(2,2,0,0);
      InitButton('        ~Backup         ',cmBackup,PushButton,BfDefault);

      AssignXY(2,4,0,0);
      InitButton('         ~Restore       ',NoCm,PushButton,BfNormal);

      AssignXY(2,6,0,0);
      InitButton('        ~Ñß†¢¶ö‚™       ',CmOptions,PushButton,BfNormal);

      AssignXY(2,8,0,0);
      InitButton('        ~Å¶„üú†ò        ',NoCm,PushButton,BfNormal);

      AssignXY(2,10,0,0);
      InitButton('        ~ëÆú´†°·        ',CmAbout,PushButton,BfNormal);



      AssignXY((GetWindowMaxX-Length(' >>   Ñ~•¶õ¶™  òß¶ ´¶ ß®Êö®ò££ò   << ')) div 2,14,0,0);
      InitButton(' >>   Ñ~•¶õ¶™  òß¶ ´¶ ß®Êö®ò££ò   << ',CmQuit,PushButton,BfNormal);

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;

      WriteWindow(28,2,'Äß¶ü„°ú¨©û (backup) ´‡§ õúõ¶£‚§‡§.');
      WriteWindow(28,4,'Ñßò§·°´û©û (restore) ´‡§ õúõ¶£‚§‡§.');
      WriteWindow(28,6,'ê¨ü£Â©ú†™ ß®¶ö®·££ò´¶™.');
      WriteWindow(28,8,'On line ô¶„üú†ò.');
      WriteWindow(28,10,'è¢û®¶≠¶®Âú™ °ò´ò©°ú¨ò©´„.');
      WriteWindow(2,12,'ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');

End;

Procedure TMyApp.InsertPassWord;
Begin
      WinTextColor:=15;
      WinTextBackGround:=4;
      OpenWindow(10,3,70,20,'â‡õ†°Ê™',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      Win^.CloseCommand:=cmMainMenu;
      Win^.EnterCommand:=CmSetPassWord;

      WriteTextColor:=14;
      WriteTextBackGround:=WinTextBackGround;

      CentreWinMessage(2,'èêéëéïÜ');
      WriteTextColor:=15;

      CentreWinMessage(4,'ëú ßú®Âß´‡©û ß¶¨ •úÆ·©ú´ú ´¶§ °‡õ†°Ê ß®Ê©ôò©û™');
      CentreWinMessage(5,'úÂ§ò† òõÁ§ò´¶§ §ò ò§ò°´ûü¶Á§ ´ò ò®ÆúÂò');
      CentreWinMessage(6,'°ò´· ´û§ õ†òõ†°ò©Âò restore.é °‡õ†°Ê™ ò§òö®·≠ú´ò†');
      CentreWinMessage(7,'©´û§ ò§ò≠¶®· ß¶¨ öÂ§ú´ò† °ò´· ´û õ†·®°ú†ò ´û™ õ†òõ†°ò©Âò™');
      CentreWinMessage(8,'backup úò§ ‚Æú´ú ú§ú®ö¶ß¶†û£‚§û ´û§ úß†¢¶ö„ report ©´¶');
      CentreWinMessage(9,'£ú§¶Á ´‡§ úß†¢¶öÈ§ !!.');
      CentreWinMessage(10,'è·´û©ú ´û§ õ†ò´òö„ <Ä°Á®‡©û> ö†ò ò°Á®‡©û ´û™ Ê¢û™');
      CentreWinMessage(11,'õ†òõ†°ò©Âò™.');

      AssignXY(3,13,GetWindowMaxX-3,12);
      InitInputLine(NoCm,50,'');
      InputLineLabel(3,12,'~â‡õ†°Ê™');

      AssignXY(25,GetWindowMaxY-1,2,0);
      InitButton('    ~Ñ§´·•ú†    ',CmSetPassWord,PushButton,BfDefault);

      AssignXY(43,GetWindowMaxY-1,0,0);
      InitButton('    ~Ä°Á®‡©û    ',CmMainMenu,PushButton,BfNormal);

      PassWord:='';


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
    Writeln('QBackup ver 1.00a   * Evaluation * ');
    Writeln('(c) Copyright 1993,96  by Digital ToolWorks');
    Writeln;
    Writeln('An unexpected error has occured that program can not handle.');
    Writeln('Refer to your manual for any recommendations.');
    Writeln;
    Writeln('Debug Info:');
    Writeln('    HeapErrorCode       =',HeapErrorCode:2);
    Writeln('    ActiveErrorWindow   =',ActiveErrorWindow);
    Halt(0);
End;
{$F-}

Begin
    DosFonts:=True;
    SetBackGround:=False;
    AllowHelpCtx:=False;
    SelectedPaths.InitText;
    CheckFDrives;
    ErrorWinUserFarCallPtr:=@HaltApplication;
    UsePassWord:=0;

    MyApp.Init;
    MyApp.MainMenu;
    MyApp.Run;
    MyApp.Done;
End.
