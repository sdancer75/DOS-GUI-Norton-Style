Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinInit,GeneralObj,Crt,Dos,
      ErrorDlg,MouseObj,WinApplObj;

Const

     MaxCodes           = 20;

     CmQuit             = 1;
     cmMainMenu         = 2;
     cmCustomers        = 3;
     cmInputCustomer    = 4;
     cmCancelCustomer   = 5;
     cmSort             = 6;
     cmSearchCustomer   = 7;
     cmRecMoney         = 9;
     cmRecPrevMod       = 10;
     cmRecInput1        = 11;
     cmRecInput2        = 12;
     cmRecInput3        = 13;
     cmRecDel1          = 14;
     cmRecDel2          = 15;
     cmRecDel3          = 16;
     cmRecList1         = 17;
     cmRecList2         = 18;
     cmRecList3         = 19;
     cmRecCode1         = 20;
     cmRecCode2         = 21;
     cmRecCode3         = 22;
     cmRecPrice1        = 23;
     cmRecPrice2        = 24;
     cmRecPrice3        = 25;
     cmRecName          = 26;
     cmRecDate          = 27;
     cmInputOutPut      = 28;
     cmPrinter          = 29;
     cmAbout            = 30;
     cmCalcTotalMod     = 31;
     cmCloseWin         = 32;
     cmTakeListName     = 33;
     cmSearchDiskCustomer = 34;
     cmInputCustomer2     = 35;
     cmDoInputCustomer2   = 36;
     cmDeleteCustomer     = 37;
     cmAskUserDeleteCustomer = 38;
     cmNextCustomer          = 39;
     cmInOutShow             = 40;



Type

   NameStr      = String[30];

   RecStruc     = Record
     Date       :String[10];
     Name       :String[25];
     Price1     :LongInt;
     List1      :Array [1..20] of String[9];
     Price2     :LongInt;
     List2      :Array [1..20] of String[14];
     Price3     :LongInt;
     List3      :Array [1..20] of String[14];
     PrevMod    :LongInt;
     Money      :LongInt;
     TotalMod   :LongInt;
   End;

   IndexStruc   = Record
     Max        :LongInt;
     Flag       :Byte;
     Name       :String[25];
   End;


   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure About;
      Procedure MainMenu;
      Procedure Customers;
      Procedure InputCustomer;
      Procedure InputCustomer2;
      Procedure Sort;
      Procedure SearchCustomerA;
      Procedure SearchCustomerB;
      Procedure InputOutPut;
      Procedure Printer;
      Procedure ReadError;
      Procedure WriteError;
      Procedure CustomData;
      Procedure ShowRestMoney;
      Procedure NameList;
      Procedure SearchDiskCustomer;
      Procedure AdjustLists;
      Procedure AskUserInputCustomer2;
      Procedure DeleteCustomer;
      Procedure AskUserDeleteCustomer;
      Procedure NextCustomer;
      Procedure DiskInputOutput;
   End;

Var
   MyApp        :TMyApp;
   FData        :File of RecStruc;
   FRec         :RecStruc;
   FIndex       :File of IndexStruc;
   FIRec        :IndexStruc;
   TakeCode1    :String;
   MarkList1    :String;
   TakeCode2    :String;
   MarkList2    :String;
   TakeCode3    :String;
   MarkList3    :String;
   ErCode       :Integer;
   List1,
   List2,
   List3        :PMenuNode;
   TIOResult    :Integer;
   MaxCode1,
   MaxCode2,
   MaxCode3     :Byte;
   NameInputLine:PInputLine;
   RecPosition  :LongInt;



Function ESpaces(S :String) :String;
Var
   I            :Byte;
   NewS         :String;
   S1           :String[1];
Begin
    NewS:='';
    For I:=1 to Length(S) do
    Begin
        S1:=Copy(S,I,1);
        IF S1[1]<>' ' Then
           NewS:=NewS+S1;
    End;

    ESpaces:=NewS;
End;

Function ESpacesRight(S :NameStr) :String;
Var
   I            :Byte;
   NewS         :String;
   S1           :String[1];
Begin
    NewS:=S;
    For I:=Length(S) DownTo 1 do
    Begin
        S1:=Copy(S,I,1);
        IF S1[1]=' ' Then
           NewS:=Copy(S,1,I-1)
        Else
        Begin
            ESpacesRight:=NewS;
            Exit;
        End;
    End;

    ESpacesRight:=NewS;
End;


Procedure HaltApplication; Forward;

Procedure InitRecord;
Var
   I    :Byte;
Begin
    With FRec do
    Begin
       Date:='';
       Name:='';
       Price1:=0;
       Price2:=0;
       Price3:=0;
       PrevMod:=0;
       Money:=0;
       TotalMod:=0;
       For I:=1 to 20 do
       Begin
           List1[I]:='';
           List2[I]:='';
           List3[I]:='';
       End;
    End;

    TakeCode1:='';
    MarkList1:='';
    TakeCode2:='';
    MarkList2:='';
    TakeCode3:='';
    MarkList3:='';

End;

Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,2,70,21,'About',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmMainMenu;
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'QSort  version 1.00a');
      CentreWinMessage(3,'<< Registered version >>');
      WriteTextColor:=1;
      CentreWinMessage(6,'Copyright (c) 1996 by Digital ToolWorks');
      WriteTextColor:=11;
      CentreWinMessage(7,'Design and Development by');
      CentreWinMessage(8,'GEORGE PAPAIOANNOY');
      WriteTextColor:=0;
      CentreWinMessage(10,'Tel - Fax (031) 236-950      Thessaloniki');
      WriteTextColor:=14;
      CentreWinMessage(13,'û There are '+KBytes+'KB free in your system.');
      CentreWinMessage(14,'û Dos version '+DosVer);


      AssignXY(25,GetWindowMaxY-1,0,0);
      InitButton('  ~OK    ',cmMainMenu,PushButton,BfDefault);
      ButtonHelp('á«ž©œ Enter š ˜ ¤˜ ¡¢œå©œ  «¦ §˜¨áŸ¬¨¦.',0);
End;

Procedure InsertNewCode1;
Var
   OldTDropDown         :PMenuNode;
Begin
   IF MaxCode1 > MaxCodes Then
      Exit;

   IF TakeCode1 = '' Then
      Exit;

   Inc(MaxCode1);
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List1^.NodePtr;
   Win^.CurMenusSeq:=List1;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF);
         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;
   InsertText(TakeCode1,$FF,$FF);

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList1:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   EnableWinCommand([cmRecList1,cmRecDel1]);

   IF MaxCode1 >= MaxCodes Then
      DisableWinCommand([cmRecInput1]);

End;

Procedure DelCode1;
Var
   OldTDropDown         :PMenuNode;
Begin
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List1^.NodePtr;
   Win^.CurMenusSeq:=List1;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         IF TDropDown^.DDText^.TextLine^ <> MarkList1 Then
            InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF)
         Else
            Dec(MaxCode1);

         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList1:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   TDropDown:=OldTDropDown^.NodePtr;


   IF GeneralHeadText = Nil Then
      DisableWinCommand([cmRecList1,cmRecDel1]);

   EnableWinCommand([cmRecInput1]);
End;

Procedure InsertNewCode2;
Var
   OldTDropDown         :PMenuNode;
Begin
   IF MaxCode2 > MaxCodes Then
      Exit;

   IF TakeCode2 = '' Then
      Exit;

   Inc(MaxCode2);
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List2^.NodePtr;
   Win^.CurMenusSeq:=List2;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF);
         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;
   InsertText(TakeCode2,$FF,$FF);

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList2:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   EnableWinCommand([cmRecList2,cmRecDel2]);


   IF MaxCode2 >= MaxCodes Then
      DisableWinCommand([cmRecInput2]);

End;

Procedure DelCode2;
Var
   OldTDropDown         :PMenuNode;
