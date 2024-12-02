Uses WindowsObj,VarConstObj,PullDnMenus,WinObjA,WinObjB,WinInit,Crt;


Const


    CmOpenWin    =1;
    CmClosewin   =2;
    CmMoveWin    =3;
    CmNextWin    =4;
    CmPrintMask  =5;
    cmQuit       =6;
    cmOption     =7;
    cmCancel     =8;
    cmWriteNum   =9;

    cm100        = 100;
    cm101        = 101;
    cm102        = 102;
    cm103        = 103;
    cm104        = 104;
    cm105        = 105;
    cm106        = 106;
    cm107        = 107;
    cmwin2       = 1;



{*********************** Now Starts The real program ******************}
Type

   TMyApp = Object (Application)
      Procedure InitMenuBar; Virtual;
      Procedure HandleCommand; Virtual;
      Procedure RunWindow;

      Procedure FillScroller;
   End;

   Win2 = Object (TMyApp)
      Procedure HandleCommand; Virtual;
      Procedure Window2;
   End;

Procedure Win2.HandleCommand;
Begin
    Case Event of
      CmWin2:
        Begin
            Gotoxy(1,1);Write('George');
            ClearEvent;
        End;
    End;
End;

Procedure Win2.Window2;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(1,4,35,22,'',Movement+WinChars+WinCharsWindow+OpenFx+CloseFx+Shadow+CloseIcon);
      CloseCommand:=CmCloseWin;

      AssignXY(2,6,0,0);
      InitButton(' ~Cancel ',cmCloseWin,PushButton,BfDefault);
      ButtonHelp('Canceling a window procedure.....',0);


      AssignXY(12,6,0,0);
      InitButton(' ~Test ',cmWin2,PushButton,BfDefault);
      ButtonHelp('testing.....',0);
End;

Var
   TWin2 :Win2;

Procedure TMyApp.InitMenuBar;
Begin
    StatLineMaxChars:=60;
    StatLineTxtColor:=4;
    PDTextBackGround:=PullDnTextBackGround;
    PDTextColor:=PullDnTextColor;
    PDParams:=Shadow+WinChars;
    InitHelpCtx:='Press F10 or click with the mouse at any position...';

PDHeadNode := NewSubMenu('~File', 0, 'File managment',1,NewMenu(

              NewItem('~Move Window','F1',KbF2,cmMoveWin,'Move a window.',2,

              NewSubMenu('~Environment of the tree',0,'',3,NewMenu(
                NewMoreSubs(
                NewItem('~Next', '', 0, 0, '',NoHelp,
                NewItem('~Move...', 'F3', kbF3, cmMoveWin, '',NoHelp,
                NewItem('~Close....', 'F3', KbF1, 0, '',NoHelp,
                NewSubMenu('Advance',0,'',NoHelp,NewMenu(
                   NewMoreSubs(
                   NewItem('~Item1', '', 0, cmPrintMask, '',NoHelp,
                   NewItem('~Item2.', 'F3', kbF3, 0, '',NoHelp,
                   NewItem('~Item3....', 'F3', KbF1, 0, '',NoHelp,Nil))))),
                NewItem('E~xit', 'Alt+X', kbAltX, cmQuit, '',NoHelp,nil))))))),

              NewSubMenu('~Preferences',0,'Set Preferences',NoHelp,NewMenu(
                NewMoreSubs(
                NewItem('Topic','F1',kbF1,0,'',NoHelp,
                NewItem('Index','F2',KbF2,0,'',NoHelp,Nil)))),
              NewCheck('~Mouse On','CheckOn',0,'',NoHelp,Nil))))),

             NewSubMenu('~Test', 0, 'Testing a program.So do it.',NoHelp,NewMenu(
               NewItem('~Next Window', 'F4',KbF4,cmNextWin , 'Activate next window',NoHelp,
               NewItem('Hello1','',0,0,'',NoHelp,
               NewItem('George Papa','',0,cmPrintMask,'',0,
               NewLine(
               NewItem('~Turbo Boat','',0,0,'',NoHelp,Nil)))))),

             NewSubMenu('~Compile',0,'Compile a program',NoHelp,NewMenu(
                 NewItem('80x30 mode','',0,cm100,'',0,
                 NewItem('80x43 mode','',0,cm101,'',0,
                 NewItem('80x60 mode','',0,cm102,'',0,
                 NewItem('132x25 mode','',0,cm103,'',0,
                 NewItem('132x30 mode','',0,cm104,'',0,
                 NewLine(
                 NewItem('132x43 mode','',0,cm105,'',0,
                 NewItem('132x60 mode','',0,cm106,'',0,
                 NewItem('80x25 mode...','',0,cm107,'',0,
                 NewItem('Dos Shell..','',0,0,'',0,
                 NewItem('Exit...','',0,0,'',0,
                 NewLine(
                 NewItem('1.. TestObj','',0,0,'',0,
                 NewItem('2.. C:\tp7\exe\run','',0,0,'',0,
                 NewItem('3.. D:\TK\Exe\Prgs\Util\Kl','',0,0,'',0,Nil)))))))))))))))),

             NewSubMenu('~Tools',0,'Window Tools or editing tools.',NoHelp,NewMenu(Nil),
             NewSubMenu('~Option',0,'set options',NoHelp,NewMenu(Nil),
             NewSubMenu('~Window',cmOpenWin,'Open a window',NoHelp,NewMenu(Nil),
             NewSubMenu('Closewi~n',cmCloseWin,'Close a window',NoHelp,NewMenu(Nil),
           Nil)))))));

