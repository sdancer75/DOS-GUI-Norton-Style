Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinObjC,WinInit,GeneralObj,Crt,Dos,
      ErrorDlg,MouseObj,WinApplObj,TopicHlp,HelpObj;

Const
     CmClose    = 1;

Type

   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure MainMenu;

   End;


Procedure TMyApp.MainMenu;
Var
   KBytes       :String;
   R            :ProgressBar;
   I            :Byte;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(12,2,66,23,'‘®œ« ¡á',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=0;
      If HeapErrorCode = 1 Then
         Exit;

      AssignXY((GetWindowMaxX-Length('  ~„¤«á¥œ  ')) div 2,GetWindowMaxY-1,0,0);
      InitButton('  ~„¤«á¥œ  ',CmClose,PushButton,BfDefault);
      ButtonHelp('',0);


      WriteTextColor:=6;
      WriteTextBackGround:=WinTextBackGround;

      AssignXY(20,2,50,2);
      InitInputLine(Nocm,30,'');
      InputLineLabel(2,2,'~‰˜«žš¦¨å˜        :');



      InitText;
      InsertText('0000000000000000000000000000000000000000000',$FF,$FF);
      InsertText('1111111111111111111111111111',$FF,$FF);
      InsertText('2222222222222222222222222222222222222222222',$FF,$FF);
      InsertText('33333333333333333333333333333333333333333333',$FF,$FF);
      InsertText('44444444444444444444444444444444444444444444',$FF,$FF);
      InsertText('55555555555555555555555555555555555555555555',$FF,$FF);
      InsertText('66666666666666666666666666666666666666666666',$FF,$FF);
      InsertText('77777777777777777777777777777777777777777777',$FF,$FF);
      InsertText('88888888888888888888888888888888888888888888',$FF,$FF);
      InsertText('99999999999999999999999999999999999999999999',$FF,$FF);
      InsertText('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',$FF,$FF);
      InsertText('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',$FF,$FF);
      InsertText('cccccccccccccccccccccccccccccccccccccccccccc',$FF,$FF);
      InsertText('dddddddddddddddddddddddddddddddddddddddddddd',$FF,$FF);
      InsertText('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',$FF,$FF);
      InsertText('ffffffffffffffffffffffffffffffffffffffffffff',$FF,$FF);
      InsertText('gggggggggggggggggggggggggggggggggggggggggggg',$FF,$FF);
      InsertText('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',$FF,$FF);
      InsertText('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii',$FF,$FF);



      AssignXY(2,4,50,10);
      InitTextBox(Box);
      ShowTextBox(GeneralHeadText,GeneralTailText);



End;

Procedure TMyApp.HandleCommand;
Begin
   Case Event of

      CmClose       :Begin
                      ExitFromProgram:=True;
                      CloseWindow;
                    End;
   End;

End;

Var
   MyApp        :TMyApp;


Begin

      MyApp.Init;
      MyApp.MainMenu;
      MyApp.Run;
      MyApp.Done;

End.