Begin
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List2^.NodePtr;
   Win^.CurMenusSeq:=List2;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         IF TDropDown^.DDText^.TextLine^ <> MarkList2 Then
            InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF)
         Else
            Dec(MaxCode2);

         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList2:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   TDropDown:=OldTDropDown^.NodePtr;

   IF GeneralHeadText = Nil Then
      DisableWinCommand([cmRecList2,cmRecDel2]);

   EnableWinCommand([cmRecInput2]);
End;

Procedure InsertNewCode3;
Var
   OldTDropDown         :PMenuNode;
Begin
   IF MaxCode3 > MaxCodes Then
      Exit;

   IF TakeCode3='' Then
      Exit;

   Inc(MaxCode3);
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List3^.NodePtr;
   Win^.CurMenusSeq:=List3;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF);
         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;
   InsertText(TakeCode3,$FF,$FF);

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList3:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   EnableWinCommand([cmRecList3,cmRecDel3]);

   IF MaxCode3 >= MaxCodes Then
      DisableWinCommand([cmRecInput3]);

End;

Procedure DelCode3;
Var
   OldTDropDown         :PMenuNode;
Begin
   OldTDropDown:=Win^.CurMenusSeq;
   TDropDown:=List3^.NodePtr;
   Win^.CurMenusSeq:=List3;

   InitText;
   TDropDown^.DDText:=TDropDown^.DDHeadTextLine;
   Repeat
       IF TDropDown^.DDText <> Nil Then
       Begin
         IF TDropDown^.DDText^.TextLine^ <> MarkList3 Then
            InsertText(TDropDown^.DDText^.TextLine^,$FF,$FF)
         Else
            Dec(MaxCode3);
         TDropDown^.DDText:=TDropDown^.DDText^.NextTextLine;
       End;
   Until TDropDown^.DDText=Nil;

   TDropDown^.DropDownDeleteAllText;
   TDropDown^.ShowDropDownText(GeneralHeadText,GeneralTailText,1);
   MarkList3:=GeneralHeadText^.TextLine^;

   Win^.CurMenusSeq:=OldTDropDown;
   TDropDown:=OldTDropDown^.NodePtr;


   IF GeneralHeadText = Nil Then
      DisableWinCommand([cmRecList3,cmRecDel3]);

   EnableWinCommand([cmRecInput3]);
End;

Procedure TMyApp.AdjustLists;
Begin
   IF MaxCode1 >= MaxCodes Then
      DisableWinCommand([cmRecInput1]);
   IF MaxCode1 = 0 Then
      DisableWinCommand([cmRecDel1,cmRecList1]);

   IF MaxCode2 >= MaxCodes Then
      DisableWinCommand([cmRecInput2]);
   IF MaxCode2 = 0 Then
      DisableWinCommand([cmRecDel2,cmRecList2]);

   IF MaxCode3 >= MaxCodes Then
      DisableWinCommand([cmRecInput3]);
   IF MaxCode3 = 0 Then
      DisableWinCommand([cmRecDel3,cmRecList3]);
End;

Procedure TMyApp.ShowRestMoney;
Var
   RestMoney    :LongInt;
   RestMoneyS   :String[8];
Begin
  RestMoney:=( (MaxCode1*FRec.Price1)+(MaxCode2*FRec.Price2)+(MaxCode3*FRec.Price3)+FRec.PrevMod ) - FRec.Money;
  IF RestMoney > 0 Then
  Begin
      Str(RestMoney,RestMoneyS);
      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(50,20,'Final Balance     :        ');
      WriteWindow(50,20,'Final Balance :'+RestMoneyS);
      FRec.TotalMod:=RestMoney;
  End
  Else
  Begin
      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(50,20,'Final Balance :        ');
  End;
End;

Function PosoAgoras :LongInt;
Var
   M1,M2,M3     :Byte;
   I            :Byte;
Begin

  M1:=0;M2:=0;M3:=0;
  For I:=1 to 20 do
  Begin
     IF FRec.List1[I] <> '' Then
        Inc(M1);
  End;

  For I:=1 to 20 do
  Begin
     IF FRec.List2[I] <> '' Then
        Inc(M2);
  End;

  For I:=1 to 20 do
  Begin
     IF FRec.List3[I] <> '' Then
        Inc(M3);
  End;

  PosoAgoras:=(M1*FRec.Price1)+(M2*FRec.Price2)+(M3*FRec.Price3);
End;


