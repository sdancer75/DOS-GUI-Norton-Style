Uses WindowsObj,VarConstObj,PullDnMenus,WinObjA,WinObjB,WinInit,GeneralObj,
      WinApplObj,ErrorDlg,Helpobj,TopicHlp,Crt,Dos;

Const
    cmQuit        = 1;
    cmCloseWin    = 2;
    cmStart       = 3;
    CmAbout       = 4;
    cmRealExit    = 5;
    CmPage1       = 6;
    CmPage2       = 7;
    CmGenerParam  = 8;
    cmPrinter     = 9;
    cmDemoWin     = 10;
    cmPassWords   = 11;
    cmHlpCatalog  = 12;
    cmHlpMouse    = 13;
    cmHlpKeyb     = 14;
    cmHlpMoveWin  = 15;
    cmHlpGlassary = 16;
    cmHlpProblems = 17;
    cmSetReligions= 18;
    cmSetArea     = 19;
    cmSetOccupy   = 20;
    cmSetNative   = 21;
    cmUsesOfConfirmations = 22;

    cmNo1       = 30;


{************************************************************************}
{Citizen                                                                 }
{************************************************************************}

Type

   TMyApp = Object (Application)
      Procedure InitMenuBar; Virtual;
      Procedure HandleCommand; Virtual;

      Procedure StartWindow;
      Procedure About;
      Procedure Quit;


      Procedure Merides;
      Procedure Page1;
      Procedure Page2;
      Procedure GeneralParametres;
      Procedure Printer;
      Procedure DemoWin;
      Procedure PassWords;
      Procedure HlpCatalog;
      Procedure SetReligions;
      Procedure SetArea;
      Procedure SetOccupy;
      Procedure SetNative;
      Procedure UsesOfConfirmations;
   End;

Var
    Day,Month,Year,DOW :Word;
    DayS,MonthS,YearS  :String[4];


Procedure TMyApp.HlpCatalog;
Begin
    KBScanCode:=59;
    KBAsciiCode:=0;
    RunHelp;
End;

