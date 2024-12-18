Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinInit,GeneralObj,Crt,
      ErrorDlg,MouseObj,WinApplObj,TopicHlp,HelpObj;

Const
     CmQuit      = 1;
     cmMainMenu  = 2;
     cmOptions   = 3;
     cmHyper     = 4;
     cmAbout     = 5;

Type

   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure MainMenu;
      Procedure Hyper;
      Procedure About;
   End;

Procedure TMyApp.Hyper;
Begin
    KBScanCode:=59;
    KBAsciiCode:=0;
    RunHelp;
End;

Procedure TMyApp.HandleCommand;
Begin
   Case Event of

      CmQuit       :Begin
                      ExitFromProgram:=True;
                      CloseWindow;
                    End;
      CmMainMenu   :Begin
                        CloseWindow;
                    End;
      CmOptions    :Begin
                        CloseWindow;
                    End;
      cmHyper      :Hyper;
      cmAbout      :About;

   End;
End;


Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(13,2,59,23,'�������',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Shadow);
      Win^.CloseCommand:=cmMainMenu;
      IF HeapErrorCode = 1 Then
         Exit;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'��暨���� Hyper Text');
      CentreWinMessage(3,'⡛��� 1.00a');
      CentreWinMessage(5,'(c) Copyright 1993,96  by Digital ToolWorks');
      WriteTextColor:=10;
      CentreWinMessage(7,'<< This Demo is a Public Domain >>');
      CentreWinMessage(8,'<< Version.Thanx For watching.>>');


      WriteTextColor:=14;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,12,GetWindowMaxX,17,' Hello again !! ',14);

      WriteTextColor:=1;
      CentreWinMessage(14,'� ��ᨮ��� '+KBytes+'KB ��� �穫��� ���矜��.');
      CentreWinMessage(15,'� � ⡛��� ��� Dos �夘� '+DosVer);


      AssignXY(17,GetWindowMaxY-1,0,0);
      InitButton('  ~���ᥜ� ',CmMainMenu,PushButton,BfDefault);
      ButtonHelp('',0);
End;


Procedure TMyApp.MainMenu;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(8,5,68,21,'Hyper Text Demo Version',WinChars+OpenFx+CloseFx+Shadow+CloseIcon+WinCharsWindow);
      IF HeapErrorCode = 1 Then
         Exit;

      Win^.CloseCommand:=cmQuit;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,2,GetWindowMaxX,8,' �������� ����⤦�',14);

      AssignXY(2,3,0,0);
      InitRadioButton(NewRItem('~�����������',NoCm,'',0,BfNormal,
                      NewRItem('~�����������',NoCm,'',0,BfDefault,
                      NewRItem('~��������嘪',NoCm,'',0,BfNormal,
                         Nil))));



      InitText;
      InsertText('Color mode',$FF,$FF);
      InsertText('Mono mode',$FF,$FF);
      InsertText('LCD mode',$FF,$FF);

      AssignXY(30,4,50,7);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,3);
      DropDownLabel(30,3,'~��飘');
      DropDownHelp('',0);

      AssignXY(30,7,50,7);
      InitInputLine(0,60,'A:\');
      InputLineLabel(30,6,'~Path');
      InputLineHelp('',0);

      AssignXY(2,7,0,0);
      InitCheckBox('~Hxos',0,BfNormal);
      CheckBoxHelp('',0);



      AssignXY(2,10,0,0);
      InitButton('    ~Go to Hyper        ',cmHyper,PushButton,BfNormal);
      ButtonHelp('',0);

      AssignXY(2,12,0,0);
      InitButton('        ~�������        ',cmAbout,PushButton,BfNormal);
      ButtonHelp('',0);

      AssignXY(2,14,0,0);
      InitButton('        �~�����         ',CmQuit,PushButton,BfDefault);
      ButtonHelp('',0);

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;

      WriteWindow(28,10,'Hyper Text Demostration.');
      WriteWindow(28,12,'��������圪 ������������.');
      WriteWindow(28,14,'������ ��� ��� Dos.');



End;

Var
   MyApp        :TMyApp;

Begin
    DosFonts:=True;
    SetBackGround:=False;
    AllowDiskHelp:=True;

    MyApp.Init;
    MyApp.MainMenu;
    MyApp.Run;
    MyApp.Done;
End.