Procedure TMyApp.HandleCommand;
Begin
   Case Event of

      cmQuit       :Begin
                      ExitFromProgram:=True;
                      CloseWindow;
                    End;
      cmCloseWin   :CloseWindow;
      cmAbout      :Begin
                       CloseWindow;
                       About;
                    End;
      cmMainMenu   :Begin
                        CloseWindow;
                        MainMenu;
                    End;
      cmCustomers       :Begin
                            CloseWindow;
                            Customers;
                         End;
      cmInputCustomer   :Begin
                           IF FRec.Name = '?' Then
                           Begin
                              FRec.Name:='';
                              TInputLine:=NameInputLine;
                              TInputLine^.SetNewData(ESpacesRight(FRec.Name));
                              NameList;
                           End
                           Else
                              InputCustomer;
                         End;
      cmInputCustomer2  :AskUserInputCustomer2;
      cmDoInputCustomer2:Begin
                            CloseWindow;
                            InputCustomer2;
                         End;
      cmCancelCustomer  :Begin
                             CloseWindow;
                             MainMenu;
                         End;
      cmSort            :Begin
                            CloseWindow;
                            Sort;
                         End;
      cmSearchCustomer  :Begin
                            CloseWindow;
                            SearchCustomerA;
                         End;
      cmInputOutput     :Begin
                             CloseWindow;
                             InputOutput;
                         End;
      cmPrinter         :Begin
                             CloseWindow;
                             Printer;
                         End;
     {***********************************************}
      cmRecDate         :FRec.Date:=InputLineStr;
      cmRecName         :FRec.Name:=InputLineStr;
      cmRecCode1        :TakeCode1:=InputLineStr;
      cmRecInput1       :InsertNewCode1;
      cmRecDel1         :DelCode1;
      cmRecPrice1       :Val(InputLineStr,FRec.Price1,ErCode);
      cmRecList1        :MarkList1:=DropDownCurrentStr;

      cmRecCode2        :TakeCode2:=InputLineStr;
      cmRecInput2       :InsertNewCode2;
      cmRecDel2         :DelCode2;
      cmRecPrice2       :Val(InputLineStr,FRec.Price2,ErCode);
      cmRecList2        :MarkList2:=DropDownCurrentStr;

      cmRecCode3        :TakeCode3:=InputLineStr;
      cmRecInput3       :InsertNewCode3;
      cmRecDel3         :DelCode3;
      cmRecPrice3       :Val(InputLineStr,FRec.Price3,ErCode);
      cmRecList3        :MarkList3:=DropDownCurrentStr;

      cmRecPrevMod      :Val(InputLineStr,FRec.PrevMod,ErCode);
      cmRecMoney        :Val(InputLineStr,FRec.Money,ErCode);
      cmCalcTotalMod    :ShowRestMoney;

      cmTakeListName    :Begin
                           IF (MenuBoxDoubleClick = True) or (Ctrl=#13) Then
                           Begin
                             FRec.Name:=ESpacesRight(MenuBoxCurrentStr);
                             CloseWindow;
                             TInputLine:=NameInputLine;
                             TInputLine^.SetNewData(ESpacesRight(FRec.Name));
                           End;
                         End;
      cmAskUserDeleteCustomer:AskUserDeleteCustomer;
      cmDeleteCustomer       :Begin
                                   CloseWindow;
                                   DeleteCustomer;
                              End;
      {**********************************}
      cmSearchDiskCustomer:SearchDiskCustomer;
      cmNextCustomer      :NextCustomer;



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



Procedure TMyApp.CustomData;
Var
   Year,Month,Day,DOW :Word;
   YearS,MonthS,DayS  :String[4];
   R                  :Pointer;
Begin

      InitRecord;

      MaxCode1:=0;
      MaxCode2:=0;
      MaxCode3:=0;


      WriteTextColor:=14;
      WriteTextBackGround:=Win^.WTextBackGround;

      GetDate(Year,Month,Day,DOW);
      Str(Year,YearS);
      Str(Month,MonthS);
      Str(Day,DayS);

      AssignXY(14,2,26,2);
      InitInputLine(cmRecDate,11,SetFullDate(YearS,MonthS,DayS));
      InputLineMask('  /  /  ');
      InputLineLabel(2,2,'~Date       :');
      FRec.Date:=SetFullDate(YearS,MonthS,DayS);

      AssignXY(14,3,41,3);
      InitInputLine(cmRecName,25,'');
      InputLineLabel(2,3,'~Name       :');
      NameInputLine:=Win^.TailMenusSeq^.NodePtr;

      {***************************}
      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,4,GetWindowMaxX,8,' Taximeters ',8);

      AssignXY(22,5,33,5);
      InitInputLine(cmRecCode1,9,'      /  ');
      InputLineMask('      /  ');
      InputLineLabel(2,5,'Ta~ximeter code     :');

      AssignXY(51,5,0,0);
      InitButton('    ~Add    ',cmRecInput1,PushButton,BfNormal);

      AssignXY(64,5,0,0);
      InitButton('   ~Delete  ',cmRecDel1,PushButton,BfNormal);


      AssignXY(22,6,30,6);
      InitInputLine(cmRecPrice1,6,'');
      InputLineNumbers;
      InputLineLabel(2,6,'~Price per item     :');

      InitText;
      AssignXY(22,7,36,13);
      List1:=InitDropDown(cmRecList1);
      DropDownLabel(2,7,'~Taximeters list    :');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);

      DisableWinCommand([cmRecDel1,cmRecList1]);

      {*****************************}
      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,9,GetWindowMaxX,13,' Replacement parts ',8);

      AssignXY(22,10,38,10);
      InitInputLine(cmRecCode2,14,'');
      InputLineLabel(2,10,'~Replacement title  :');


      AssignXY(51,10,0,0);
      InitButton('    A~dd    ',cmRecInput2,PushButton,BfNormal);

      AssignXY(64,10,0,0);
      InitButton('   D~elete  ',cmRecDel2,PushButton,BfNormal);


      AssignXY(22,11,30,11);
      InitInputLine(cmRecPrice2,6,'');
      InputLineNumbers;
      InputLineLabel(2,11,'Price per ~item     :');

      InitText;
      AssignXY(22,12,40,18);
      List2:=InitDropDown(cmRecList2);
      DropDownLabel(2,12,'Replacement par~ts  :');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);

      DisableWinCommand([cmRecDel2,cmRecList2]);
      {************************}

      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,14,GetWindowMaxX,18,' Repairs ',8);

      AssignXY(22,15,38,15);
      InitInputLine(cmRecCode3,14,'');
      InputLineLabel(2,15,'RMA ~Code           :');

      AssignXY(51,15,0,0);
      InitButton('    Ad~d    ',cmRecInput3,PushButton,BfNormal);

      AssignXY(64,15,0,0);
      InitButton('  Delet~e   ',cmRecDel3,PushButton,BfNormal);


      AssignXY(22,16,30,16);
      InitInputLine(cmRecPrice3,6,'');
      InputLineNumbers;
      InputLineLabel(2,16,'Price per ite~m     :');

      InitText;
      AssignXY(22,17,40,23);
      List3:=InitDropDown(cmRecList3);
      DropDownLabel(2,17,'Repairing ~list     :');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);

      DisableWinCommand([cmRecDel3,cmRecList3]);
      {***************************}

      AssignXY(23,19,31,19);
      InitInputLine(cmRecPrevMod,6,'0');
      InputLineNumbers;
      InputLineLabel(2,19,'Previous Balance    :');

      AssignXY(23,20,31,20);
      InitInputLine(cmRecMoney,6,'0');
      InputLineNumbers;
      InputLineLabel(2,20,'Payments in Advance :');

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(50,20,'Final Balance  :');
      HorizontalLine(50,21,GetWindowMaxX,196);


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('     ~Save     ',CmInputCustomer,PushButton,BfDefault);

      AssignXY(18,GetWindowMaxY-1,0,0);
      InitButton('  << ~Return   ',CmCancelCustomer,PushButton,BfNormal);

      AssignXY(50,GetWindowMaxY-1,0,0);
      InitButton('   ~Balance    '+Chr(WCUpArrow1)+Chr(WCUpArrow2),cmCalcTotalMod,PushButton,BfNormal);

End;


