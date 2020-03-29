UNIT WinObjA;


INTERFACE
Uses SavRstObj,WindowsObj,VarConstObj,GeneralObj,MouseObj,PullDnMenus,
              ErrorDlg,WinApplObj,HelpObj,Crt;



Const

    DisableWinColor        :Byte = 7;  {Disable Æ®‡£ò ö†ò ´ò ò§´†°ú†£ú§ò ´¶¨ ßò®òü¨®¶¨}

    DeskTopBackGroundColor :Byte = 0;  {BackGround Color}
    DeskTopTextColor       :Byte = 15;  {BackGround Text Color}
    DeskTopFillChar        :Byte = 176; {í¶ Æò®ò°´û®ò £ú ´¶§ ¶ß¶†¶ öú£†ù¶¨£ú ´û§ ¶ü¶§û}

    ButNormalTxtColor :Byte = 0;       {Buttons normal text Color}
    ButNormalBckColor :Byte = 7;       {Buttons normal BackGround Color}
    ButRevTxtColor    :Byte = 1;       {Buttons Current text color}
    ButRevBckColor    :Byte = 6;       {Buttons Current text background color}

    ButHorShadow      :Byte = 223;     {Ascii char for horizontal buttons shadow}
    ButVerShadow      :Byte = 220;     {Ascii char for vertical buttons shadow}

    BfDefault         = 1;  {Const ,Æ®û©†£¶ß¶†û´ò† òß¶ :Buttons,CheckBoxes,RadioButtons}
    BfNormal          = 0;  {Const ,Æ®û©†£¶ß¶†û´ò† òß¶ :Buttons,CheckBoxes,RadioButtons}

    InputLineNormTxtColor    :Byte = 15;  {InputLine normal text color}
    InputLineNormBckColor    :Byte = 255; {InputLine normal text background color}
    InputLineRevTxtColor     :Byte = 15;  {InputLine Current text color}
    InputLineRevBckColor     :Byte = 0;   {InputLine Current text backgournd}
    InputLineSelectedText    :Byte = 7;   {InputLine Marked text background color}
    InputLineNormLabelColor  :Byte = 9;  {InputLine Text Label Color}
    InputLineRevLabelColor   :Byte = 14;
    InputLineSSL             :Byte = 11;
    InputLineESL             :Byte = 12;

    {ï®û©†£¶ß¶†û©¶¨£ú ´û§ ´†£û $FF û 255 ö†ò §ò õû¢‡©¶¨£ú ¶´† ú•' ¶®†©¶¨£ú üò}
    {úÆ¶¨£ú ´¶ Æ®‡£ò ´¶¨ ´®úÆ¶§´¶™ ßò®òü¨®¶¨.                                }


    CheckBoxNormTxtColor     :Byte = 15;  {Check Box normal text Color}
    CheckBoxNormBckColor     :Byte = 255; {Check Box normal text background}
    CheckBoxRevTxtColor      :Byte = 14;  {Check Box current text color}
    CheckBoxRevBckColor      :Byte = 255; {Check Box current text background}
    CheckBoxSSL              :Byte = 11;
    CheckBoxESL              :Byte = 12;

    RadioButtonNormTxtColor  :Byte = 15;  {Radio Button normal text color}
    RadioButtonNormBckColor  :Byte = 255; {Radio Button normal text background}
    RadioButtonRevTxtColor   :Byte = 14;  {Radio Button current text color}
    RadioButtonRevBckColor   :Byte = 255; {Radio Button current text background}
    RadioButtonSSL           :Byte = 11;
    RadioButtonESL           :Byte = 12;

    ScrollBarNormTxtColor    :Byte = 255;
    ScrollBarNormBckColor    :Byte = 6;
    ScrollBarRevTxtColor     :Byte = 0;
    ScrollBarRevBckColor     :Byte = 6;

    MenuBoxNormTxtColor      :Byte = 15;
    MenuBoxNormBckColor      :Byte = 6;
    MenuBoxRevTxtColor       :Byte = 14;
    MenuBoxRevBckColor       :Byte = 6;
    MenuBoxSelectBckColor    :Byte = 0;
    MenuBoxSelectTxtColor    :Byte = 14;
    MenuBoxNoSelectTxtColor  :Byte = 14;
    MenuBoxDesktopColor      :Byte = 255;

    DropDownNormTxtColor     :Byte = 15;
    DropDownNormBckColor     :Byte = $FF;
    DropDownRevTxtColor      :Byte = 15;
    DropDownRevBckColor      :Byte = 0;
    DropDownTableColor       :Byte = 6;
    DropDownNormLabelColor   :Byte = 9;
    DropDownRevLabelColor    :Byte = 14;

    TextBoxNormTxtColor    :Byte = 15;
    TextBoxNormBckColor    :Byte = $FF;
    TextBoxRevTxtColor     :Byte = 15;
    TextBoxRevBckColor     :Byte = $FF;


    BfOk                     = 1;
    BfCancel                 = 2;
    BfIgnore                 = 4;
    BfRetry                  = 8;
    BfFail                   = 16;

    OkStr                    = '   ~OK   ';
    CancelStr                = ' ~Cancel ';
    IgnoreStr                = ' ~Ignore ';
    RetryStr                 = ' ~Retry  ';
    FailStr                  = '  ~Fail  ';

    {*******************************************}

    ReservedCmStart          = 65527; {The Start of the Reserved commands}
    ReservedCmEnd            = 65534; {The End of the REserved commands}
    ReservedCmHelpStart      = 65527; {The Start point reserved commands for help}
    ReservedCmHelpEnd        = 65529; {The end  point reserved commands for help}

    {IF a new reserved commands permeate to current API interface I have to}
    {change the ReservedCmStart and ReservedCmEnd respectively.The current}
    {reserved functions point to a far call that a user defined previously }
    {and process is taken control to our predefined piece of code.}

    ReservedCmHelpPrev       = 65527;
    ReservedCmHelpIndex      = 65528;
    ReservedCmHelpCancel     = 65529;
    ReservedCmOk             = 65530;
    ReservedCmCancel         = 65531;
    ReservedCmIgnore         = 65532;
    ReservedCmRetry          = 65533;
    ReservedCmFail           = 65534;
    NoCm                     = 0;
    {********************************************}

    VerRightDrawing           = 1;
    HorDownDrawing            = 2;
    WholeMenuBox              = 3;  {Is equal with VerRightDrawing+HorDownDrawing}


    TraceHeadMenuSeq  :PMenuNode   = Nil;  {é† £ú´òô¢û´ú™ ò¨´ú™ Æ®ú†òù¶§´ò† òß¶ ´ò}
    TraceMenuNode     :PMenuNode   = Nil;  {radio Buttons ö†ò ©‡©´û ´ò•†§¶£û©û    }
    ErrorWin          :PWinFunc    = Nil;
    ErrorSnapShot     :PScreenImage= Nil;
    TempWin           :PWinFunc    = Nil;
    PrevPDState       :Boolean     = False; {A flag that shows if access to Pd menus are allowed}
    {´†´¢‡§ £ú ´û ©‡©´û ©ú†®ò.ï®ú†òù¶§´ò† £¶§¶ ´û§ InitRadioButton.             }


    {*************** USER READ ONLY VARs *************************}
    MenuBoxCurrentNum     :Word    = 1;
    MenuBoxCurrentStr     :String  = '';
    MenuBoxDoubleClick    :Boolean = False;
    InputLineStr          :String  = '';
    CheckBoxActive        :Byte    = 0;
    RadioButtonCurrentNum :Byte    = 1;
    RadioButtonCurrentStr :String  = '';
    VerScrollBarCurrentNum:Word    = 1;
    DropDownCurrentNum    :Word    = 1;
    DropDownCurrentStr    :String  = '';
    {*************************************************************}


Var

   WindowFrame          :Byte;  {èú®†¢ò£ôò§ú†:  WinChars+WinCharsWindow}
   PullDnTextBackGround :Byte;  {Çú§†°û £ú´òô¢û´û ö†ò Pull Down normal Text BackGround Color}
   PullDnTextColor      :Byte;  {Çú§†°û £ú´òô¢û´û ö†ò Pull Down normal Text Color}

   BackFreeObject       :Byte;  {Ñ†§ò† ú§ò Flag ß¶¨ ßò†®§ú† ´†£û 255 ¶´ò§ úÆ¶¨£ú }
                                {ò§òùû´û©û object ß®¶™ ´ò ß†©‡ ú§‡ ßò†®§ú† ´†£û 0}
                                {ö†ò ò§òùû´©û ß®¶™ ´ò ú£ß®¶™.                    }
Type


   PButton=       ^Button;
   Button = Object (PullDownObj)
      BName        :Str40;    {í†´¢¶™                                   }
      BCommand     :Word;     {É†ò´òöû                                  }
      BButtonType  :Byte;     {í¨ß¶™ :PushButton or VgaButton           }
      BDefault     :Byte;     {Ä§ ú†§ò† ´¶ ´®úÆ¶§                       }
      ButX1,ButY1  :Byte;     {ï,ì ©¨§´ú´òö£ú§ú™                        }
      BHelpCtx     :^Str80;   {Status Line Help                         }
      BDiskHelp    :Word;     {On Line Help number                      }

      BButNormalTxtColor :Byte;       {Buttons normal text Color}
      BButNormalBckColor :Byte;       {Buttons normal BackGround Color}
      BButRevTxtColor    :Byte;       {Buttons Current text color}
      BButRevBckColor    :Byte;       {Buttons Current text background color}




      Procedure   HandleCommand; Virtual;
      Procedure   WinHandleEvent; Virtual;

      Procedure   InitButton(InName :Str40;InCommand :Word;InButtonType :Byte;InDefault :Byte);
      Procedure   ButtonHelp(InHelpCtx:Str80;InDiskHelp:Word);
      Procedure   PressKbButton;
      Procedure   PressMsButton;
      Procedure   ReleaseMsButton;
      Procedure   DisableButton;
      Procedure   EnableButton;

      Procedure   NormalColor;
      Procedure   DefaultColor;
      Procedure   SetButtonPalette(TxtColor,BckColor,CurTxtColor,CurBckColor :Byte);

      Procedure   HandleButtonEvent;
   End;

   PInputLine = ^InputLine;
   InputLine  = Object (Button)

       ILHelpCtx              :^Str80;  {Status Line Help                  }
       ILDiskHelp             :Word;    {On Line Help number               }
       ILCommand              :Word;    {É†ò´òöû                           }
       ILX1,ILY1,
       ILX2,ILY2              :Byte;    {ë¨§´ú´òö£ú§ú™                     }
       ILMaxChars             :Byte;    {ãúö†©´¶ ò®†ü£¶ Æò®ò°´û®‡§         }
       ILData                 :String;   {íò õúõ¶£ú§ò ß¶¨ ö®ò≠¶¨£ú          }
       ILOnlyNumbers          :Boolean; {èò†®§ú† True ò§ üú¢¶¨£ú £¶§¶ ò®†ü.}
       InputLineSelectTxt     :Boolean; {Ä§ ú†§ò† True £ß¶®¶¨£ú §ò ´¶ ©ô¨©¶¨£ú}
       ILGrowChars            :Byte;    {ëú ß¶†ò üú©û ô®†©°ú´ò† £ú©ò ©´¶ Data}
       ILStrStartPosit        :Byte;    {è¶©ú™ üú©ú†™ úÆ¶¨£ú °ò§ú† ò®†©´ú®¶ scroll}
       ILCurX                 :Byte;    {è¶¨ ô®†©°ú´ò† ¶ cursor ßò§‡ ©´û§ £ßò®ò}
       ILMsFocus              :Boolean; {Ñ§ò Flag ö†ò ´¶ ß¶§´†°†           }
       ILMask                 :^Str80;  {Mask our text with specific text}
       ILLabel                :Str40;
       ILLabX1,ILLabY1        :Byte;

       IInputLineNormTxtColor    :Byte;  {InputLine normal text color}
       IInputLineNormBckColor    :Byte; {InputLine normal text background color}
       IInputLineRevTxtColor     :Byte;  {InputLine Current text color}
       IInputLineRevBckColor     :Byte;   {InputLine Current text backgournd}
       IInputLineSelectedText    :Byte;   {InputLine Marked text background color}
       IInputLineNormLabelColor  :Byte;  {InputLine Text Label Color}
       IInputLineRevLabelColor   :Byte;
       IInputLineSSL             :Byte;
       IInputLineESL             :Byte;



       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitInputLine(InCommand :Word;InMaxChars :Byte;InData :Str80);
       Procedure   SetNewData(InData :String);
       Procedure   InputLineMask(Str :Str80);
       Procedure   InputLineHelp(InHelpCtx:Str80;InDiskHelp:Word);
       Procedure   InputLineNumbers;
       Procedure   InputLineLabel(InX1,InY1 :Byte;InLabel :Str40);
       Procedure   HandleInputLineEvent;

       Procedure   WriteInputLineData;
       Procedure   DefaultInputLineColor;
       Procedure   NormalInputLineColor;
       Procedure   DisableInputLine;
       Procedure   EnableInputLine;

       Procedure  SetInputLinePalette(TxtColor,BckColor,CurTxtColor,CurBckColor,SelectTextColor,
                                              NormLabelColor,RevLabelColor :Byte);

   End;

   PCheckBox = ^CheckBox;
   CheckBox  = Object (InputLine)

       CBX1,CBY1      :Byte;     {ë¨§´ú´òö£ú§ú™                           }
       CBTitle        :Str40;    {í†´¢¶™                                  }
       CBCommand      :Word;     {É†ò´òöû                                 }
       CBDefault      :Byte;     {Ä§ ú†§ò† Check û ¶Æ†                    }
       CBHelpCtx      :^Str80;   {Input line help                         }
       CBDiskHelp     :Word;     {On Line Help number                     }

       CCheckBoxNormTxtColor     :Byte;  {Check Box normal text Color}
       CCheckBoxNormBckColor     :Byte; {Check Box normal text background}
       CCheckBoxRevTxtColor      :Byte;  {Check Box current text color}
       CCheckBoxRevBckColor      :Byte; {Check Box current text background}
       CCheckBoxSSL              :Byte;
       CCheckBoxESL              :Byte;



       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitCheckBox(InName :Str40;InCommand :Word; InDefaultCheck :Byte);
       Procedure   CheckBoxHelp(InHelpCtx:Str80;InDiskHelp:Word);

       Procedure   DefaultCheckBoxColor;
       Procedure   NormalCheckBoxColor;

       Procedure   DisableCheckBox;
       Procedure   EnableCheckBox;

       Procedure   HandleCheckBoxEvent;
       Procedure   SetCheckBoxPalette(TxtColor,BckColor,CurTxtColor,CurBckColor :Byte);
   End;

   PRadioButton = ^RadioButton;
   RadioButton  = Object (CheckBox)

       RBX1,RBY1        :Byte;     {ë¨§´ú´òö£ú§ú™                          }
       RBMaxChoise      :Byte;     {ãúö†©´ú™ úß†¢¶öú™ ´¶¨ ´®úÆ¶§ RadioBut  }
       RBRadioNum       :Byte;     {ëú†®†ò°¶™ ò®†ü£¶™ ò®Æ†ù¶§´ò™ òß¶ 1     }
       RBHelpCtx        :^Str80;   {Status Line Help                       }
       RBDiskHelp       :Word;     {On Line Help                           }
       RBCommand        :Word;     {É†ò´òöû                                }
       RBTitle          :Str40;    {í†´¢¶™                                 }
       RBDefault        :Byte;     {Ä§ ú†§ò† Check û ¶Æ†                   }
       RBHeadRadioButton:PMenuNode;{Ä®Æû ´¶¨ ß®‡´¶¨ Radio òß¶ ´û§ ´®úÆ¶§ ¶£òõò}

       RRadioButtonNormTxtColor  :Byte;  {Radio Button normal text color}
       RRadioButtonNormBckColor  :Byte; {Radio Button normal text background}
       RRadioButtonRevTxtColor   :Byte;  {Radio Button current text color}
       RRadioButtonRevBckColor   :Byte; {Radio Button current text background}
       RRadioButtonSSL           :Byte;
       RRadioButtonESL           :Byte;



       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitRadioButton(InNext :PRadioButton);
       Function    NewRItem(InTitle :Str40;InCommand :Word;InHelpCtx :Str80;InDiskHelp :Word;InDefault :Byte;
                             InNext :PRadioButton) :PRadioButton;

       Procedure   DefaultRadioButtonColor;
       Procedure   NormalRadioButtonColor;

       Procedure   DisableRadioButton;
       Procedure   EnableRadioButton;

       Procedure   HandleRadioButtonEvent;
       Procedure   RadioButtonHandleCommand;

       Procedure   SetRadioButtonPalette(TxtColor,BckColor,CurTxtColor,CurBckColor :Byte);
   End;

   PVerScrollBar = ^VerScrollBar;
   VerScrollBar  = Object (RadioButton)

       VSBX1,VSBY1,
       VSBX2,VSBY2      :Byte;
       VSBHelpCtx       :^Str80;
       VSBDiskHelp      :Word;
       VSBCommand       :Word;
       VSBPointer       :Byte;
       VSBMaxChoises    :Word;     {ãúö†©´¶ ß¢ûü¶™ úß†¢¶ö‡§.}
       VSBPointerStep   :Byte;     {í¶ ôû£ò £ú ´¶ ¶ß¶†¶ üò ò¢¢òùú† ¶ Pointer}
       VSBVirtualYPosit :Word;

       {Palette adjustments}

       SScrollBarNormTxtColor    :Byte;
       SScrollBarNormBckColor    :Byte;
       SScrollBarRevTxtColor     :Byte;
       SScrollBarRevBckColor     :Byte;



       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Function    InitVerScrollBar(InCommand :Word) :Pointer;
       Procedure   VerScrollBarHelp(InHelpCtx :Str80;InDiskHelp :Word);

       Procedure   ClearVerScrollBarPointer;
       Procedure   SetVerScrBarMaximumChoises(MaxChoises :Word);
       Procedure   SetVerScrBarDefaultChoise(StartPoint :Word);

       Procedure   NormalVerScrollBarColor;
       Procedure   DefaultVerScrollBarColor;
       Procedure   DisableVerScrollBar;
       Procedure   EnableVerScrollBar;

       Procedure   AdjustVerScrollPointer;

       Procedure   HandleVerScrollBarEvent;
   End;


Const
  ActiveErrorWindow :Boolean = False;
  ErrorProcessPtr   :Pointer = Nil;
  VerScr                     = 1;
  DoCheckEveryThing :Boolean = True;

  UpWard                     = False;
  DownWard                   = True;


Procedure OpenErrorWindow(InX1,InY1,InX2,InY2 :Byte);
Procedure CloseErrorWindow;
Procedure ErrorMessage(Message:String;InParams :Byte);
Procedure NewMenusSeq(InIDByte :Byte;TObject :Pointer;InBroadCast,InX1,InY1,InX2,InY2 :Byte);
Procedure CheckIFDisabled(PtrMenu :PMenuNode;Var YesOrNo :Boolean);
Procedure FindNextFreeObject;
Procedure FindBackFreeObject;



Var
  TButton           :PButton;
  TInputLine        :PInputLine;
  TCheckBox         :PCheckBox;
  TRadioButton      :PRadioButton;
  TVerScrollBar     :PVerScrollBar;
  InternalHandlePtr :Pointer;






IMPLEMENTATION

{******************** ERROR WINDOWS **********************************}
{*********************************************************************}


{*********************************************************************}
{Procedure OpenErrorWindow                                            }
{Ä§¶†öú† ú§ò ßò®òü¨®¶ äòü¶¨™.                                         }
{*********************************************************************}

Procedure OpenErrorWindow(InX1,InY1,InX2,InY2 :Byte);
Var
     T             :View;
     Params        :Word;
     InTitle       :String[20];
Begin
      PrevPDState:=AccessPDMenus;
      ActiveErrorWindow:=True;
      WinTextColor:=15;
      WinTextBackGround:=4;

      IF VgaExist Then
         Params:=WinChars+WinCharsWindow+Shadow
      Else
      IF ColorCard Then
         Params:=StandardChars+Shadow
      Else
         Params:=StandardChars;

      InTitle:='  Announcement  ';

      Win^.X1:=Win^.BX1;Win^.Y1:=Win^.BY1;
      Win^.X2:=Win^.BX2;Win^.Y2:=Win^.BY2;

      Win^.SavePartOfWindowImage(Win^.BX1,Win^.Y1,Win^.X2,Win^.Y2);

      Win^.X1:=InX1;Win^.Y1:=InY1;
      Win^.X2:=InX2;Win^.Y2:=InY2;

      Win^.Params:=Params;
      Win^.Title:=InTitle;
      Win^.TitleTextColor:=WinTextColor;
      Win^.TitleTextBackground:=WinTextBackGround;
      Win^.WTextColor:=WinTextColor;
      Win^.WTextBackGround:=WinTextBackGround;
      Win^.CurrentMessageLine:='';
      Win^.WinCurX:=0;Win^.WinCurY:=0;
      Win^.WinSScanL:=$30;Win^.WinEScanL:=0;

      IF ( (InterMX+1 in [InX1..InX2+2]) or (InterMX+2 in [InX1..InX2+2]) ) AND
         ( (InterMY+1 in [InY1..InY2+2]) or (InterMY+2 in [InY1..InY2+2]) ) Then
      Begin
         HiddenMouseCursor;
         HiddenMouse:=True;
      End;

      Win^.OpenFxWin;

      Win^.TitleTextColor:=WTitleTextColor;
      Win^.TitleTextBackGround:=WTitleTextBackGround;

      Win^.DrawFrameWin;
      Win^.DrawIcons;
      Win^.ClearWin(WinTextBackground);
      Win^.DisplayTitleWin;
      IF (Params and Shadow) = Shadow Then
          Win^.DrawShadowWin;

      IF HiddenMouse Then
      Begin
        ShowMouseCursor;
        HiddenMouse:=False;
      End;

      {í¶ß¶üú´û©ú ©´û§ ¶¨®ò ´‡§ ßò®òü¨®‡§ ´¶ °ò†§¶¨®ö†¶ ßò®òü¨®¶}
      {°ò† °ò§´¶ topwindow.                                     }

      WinLayer[WindowCounter]:=WindowCounter;
      TopWindow:=WindowCounter;
      Win^.WinNumber:=WindowCounter;

      Win^.Next:=WinHead;
      WinHead:=Win;

End;

{***********************************************************************}
{Procedure CloseErrorWindow                                             }
{â¢ú†§ú† ú§ò ßò®òü¨®¶ ¢òü¶¨™.                                           }
{***********************************************************************}

Procedure CloseErrorWindow;
Var
   T    :View;
Begin
      IF ActiveErrorWindow=False Then
         Exit;


      ActiveErrorWindow:=False;
      Win^.ShowWindowImage;

      Win:=TempWin;
      WinHead:=Win;

      Dec(WindowCounter);
      TopWindow:=WindowCounter;
      IF (WindowCounter>0) and (PDActive = False) Then
      Begin
           SetVirtCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
           IF ( (InterMX+1 in [Win^.BX1..Win^.BX2]) or (InterMX+2 in [Win^.BX1..Win^.BX2]) ) AND
              ( (InterMY+1 in [Win^.BY1..Win^.BY2]) or (InterMY+2 in [Win^.BY1..Win^.BY2]) ) Then
           Begin
             HiddenMouseCursor;
             HiddenMouse:=True;
           End;
           Win^.DrawFrameWin;
           Win^.DrawIcons;
           Win^.DisplayTitleWin;
           IF HiddenMouse Then
           Begin
             ShowMouseCursor;
             HiddenMouse:=False;
           End;

           T.ShowHelpCtx(Win^.CurrentMessageLine);
      End
      Else
      IF (PDActive = True) and (AccessPDMenus=True) Then
           T.ShowHelpCtx(PullDownCurrentHelpCtx)
      Else
      IF (PDActive = False) and (WindowCounter <= 0) and (AccessPDMenus=True) Then
           T.ShowHelpCtx(InitHelpCtx);

End;

{************************************************************************}
{Procedure ErrorMessage                                                  }
{Ç®ò≠¶¨£ú ´¶ £¨§û£ò ß¶¨ üú¢¶¨£ú £ú©‡ ´û™ £ú´òô¢û´û™ Message (ö†ò ò¢¢òöû  }
{ö®ò££û™ ´¶ß¶üú´¶¨£ú ´¶§ Æò®ò°´û®ò #10) °ò† õ†§¶¨£ú úß†©û™ ´ò buttons ß¶¨}
{üò ú£≠ò§†©´¶¨§ (ÅfOk,BfCancel,BfIgnore,BfRetry,BfFail).                 }
{************************************************************************}

Procedure ErrorMessage(Message:String;InParams :Byte);
Var
     KeepStrings   :Array [1..10] Of Str80;
     Index,OldIndex:Word;
     TraceString   :Str80;
     L,I           :Word;
     MaxLength     :Byte;
     InX1,InY1,
     InX2,InY2     :Byte;
     T             :View;
     TotalLength   :Byte;
     TX1,Counter   :Byte;
     Trace         :Byte;

     SpaceAmongButtons :Byte;
     ButtonLength      :Byte;

Procedure NodeContinue;
Begin
    IF Win^.CurMenusSeq=Win^.HeadMenusSeq Then
    Begin
       TButton^.BDefault:=BfDefault;
       Win^.CurMenusSeq:=Win^.CurMenusSeq;
    End;
    Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
    Inc(Counter);
End;

Begin
      IF ActiveErrorWindow=True Then
         Exit;

      ActiveErrorWindow:=True;
      {ëÆúõ†ò©ú £ú òßò¢¶ Æ®‡£ò ´¶ frame ´¶¨ ß®¶ûö¶¨£ú§¶¨ ßò®òü¨®¶¨}

      IF (WindowCounter>0) and (PDActive = False) Then
      Begin
         WinTextColor:=Win^.WTextColor;
         Win^.WTextColor:=NotActiveColorFrame;
         HiddenMouseCursor;
         Win^.DrawFrameWin;
         ShowMouseCursor;
         Win^.WTextColor:=WinTextColor;
         CurOff;
      End;

      {Now The New window}

      Inc(WindowCounter);

      {Change the Main WIN value with the predetermined ErrorWin }
      {The ErrorWin was initialized at the Initialization part in}
      {the beginning of the program                              }

      TempWin:=Win;
      Win:=ErrorWin;


      { Zero All SubStrings                                     }
      {We can Input at maximum 10 text lines                    }

      For I:=1 to 10 do
         KeepStrings[I]:='';

      { Put The substrings into the KeepStrings Array           }

      L:=1;
      Repeat
          Index:=Pos(#10,Message);
          IF Index<>0 Then
             TraceString:=Copy(Message,1,Index-1)
          Else
             TraceString:=Copy(Message,1,Length(Message));

          IF Length(TraceString) > 80 Then
             KeepStrings[L]:=Copy(TraceString,1,80)
          Else
             KeepStrings[L]:=TraceString;

          IF Index <> 0 Then
              Message:=Copy(Message,Index+1,Length(Message));
          Inc(L);
      Until (Index=0) or (L=11);

      {Now L contains the total Rows-1                                  }
      {Now we must find the max length, so we can evaluate the window   }
      {coordinates.                                                     }

      L:=L-1;
      MaxLength:=Length(KeepStrings[1]);
      IF  L > 1 Then
         For I:=2 to L do
         Begin
            IF Length(KeepStrings[I]) > MaxLength Then
               MaxLength:=Length(KeepStrings[I]);
         End;

      {Now we are ready to compute the window coordinates               }

      InX1:=Round( ((BiosColumns div 2)-MaxLength) / 2);
      InX1:=InX1-2;
      InX2:=InX1+MaxLength+2;
      InY1:=Round( (BiosRows-L) / 2);
      InY1:=InY1-3;
      InY2:=InY1+L+6;


      {-------------------------------------------------------------------}
      {-------------------------------------------------------------------}
      {Now The real Work.First put the buttons  and the the messages      }
      {Put Names to Exist buttons                                         }

      Win^.CurMenusSeq:=Win^.HeadMenusSeq;
      Counter:=0;

      For I:=0 to 7 do
      Begin
          Trace:=1;
          Trace:=InParams and (Trace shl I);

          Case Trace OF
            BfOk     :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        TButton^.BName:=OKStr;
                        TButton^.BCommand:=ReservedCmOk;
                        Win^.CurMenusSeq^.Disabled:=False;
                        NodeContinue;
                      End;
            BfCancel :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        TButton^.BName:=CancelStr;
                        TButton^.BCommand:=ReservedCmCancel;
                        Win^.CurMenusSeq^.Disabled:=False;
                        NodeContinue;
                      End;
            BfIgnore :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        TButton^.BName:=IgnoreStr;
                        TButton^.BCommand:=ReservedCmIgnore;
                        Win^.CurMenusSeq^.Disabled:=False;
                        NodeContinue;
                      End;
            BfRetry  :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        TButton^.BName:=RetryStr;
                        TButton^.BCommand:=ReservedCmRetry;
                        Win^.CurMenusSeq^.Disabled:=False;
                        NodeContinue;
                      End;
            BfFail   :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        TButton^.BName:=FailStr;
                        TButton^.BCommand:=ReservedCmFail;
                        Win^.CurMenusSeq^.Disabled:=False;
                        NodeContinue;
                      End;
          End;
      End;

      {Make the rest buttons disable so we can't go with TAB key        }

      While Win^.CurMenusSeq<>Nil Do
      Begin
         IF Win^.CurMenusSeq <> Nil Then
         Begin
          Win^.CurMenusSeq^.Disabled:=True;
          Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
         End;
      End;

      SpaceAmongButtons:=2;
      ButtonLength:=Length(OkStr)+1;  {Because the shadow}

      IF Counter > 0 Then
      Begin
         TotalLength:=(Counter * ButtonLength) + ( (Counter-1) * SpaceAmongButtons );

         IF TotalLength > MaxLength Then
         Begin
           InX1:=Round( ((BiosColumns div 2) - TotalLength) / 2);
           InX1:=InX1-2;
           InX2:=InX1+TotalLength+2;
         End;

         IF SoundFx=On Then
            FX;
         OpenErrorWindow(InX1,InY1,InX2,InY2);

         TX1:=Round( ((InX2-InX1)-TotalLength) / 2);
         Win^.CurMenusSeq:=Win^.HeadMenusSeq;

         Repeat

            IF (Win^.CurMenusSeq<>Nil) and (Win^.CurMenusSeq^.Disabled=False) Then
            Begin
               TButton:=Win^.CurMenusSeq^.NodePtr;

               Win^.CurMenusSeq^.BroadCast:=BroadCastChar(TButton^.BName);

               TButton^.ButX1:=TX1;
               TButton^.ButY1:=(InY2-2)-InY1;
               Win^.CurMenusSeq^.X1:=TX1;
               Win^.CurMenusSeq^.Y1:=(InY2-2)-InY1;
               Win^.CurMenusSeq^.X2:=TX1+Length(TButton^.BName);
               Win^.CurMenusSeq^.Y2:=(InY2-2)-InY1;
               TButton^.ReleaseMsButton;
               Case TButton^.BDefault OF
                  BfNormal :TButton^.NormalColor;
                  BfDefault:Begin
                             TButton^.DefaultColor;
                             Win^.CurrentMessageLine:='';
                             TButton^.ShowHelpCtx('');
                            End;
               End;
               TX1:=TX1+ButtonLength+SpaceAmongButtons;
            End;
            Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
            TButton:=Win^.CurMenusSeq^.NodePtr;
         Until (Win^.CurMenusSeq^.Disabled=True) or (Win^.CurMenusSeq=Nil);
      End;

      WriteTextColor:=15;
      WriteTextBackGround:=Win^.WTextBackGround;
      HiddenMouseCursor;
      For I:=1 To L do
          CentreWinMessage(I+1,KeepStrings[I]);
      ShowMouseCursor;
      IF SoundFx=On Then
         Fx;
      AccessPDMenus:=False;


      {Invert Pascal's internal Flag}

      IF IOResult <> 0 Then
         ;

      Win^.CurMenusSeq:=Win^.HeadMenusSeq;

End;

{********************* END OF ERROR WINDOWS ******************************}
{*************************************************************************}


{***************************************************************************}
{Procedure NewMenusSeq`                                                     }
{Ñ†©òöú† ú§ò §ú¶ ò§´†°ú†£ú§¶ ßò®òü¨®¶¨ ©´û§ ¢†©´ò                           }
{***************************************************************************}

Procedure NewMenusSeq(InIDByte :Byte;TObject :Pointer;InBroadCast,InX1,InY1,InX2,InY2 :Byte);
Var
   Trace        :PMenuNode;
Begin
    New(Trace);
    Trace^.IDByte:=InIDByte;
    Trace^.NodePtr:=TObject;
    Trace^.Next:=Nil;
    Trace^.Back:=Win^.TailMenusSeq;
    Trace^.X1:=InX1;
    Trace^.Y1:=InY1;
    Trace^.X2:=InX2;
    Trace^.Y2:=InY2;
    Trace^.BroadCast:=InBroadCast;
    Trace^.Disabled:=False;


    {Not pass The first time}

    IF Win^.TailMenusSeq<>Nil Then
       Win^.TailMenusSeq^.Next:=Trace;

    Win^.TailMenusSeq:=Trace;

    IF Win^.HeadMenusSeq=Nil Then
       Win^.HeadMenusSeq:=Trace;
End;


{---------------------------------------------------------------------------}
{---------------- GENERAL ROUTINES ONLY FOR THE WIN OBJECTS ----------------}
{---------------------------------------------------------------------------}


{*************************************************************************}
{Procedure ObjectCase                                                     }
{ï®û©†£¶ß¶†û´ò† òß¶ ´†™ Procedure FindNextFreeObject,Procedure FindBack-  }
{FreeObject.Ñß†©´®ú≠ú† False ò§ ´¶ ò§´†°ú†£ú§¶ ú†§ò† ú°ö¨®¶ û True ò§     }
{ú†§ò† ©ô¨©´¶.                                                            }
{*************************************************************************}
Procedure ObjectCase(Var DisabledObj :Boolean);
Begin
    DisabledObj:=Win^.CurMenusSeq^.Disabled;
End;

{**************************************************************************}
{Procedure FindNextFreeObject                                              }
{ñòÆ§ú† °ò† ô®†©°ú† ´¶ úß¶£ú§¶ ©´û ¢†©´ò ú¢ú¨üú®¶ (¶Æ† ©ô¨©´¶) ò§´†°ú†£ú§¶.}
{**************************************************************************}

Procedure FindNextFreeObject;
Var
   DisabledObj  :Boolean;
   SaveOldMSeq  :PMenuNode;
Begin
   DisabledObj:=True;
   SaveOldMSeq:=Win^.CurMenusSeq;
   Repeat
      Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
      IF Win^.CurMenusSeq<>Nil Then
          ObjectCase(DisabledObj);

      Until (Win^.CurMenusSeq=Nil) or (DisabledObj=False);

   IF (Win^.CurMenusSeq=Nil) and (DisabledObj=True) Then
   Begin
     Win^.CurMenusSeq:=Win^.HeadMenusSeq;
     Repeat
        IF Win^.CurMenusSeq<>Nil Then
           ObjectCase(DisabledObj);

        IF DisabledObj=True Then
           Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
     Until (Win^.CurMenusSeq=Nil) or (DisabledObj=False);
   End;

   IF (DisabledObj=True) and (Win^.CurMenusSeq=Nil) Then
       Win^.CurMenusSeq:=SaveOldMSeq;

End;

{***************************************************************************}
{Procedure FindBackFreeObject                                               }
{ñòÆ§ú† °ò† ô®†©°ú† ´¶ ß®¶ûö¶¨£ú ©´û ¢†©´ò ú¢ú¨üú®¶ (¶Æ† ©ô¨©´¶) ò§´†°ú†£ú§¶}
{***************************************************************************}

Procedure FindBackFreeObject;
Var
   DisabledObj  :Boolean;
   SaveOldMSeq  :PMenuNode;
Begin
   DisabledObj:=True;
   SaveOldMSeq:=Win^.CurMenusSeq;
   Repeat
      Win^.CurMenusSeq:=Win^.CurMenusSeq^.Back;
      IF Win^.CurMenusSeq<>Nil Then
         ObjectCase(DisabledObj);
   Until (Win^.CurMenusSeq=Nil) or (DisabledObj=False);

   IF (Win^.CurMenusSeq=Nil) and (DisabledObj=True) Then
   Begin
     Win^.CurMenusSeq:=Win^.TailMenusSeq;
     Repeat
        IF Win^.CurMenusSeq<>Nil Then
           ObjectCase(DisabledObj);
        IF DisabledObj=True Then
           Win^.CurMenusSeq:=Win^.CurMenusSeq^.Back;
     Until (Win^.CurMenusSeq=Nil) or (DisabledObj=False);
   End;

   IF (DisabledObj=True) and (Win^.CurMenusSeq=Nil) Then
       Win^.CurMenusSeq:=SaveOldMSeq;

End;

{***************************************************************************}
{Procedure CheckIFDisabled                                                  }
{Ñ¢ú§Æú† ò§ ´¶ ©¨ö°ú°®†£ú§¶ ò§´†°ú†£ú§¶ ú†§ò† ©ô¨©´¶.                       }
{***************************************************************************}

Procedure CheckIFDisabled(PtrMenu :PMenuNode;Var YesOrNo :Boolean);
Begin

   IF PtrMenu^.Disabled=False Then
      YesOrNo:=False
   Else
      YesOrNo:=True;
End;





{**************************************************************************}
{ Now starts the window objects.                                           }
{                                                                          }
{                                                                          }
{**************************************************************************}

{--------------------------------------------------------------------------}
{-------------------------------BUTTONS------------------------------------}
{--------------------------------------------------------------------------}



{**************************************************************************}
{Procedure HandleCommand;Virtual                                           }
{èûöò†§ú† ©´û§ Handle Command ß¶¨ ¶®†ùú† ¶ Æ®û©´û™                         }
{**************************************************************************}

Procedure Button.HandleCommand;
Begin

End;

{**************************************************************************}
{Procedure WinHandleEvent;Virtual                                          }
{é¢ò ´ò ò§´†°ú†£ú§ò ß¶¨ Æ®û©†£¶ß¶†¶¨§ ò¨´û§ ´û§ ®¶¨´†§ò ßûöò†§¶¨§ ©´û§     }
{ò§´†©´¶†Æû ®¶¨´†§ò ´û™ Application.                                       }
{**************************************************************************}

Procedure Button.WinHandleEvent;
Begin

End;

{*************************************************************************}
{Procedure Button.InitButton                                              }
{*************************************************************************}

Procedure Button.InitButton;

Procedure DrawPushBut;
Var
    I      :Byte;
    X1,Y1  :Byte;
Begin

    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;
    IF ( (InterMX+1 in [X1..X1+Length(TButton^.BName)]) or (InterMX+2 in [X1..X1+Length(TButton^.BName)]) ) AND
       ( (InterMY+1 in [Y1..Y1+1]) or (InterMY+2 in [Y1..Y1+1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    IF MonoCard=False Then
    Begin
      For I:=X1+1 to X1+Length(TButton^.BName)-1 do
          WriteVirtWinChar(I,Y1+1,0,Win^.WTextBackGround,ButHorShadow);

      WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,0,Win^.WTextBackGround,ButVerShadow);
    End
    Else
    Begin
      WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,3,Win^.WTextBackGround,Ord(']'));
      WriteVirtWinChar(X1-1,Y1,3,Win^.WTextBackGround,Ord('['));
    End;

    IF HiddenMouse Then
    Begin
       ShowMouseCursor;
       HiddenMouse:=False;
    End;

End;

Procedure DrawVgaBut;
Var
   I      :Byte;
   X1,Y1  :Byte;
Begin
    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;

    IF ( (InterMX+1 in [X1..X1+Length(TButton^.BName)+1]) or (InterMX+2 in [X1..X1+Length(TButton^.BName)+1]) ) AND
       ( (InterMY+1 in [Y1..Y1+1]) or (InterMY+2 in [Y1..Y1+1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    For I:=X1 to X1+Length(TButton^.BName)-2 do
        WriteVirtWinChar(I,Y1-1,15,Win^.WTextBackGround,WCDnHorLineS);

    For I:=X1 to X1+Length(TButton^.BName)-2 do
        WriteVirtWinChar(I,Y1+1,0,Win^.WTextBackGround,WCUpHorLineS);

    WriteVirtWinChar(X1-1,Y1,15,Win^.WTextBackGround,WCRgVerLineS);
    WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,0,Win^.WTextBackGround,WCLfVerLineS);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;


Begin

    IF HeapErrorCode=1 Then
    Begin
        TButton:=Nil;
        Exit;
    End;

    New(TButton);

    IF TButton=Nil Then
       Exit;

    TButton^.ButX1:=ObjectX1;
    TButton^.ButY1:=ObjectY1;
    IF InName<>'' Then
       ObjectX2:=ObjectX1+Length(InName)-1
    Else
       ObjectX2:=1;

    NewMenusSeq(Buttons,TButton,BroadCastChar(InName),ObjectX1,ObjectY1,ObjectX2,ObjectY1);

    TButton^.BName:=InName;
    TButton^.BCommand:=InCommand;
    TButton^.BButtonType:=InButtonType;
    TButton^.BDefault:=InDefault;
    TButton^.BHelpCtx:=Nil;
    TButton^.BDiskHelp:=0;

    TButton^.BButNormalTxtColor :=ButNormalTxtColor;
    TButton^.BButNormalBckColor :=ButNormalBckColor;
    TButton^.BButRevTxtColor    :=ButRevTxtColor;
    TButton^.BButRevBckColor    :=ButRevBckColor;


    IF (TButton^.BName<>'') AND (InCommand < ReservedCmOk) or (InCommand > ReservedCmFail) Then
    Begin
      Case TButton^.BDefault of
        BfNormal :NormalColor;
        BfDefault:Begin
                  DefaultColor;
                  Win^.CurMenusSeq:=Win^.TailMenusSeq;
                  End;
      End;

      IF MonoCard=False Then
        Case TButton^.BButtonType of
          PushButton:DrawPushBut;
          VgaButton :DrawVgaBut;
        End
      Else
      Begin
        TButton^.BButtonType:=PushButton;
        DrawPushBut;
      End;

    End;

End;

{***************************************************************************}
{Procedure Button.ButtonHelp;                                               }
{***************************************************************************}
Procedure Button.ButtonHelp;
Begin

    IF (TButton=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TButton^.BHelpCtx:=Nil
    Else
    Begin
        New(TButton^.BHelpCtx);
        IF TButton^.BHelpCtx=Nil Then
           Exit;
        TButton^.BHelpCtx^:=InHelpCtx;
    End;

    TButton^.BDiskHelp:=InDiskHelp;

    IF TButton^.BDefault = BfDefault Then
    Begin
      IF HelpWindowIsNotOpen=True Then
         CurrentHelpPtr:=InDiskHelp;

      IF TButton^.BHelpCtx<>Nil Then
      Begin
         ShowHelpCtx(TButton^.BHelpCtx^);
         Win^.CurrentMessageLine:=TButton^.BHelpCtx^;
      End
      Else
         ShowHelpCtx('');
    End;

End;

{***************************************************************************}
{Procedure Button.PressKbButton;                                            }
{***************************************************************************}

Procedure Button.PressKbButton;

Procedure PressPushButton;
Var
   I      :Byte;
   X1,Y1  :Byte;

Begin
    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;

    Inc(TButton^.ButX1);
    DefaultColor;
    Dec(TButton^.ButX1);
    IF ( (InterMX+1 in [X1..X1+Length(TButton^.BName)+1]) or (InterMX+2 in [X1..X1+Length(TButton^.BName)+1]) ) AND
       ( (InterMY+1 in [Y1..Y1+1]) or (InterMY+2 in [Y1..Y1+1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteVirtWinChar(X1,Y1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
    For I:=X1+1 To X1+Length(TButton^.BName)-1 do
        WriteVirtWinChar(I,Y1+1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    RetraceDelay(ProDelay2);
    DefaultColor;

    IF ( (InterMX+1 in [X1..X1+Length(TButton^.BName)+1]) or (InterMX+2 in [X1..X1+Length(TButton^.BName)+1]) ) AND
       ( (InterMY+1 in [Y1..Y1+1]) or (InterMY+2 in [Y1..Y1+1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,0,Win^.WTextBackGround,ord(ButVerShadow));
    For I:=X1+1 To X1+Length(TButton^.BName)-1 do
        WriteVirtWinChar(I,Y1+1,0,Win^.WTextBackGround,ord(ButHorShadow));

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    RetraceDelay(ProDelay2);
End;

Procedure PressVgaButton;
Var
    X1,Y1       :Byte;
Begin
    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;

    NormalColor;
    RetraceDelay(ProDelay2);
    DefaultColor;
    RetraceDelay(ProDelay2);
    NormalColor;
    RetraceDelay(ProDelay2);
    DefaultColor;
    RetraceDelay(ProDelay2);
End;

Begin
     IF MonoCard=False Then
        Case TButton^.BButtonType Of
           PushButton:PressPushButton;
           VgaButton :PressVgaButton;
        End;
End;

{***************************************************************************}
{Procedure Button.PressMsButton;                                            }
{***************************************************************************}
Procedure Button.PressMsButton;
Var
  TX1,TY1,I       :Byte;
Begin

    IF MonoCard=False Then
    Begin
      TX1:=TButton^.ButX1+Win^.X1;
      TY1:=TButton^.ButY1+Win^.Y1;

      Inc(TButton^.ButX1);
      DefaultColor;
      Dec(TButton^.ButX1);

      IF ( (InterMX+1 in [TX1..TX1+Length(TButton^.BName)+1]) or (InterMX+2 in [TX1..TX1+Length(TButton^.BName)+1]) ) AND
         ( (InterMY+1 in [TY1..TY1+1]) or (InterMY+2 in [TY1..TY1+1]) ) Then
      Begin
        HiddenMouseCursor;
        HiddenMouse:=True;
      End;

      WriteVirtWinChar(TX1,TY1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
      For I:=TX1+1 To TX1+Length(TButton^.BName)-1 do
          WriteVirtWinChar(I,TY1+1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));

      IF HiddenMouse Then
      Begin
        ShowMouseCursor;
        HiddenMouse:=False;
      End;
    End;
End;

{***************************************************************************}
{Procedure Button.ReleaseMsButton;                                          }
{***************************************************************************}

Procedure Button.ReleaseMsButton;
Var
   TX1,TY1,I      :Byte;
Begin
    IF MonoCard=False Then
    Begin
      TX1:=TButton^.ButX1+Win^.X1;
      TY1:=TButton^.ButY1+Win^.Y1;

      DefaultColor;
      IF ( (InterMX+1 in [TX1..TX1+Length(TButton^.BName)+1]) or (InterMX+2 in [TX1..TX1+Length(TButton^.BName)+1]) ) AND
         ( (InterMY+1 in [TY1..TY1+1]) or (InterMY+2 in [TY1..TY1+1]) ) Then
      Begin
        HiddenMouseCursor;
        HiddenMouse:=True;
      End;

      WriteVirtWinChar(TX1+Length(TButton^.BName)-1,TY1,0,Win^.WTextBackGround,ord(ButVerShadow));
      For I:=TX1+1 To TX1+Length(TButton^.BName)-1 do
          WriteVirtWinChar(I,TY1+1,0,Win^.WTextBackGround,ord(ButHorShadow));

      IF HiddenMouse Then
      Begin
        ShowMouseCursor;
        HiddenMouse:=False;
      End;
    End;
End;

{***************************************************************************}
{Procedure Button.DisableButton;                                            }
{***************************************************************************}

Procedure Button.DisableButton;
Var
  TX1,TY1         :Byte;
Begin
    IF (TButton=Nil) or (HeapErrorCode=1) Then
       Exit;

   IF MonoCard=False Then
   Begin
    TX1:=TButton^.ButX1+Win^.X1;
    TY1:=TButton^.ButY1+Win^.Y1;

    IF VgaExist Then
    Begin
       WriteTextColor:=8;
       WriteTextBackGround:=DisableWinColor;
    End
    Else
    Begin
       WriteTextColor:=0;
       WriteTextBackGround:=7;
    End;

    IF ( (InterMX+1 in [TX1..TX1+Length(TButton^.BName)+1]) or (InterMX+2 in [TX1..TX1+Length(TButton^.BName)+1]) ) AND
       ( (InterMY+1 in [TY1..TY1+1]) or (InterMY+2 in [TY1..TY1+1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteWithOutMark(TX1,TY1,TButton^.BName);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
   End;

End;


{***************************************************************************}
{Procedure Button.EnableButton;                                             }
{***************************************************************************}
Procedure Button.EnableButton;
Var
  TX1,TY1         :Byte;
Begin
    IF (TButton=Nil) or (HeapErrorCode=1) Then
       Exit;

    TX1:=TButton^.ButX1+Win^.X1;
    TY1:=TButton^.ButY1+Win^.Y1;

    WriteTextColor:=TButton^.BButNormalTxtColor;
    WriteTextBackGround:=TButton^.BButNormalBckColor;
    WriteStrAndMark(TX1,TY1,TButton^.BName);

End;

{***************************************************************************}
{Procedure Button.NormalColor;                                              }
{***************************************************************************}
Procedure Button.NormalColor;
Var
   TX1,TY1        :Byte;
Begin

   TX1:=TButton^.ButX1+Win^.X1;
   TY1:=TButton^.ButY1+Win^.Y1;

   WriteTextColor:=TButton^.BButNormalTxtColor;
   WriteTextBackGround:=TButton^.BButNormalBckColor;
   IF ( (InterMX+1 in [TX1..TX1+Length(TButton^.BName)+1]) or (InterMX+2 in [TX1..TX1+Length(TButton^.BName)+1]) ) AND
      ( (InterMY+1 in [TY1..TY1+1]) or (InterMY+2 in [TY1..TY1+1]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   WriteStrAndMark(TX1,TY1,TButton^.BName);

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;
End;

{***************************************************************************}
{Procedure Button.DefaultColor;                                             }
{***************************************************************************}
Procedure Button.DefaultColor;
Var
   TX1,TY1        :Byte;
Begin

   TX1:=TButton^.ButX1+Win^.X1;
   TY1:=TButton^.ButY1+Win^.Y1;

   WriteTextColor:=TButton^.BButRevTxtColor;
   WriteTextBackGround:=TButton^.BButRevBckColor;

   IF ( (InterMX+1 in [TX1..TX1+Length(TButton^.BName)+1]) or (InterMX+2 in [TX1..TX1+Length(TButton^.BName)+1]) ) AND
      ( (InterMY+1 in [TY1..TY1+1]) or (InterMY+2 in [TY1..TY1+1]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   WriteStrAndMark(TX1,TY1,TButton^.BName);

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;
End;

{***************************************************************************}
{Procedure Button.SetButtonPalette;                                               }
{***************************************************************************}
Procedure Button.SetButtonPalette;
Begin
    TButton^.BButNormalTxtColor :=TxtColor;
    TButton^.BButNormalBckColor :=BckColor;
    TButton^.BButRevTxtColor    :=CurTxtColor;
    TButton^.BButRevBckColor    :=CurBckColor;
End;

{***************************************************************************}
{Procedure Button.HandleButtonEvent;                                        }
{***************************************************************************}
Procedure Button.HandleButtonEvent;
Var
   PressRelFlag :Boolean;
   Answer       :Boolean;

Procedure HandleKbEvent;
Var
   Trace   :PMenuNode;
   ButTrace:PButton;
   WX1,WY1,
   WX2,WY2 :Byte;
Begin
    TButton:=Win^.CurMenusSeq^.NodePtr;
    IF (TButton^.BCommand < ReservedCmHelpStart) or
        (TButton^.BCommand > ReservedCmHelpEnd) Then
       CurrentHelpPtr:=TButton^.BDiskHelp;

    {ãú´ò òß¶ °òüú tab „ ò¢¢òöû ú®Æ¶£ò©´ú ö†ò ©Æúõ†ò©£¶ ©ú ò¨´¶ ´¶ ©û£ú†¶}
    {£¶§¶§ ö†ò keyboard                                                  }

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;

        TButton:=Win^.CurMenusSeq^.NodePtr;
        DefaultColor;
        IF TButton^.BHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TButton^.BHelpCtx^;
           ShowHelpCtx(TButton^.BHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

        Event:=0;

        IF CtrlPressed.Address <> Nil Then
        Begin
            Event:=TButton^.BCommand;
            IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
            Asm
               call InternalHandlePtr
            End
            Else
               HandleCommand;
        End;

    End
    Else

    {ãú´ò òß¶ °òüú §ú¶ event ´¶¨ mouse ú®Æ¶£ò©´ú úò§ ú†§ò† button úõ‡ (£¶§¶ }
    {ö†ò mouse events).                                                     }

    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin

        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;

        ButTrace:=Win^.CurMenusSeq^.NodePtr;
        IF Win^.CurMenusSeq^.Disabled=False Then
        Begin
          TButton:=ButTrace;
          DefaultColor;
          IF TButton^.BHelpCtx<>Nil Then
          Begin
             Win^.CurrentMessageLine:=TButton^.BHelpCtx^;
             ShowHelpCtx(TButton^.BHelpCtx^);
          End
          Else
          Begin
             Win^.CurrentMessageLine:='';
             ShowHelpCtx('');
          End;

          WX1:=Win^.CurMenusSeq^.X1+Win^.X1;
          WX2:=Win^.CurMenusSeq^.X2+Win^.X1;
          WY1:=Win^.CurMenusSeq^.Y1+Win^.Y1;
          WY2:=Win^.CurMenusSeq^.Y2+Win^.Y1;

          PressRelFlag:=True;
          PressMsButton;
          IF MouseButton=MsIdle Then
             RetraceDelay(ProDelay1);
          Repeat

             IF (InterMX+1 in [WX1..WX2]) and (InterMY+1 in [WY1..WY2]) and (PressRelFlag=False) Then
             Begin
               PressMsButton;
               PressRelFlag:=True;
             End
             Else
             IF ( (InterMX+1 < WX1)  Or (InterMX+1 > WX2) Or
                 (InterMY+1 <WY1) Or (InterMY+1 >WY2) ) And (PressRelFlag=True) Then
             Begin
               ReleaseMsButton;
               PressRelFlag:=False;
             End;

          Until (MouseButton=msIDLE);
          ReleaseMsButton;

          IF (InterMX+1 in [WX1..WX2]) and (InterMY+1 in [WY1..WY2]) Then
          Begin
            Ctrl:=#13;
            Event:=TButton^.BCommand;
            IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
            Asm
               call InternalHandlePtr
            End
            Else
               HandleCommand;
          End;
        End;
    End
    Else
    IF  CtrlPressed.Address <> Nil Then
    Begin
        IF CtrlPressed.Address <> TButton Then
        Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TButton:=Win^.CurMenusSeq^.NodePtr;
           IF Trace^.NodePtr<>TButton Then
           Begin
             NormalColor;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
        End;

        CtrlPressed.Address:=Nil; {Come back to Normal state}
    End
    Else

    {Ñò§ ßò´û©ò£ú ENTER ´¶´ú ú¢ò úõ‡}

    IF Ctrl=#13 Then
    Begin
        TButton:=Win^.CurMenusSeq^.NodePtr;
        PressKbButton;
        Event:=TButton^.BCommand;
        IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
        Asm
           call InternalHandlePtr
        End
        Else
           HandleCommand;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }
    {Ñò§ ßò´û©ò£ú RIGHT ARROW „ DOWN ARROW ´¶´ú ú¢ò úõ‡.                  }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and ( (Ascii=#77) or (Ascii=#80) ) )Then
    Begin
         TButton:=Win^.CurMenusSeq^.NodePtr;
         IF Win^.CurMenusSeq^.Disabled=False Then
            NormalColor;
         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.H ò§ ßò´û©¶¨£ú LEFT ARROW OR}
    {UP ARROW.                                                              }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and ( (Ascii=#75) or (Ascii=#72) ) )Then
    Begin
         TButton:=Win^.CurMenusSeq^.NodePtr;
         IF Win^.CurMenusSeq^.Disabled=False Then
            NormalColor;
         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;

Begin

     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF ( MouseX in [WX1..WX2]) and ( MouseY in [WY1..WY2])  Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TButton:=Win^.CurMenusSeq^.NodePtr;
           IF Trace^.NodePtr<>TButton Then
           Begin
             IF Win^.CurMenusSeq^.Disabled=False Then
                NormalColor;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End
End;

Begin
    Case Event of
       0:HandleKbEvent;
       1:HandleMsEvent;
    End;
End;

{--------------------------------------------------------------------------}
{--------------------------INPUT LINE--------------------------------------}
{--------------------------------------------------------------------------}

{***************************************************************************}
{Procedure InputLine.HandleCommand;                                         }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure InputLine.HandleCommand;
Begin

End;

{***************************************************************************}
{Procedure InputLine.WinHandleEvent;                                        }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure InputLine.WinHandleEvent;
Begin

End;

{***************************************************************************}
{Procedure InputLine.DefaultInputLineColor;                                 }
{***************************************************************************}
Procedure InputLine.DefaultInputLineColor;
Var
   WX1,WY1,WX2,WY2      :Byte;
   ILFillChar           :Byte;
   I                    :Byte;
   Blank                :Byte;
   Name                 :Str80;
Begin
    WX1:=Win^.X1+TInputLine^.ILX1;
    WY1:=Win^.Y1+TInputLine^.ILY1;
    WX2:=Win^.X1+TInputLine^.ILX2;
    WY2:=Win^.Y1+TInputLine^.ILY2;

    IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
       ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    IF VgaExist=True Then
    Begin
       ILFillChar:=WCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,WCLeftPoint);
       WriteVirtWinChar(WX2,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,WCRightPoint);
    End
    Else
    Begin
       ILFillChar:=SCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,SCLeftArrow);
       WriteVirtWinChar(WX2,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,SCRightArrow);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    IF  TInputLine^.ILData<>'' Then
    Begin
        IF Length(TInputLine^.ILData)+WX1+1 > WX2-1 Then
        Begin
           Name:=Copy(TInputLine^.ILData,1,((WX2-1)-(WX1+1))+1);
           Blank:=0;
        End
        Else
        Begin
           Name:=TInputLine^.ILData;
           Blank:=WX1+1+Length(TInputLine^.ILData);
        End;

        WriteTextColor:=TInputLine^.IInputLineRevTxtColor;
        WriteTextBackGround:=TInputLine^.IInputLineSelectedText;

        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,TInputLine^.IInputLineRevTxtColor,TInputLine^.IInputLineRevBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

        TInputLine^.InputLineSelectTxt:=True;
    End
    Else
    Begin
        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,TInputLine^.IInputLineRevTxtColor,TInputLine^.IInputLineRevBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
           ShowMouseCursor;
           HiddenMouse:=False;
        End;
    End;

    TInputLine^.InputLineSelectTxt:=True;
End;

{***************************************************************************}
{Procedure InputLine.NormalInputLineColor;                                  }
{***************************************************************************}
Procedure InputLine.NormalInputLineColor;
Var
   WX1,WY1,WX2,WY2      :Byte;
   ILFillChar           :Byte;
   I                    :Byte;
   Name                 :Str80;
   Blank                :Byte;
Begin
    WX1:=Win^.X1+TInputLine^.ILX1;
    WY1:=Win^.Y1+TInputLine^.ILY1;
    WX2:=Win^.X1+TInputLine^.ILX2;
    WY2:=Win^.Y1+TInputLine^.ILY2;

    IF InputLineNormBckColor=255 Then
       TInputLine^.IInputLineNormBckColor:=Win^.WTextBackGround;

    IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
       ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    IF VgaExist=True Then
    Begin
       ILFillChar:=WCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,WCRightPoint);
       WriteVirtWinChar(WX2,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,WCLeftPoint);
    End
    Else
    Begin
       ILFillChar:=SCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,SCRightArrow);
       WriteVirtWinChar(WX2,WY1,TInputLine^.IInputLineNormTxtColor,Win^.WTextBackGround,SCLeftArrow);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    IF  TInputLine^.ILData<>'' Then
    Begin
        IF Length(TInputLine^.ILData)+WX1+1 > WX2-1 Then
        Begin
           Name:=Copy(TInputLine^.ILData,1,((WX2-1)-(WX1+1))+1);
           Blank:=0;
        End
        Else
        Begin
           Name:=TInputLine^.ILData;
           Blank:=WX1+1+Length(TInputLine^.ILData);
        End;

        WriteTextColor:=TInputLine^.IInputLineNormTxtColor;
        WriteTextBackGround:=TInputLine^.IInputLineNormBckColor;

        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,TInputLine^.IInputLineNormTxtColor,TInputLine^.IInputLineNormBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
    End
    Else
    Begin
        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,TInputLine^.IInputLineNormTxtColor,TInputLine^.IInputLineNormBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

    End;

    TInputLine^.InputLineSelectTxt:=True;

End;

{***************************************************************************}
{Procedure InputLine.InitInputLine;                                         }
{***************************************************************************}
Procedure InputLine.InitInputLine;
Begin
    IF HeapErrorCode=1 Then
    Begin
        TInputLine:=Nil;
        Exit;
    End;

    New(TInputLine);

    IF TInputLine=Nil Then
       Exit;

    TInputLine^.ILX1:=ObjectX1;
    TInputLine^.ILY1:=ObjectY1;
    TInputLine^.ILX2:=ObjectX2;
    TInputLine^.ILY2:=ObjectY1;

    TInputLine^.ILCommand:=InCommand;
    TInputLine^.ILMaxChars:=InMaxChars;
    TInputLine^.ILData:=InData;
    TInputLine^.InputLineSelectTxt:=False;
    TInputLine^.ILGrowChars:=1;
    TInputLine^.ILStrStartPosit:=1;
    TInputLine^.ILCurX:=0;
    TInputLine^.ILMsFocus:=False;
    TInputLine^.ILMask:=Nil;
    TInputLine^.ILHelpCtx:=Nil;
    TInputLine^.ILLabel:='';
    TInputLine^.ILLabX1:=0;
    TInputLine^.ILLabY1:=0;

    TInputLine^.IInputLineNormTxtColor    :=InputLineNormTxtColor;
    TInputLine^.IInputLineNormBckColor    :=InputLineNormBckColor;
    TInputLine^.IInputLineRevTxtColor     :=InputLineRevTxtColor;
    TInputLine^.IInputLineRevBckColor     :=InputLineRevBckColor;
    TInputLine^.IInputLineSelectedText    :=InputLineSelectedText;
    TInputLine^.IInputLineNormLabelColor  :=InputLineNormLabelColor;
    TInputLine^.IInputLineRevLabelColor   :=InputLineRevLabelColor;
    TInputLine^.IInputLineSSL             :=InputLineSSL;
    TInputLine^.IInputLineESL             :=InputLineESL;

    NewMenusSeq(InputLines,TInputLine,255,ObjectX1,ObjectY1,ObjectX2,ObjectY1);

    NormalInputLineColor;
    TInputLine^.ILOnlyNumbers:=False;

    InputLineStr:=InData;  {user read only variable}
End;

Procedure InputLine.SetNewData(InData :String);
Begin
    TInputLine^.ILData:=InData;
    InputLineStr:=InData;  {user read only variable}
    NormalInputLineColor;
End;

{***************************************************************************}
{Procedure InputLine.InputLineMask;                                         }
{***************************************************************************}

Procedure InputLine.InputLineMask;
Var
   I            :Byte;
   C            :String[1];
Begin
   IF TInputLine = Nil Then
      Exit;

   New(TInputLine^.ILMask);
   IF TInputLine^.ILMask=Nil Then
      Exit;
   TInputLine^.ILMask^:=Str;

   For I:=1 to Length(Str) do
   Begin
       C:=Copy(Str,I,1);
       IF C[1]<>' ' Then
          TInputLine^.ILData[I]:=C[1];

   End;
   IF TInputLine^.ILData[0] < TInputLine^.ILMask^[0] Then
      TInputLine^.ILData:=TInputLine^.ILData+
           Copy(TInputLine^.ILMask^,Length(TInputLine^.ILData)+1,Length(TInputLine^.ILMask^));

   {Not Input line scroll allowed so,adjust all values with the max length }
   {of the difference between X2-X1.                                       }

   IF TInputLine^.ILMaxChars > ((TInputLine^.ILX2 - TInputLine^.ILX1)-2) Then
   Begin
      TInputLine^.ILMaxChars:=((TInputLine^.ILX2 - TInputLine^.ILX1)-2);
      IF Length(TInputLine^.ILMask^) > TInputLine^.ILMaxChars Then
                TInputLine^.ILMask^:=Copy(TInputLine^.ILMask^,1,TInputLine^.ILMaxChars);
      IF Length(TInputLine^.ILData) > TInputLine^.ILMaxChars Then
                TInputLine^.ILData:=Copy(TInputLine^.ILData,1,TInputLine^.ILMaxChars);
   End;

   NormalInputLineColor;
End;

{***************************************************************************}
{Procedure InputLine.InputLineHelp;                                         }
{***************************************************************************}
Procedure InputLine.InputLineHelp;
Begin

    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TInputLine^.ILHelpCtx:=Nil
    Else
    Begin
        New(TInputLine^.ILHelpCtx);
        IF TInputLine^.ILHelpCtx=Nil Then
           Exit;
        TInputLine^.ILHelpCtx^:=InHelpCtx;
    End;

    TInputLine^.ILDiskHelp:=InDiskHelp;
End;

{**************************************************************************}
{Procedure InputLine.InputLineNumbers;                                     }
{**************************************************************************}
Procedure InputLine.InputLineNumbers;
Begin
    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
        Exit;
    TInputLine^.ILOnlyNumbers:=True;
End;

Procedure InputLine.InputLineLabel;
Begin

    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF Length(InLabel) <= 40 Then
       TInputLine^.ILLabel:=InLabel
    Else
       TInputLine^.ILLabel:=Copy(InLabel,1,40);

    TInputLine^.ILLabX1:=InX1;
    TInputLine^.ILLabY1:=InY1;

    WriteTextColor:=TInputLine^.IInputLineNormLabelColor;
    WriteTextBackGround:=Win^.WTextBackGround;
    IF ( (InterMX+1 in [Win^.X1+InX1..Win^.X1+InX1+Length(InLabel)])
        or (InterMX+1+1 in [Win^.X1+InX1..Win^.X1+InX1+Length(InLabel)]) ) AND
       ( (InterMY+1 in [Win^.Y1+InY1..Win^.Y1+InY1]) or (InterMY+2 in [Win^.Y1+InY1..Win^.Y1+InY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteStrAndMark(InX1+Win^.X1,InY1+Win^.Y1,InLabel);

    IF HiddenMouse Then
    Begin
       ShowMouseCursor;
       HiddenMouse:=False;
    End;

    Win^.TailMenusSeq^.BroadCast:=BroadCastChar(InLabel);
End;

{***************************************************************************}
{Procedure InputLine.DisableInputLine;                                      }
{***************************************************************************}
Procedure InputLine.DisableInputLine;
Var
   WX1,WY1,WX2,WY2      :Byte;
   ILFillChar           :Byte;
   I                    :Byte;
   Name                 :Str80;
   Blank                :Byte;
Begin

    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    WX1:=Win^.X1+TInputLine^.ILX1;
    WY1:=Win^.Y1+TInputLine^.ILY1;
    WX2:=Win^.X1+TInputLine^.ILX2;
    WY2:=Win^.Y1+TInputLine^.ILY2;

    IF InputLineNormBckColor=255 Then
       TInputLine^.IInputLineNormBckColor:=Win^.WTextBackGround;

    WriteTextColor:=DisableWinColor;
    WriteTextBackGround:=TInputLine^.IInputLineNormBckColor;

    IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
       ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    IF VgaExist=True Then
    Begin
       ILFillChar:=WCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,DisableWinColor,Win^.WTextBackGround,WCRightPoint);
       WriteVirtWinChar(WX2,WY1,DisableWinColor,Win^.WTextBackGround,WCLeftPoint);
    End
    Else
    Begin
       ILFillChar:=SCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,DisableWinColor,Win^.WTextBackGround,SCRightArrow);
       WriteVirtWinChar(WX2,WY1,DisableWinColor,Win^.WTextBackGround,SCLeftArrow);
    End;

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    IF  TInputLine^.ILData<>'' Then
    Begin
        IF Length(TInputLine^.ILData)+WX1+1 > WX2-1 Then
        Begin
           Name:=Copy(TInputLine^.ILData,1,((WX2-1)-(WX1+1))+1);
           Blank:=0;
        End
        Else
        Begin
           Name:=TInputLine^.ILData;
           Blank:=WX1+1+Length(TInputLine^.ILData);
        End;


        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,DisableWinColor,TInputLine^.IInputLineNormBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
    End
    Else
    Begin
        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2])) AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,DisableWinColor,TInputLine^.IInputLineNormBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;
    End;

    IF TInputLine^.ILLabel<>'' Then
    Begin
        IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILX1..Win^.X1+TInputLine^.ILX2]) or
             (InterMX+2 in [Win^.X1+TInputLine^.ILX1..Win^.X1+TInputLine^.ILX2]) )AND
           ( (InterMY+1 in [Win^.Y1+TInputLine^.ILY1..Win^.Y1+TInputLine^.ILY2]) or
             (InterMY+2 in [Win^.Y1+TInputLine^.ILY1..Win^.Y1+TInputLine^.ILY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteWithOutMark(Win^.X1+TInputLine^.ILLabX1,Win^.Y1+TInputLine^.ILLabY1,TInputLine^.ILLabel);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

    End;

End;

{***************************************************************************}
{Procedure InputLine.EnableInputLine;                                       }
{***************************************************************************}
Procedure InputLine.EnableInputLine;
Begin
    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    NormalInputLineColor;
    WriteTextColor:=TInputLine^.IInputLineNormTxtColor;;
    WriteTextBackGround:=TInputLine^.IInputLineNormBckColor;

    IF TInputLine^.ILLabel<>'' Then
    Begin
        IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILX1..Win^.X1+TInputLine^.ILX2]) or
             (InterMX+2 in [Win^.X1+TInputLine^.ILX1..Win^.X1+TInputLine^.ILX2]) )AND
           ( (InterMY+1 in [Win^.Y1+TInputLine^.ILY1..Win^.Y1+TInputLine^.ILY2]) or
             (InterMY+2 in [Win^.Y1+TInputLine^.ILY1..Win^.Y1+TInputLine^.ILY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteStrAndMark(Win^.X1+TInputLine^.ILLabX1,Win^.Y1+TInputLine^.ILLabY1,TInputLine^.ILLabel);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

    End;

End;

{**************************************************************************}
{Procedure InputLine.WriteInputLineData;                                   }
{**************************************************************************}
Procedure InputLine.WriteInputLineData;
Var
   WX1,WY1,WX2,WY2      :Byte;
   ILFillChar           :Byte;
   I                    :Byte;
   Blank                :Byte;
   Name                 :String;
Begin
    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    WX1:=Win^.X1+TInputLine^.ILX1;
    WY1:=Win^.Y1+TInputLine^.ILY1;
    WX2:=Win^.X1+TInputLine^.ILX2;
    WY2:=Win^.Y1+TInputLine^.ILY2;


    IF VgaExist=True Then
       ILFillChar:=WCInputLineFillChar
    Else
       ILFillChar:=SCInputLineFillChar;


    IF  (TInputLine^.ILData<>'') Then
    Begin
        IF (Length(TInputLine^.ILData)+WX1+1 > WX2-1) or (TInputLine^.ILStrStartPosit>1) Then
        Begin
           IF Length(TInputLine^.ILData) - ( TInputLine^.ILStrStartPosit ) < ((WX2-1)-(WX1+1))  Then
           Begin
              Name:=Copy(TInputLine^.ILData,TInputLine^.ILStrStartPosit,Length(TInputLine^.ILData));
              Blank:=(WX1+1) + ( Length(TInputLine^.ILData) - ( TInputLine^.ILStrStartPosit ) ) + 1;
           End
           Else
           Begin
              Name:=Copy(TInputLine^.ILData,TInputLine^.ILStrStartPosit,((WX2-1)-(WX1+1)));
              Blank:=WX2-1;
           End;
        End
        Else
        Begin
           Name:=TInputLine^.ILData;
           Blank:=WX1+1+Length(TInputLine^.ILData);
        End;

        WriteTextColor:=TInputLine^.IInputLineRevTxtColor;
        WriteTextBackGround:=TInputLine^.IInputLineRevBckColor;
        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,TInputLine^.IInputLineRevTxtColor,TInputLine^.IInputLineRevBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
          ShowMouseCursor;
          HiddenMouse:=False;
        End;

    End
    Else
    Begin
        IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+1+1 in [WX1..WX2]) )AND
           ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
        Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
        End;

        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,TInputLine^.IInputLineRevTxtColor,TInputLine^.IInputLineRevBckColor,ILFillChar);

        IF HiddenMouse Then
        Begin
           ShowMouseCursor;
           HiddenMouse:=False;
        End;
    End;

End;

{***************************************************************************}
{Procedure InputLine.HandleInputLineEvent;                                  }
{***************************************************************************}
Procedure InputLine.HandleInputLineEvent;
Var
   Answer       :Boolean;


Procedure HandleKBInputLineEvent;
Var
   I            :Byte;
   Found        :Boolean;
   IncX         :Byte;

Procedure InsertChar;
Var
   I            :Byte;
   Found        :Boolean;
Begin
   {If mask, then find the first blank position in mask (' ')}
   IF (TInputLine^.ILMask <> Nil) and (TInputLine^.ILGrowChars <= Length(TInputLine^.ILMask^)) Then
   Begin
      IF TInputLine^.ILMask^[TInputLine^.ILGrowChars] <> ' ' Then
      Begin
          I:=TInputLine^.ILGrowChars;
          Found:=False;
          Repeat
              IF TInputLine^.ILMask^[I] = ' ' Then
              Begin
                 Found:=True;
                 TInputLine^.ILGrowChars:=I;
                 TInputLine^.ILData[TInputLine^.ILGrowChars]:=Ctrl;
              End;
              Inc(I);
          Until (Found=True) or (I>Length(TInputLine^.ILData));
          IF Found = False Then
              Exit;
      End
      Else
        TInputLine^.ILData[TInputLine^.ILGrowChars]:=Ctrl;
   End
   Else
     Insert(Ctrl,TInputLine^.ILData,TInputLine^.ILGrowChars);


   {If mask,then check the next cursor position.}
   IF (TInputLine^.ILMask <> Nil) and (TInputLine^.ILGrowChars+1 <= Length(TInputLine^.ILMask^)) Then
   Begin
      I:=TInputLine^.ILGrowChars+1;
      Found:=False;
      IncX:=0;
      Repeat
          IF TInputLine^.ILMask^[I] = ' ' Then
          Begin
             Found:=True;
             TInputLine^.ILGrowChars:=I;
          End;
          Inc(IncX);
          Inc(I);
      Until (Found=True) or (I>Length(TInputLine^.ILMask^));
      IF (I<Length(TInputLine^.ILMask^)) and  (Found = False) Then
          Exit
      Else
      IF (I>Length(TInputLine^.ILMask^)) and  (Found = False) Then
      Begin
          TInputLine^.ILGrowChars:=Length(TInputLine^.ILMask^)+1;
          Inc(IncX);
      End;
   End
   Else
   Begin
     IncX:=1;
     Inc(TInputLine^.ILGrowChars);
   End;

   IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+IncX < Win^.X1+TInputLine^.ILX2-1 Then
   Begin
      Inc(TInputLine^.ILCurX,IncX);
      SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
   End
   Else
   IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILGrowChars+1 > Win^.X1+TInputLine^.ILX2-1 Then
   Begin
       Inc(TInputLine^.ILStrStartPosit);
       SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
   End;

   TInputLine^.InputLineSelectTxt:=False;
   TInputLine^.ILMsFocus:=True;
   WriteInputLineData;
End;

Procedure AnyChar;
Begin
    {Ñò§ úÆ¶¨£ú £ò®°ò®†©£ú§¶ °ú†£ú§¶ ´¶´ú ©ô¨©´¶ òß¶ ´û§ ö®ò££û}

    IF TInputLine^.InputLineSelectTxt=True Then
    Begin
        TInputLine^.InputLineSelectTxt:=False;
        IF TInputLine^.ILMask = Nil Then
           TInputLine^.ILData:=''
        Else
           TInputLine^.ILData:=TInputLine^.ILMask^;

        TInputLine^.ILGrowChars:=1;
        TInputLine^.ILStrStartPosit:=1;
        TInputLine^.ILCurX:=0;
    End;

    IF TInputLine^.ILOnlyNumbers=False Then
       InsertChar
    Else
    IF ((Ctrl in [#48..#57]) or (Ctrl=#46)) and (TInputLine^.ILOnlyNumbers) Then
       InsertChar;

    TInputLine^.ILMsFocus:=True;
    InputLineStr:=TInputLine^.ILData;
End;




Begin

    TInputLine:=Win^.CurMenusSeq^.NodePtr;
    CurrentHelpPtr:=TInputLine^.ILDiskHelp;
    InputLineStr:=TInputLine^.ILData;

    {ãú´ò òß¶ °òüú tab „ ò¢¢òöû ú®Æ¶£ò©´ú ö†ò ©Æúõ†ò©£¶ ©ú ò¨´¶ ´¶ ©û£ú†¶}
    {£¶§¶§ ö†ò keyboard                                                  }

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        TInputLine:=Win^.CurMenusSeq^.NodePtr;
        DefaultInputLineColor;
        IF TInputLine^.ILHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TInputLine^.ILHelpCtx^;
           ShowHelpCtx(TInputLine^.ILHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

        IF TInputLine^.ILLabel<>'' Then
        Begin
           WriteTextColor:=TInputLine^.IInputLineRevLabelColor;
           WriteTextBackGround:=Win^.WTextBackGround;

           IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)])
               or (InterMX+1+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)]) ) AND
              ( (InterMY+1 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) or
               (InterMY+2 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) ) Then
           Begin
             HiddenMouseCursor;
             HiddenMouse:=True;
           End;

           WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);

           IF HiddenMouse Then
           Begin
             ShowMouseCursor;
             HiddenMouse:=False;
           End;
        End;


        TInputLine^.ILGrowChars:=1;
        TInputLine^.ILStrStartPosit:=1;
        TInputLine^.ILCurX:=0;
        TInputLine^.ILMsFocus:=True;

        IF TInputLine^.ILMask <> Nil Then
        Begin
           I:=TInputLine^.ILGrowChars;
           Found:=False;
           IncX:=0;
           Repeat
               IF TInputLine^.ILMask^[I] = ' ' Then
               Begin
                  Found:=True;
                  TInputLine^.ILGrowChars:=I;
               End;
               Inc(IncX);
               Inc(I);
           Until (Found=True) or (I>Length(TInputLine^.ILData));
           IF Found = False Then
           Begin
               MsLeftDoubleClick:=False;
               Exit;
           End;
           Dec(IncX);
        End
        Else
          IncX:=0;

        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+IncX < Win^.X1+TInputLine^.ILX2-1 Then
        Begin
           Inc(TInputLine^.ILCurX,IncX);
           SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End
        Else
        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILGrowChars+1 > Win^.X1+TInputLine^.ILX2-1 Then
        Begin
            Inc(TInputLine^.ILStrStartPosit);
            TInputLine^.ILCurX:=Win^.X1+TInputLine^.ILX2-2;
            SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End;
        SetVirtCursorPositHeight(TInputLine^.ILX1+1+Win^.X1,TInputLine^.ILY1+Win^.Y1,InputLineSSL,InputLineESL);
    End
    Else

    {IF Mouse Button Then come Here                                      }

    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        IF ( ( (InterMX+1 >= TInputLine^.ILX1+Win^.X1) or (InterMX+2 >= TInputLine^.ILX1+Win^.X1) ) and
             ( (InterMX+1 <= TInputLine^.ILX2+Win^.X1) or (InterMX+2 <= TInputLine^.ILX2+Win^.X1) ) and
             ( (InterMY+1 =TInputLine^.ILY1+Win^.Y1) or (InterMY+2 =TInputLine^.ILY1+Win^.Y1) ) ) And
                (TInputLine^.ILMsFocus=False) Then
        Begin
            Ctrl:=#$FF;
            Ascii:=#$FF;
            HandleKBInputLineEvent;
        End
        Else
        IF ( (InterMX+1 =TInputLine^.ILX1+Win^.X1) or (InterMX+2 =TInputLine^.ILX1+Win^.X1) ) And
           ( (InterMY+1 =TInputLine^.ILY1+Win^.Y1) or (InterMY+2 =TInputLine^.ILY1+Win^.Y1) ) Then
        Begin
           Repeat
            Ctrl:=#0;
            Ascii:=#75;
            HandleKBInputLineEvent;
            RetraceDelay(ProDelay4);
           Until MouseButton=MsIDle;
        End
        Else
        IF ( (InterMX+1 =TInputLine^.ILX2+Win^.X1) or (InterMX+2 =TInputLine^.ILX2+Win^.X1) ) And
           ( (InterMY+1 =TInputLine^.ILY2+Win^.Y1) or (InterMY+2 =TInputLine^.ILY2+Win^.Y1) ) Then
        Begin
           Repeat
            Ctrl:=#0;
            Ascii:=#77;
            HandleKBInputLineEvent;
            RetraceDelay(ProDelay4);
           Until MouseButton=MsIDle;
        End;

    End
    Else

    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TInputLine:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TInputLine Then
           Begin
             NormalInputLineColor;
             CurOff;
             TInputLine^.ILMsFocus:=False;
             IF TInputLine^.ILLabel<>'' Then
             Begin
               WriteTextColor:=TInputLine^.IInputLineNormLabelColor;
               WriteTextBackGround:=Win^.WTextBackGround;
               IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)])
                 or (InterMX+2 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)]) ) AND
                 ( (InterMY+1 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) or
                 (InterMY+2 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) ) Then
               Begin
                 HiddenMouseCursor;
                 HiddenMouse:=True;
               End;

               WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);

               IF HiddenMouse Then
               Begin
                 ShowMouseCursor;
                 HiddenMouse:=False;
               End;
             End;
             Event:=TInputLine^.ILCommand;
             HandleCommand;

             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) Or ( (Ctrl=#0) and (Ascii=#80) ) Then
    Begin
         CurOff;
         TInputLine:=Win^.CurMenusSeq^.NodePtr;
         TInputLine^.ILMsFocus:=False;
         NormalInputLineColor;
         IF TInputLine^.ILLabel<>'' Then
         Begin
             WriteTextColor:=TInputLine^.IInputLineNormLabelColor;
             WriteTextBackGround:=Win^.WTextBackGround;
             IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)])
                 or (InterMX+2 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)]) ) AND
                ( (InterMY+1 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1])
                or (InterMY+2 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) ) Then
             Begin
               HiddenMouseCursor;
               HiddenMouse:=True;
             End;

             WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);

             IF HiddenMouse Then
             Begin
               ShowMouseCursor;
               HiddenMouse:=False;
             End;

         End;
         InputLineStr:=TInputLine^.ILData;
         Event:=TInputLine^.ILCommand;
         HandleCommand;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) Or ( (Ctrl=#0) and (Ascii=#72) ) Then
    Begin
         CurOff;
         TInputLine^.ILMsFocus:=False;
         TInputLine:=Win^.CurMenusSeq^.NodePtr;
         NormalInputLineColor;
         IF TInputLine^.ILLabel<>'' Then
         Begin
             WriteTextColor:=TInputLine^.IInputLineNormLabelColor;
             WriteTextBackGround:=Win^.WTextBackGround;
             IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)])
                 or (InterMX+2 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)]) ) AND
                ( (InterMY+1 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) or
                (InterMY+2 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) ) Then
             Begin
               HiddenMouseCursor;
               HiddenMouse:=True;
             End;

             WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);

             IF HiddenMouse Then
             Begin
               ShowMouseCursor;
               HiddenMouse:=False;
             End;

         End;
         InputLineStr:=TInputLine^.ILData;
         Event:=TInputLine^.ILCommand;
         HandleCommand;

         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    {IF DELETE go here.                                                  }

    IF (Ctrl=#0) and (Ascii=#83) Then
    Begin
        IF TInputLine^.InputLineSelectTxt=True Then
        Begin
            TInputLine^.InputLineSelectTxt:=False;
            IF TInputLine^.ILMask = Nil Then
               TInputLine^.ILData:=''
            Else
               TInputLine^.ILData:=TInputLine^.ILMask^;
            TInputLine^.ILGrowChars:=1;
            TInputLine^.ILStrStartPosit:=1;
            TInputLine^.ILCurX:=0;
            WriteInputLineData;
        End
        Else
        Begin
          IF (TInputLine^.ILMask = Nil)  Then
             Delete(TInputLine^.ILData,TInputLine^.ILGrowChars,1)
          Else
          IF TInputLine^.ILGrowChars <= Length(TInputLine^.ILMask^) Then
             TInputLine^.ILData[TInputLine^.ILGrowChars]:=' '
          Else
             Delete(TInputLine^.ILData,TInputLine^.ILGrowChars,1);
          WriteInputLineData;
        End;
        TInputLine^.ILMsFocus:=True;
        InputLineStr:=TInputLine^.ILData;
    End
    Else

    {Any CHAR come here                                                 }

    IF (Ctrl<>#0) and (Ctrl<>#13) and (Ctrl<>#27) and (Ctrl<>#8) Then
    Begin

        IF TInputLine^.ILMask=Nil Then
        Begin
           IF (Length(TInputLine^.ILData) < TInputLine^.ILMaxChars) Then
              AnyChar;
        End
        Else
        IF TInputLine^.ILMask<>Nil Then
        Begin
           IF TInputLine^.ILGrowChars <= TInputLine^.ILMaxChars Then
              AnyChar;
        End;
    End
    Else

    {IF BACK SPACE come here                                            }

    IF (Ctrl=#8) and (Ascii=#0) and (Length(TInputLine^.ILData) > 0 ) and
           (TInputLine^.ILCurX > 0 ) Then
    Begin
        IF (TInputLine^.ILMask <> Nil) and (TInputLine^.ILGrowChars-1   <= Length(TInputLine^.ILMask^)) Then
        Begin
            IF TInputLine^.ILMask^[TInputLine^.ILGrowChars-1] <> ' ' Then
            Begin
                I:=TInputLine^.ILGrowChars-1;
                Found:=False;
                IncX:=0;
                Repeat
                    IF TInputLine^.ILMask^[I] = ' ' Then
                    Begin
                       Found:=True;
                       TInputLine^.ILGrowChars:=I;
                    End;
                    Dec(I);
                    Inc(IncX);
                Until (Found=True) or (I<1);

                IF Found = False Then
                Begin
                    MsLeftDoubleClick:=False;
                    Exit;
                End
                Else
                IF Found Then
                 TInputLine^.ILData[TInputLine^.ILGrowChars]:=' ';
            End
            Else
            Begin
             TInputLine^.ILData[TInputLine^.ILGrowChars-1]:=' ';
             Dec(TInputLine^.ILGrowChars);
             IncX:=1;
            End;

        End
        Else
        Begin
           Delete(TInputLine^.ILData,TInputLine^.ILGrowChars-1,1);
           Dec(TInputLine^.ILGrowChars);
           IncX:=1;
        End;

        IF TInputLine^.ILStrStartPosit > 1 Then
           Dec(TInputLine^.ILStrStartPosit,IncX)
        Else
        Begin
           Dec(TInputLine^.ILCurX,IncX);
           SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End;

        WriteInputLineData;
        TInputLine^.ILMsFocus:=True;
        InputLineStr:=TInputLine^.ILData;
    End
    Else

    {IF RIGHT ARROW come here                                             }

    IF (Ctrl=#0) and (Ascii=#77) and (TInputLine^.ILGrowChars <= Length(TInputLine^.ILData) ) Then
    Begin
        IF (TInputLine^.ILMask <> Nil) and (TInputLine^.ILGrowChars+1 <= Length(TInputLine^.ILMask^)) Then
        Begin
           I:=TInputLine^.ILGrowChars+1;
           Found:=False;
           IncX:=0;
           Repeat
               IF TInputLine^.ILMask^[I] = ' ' Then
               Begin
                  Found:=True;
                  TInputLine^.ILGrowChars:=I;
               End;
               Inc(IncX);
               Inc(I);
           Until (Found=True) or (I>Length(TInputLine^.ILMask^));
           IF (Found = False) and (I<=Length(TInputLine^.ILMask^)) Then
           Begin
               MsLeftDoubleClick:=False;
               Exit;
           End
           Else
           IF (Found = False) and (I>Length(TInputLine^.ILMask^)) Then
               TInputLine^.ILGrowChars:=Length(TInputLine^.ILMask^);
        End
        Else
        Begin
          IncX:=1;
          Inc(TInputLine^.ILGrowChars);
        End;

        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+IncX < Win^.X1+TInputLine^.ILX2-1 Then
        Begin
           Inc(TInputLine^.ILCurX,IncX);
           SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End
        Else
        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILGrowChars+1 > Win^.X1+TInputLine^.ILX2-1 Then
        Begin
            Inc(TInputLine^.ILStrStartPosit);
            SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End;

        WriteInputLineData;
        TInputLine^.InputLineSelectTxt:=False;
        TInputLine^.ILMsFocus:=True;
    End
    Else

    {If LEFT ARROW come here                                            }

    IF (Ctrl=#0) and (Ascii=#75) and (TInputLine^.ILGrowChars > 1)  Then
    Begin
        IF (TInputLine^.ILMask <> Nil) and (TInputLine^.ILGrowChars-1 <= Length(TInputLine^.ILMask^)) Then
        Begin
           I:=TInputLine^.ILGrowChars-1;
           Found:=False;
           IncX:=0;
           Repeat
               IF TInputLine^.ILMask^[I] = ' ' Then
               Begin
                  Found:=True;
                  TInputLine^.ILGrowChars:=I;
               End;
               Inc(IncX);
               Dec(I);
           Until (Found=True) or (I<1);
           IF Found = False Then
           Begin
               MsLeftDoubleClick:=False;
               Exit;
           End;
        End
        Else
        Begin
          Dec(TInputLine^.ILGrowChars);
          IncX:=1;
        End;

        IF TInputLine^.ILGrowChars = 0 Then
           TInputLine^.ILGrowChars:=1;

        IF Win^.X1+TInputLine^.ILX1+(TInputLine^.ILCurX-IncX) > Win^.X1+TInputLine^.ILX1-1 Then
        Begin
           Dec(TInputLine^.ILCurX,IncX);
           SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End
        Else
        IF TInputLine^.ILStrStartPosit > 1 Then
           Dec(TInputLine^.ILStrStartPosit);

        WriteInputLineData;
        TInputLine^.InputLineSelectTxt:=False;
        TInputLine^.ILMsFocus:=True;
    End
    Else

    {IF HOME then come here                                             }

    IF (Ctrl=#0) and (Ascii=#71) Then
    Begin
         TInputLine^.ILGrowChars:=1;
         TInputLine^.ILStrStartPosit:=1;
         TInputLine^.ILCurX:=0;
         SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
         WriteInputLineData;
         TInputLine^.InputLineSelectTxt:=False;
         TInputLine^.ILMsFocus:=True;
    End
    Else

    {If END then come here                                              }

    IF (Ctrl=#0) and (Ascii=#79) Then
    Begin
            TInputLine^.ILGrowChars:=Length(TInputLine^.ILData)+1;

            IF Length(TInputLine^.ILData) > ( (Win^.X1+(TInputLine^.ILX2-1)) - (Win^.X1+(TInputLine^.ILX1+1)) ) Then
                  TInputLine^.ILStrStartPosit:=1+Length(TInputLine^.ILData) -
                              ( (Win^.X1+(TInputLine^.ILX2-1)) - (Win^.X1+(TInputLine^.ILX1+1)) )
            Else
                  TInputLine^.ILStrStartPosit:=1;

            IF TInputLine^.ILStrStartPosit > 1 Then
               TInputLine^.ILCurX:=( (Win^.X1+(TInputLine^.ILX2-1)) - (Win^.X1+(TInputLine^.ILX1+1)) )
            Else
               TInputLine^.ILCurX:=Length(TInputLine^.ILData);

            SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
            WriteInputLineData;
            TInputLine^.InputLineSelectTxt:=False;
            TInputLine^.ILMsFocus:=True;
    End;

    MsLeftDoubleClick:=False;

    {we have to inform the main user program for the changes that have made}
    {in our input line so if he press Win^.EnterCommand the program will   }
    {active with the current String Line.                                  }

    InputLineStr:=TInputLine^.ILData;
    Event:=TInputLine^.ILCommand;
    HandleCommand;
End;

Procedure HandleMsInputLineEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);



     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TInputLine:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TInputLine Then
           Begin
             NormalInputLineColor;
             CurOff;
             TInputLine^.ILMsFocus:=False;
             IF TInputLine^.ILLabel<>'' Then
             Begin
               WriteTextColor:=TInputLine^.IInputLineNormLabelColor;
               WriteTextBackGround:=Win^.WTextBackGround;
               IF ( (InterMX+1 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)])
                 or (InterMX+2 in [Win^.X1+TInputLine^.ILLabX1..Win^.X1+TInputLine^.ILLabX1+Length(TInputLine^.ILLabel)]) ) AND
                 ( (InterMY+1 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) or
                 (InterMY+2 in [Win^.Y1+TInputLine^.ILLabY1..Win^.Y1+TInputLine^.ILLabY1]) ) Then
               Begin
                 HiddenMouseCursor;
                 HiddenMouse:=True;
               End;

               WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);

               IF HiddenMouse Then
               Begin
                 ShowMouseCursor;
                 HiddenMouse:=False;
               End;
             End;
             Event:=TInputLine^.ILCommand;
             HandleCommand;

             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End

End;

Begin
     Case Event OF
        0:HandleKBInputLineEvent;
        1:HandleMsInputLineEvent;
     End;
End;

{***************************************************************************}
{Procedure InputLine.SetInputLinePalette;                                   }
{***************************************************************************}
Procedure InputLine.SetInputLinePalette;
Begin
    InputLineNormTxtColor    :=TxtColor;
    InputLineNormBckColor    :=BckColor;
    InputLineRevTxtColor     :=CurTxtColor;
    InputLineRevBckColor     :=CurBckColor;
    InputLineSelectedText    :=SelectTextColor;
    InputLineNormLabelColor  :=NormLabelColor;
    InputLineRevLabelColor   :=RevLabelColor;
End;

{---------------------------------------------------------------------------}
{-----------------------------CHECK BOXES-----------------------------------}
{---------------------------------------------------------------------------}


{***************************************************************************}
{Procedure CheckBox.WinHandleEvent;                                         }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure CheckBox.WinHandleEvent;
Begin

End;

{***************************************************************************}
{Procedure CheckBox.HandleCommand;                                          }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure CheckBox.HandleCommand;
Begin

End;

{***************************************************************************}
{Procedure CheckBox.InitCheckBox;                                           }
{***************************************************************************}
Procedure CheckBox.InitCheckBox;
Var
     CheckShape :Byte;
Begin
    IF HeapErrorCode=1 Then
    Begin
       TCheckBox:=Nil;
       Exit;
    End;

    New(TCheckBox);

    IF TCheckBox=Nil Then
       Exit;

    TCheckBox^.CBX1:=ObjectX1;
    TCheckBox^.CBY1:=ObjectY1;

    TCheckBox^.CBCommand:=InCommand;
    TCheckBox^.CBTitle:=InName;
    TCheckBox^.CBDefault:=InDefaultCheck;
    TCheckBox^.CBHelpCtx:=Nil;
    TCheckBox^.CBDiskHelp:=0;

    TCheckBox^.CCheckBoxNormTxtColor     :=CheckBoxNormTxtColor;
    TCheckBox^.CCheckBoxNormBckColor     :=CheckBoxNormBckColor;
    TCheckBox^.CCheckBoxRevTxtColor      :=CheckBoxRevTxtColor;
    TCheckBox^.CCheckBoxRevBckColor      :=CheckBoxRevBckColor;
    TCheckBox^.CCheckBoxSSL              :=CheckBoxSSL;
    TCheckBox^.CCheckBoxESL              :=CheckBoxESL;

   CheckShape:=3+1;        {í®ú†™ Æò®ò°´û®ú™ ö†ò ´¶ ©Æû£ò °ò† ú§ò ö†ò °ú§¶}

    NewMenusSeq(CheckBoxes,TCheckBox,BroadCastChar(InName),ObjectX1,ObjectY1,ObjectX1+Length(InName)+CheckShape-1,ObjectY1);

    IF VgaExist Then
       Case TCheckBox^.CBDefault Of
         BfNormal  :TCheckBox^.CBTitle:=Chr(WCCheckBoxLB)+Chr(WCEmptyCheckBox)+Chr(WCCheckBoxRB)+' '+InName;
         BfDefault :TCheckBox^.CBTitle:=Chr(WCCheckBoxLB)+Chr(WCMarkCheckBox)+Chr(WCCheckBoxRB)+' '+InName;
       End
    Else
       Case TCheckBox^.CBDefault Of
         BfNormal  :TCheckBox^.CBTitle:=Chr(SCCheckBoxLB)+Chr(SCEmptyCheckBox)+Chr(SCCheckBoxRB)+' '+InName;
         BfDefault :TCheckBox^.CBTitle:=Chr(SCCheckBoxLB)+Chr(SCMarkCheckBox)+Chr(SCCheckBoxRB)+' '+InName;
       End;

    IF CheckBoxNormBckColor=255 Then
       TCheckBox^.CCheckBoxNormBckColor:=Win^.WTextBackGround;

    IF CheckBoxRevBckColor=255 Then
       TCheckBox^.CCheckBoxRevBckColor:=Win^.WTextBackGround;

    WriteTextColor:=TCheckBox^.CCheckBoxNormTxtColor;
    WriteTextBackGround:=TCheckBox^.CCheckBoxNormBckColor;
    IF ( (InterMX+1 in [Win^.X1+ObjectX1..Win^.X1+ObjectX1+Length(TCheckBox^.CBTitle)]) or
          (InterMX+2 in [Win^.X1+ObjectX1..Win^.X1+ObjectX1+Length(TCheckBox^.CBTitle)]) )AND
       ( (InterMY+1 in [Win^.Y1+ObjectY1..Win^.Y1+ObjectY1]) or (InterMY+2 in [Win^.Y1+ObjectY1..Win^.Y1+ObjectY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteStrAndMark(Win^.X1+ObjectX1,Win^.Y1+ObjectY1,TCheckBox^.CBTitle);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

    CheckBoxActive:=InDefaultCheck; {user read only variable}
End;

{***************************************************************************}
{Procedure CheckBox.CheckBoxHelp;                                           }
{***************************************************************************}
Procedure CheckBox.CheckBoxHelp;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TCheckBox^.CBHelpCtx:=Nil
    Else
    Begin
        New(TCheckBox^.CBHelpCtx);
        IF TCheckBox^.CBHelpCtx=Nil Then
           Exit;
        TCheckBox^.CBHelpCtx^:=InHelpCtx;
    End;

    TCheckBox^.CBDiskHelp:=InDiskHelp;
End;

{***************************************************************************}
{Procedure CheckBox.DefaultCheckBoxColor;                                   }
{***************************************************************************}
Procedure CheckBox.DefaultCheckBoxColor;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    WriteTextColor:=TCheckBox^.CCheckBoxRevTxtColor;
    WriteTextBackGround:=TCheckBox^.CCheckBoxRevBckColor;
    IF ( (InterMX+1 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) or
        (InterMX+2 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) )AND
       ( (InterMY+1 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) or
           (InterMY+2 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;

    WriteStrAndMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

{***************************************************************************}
{Procedure CheckBox.NormalCheckBoxColor;                                    }
{***************************************************************************}
Procedure CheckBox.NormalCheckBoxColor;
Begin

    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    WriteTextColor:=TCheckBox^.CCheckBoxNormTxtColor;
    WriteTextBackGround:=TCheckBox^.CCheckBoxNormBckColor;
    IF ( (InterMX+1 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) or
        (InterMX+2 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) )AND
       ( (InterMY+1 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) or
           (InterMY+2 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    WriteStrAndMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;
End;

{***************************************************************************}
{Procedure CheckBox.DisableCheckBox;                                        }
{***************************************************************************}
Procedure CheckBox.DisableCheckBox;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    WriteTextColor:=DisableWinColor;
    WriteTextBackGround:=TCheckBox^.CCheckBoxNormBckColor;
    IF ( (InterMX+1 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) or
        (InterMX+2 in [Win^.X1+TCheckBox^.CBX1..Win^.X1+TCheckBox^.CBX1+Length(TCheckBox^.CBTitle)]) )AND
       ( (InterMY+1 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) or
           (InterMY+2 in [Win^.Y1+TCheckBox^.CBY1..Win^.Y1+TCheckBox^.CBY1]) ) Then
    Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
    End;


    WriteWithOutMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);

    IF HiddenMouse Then
    Begin
      ShowMouseCursor;
      HiddenMouse:=False;
    End;

End;

{***************************************************************************}
{Procedure CheckBox.EnableCheckBox;                                         }
{***************************************************************************}
Procedure CheckBox.EnableCheckBox;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    NormalCheckBoxColor;
End;

{***************************************************************************}
{Procedure CheckBox.HandleCheckBoxEvent;                                    }
{***************************************************************************}
Procedure CheckBox.HandleCheckBoxEvent;
Var
   Answer       :Boolean;

Procedure HandleKBCheckBoxEvent;
Begin

    TCheckBox:=Win^.CurMenusSeq^.NodePtr;
    CurrentHelpPtr:=TCheckBox^.CBDiskHelp;

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        DefaultCheckBoxColor;
        IF TCheckBox^.CBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TCheckBox^.CBHelpCtx^;
           ShowHelpCtx(TCheckBox^.CBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;
        SetVirtCursorPositHeight(TCheckBox^.CBX1+Win^.X1+1,TCheckBox^.CBY1+Win^.Y1,CheckBoxSSL,CheckBoxESL);

    End
    Else


    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
         IF ( (InterMX+1 in [TCheckBox^.CBX1+Win^.X1..TCheckBox^.CBX1+Win^.X1+Length(TCheckBox^.CBTitle)]) or
             (InterMX+2 in [TCheckBox^.CBX1+Win^.X1..TCheckBox^.CBX1+Win^.X1+Length(TCheckBox^.CBTitle)])) and
             ( (InterMY+1 = TCheckBox^.CBY1+Win^.Y1) or (InterMY+2 = TCheckBox^.CBY1+Win^.Y1) ) Then
         Begin

             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBCheckBoxEvent;

             Ctrl:=#32;
             Ascii:=#0;
             HandleKBCheckBoxEvent;

             Repeat
             Until MouseButton=MsIdle;

         End;
    End
    Else

    IF (CtrlPressed.Address <> Nil) Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TCheckBox:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TCheckBox Then
           Begin
             NormalCheckBoxColor;
             CurOff;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and ( (Ascii=#77) or (Ascii=#80) ) )Then
    Begin
         CurOff;
         NormalCheckBoxColor;
         CheckBoxActive:=TCheckBox^.CBDefault;
         Event:=TCheckBox^.CBCommand;
         HandleCommand;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and ( (Ascii=#75) or (Ascii=#72) ) )Then
    Begin
         CurOff;
         NormalCheckBoxColor;
         CheckBoxActive:=TCheckBox^.CBDefault;
         Event:=TCheckBox^.CBCommand;
         HandleCommand;

         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    IF (Ctrl=#32) or ((Ctrl=#0) and (Ascii=#82)) Then
    Begin
        IF TCheckBox^.CBDefault = BfDefault Then
        Begin
            Delete(TCheckBox^.CBTitle,2,1);

            IF VgaExist Then
                Insert(Chr(WCEmptyCheckBox),TCheckBox^.CBTitle,2)
            Else
                Insert(Chr(SCEmptyCheckBox),TCheckBox^.CBTitle,2);

            TCheckBox^.CBDefault:=BfNormal;
            MenusCheckerOnOff:=False;
            DefaultCheckBoxColor;
        End
        Else
        Begin
            Delete(TCheckBox^.CBTitle,2,1);

            IF VgaExist Then
                Insert(Chr(WCMarkCheckBox),TCheckBox^.CBTitle,2)
            Else
                Insert(Chr(SCMarkCheckBox),TCheckBox^.CBTitle,2);

            TCheckBox^.CBDefault:=BfDefault;
            MenusCheckerOnOFF:=True;
            DefaultCheckBoxColor;
        End;
       CheckBoxActive:=TCheckBox^.CBDefault;
       Event:=TCheckBox^.CBCommand;
       HandleCommand;
    End;

   MsLeftDoubleClick:=False;
End;

Procedure HandleMsCheckBoxEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;


     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TCheckBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TCheckBox Then
           Begin
             NormalCheckBoxColor;
             CurOff;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End


End;

Begin
    Case Event Of
       0:HandleKBCheckBoxEvent;
       1:HandleMsCheckBoxEvent;
    End;
End;

{**************************************************************************}
{Procedure CheckBox.SetCheckBoxPalette;                                    }
{**************************************************************************}
Procedure CheckBox.SetCheckBoxPalette;
Begin
    TCheckBox^.CCheckBoxNormTxtColor     :=TxtColor;
    TCheckBox^.CCheckBoxNormBckColor     :=BckColor;
    TCheckBox^.CCheckBoxRevTxtColor      :=CurTxtColor;
    TCheckBox^.CCheckBoxRevBckColor      :=CurBckColor;
End;

{---------------------------------------------------------------------------}
{-------------------------RADIO BUTTONS-------------------------------------}
{---------------------------------------------------------------------------}


{***************************************************************************}
{Procedure RadioButton.WinHandleEvent;                                      }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure RadioButton.WinHandleEvent;
Begin

End;

{***************************************************************************}
{Procedure RadioButton.HandleCommand;                                       }
{Virtual Method.                                                            }
{***************************************************************************}
Procedure RadioButton.HandleCommand;
Begin

End;

{***************************************************************************}
{Function RadioButton.NewRItem;                                             }
{***************************************************************************}
Function RadioButton.NewRItem;
Begin
    IF HeapErrorCode=1 Then
    Begin
       TRadioButton:=Nil;
       Exit;
    End;

    New(TRadioButton);

    IF TRadioButton=Nil Then
       Exit;

    TRadioButton^.RBTitle:=InTitle;
    TRadioButton^.RBCommand:=InCommand;
    TRadioButton^.RBDiskHelp:=InDiskHelp;
    TRadioButton^.RBHeadRadioButton:=Nil;

    TRadioButton^.RRadioButtonNormTxtColor  :=RadioButtonNormTxtColor;
    TRadioButton^.RRadioButtonNormBckColor  :=RadioButtonNormBckColor;
    TRadioButton^.RRadioButtonRevTxtColor   :=RadioButtonRevTxtColor;
    TRadioButton^.RRadioButtonRevBckColor   :=RadioButtonRevBckColor;
    TRadioButton^.RRadioButtonSSL           :=RadioButtonSSL;
    TRadioButton^.RRadioButtonESL           :=RadioButtonESL;

    IF InHelpCtx<>'' Then
    Begin
      New(TRadioButton^.RBHelpCtx);
      IF TRadioButton^.RBHelpCtx=Nil Then
         Exit;
      TRadioButton^.RBHelpCtx^:=InHelpCtx;
    End
    Else
      TRadioButton^.RBHelpCtx:=Nil;
    TRadioButton^.RBDefault:=InDefault;

    New(TraceMenuNode);
    IF TraceMenuNode=Nil Then
       Exit;
    TraceMenuNode^.NodePtr:=TRadioButton;
    TraceMenuNode^.Next:=TraceHeadMenuSeq;
    TraceHeadMenuSeq:=TraceMenuNode;
End;

{***************************************************************************}
{Procedure RadioButton.InitRadioButton;                                     }
{***************************************************************************}
Procedure RadioButton.InitRadioButton;
Var
    MaxChoise         :Byte;
    Temp,TraceNode    :PMenuNode;
    I                 :Byte;

Procedure DrawRadioButton;
Begin
     IF VgaExist Then
       Case TRadioButton^.RBDefault Of
         BfNormal  :TRadioButton^.RBTitle:=Chr(WCRadioButLB)+Chr(WCEmptyRadioBut)+Chr(WCRadioButRB)+' '+TRadioButton^.RBTitle;
         BfDefault :TRadioButton^.RBTitle:=Chr(WCRadioButLB)+Chr(WCMarkRadioBut)+Chr(WCRadioButRB)+' '+TRadioButton^.RBTitle;
       End
     Else
       Case TRadioButton^.RBDefault Of
         BfNormal  :TRadioButton^.RBTitle:=Chr(SCRadioButLB)+Chr(SCEmptyRadioBut)+Chr(SCRadioButRB)+' '+TRadioButton^.RBTitle;
         BfDefault :TRadioButton^.RBTitle:=Chr(SCRadioButLB)+Chr(SCMarkRadioBut)+Chr(SCRadioButRB)+' '+TRadioButton^.RBTitle;
       End;

     IF RadioButtonNormBckColor=255 Then
        TRadioButton^.RRadioButtonNormBckColor:=Win^.WTextBackGround;

     IF RadioButtonRevBckColor=255 Then
        TRadioButton^.RRadioButtonRevBckColor:=Win^.WTextBackGround;

     WriteTextColor:=TRadioButton^.RRadioButtonNormTxtColor;
     WriteTextBackGround:=TRadioButton^.RRadioButtonNormBckColor;
     IF ( (InterMX+1 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) or
         (InterMX+2 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) )AND
        ( (InterMY+1 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) or
            (InterMY+2 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;
End;

Begin

    IF (HeapErrorCode=1) or (TRadioButton=Nil) Then
         Exit;

    TraceMenuNode:=TraceHeadMenuSeq;
    MaxChoise:=0;
    Repeat
       IF TraceMenuNode<>Nil Then
       Begin
          Inc(MaxChoise);
          TraceMenuNode:=TraceMenuNode^.Next;
       End;
    Until TraceMenuNode=Nil;

    IF MaxChoise > 0 Then
    Begin
        TraceMenuNode:=TraceHeadMenuSeq;
        For I:=1 to MaxChoise do
        Begin
          TRadioButton:=TraceMenuNode^.NodePtr;

          TRadioButton^.RBRadioNum:=I;
          TRadioButton^.RBMaxChoise:=MaxChoise;
          TRadioButton^.RBX1:=ObjectX1;
          TRadioButton^.RBY1:=ObjectY1+(I-1);

          NewMenusSeq(RadioButtons,TRadioButton,BroadCastChar(TRadioButton^.RBTitle),ObjectX1,
                       ObjectY1+(I-1),ObjectX1+Length(TRadioButton^.RBTitle)+2,ObjectY1+(I-1));

          IF I=1 Then
          Begin
              TRadioButton^.RBHeadRadioButton:=Win^.TailMenusSeq;
              TraceNode:=Win^.TailMenusSeq;
          End
          Else
              TRadioButton^.RBHeadRadioButton:=TraceNode;

          DrawRadioButton;

          {Process for the users read only variables}
          IF TRadioButton^.RBDefault = BfDefault Then
          Begin
              RadioButtonCurrentNum:=I;
              RadioButtonCurrentStr:=TRadioButton^.RBTitle;
          End;

          TraceMenuNode:=TraceMenuNode^.Next;
        End;

        TraceMenuNode:=TraceHeadMenuSeq;
        For I:=1 to MaxChoise do
        Begin
            Temp:=TraceMenuNode^.Next;
            Dispose(TraceMenuNode);
            TraceMenuNode:=Temp;
        End;

    End;

    TraceHeadMenuSeq  := Nil;
    TraceMenuNode     := Nil;
End;

{***************************************************************************}
{Procedure RadioButton.NormalRadioButtonColor;                              }
{***************************************************************************}
Procedure RadioButton.NormalRadioButtonColor;
Begin
     WriteTextColor:=TRadioButton^.RRadioButtonNormTxtColor;
     WriteTextBackGround:=TRadioButton^.RRadioButtonNormBckColor;
     IF ( (InterMX+1 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) or
         (InterMX+2 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) )AND
        ( (InterMY+1 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) or
            (InterMY+2 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;

     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;
End;

{***************************************************************************}
{Procedure RadioButton.DefaultRadioButtonColor;                             }
{***************************************************************************}
Procedure RadioButton.DefaultRadioButtonColor;
Begin
     WriteTextColor:=TRadioButton^.RRadioButtonRevTxtColor;
     WriteTextBackGround:=TRadioButton^.RRadioButtonRevBckColor;
     IF ( (InterMX+1 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) or
         (InterMX+2 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) )AND
        ( (InterMY+1 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) or
            (InterMY+2 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;


     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;
End;

{***************************************************************************}
{Procedure RadioButton.DisableRadioButton;                                  }
{***************************************************************************}
Procedure RadioButton.DisableRadioButton;
Begin
     IF (TRadioButton=Nil) or (HeapErrorCode=1) Then
        Exit;

     WriteTextColor:=DisableWinColor;
     WriteTextBackGround:=TRadioButton^.RRadioButtonNormBckColor;
     IF ( (InterMX+1 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) or
         (InterMX+2 in [Win^.X1+TRadioButton^.RBX1..Win^.X1+TRadioButton^.RBX1+Length(TRadioButton^.RBTitle)]) )AND
        ( (InterMY+1 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) or
            (InterMY+2 in [Win^.Y1+TRadioButton^.RBY1..Win^.Y1+TRadioButton^.RBY1]) ) Then
     Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
     End;


     WriteWithOutMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);

     IF HiddenMouse Then
     Begin
       ShowMouseCursor;
       HiddenMouse:=False;
     End;

End;

{***************************************************************************}
{Procedure RadioButton.EnableRadioButton;                                   }
{***************************************************************************}
Procedure RadioButton.EnableRadioButton;
Begin
     IF (TRadioButton=Nil) or (HeapErrorCode=1) Then
        Exit;

    NormalRadioButtonColor;
End;

Procedure RadioButton.RadioButtonHandleCommand;
Var
    TraceMenu            :PMenuNode;
    StartNode,MaxNodes   :Byte;
    TraceRadio           :PRadioButton;
Begin
       TraceRadio:=TRadioButton;
       TraceMenu:=TRadioButton^.RBHeadRadioButton;
       MaxNodes:=TRadioButton^.RBMaxChoise;
       For StartNode:=1 To MaxNodes do
       Begin
           TRadioButton:=TraceMenu^.NodePtr;

           IF TRadioButton^.RBDefault = BfDefault Then
           Begin
              RadioButtonCurrentNum:=TRadioButton^.RBRadioNum;
              RadioButtonCurrentStr:=Copy(TRadioButton^.RBTitle,5,Length(TRadioButton^.RBTitle));
              Event:=TRadioButton^.RBCommand;
              HandleCommand;
           End;

           TraceMenu:=TraceMenu^.Next;
       End;
       TRadioButton:=TraceRadio;
End;


{***************************************************************************}
{Procedure RadioButton.HandleRadioButtonEvent;                              }
{***************************************************************************}
Procedure RadioButton.HandleRadioButtonEvent;
Var
    TraceMenu            :PMenuNode;
    Answer               :Boolean;

Procedure HandleKbRadioButtonEvent;
Var
    StartNode,MaxNodes   :Byte;
Begin
    TRadioButton:=Win^.CurMenusSeq^.NodePtr;
    CurrentHelpPtr:=TRadioButton^.RBDiskHelp;

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        DefaultRadioButtonColor;
        IF TRadioButton^.RBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TRadioButton^.RBHelpCtx^;
           ShowHelpCtx(TRadioButton^.RBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;
        SetVirtCursorPositHeight(TRadioButton^.RBX1+Win^.X1+1,TRadioButton^.RBY1+Win^.Y1,RadioButtonSSL,RadioButtonESL);

    End
    Else


    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
         IF ( (InterMX+1 in [TRadioButton^.RBX1+Win^.X1..TRadioButton^.RBX1+Win^.X1+Length(TRadioButton^.RBTitle)]) or
              (InterMX+2 in [TRadioButton^.RBX1+Win^.X1..TRadioButton^.RBX1+Win^.X1+Length(TRadioButton^.RBTitle)]) ) and
            ( (InterMY+1 = TRadioButton^.RBY1+Win^.Y1) or (InterMY+2 = TRadioButton^.RBY1+Win^.Y1) )Then
         Begin

             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBRadioButtonEvent;

             Ctrl:=#32;
             Ascii:=#0;
             HandleKBRadioButtonEvent;

             Repeat
             Until MouseButton=MsIdle;
         End;
    End
    Else

    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TRadioButton:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TRadioButton Then
           Begin
             NormalRadioButtonColor;
             CurOff;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;
    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and ( (Ascii=#77) or (Ascii=#80) ) )Then
    Begin
         CurOff;
         NormalRadioButtonColor;
         RadioButtonHandleCommand;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and ( (Ascii=#75) or (Ascii=#72) ) )Then
    Begin
         CurOff;
         NormalRadioButtonColor;
         RadioButtonHandleCommand;

         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    IF (Ctrl=#32) OR ( (Ctrl=#0) and (Ascii=#82) ) Then
    Begin

       TraceMenu:=TRadioButton^.RBHeadRadioButton;
       MaxNodes:=TRadioButton^.RBMaxChoise;
       For StartNode:=1 To MaxNodes do
       Begin
           TRadioButton:=TraceMenu^.NodePtr;

           IF TRadioButton^.RBDefault=BfDefault Then
           Begin
              Delete(TRadioButton^.RBTitle,2,1);
              TRadioButton^.RBDefault:=BfNormal;

              IF VgaExist Then
                    Insert(Chr(WCEmptyRadioBut),TRadioButton^.RBTitle,2)
              Else
                    Insert(Chr(SCEmptyRadioBut),TRadioButton^.RBTitle,2);

              NormalRadioButtonColor;
           End;{IF Default}

           TraceMenu:=TraceMenu^.Next;
       End;{For}

       TRadioButton:=Win^.CurMenusSeq^.NodePtr;
       Delete(TRadioButton^.RBTitle,2,1);
       IF VgaExist Then
          Insert(Chr(WCMarkRadioBut),TRadioButton^.RBTitle,2)
       Else
          Insert(Chr(SCMarkRadioBut),TRadioButton^.RBTitle,2);

       TRadioButton^.RBDefault:=BfDefault;
       DefaultRadioButtonColor;

       RadioButtonHandleCommand;

    End;

    MsLeftDoubleClick:=False;
    Event:=TRadioButton^.RBCommand;
    HandleCommand;

End;

Procedure HandleMsRadioButtonEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin
     IF (MouseButton and msRight) = msRight Then
        Exit;


     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TRadioButton:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TRadioButton Then
           Begin
             NormalRadioButtonColor;
             CurOff;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End


End;
Begin
   Case Event Of
       0:HandleKBRadioButtonEvent;
       1:HandleMsRadioButtonEvent;
   End;

End;

{***************************************************************************}
{Procedure RadioButton.SetRadioButtonPalette;                               }
{***************************************************************************}
Procedure RadioButton.SetRadioButtonPalette;
Begin
    RadioButtonNormTxtColor  :=TxtColor;
    RadioButtonNormBckColor  :=BckColor;
    RadioButtonRevTxtColor   :=CurTxtColor;
    RadioButtonRevBckColor   :=CurBckColor;

End;


{---------------------------------------------------------------------------}
{----------------------------VERTICAL SCROLL BAR----------------------------}
{---------------------------------------------------------------------------}

Procedure VerScrollBar.HandleCommand;
Begin

End;

Procedure VerScrollBar.WinHandleEvent;
Begin

End;

Function VerScrollBar.InitVerScrollBar;

Procedure DrawBar;
Var
    WX1,WX2,WY1,WY2     :Byte;
    I                   :Byte;
Begin

   WX1:=Win^.X1+TVerScrollBar^.VSBX1;
   WY1:=Win^.Y1+TVerScrollBar^.VSBY1;
   WX2:=Win^.X1+TVerScrollBar^.VSBX2;
   WY2:=Win^.Y1+TVerScrollBar^.VSBY2;

   IF ScrollBarNormBckColor=255 Then
      TVerScrollBar^.SScrollBarNormBckColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.SScrollBarNormBckColor:=ScrollBarNormBckColor;

   IF ScrollBarRevBckColor=255 Then
      TVerScrollBar^.SScrollBarRevBckColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.SScrollBarRevBckColor:=ScrollBarRevBckColor;

   IF ScrollBarNormTxtColor=255 Then
      TVerScrollBar^.SScrollBarNormTxtColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.SScrollBarNormTxtColor:=ScrollBarNormTxtColor;

   TVerScrollBar^.SScrollBarRevTxtColor:=ScrollBarRevTxtColor;

   IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+2 in [WX1..WX2]) )AND
      ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCDownArrow2);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
        Begin
          WriteVirtWinChar(
              WX1,WY1+1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
              WX2,WY1+1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLinePointer2);
        End;

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
              WX2,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLineFillChar2);
        End;


   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCDownArrow);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
          WriteVirtWinChar(
              WX1,WY1+1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLinePointer);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLineFillChar);

   End;

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;
End;

Begin
    IF HeapErrorCode=1 Then
    Begin
        TVerScrollBar:=Nil;
        Exit;
    End;

    New(TVerScrollBar);

    IF TVerScrollBar=Nil Then
       Exit;

    IF VgaExist Then
       ObjectX2:=ObjectX1+1
    Else
       ObjectX2:=ObjectX1;

    TVerScrollBar^.VSBX1:=ObjectX1;
    TVerScrollBar^.VSBY1:=ObjectY1;
    TVerScrollBar^.VSBX2:=ObjectX2;
    TVerScrollBar^.VSBY2:=ObjectY2;
    TVerScrollBar^.VSBCommand:=InCommand;
    TVerScrollBar^.VSBHelpCtx:=Nil;
    TVerScrollBar^.VSBDiskHelp:=0;
    TVerScrollBar^.VSBPointer:=1;
    TVerScrollBar^.VSBMaxChoises:=0;
    TVerScrollBar^.VSBPointerStep:=1;
    TVerScrollBar^.VSBVirtualYPosit:=1;


    NewMenusSeq(VerScrollBars,TVerScrollBar,255,ObjectX1,ObjectY1,ObjectX2,ObjectY2);
    DrawBar;

    InitVerScrollBar:=TVerScrollBar;

    {user read only variable}
    VerScrollBarCurrentNum:=1;
End;


{*************************************************************************}
{Procedure SetVerScrBarMaximumChoises                                              }
{Éû¢‡§ú† ©´û§ ®¶¨´†§ò ß¶©ú™ ú†§ò† ¶† úß†¢¶öú™ ö†ò §ò ®¨ü£†©´ú† ò§ò¢¶öò    }
{°ò† ´¶ ôû£ò ß¶¨ üò °ò§ú† ¶ pointer.                                      }
{*************************************************************************}
Procedure VerScrollBar.SetVerScrBarMaximumChoises(MaxChoises :Word);
Begin
    IF TVerScrollBar = Nil Then
       Exit;

    TVerScrollBar^.VSBMaxChoises:=MaxChoises;
    TVerScrollBar^.VSBPointerStep:=Trunc(MaxChoises / ( (TVerScrollBar^.VSBY2-1) -
                                                    (TVerScrollBar^.VSBY1)) );
End;

Procedure VerScrollBar.SetVerScrBarDefaultChoise(StartPoint :Word);
Begin
    IF TVerScrollBar = Nil Then
       Exit;


    TVerScrollBar^.VSBVirtualYPosit:=StartPoint;
    AdjustVerScrollPointer;

    NormalVerScrollBarColor;
    VerScrollBarCurrentNum:=StartPoint;
End;

Procedure VerScrollBar.VerScrollBarHelp;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TVerScrollBar^.VSBHelpCtx:=Nil
    Else
    Begin
        New(TVerScrollBar^.VSBHelpCtx);
        IF TVerScrollBar^.VSBHelpCtx=Nil Then
           Exit;
        TVerScrollBar^.VSBHelpCtx^:=InHelpCtx;
    End;

    TVerScrollBar^.VSBDiskHelp:=InDiskHelp;
End;

Procedure VerScrollBar.NormalVerScrollBarColor;
Var
    WX1,WX2,WY1,WY2     :Byte;
    I                   :Byte;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;

   WX1:=Win^.X1+TVerScrollBar^.VSBX1;
   WY1:=Win^.Y1+TVerScrollBar^.VSBY1;
   WX2:=Win^.X1+TVerScrollBar^.VSBX2;
   WY2:=Win^.Y1+TVerScrollBar^.VSBY2;

   IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+2 in [WX1..WX2]) )AND
      ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;


   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
                WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
                WX2,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
        Begin
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
               WX2,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,WCScrLinePointer2);
        End;

   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLinePointer);

   End;

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;
End;

Procedure VerScrollBar.ClearVerScrollBarPointer;
Var
    WX1,WX2,WY1,WY2     :Byte;
    I                   :Byte;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;


   WX1:=Win^.X1+TVerScrollBar^.VSBX1;
   WY1:=Win^.Y1+TVerScrollBar^.VSBY1;
   WX2:=Win^.X1+TVerScrollBar^.VSBX2;
   WY2:=Win^.Y1+TVerScrollBar^.VSBY2;

   IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+2 in [WX1..WX2]) )AND
      ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
              WX2,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLineFillChar2);
        End;
   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCScrLineFillChar);

   End;

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;

End;



Procedure VerScrollBar.DefaultVerScrollBarColor;
Var
    WX1,WX2,WY1,WY2     :Byte;
    I                   :Byte;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;


   WX1:=Win^.X1+TVerScrollBar^.VSBX1;
   WY1:=Win^.Y1+TVerScrollBar^.VSBY1;
   WX2:=Win^.X1+TVerScrollBar^.VSBX2;
   WY2:=Win^.Y1+TVerScrollBar^.VSBY2;

   IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+2 in [WX1..WX2]) )AND
      ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
             WX2,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
        Begin
          WriteVirtWinChar(
             WX1,WY1+TVerScrollBar^.VSBPointer,
                 TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
             WX2,WY1+TVerScrollBar^.VSBPointer,
                 TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,WCScrLinePointer2);
        End;
   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.SScrollBarRevTxtColor,TVerScrollBar^.SScrollBarRevBckColor,SCScrLinePointer);
   End;

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;
End;

Procedure VerScrollBar.DisableVerScrollBar;
Var
    WX1,WX2,WY1,WY2     :Byte;
    I                   :Byte;
Begin

    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;

   WX1:=Win^.X1+TVerScrollBar^.VSBX1;
   WY1:=Win^.Y1+TVerScrollBar^.VSBY1;
   WX2:=Win^.X1+TVerScrollBar^.VSBX2;
   WY2:=Win^.Y1+TVerScrollBar^.VSBY2;

   IF ( (InterMX+1 in [WX1..WX2]) or (InterMX+2 in [WX1..WX2]) )AND
      ( (InterMY+1 in [WY1..WY2]) or (InterMY+2 in [WY1..WY2]) ) Then
   Begin
     HiddenMouseCursor;
     HiddenMouse:=True;
   End;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCScrLineFillChar1);
          WriteVirtWinChar(WX2,I,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
        Begin
          WriteVirtWinChar(
              WX1,WY1+TVerScrollBar^.VSBPointer,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCScrLinePointer1);
          WriteVirtWinChar(
              WX2,WY1+TVerScrollBar^.VSBPointer,TVerScrollBar^.SScrollBarNormTxtColor,DisableColor,WCScrLinePointer2);
        End;

   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
           WriteVirtWinChar(
              WX1,WY1+TVerScrollBar^.VSBPointer,
                  TVerScrollBar^.SScrollBarNormTxtColor,TVerScrollBar^.SScrollBarNormBckColor,SCScrLinePointer);
   End;

   IF HiddenMouse Then
   Begin
     ShowMouseCursor;
     HiddenMouse:=False;
   End;

End;

Procedure VerScrollBar.EnableVerScrollBar;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;

   NormalVerScrollBarColor;
End;

Procedure VerScrollBar.AdjustVerScrollPointer;
Var
  Stepper,Carry :Byte;
  MaxVis        :Byte;
Begin

   IF (TVerScrollBar^.VSBMaxChoises < ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
      Exit;

   MaxVis:=(TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1);

   Stepper:=Trunc(TVerScrollBar^.VSBVirtualYPosit / TVerScrollBar^.VSBPointerStep);
   Carry:=TVerScrollBar^.VSBVirtualYPosit mod TVerScrollBar^.VSBPointerStep;

   IF (Carry<>0) and (Stepper < MaxVis) Then
   Begin
      Inc(Stepper);
      TVerScrollBar^.VSBPointer:=Stepper;
   End
   Else
   IF (Stepper=0) Then
      TVerScrollBar^.VSBPointer:=1
   Else
   IF (Stepper<>TVerScrollBar^.VSBPointer) and (Stepper<=MaxVis) Then
      TVerScrollBar^.VSBPointer:=Stepper
   Else
   IF Stepper > MaxVis Then
      TVerScrollBar^.VSBPointer:=MaxVis;
End;

Procedure VerScrollBar.HandleVerScrollBarEvent;
Var
   Answer       :Boolean;

Procedure HandleKBVerScrollBarEvent;
Var
    Delayer           :Word;
    Delayer2          :Word;
    TracePointer      :Byte;
    MyMouseX,MyMouseY :Byte;
Begin

    TVerScrollBar:=Win^.CurMenusSeq^.NodePtr;
    CurrentHelpPtr:=TVerScrollBar^.VSBDiskHelp;

    IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        DefaultVerScrollBarColor;

        IF TVerScrollBar^.VSBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TVerScrollBar^.VSBHelpCtx^;
           ShowHelpCtx(TVerScrollBar^.VSBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;
    End
    Else

    {Up Arrow}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        IF (InterMX+1 in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (InterMY+1 = Win^.Y1+TVerScrollBar^.VSBY1) Then
        Begin
           Ctrl:=#$FF;
           Ascii:=#$FF;
           HandleKBVerScrollBarEvent;
           Delayer2:=1;

           SetMouseMinMaxX(Win^.X1+TVerScrollBar^.VSBX1,Win^.X1+TVerScrollBar^.VSBX2);
           SetMouseMinMaxY(Win^.Y1+TVerScrollBar^.VSBY1,Win^.Y1+TVerScrollBar^.VSBY1);

           Repeat
             Ctrl:=#0;
             Ascii:=#72;
             HandleKBVerScrollBarEvent;
             Case Delayer2 of
               1:Delayer:=ProDelay1;
               2:Delayer:=ProDelay2;
               3:Delayer:=ProDelay3;
               4:Delayer:=ProDelay4;
               Else
                 Delayer:=ProDelay5;
             End;


             Repeat
              RetraceDelay(Delayer);
              Delayer:=0;
             Until (MouseButton=MsIdle) or (Delayer=0);

             Inc(Delayer2);
           Until (MouseButton=MsIdle);

           SetMouseMinMaxX(1,80);
           SetMouseMinMaxY(1,25);

        End
        Else
        {Down Arrow}
        IF (InterMX+1 in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (InterMY+1 = Win^.Y1+TVerScrollBar^.VSBY2) Then
        Begin
           Ctrl:=#$FF;
           Ascii:=#$FF;
           HandleKBVerScrollBarEvent;
           Delayer2:=1;

           SetMouseMinMaxX(Win^.X1+TVerScrollBar^.VSBX1,Win^.X1+TVerScrollBar^.VSBX2);
           SetMouseMinMaxY(Win^.Y1+TVerScrollBar^.VSBY2,Win^.Y1+TVerScrollBar^.VSBY2);
           Repeat
             Ctrl:=#0;
             Ascii:=#80;
             HandleKBVerScrollBarEvent;

             Case Delayer2 of
               1:Delayer:=ProDelay1;
               2:Delayer:=ProDelay2;
               3:Delayer:=ProDelay3;
               4:Delayer:=ProDelay4;
               Else
                 Delayer:=ProDelay5;
             End;

             Repeat
               RetraceDelay(Delayer);
               Delayer:=0;
             Until (MouseButton=MsIdle) or (Delayer=0);

             Inc(Delayer2);
           Until (MouseButton=MsIdle);

           SetMouseMinMaxX(1,80);
           SetMouseMinMaxY(1,25);
        End
        Else

        {Get the Scroller Pointer and move it}

        IF (InterMX+1 in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (InterMY+1 = Win^.Y1+TVerScrollBar^.VSBY1+(TVerScrollBar^.VSBPointer)) Then
        Begin
           Ctrl:=#$FF;
           Ascii:=#$FF;
           HandleKBVerScrollBarEvent;
           SetMouseMinMaxX(Win^.X1+TVerScrollBar^.VSBX1,Win^.X1+TVerScrollBar^.VSBX2);
           SetMouseMinMaxY(Win^.Y1+TVerScrollBar^.VSBY1+1,Win^.Y1+TVerScrollBar^.VSBY2-1);

           Repeat
              MYMouseX:=InterMX+1;MYMouseY:=InterMY+1;

              IF (MyMouseX in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
                   and (MyMouseY in [Win^.Y1+TVerScrollBar^.VSBY1+1..Win^.Y1+TVerScrollBar^.VSBY2-1]) Then
              Begin
                TracePointer:=(MyMouseY-(Win^.Y1+TVerScrollBar^.VSBY1+1))+1;
                IF TracePointer <> TVerScrollBar^.VSBPointer Then
                Begin
                   TVerScrollBar^.VSBPointer:=TracePointer;
                   DefaultVerScrollBarColor;
                End;
              End;
           Until (MouseButton=MsIdle);

           IF TVerScrollBar^.VSBPointer = 1 Then
              TVerScrollBar^.VSBVirtualYPosit:=1
           Else
           IF TVerScrollBar^.VSBPointer = ( (TVerScrollBar^.VSBY2 - TVerScrollBar^.VSBY1)-1) Then
              TVerScrollBar^.VSBVirtualYPosit:=(TVerScrollBar^.VSBY2 - TVerScrollBar^.VSBY1)-1
           Else
           Begin
             TVerScrollBar^.VSBVirtualYPosit:=TVerScrollBar^.VSBPointer * TVerScrollBar^.VSBPointerStep;
             IF TVerScrollBar^.VSBVirtualYPosit > ( (TVerScrollBar^.VSBY2 - TVerScrollBar^.VSBY1)-1) Then
                TVerScrollBar^.VSBVirtualYPosit:=(TVerScrollBar^.VSBY2 - TVerScrollBar^.VSBY1)-1;

           End;

           SetMouseMinMaxX(1,80);
           SetMouseMinMaxY(1,25);

        End
        Else

        {Change Page}

        Begin
           Ctrl:=#$FF;
           Ascii:=#$FF;
           HandleKBVerScrollBarEvent;
        End;

        VerScrollBarCurrentNum:=TVerScrollBar^.VSBVirtualYPosit;
        Event:=TVerScrollBar^.VSBCommand;
        IF Event <> NoCm Then
           HandleCommand;
    End
    Else

    IF CtrlPressed.Address <> Nil Then
    Begin
         CheckIFDisabled(CtrlPressed.Address,Answer);
         IF Answer=False Then
         Begin
           TVerScrollBar:=Win^.CurMenusSeq^.NodePtr;

           IF CtrlPressed.Address<>TVerScrollBar Then
           Begin
             NormalVerScrollBarColor;
             CurOff;
             Win^.CurMenusSeq:=CtrlPressed.Address;
           End;

           Ctrl:=#$FF;Ascii:=#$FF;
           ClearEvent;
           WinHandleEvent;
         End;
         CtrlPressed.Address:=Nil;

    End
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and  (Ascii=#77)  )Then
    Begin
         NormalVerScrollBarColor;
         VerScrollBarCurrentNum:=TVerScrollBar^.VSBVirtualYPosit;
         Event:=TVerScrollBar^.VSBCommand;
         IF Event <> NoCm Then
            HandleCommand;

         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF ((Ctrl=#0) and (Ascii=#15)) OR ( (Ctrl=#0) and  (Ascii=#75)  )Then
    Begin
         CurOff;
         NormalVerScrollBarColor;
         VerScrollBarCurrentNum:=TVerScrollBar^.VSBVirtualYPosit;
         Event:=TVerScrollBar^.VSBCommand;
         IF Event <> NoCm Then
            HandleCommand;

         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else
    IF (Ctrl=#0) and (Ascii=#80) and (TVerScrollBar^.VSBVirtualYPosit < TVerScrollBar^.VSBMaxChoises) Then
    Begin

         Inc(TVerScrollBar^.VSBVirtualYPosit);
         {Ñò§ úÆ¶¨£ú úß†¢¶öú™ ßú®®†©¶´ú®ú™ òß¶ ´†™ ≠ò†§¶£ú§†°ú™ ´¶´ú £ß¶®ú† §ò}
         {¢ú†´¶¨®öû©ú† ¶ pointer ©¨£≠‡§ò £ú ´¶ ôû£ò PointerStep.              }
         IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
         Begin
           AdjustVerScrollPointer;
           DefaultVerScrollBarColor;
         End;
         VerScrollBarCurrentNum:=TVerScrollBar^.VSBVirtualYPosit;
         Event:=TVerScrollBar^.VSBCommand;
         IF Event <> NoCm Then
            HandleCommand;
    End
    Else
    IF (Ctrl=#0) and (Ascii=#72) and (TVerScrollBar^.VSBVirtualYPosit > 1 ) Then
    Begin
         Dec(TVerScrollBar^.VSBVirtualYPosit);
         {Ñò§ úÆ¶¨£ú úß†¢¶öú™ ßú®®†©¶´ú®ú™ òß¶ ´†™ ≠ò†§¶£ú§†°ú™ ´¶´ú £ß¶®ú† §ò}
         {¢ú†´¶¨®öû©ú† ¶ pointer ©¨£≠‡§ò £ú ´¶ ôû£ò PointerStep.              }
         IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1+1)+1)) Then
         Begin
            AdjustVerScrollPointer;
            DefaultVerScrollBarColor;
         End;
         VerScrollBarCurrentNum:=TVerScrollBar^.VSBVirtualYPosit;
         Event:=TVerScrollBar^.VSBCommand;
         IF Event <> NoCm Then
            HandleCommand;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsVerScrollBarEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
Begin

     IF (MouseButton and msRight) = msRight Then
        Exit;

     Found:=False;
     Trace:=Win^.HeadMenusSeq;

     WX1:=Trace^.X1+Win^.X1;
     WX2:=Trace^.X2+Win^.X1;
     WY1:=Trace^.Y1+Win^.Y1;
     WY2:=Trace^.Y2+Win^.Y1;

     Repeat
          IF (MouseX in [WX1..WX2])  and (MouseX in [WY1..WY2]) Then
             Found:=True
          Else
          Begin
             Trace:=Trace^.Next;
             WX1:=Trace^.X1+Win^.X1;
             WX2:=Trace^.X2+Win^.X1;
             WY1:=Trace^.Y1+Win^.Y1;
             WY2:=Trace^.Y2+Win^.Y1;
          End;
     Until (Trace=Nil) or (Found=True);


     IF (Found=True)  Then
     Begin
         CheckIFDisabled(Trace,Answer);
         IF Answer=False Then
         Begin
           TVerScrollBar:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TVerScrollBar Then
           Begin
             NormalVerScrollBarColor;
             CurOff;
             Win^.CurMenusSeq:=Trace;
           End;

           Ctrl:=#$FE;Ascii:=#$FE;
           ClearEvent;
           WinHandleEvent;
         End;
         ClearEvent;
     End



End;

Begin
    Case Event Of
       0:HandleKBVerScrollBarEvent;
       1:HandleMsVerScrollBarEvent;
    End;
End;


Begin

End.