End;

Procedure TMyApp.FillScroller;
Begin
      InsertText('Item 1George',$FF,$FF);
      InsertText('Item 2',$FF,$FF);
      InsertText('Item 3',$FF,$FF);
      InsertText('Item 4',$FF,$FF);
      InsertText('Item 5',$FF,$FF);
      InsertText('Item 6',$FF,$FF);
      InsertText('Item 7',$FF,$FF);
      InsertText('Item 8',$FF,$FF);
      InsertText('Item 9',$FF,$FF);
      InsertText('Item 10',$FF,$FF);
      InsertText('Item 11',$FF,$FF);
      InsertText('Item 12',$FF,$FF);
      InsertText('Item 13',$FF,$FF);
      InsertText('Item 14',$FF,$FF);
      InsertText('Item 15',$FF,$FF);
End;
Const
    cmInput1    = 1000;
    cmInput2    = 1001;
    cmCheck1    = 1002;
    cmCheck2    = 1003;
    cmMenu1     = 12;
    cmRadio1    = 1005;
    cmRadio2    = 1006;
    cmRadio3    = 1007;

Procedure TMyApp.RunWindow;
Var
   k,i  :word;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(1,4,65,22,'',Movement+WinChars+WinCharsWindow+OpenFx+CloseFx+Shadow+CloseIcon);
      CloseCommand:=CmCloseWin;

      InitText;
      FillScroller;
{
      AssignXY(2,6,0,0);
      InitButton(' ~Cancel ',cmCancel,PushButton,BfNormal);
      ButtonHelp('Canceling a window procedure.....',0);


      AssignXY(15,6,0,0);
      InitButton(' ~Option ',cmNextWin,PushButton,BfNormal);
      ButtonHelp('Select an option if you want to redifine.....',0);}

      AssignXY(28,13,0,0);
      InitButton(' Clo~se  ',cmCloseWin,PushButton,BfDefault);
      ButtonHelp('Close current window.....',0);


      AssignXY(2,3,25,3);
      InitInputLine(cmInput1,12,'21/21/43');
      InputLineMask('  /  /  ');
      InputLineHelp('Write your command ......',0);
      InputLineLabel(2,2,'N~ame/Address');

{      AssignXY(2,4,25,4);
      InitInputLine(cmInput2,20,'Noname');
      InputLineHelp('Give me your ID ......',0);
      InputLineNumbers;

      AssignXY(2,6,0,0);
      InitCheckBox('~ƒœ¡˜› ¡¦ª',cmCheck1,BfNormal);
      CheckBoxHelp('ƒœ¡˜› ¡¦ ©¬©«ž£˜..',0);

      AssignXY(30,3,49,13);
      InitDropDown(0);
      ShowDropDownText(GeneralHeadText,GeneralTailText,3);
      DropDownLabel(30,2,'~Testing');

      AssignXY(2,9,0,0);
      InitRadioButton(NewRItem('„§ ¢¦~šž 1',cmRadio1,'Choise Item 1..',0,BfNormal,
                      NewRItem('„~§ ¢¦šž 2',cmRadio1,'Choise Item 2 ..',0,BfDefault,
                      NewRItem('‰˜¤œ¤˜~ª',cmRadio1,'Choise Item 3 ..',0,BfNormal,Nil))));


}
      AssignXY(30,2,49,10);
      InitMenuBox('~FileFix',VerScr,CmMenu1);
      ShowMenuText(GeneralHeadText,GeneralTailText,5);

End;
Procedure TMyApp.HandleCommand;
Begin
    Case Event of
      CmOpenWin:
        Begin
            RunWindow;
            ClearEvent;
        End;
      CmCloseWin:
         Begin
          CloseWindow;
          ClearEvent;
         End;
      CmMoveWin:
         Begin
            Twin2.window2;
            ClearEvent;
         End;
      CmNextWin:
         Begin
            DisableWinCommand([cmMenu1]);
            {ActivateNext;}
{            Assign(Ar,'A:G.T');
            Reset(Ar);
            Close(Ar);
            IF CriticalError <> 0 Then
               CriticalErrorMessage;}
            ClearEvent;
         End;
      CmPrintMask:
           Begin
                ClearEvent;
           End;
      CmOption:DisableWinCommand([cmWriteNum]);
      CmCancel:EnableWinCommand([cmMenu1]);
      cm100   :SetText80x30;
      cm101   :SetText80x43;
      cm102   :SetText80x60;
      cm103   :SetText132x25;
      cm104   :SetText132x30;
      cm105   :SetText132x43;
      cm106   :SetText132x60;
      cm107   :SetText80x25;
      NoCm:
        Begin
        End;
      cmQuit:ExitFromProgram:=True;

      {***************************}
      cmInput1:;
      cmInput2:;
      cmCheck1:;
      cmCheck2:;
      cmRadio1:;
      cmRadio2:;
      cmRadio3:;
      cmMenu1 :;

    End;

End;


Var
  MyApp :TMyApp;

Begin
    MyApp.Init;
    MyApp.Run;
    MyApp.Done;
End.