Procedure TMyApp.Customers;
Begin

      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(2,1,79,25,'Add Customer',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <>0 Then
         HaltApplication;
      Win^.CloseCommand:=cmCancelCustomer;

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(68,1,'A/A  ---');

      CustomData;
End;

{$F+}
Procedure HandleError;
Begin
     Event:=CmMainMenu;
     MyApp.HandleCommand;
End;
{$F-}

Procedure TMyApp.NameList;
Var
   R    :Pointer;
   S    :String;
Begin
   Assign(FIndex,'Qsort.Idx');
{$I-}
   Reset(FIndex);  {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
      WriteError;
      TIOResult:=IOResult;
      Exit;
   End;

   InitText;

   While Not Eof(FIndex) do
   Begin
{$I-}
      Read(FIndex,FIRec); {$I+}
      TIOResult:=IOResult;
      IF TIOResult <> 0 Then
      Begin
          ReadError;
          Close(FIndex);
          Exit;
      End;
      Str(FIRec.Max,S);
      InsertText(SetString(FIRec.Name,30,LeftJustify)+'     '+SetString(S,11,LeftJustify),$FF,$FF);
   End;

   Close(FIndex);

   WinTextColor:=15;
   WinTextBackGround:=1;
   OpenWindow(10,3,70,23,'Names List',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow+Shadow);
   IF HeapErrorCode <>0 Then
      HaltApplication;
   Win^.CloseCommand:=cmCloseWin;
   Win^.EnterCommand:=cmTakeListName;

   AssignXY(2,2,GetWindowMaxX-1,13);
   R:=InitMenuBox('~List names inside the file index',VerScr,cmTakeListName);
   ShowMenuText(GeneralHeadText,GeneralTailText,1);

   AssignXY(2,GetWindowMaxY-1,0,0);
   InitButton('     ~OK     ',cmTakeListName,PushButton,BfDefault);

   AssignXY(18,GetWindowMaxY-1,0,0);
   InitButton('   ~Cancel   ',cmCloseWin,PushButton,BfNormal);

   IF GeneralHeadText=Nil Then
   Begin
      DisableWinCommand([cmTakeListName]);
      FRec.Name:='';
   End
   Else
      FRec.Name:=ESpacesRight(MenuBoxCurrentStr);

End;


Procedure TMyApp.ReadError;
Begin
    ErrorMessage('Error reading file data.'+#10+
                 'Process is canceled.'+#10+
                 'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);

    ErrorProcessPtr:=@HandleError;
End;

Procedure TMyApp.WriteError;
Begin
    ErrorMessage('Error writing file data.'+#10+
                 'Process is canceled.'+#10+
                 'Dos Error Report :'+TDosErrorMessage(TIOResult),bfOk);
    ErrorProcessPtr:=@HandleError;
End;


Procedure TMyApp.AskUserInputCustomer2;
Begin
   WinTextColor:=15;
   WinTextBackGround:=2;
   OpenWindow(10,8,70,16,'Notification',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow+Shadow);
   IF HeapErrorCode <>0 Then
      HaltApplication;
   Win^.CloseCommand:=cmCloseWin;

   WriteTextColor:=15;
   WriteTextBackGround:=Win^.WTextBackGround;

   CentreWinMessage(2,'Are you sure you want to save');
   CentreWinMessage(3,'the current record?');

   AssignXY(2,GetWindowMaxY-1,0,0);
   InitButton('      ~OK    ',cmDoInputCustomer2,PushButton,BfDefault);

   AssignXY(18,GetWindowMaxY-1,0,0);
   InitButton('    ~Cancel  ',cmCloseWin,PushButton,BfNormal);

End;


Procedure TMyApp.AskUserDeleteCustomer;
Begin
   WinTextColor:=15;
   WinTextBackGround:=2;
   OpenWindow(10,8,70,16,'Notification',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow+Shadow);
   IF HeapErrorCode <>0 Then
      HaltApplication;
   Win^.CloseCommand:=cmCloseWin;

   WriteTextColor:=15;
   WriteTextBackGround:=Win^.WTextBackGround;

   CentreWinMessage(2,'Are you sure you want to delete');
   CentreWinMessage(3,'the current record?');

   AssignXY(2,GetWindowMaxY-1,0,0);
   InitButton('     ~OK     ',cmDeleteCustomer,PushButton,BfNormal);

   AssignXY(18,GetWindowMaxY-1,0,0);
   InitButton('   ~Cancel   ',cmCloseWin,PushButton,BfDefault);

End;

Procedure TMyApp.NextCustomer;
Var
   Found        :Boolean;
   S            :String;
Begin
        Assign(FData,'QSort.Dat');
{$I-}   Reset(FData); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            ReadError;
            Exit;
        End;

        Assign(FIndex,'QSort.Idx');
{$I-}   Reset(FIndex); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            Close(FData);
            ReadError;
            Exit;
        End;

{$I-}   Seek(FIndex,RecPosition+1); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

        Found:=False;
        While (Not Eof(FIndex)) and (Found=False) Do
        Begin
{$I-}     Read(FIndex,FIRec); {$I+}
          TIOResult:=IOResult;
          IF TIOResult <> 0 Then
          Begin
              Close(FData);
              Close(FIndex);
              ReadError;
              Exit;
          End;

          IF FIRec.Name = FRec.Name Then
             Found:=True;
        End;


        IF Found=True Then
        Begin
            InitRecord;
            RecPosition:=FilePos(FIndex)-1;
    {$I-}   Seek(FData,RecPosition); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                ReadError;
                Close(FData);
                Close(FIndex);
                Exit;
            End;

    {$I-}   Read(FData,FRec); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                ReadError;
                Close(FData);
                Close(FIndex);
                Exit;
            End;

            DoneWindowObjects;
            SearchCustomerB;
            AdjustLists;
            ShowRestMoney;
            WriteTextColor:=11;
            WriteTextBackGround:=Win^.WTextBackGround;
            Str(RecPosition,S);
            WriteWindow(73,1,S);


        End
        Else
        Begin
            ErrorMessage('There is no other record with this'+#10+
                         'name.',bfOk);
        End;

        Close(FData);
        Close(FIndex);

End;

Procedure TMyApp.DeleteCustomer;
Begin
        {Open the files}

        Assign(FData,'QSort.Dat');
{$I-}   Reset(FData); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            ReadError;
            Exit;
        End;

        Assign(FIndex,'QSort.Idx');
{$I-}   Reset(FIndex); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            Close(FData);
            ReadError;
            Exit;
        End;

        {Go to the last file}

{$I-}   Seek(FData,FileSize(FData)-1); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

{$I-}   Seek(FIndex,FileSize(FIndex)-1); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;


        {Read the last file}

{$I-}   Read(FData,FRec); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

{$I-}   Read(FIndex,FIRec); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

        {Go to the specific record}

{$I-}   Seek(FData,RecPosition); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

{$I-}   Seek(FIndex,RecPosition); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;


        {Overwrite the specific record}

{$I-}   Write(FData,FRec); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            WriteError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;


{$I-}   Write(FIndex,FIRec); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            WriteError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

        {Now go again to the last record}

{$I-}   Seek(FData,FileSize(FData)-1); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

{$I-}   Seek(FIndex,FileSize(FIndex)-1); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FData);
            Close(FIndex);
            Exit;
        End;

        {Transcate the last record}

{$I-}   Truncate(FData); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            WriteError;
            Close(FData);
            Close(FIndex);
        End;

{$I-}   Truncate(FIndex); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            WriteError;
            Close(FData);
            Close(FIndex);
        End;


        Close(FData);
        Close(FIndex);

        ErrorMessage('  The record is deleted successfully from  '+#10+
                     '  disk.  ',bfOk);

        ErrorProcessPtr:=@HandleError;
End;

Procedure TMyApp.InputCustomer2;
Type
    SortType = Record
      Num            :LongInt;
      OriginalStr    :String[14];
    End;
Var
   IntList            :Array [1..20] of SortType;
   P1                 :Pointer;
   I,M,J              :Byte;
   ErCode             :Integer;
   TraceDropDown      :PDropDown;
   Temp               :LongInt;
   Temp2              :String[14];
Begin

   FRec.Name:=ESpacesRight(FRec.Name);

   IF FRec.Name = '' Then
   Begin
    ErrorMessage('The customers name is mandatory.'+#10+
                 'Please fill the name field and'+#10+
                 'try again.',bfOk);
    Exit;
   End;


{$I-}
   Assign(FData,'QSort.Dat');
   Reset(FData);  {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Exit;
   End;

   Assign(FIndex,'Qsort.Idx');
{$I-}
   Reset(FIndex);  {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
      WriteError;
      Close(FData);
      TIOResult:=IOResult;
      Exit;
   End;

   For I:=1 to 20 do
       IntList[I].Num:=0;

   TraceDropDown:=List1^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=0;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         Inc(I);
         Val(ESpaces(Copy(TraceDropDown^.DDText^.TextLine^,1,Pos('/',TraceDropDown^.DDText^.TextLine^)-1))
                          ,IntList[I].Num,ErCode);
         IntList[I].OriginalStr:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;


   For M:=1 to 20 do
       FRec.List1[M]:='';

   IF I > 0 Then
   Begin
      {Now do a simple Bubble Sort}
      For M:=1 to I do
      Begin
          For J:=1 to I do
          Begin
              IF IntList[M].Num < IntList[J].Num Then
              Begin
                  Temp:=IntList[M].Num;
                  Temp2:=IntList[M].OriginalStr;

                  IntList[M].Num:=IntList[J].Num;
                  IntList[M].OriginalStr:=IntList[J].OriginalStr;

                  IntList[J].Num:=Temp;
                  IntList[J].OriginalStr:=Temp2;
              End;
          End;
      End;

      For M:=1 to I do
          FRec.List1[M]:=IntList[M].OriginalStr;
   End;


   For M:=1 to 20 do
       FRec.List2[M]:='';

   {List2}
   TraceDropDown:=List2^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=1;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         FRec.List2[I]:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
         Inc(I);
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;


   For M:=1 to 20 do
       FRec.List3[M]:='';

   {List3}
   TraceDropDown:=List3^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=1;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         FRec.List3[I]:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
         Inc(I);
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;



   FIRec.Name:=UpCaseString(FRec.Name);
   FRec.Name:=FIRec.Name;
   FIRec.Max:=IntList[1].Num;



{$I-}
   Seek(FData,RecPosition); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       ReadError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

{$I-}
   Seek(FIndex,RecPosition); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       ReadError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

{$I-}
   Write(FData,FRec); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

{$I-}
   FIRec.Flag:=0;
   Write(FIndex,FIRec); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;


{$I-}
   Close(FData);
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FIndex);
       TIOResult:=IOResult;
       Exit;
   End;

   Close(FIndex);
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       TIOResult:=IOResult;
       Exit;
   End;
{$I+}

   ShowRestMoney;

End;

Procedure TMyApp.InputCustomer;
Type
    SortType = Record
      Num            :LongInt;
      OriginalStr    :String[14];
    End;
Var
   IntList            :Array [1..20] of SortType;
   P1                 :Pointer;
   I,M,J              :Byte;
   ErCode             :Integer;
   TraceDropDown      :PDropDown;
   Temp               :LongInt;
   Temp2              :String[14];
Begin
   FRec.Name:=ESpacesRight(FRec.Name);

   IF FRec.Name = '' Then
   Begin
    ErrorMessage('Customer name is mandatory.'+#10+
                 'Fill the name field and'+#10+
                 'try again.',bfOk);
    Exit;
   End;


{$I-}
   Assign(FData,'QSort.Dat');
   Reset(FData);  {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Exit;
   End;

   Assign(FIndex,'Qsort.Idx');
{$I-}
   Reset(FIndex);  {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
      WriteError;
      Close(FData);
      TIOResult:=IOResult;
      Exit;
   End;

   For I:=1 to 20 do
       IntList[I].Num:=0;

   TraceDropDown:=List1^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=0;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         Inc(I);
         Val(ESpaces(Copy(TraceDropDown^.DDText^.TextLine^,1,Pos('/',TraceDropDown^.DDText^.TextLine^)-1))
                          ,IntList[I].Num,ErCode);
         IntList[I].OriginalStr:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;


   For M:=1 to 20 do
       FRec.List1[M]:='';

   IF I > 0 Then
   Begin
      {Now do a simple Bubble Sort}
      For M:=1 to I do
      Begin
          For J:=1 to I do
          Begin
              IF IntList[M].Num < IntList[J].Num Then
              Begin
                  Temp:=IntList[M].Num;
                  Temp2:=IntList[M].OriginalStr;

                  IntList[M].Num:=IntList[J].Num;
                  IntList[M].OriginalStr:=IntList[J].OriginalStr;

                  IntList[J].Num:=Temp;
                  IntList[J].OriginalStr:=Temp2;
              End;
          End;
      End;

      For M:=1 to I do
          FRec.List1[M]:=IntList[M].OriginalStr;
   End;


   For M:=1 to 20 do
       FRec.List2[M]:='';

   {List2}
   TraceDropDown:=List2^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=1;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         FRec.List2[I]:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
         Inc(I);
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;


   For M:=1 to 20 do
       FRec.List3[M]:='';

   {List3}
   TraceDropDown:=List3^.NodePtr;
   P1:=TraceDropDown^.DDText;
   TraceDropDown^.DDText:=TraceDropDown^.DDHeadTextLine;
   I:=1;
   Repeat
       IF TraceDropDown^.DDText <> Nil Then
       Begin
         FRec.List3[I]:=TraceDropDown^.DDText^.TextLine^;
         TraceDropDown^.DDText:=TraceDropDown^.DDText^.NextTextLine;
         Inc(I);
       End;
   Until TraceDropDown^.DDText=Nil;
   TraceDropDown^.DDText:=P1;



   FIRec.Name:=UpCaseString(FRec.Name);
   FRec.Name:=FIRec.Name;
   FIRec.Max:=IntList[1].Num;



{$I-}
   Seek(FData,FileSize(FData)); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       ReadError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

{$I-}
   Seek(FIndex,FileSize(FIndex)); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       ReadError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

   ShowRestMoney;

{$I-}
   Write(FData,FRec); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

{$I-}
   FIRec.Flag:=0;
   Write(FIndex,FIRec); {$I+}
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       Close(FIndex);
       Exit;
   End;

   WriteTextColor:=11;
   WriteTextBackGround:=Win^.WTextBackGround;
   Str(FileSize(FData),Temp2);
   WriteWindow(73,1,Temp2);



{$I-}
   Close(FData);
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FIndex);
       TIOResult:=IOResult;
       Exit;
   End;

   Close(FIndex);
   TIOResult:=IOResult;
   IF TIOResult <> 0 Then
   Begin
       WriteError;
       Close(FData);
       TIOResult:=IOResult;
       Exit;
   End;
{$I+}

   InitRecord;
   DoneWindowObjects;
   CustomData;
   ShowRestMoney;

End;

Procedure TMyApp.Sort;
Type
    PSortType   =^SortType;
    SortType    = Record
      Number   :LongInt;
      RecNum   :Word;
      Next     :PSortType;
    End;
Var
   R            :Pointer;
   HeadSort     :PSortType;
   CurSort,
   CurSort2     :PSortType;
   I,J          :Word;
   Temp         :LongInt;
   Temp2        :Word;

   Procedure DeleteSortType;
   Begin
       IF HeadSort = Nil Then
          Exit;

       CurSort:=HeadSort;
       Repeat
          IF CurSort <> Nil Then
          Begin
             HeadSort:=CurSort^.Next;
             Dispose(CurSort);
             CurSort:=HeadSort;
          End;
       Until CurSort=Nil;
   End;

Begin

      HeadSort:=Nil;
      CurSort:=Nil;
      CurSort2:=Nil;

      Assign(FIndex,'QSort.Idx');
{$I-} Reset(FIndex); {$I+}
      TIOResult:=IOResult;
      IF TIOResult <> 0 Then
      Begin
          ReadError;
          Exit;
      End;

      I:=0;
      While Not Eof(FIndex) do
      Begin
{$I-}     Read(FIndex,FIRec); {$I+}
          TIOResult:=IOResult;
          IF TIOResult <> 0 Then
          Begin
              ReadError;
              Close(FIndex);
              Exit;
          End;
          IF MemAvail > SizeOf(CurSort) Then
          Begin
            New(CurSort);
            CurSort^.Number:=FIRec.Max;
            CurSort^.RecNum:=I;
            CurSort^.Next:=HeadSort;
            HeadSort:=CurSort;
            Inc(I);
          End;
      End;
      Close(FIndex);

      Dec(I);
      {Now do The Sort}
      CurSort2:=HeadSort;
      IF CurSort2 <> Nil Then

         Repeat
            CurSort:=HeadSort;

            Repeat
                IF (CurSort2^.Number < CurSort^.Number) and
                   (CurSort2 <> Nil) and (CurSort <> nil)  Then
                Begin
                   Temp:=CurSort2^.Number;
                   Temp2:=CurSort2^.RecNum;
                   CurSort2^.Number:=CurSort^.Number;
                   CurSort2^.RecNum:=CurSort^.RecNum;
                   CurSort^.Number:=Temp;
                   CurSort^.RecNum:=Temp2;
                End;
                CurSort:=CurSort^.Next;
            Until CurSort=Nil;

            CurSort2:=CurSort2^.Next;

         Until CurSort2 = Nil;

      Assign(FData,'QSort.Dat');
{$I-} Reset(FData); {$I+}
      TIOResult:=IOResult;
      IF TIOResult <> 0 Then
      Begin
          ReadError;
          DeleteSortType;
          Exit;
      End;

      InitText;
      CurSort:=HeadSort;
      IF CurSort = Nil Then
      Begin
          ReadError;
          DeleteSortType;
          Exit;
      End;

      Repeat
   {$I-} Seek(FData,CurSort^.RecNum); {$I+}
         TIOResult:=IOResult;
         IF TIOResult <> 0 Then
         Begin
             ReadError;
             DeleteSortType;
             DeleteText;
             Close(FData);
             Exit;
         End;

   {$I-} Read(FData,FRec); {$I+}
         TIOResult:=IOResult;
         IF TIOResult <> 0 Then
         Begin
             ReadError;
             DeleteSortType;
             DeleteText;
             Close(FData);
             Exit;
         End;

         J:=1;
         Repeat
            IF FRec.List1[J]<>'' Then
            Begin
              IF J=1 Then
                 InsertText(SetString(FRec.Name,30,LeftJustify)+'    '+FRec.List1[J],$FF,$FF)
              Else
                 InsertText(SetString('',30,LeftJustify)+'    '+FRec.List1[J],$FF,$FF);
              Inc(J);
            End;
         Until FRec.List1[J] = '';

         CurSort:=CurSort^.Next;
      Until CurSort = Nil;

      DeleteSortType;
      Close(FData);

      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(10,3,70,23,'Sorting data',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <>0 Then
         HaltApplication;
      Win^.CloseCommand:=cmMainMenu;


{      InsertText('George Papaioannou                   88976A',$FF,$FF);
      InsertText('                                      87327B',$FF,$FF);
      InsertText('                                      83456B',$FF,$FF);
      InsertText('--------------------------------------------',$FF,$FF);
      InsertText('Jonathan Maverick                     82346A',$FF,$FF);
      InsertText('                                      81234B',$FF,$FF);}

      AssignXY(2,2,GetWindowMaxX-1,13);
      R:=InitMenuBox('Codes sorted ~asceding',VerScr,NoCm);
      ShowMenuText(GeneralHeadText,GeneralTailText,1);



      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('   << ~Return  ',CmMainMenu,PushButton,BfDefault);

      AssignXY(18,GetWindowMaxY-1,0,0);
      InitButton('     ~Print    ',CmMainMenu,PushButton,BfNormal);

      AssignXY(34,GetWindowMaxY-1,0,0);
      InitButton('     ~Help     ',CmMainMenu,PushButton,BfNormal);

End;

Procedure TMyApp.SearchDiskCustomer;
Var
   Found        :Boolean;
   S            :String;
Begin
    IF FRec.Name = '?' Then
    Begin
       FRec.Name:='';
       TInputLine:=NameInputLine;
       TInputLine^.SetNewData(ESpacesRight(FRec.Name));
       NameList;
    End
    Else
    IF FRec.Name = '' Then
    Begin
        ErrorMessage('Customer name is mandatory.'+#10+
                     'Please fill the name field and'+#10+
                     'try again.',bfOk);
        Exit;
    End
    Else
    Begin
        TInputLine:=NameInputLine;
        TInputLine^.SetNewData('');

        FRec.Name:=UpCaseString(FRec.Name);

        Assign(FData,'QSort.Dat');
{$I-}   Reset(FData); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            ReadError;
            Exit;
        End;

        Assign(FIndex,'QSort.Idx');
{$I-}   Reset(FIndex); {$I+}
        TIOResult:=IOResult;
        IF TIOResult<>0 Then
        Begin
            Close(FData);
            ReadError;
            Exit;
        End;

        Found:=False;
        While (Not Eof(FIndex)) and (Found=False) Do
        Begin
{$I-}     Read(FIndex,FIRec); {$I+}
          TIOResult:=IOResult;
          IF TIOResult <> 0 Then
          Begin
              Close(FData);
              Close(FIndex);
              ReadError;
              Exit;
          End;

          IF FIRec.Name = FRec.Name Then
             Found:=True;
        End;

        InitRecord;
        RecPosition:=FilePos(FIndex)-1;
        IF Found=True Then
        Begin
    {$I-}   Seek(FData,RecPosition); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                ReadError;
                Close(FData);
                Close(FIndex);
                Exit;
            End;

    {$I-}   Read(FData,FRec); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                ReadError;
                Close(FData);
                Close(FIndex);
                Exit;
            End;

            DoneWindowObjects;
            SearchCustomerB;
            AdjustLists;
            ShowRestMoney;
            WriteTextColor:=11;
            WriteTextBackGround:=Win^.WTextBackGround;
            Str(RecPosition,S);
            WriteWindow(73,1,S);


        End
        Else
        Begin
            ErrorMessage('The record you are searching for, is not found.'+#10+
                         'Enter an new name to start a new'+#10+
                         'search.',bfOk);
        End;

        Close(FData);
        Close(FIndex);


    End;
End;

Procedure TMyApp.SearchCustomerA;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(2,1,79,25,'Customer search',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <>0 Then
         HaltApplication;
      Win^.CloseCommand:=cmCancelCustomer;

      InitRecord;
      RecPosition:=0;
      SearchCustomerB;
      DisableWinCommand([cmInputCustomer,cmAskUserDeleteCustomer,cmRecMoney,cmRecPrevMod,
       cmRecInput1,cmRecInput2,cmRecInput3,cmRecDel1,cmRecDel2,cmRecDel3,
       cmRecList1,cmRecList2,cmRecList3,cmRecCode1,cmRecCode2,cmRecCode3,
       cmRecPrice1,cmRecPrice2,cmRecPrice3,cmRecDate,cmInputCustomer2]);

End;

Procedure TMyApp.SearchCustomerB;
Var
   R                  :Pointer;
   S                  :String;
   I                  :Byte;
Begin
      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(68,1,'A/A  ---');

      WriteTextColor:=14;
      WriteTextBackGround:=Win^.WTextBackGround;

      AssignXY(14,2,26,2);
      InitInputLine(cmRecDate,11,FRec.Date);
      InputLineMask('  /  /  ');
      InputLineLabel(2,2,'~Date       :');

      AssignXY(14,3,41,3);
      InitInputLine(cmRecName,25,FRec.Name);
      InputLineLabel(2,3,'~Name       :');
      NameInputLine:=Win^.TailMenusSeq^.NodePtr;

      {***************************}
      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,4,GetWindowMaxX,8,' Taximeters ',8);


      AssignXY(22,5,33,5);
      InitInputLine(cmRecCode1,9,'      /  ');
      InputLineMask('      /  ');
      InputLineLabel(2,5,'Ta~ximeter code     :');

      AssignXY(51,5,0,0);
      InitButton('    Ad~d    ',cmRecInput1,PushButton,BfNormal);

      AssignXY(64,5,0,0);
      InitButton('  Dele~te ',cmRecDel1,PushButton,BfNormal);


      Str(FRec.Price1,S);
      AssignXY(22,6,30,6);
      InitInputLine(cmRecPrice1,6,S);
      InputLineNumbers;
      InputLineLabel(2,6,'~Pri~ce per item     :');

      InitText;
      I:=1;
      Repeat
            IF FRec.List1[I] <> '' Then
            Begin
               InsertText(FRec.List1[I],$FF,$FF);
               Inc(I);
            End;
      Until FRec.List1[I] = '';
      MaxCode1:=I-1;
      MarkList1:=FRec.List1[1];

      AssignXY(22,7,36,13);
      List1:=InitDropDown(cmRecList1);
      DropDownLabel(2,7,'~Taximeter list     :');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);

      {*****************************}
      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,9,GetWindowMaxX,13,' Replacement parts ',8);

      AssignXY(22,10,38,10);
      InitInputLine(cmRecCode2,14,'');
      InputLineLabel(2,10,'Replacement tit~le:');


      AssignXY(51,10,0,0);
      InitButton('   A~dd     ',cmRecInput2,PushButton,BfNormal);

      AssignXY(64,10,0,0);
      InitButton('  Dele~te   ',cmRecDel2,PushButton,BfNormal);


      Str(FRec.Price2,S);
      AssignXY(22,11,30,11);
      InitInputLine(cmRecPrice2,6,S);
      InputLineNumbers;
      InputLineLabel(2,11,'Price per ite~m   :');

      InitText;
      I:=1;
      Repeat
            IF FRec.List2[I] <> '' Then
            Begin
               InsertText(FRec.List2[I],$FF,$FF);
               Inc(I);
            End;
      Until FRec.List2[I] = '';
      MaxCode2:=I-1;
      MarkList2:=FRec.List2[1];

      AssignXY(22,12,40,18);
      List2:=InitDropDown(cmRecList2);
      DropDownLabel(2,12,'~Replacement parts:');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);


      {************************}

      WriteTextColor:=7;
      WriteTextBackGround:=Win^.WTextBackGround;
      InfoBox(1,14,GetWindowMaxX,18,' Repairs ',8);

      AssignXY(22,15,38,15);
      InitInputLine(cmRecCode3,14,'');
      InputLineLabel(2,15,'RMA ~Code         :');

      AssignXY(51,15,0,0);
      InitButton('    ~Add    ',cmRecInput3,PushButton,BfNormal);

      AssignXY(64,15,0,0);
      InitButton('  Dele~te   ',cmRecDel3,PushButton,BfNormal);

      Str(FRec.Price3,S);
      AssignXY(22,16,30,16);
      InitInputLine(cmRecPrice3,6,S);
      InputLineNumbers;
      InputLineLabel(2,16,'Price per ~item   :');

      InitText;
      I:=1;
      Repeat
            IF FRec.List3[I] <> '' Then
            Begin
               InsertText(FRec.List3[I],$FF,$FF);
               Inc(I);
            End;
      Until FRec.List3[I] = '';
      MaxCode3:=I-1;
      MarkList3:=FRec.List3[1];

      AssignXY(22,17,40,23);
      List3:=InitDropDown(cmRecList3);
      DropDownLabel(2,17,'Repairing ~list   :');
      ShowDropDownText(GeneralHeadText,GeneralTailText,1);


      {***************************}

      Str(FRec.PrevMod,S);
      AssignXY(23,19,31,19);
      InitInputLine(cmRecPrevMod,10,S);
      InputLineNumbers;
      InputLineLabel(2,19,'Previous Balance    :');

      Str(FRec.Money,S);
      AssignXY(23,20,31,20);
      InitInputLine(cmRecMoney,10,S);
      InputLineNumbers;
      InputLineLabel(2,20,'Payments in Advance :');

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;
      WriteWindow(50,20,'Final Balance :');
      HorizontalLine(50,21,GetWindowMaxX,196);


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton('    ~Save     ',cmInputCustomer2,PushButton,BfNormal);

      AssignXY(17,GetWindowMaxY-1,0,0);
      InitButton('   ~Delete    ',CmAskUserDeleteCustomer,PushButton,BfNormal);

      AssignXY(32,GetWindowMaxY-1,0,0);
      InitButton('  ~<< Return  ',CmCancelCustomer,PushButton,BfDefault);

      AssignXY(47,GetWindowMaxY-1,0,0);
      InitButton('    ~Search   ',CmSearchDiskCustomer,PushButton,BfNormal);

      AssignXY(62,GetWindowMaxY-1,0,0);
      InitButton('   Next >~>   ',CmNextCustomer,PushButton,BfNormal);


End;

Procedure TMyApp.DiskInputOutPut;
Var
   TraceRecPosition     :LongInt;
   TraceFIRec           :IndexStruc;
   S,S1,S2,S3           :String;
   Temaxia              :Word;
   I                    :Byte;
   Count                :Byte;
   SynolikoPosoAgoras,
   SynolikesProkataboles,
   SynolikoYpolipo      :LongInt;


   Procedure InsertNewData;
   Var
      I         :Byte;
   Begin
               Inc(Count);
               Temaxia:=0;
               For I:=1 to 20 do
                   IF FRec.List1[I] <> '' Then
                      Inc(Temaxia);

               Str(Temaxia,S);
               Str(PosoAgoras,S1);
               Str(FRec.Money,S2);
               Str(FRec.TotalMod,S3);
               IF FRec.PrevMod <> 0 Then
                  S3:=S3+' *';

               IF Count > 1 Then
                  FRec.Name:='';

               InsertText(SetString(FRec.Date,10,LeftJustify)+'³'+
                          SetString(FRec.Name,25,LeftJustify)+'³'+
                          SetString(FRec.List1[1],9,LeftJustify)+'³'+
                          SetString(S,2,LeftJustify)+'³'+
                          SetString(S1,6,LeftJustify)+'³'+
                          SetString(S2,6,LeftJustify)+'³'+
                          SetString(S3,8,LeftJustify),$FF,$FF);


               SynolikoPosoAgoras:=SynolikoPosoAgoras+PosoAgoras;
               SynolikesProkataboles:=SynolikesProkataboles+FRec.Money;
               SynolikoYpolipo:=SynolikoYpolipo+FRec.TotalMod;
               For I:=2 to 20 do
               Begin
                   IF FRec.List1[I] <> '' Then
                       InsertText(SetString('',10,LeftJustify)+'³'+
                                  SetString('',25,LeftJustify)+'³'+
                                  SetString(FRec.List1[I],9,LeftJustify)+'³'+
                                  SetString('',2,LeftJustify)+'³'+
                                  SetString('',6,LeftJustify)+'³'+
                                  SetString('',6,LeftJustify)+'³'+
                                  SetString('',8,LeftJustify),$FF,$FF);

               End;




   End;
Begin
    InitText;
    RecPosition:=0;

   SynolikoPosoAgoras:=0;
   SynolikesProkataboles:=0;
   SynolikoYpolipo:=0;


    {Open Files}

    Assign(FData,'QSort.Dat');
{$I-}   Reset(FData); {$I+}
    TIOResult:=IOResult;
    IF TIOResult<>0 Then
    Begin
        ReadError;
        Exit;
    End;

    Assign(FIndex,'QSort.Idx');
{$I-}   Reset(FIndex); {$I+}
    TIOResult:=IOResult;
    IF TIOResult<>0 Then
    Begin
        Close(FData);
        ReadError;
        Exit;
    End;

    Repeat

{$I-}   Seek(FIndex,RecPosition); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
           ReadError;
           Close(FIndex);
           Close(FData);
           Exit;
        End;
{$I-}   Read(FIndex,FIRec); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
           ReadError;
           Close(FIndex);
           Close(FData);
           Exit;
        End;

{$I-}   Seek(FIndex,RecPosition); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
           ReadError;
           Close(FIndex);
           Close(FData);
           Exit;
        End;


        Count:=0;
        TRaceFIRec:=FIRec;
        While (Not Eof(FIndex)) Do
        Begin

    {$I-} Read(FIndex,TraceFIRec); {$I+}
          TIOResult:=IOResult;
          IF TIOResult <> 0 Then
          Begin
              Close(FData);
              Close(FIndex);
              ReadError;
              Exit;
          End;

          IF (TraceFIRec.Name = FIRec.Name) and (TraceFIRec.Flag=0) Then
          Begin

                TraceFIRec.Flag:=1;
   {$I-}        Seek(FData,FilePos(FIndex)-1); {$I+}
                TIOResult:=IOResult;
                IF TIOResult <> 0 Then
                Begin
                   ReadError;
                   Close(FData);
                   Close(FIndex);
                   Exit;
                End;
    {$I-}       Read(FData,FRec); {$I+}
                TIOResult:=IOResult;
                IF TIOResult <> 0 Then
                Begin
                   ReadError;
                   Close(FData);
                   Close(FIndex);
                   Exit;
                End;
                InsertNewData;

      {$I-}     Seek(FIndex,FIlePos(FIndex)-1); {$I+}
                IF TIOResult <> 0 Then
                Begin
                    Close(FData);
                    Close(FIndex);
                    ReadError;
                    Exit;
                End;

          {$I-} Write(FIndex,TraceFIRec); {$I+}
                IF TIOResult <> 0 Then
                Begin
                    Close(FData);
                    Close(FIndex);
                    ReadError;
                    Exit;
                End;

          End;


        End;

        Inc(RecPosition);

        IF (FIRec.Flag=0) and (RecPosition <> FileSize(FIndex)) Then
           InsertText('ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ',$FF,$FF);


        Until (RecPosition=FileSize(FIndex));

{$I-}
        Close(FData);
        Seek(FIndex,0); {$I+}
        TIOResult:=IOResult;
        IF TIOResult <> 0 Then
        Begin
            ReadError;
            Close(FIndex);
            Exit;
        End;


        While Not Eof(FIndex) do
        Begin
{$I-}       Read(FIndex,FIRec); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                Close(FIndex);
                ReadError;
                Exit;
            End;

{$I-}       Seek(FIndex,FilePos(FIndex)-1); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                Close(FIndex);
                ReadError;
                Exit;
            End;

            FIRec.Flag:=0;
{$I-}       Write(FIndex,FIRec); {$I+}
            TIOResult:=IOResult;
            IF TIOResult <> 0 Then
            Begin
                Close(FIndex);
                WriteError;
                Exit;
            End;

        End;
        Close(FIndex); {$I+}

        IF (SynolikoPosoAgoras<>0) or (SynolikesProkataboles <> 0) or (SynolikoYpolipo <> 0) Then
        Begin
           InsertText('ÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ',$FF,$FF);
           Str(SynolikoPosoAgoras,S1);
           Str(SynolikesProkataboles,S2);
           Str(SynolikoYpolipo,S3);
           InsertText('                                         Total purchases      = '+S1,$FF,$FF);
           InsertText('                                         Payments in advance  = '+S2,$FF,$FF);
           InsertText('                                         --------------------------------',$FF,$FF);
           InsertText('                                         Final balance        = '+S3,$FF,$FF);
        End;

        TIOResult:=IOResult;
End;

Procedure TMyApp.InputOutPut;
Var
   R    :Pointer;
Begin

      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(1,3,80,23,'Revenue/Expenditure',WinChars+OpenFx+CloseFx+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode <>0 Then
         HaltApplication;
      Win^.CloseCommand:=cmMainMenu;

      WriteTextColor:=11;
      WriteTextBackGround:=WinTextBackGround;
      WriteWindow(3,2,'Date         Name           Code      Qnt  P.A    Retainer   Balance');
{      InitText;
      InsertText('21/05/1995³George Papaioannou  ³88976/A³3  ³1.000.000³1.000.000³1.000.000',$FF,$FF);
      InsertText('          ³                    ³87327/B³   ³         ³         ³         ',$FF,$FF);
      InsertText('          ³                    ³83456/B³   ³         ³         ³         ',$FF,$FF);
      InsertText('----------³--------------------³-------³---³---------³---------³---------',$FF,$FF);
      InsertText('22/06/1992³Jonathan Maverick   ³82346/A³123³  250.000³  150.000³  200.000',$FF,$FF);
      InsertText('          ³                    ³81234/B³   ³         ³         ³         ',$FF,$FF);
      InsertText('-------------------------------------------------------------------------',$FF,$FF);
      InsertText('                                         Purchases            = 2.000.000',$FF,$FF);
      InsertText('                                         Payments in Advance  = 1.000.000',$FF,$FF);
      InsertText('                                         --------------------------------',$FF,$FF);
      InsertText('                                         Total Balance        = 1.000.000',$FF,$FF);}


      AssignXY(2,GetWindowMaxY-1,0,0);
      InitButton(' << ~Return ',CmMainMenu,PushButton,BfDefault);

      AssignXY(18,GetWindowMaxY-1,0,0);
      InitButton('   P~rint   ',CmMainMenu,PushButton,BfNormal);

      AssignXY(34,GetWindowMaxY-1,0,0);
      InitButton('   ~Help    ',CmMainMenu,PushButton,BfNormal);


      InitText;
      AssignXY(1,3,GetWindowMaxX,16);
      R:=InitMenuBox('',VerScr,cmInOutShow);
      ShowMenuText(GeneralHeadText,GeneralTailText,1);
      IF GeneralHeadText = Nil Then
         DisableWinCommand([cmInOutShow]);

      DiskInputOutput;
      IF ActiveErrorWindow = False Then
      Begin
         ShowMenuText(GeneralHeadText,GeneralTailText,1);
         IF GeneralHeadText = Nil Then
            DisableWinCommand([cmInOutShow])
         Else
            EnableWinCommand([cmInOutShow]);
      End;


End;

Procedure TMyApp.Printer;
Begin
      WinTextColor:=15;
      WinTextBackGround:=4;
      OpenWindow(20,6,60,20,'Printing parameters',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+movement+shadow);
      Win^.CloseCommand:=cmMainMenu;
      IF HeapErrorCode <> 0 Then
         HaltApplication;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,1,15,6,' Port ',14);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(17,1,39,6,' Page feed ',14);

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,7,39,10,' Extra ',14);


      AssignXY(2,12,0,0);
      InitButton('    ~OK    ',cmMainMenu,PushButton,BfDefault);
      ButtonHelp('€§¦›¦®ã «à¤ œ§ ¢¦šé¤.',0);

      AssignXY(16,12,0,0);
      InitButton('  ~Cancel  ',cmMainMenu,PushButton,BfNormal);
      ButtonHelp('€¡ç¨à©ž «žª › ˜› ¡˜©å˜ª.',0);

      AssignXY(2,2,0,0);
      InitRadioButton(NewRItem('~LPT 1',NoCm,'Parallel port 1.',0,BfDefault,
                      NewRItem('L~PT 2',NoCm,'Parallel port 2.',0,BfNormal,
                      NewRItem('~COM 1',NoCm,'Serial port 1.',0,BfNormal,
                      NewRItem('C~OM 2',NoCm,'Serial port 2.',0,BfNormal,
                         Nil)))));

      AssignXY(18,2,0,0);
      InitRadioButton(NewRItem('~Computerized page',NoCm,'Computerized paper.',0,BfDefault,
                      NewRItem('Single Pa~ge',NoCm,'Set page.',0,BfNormal,
                         Nil)));

      AssignXY(18,8,22,8);
      InitInputLine(NoCm,3,'');
      InputLineHelp('Lines per page.',0);
      InputLineLabel(3,8,'~Lines/page:');
      InputLineNumbers;

      AssignXY(2,9,0,0);
      InitCheckBox('~Print to file.',NoCm,BfNormal);
      CheckBoxHelp('All printings are routed to a file.',0);



End;


Procedure TMyApp.MainMenu;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(5,5,75,21,'Customers',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      IF HeapErrorCode = 1 Then
         Exit;

      Win^.CloseCommand:=cmQuit;

      AssignXY(2,2,0,0);
      InitButton('  ~Customers (add new)   ',cmCustomers,PushButton,BfDefault);

      AssignXY(2,4,0,0);
      InitButton('     ~Run Sortings       ',cmSort,PushButton,BfNormal);

      AssignXY(2,6,0,0);
      InitButton('    ~Search Customer     ',cmSearchCustomer,PushButton,BfNormal);

      AssignXY(2,8,0,0);
      InitButton('  Revenue/E~xpenditure   ',cmInputOutput,PushButton,BfNormal);

      AssignXY(2,10,0,0);
      InitButton('       ~Printings        ',cmPrinter,PushButton,BfNormal);

      AssignXY(2,12,0,0);
      InitButton('        ~About           ',cmAbout,PushButton,BfNormal);

      AssignXY(2,14,0,0);
      InitButton('          E~xit          ',CmQuit,PushButton,BfNormal);

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;

      WriteWindow(28,2,'Customer functionalities.');
      WriteWindow(28,4,'Sorting customers or codes.');
      WriteWindow(28,6,'Search/Edit/Delete card.');
      WriteWindow(28,8,'Revenue-Expenditure card.');
      WriteWindow(28,10,'General printings.');
      WriteWindow(28,12,'About me.');
      WriteWindow(28,14,'Back to Dos prompt.');

End;

{$F+}
Procedure HaltApplication;
Begin
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



Begin
    DosFonts:=True;
    SetBackGround:=False;
    AllowHelpCtx:=False;

    MyApp.Init;
    MyApp.MainMenu;
    MyApp.Run;
    MyApp.Done;
End.