Procedure TMyApp.SetReligions;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,6,70,20,'„ ©˜šàšã Ÿ¨©¡œç£˜«¦ª',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      InitText;
      InsertText('No Texts',$FF,$FF);

      AssignXY(2,2,30,GetWindowMaxY-3);
      R:=InitMenuBox('~‡¨©¡œå˜',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(35,3,57,3);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã Ÿ¨©¡œç£˜«¦ª.',0);
      InputLineLabel(35,2,'~„ ©˜šàšã :');


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(15,GetWindowMaxY-1,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(28,GetWindowMaxY-1,0,0);
      InitButton('  ~„§æ£œ¤¦ ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§æ£œ¤ œ ©˜šàšã.',0);

      AssignXY(41,GetWindowMaxY-1,0,0);
      InitButton(' ~¦ãŸœ ˜  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('¦ãŸœ ˜ on-line.',0);
End;

Procedure TMyApp.SetArea;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,6,70,20,'„ ©˜šàšã Œ¦£é¤',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      InitText;
      InsertText('No Texts',$FF,$FF);

      AssignXY(2,2,30,GetWindowMaxY-3);
      R:=InitMenuBox('~Œ¦£¦å',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(35,3,57,3);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã Œ¦£é¤.',0);
      InputLineLabel(35,2,'~„ ©˜šàšã :');


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(15,GetWindowMaxY-1,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(28,GetWindowMaxY-1,0,0);
      InitButton('  ~„§æ£œ¤¦ ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§æ£œ¤ œ ©˜šàšã.',0);

      AssignXY(41,GetWindowMaxY-1,0,0);
      InitButton(' ~¦ãŸœ ˜  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('¦ãŸœ ˜ on-line.',0);
End;

Procedure TMyApp.SetOccupy;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,6,70,20,'„ ©˜šàšã „§˜ššœ¢£á«à¤',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      InitText;
      InsertText('No Texts',$FF,$FF);

      AssignXY(2,2,30,GetWindowMaxY-3);
      R:=InitMenuBox('~„§áššœ¢£˜',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(35,3,57,3);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã „§˜ššâ¢£˜«¦ª.',0);
      InputLineLabel(35,2,'~„ ©˜šàšã :');


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(15,GetWindowMaxY-1,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(28,GetWindowMaxY-1,0,0);
      InitButton('  ~„§æ£œ¤¦ ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§æ£œ¤ œ ©˜šàšã.',0);

      AssignXY(41,GetWindowMaxY-1,0,0);
      InitButton(' ~¦ãŸœ ˜  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('¦ãŸœ ˜ on-line.',0);
End;

Procedure TMyApp.SetNative;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,6,70,20,'„ ©˜šàšã ¡«ã©ª  Ÿ˜šâ¤œ ˜ª',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      InitText;
      InsertText('No Texts',$FF,$FF);

      AssignXY(2,2,30,GetWindowMaxY-3);
      R:=InitMenuBox('~‰«ã© ˆŸ˜šâ¤œ ˜ª',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(35,3,57,3);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã ¡«ã©ª  Ÿ˜šâ¤œ ˜ª.',0);
      InputLineLabel(35,2,'~„ ©˜šàšã :');


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(15,GetWindowMaxY-1,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(28,GetWindowMaxY-1,0,0);
      InitButton('  ~„§æ£œ¤¦ ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§æ£œ¤ œ ©˜šàšã.',0);

      AssignXY(41,GetWindowMaxY-1,0,0);
      InitButton(' ~¦ãŸœ ˜  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('¦ãŸœ ˜ on-line.',0);
End;

Procedure TMyApp.UsesOfConfirmations;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(5,4,75,23,'•¨ã©œ ª § ©«¦§¦ « ¡é¤',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      InitText;
      InsertText('No Texts',$FF,$FF);

      AssignXY(2,2,GetWindowMaxX,GetWindowMaxY-9);
      R:=InitMenuBox('~œ¨ š¨˜­ã § ©«¦§¦ « ¡é¤',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(2,GetWindowMaxY-6,57,3);
      InitInputLine(NoCm,40,'');
      InputLineHelp('„ ©˜šàšã ¤â¦¬ § ©«¦§¦ « ¡¦ç',0);
      InputLineLabel(2,GetWindowMaxY-7,'~œ¨ š¨˜­ã :');

      AssignXY(2,GetWindowMaxY-4,40,6);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã ˜¤«¦å©« ®¦¬ Ascii ˜¨®œå¦¬',0);
      InputLineLabel(2,GetWindowMaxY-5,'„ ©˜šàšã A~SCII ˜¨®œå¦¬:');


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(15,GetWindowMaxY-1,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(28,GetWindowMaxY-1,0,0);
      InitButton('  ~„§æ£œ¤¦ ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§æ£œ¤ œ ©˜šàšã.',0);

      AssignXY(41,GetWindowMaxY-1,0,0);
      InitButton(' ~¦ãŸœ ˜  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('¦ãŸœ ˜ on-line.',0);
End;


Procedure TMyApp.Quit;
Begin
      WinTextColor:=15;
      WinTextBackGround:=4;
      OpenWindow(20,8,60,16,'„¥¦›¦ª',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'„ ©˜  ©åš¦¬¨¦ª ¦«  Ÿâ¢œ ª ¤˜ ™šœåª');
      CentreWinMessage(3,'©«¦ ¢œ «¦¬¨š ¡æ ©ç©«£˜ ;');

      AssignXY(8,6,0,0);
      InitButton('  ~„¤«á¥œ  ',CmRealExit,PushButton,BfDefault);
      ButtonHelp('„¥¦›¦ª ©«¦ ¢œ «¦¬¨š ¡æ ©ç©«£˜.',0);

      AssignXY(23,6,0,0);
      InitButton('  ~€¡ç¨à© ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„§ ©«¨¦­ã ©«¦ §¨æš¨˜££˜.',0);

End;

Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,5,70,20,'‘®œ« ¡á',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(3,'¨æš¨˜££˜ ƒ£æ«ª   œ¡›¦© 2.1');
      CentreWinMessage(4,'<< Demo version >>');
      CentreWinMessage(6,'Copyright (c) 1996 by Digital ToolWorks');
      WriteTextColor:=14;
      CentreWinMessage(9,'û “§á¨®¦¬¤ '+KBytes+'KB ©«¦ ©ç©«£˜ œ¢œçŸœ¨˜.');
      CentreWinMessage(10,'û † â¡›¦© «¦ Dos œå¤˜  '+DosVer);


      AssignXY(25,13,0,0);
      InitButton('  ~„¤«á¥œ  ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('á«©œ Enter š ˜ ¤˜ ¡¢œå©œ  «¦ §˜¨áŸ¬¨¦.',0);
End;

Procedure TMyApp.Page1;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(3,5,78,22,' ¡¦šœ¤œ ˜¡âª ‹œ¨å›œª (‘œ¢å›˜ 1)',WinChars+OpenFx+CloseFx+CloseIcon+
                           WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,1,74,7,'',14);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,8,74,14,' ‘«¦ ®œå˜ ‚á£¦¬ ',14);



      AssignXY(2,15,0,0);
      InitButton(' << ~„§ ©«¨¦­ã ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ©«¨¦­ã ©«¦ ™˜© ¡æ §˜¨áŸ¬¨¦.',0);

      AssignXY(14,2,36,2);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© ¡˜«¦ ¡å˜ª. ',0);
      InputLineLabel(2,2,'‰~˜«¦ ¡å˜   :');

      AssignXY(51,2,73,2);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© œ§˜ššâ¢£˜«¦ª.',0);
      InputLineLabel(40,2,'~„§áššœ¢£˜ :');

      AssignXY(14,3,36,3);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© Ÿ¨©¡œç£˜«¦ª.',0);
      InputLineLabel(2,3,'~‡¨ã©¡œ¬£˜  :');

      AssignXY(51,3,73,3);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© š ˜ «¤ ¡«ã© «ª œ¢¢¤ ¡ãª  Ÿ˜šâ¤œ ˜ª.',0);
      InputLineLabel(40,3,'‰~«.ˆŸ˜šâ¤.:');

      AssignXY(14,4,36,4);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© ¡«ã©œàª  › æ««˜ª ›£æ«.',0);
      InputLineLabel(2,4,'‰«.~ˆ› æ««.:');

      InitText;
      InsertText('€š¤à©«',$FF,$FF);
      InsertText('‰˜¡ã',$FF,$FF);
      InsertText('‹â«¨ ˜',$FF,$FF);
      InsertText('‰˜¢ã',$FF,$FF);
      InsertText('€¨ ©«',$FF,$FF);

      AssignXY(50,4,73,9);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(40,4,' ¡.‰˜«˜~©«:');
      DropDownHelp('‘«¦ ®œå˜ ¦ ¡¦šœ¤ ˜¡ãª ¡˜«á©«˜©ª',0);

      AssignXY(14,5,24,5);
      InitInputLine(NoCm,8,'');
      InputLineMask('     /  ');
      InputLineHelp('ƒã¢à© «ª £œ¨å›˜ª £œ«˜š¨˜­ãª.',0);
      InputLineLabel(2,5,'‹œ~¨.Mœ«˜š¨.:');

      AssignXY(51,5,73,5);
      InitInputLine(NoCm,20,'');
      InputLineHelp('ƒã¢à© «¢œ­é¤¦¬.',0);
      InputLineLabel(40,5,'’¢â­~à¤¦  :');
      InputLineNumbers;

      AssignXY(14,6,28,6);
      InitInputLine(NoCm,10,'');
      InputLineHelp('ƒã¢à© «¦¬ ˜¨ Ÿ£¦ç ›œ¢«å¦¬ «˜¬«æ««˜ª.',0);
      InputLineLabel(2,6,'€¨.’˜~¬«æ««:');

      {******************}

      AssignXY(14,9,26,9);
      InitInputLine(NoCm,10,'  /  /    ');
      InputLineMask('  /  /  ');
      InputLineHelp('†£œ¨¦£¤å˜ šá£¦¬.',0);
      InputLineLabel(2,9,'~†£œ¨¦£¤å˜ :');

      AssignXY(51,9,73,9);
      InitInputLine(NoCm,20,'');
      InputLineHelp('’æ§¦ª §¨˜š£á«à©ª «¦¬ šá£¦¬.',0);
      InputLineLabel(40,9,'„~š ¤œ     :');

      AssignXY(14,10,17,10);
      InitInputLine(NoCm,1,'');
      InputLineHelp('ƒã¢à© ™˜Ÿ£¦ç.',0);
      InputLineLabel(2,10,'~˜Ÿ£æª     :');
      InputLineNumbers;

      AssignXY(51,10,59,10);
      InitInputLine(NoCm,6,'');
      InputLineHelp('ƒã¢à© §¨á¥œàª.',0);
      InputLineLabel(40,10,'~¨á¥     :');
      InputLineNumbers;

      AssignXY(14,11,24,11);
      InitInputLine(NoCm,5,'');
      InputLineHelp('ƒã¢à© «æ£¦¬.',0);
      InputLineLabel(2,11,'’æ£~¦ª      :');
      InputLineNumbers;

End;

Procedure TMyApp.Page2;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(3,7,78,20,' ¡¦šœ¤œ ˜¡âª ‹œ¨å›œª (‘œ¢å›˜ 2)',WinChars+OpenFx+CloseFx+
                          CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,1,74,10,' ‘«¦ ®œå˜ ƒ ˜š¨˜­ãª ',14);

      AssignXY(2,11,0,0);
      InitButton(' << ~„§ ©«¨¦­ã ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ©«¨¦­ã ©«¦ ™˜© ¡æ §˜¨áŸ¬¨¦.',0);

      InitText;
      InsertText('‚á£¦ª',$FF,$FF);
      InsertText('‡á¤˜«¦ª',$FF,$FF);
      InsertText('‹œ«˜›£æ«œ¬©',$FF,$FF);
      InsertText('ƒ áœ¬¥',$FF,$FF);
      InsertText('“ ¦Ÿœ© ˜',$FF,$FF);
      InsertText('€¤˜š¤é¨ © ’â¡¤¦¬',$FF,$FF);
      InsertText('€§é¢œ ˜ ˆŸ˜šâ¤œ ˜ª',$FF,$FF);
      InsertText('€§æ¡«.„¥éš˜£¦¬ ’â¡¤¦¬',$FF,$FF);
      InsertText('Š¦ §âª € «åœª',$FF,$FF);

      AssignXY(20,2,44,11);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(2,2,'€ «.ƒ ˜š¨˜~­ãª    :');
      DropDownHelp('ƒã¢à© ˜ «å˜ª › ˜š¨˜­ãª.',0);

      AssignXY(20,3,32,3);
      InitInputLine(NoCm,10,'  /  /    ');
      InputLineMask('  /  /  ');
      InputLineHelp('†£œ¨¦£¤å˜ › ˜š¨˜­ãª.',0);
      InputLineLabel(2,3,'~†£œ¨¦£¤å˜ › ˜š  :');

      AssignXY(20,4,63,4);
      InitInputLine(NoCm,40,'');
      InputLineHelp('‰˜«˜š¨˜­ã «ª ˜§æ­˜©ª «¦¬ ƒ£á¨®¦¬.',0);
      InputLineLabel(2,4,'~€§æ­˜© ƒ£á¨®¦¬:');

      AssignXY(2,7,70,7);
      InitInputLine(NoCm,65,'');
      InputLineHelp('‰˜«˜š¨˜­ã §˜¨˜«¨ã©œà¤.',0);
      InputLineLabel(2,6,'~˜¨˜«¨ã©œ ª');

      AssignXY(2,8,70,8);
      InitInputLine(NoCm,65,'');
      InputLineHelp('‰˜«˜š¨˜­ã §˜¨˜«¨ã©œà¤.',0);

      AssignXY(2,9,70,9);
      InitInputLine(NoCm,65,'');
      InputLineHelp('‰˜«˜š¨˜­ã §˜¨˜«¨ã©œà¤.',0);

End;

Procedure TMyApp.Merides;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(2,4,79,23,' ¡¦šœ¤œ ˜¡âª ‹œ¨å›œª (Main)',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      AssignXY(2,17,0,0);
      InitButton(' ~€§¦Ÿã¡œ¬© ',0,PushButton,BfDefault);
      ButtonHelp('€§¦Ÿã¡œ¬© «à¤ ›œ›¦£â¤à¤ ©«¦ ›å©¡¦.',0);

      AssignXY(18,17,0,0);
      InitButton('  ~‘œ¢å›˜ 1  ',CmPage1,PushButton,BfNormal);
      ButtonHelp('‘¬¤â®œ ˜ «ª œ ©˜šàšãª ©« ‘œ¢å›˜ 1.',0);

      AssignXY(34,17,0,0);
      InitButton('  ‘~œ¢å›˜ 2  ',CmPage2,PushButton,BfNormal);
      ButtonHelp('‘¬¤â®œ ˜ «ª œ ©˜šàšãª ©« ‘œ¢å›˜ 2.',0);

      AssignXY(50,17,0,0);
      InitButton('   „¥~¦›¦ª   ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„¥¦›¦ª ˜§¦ «¦ §¨æš¨˜££˜.',0);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,1,76,8,' ˜© ¡á ©«¦ ®œå˜ ',14);

      AssignXY(17,2,27,2);
      InitInputLine(NoCm,8,'');
      InputLineMask('     /  ');
      InputLineHelp('',0);
      InputLineLabel(2,2,'€¨.~‹œ¨./‹œ¢.  :');


      InitText;
      InsertText('‰˜¤¦¤ ¡ã',$FF,$FF);
      InsertText('ƒ ˜š¨˜££â¤',$FF,$FF);
      InsertText('„¤›œ ¡« ¡ã',$FF,$FF);
      InsertText('„¢¢œ §ãª',$FF,$FF);

      AssignXY(54,2,68,6);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(42,2,'~„šš¨˜­ã    :');
      DropDownHelp('',0);


      InitText;
      InsertText('€¨©œ¤ ¡æ',$FF,$FF);
      InsertText('‡¢¬¡æ',$FF,$FF);

      AssignXY(17,3,35,5);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(2,3,'~”ç¢¦          :');
      DropDownHelp('',0);


      AssignXY(17,4,59,4);
      InitInputLine(NoCm,40,'');
      InputLineHelp('',0);
      InputLineLabel(2,4,'„§é¤~¬£¦       :');

      AssignXY(17,5,49,5);
      InitInputLine(NoCm,30,'');
      InputLineHelp('',0);
      InputLineLabel(2,5,'¤¦£~˜         :');

      AssignXY(17,6,49,6);
      InitInputLine(NoCm,30,'');
      InputLineHelp('',0);
      InputLineLabel(2,6,'¤¦£˜ ˜«~¨æª  :');

      AssignXY(17,7,49,7);
      InitInputLine(NoCm,30,'');
      InputLineHelp('',0);
      InputLineLabel(2,7,'¤¦£˜ ‹~«¨æª  :');

      {=========================================}

      InitText;
      InsertText('€š˜£¦ª/',$FF,$FF);
      InsertText('„šš˜£¦ª/',$FF,$FF);
      InsertText('ƒ ˜œ¬š£â¤¦ª/',$FF,$FF);
      InsertText('•ã¨¦ª/˜',$FF,$FF);
      InsertText('ƒ á©«˜©',$FF,$FF);

      AssignXY(17,10,35,15);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(1,10,'~ ¡.‰˜«á©«˜©  :');
      DropDownHelp('',0);

      InitText;
      InsertText('€¨®šæª  ¡.',$FF,$FF);
      InsertText('‘ç¬š¦ª',$FF,$FF);
      InsertText('ƒœ¬«.‘ç¬š¦ª',$FF,$FF);
      InsertText('’¨ « ‘ç¬š¦ª',$FF,$FF);
      InsertText('’œ«˜¨.‘ç¬š¦ª',$FF,$FF);
      InsertText('’â¡¤¦',$FF,$FF);

      AssignXY(54,10,71,16);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(42,10,'‘¬~ššâ¤œ ˜  :');
      DropDownHelp('',0);

      AssignXY(17,11,29,11);
      InitInputLine(NoCm,11,'  /  /    ');
      InputLineMask('  /  /  ');
      InputLineHelp('„ ©˜šàšã £œ¨¦£¤å˜ª.',0);
      InputLineLabel(1,11,'~†£œ¨.„šš¨˜­ª  :');

      AssignXY(54,11,62,11);
      InitInputLine(NoCm,7,'');
      InputLineHelp('',0);
      InputLineLabel(42,11,'~€¨. „šš¨.  :');
      InputLineNumbers;

      AssignXY(17,12,39,12);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(1,12,'€§. ƒ£á¨~®¦¬   :');

      AssignXY(54,12,76,12);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(42,12,'€~§.Œ¦£á¨.  :');

      AssignXY(17,13,27,13);
      InitInputLine(NoCm,8,'');
      InputLineHelp('',0);
      InputLineLabel(1,13,'€¨ Ÿ.ƒ ˜š¨˜~­ãª :');
      InputLineNumbers;

      AssignXY(54,13,76,13);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(42,13,'‚â~¤¦ª ‚¬¤. :');

      AssignXY(17,14,39,14);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(1,14,'‚â¤¦ª ‹«~¨æª :');

      AssignXY(54,14,66,14);
      InitInputLine(NoCm,11,'  /  /    ');
      InputLineMask('  /  /  ');
      InputLineHelp('„ ©˜šàšã £œ¨¦£¤å˜ª.',0);
      InputLineLabel(42,14,'†£.‚â¤~¤©ª:');

      AssignXY(17,15,39,15);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(1,15,'~’æ§¦ª ‚â¤¤©.:');

      AssignXY(54,15,76,15);
      InitInputLine(NoCm,20,'');
      InputLineHelp('',0);
      InputLineLabel(42,15,'~Œ¦£æª      :');

End;

Procedure TMyApp.GeneralParametres;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(3,4,77,23,'‚œ¤ ¡âª §˜¨á£œ«¨¦ ',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      AssignXY(2,17,0,0);
      InitButton('  ~„¤«á¥œ   ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('€§¦Ÿã¡œ¬© «à¤ ›œ›¦£â¤à¤ ©«¦ ›å©¡¦.',0);

      AssignXY(16,17,0,0);
      InitButton('  ~€¡ç¨à©  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      InitText;
      InsertText('ƒã£¦ª',$FF,$FF);
      InsertText('‰¦ ¤æ««˜',$FF,$FF);

      AssignXY(24,1,50,3);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);
      DropDownLabel(1,1,'~ƒã£¦ª / ‰¦ ¤æ««˜     :');
      DropDownHelp('„§ ¢¦šã ƒã£¦¬ ã ¡¦ ¤æ««˜ª.',0);

      AssignXY(24,2,73,2);
      InitInputLine(NoCm,46,'');
      InputLineHelp('„§à¤¬£å˜ «¦¬ ƒã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,2,'~„§à¤¬£å˜              :');

      AssignXY(24,3,73,3);
      InitInputLine(NoCm,46,'');
      InputLineHelp('„§à¤¬£å˜ «ª „§˜¨®å˜ª.',0);
      InputLineLabel(1,3,'„~§˜¨®å˜               :');

      AssignXY(24,4,73,4);
      InitInputLine(NoCm,46,'');
      InputLineHelp('„§à¤¬£å˜ «ª Œ¦£˜¨®å˜ª.',0);
      InputLineLabel(1,4,'~Œ¦£˜¨®å˜              :');

      AssignXY(24,5,73,5);
      InitInputLine(NoCm,46,'');
      InputLineHelp('„§à¤¬£å˜ «¦¬ Œ¦£¦ç.',0);
      InputLineLabel(1,5,'Œ~¦£¦ª                 :');

      AssignXY(24,6,73,6);
      InitInputLine(NoCm,46,'');
      InputLineHelp('† › œçŸ¬¤© «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,6,'~ƒ œçŸ¬¤©             :');

      AssignXY(24,7,73,7);
      InitInputLine(NoCm,46,'');
      InputLineHelp(' «˜®¬›¨¦£ ¡æª ¡é› ¡˜ª «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,7,'~’˜®¬›¨¦£ ¡æª ¡é› ¡˜ª  :');

      AssignXY(24,8,73,8);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ «¢â­à¤¦ «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,8,'’~¢œ­à¤¦              :');

      AssignXY(24,9,73,9);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ fax «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,9,'~FAX                   :');

      AssignXY(24,10,73,10);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ telex «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,10,'Tele~x                 :');

      AssignXY(24,11,73,11);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ modem «¦¬ ›ã£¦¬ ã «ª ¡¦ ¤æ««˜ª.',0);
      InputLineLabel(1,11,'~Modem                 :');

      AssignXY(24,12,73,12);
      InitInputLine(NoCm,46,'');
      InputLineHelp('† ˜¨£æ› ˜ ›£æ© ˜ª ¦ ¡¦¤¦£ ¡ãª ¬§¨œ©å˜ª.',0);
      InputLineLabel(1,12,'~€¨£æ› ˜ ƒ..“         :');

      AssignXY(24,13,73,13);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ œ§é¤¬£¦ «¦¬ ›£á¨®¦¬ ã «¦¬ §¨¦â›¨¦¬.',0);
      InputLineLabel(1,13,'„§é¤~¬£¦ ƒ£á¨/¨¦â›¨¦¬:');

      AssignXY(24,14,73,14);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ æ¤¦£˜ «¦¬ ›£á¨®¦¬ ã «¦¬ §¨¦â›¨¦¬.',0);
      InputLineLabel(1,14,'¤~¦£˜ ƒ£á¨/¨¦â›¨¦¬  :');

      AssignXY(24,15,73,15);
      InitInputLine(NoCm,46,'');
      InputLineHelp('’¦ §˜«¨é¤¬£¦ «¦¬ ›£á¨®¦¬ ã «¦¬ §¨¦â›¨¦¬.',0);
      InputLineLabel(1,15,'~˜«¨é¤. ƒ£á¨/¨¦â›¨¦¬:');


End;

Procedure TMyApp.Printer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=4;
      OpenWindow(20,6,60,20,'˜¨á£œ«¨¦  „¡«¬§à«ã',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,1,15,6,' „¥¦›¦ª ',14);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(17,1,39,6,' ’¨¦­¦›¦©å˜ ',14);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,7,39,10,' ƒ á­¦¨˜ ',14);


      AssignXY(2,12,0,0);
      InitButton('  ~„¤«á¥œ   ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('€§¦›¦®ã «à¤ œ§ ¢¦šé¤.',0);

      AssignXY(16,12,0,0);
      InitButton('  ~€¡ç¨à©  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à© «ª › ˜› ¡˜©å˜ª.',0);

      AssignXY(2,2,0,0);
      InitRadioButton(NewRItem('~LPT 1',NoCm,'¨é« §˜¨á¢¢¢.',0,BfDefault,
                      NewRItem('L~PT 2',NoCm,'ƒœç«œ¨ §˜¨á¢¢¢.',0,BfNormal,
                      NewRItem('~COM 1',NoCm,'¨é« ©œ ¨ ˜¡ã.',0,BfNormal,
                      NewRItem('C~OM 2',NoCm,'ƒœç«œ¨ ©œ ¨ ˜¡ã.',0,BfNormal,
                         Nil)))));

      AssignXY(18,2,0,0);
      InitRadioButton(NewRItem('~‘¬¤œ®æ£œ¤',NoCm,'‘¬¤œ®æ£œ¤¦ £®˜¤¦š¨˜­ ¡æ ®˜¨«å.',0,BfDefault,
                      NewRItem('‘œ~¢ ›˜',NoCm,'’¦§¦Ÿâ«© ©œ¢å›˜ª.',0,BfNormal,
                         Nil)));

      AssignXY(18,8,22,8);
      InitInputLine(NoCm,3,'');
      InputLineHelp('‚¨˜££âª ˜¤˜ ©œ¢å›˜.',0);
      InputLineLabel(3,8,'~‚¨˜££âª/©œ¢å›˜:');
      InputLineNumbers;

      AssignXY(2,9,0,0);
      InitCheckBox('„¡«ç~§à© ©œ ˜¨®œå¦.',NoCm,BfNormal);
      CheckBoxHelp('¢œª ¦  œ¡«¬§é©œ ª ¡˜«œ¬Ÿç¤¦¤«˜  ©œ ˜¨®œå¦',0);



End;

Procedure TMyApp.DemoWin;
Begin
      WinTextColor:=15;
      WinTextBackGround:=2;
      OpenWindow(20,8,60,18,'‹ › ˜Ÿâ© £¦',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      AssignXY(14,8,0,0);
      InitButton('  ~„¤«á¥œ   ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ©«¨¦­ã ©«¦ §¨æš¨˜££˜.',0);

      WriteTextColor:=14;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(3,'€¬«ã  ¢œ «¦¬¨šå˜ ›œ¤ œå¤˜  › ˜Ÿâ© £');
      CentreWinMessage(4,'©«¤ Demo â¡›¦© «¦¬ §¨¦š¨á££˜«¦ª.');

End;

Procedure TMyApp.Passwords;
Var
   R    :Pointer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,7,70,20,'„ ©˜šàšã Passwords',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+Shadow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;


      AssignXY(2,11,0,0);
      InitButton(' << ~„§ ©«¨¦­ã ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„§ ©«¨¦­ã ©«¦ ™˜© ¡æ §˜¨áŸ¬¨¦.',0);

      AssignXY(40,2,0,0);
      InitButton('    „ ~©˜šàšã    ',NoCm,PushButton,BfNormal);
      ButtonHelp('„ ©˜šàšã ¤â¦¬ ¡à› ¡¦ç.',0);

      AssignXY(40,4,0,0);
      InitButton('    ~ƒ ˜š¨˜­ã    ',NoCm,PushButton,BfNormal);
      ButtonHelp('ƒ ˜š¨˜­ã ¡à› ¡¦ç.',0);

      AssignXY(40,6,0,0);
      InitButton('    ~’˜¥ ¤æ£ ©  ',NoCm,PushButton,BfNormal);
      ButtonHelp('’˜¥ ¤æ£ © ¡à› ¡é¤.',0);

      InitText;
      InsertText('Supervisor',$FF,$FF);
      InsertText('Guest 1',$FF,$FF);
      InsertText('User ID 23A-G2',$FF,$FF);

      AssignXY(2,2,30,9);
      R:=InitMenuBox('~Passwords',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

      AssignXY(45,9,59,9);
      InitInputLine(NoCm,12,'');
      InputLineHelp('„ ©˜šàšã ¡à› ¡¦ç.',0);
      InputLineLabel(35,9,'~‰à› ¡æª :');


End;

Procedure TMyApp.InitMenuBar;
Begin
    PDY1:=2;
    SetWindowY1:=2;
    StatLineMaxChars:=70;
    StatLineTxtColor:=0;
    PDTextBackGround:=PullDnTextBackGround;
    PDTextColor:=PullDnTextColor;
    PDParams:=Shadow+WinChars;
    InitHelpCtx:='á«©œ F10 ã ¡˜¤œ click £œ «¦ §¦¤« ¡  š ˜ ¤˜ §˜ª ©«˜ menus';


    PDHeadNode:=NewSubMenu('~ğ',NoCm,'„¤›œ ¥ â¡›¦©ª ¡˜  œ§ ¢¦šã œ¥æ›¦¬ ˜§¦ «¦ §¨æš¨˜££˜.',NoCm,NewMenu(
                  NewItem('~‘®œ« ¡á','',0,CmAbout,'¢¨¦­¦¨åœª ©®œ« ¡á £œ «¤ â¡›¦© ¡˜  «˜ › ¡˜ é£˜«˜ ˜v« š¨˜­ãª.',NoCm,
                  NewLine(
                  NewItem('~Dos shell','',NoCm,CmDemoWin,'¨¦©à¨ ¤ã â¥¦›¦ª ©«¦ ©ç©«£˜.',NoCm,
                  NewItem('~„¥¦›¦ª','Alt-X',KbAltX,cmQuit,'„¥¦›¦ª ˜§¦ «¦ §¨æš¨˜££˜.',NoCm,
                          Nil))))),
                NewSubMenu('~€¨®œ ˜',NoCm,'ƒ ˜®œå¨ © €¨®œåà¤.',NoCm,NewMenu(
                  NewItem('~ ¡¦šœ¤œ ˜¡âª ‹œ¨å›œª','F2',KbF2,CmNo1,'‘«¦ ®œå˜ ƒ£æ«.',NoCm,
                  NewLine(
                  NewItem('~‡¨©¡œç£˜«˜','Ctrl-F1',KbCtrlF1,cmSetReligions,'‰˜«á¢¦š¦ª ‡¨©¡œ¬£á«à¤.',NoCm,
                  NewItem('~‰«ã© ˆŸ˜šâ¤œ ˜ª','Ctrl-F2',KbCtrlF2,cmSetNative,'‰˜«á¢¦š¦ª ˆŸ˜šâ¤œ ˜ª.',NoCm,
                  NewItem('•¨ã©œ ª ~ ©«¦§¦ « ¡é¤','Ctrl-F3',KbCtrlF3,cmUsesOfConfirmations,'‰˜«á¢¦š¦ª  ©«¦§¦ « ¡é¤.',NoCm,
                  NewLine(
                  NewItem('Œ¦~£¦å','Ctrl-F4',KbCtrlF4,cmSetArea,'‰˜«á¢¦š¦ª Œ¦£é¤.',NoCm,
                  NewItem('~„§˜ššâ¢£˜«˜','Ctrl-F5',KbCtrlF5,cmSetOccupy,'‰˜«á¢¦š¦ª „§˜ššœ¢£á«à¤.',NoCm,
                          Nil))))))))),

                NewSubMenu('~¨¦ æ¤«˜',NoCm,'ƒ ˜®œå¨ © €§¦«œ¢œ©£á«à¤.',NoCm,NewMenu(
                  NewItem('~£˜› ¡á  ©«¦§¦ « ¡á','',NoCm,CmDemoWin,'‰˜¨«â¢œª  ©«¦§¦ « ¡é¤.',NoCm,
                  NewItem('~„¡«¬§é©œ ª.','',NoCm,CmDemoWin,'„¡«¬§é©œ ª œšš¨˜­é¤.',NoCm,
                          Nil))),

                NewSubMenu('~¬Ÿ£å©œ ª',NoCm,'¬Ÿ£å©œ ª š ˜ «¤ ¢œ «¦¬¨šå˜ «¦¬ §¨¦š¨á££˜«¦ª.',NoCm,NewMenu(
                  NewItem('~‚œ¤ ¡âª ˜¨á£œ«¨¦ ','',NoCm,CmGenerParam,'˜¨á£œ«¨¦  ¨¦š¨á££˜«¦ª.',NoCm,
                  NewItem('~˜¨á£œ«¨¦  „­˜¨£¦šãª','',NoCm,CmDemoWin,'¢œª ¦  §˜¨á£œ«¨¦  œ­˜¨£¦šãª.',NoCm,
                  NewItem('˜¨˜£œ«¨¦  ~„¡«¬§à«ã','',NoCm,CmPrinter,'ç¨£ © œ¡«¬§é«.',NoCm,
                  NewItem('~‰à› ¡¦å ¨æ©™˜©ª (Password)','',NoCm,CmPasswords,'„ ©˜šàšã ¡à› ¡¦ç §¨æ©™˜©ª.',NoCm,
                  NewLine(
                  NewItem('ƒ ˜£æ¨­à© › ©¡â«˜ª (~Format)','',NoCm,CmDemoWin,'ƒ ˜£æ¨­à© ¤â˜ª › ©¡â«˜ª.',NoCm,
                  NewItem('€§¦Ÿã¡œ¬© ˜¨®œåà¤ (~Backup)','',NoCm,CmDemoWin,'ackup «à¤ ›œ›¦£â¤à¤.',NoCm,
                  NewItem('„§˜¤˜­¦¨á ˜¨®œåà¤ (~Restore)','',NoCm,CmDemoWin,'Restore «à¤ ›œ›¦£â¤à¤.',NoCm,
                          Nil))))))))),

                NewSubMenu('~B¦ãŸœ ˜',NoCm,'On line ™¦ãŸœ ˜.',NoCm,NewMenu(
                  NewItem('~‰˜«á¢¦š¦ª','',NoCm,cmHlpCatalog,'Index «ª ™¦ãŸœ ˜ª.',NoCm,
                  NewItem('•œ ¨ ©£æª ~¦¤« ¡ ¦ç','',NoCm,CmHlpMouse,'›šœåœª š ˜ «¦¤ ®œ ¨ ©£æ «¦¬ §¦¤« ¡ ¦ç.',hcMouseFunc,
                  NewItem('•œ ¨ ©£æª ~¢¡«¨¦¢¦šå¦¬','',NoCm,cmHlpKeyb,'›šœåœª š ˜ «¦¤ ®œ ¨ ©£æ «¦¬ §¢¡«¨¦¢¦šå¦¬.'
                                 ,hcKeyboardFunc,
                  NewItem('•œ ¨ ©£æª ˜¨˜~Ÿç¨à¤','',NoCm,cmHlpMoveWin,'›šœåœª š ˜ «¦¤ ®œ ¨ ©£æ «à¤ §˜¨˜Ÿç¨à¤.',hcMoveWin,
                  NewItem('~‚¢à©©á¨ ','',NoCm,cmHlpGlassary,'„¨£¤å˜ ¦¨¦¢¦šå˜ª',hcGlossary,
                  NewItem('¨¦~™¢ã£˜«˜','',NoCm,CmHlpProblems,'„¨£¤å˜ §¨¦™¢£á«à¤ ¡˜«˜ «¤ › á¨¡œ ˜ œ¡«â¢œ©ª',hcErrorMsg,
                  NewLine(
                  NewItem('On Line ~Help','F1',KbF1,CmHlpCatalog,'¦ãŸœ ˜ š ˜ «¦ «¨œ®à¤ topic.',NoCm,
                          Nil))))))))),
                Nil)))));

End;


Procedure TMyApp.HandleCommand;
Begin
   Case Event of

      CmQuit       :Quit;
      CmCloseWin   :CloseWindow;
      CmAbout      :About;
      CmRealExit   :ExitFromProgram:=True;
      CmPage1      :Page1;
      CmPage2      :Page2;
      cmGenerParam :GeneralParametres;
      cmPrinter    :Printer;
      cmDemoWin    :DemoWin;
      CmPassWords  :PassWords;
      cmHlpCatalog,
      cmHlpMouse,
      cmHlpKeyb,
      cmHlpMoveWin,
      cmHlpGlassary,
      cmHlpProblems   :HlpCatalog;

      cmNo1           :Merides;
      cmSetReligions  :SetReligions;
      cmSetArea       :SetArea;
      cmSetOccupy     :SetOccupy;
      cmSetNative     :SetNative;
      cmUsesOfConfirmations :UsesOfConfirmations;
   End;
End;

Function SetFullDate(YearS,MonthS,DayS :String) :String;
Var
   SDate        :String;
Begin
    SDate:='';
    IF Length(YearS) < 4 Then
       SDate:='19'+YearS
    Else
       SDate:=YearS;

    IF Length(MonthS) < 2 Then
      SDate:='0'+MonthS+'/'+SDate
    Else
      SDate:=MonthS+'/'+SDate;

    IF Length(DayS) < 2 Then
      SDate:='0'+DayS+'/'+SDate
    Else
      SDate:=DayS+'/'+SDate;

      SetFullDate:=SDate;
End;


Procedure TMyApp.StartWindow;
Var
   Date :String[11];
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(8,5,68,20,'Code',WinChars+OpenFx+CloseFx+Shadow+movement+CloseIcon+WinCharsWindow);
      Win^.CloseCommand:=cmCloseWin;
      IF HeapErrorCode <> 0 Then
         Exit;

      AssignXY(2,13,0,0);
      InitButton('  ~„¤«á¥œ   ',CmCloseWin,PushButton,BfDefault);
      ButtonHelp('„¢œš®¦ª «à¤ §˜¨˜£â«¨à¤.',0);

      AssignXY(18,13,0,0);
      InitButton('  „¥~¦›¦ª  ',CmCloseWin,PushButton,BfNormal);
      ButtonHelp('„¥¦›¦ª ˜§¦ «¦ §¨æš¨˜££˜.',0);

      WriteTextColor:=0;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(1,'„¢œš®¦ª ®¨ã©« ¡˜  œ ©˜šàšã £œ¨¦£¤å˜ª.');
      CentreWinMessage(2,'’¦ §¨æš¨˜££˜ Ÿ˜ ¡˜¤œ  â¢œš®¦ ˜¤ ¦ ®¨ã©«ª œ®œ  §¨æ©™˜©');
      CentreWinMessage(3,'©«¦ ©ç©«£˜ ¡˜  ˜¤  œ ©˜®Ÿâ©˜ £œ¨¦£¤å˜ «˜¤ âš¡¬¨.');


      GetDate(Year,Month,Day,DOW);
      Str(Year,YearS);
      Str(Month,MonthS);
      Str(Day,DayS);
      SetFullDate(YearS,MonthS,DayS);

      AssignXY(14,7,26,7);
      InitInputLine(NoCm,11,SetFullDate(YearS,MonthS,DayS));
      InputLineMask('  /  /  ');
      InputLineHelp('„ ©˜šàšã £œ¨¦£¤å˜ª.',0);
      InputLineLabel(2,7,'~†£œ¨¦£¤å˜ :');

      AssignXY(14,9,24,9);
      InitInputLine(NoCm,8,'');
      InputLineHelp('„ ©˜šàšã ¡à› ¡¦ç §¨æ©™˜©ª.',0);
      InputLineLabel(2,9,'~Kà› ¡æª    :');

End;

Var
   MyApp        :TMyApp;

Begin
    ExclusiveVGA:=True;
    ReadCurPositHeight;
    WriteTextColor:=7;
    WriteTextBackGround:=0;
    WriteOut(CurColumn+1,CurRow+1,'Citizen  version  2.00a   Copyright (c)  1990,95   Digital Toolworks');
    Writeln;
{    RetraceDelay(40000);}
    AllowDiskHelp:=True;
    AllowHelpCtx:=True;
    MyApp.Init;

    DeskTopHead(15,3,'¨æš¨˜££˜ ƒ£¦«¦¢¦šå¦¬');
    WriteChar(71,25,PullDnTextColor,PullDnTextBackGround,179);
    SetClock(74,25,7,6);

    MyApp.StartWindow;
    MyApp.Run;
    MyApp.Done;
End.