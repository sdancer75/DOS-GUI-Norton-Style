UNIT WinObjects;


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

    ReservedCmStart          = 65527;
    ReservedCmEnd            = 65534;
    ReservedCmHelpStart      = 65527;
    ReservedCmHelpEnd        = 65529;

    ReservedCmHelpPrev       = 65527;
    ReservedCmHelpIndex      = 65528;
    ReservedCmHelpCancel     = 65529;
    ReservedCmOk             = 65530;
    ReservedCmCancel         = 65531;
    ReservedCmIgnore         = 65532;
    ReservedCmRetry          = 65533;
    ReservedCmFail           = 65534;
    NoCm                     = 65535;
    {********************************************}

    VerRightDrawing           = 1;
    HorDownDrawing            = 2;
    WholeMenuBox              = 3;  {Is equal with VerRightDrawing+HorDownDrawing}


    TraceHeadMenuSeq  :PMenuNode   = Nil;  {é† £ú´òô¢û´ú™ ò¨´ú™ Æ®ú†òù¶§´ò† òß¶ ´ò}
    TraceMenuNode     :PMenuNode   = Nil;  {radio Buttons ö†ò ©‡©´û ´ò•†§¶£û©û    }
    ErrorWin          :PWinFunc    = Nil;
    ErrorSnapShot     :PScreenImage= Nil;
    TempWin           :PWinFunc    = Nil;
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
      BDisabled    :Boolean;  {Ä§ ú†§ò† ©ô¨©´¶                          }
      BHelpCtx     :^Str80;   {Status Line Help                         }
      BDiskHelp    :Word;     {On Line Help number                      }

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
       ILData                 :Str80;   {íò õúõ¶£ú§ò ß¶¨ ö®ò≠¶¨£ú          }
       ILOnlyNumbers          :Boolean; {èò†®§ú† True ò§ üú¢¶¨£ú £¶§¶ ò®†ü.}
       InputLineSelectTxt     :Boolean; {Ä§ ú†§ò† True £ß¶®¶¨£ú §ò ´¶ ©ô¨©¶¨£ú}
       ILGrowChars            :Byte;    {ëú ß¶†ò üú©û ô®†©°ú´ò† £ú©ò ©´¶ Data}
       ILStrStartPosit        :Byte;    {è¶©ú™ üú©ú†™ úÆ¶¨£ú °ò§ú† ò®†©´ú®¶ scroll}
       ILCurX                 :Byte;    {è¶¨ ô®†©°ú´ò† ¶ cursor ßò§‡ ©´û§ £ßò®ò}
       ILDisabled             :Boolean; {Ä§ ú†§ò† ©ô¨©£ú§¶                 }
       ILMsFocus              :Boolean; {Ñ§ò Flag ö†ò ´¶ ß¶§´†°†           }
       ILLabel                :Str40;
       ILLabX1,ILLabY1        :Byte;


       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitInputLine(InCommand :Word;InMaxChars :Byte;InData :Str80);
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
       CBDisabled     :Boolean;  {Ä§ ú†§ò† ©ô¨©´¶                         }
       CBHelpCtx      :^Str80;   {Input line help                         }
       CBDiskHelp     :Word;     {On Line Help number                     }


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
       RBDisabled       :Boolean;  {Ä§ ú†§ò† ©ô¨©´¶                        }
       RBHelpCtx        :^Str80;   {Status Line Help                       }
       RBDiskHelp       :Word;     {On Line Help                           }
       RBCommand        :Word;     {É†ò´òöû                                }
       RBTitle          :Str40;    {í†´¢¶™                                 }
       RBDefault        :Byte;     {Ä§ ú†§ò† Check û ¶Æ†                   }
       RBHeadRadioButton:PMenuNode;{Ä®Æû ´¶¨ ß®‡´¶¨ Radio òß¶ ´û§ ´®úÆ¶§ ¶£òõò}


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
       VSBDisabled      :Boolean;
       VSBPointer       :Byte;
       VSBMaxChoises    :Word;     {ãúö†©´¶ ß¢ûü¶™ úß†¢¶ö‡§.}
       VSBPointerStep   :Byte;     {í¶ ôû£ò £ú ´¶ ¶ß¶†¶ üò ò¢¢òùú† ¶ Pointer}
       VSBVirtualYPosit :Word;

       {Palette adjustments}

       VSBScrollBarNormTxtColor    :Byte;
       VSBScrollBarNormBckColor    :Byte;
       VSBScrollBarRevTxtColor     :Byte;
       VSBScrollBarRevBckColor     :Byte;



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

   PMenuBox     = ^MenuBox;
   MenuBox      = Object (VerScrollBar)

       MBX1,MBX2,
       MBY1,MBY2     :Byte;
       MBHelpCtx     :^Str80;
       MBDiskHelp    :Word;
       MBDisabled    :Boolean;
       MBText        :PDynText;
       MBTitle       :Str40;
       MBCommand     :Word;
       MBVerScrBar   :PVerScrollBar;
       MBStatus      :Byte;        {Bit 0 => 1 úò§ ©Æúõ†ò©¶¨£ú ´û§ õú•†¶´ú®û °òüú´û ö®ò££û}
                                   {Bit 1 => 1   >>      >>    ´û§ °ò´‡´ú®û ¶®†ù. ö®ò££û  }
                                   {Ñ•'¶®†©£¶¨ ú†§ò† °ò† ´ò õ¨¶ ©ú °ò´ò©´ò©û Set=1        }
       MBHeadTextLine:PDynText;
       MBRearTextLine:PDynText;

       MBVisualYPosit :Byte;        {Y ©¨§´ú´òö£ú§û ©´û§ ¶ü¶§û}
       MBVirtualYPosit:Word;        {í®úÆ‡§ ò®†ü£¶™ úß†¢¶öû™}
       MBMaxChoise    :Word;

       Procedure   HandleCommand; Virtual;
       Procedure   WinHandleEvent; Virtual;

       Procedure   InitMenuBox(InTitle:Str40;InVerScr :Byte;InCommand :Word);
       Procedure   MenuBoxHelp(InHelpCtx :Str80;InDiskHelp :Word);
       Procedure   ShowSelectedMenuText(StartPoint :Word);
       Procedure   ShowMenuText(HeadPtr,TailPtr :PDynText;StartPoint :Word);
       Procedure   AdjustMenuBox;

       Procedure   NormalMenuBoxColor;
       Procedure   ActiveMenuBoxColor;
       Procedure   DefaultMenuBoxColor;

       Procedure   HandleMenuBoxEvent;

       Procedure   MenuBoxDeleteAllText;

   End;

   PHelpBox     = ^HelpBox;
   HelpBox      = Object (MenuBox)

       HBX1,HBY1,
       HBX2,HBY2        :Byte;
       HBVerScrBar      :PVerScrollBar;
       HBMaxLines       :Word;
       HBVisualYPosit   :Word;
       HBVirtualYPosit  :Word;

       Procedure   InitHelpBox;
       Procedure   WriteHelpStr(Str :String);
       Procedure   UnActiveTopic;
       Procedure   CheckTopic;
       Procedure   ShowHelpText;
       Procedure   FindReference(Ref :Word);
       Procedure   HandleHelpBoxEvent;
   End;



Const
  ActiveErrorWindow :Boolean = False;
  ErrorProcessPtr   :Pointer = Nil;
  VerScr                     = 1;


Var
  TButton           :PButton;
  TInputLine        :PInputLine;
  TCheckBox         :PCheckBox;
  TRadioButton      :PRadioButton;
  TVerScrollBar     :PVerScrollBar;
  TMenuBox          :PMenuBox;
  THelpBox          :PHelpBox;

Procedure OpenErrorWindow(InX1,InY1,InX2,InY2 :Byte);
Procedure CloseErrorWindow;
Procedure ErrorMessage(Message:String;InParams :Byte);

Procedure InternalHandleCommand;

Procedure NewMenusSeq(InIDByte :Byte;TObject :Pointer;InBroadCast,InX1,InY1,InX2,InY2 :Byte);
Procedure CheckIFDisabled(PtrMenu :PMenuNode;Var YesOrNo :Boolean);
Procedure FindNextFreeObject;
Procedure FindBackFreeObject;
Procedure DisableWinCommand(Cmd :CommandsRange);
Procedure EnableWinCommand(Cmd :CommandsRange);
Function  OpenAndFindTopic(TopicNum :Word) :Byte;




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

      ActiveErrorWindow:=True;
      WinTextColor:=15;
      WinTextBackGround:=4;

      IF VgaExist Then
         Params:=WinChars+WinCharsWindow+Shadow
      Else
      IF ColorCard Then
         Params:=StandardChars+Shadow
      Else
         Params:=StandardChars+Move+CloseIcon;

      InTitle:='** ERROR **';

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

      HiddenMouseCursor;

      Win^.OpenFxWin;

      Win^.DrawFrameWin;
      Win^.DrawIcons;
      Win^.ClearWin(WinTextBackground);
      Win^.DisplayTitleWin;
      IF (Params and Shadow) = Shadow Then
          Win^.DrawShadowWin;

      ShowMouseCursor;

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
           IF Win^.WinCurX<>255 Then
           Begin
             SetCurLength(Win^.WinSScanL,Win^.WinEScanL);
             SetVirtCursorPosit(Win^.WinCurX+1,Win^.WinCurY+1);
           End;

           HiddenMouseCursor;
           Win^.DrawFrameWin;
           Win^.DrawIcons;
           Win^.DisplayTitleWin;
           ShowMouseCursor;

           T.ShowHelpCtx(Win^.CurrentMessageLine);
      End
      Else
      IF (PDActive = True) Then
           T.ShowHelpCtx(PullDownCurrentHelpCtx)
      Else
      IF (PDActive = False) and (WindowCounter <= 0) Then
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
    IF Win^.MenusSeq=Win^.HeadMenusSeq Then
    Begin
       TButton^.BDefault:=BfDefault;
       Win^.CurMenusSeq:=Win^.MenusSeq;
    End;
    Win^.MenusSeq:=Win^.MenusSeq^.Next;
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
         ReadCurPositHeight;
         Win^.WinCurX:=CurColomn;
         Win^.WinCurY:=CurRow;
         Win^.WinSScanL:=SScanL;
         Win^.WinEScanL:=EScanL;
         CurOff;
      End;

      {Now The New window}

      Inc(WindowCounter);

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

      Win^.MenusSeq:=Win^.HeadMenusSeq;
      Counter:=0;

      For I:=0 to 7 do
      Begin
          Trace:=1;
          Trace:=InParams and (Trace shl I);

          Case Trace OF
                    1:Begin
                        TButton:=Win^.MenusSeq^.NodePtr;
                        TButton^.BName:=OKStr;
                        TButton^.BCommand:=ReservedCmOk;
                        TButton^.BDisabled:=False;
                        NodeContinue;
                      End;
                    2:Begin
                        TButton:=Win^.MenusSeq^.NodePtr;
                        TButton^.BName:=CancelStr;
                        TButton^.BCommand:=ReservedCmCancel;
                        TButton^.BDisabled:=False;
                        NodeContinue;
                      End;
                    4:Begin
                        TButton:=Win^.MenusSeq^.NodePtr;
                        TButton^.BName:=IgnoreStr;
                        TButton^.BCommand:=ReservedCmIgnore;
                        TButton^.BDisabled:=False;
                        NodeContinue;
                      End;
                    8:Begin
                        TButton:=Win^.MenusSeq^.NodePtr;
                        TButton^.BName:=RetryStr;
                        TButton^.BCommand:=ReservedCmRetry;
                        TButton^.BDisabled:=False;
                        NodeContinue;
                      End;
                   16:Begin
                        TButton:=Win^.MenusSeq^.NodePtr;
                        TButton^.BName:=FailStr;
                        TButton^.BCommand:=ReservedCmFail;
                        TButton^.BDisabled:=False;
                        NodeContinue;
                      End;
          End;
      End;

      {Make the rest buttons disable so we can't go with TAB key        }

      While Win^.MenusSeq<>Nil Do
      Begin
         IF Win^.MenusSeq <> Nil Then
         Begin
          TButton:=Win^.MenusSeq^.NodePtr;
          TButton^.BDisabled:=True;
          Win^.MenusSeq:=Win^.MenusSeq^.Next;
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
         Win^.MenusSeq:=Win^.HeadMenusSeq;

         Repeat

            IF Win^.MenusSeq<>Nil Then
            Begin
               TButton:=Win^.MenusSeq^.NodePtr;

               Win^.MenusSeq^.BroadCast:=BroadCastChar(TButton^.BName);

               TButton^.ButX1:=TX1;
               TButton^.ButY1:=(InY2-2)-InY1;
               Win^.MenusSeq^.X1:=TX1;
               Win^.MenusSeq^.Y1:=(InY2-2)-InY1;
               Win^.MenusSeq^.X2:=TX1+Length(TButton^.BName);
               Win^.MenusSeq^.Y2:=(InY2-2)-InY1;
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
            Win^.MenusSeq:=Win^.MenusSeq^.Next;
            TButton:=Win^.MenusSeq^.NodePtr;
         Until (TButton^.BDisabled=True) or (Win^.MenusSeq=Nil);
      End;

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

End;

{********************* END OF ERROR WINDOWS ******************************}
{*************************************************************************}

Procedure InternalHandleCommand;
Begin
   IF (ActiveErrorWindow=True) and (Event >= ReservedCmOk) and (Event <= ReservedCmFail) Then
   Begin
    HeapErrorCode:=0;    {No Errors now}
    CloseErrorWindow;    {Close Error Window}
    AccessPDMenus:=True; {Back again to normal access}
    Asm;
      Call ErrorProcessPtr
    End;
    ErrorProcessPtr:=Nil;
   End
   Else
   IF (HelpWindowIsNotOpen = False) and (Event >= ReservedCmHelpStart) and (Event <= ReservedCmHelpEnd) Then
   Begin
      Case Event Of
        ReservedCmHelpCancel :Begin
                                   HelpWindowIsNotOpen:=True;
                                   DisposeHelp;
                                   CloseWindow;
                                   AccessPDMenus:=True; {Back again to normal access}
                              End;
        ReservedCmHelpIndex  :Begin
                                   IF CurrentHelpPtr = 0 Then
                                      Exit;
                                   MakeHistory;
                                   THelpBox^.FindReference(0);
                                   THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
                              End;
        ReservedCmHelpPrev   :Begin
                                   IF CurrentHelpHistory < 1 Then
                                      Exit;
                                   BackHistory;
                                   THelpBox^.FindReference(CurrentHelpPtr);
                                   THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
                              End;
      End;
   End;
End;


{---------------------------------------------------------------------------}
{---------------- GENERAL ROUTINES ONLY FOR THE WIN OBJECTS ----------------}
{---------------------------------------------------------------------------}

{***************************************************************************}
{Procedure NewMenusSeq`                                                     }
{Ñ†©òöú† ú§ò §ú¶ ò§´†°ú†£ú§¶ ßò®òü¨®¶¨ ©´û§ ¢†©´ò                           }
{***************************************************************************}

Procedure NewMenusSeq(InIDByte :Byte;TObject :Pointer;InBroadCast,InX1,InY1,InX2,InY2 :Byte);
Begin
    New(Win^.MenusSeq);
    Win^.MenusSeq^.IDByte:=InIDByte;
    Win^.MenusSeq^.NodePtr:=TObject;
    Win^.MenusSeq^.Next:=Nil;
    Win^.MenusSeq^.Back:=Win^.TailMenusSeq;
    Win^.MenusSeq^.X1:=InX1;
    Win^.MenusSeq^.Y1:=InY1;
    Win^.MenusSeq^.X2:=InX2;
    Win^.MenusSeq^.Y2:=InY2;
    Win^.MenusSeq^.BroadCast:=InBroadCast;


    {Not pass The first time}

    IF Win^.TailMenusSeq<>Nil Then
       Win^.TailMenusSeq^.Next:=Win^.MenusSeq;

    Win^.TailMenusSeq:=Win^.MenusSeq;

    IF Win^.HeadMenusSeq=Nil Then
       Win^.HeadMenusSeq:=Win^.MenusSeq;
End;

{*************************************************************************}
{Procedure ObjectCase                                                     }
{ï®û©†£¶ß¶†û´ò† òß¶ ´†™ Procedure FindNextFreeObject,Procedure FindBack-  }
{FreeObject.Ñß†©´®ú≠ú† False ò§ ´¶ ò§´†°ú†£ú§¶ ú†§ò† ú°ö¨®¶ û True ò§     }
{ú†§ò† ©ô¨©´¶.                                                            }
{*************************************************************************}
Procedure ObjectCase(Var DisabledObj :Boolean);
Begin
    Case Win^.CurMenusSeq^.IDByte of
        Buttons   :Begin
                        TButton:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TButton^.BDisabled;
                    End;
        InputLines:Begin
                        TInputLine:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TInputLine^.ILDisabled;
                    End;
        CheckBoxes:Begin
                        TCheckBox:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TCheckBox^.CBDisabled;
                   End;
        RadioButtons:Begin
                        TRadioButton:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TRadioButton^.RBDisabled;
                     End;
        VerScrollBars:Begin
                        TVerScrollBar:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TVerScrollBar^.VSBDisabled;
                      End;
        MenuBoxes    :Begin
                        TMenuBox:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=TMenuBox^.MBDisabled;
                      End;
        DropDowns    :Begin
{                        TDropDown:=Win^.CurMenusSeq^.NodePtr;}
                        DisabledObj:=False;{TDropDown^.DDDisabled;}
                      End;
        HelpBoxes    :Begin
                        THelpBox:=Win^.CurMenusSeq^.NodePtr;
                        DisabledObj:=False;
                      End;
    End;
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
Var
   TraceButton      :PButton;
   TraceInputLine   :PInputLine;
   TraceCheckBox    :PCheckBox;
   TraceRadioButton :PRadioButton;
   TraceVerScrollBar:PVerScrollBar;
   TraceMenuBox     :PMenuBox;
{   TraceDropDown    :PDropDown;}
   TraceHelpBox     :PHelpBox;
Begin
    Case PtrMenu^.IDByte of
        Buttons        :Begin
                          TraceButton:=PtrMenu^.NodePtr;
                          IF TraceButton^.BDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                        End;
        InputLines     :Begin
                          TraceInputLine:=PtrMenu^.NodePtr;
                          IF TraceInputLine^.ILDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                        End;
        CheckBoxes      :Begin
                          TraceCheckBox:=PtrMenu^.NodePtr;
                          IF TraceCheckBox^.CBDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                        End;

        RadioButtons   :Begin
                          TraceRadioButton:=PtrMenu^.NodePtr;
                          IF TraceRadioButton^.RBDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                        End;
        VerScrollBars  :Begin
                          TraceVerScrollBar:=PtrMenu^.NodePtr;
                          IF TraceVerScrollBar^.VSBDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                        End;
        MenuBoxes      :Begin
                          TraceMenuBox:=PtrMenu^.NodePtr;
                          IF TraceMenuBox^.MBDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;
                         End;
        DropDowns       :Begin
{                          TraceDropDown:=PtrMenu^.NodePtr;
                          IF TraceDropDown^.DDDisabled=False Then
                             YesOrNo:=False
                          Else
                             YesOrNo:=True;}
                             YesOrNo:=False;
                         End;
        HelpBoxes       :Begin
                           TraceHelpBox:=PtrMenu^.NodePtr;
                           YesOrNo:=False;
                         End;
    End;
End;


{***************************************************************************}
{Procedure DisableWinCommand                                                }
{ëô¨§ú† ú§ò ò§´†°ú†£ú§¶ (¶Æ† ú§ú®ö¶).                                       }
{***************************************************************************}

Procedure DisableWinCommand(Cmd :CommandsRange);
Var
    SearchPtr :PMenuNode;
Begin
   SearchPtr:=Win^.HeadMenusSeq;
   Repeat
      Case SearchPtr^.IDByte OF
         Buttons    :Begin
                       TButton:=SearchPtr^.NodePtr;
                       IF TButton^.BCommand in Cmd Then
                          TButton^.DisableButton;
                     End;
         InputLines  :Begin
                       TInputLine:=SearchPtr^.NodePtr;
                       IF TInputLine^.ILCommand in Cmd Then
                          TInputLine^.DisableInputLine;
                      End;
        CheckBoxes   :Begin
                       TCheckBox:=SearchPtr^.NodePtr;
                       IF TCheckBox^.CBCommand in Cmd Then
                          TCheckBox^.DisableCheckBox;
                      End;
       RadioButtons  :Begin
                       TRadioButton:=SearchPtr^.NodePtr;
                       IF TRadioButton^.RBCommand in Cmd Then
                          TRadioButton^.DisableRadioButton;
                      End;
       VerScrollBars :Begin
                       TVerScrollBar:=SearchPtr^.NodePtr;
                       IF TVerScrollBar^.VSBCommand in Cmd Then
                          TVerScrollBar^.DisableVerScrollBar;
                      End;
       MenuBoxes     :Begin
                       TMenuBox:=SearchPtr^.NodePtr;
                       IF TMenuBox^.MBCommand in Cmd Then
                          {TMenuBox^.DisableMenuBox};
                      End;
       DropDowns     :Begin
{                       TDropDown:=SearchPtr^.NodePtr;
                       IF TDropDown^.DDCommand in Cmd Then
                          TMenuBox^.DisableMenuBox;}
                      End;

      End;
      SearchPtr:=SearchPtr^.Next;
   Until (SearchPtr=Nil);
End;

{**************************************************************************}
{Procedure EnableWinCommand                                                }
{Ñ§ú®ö¶ß¶†ûú† •ò§ò ú§ò ò§´†°ú†£ú§¶                                         }
{**************************************************************************}

Procedure EnableWinCommand(Cmd :CommandsRange);
Var
    SearchPtr :PMenuNode;
Begin
   SearchPtr:=Win^.HeadMenusSeq;
   Repeat
      Case SearchPtr^.IDByte OF
         Buttons     :Begin
                       TButton:=SearchPtr^.NodePtr;
                       IF TButton^.BCommand in Cmd Then
                          TButton^.EnableButton;
                      End;
         InputLines  :Begin
                       TInputLine:=SearchPtr^.NodePtr;
                       IF TInputLine^.ILCommand in Cmd Then
                          TInputLine^.EnableInputLine;
                      End;
         CheckBoxes  :Begin
                       TCheckBox:=SearchPtr^.NodePtr;
                       IF TCheckBox^.CBCommand in Cmd Then
                          TCheckBox^.EnableCheckBox;
                      End;
         RadioButtons:Begin
                       TRadioButton:=SearchPtr^.NodePtr;
                       IF TRadioButton^.RBCommand in Cmd Then
                          TRadioButton^.EnableRadioButton;
                      End;
         VerScrollBars:Begin
                       TVerScrollBar:=SearchPtr^.NodePtr;
                       IF TVerScrollBar^.VSBCommand in Cmd Then
                          TVerScrollBar^.EnableVerScrollBar;
                      End;
       MenuBoxes     :Begin
                       TMenuBox:=SearchPtr^.NodePtr;
                       IF TMenuBox^.MBCommand in Cmd Then
                          {TMenuBox^.EnableMenuBox};
                      End;
       DropDowns     :Begin
{                       TDropDown:=SearchPtr^.NodePtr;
                       IF TDropDown^.DDCommand in Cmd Then
                          TMenuBox^.EnableMenuBox;}
                      End;

      End;
      SearchPtr:=SearchPtr^.Next;
   Until (SearchPtr=Nil);
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
    HiddenMouseCursor;
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
    ShowMouseCursor;

End;

Procedure DrawVgaBut;
Var
   I      :Byte;
   X1,Y1  :Byte;
Begin
    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;

    HiddenMouseCursor;
    For I:=X1 to X1+Length(TButton^.BName)-2 do
        WriteVirtWinChar(I,Y1-1,15,Win^.WTextBackGround,WCDnHorLineS);

    For I:=X1 to X1+Length(TButton^.BName)-2 do
        WriteVirtWinChar(I,Y1+1,0,Win^.WTextBackGround,WCUpHorLineS);

    WriteVirtWinChar(X1-1,Y1,15,Win^.WTextBackGround,WCRgVerLineS);
    WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,0,Win^.WTextBackGround,WCLfVerLineS);
    ShowMouseCursor;
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
    TButton^.BDisabled:=False;
    TButton^.BHelpCtx:=Nil;
    TButton^.BDiskHelp:=0;

    IF TButton^.BCommand = 0 Then
       Exit;

    IF TButton^.BName<>'' Then
    Begin
      Case TButton^.BDefault of
        BfNormal :NormalColor;
        BfDefault:Begin
                  DefaultColor;
                  Win^.CurMenusSeq:=Win^.MenusSeq;
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
        TButton^.BHelpCtx^:=InHelpCtx;
    End;

    TButton^.BDiskHelp:=InDiskHelp;

    IF TButton^.BDefault = BfDefault Then
      IF TButton^.BHelpCtx<>Nil Then
      Begin
         ShowHelpCtx(TButton^.BHelpCtx^);
         Win^.CurrentMessageLine:=TButton^.BHelpCtx^;
      End
      Else
         ShowHelpCtx('');

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
    HiddenMouseCursor;
    WriteVirtWinChar(X1,Y1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
    For I:=X1+1 To X1+Length(TButton^.BName)-1 do
        WriteVirtWinChar(I,Y1+1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
    ShowMouseCursor;
    Delay(ProDelay1);
    DefaultColor;
    HiddenMouseCursor;
    WriteVirtWinChar(X1+Length(TButton^.BName)-1,Y1,0,Win^.WTextBackGround,ord(ButVerShadow));
    For I:=X1+1 To X1+Length(TButton^.BName)-1 do
        WriteVirtWinChar(I,Y1+1,0,Win^.WTextBackGround,ord(ButHorShadow));
    ShowMouseCursor;
    Delay(ProDelay1);
End;

Procedure PressVgaButton;
Var
    X1,Y1       :Byte;
Begin
    X1:=TButton^.ButX1+Win^.X1;
    Y1:=TButton^.ButY1+Win^.Y1;

    NormalColor;
    Delay(ProDelay2);
    DefaultColor;
    Delay(ProDelay2);
    NormalColor;
    Delay(ProDelay2);
    DefaultColor;
    Delay(ProDelay2);
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
      HiddenMouseCursor;
      WriteVirtWinChar(TX1,TY1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
      For I:=TX1+1 To TX1+Length(TButton^.BName)-1 do
          WriteVirtWinChar(I,TY1+1,Win^.WTextColor,Win^.WTextBackGround,ord(' '));
      ShowMouseCursor;
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
      HiddenMouseCursor;
      WriteVirtWinChar(TX1+Length(TButton^.BName)-1,TY1,0,Win^.WTextBackGround,ord(ButVerShadow));
      For I:=TX1+1 To TX1+Length(TButton^.BName)-1 do
          WriteVirtWinChar(I,TY1+1,0,Win^.WTextBackGround,ord(ButHorShadow));
      ShowMouseCursor;
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
    HiddenMouseCursor;
    WriteWithOutMark(TX1,TY1,TButton^.BName);
    ShowMouseCursor;
   End;

   TButton^.BDisabled:=True;
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

    WriteTextColor:=ButNormalTxtColor;
    WriteTextBackGround:=ButNormalBckColor;
    WriteStrAndMark(TX1,TY1,TButton^.BName);

    TButton^.BDisabled:=False;
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

   WriteTextColor:=ButNormalTxtColor;
   WriteTextBackGround:=ButNormalBckColor;
   HiddenMouseCursor;
   WriteStrAndMark(TX1,TY1,TButton^.BName);
   ShowMouseCursor;
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

   WriteTextColor:=ButRevTxtColor;
   WriteTextBackGround:=ButRevBckColor;
   HiddenMouseCursor;
   WriteStrAndMark(TX1,TY1,TButton^.BName);
   ShowMouseCursor;
End;

{***************************************************************************}
{Procedure Button.SetButtonPalette;                                               }
{***************************************************************************}
Procedure Button.SetButtonPalette;
Begin
    ButNormalTxtColor :=TxtColor;
    ButNormalBckColor :=BckColor;
    ButRevTxtColor    :=CurTxtColor;
    ButRevBckColor    :=CurBckColor;
End;

{***************************************************************************}
{Procedure Button.HandleButtonEvent;                                        }
{***************************************************************************}
Procedure Button.HandleButtonEvent;
Var
   PressRelFlag :Boolean;

Procedure HandleKbEvent;
Var
   Trace   :PMenuNode;
   ButTrace:PButton;
   WX1,WY1,
   WX2,WY2 :Byte;
Begin

    TButton:=Win^.CurMenusSeq^.NodePtr;
    IF (TButton^.BCommand < ReservedCmHelpStart) and
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
        IF ButTrace^.BDisabled=False Then
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
             Delay(ProDelay1);
          Repeat

             IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) and (PressRelFlag=False) Then
             Begin
               PressMsButton;
               PressRelFlag:=True;
             End
             Else
             IF ( (MouseX <WX1) or (MouseX>WX2) or (MouseY<WY1) or (MouseY>WY2) ) and (PressRelFlag=True) Then
             Begin
               ReleaseMsButton;
               PressRelFlag:=False;
             End;

          Until (MouseButton=msIDLE);
          ReleaseMsButton;

          IF (MouseX in [WX1..WX2]) and (MouseY in [WY1..WY2]) Then
          Begin
            Event:=TButton^.BCommand;
            IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
               InternalHandleCommand
            Else
               HandleCommand;
          End;
        End;
    End
    Else
    {Ñò§ ßò´û©ò£ú ENTER ´¶´ú ú¢ò úõ‡}

    IF Ctrl=#13 Then
    Begin
        TButton:=Win^.CurMenusSeq^.NodePtr;
        PressKbButton;
        Event:=TButton^.BCommand;
        IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
           InternalHandleCommand
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
  Answer :Boolean;
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
           TButton:=Win^.CurMenusSeq^.NodePtr;
           IF Trace^.NodePtr<>TButton Then
           Begin
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


    HiddenMouseCursor;

    IF VgaExist=True Then
    Begin
       ILFillChar:=WCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,InputLineNormTxtColor,Win^.WTextBackGround,WCLeftPoint);
       WriteVirtWinChar(WX2,WY1,InputLineNormTxtColor,Win^.WTextBackGround,WCRightPoint);
    End
    Else
    Begin
       ILFillChar:=SCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,InputLineNormTxtColor,Win^.WTextBackGround,SCLeftArrow);
       WriteVirtWinChar(WX2,WY1,InputLineNormTxtColor,Win^.WTextBackGround,SCRightArrow);
    End;

    ShowMouseCursor;

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

        WriteTextColor:=InputLineRevTxtColor;
        WriteTextBackGround:=InputLineSelectedText;
        HiddenMouseCursor;
        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,InputLineRevTxtColor,InputLineRevBckColor,ILFillChar);

        ShowMouseCursor;
        TInputLine^.InputLineSelectTxt:=True;
    End
    Else
    Begin
        HiddenMouseCursor;
        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,InputLineRevTxtColor,InputLineRevBckColor,ILFillChar);
        ShowMouseCursor;
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
       InputLineNormBckColor:=Win^.WTextBackGround;

    HiddenMouseCursor;
    IF VgaExist=True Then
    Begin
       ILFillChar:=WCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,InputLineNormTxtColor,Win^.WTextBackGround,WCRightPoint);
       WriteVirtWinChar(WX2,WY1,InputLineNormTxtColor,Win^.WTextBackGround,WCLeftPoint);
    End
    Else
    Begin
       ILFillChar:=SCInputLineFillChar;
       WriteVirtWinChar(WX1,WY1,InputLineNormTxtColor,Win^.WTextBackGround,SCRightArrow);
       WriteVirtWinChar(WX2,WY1,InputLineNormTxtColor,Win^.WTextBackGround,SCLeftArrow);
    End;
    ShowMouseCursor;

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

        WriteTextColor:=InputLineNormTxtColor;
        WriteTextBackGround:=InputLineNormBckColor;
        HiddenMouseCursor;
        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,InputLineNormTxtColor,InputLineNormBckColor,ILFillChar);
        ShowMouseCursor;
    End
    Else
    Begin
        HiddenMouseCursor;
        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,InputLineNormTxtColor,InputLineNormBckColor,ILFillChar);
        ShowMouseCursor;
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
    TInputLine^.ILY2:=ObjectY2;

    TInputLine^.ILCommand:=InCommand;
    TInputLine^.ILMaxChars:=InMaxChars;
    TInputLine^.ILData:=InData;
    TInputLine^.InputLineSelectTxt:=False;
    TInputLine^.ILGrowChars:=1;
    TInputLine^.ILStrStartPosit:=1;
    TInputLine^.ILCurX:=0;
    TInputLine^.ILDisabled:=False;
    TInputLine^.ILMsFocus:=False;
    TInputLine^.ILLabel:='';
    TInputLine^.ILLabX1:=0;
    TInputLine^.ILLabY1:=0;

    NewMenusSeq(InputLines,TInputLine,255,ObjectX1,ObjectY1,ObjectX2,ObjectY2);

    NormalInputLineColor;
    TInputLine^.ILOnlyNumbers:=False;

    InputLineStr:=InData;  {user read only variable}
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

    WriteTextColor:=InputLineNormLabelColor;
    WriteTextBackGround:=Win^.WTextBackGround;
    HiddenMouseCursor;
    WriteStrAndMark(InX1+Win^.X1,InY1+Win^.Y1,InLabel);
    ShowMouseCursor;

    Win^.MenusSeq^.BroadCast:=BroadCastChar(InLabel);
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
       InputLineNormBckColor:=Win^.WTextBackGround;

    HiddenMouseCursor;
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
    ShowMouseCursor;

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

        WriteTextColor:=DisableWinColor;
        WriteTextBackGround:=InputLineNormBckColor;
        HiddenMouseCursor;
        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,DisableWinColor,InputLineNormBckColor,ILFillChar);
        ShowMouseCursor;
    End
    Else
    Begin
        HiddenMouseCursor;
        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,DisableWinColor,InputLineNormBckColor,ILFillChar);
        ShowMouseCursor;
    End;

    TInputLine^.ILDisabled:=True;
End;

{***************************************************************************}
{Procedure InputLine.EnableInputLine;                                       }
{***************************************************************************}
Procedure InputLine.EnableInputLine;
Begin
    IF (TInputLine=Nil) or (HeapErrorCode=1) Then
       Exit;

    NormalInputLineColor;
    TInputLine^.ILDisabled:=False;
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
   Name                 :Str80;
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

        WriteTextColor:=InputLineRevTxtColor;
        WriteTextBackGround:=InputLineRevBckColor;
        HiddenMouseCursor;
        WriteVirtWinOut(WX1+1,WY1,Name);

        IF Blank<>0 Then
           For I:=Blank To WX2-1 Do
             WriteVirtWinChar(I,WY1,InputLineRevTxtColor,InputLineRevBckColor,ILFillChar);
        ShowMouseCursor;

    End
    Else
    Begin
        HiddenMouseCursor;
        For I:=WX1+1 To WX2-1 Do
          WriteVirtWinChar(I,WY1,InputLineRevTxtColor,InputLineRevBckColor,ILFillChar);
        ShowMouseCursor;
    End;

End;

{***************************************************************************}
{Procedure InputLine.HandleInputLineEvent;                                  }
{***************************************************************************}
Procedure InputLine.HandleInputLineEvent;

Procedure InsertChar;
Begin
   Insert(Ctrl,TInputLine^.ILData,TInputLine^.ILGrowChars);
   Inc(TInputLine^.ILGrowChars);

   IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+1 < Win^.X1+TInputLine^.ILX2-1 Then
   Begin
      Inc(TInputLine^.ILCurX);
      SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
   End
   Else
   IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILGrowChars > Win^.X1+TInputLine^.ILX2-1 Then
      Inc(TInputLine^.ILStrStartPosit);

   WriteInputLineData;
End;

Procedure HandleKBInputLineEvent;
Begin

    TInputLine:=Win^.CurMenusSeq^.NodePtr;

    CurrentHelpPtr:=TInputLine^.ILDiskHelp;

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
           WriteTextColor:=InputLineRevLabelColor;
           WriteTextBackGround:=Win^.WTextBackGround;
           HiddenMouseCursor;
           WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);
           ShowMouseCursor;
        End;

        SetVirtCursorPositHeight(TInputLine^.ILX1+1+Win^.X1,TInputLine^.ILY1+Win^.Y1,InputLineSSL,InputLineESL);

        TInputLine^.ILGrowChars:=1;
        TInputLine^.ILStrStartPosit:=1;
        TInputLine^.ILCurX:=0;
        TInputLine^.ILMsFocus:=True;
    End
    Else

    {IF Mouse Button Then come Here                                      }

    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        IF ( (MouseX >= TInputLine^.ILX1+Win^.X1) and (MouseX <= TInputLine^.ILX2+Win^.X1) and
            (MouseY=TInputLine^.ILY1+Win^.Y1)) and (TInputLine^.ILMsFocus=False) Then
        Begin
            Ctrl:=#$FF;
            Ascii:=#$FF;
            HandleKBInputLineEvent;
        End
        Else
        IF (MouseX=TInputLine^.ILX1+Win^.X1) and (MouseY=TInputLine^.ILY1+Win^.Y1) Then
        Begin
           Repeat
            Ctrl:=#0;
            Ascii:=#75;
            HandleKBInputLineEvent;
            Delay(ProDelay3);
           Until MouseButton=MsIDle;
        End
        Else
        IF (MouseX=TInputLine^.ILX2+Win^.X1) and (MouseY=TInputLine^.ILY2+Win^.Y1) Then
        Begin
           Repeat
            Ctrl:=#0;
            Ascii:=#77;
            HandleKBInputLineEvent;
            Delay(ProDelay3);
           Until MouseButton=MsIDle;
        End;

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
             WriteTextColor:=InputLineNormLabelColor;
             WriteTextBackGround:=Win^.WTextBackGround;
             HiddenMouseCursor;
             WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);
             ShowMouseCursor;
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
             WriteTextColor:=InputLineNormLabelColor;
             WriteTextBackGround:=Win^.WTextBackGround;
             HiddenMouseCursor;
             WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);
             ShowMouseCursor;
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
            TInputLine^.ILData:='';
            TInputLine^.ILGrowChars:=1;
            TInputLine^.ILStrStartPosit:=1;
            TInputLine^.ILCurX:=0;
            DefaultInputLineColor;
        End
        Else
        Begin
          Delete(TInputLine^.ILData,TInputLine^.ILGrowChars,1);
          WriteInputLineData;
        End;
        TInputLine^.ILMsFocus:=True;
        InputLineStr:=TInputLine^.ILData;
    End
    Else

    {Any CHAR come here                                                 }

    IF (Ctrl<>#0) and (Ctrl<>#13) and (Ctrl<>#27) and (Ctrl<>#8) and
        (Length(TInputLine^.ILData) < TInputLine^.ILMaxChars) Then
    Begin

        {Ñò§ úÆ¶¨£ú £ò®°ò®†©£ú§¶ °ú†£ú§¶ ´¶´ú ©ô¨©´¶ òß¶ ´û§ ö®ò££û}

        IF TInputLine^.InputLineSelectTxt=True Then
        Begin
            TInputLine^.InputLineSelectTxt:=False;
            TInputLine^.ILData:='';
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
    End
    Else

    {IF BACK SPACE come here                                            }

    IF (Ctrl=#8) and (Ascii=#0) and (Length(TInputLine^.ILData) > 0 ) and
           (TInputLine^.ILCurX > 0 ) Then
    Begin
        Delete(TInputLine^.ILData,TInputLine^.ILGrowChars-1,1);
        Dec(TInputLine^.ILGrowChars);
        IF TInputLine^.ILStrStartPosit > 1 Then
           Dec(TInputLine^.ILStrStartPosit)
        Else
        Begin
           Dec(TInputLine^.ILCurX);
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
        Inc(TInputLine^.ILGrowChars);
        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+1 < Win^.X1+TInputLine^.ILX2-1 Then
        Begin
           Inc(TInputLine^.ILCurX);
           SetVirtCursorPosit(TInputLine^.ILX1+1+Win^.X1+TInputLine^.ILCurX,TInputLine^.ILY1+Win^.Y1);
        End
        Else
        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILGrowChars+1 > Win^.X1+TInputLine^.ILX2-1 Then
            Inc(TInputLine^.ILStrStartPosit);

        WriteInputLineData;
        TInputLine^.InputLineSelectTxt:=False;
        TInputLine^.ILMsFocus:=True;
    End
    Else

    {If LEFT ARROW come here                                            }

    IF (Ctrl=#0) and (Ascii=#75) and (TInputLine^.ILGrowChars > 0)  Then
    Begin
        Dec(TInputLine^.ILGrowChars);

        IF TInputLine^.ILGrowChars = 0 Then
           TInputLine^.ILGrowChars:=1;

        IF Win^.X1+TInputLine^.ILX1+TInputLine^.ILCurX+1 > Win^.X1+TInputLine^.ILX1+1 Then
        Begin
           Dec(TInputLine^.ILCurX);
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
End;

Procedure HandleMsInputLineEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
  Answer :Boolean;
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
               WriteTextColor:=InputLineNormLabelColor;
               WriteTextBackGround:=Win^.WTextBackGround;
               HiddenMouseCursor;
               WriteStrAndMark(TInputLine^.ILLabX1+Win^.X1,TInputLine^.ILLabY1+Win^.Y1,TInputLine^.ILLabel);
               ShowMouseCursor;
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
    TCheckBox^.CBDisabled:=False;
    TCheckBox^.CBDefault:=InDefaultCheck;
    TCheckBox^.CBHelpCtx:=Nil;
    TCheckBox^.CBDiskHelp:=0;

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
       CheckBoxNormBckColor:=Win^.WTextBackGround;

    IF CheckBoxRevBckColor=255 Then
       CheckBoxRevBckColor:=Win^.WTextBackGround;

    WriteTextColor:=CheckBoxNormTxtColor;
    WriteTextBackGround:=CheckBoxNormBckColor;
    HiddenMouseCursor;
    WriteStrAndMark(Win^.X1+ObjectX1,Win^.Y1+ObjectY1,TCheckBox^.CBTitle);
    ShowMouseCursor;

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

    WriteTextColor:=CheckBoxRevTxtColor;
    WriteTextBackGround:=CheckBoxRevBckColor;
    HiddenMouseCursor;
    WriteStrAndMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);
    ShowMouseCursor;
End;

{***************************************************************************}
{Procedure CheckBox.NormalCheckBoxColor;                                    }
{***************************************************************************}
Procedure CheckBox.NormalCheckBoxColor;
Begin

    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    WriteTextColor:=CheckBoxNormTxtColor;
    WriteTextBackGround:=CheckBoxNormBckColor;
    HiddenMouseCursor;
    WriteStrAndMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);
    ShowMouseCursor;
End;

{***************************************************************************}
{Procedure CheckBox.DisableCheckBox;                                        }
{***************************************************************************}
Procedure CheckBox.DisableCheckBox;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    WriteTextColor:=DisableWinColor;
    WriteTextBackGround:=CheckBoxNormBckColor;
    HiddenMouseCursor;
    WriteWithOutMark(Win^.X1+TCheckBox^.CBX1,Win^.Y1+TCheckBox^.CBY1,TCheckBox^.CBTitle);
    ShowMouseCursor;

    TCheckBox^.CBDisabled:=True;
End;

{***************************************************************************}
{Procedure CheckBox.EnableCheckBox;                                         }
{***************************************************************************}
Procedure CheckBox.EnableCheckBox;
Begin
    IF (TCheckBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    NormalCheckBoxColor;
    TCheckBox^.CBDisabled:=False;
End;

{***************************************************************************}
{Procedure CheckBox.HandleCheckBoxEvent;                                    }
{***************************************************************************}
Procedure CheckBox.HandleCheckBoxEvent;

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
         IF (MouseX in [TCheckBox^.CBX1+Win^.X1..TCheckBox^.CBX1+Win^.X1+Length(TCheckBox^.CBTitle)]) and
             (MouseY = TCheckBox^.CBY1+Win^.Y1) Then
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

    IF (Ctrl=#32) or (Ctrl=#13) Then
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
  Answer :Boolean;
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
    CheckBoxNormTxtColor     :=TxtColor;
    CheckBoxNormBckColor     :=BckColor;
    CheckBoxRevTxtColor      :=CurTxtColor;
    CheckBoxRevBckColor      :=CurBckColor;
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

    IF InHelpCtx<>'' Then
    Begin
      New(TRadioButton^.RBHelpCtx);
      TRadioButton^.RBHelpCtx^:=InHelpCtx;
    End
    Else
      TRadioButton^.RBHelpCtx:=Nil;
    TRadioButton^.RBDefault:=InDefault;

    New(TraceMenuNode);
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
        RadioButtonNormBckColor:=Win^.WTextBackGround;

     IF RadioButtonRevBckColor=255 Then
        RadioButtonRevBckColor:=Win^.WTextBackGround;

     WriteTextColor:=RadioButtonNormTxtColor;
     WriteTextBackGround:=RadioButtonNormBckColor;
     HiddenMouseCursor;
     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);
     ShowMouseCursor;
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
          TRadioButton^.RBDisabled:=False;
          TRadioButton^.RBX1:=ObjectX1;
          TRadioButton^.RBY1:=ObjectY1+(I-1);

          NewMenusSeq(RadioButtons,TRadioButton,BroadCastChar(TRadioButton^.RBTitle),ObjectX1,
                       ObjectY1+(I-1),ObjectX1+Length(TRadioButton^.RBTitle)+2,ObjectY1+(I-1));

          IF I=1 Then
          Begin
              TRadioButton^.RBHeadRadioButton:=Win^.MenusSeq;
              TraceNode:=Win^.MenusSeq;
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
     WriteTextColor:=RadioButtonNormTxtColor;
     WriteTextBackGround:=RadioButtonNormBckColor;
     HiddenMouseCursor;
     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);
     ShowMouseCursor;
End;

{***************************************************************************}
{Procedure RadioButton.DefaultRadioButtonColor;                             }
{***************************************************************************}
Procedure RadioButton.DefaultRadioButtonColor;
Begin
     WriteTextColor:=RadioButtonRevTxtColor;
     WriteTextBackGround:=RadioButtonRevBckColor;
     HiddenMouseCursor;
     WriteStrAndMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);
     ShowMouseCursor;
End;

{***************************************************************************}
{Procedure RadioButton.DisableRadioButton;                                  }
{***************************************************************************}
Procedure RadioButton.DisableRadioButton;
Begin
     IF (TRadioButton=Nil) or (HeapErrorCode=1) Then
        Exit;

     WriteTextColor:=DisableWinColor;
     WriteTextBackGround:=RadioButtonNormBckColor;
     HiddenMouseCursor;
     WriteWithOutMark(TRadioButton^.RBX1+Win^.X1,TRadioButton^.RBY1+Win^.Y1,TRadioButton^.RBTitle);
     ShowMouseCursor;

     TRadioButton^.RBDisabled:=True;
End;

{***************************************************************************}
{Procedure RadioButton.EnableRadioButton;                                   }
{***************************************************************************}
Procedure RadioButton.EnableRadioButton;
Begin
     IF (TRadioButton=Nil) or (HeapErrorCode=1) Then
        Exit;

    NormalRadioButtonColor;
    TRadioButton^.RBDisabled:=False;
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
         IF (MouseX in [TRadioButton^.RBX1+Win^.X1..TRadioButton^.RBX1+Win^.X1+Length(TRadioButton^.RBTitle)]) and
             (MouseY = TRadioButton^.RBY1+Win^.Y1) Then
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

    IF (Ctrl=#32) or (Ctrl=#13) Then
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
End;

Procedure HandleMsRadioButtonEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
  Answer :Boolean;
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
      TVerScrollBar^.VSBScrollBarNormBckColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.VSBScrollBarNormBckColor:=ScrollBarNormBckColor;

   IF ScrollBarRevBckColor=255 Then
      TVerScrollBar^.VSBScrollBarRevBckColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.VSBScrollBarRevBckColor:=ScrollBarRevBckColor;

   IF ScrollBarNormTxtColor=255 Then
      TVerScrollBar^.VSBScrollBarNormTxtColor:=Win^.WTextBackGround
   Else
      TVerScrollBar^.VSBScrollBarNormTxtColor:=ScrollBarNormTxtColor;

   TVerScrollBar^.VSBScrollBarRevTxtColor:=ScrollBarRevTxtColor;


   HiddenMouseCursor;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCDownArrow2);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
        Begin
          WriteVirtWinChar(
              WX1,WY1+1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
              WX2,WY1+1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLinePointer2);
        End;

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
              WX2,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLineFillChar2);
        End;


   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCDownArrow);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
          WriteVirtWinChar(
              WX1,WY1+1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLinePointer);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLineFillChar);

   End;

   ShowMouseCursor;
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
    TVerScrollBar^.VSBDisabled:=False;
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

   HiddenMouseCursor;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
                WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
                WX2,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
        Begin
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
               WX2,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,WCScrLinePointer2);
        End;

   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLinePointer);

   End;
   ShowMouseCursor;
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

   HiddenMouseCursor;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
              WX2,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLineFillChar2);
        End;
   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCScrLineFillChar);

   End;
   ShowMouseCursor;
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

   HiddenMouseCursor;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLineFillChar1);
          WriteVirtWinChar(
             WX2,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
        Begin
          WriteVirtWinChar(
             WX1,WY1+TVerScrollBar^.VSBPointer,
                 TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLinePointer1);
          WriteVirtWinChar(
             WX2,WY1+TVerScrollBar^.VSBPointer,
                 TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,WCScrLinePointer2);
        End;
   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
               WX1,I,TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
          WriteVirtWinChar(
               WX1,WY1+TVerScrollBar^.VSBPointer,
                   TVerScrollBar^.VSBScrollBarRevTxtColor,TVerScrollBar^.VSBScrollBarRevBckColor,SCScrLinePointer);
   End;
   ShowMouseCursor;
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

   HiddenMouseCursor;

   IF VgaExist Then
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCUpArrow1);
        WriteVirtWinChar(WX2,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCUpArrow2);

        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCDownArrow1);
        WriteVirtWinChar(WX2,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCDownArrow2);

        For I:=WY1+1 to WY2-1 do
        Begin
          WriteVirtWinChar(WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCScrLineFillChar1);
          WriteVirtWinChar(WX2,I,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCScrLineFillChar2);
        End;

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
        Begin
          WriteVirtWinChar(
              WX1,WY1+TVerScrollBar^.VSBPointer,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCScrLinePointer1);
          WriteVirtWinChar(
              WX2,WY1+TVerScrollBar^.VSBPointer,TVerScrollBar^.VSBScrollBarNormTxtColor,DisableColor,WCScrLinePointer2);
        End;

   End
   Else
   Begin
        WriteVirtWinChar(WX1,WY1,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCUpArrow);
        WriteVirtWinChar(WX1,WY2,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCDownArrow);

        For I:=WY1+1 to WY2-1 do
          WriteVirtWinChar(
              WX1,I,TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLineFillChar);

        IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
           WriteVirtWinChar(
              WX1,WY1+TVerScrollBar^.VSBPointer,
                  TVerScrollBar^.VSBScrollBarNormTxtColor,TVerScrollBar^.VSBScrollBarNormBckColor,SCScrLinePointer);
   End;

   ShowMouseCursor;

   TVerScrollBar^.VSBDisabled:=True;

End;

Procedure VerScrollBar.EnableVerScrollBar;
Begin
    IF (TVerScrollBar=Nil) or (HeapErrorCode=1) Then
       Exit;

   NormalVerScrollBarColor;
   TVerScrollBar^.VSBDisabled:=False;
End;

Procedure VerScrollBar.AdjustVerScrollPointer;
Var
  Stepper,Carry :Byte;
  MaxVis        :Byte;
Begin

   IF (TVerScrollBar^.VSBMaxChoises < ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
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
      TVerScrollBar^.VSBPointer:=Stepper;
End;

Procedure VerScrollBar.HandleVerScrollBarEvent;

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
        IF (MouseX in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (MouseY = Win^.Y1+TVerScrollBar^.VSBY1) Then
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
              Delay(Delayer);
              Delayer:=0;
             Until (MouseButton=MsIdle) or (Delayer=0);

             Inc(Delayer2);
           Until (MouseButton=MsIdle);

           SetMouseMinMaxX(1,80);
           SetMouseMinMaxY(1,25);

        End
        Else
        {Down Arrow}
        IF (MouseX in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (MouseY = Win^.Y1+TVerScrollBar^.VSBY2) Then
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
               Delay(Delayer);
               Delayer:=0;
             Until (MouseButton=MsIdle) or (Delayer=0);

             Inc(Delayer2);
           Until (MouseButton=MsIdle);

           SetMouseMinMaxX(1,80);
           SetMouseMinMaxY(1,25);
        End
        Else

        {Get the Scroller Pointer and move it}

        IF (MouseX in [Win^.X1+TVerScrollBar^.VSBX1..Win^.X1+TVerScrollBar^.VSBX2])
            and (MouseY = Win^.Y1+TVerScrollBar^.VSBY1+(TVerScrollBar^.VSBPointer)) Then
        Begin
           Ctrl:=#$FF;
           Ascii:=#$FF;
           HandleKBVerScrollBarEvent;
           SetMouseMinMaxX(Win^.X1+TVerScrollBar^.VSBX1,Win^.X1+TVerScrollBar^.VSBX2);
           SetMouseMinMaxY(Win^.Y1+TVerScrollBar^.VSBY1+1,Win^.Y1+TVerScrollBar^.VSBY2-1);

           Repeat
              MYMouseX:=MouseX;MYMouseY:=MouseY;

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
         IF (TVerScrollBar^.VSBMaxChoises >= ((TVerScrollBar^.VSBY2-1)-(TVerScrollBar^.VSBY1)+1)) Then
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
  Answer :Boolean;
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


{---------------------------------------------------------------------------}
{-------------------------------MENU BOX------------------------------------}
{---------------------------------------------------------------------------}

Procedure MenuBox.HandleCommand;
Begin

End;

Procedure MenuBox.WinHandleEvent;
Begin

End;

Procedure MenuBox.InitMenuBox;
Var
   VS           :PVerScrollBar;
   ObjectX1H    :Byte;


  {******************************************************************}
  {Procedure DrawMenuBox                                             }
  {Ñ†§ò† ú©‡´ú®†°û ®¶¨´†§ò ´û™ MenuBox.InitMenuBox.ëÆúõ†òùú† ´¶ °¶¨´†}
  {úß†¢¶ö‡§.                                                         }
  {******************************************************************}
  Procedure DrawMenuBox;
  Var
     I,J          :Byte;
     DestX        :Byte;
     TraceTitle   :Str40;
     Position     :Byte;
  Begin

    IF MenuBoxDesktopColor=255 Then
       MenuBoxDesktopColor:=Win^.WTextBackGround;

    HiddenMouseCursor;

    {Clear Box}

    For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
         For J:=Win^.X1+TMenuBox^.MBX1+1 to Win^.X1+TMenuBox^.MBX2-1 do
            WriteVirtWinChar(J,I,MenuBoxNormTxtColor,MenuBoxDesktopColor,32);

    {Make Title Bar}

    IF TMenuBox^.MBVerScrBar <> Nil Then
       DestX:=Win^.X1+TMenuBox^.MBX2+1+Byte(VgaExist)
    Else
       DestX:=Win^.X1+TMenuBox^.MBX2;

    For I:=Win^.X1+TMenuBox^.MBX1 to DestX do
        WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY1,0,MenuBoxNormBckColor,32);

    {Only for Vga cards}

    IF VgaExist=True Then
    Begin

       {Make Vertical Lines}

       For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
       Begin
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,I,MenuBoxNormTxtColor,MenuBoxDeskTopColor,WCLfVerLineS);
           IF TMenuBox^.MBVerScrBar = Nil Then
               WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,I,MenuBoxNormTxtColor,MenuBoxDeskTopColor,WCRgVerLineS);
       End;

       {Horizontal Lines}

        For I:=Win^.X1+TMenuBox^.MBX1+1 to DestX do
            WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,MenuBoxDeskTopColor,WCDnHorLineS);

       {And.... Corners}

        WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,MenuBoxDeskTopColor,WCDnLfCornerS);

        IF TMenuBox^.MBVerScrBar = Nil Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,
                                MenuBoxDeskTopColor,WCDnRgCornerS);
    End
    Else

    {Now for Older Video Cards}

    Begin

       {Vertical Lines}

       For I:=Win^.Y1+TMenuBox^.MBY1+1 to Win^.Y1+TMenuBox^.MBY2-1 do
       Begin
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,I,MenuBoxNormTxtColor,MenuBoxDeskTopColor,SCLfVerLine);
           IF (TMenuBox^.MBStatus and VerRightDrawing) = VerRightDrawing Then
               WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,I,MenuBoxNormTxtColor,MenuBoxDeskTopColor,SCRgVerLine);
       End;

       {Horizontal Line}

        For I:=Win^.X1+TMenuBox^.MBX1+1 to DestX do
            WriteVirtWinChar(I,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,MenuBoxDeskTopColor,SCDnHorLine);

       {And Corners}

        WriteVirtWinChar(Win^.X1+TMenuBox^.MBX1,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,MenuBoxDeskTopColor,SCDnLfCorner);
        IF TMenuBox^.MBVerScrBar = Nil Then
           WriteVirtWinChar(Win^.X1+TMenuBox^.MBX2,Win^.Y1+TMenuBox^.MBY2,MenuBoxNormTxtColor,
                MenuBoxDeskTopColor,SCDnRgCorner);
    End;

    ShowMouseCursor;

    Position:=Pos('~',TMenuBox^.MBTitle);
    IF Position<>0 Then
    Begin
      TraceTitle:=Copy(TMenuBox^.MBTitle,1,Position-1);
      TraceTitle:=TraceTitle+Copy(TMenuBox^.MBTitle,Position+1,Length(TMenuBox^.MBTitle));
    End
    Else
      TraceTitle:=TMenuBox^.MBTitle;

    X1:=Win^.X1+TMenuBox^.MBX1;
    X2:=DestX;
    DestX:=Round( ( (X2-X1)-Length(TraceTitle) ) div 2 );

    WriteTextBackGround:=MenuBoxNormBckColor;
    WriteTextColor:=0;
    WriteStrandMark(X1+DestX,Win^.Y1+TMenuBox^.MBY1,TMenuBox^.MBTitle);
  End;


{*********************************************************************}
{From here starts the real object routine.                            }
{*********************************************************************}

Begin

    IF InVerScr=VerScr Then
    Begin
      ObjectX1H:=ObjectX1;
      ObjectX1:=ObjectX2-1;
      Inc(ObjectY1);
      VS:=InitVerScrollBar(NoCm);
      ObjectX1:=ObjectX1H;
      Dec(ObjectY1);
    End
    Else
        VS:=Nil;

    IF HeapErrorCode=1 Then
    Begin
        TMenuBox:=Nil;
        Exit;
    End;

    New(TMenuBox);

    IF TMenuBox=Nil Then
       Exit;


    TMenuBox^.MBVerScrBar:=VS;
    TMenuBox^.MBX1:=ObjectX1;
    TMenuBox^.MBY1:=ObjectY1;
    IF VS <> Nil Then
       TMenuBox^.MBX2:=ObjectX2-Abs(ObjectX2-TMenuBox^.MBVerScrBar^.VSBX1)-Byte(VgaExist)
    Else
       TMenuBox^.MBX2:=ObjectX2;
    TMenuBox^.MBY2:=ObjectY2;
    TMenuBox^.MBHelpCtx:=Nil;
    TMenuBox^.MBDiskHelp:=0;
    TMenuBox^.MBDisabled:=False;
    TMenuBox^.MBText:=Nil;
    TMenuBox^.MBStatus:=Status;
    TMenuBox^.MBTitle:=InTitle;
    TMenuBox^.MBMaxChoise:=0;
    TMenuBox^.MBCommand:=InCommand;

    TMenuBox^.MBHeadTextLine:=Nil;
    TMenuBox^.MBRearTextLine:=Nil;

    TMenuBox^.MBVisualYPosit:=1;
    TMenuBox^.MBVirtualYPosit:=1;

    {If we have at least one scroll bar (either Vertical or Horizontal) then}
    {don't make new MenuSeq,just change the boundaries.                     }

    IF TMenuBox^.MBVerScrBar<>Nil Then
    Begin
      Win^.MenusSeq^.IDByte:=MenuBoxes;
      Win^.MenusSeq^.NodePtr:=TMenuBox;
      Win^.MenusSeq^.X1:=ObjectX1;
      Win^.MenusSeq^.Y1:=ObjectY1;
      Win^.MenusSeq^.X2:=ObjectX2+Abs(ObjectX2-TMenuBox^.MBVerScrBar^.VSBX2);
      Win^.MenusSeq^.Y2:=ObjectY2;
      Win^.MenusSeq^.BroadCast:=BroadCastChar(InTitle);
    End
    Else

    {If haven't any scrollers then just go ahead with the usual way}

      NewMenusSeq(MenuBoxes,TMenuBox,BroadCastChar(InTitle),ObjectX1,ObjectY1,ObjectX2,ObjectY2);

    DrawMenuBox;


    {Users read only variables}
    MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
    MenuBoxCurrentStr:='';

End;

Procedure MenuBox.MenuBoxHelp;
Begin
    IF (TMenuBox=Nil) or (HeapErrorCode=1) Then
       Exit;

    IF InHelpCtx='' Then
      TMenuBox^.MBHelpCtx:=Nil
    Else
    Begin
        New(TMenuBox^.MBHelpCtx);
        TMenuBox^.MBHelpCtx^:=InHelpCtx;
    End;

    TMenuBox^.MBDiskHelp:=InDiskHelp;
End;

Procedure MenuBox.MenuBoxDeleteAllText;
Begin
    TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

    Repeat
         IF (TMenuBox^.MBText<>Nil) Then
         Begin
             FreeMem(TMenuBox^.MBText^.TextLine,Length(TMenuBox^.MBText^.TextLine^)+1);
             TMenuBox^.MBHeadTextLine:=TMenuBox^.MBText;
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
             Dispose(TMenuBox^.MBHeadTextLine);
         End;
    Until TMenuBox^.MBText = Nil;

    TMenuBox^.MBHeadTextLine:=Nil;
    TMenuBox^.MBRearTextLine:=Nil;
    TMenuBox^.MBText:=Nil;

End;

Procedure MenuBox.ShowSelectedMenuText(StartPoint :Word);
Var
    MaxVisualTexts :Byte; {Max menus available}
    I,LenDif       :ShortInt;
    XVision        :Byte; {How many chars in X dimension}
    CurrentChoise  :Integer;
    YVOffset       :Byte;
    TraceText      :PDynText;

    Procedure PrintChoises;
    Var
       K        :Byte;
    Begin
           LenDif:=XVision - Length(TMenuBox^.MBText^.TextLine^);
           {Ñò§ ´¶ £úöúü¶™ ´¶¨ string ú†§ò† £úöò¢¨´ú®¶ òß¶ ´¶ ßò®òü¨®¶}
           {úß†¢¶öû™ ´¶´ú Æ®û©†£¶ß¶†û©ú ´û§ Copy.                     }

           IF LenDif < 0 Then
              WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),
                       Copy(TMenuBox^.MBText^.TextLine^,1,XVision))
           Else
           Begin
              WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),
                       TMenuBox^.MBText^.TextLine^);

              For K:=Win^.X1+TMenuBox^.MBX1+1+(Length(TMenuBox^.MBText^.TextLine^))
                     To Win^.X1+TMenuBox^.MBX1+XVision Do
                  WriteVirtWinChar(K,Win^.Y1+TMenuBox^.MBY1+1+(YVOffset-1),WriteTextColor,WriteTextBackGround,32);
           End;

    End;

Begin

     {è¶©ú™ úß†¢¶öú™ ©´¶§ ì ò•¶§ò}
      MaxVisualTexts:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
      Inc(MaxVisualTexts);

      XVision:=(TMenuBox^.MBX2) - (TMenuBox^.MBX1+1);

      {Print it }

      IF (StartPoint < 1) Or (StartPoint > TMenuBox^.MBMaxChoise) Then
         StartPoint:=1;

      CurrentChoise:=StartPoint;
      TMenuBox^.MBVisualYPosit:=1;


      {âò§ú £ú®†°¶¨™ ú¢úöÆ¶¨™ ö†ò ´û§ ß®‡´û úß†¢¶öû ß¶¨ üò ò®Æ†©¶¨£ú §ò}
      {´¨ß‡§¶¨£ú.                                                      }

      IF StartPoint <> 1  Then
      Begin
         IF (StartPoint + (MaxVisualTexts-1)) > (TMenuBox^.MBMaxChoise) Then
         Begin
            StartPoint:=TMenuBox^.MBMaxChoise - (MaxVisualTexts-1);
            IF StartPoint <= 0 Then
            Begin
               StartPoint:=1;
               TMenuBox^.MBVisualYPosit:=CurrentChoise;
            End
            Else
               TMenuBox^.MBVisualYPosit:=(CurrentChoise-StartPoint)+1;
         End
         Else
         IF (StartPoint < 0) OR (StartPoint > TMenuBox^.MBMaxChoise) Then
         Begin
            StartPoint:=1;
            TMenuBox^.MBVisualYPosit:=CurrentChoise;
         End;

      End;

      {*********** Now Starts the Printing Process **********************}

      YVOffset:=1;
      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      {Find The right MBText                                            }

      IF StartPoint > 1 Then
         For I:=1 to StartPoint-1 do
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;


      I:=StartPoint;
      TraceText:=TMenuBox^.MBText;
      TMenuBox^.MBVirtualYPosit:=CurrentChoise;
      Repeat

         {Come Here To Show The Current Choise}
         IF I=CurrentChoise Then
         Begin

           {BackGround Color}
           IF TMenuBox^.MBText^.TLineBackGround = $FF Then
               WriteTextBackGround:=MenuBoxDeskTopColor
           Else
               WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

           {TextColor}
           IF TMenuBox^.MBText^.TLineColor = $FF Then
               WriteTextColor:=MenuBoxNoSelectTxtColor
           Else
               WriteTextColor:=TMenuBox^.MBText^.TLineColor;

           PrintChoises;


         End
         Else

         {For all other choises come here}
         Begin

           {BackGround Color}
           IF TMenuBox^.MBText^.TLineBackGround = $FF Then
               WriteTextBackGround:=MenuBoxDeskTopColor
           Else
               WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

           {TextColor}
           IF TMenuBox^.MBText^.TLineColor = $FF Then
               WriteTextColor:=MenuBoxNormTxtColor
           Else
               WriteTextColor:=TMenuBox^.MBText^.TLineColor;

           PrintChoises;

         End;

         Inc(YVOffset);
         Inc(I);
         TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

      Until (StartPoint+MaxVisualTexts <= I) or (TMenuBox^.MBText=Nil);

      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      {Find The right MBText                                            }

      IF CurrentChoise > 1 Then
         For I:=1 to CurrentChoise-1 do
             TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;


End;

{*************************************************************************}
{Procedure MenuBox.ShowMenuText                                           }
{í¨ß‡§ú† ´†™ úß†¢¶öú™ òß¶ £†ò ©¨ö°ú°®†£ú§û úß†¢¶öû.ï®û©†£¶ß¶†ú†´ò† £¶§¶   }
{ö†ò ´û§ ß®‡´û ≠¶®ò £†ò™ °ò† °ò§ú† °ò† initialize.                        }
{*************************************************************************}

Procedure MenuBox.ShowMenuText;
Var
    I      :ShortInt;
Begin
    IF TMenuBox = Nil Then
       Exit;

    TMenuBox^.MBHeadTextLine:=HeadPtr;
    TMenuBox^.MBRearTextLine:=TailPtr;

    TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

    IF TMenuBox^.MBText <> Nil Then
    Begin


      I:=0; {Count how many texts we have}
      Repeat
         IF TMenuBox^.MBText<>Nil Then
         Begin
           Inc(I);
           TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
         End;
      Until (TMenuBox^.MBText=Nil);

      TMenuBox^.MBMaxChoise:=I;

      IF TMenuBox^.MBVerScrBar <> Nil Then
      Begin
         TMenuBox^.MBVerScrBar^.VSBMaxChoises:=I; {VerScrollBar needs this number}
                                                  {If we don't pass this number automacally}
                                                  {we must pass it manually.               }
         TMenuBox^.MBVerScrBar^.VSBPointerStep:=Trunc(I / ( (TMenuBox^.MBVerScrBar^.VSBY2-1) -
                                                    (TMenuBox^.MBVerScrBar^.VSBY1)) );
      End;


      HiddenMouseCursor;
      ShowSelectedMenuText(StartPoint);
      IF TMenuBox^.MBVerScrBar<>Nil Then
      Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=StartPoint;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
      End;
      ShowMouseCursor;

      MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
      MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

      IF TMenuBox^.MBVerScrBar = Nil Then
         Exit;

      IF (TMenuBox^.MBVerScrBar^.VSBMaxChoises < ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1)+1)) Then
          TMenuBox^.MBVerScrBar^.ClearVerScrollBarPointer
      Else
          TMenuBox^.MBVerScrBar^.NormalVerSCrollBarColor;

    End; {IF MBText<>nil}
End;

Procedure PrintCurrentChoise;
Var
   K               :Byte;
   LenDif          :ShortInt;
   XVision         :Byte;
Begin
    XVision:=(TMenuBox^.MBX2) - (TMenuBox^.MBX1+1);

    IF TMenuBox^.MBText<>Nil Then
    Begin

        LenDif:=XVision - Length(TMenuBox^.MBText^.TextLine^);
       {Ñò§ ´¶ £úöúü¶™ ´¶¨ string ú†§ò† £úöò¢¨´ú®¶ òß¶ ´¶ ßò®òü¨®¶}
       {úß†¢¶öû™ ´¶´ú Æ®û©†£¶ß¶†û©ú ´û§ Copy.                     }


        IF LenDif < 0 Then
           WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,
                    Copy(TMenuBox^.MBText^.TextLine^,1,XVision))
        Else
        Begin
           WriteVirtWinOut(Win^.X1+TMenuBox^.MBX1+1,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,
                    TMenuBox^.MBText^.TextLine^);

           For K:=Win^.X1+TMenuBox^.MBX1+1+(Length(TMenuBox^.MBText^.TextLine^))
               To Win^.X1+TMenuBox^.MBX1+XVision Do
                   WriteVirtWinChar(K,Win^.Y1+TMenuBox^.MBY1+TMenuBox^.MBVisualYPosit,WriteTextColor,WriteTextBackGround,32);
        End;

    End;

End;



Procedure MenuBox.ActiveMenuBoxColor;
Begin

    {BackGround Color}
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=MenuBoxDeskTopColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    {TextColor}
    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=MenuBoxNoSelectTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;

    HiddenMouseCursor;
    PrintCurrentChoise;
    ShowMouseCursor;
End;

Procedure MenuBox.NormalMenuBoxColor;
Begin

    {BackGround Color}
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=MenuBoxDeskTopColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    {TextColor}
    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=MenuBoxNormTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;

    HiddenMouseCursor;
    PrintCurrentChoise;
    ShowMouseCursor;

End;


Procedure MenuBox.DefaultMenuBoxColor;
Begin
    {BackGround Color}
    IF TMenuBox^.MBText^.TLineBackGround = $FF Then
       WriteTextBackGround:=MenuBoxSelectBckColor
    Else
       WriteTextBackGround:=TMenuBox^.MBText^.TLineBackGround;

    {TextColor}
    IF TMenuBox^.MBText^.TLineColor = $FF Then
       WriteTextColor:=MenuBoxSelectTxtColor
    Else
       WriteTextColor:=TMenuBox^.MBText^.TLineColor;

    HiddenMouseCursor;
    PrintCurrentChoise;
    ShowMouseCursor;

End;

{*************************************************************************}
{Procedure MenuBox.AdjustMenuBox                                          }
{ãú´ò´¶ß†ùú† ´¶ °ú†£ú§¶ ò§ò¢¶öò £ú ´¶§ pointer ´¶¨ VerScrollBar.          }
{*************************************************************************}
Procedure MenuBox.AdjustMenuBox;
Var
    MaxVis       :Byte;
    MaxVisPtr    :Byte;
    I            :Word;
    CurrentChoise:Word;
Begin
   IF (TMenuBox^.MBVerScrBar=Nil) OR
        (TMenuBox^.MBVerScrBar^.VSBMaxChoises < ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1)+1)) Then
      Exit;

   MaxVis:=(TMenuBox^.MBY2-1)-(TMenuBox^.MBY1);
   MaxVisPtr:=(TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1);
   TMenuBox^.MBVisualYPosit:=1;

   {IF VerScrollBar Pointer is on the First Position}
   IF TMenuBox^.MBVerScrBar^.VSBPointer = 1 Then
   Begin
      TMenuBox^.MBVirtualYPosit:=1;
      CurrentChoise:=1;
      TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=1;
      TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
         DefaultMenuBoxColor;
         Inc(TMenuBox^.MBVisualYPosit);
         For I:=1 to MaxVis-1 do
         Begin
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
            NormalMenuBoxColor;
            Inc(TMenuBox^.MBVisualYPosit);
         End;
         TMenuBox^.MBVisualYPosit:=1;
         TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
      End;

   End
   Else
   {IF VerScrollBar Pointer is on the Last Position}

   IF TMenuBox^.MBVerScrBar^.VSBPointer = MaxVisPtr Then
   Begin
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
         CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBMaxChoises - MaxVis;
         Inc(CurrentChoise);
         TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
         TMenuBox^.MBVisualYPosit:=MaxVis;

         DefaultMenuBoxColor;
         Dec(TMenuBox^.MBVisualYPosit);
         For I:=TMenuBox^.MBVerScrBar^.VSBMaxChoises downto CurrentChoise+1 do
         Begin
            TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
            NormalMenuBoxColor;
            Dec(TMenuBox^.MBVisualYPosit);
         End;
         TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
         TMenuBox^.MBVisualYPosit:=MaxVis;
         TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
      End
      Else
      Begin
        TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
        TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
        TMenuBox^.MBText:=TMenuBox^.MBRearTextLine;
        For I:=1 to MaxVis-1 do
            TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
        CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBMaxChoises;
      End;
   End
   Else

   {IF VerScrollBar Pointer is non of the above positions}
   Begin
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep > 1 Then
      Begin
        CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBPointer * TMenuBox^.MBVerScrBar^.VSBPointerStep;
        IF CurrentChoise+MaxVis > TMenuBox^.MBVerScrBar^.VSBMaxChoises Then
        Begin
            I:=(CurrentChoise+MaxVis) - TMenuBox^.MBVerScrBar^.VSBMaxChoises;
            CurrentChoise:=CurrentChoise-I;
            IF CurrentChoise < 0 Then
               CurrentChoise:=1;
        End;
        TMenuBox^.MBVisualYPosit:=1;
        TMenuBox^.MBVirtualYPosit:=CurrentChoise;
        TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
        TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
        IF CurrentChoise > 1 Then
           For I:=1 to CurrentChoise-1 do
               TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
      End
      Else
      IF TMenuBox^.MBVerScrBar^.VSBPointerStep = 1 Then
      Begin
          CurrentChoise:=TMenuBox^.MBVerScrBar^.VSBPointer;
          TMenuBox^.MBVisualYPosit:=1;
          TMenuBox^.MBVirtualYPosit:=CurrentChoise;
          TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
          TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;

          For I:=1 to MaxVis do
          Begin
            IF I=CurrentChoise Then
               DefaultMenuBoxColor
            Else
               NormalMenuBoxColor;
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
            Inc(TMenuBox^.MBVisualYPosit);
          End;

          TMenuBox^.MBVisualYPosit:=CurrentChoise;
          TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
          IF TMenuBox^.MBVisualYPosit > 1 Then
            For I:=1 to TMenuBox^.MBVisualYPosit-1 do
                TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

      End;
   End;


   IF TMenuBox^.MBVerScrBar^.VSBPointerStep > 1 Then
   Begin
     For I:=1 to MaxVis do
     Begin
        NormalMenuBoxColor;

        {End of the Choises? If Yes SET the Last choise}
        IF TMenuBox^.MBVerScrBar^.VSBPointer = MaxVisPtr Then
        Begin
          IF I = MaxVis Then
                DefaultMenuBoxColor;
        End
        Else
        {If not the SET the First choise}
        IF I=1 Then
           DefaultMenuBoxColor;

        Inc(TMenuBox^.MBVisualYPosit);
        TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
     End;

     Dec(TMenuBox^.MBVisualYPosit);   {Dec-1 because the For Loop inc the final result by 1}
     TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
     IF CurrentChoise > 1 Then
        For I:=1 to CurrentChoise-1 do
            TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

     IF CurrentChoise <> TMenuBox^.MBVerScrBar^.VSBMaxChoises Then
        TMenuBox^.MBVisualYPosit:=1
     Else
        TMenuBox^.MBVisualYPosit:=MaxVis;
   End;

End;

{*************************************************************************}
{Procedure MenuBox.HandleMenuBoxEvent                                     }
{Ñ°´ú¢ú† °òüú öúö¶§¶™ ú†´ú ß¢û°´®¶¢¶ö†¶¨ ú†´ú ß¶§´†°†¶¨.Ñ†§ò† û °ú§´®†°û  }
{®¶¨´†§ò ´¶¨ ò§´†°ú†£ú§¶¨ °ò† ßú®†¢ò£ôò§ú† ú©‡´ú®†°ò ò¢¢ú™ £†°®¶´ú®ú™     }
{õ†òõ†°ò©†ú™.                                                             }
{*************************************************************************}
Procedure MenuBox.HandleMenuBoxEvent;

Procedure CallVerScrollKBEvent;
Var
   TempObjectPtr        :Pointer;
Begin
   {If we haven't any ver scroll bar then just exit                     }
   IF TMenuBox^.MBVerScrBar = Nil Then
      Exit;

   Event:=0;  {KeyBoard event}
   TempObjectPtr:=Win^.CurMenusSeq^.NodePtr; {Keep the current node somewhere temp}
   Win^.CurMenusSeq^.NodePtr:=TMenuBox^.MBVerScrBar; {Put scroller pointer into}
   TMenuBox^.MBVerScrBar^.HandleVerScrollBarEvent; {Call Scroller procedure}
   Win^.CurMenusSeq^.NodePtr:=TempObjectPtr; {And then come to previous position}
End;


Procedure HandleKBMenuBoxEvent;
Var
        TraceVY           :Byte;
        I                 :Word;
        TraceText         :PDynText;
        YDif              :Byte;
        Delayer           :Word;
        Delayer2          :Word;
        TracePointer      :Byte;
        MyMouseX,MyMouseY :Byte;
        J                 :Integer;
        MouseResponse     :Boolean;
Begin

    TMenuBox:=Win^.CurMenusSeq^.NodePtr;

    IF TMenuBox^.MBVerScrBar <> Nil Then
       TVerScrollBar:=TMenuBox^.MBVerScrBar;

    CurrentHelpPtr:=TMenuBox^.MBDiskHelp;

    {For Keyboard come here}
     IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin


        CurOff;
        ReadCurPositHeight;
        Win^.WinSScanL:=SScanL;
        Win^.WinEScanL:=EScanL;
        Win^.WinCurX:=1;
        Win^.WinCurY:=1;

        DefaultMenuBoxColor;
        IF TMenuBox^.MBVerScrBar <> Nil Then
           TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

        IF TMenuBox^.MBHelpCtx<>Nil Then
        Begin
           Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
           ShowHelpCtx(TMenuBox^.MBHelpCtx^);
        End
        Else
        Begin
           Win^.CurrentMessageLine:='';
           ShowHelpCtx('');
        End;

        MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
        MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

    End
    Else

    {For Mouse come here}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        MouseResponse:=True;

        {Up Arrow}

        IF TMenuBox^.MBVerScrBar <> Nil Then
        Begin
          IF (MouseX in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBMenuBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1);

             Repeat
               Ctrl:=#0;
               Ascii:=#72;
               HandleKBMenuBoxEvent;
               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;


               Repeat
                Delay(Delayer);
                Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Down Arrow}

          IF (MouseX in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBMenuBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2);

             Repeat
               Ctrl:=#0;
               Ascii:=#80;
               HandleKBMenuBoxEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;

               Repeat
                 Delay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Get the Scroller Pointer and move it}

          IF ( (MouseX in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+(TMenuBox^.MBVerScrBar^.VSBPointer)) )
              AND ((TMenuBox^.MBVerScrBar^.VSBMaxChoises)
                        >= ((TMenuBox^.MBVerScrBar^.VSBY2-1)-(TMenuBox^.MBVerScrBar^.VSBY1)+1)) Then
          Begin

            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            {Make the initials adjustments}
            IF TMenuBox^.MBVerScrBar <> Nil Then
               TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

            IF TMenuBox^.MBHelpCtx<>Nil Then
            Begin
              Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
              ShowHelpCtx(TMenuBox^.MBHelpCtx^);
            End
            Else
             Begin
               Win^.CurrentMessageLine:='';
               ShowHelpCtx('');
             End;

             IF TMenuBox^.MBVerScrBar<>Nil Then
                TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;


             NormalMenuBoxColor;

             SetMouseMinMaxX(Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1,Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1,Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2-1);

             Repeat
                MYMouseX:=MouseX;MYMouseY:=MouseY;

                IF (MyMouseX in [Win^.X1+TMenuBox^.MBVerScrBar^.VSBX1..Win^.X1+TMenuBox^.MBVerScrBar^.VSBX2])
                     and (MyMouseY in [Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1..Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY2-1]) Then
                Begin
                  TracePointer:=(MyMouseY-(Win^.Y1+TMenuBox^.MBVerScrBar^.VSBY1+1))+1;
                  IF TracePointer <> TMenuBox^.MBVerScrBar^.VSBPointer Then
                  Begin
                     TMenuBox^.MBVerScrBar^.VSBPointer:=TracePointer;
                     TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;
                  End;
                End;
             Until (MouseButton=MsIdle);

             AdjustMenuBox;

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else
            MouseResponse:=False;
        End {IF MBVerScrBar <> Nil}
        Else
           MouseResponse:=False;


        {Mark the Choise}
        IF ( (MouseX in [Win^.X1+TMenuBox^.MBX1..Win^.X1+TMenuBox^.MBX2-1])) AND (MouseResponse=False)
           AND ( (MouseY in [Win^.Y1+TMenuBox^.MBY1+1..Win^.Y1+TMenuBox^.MBY2-1])) Then
        Begin
            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            IF TMenuBox^.MBVerScrBar <> Nil Then
               TMenuBox^.MBVerScrBar^.DefaultVerScrollBarColor;

            IF TMenuBox^.MBHelpCtx<>Nil Then
            Begin
               Win^.CurrentMessageLine:=TMenuBox^.MBHelpCtx^;
               ShowHelpCtx(TMenuBox^.MBHelpCtx^);
            End
            Else
            Begin
               Win^.CurrentMessageLine:='';
               ShowHelpCtx('');
            End;

            NormalMenuBoxColor;

            I:=(MouseY - (Win^.Y1+TMenuBox^.MBY1));
            TMenuBox^.MBVirtualYPosit:=TMenuBox^.MBVirtualYPosit + (I - TMenuBox^.MBVisualYPosit);
            TMenuBox^.MBVisualYPosit:=I;
            TMenuBox^.MBText:=TMenuBox^.MBHeadTextLine;
             IF TMenuBox^.MBVirtualYPosit > 1 Then
                 For I:=1 to TMenuBox^.MBVirtualYPosit-1 do
                     TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;

              DefaultMenuBoxColor;

              IF TMenuBox^.MBVerScrBar<>Nil Then
              Begin
                TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=TMenuBox^.MBVirtualYPosit;
                TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
                TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
              End;

              IF  msLeftDoubleClick Then
                  MenuBoxDoubleClick := True
              Else
                  MenuBoxDoubleClick :=False;

              MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
              MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
              Event:=TMenuBox^.MBCommand;
              HandleCommand;
        End
        Else
        IF MouseResponse=False Then
        Begin
            CurOff;
            ReadCurPositHeight;
            Win^.WinSScanL:=SScanL;
            Win^.WinEScanL:=EScanL;
            Win^.WinCurX:=1;
            Win^.WinCurY:=1;

            DefaultMenuBoxColor;
        End
        Else
        Begin
            Ctrl:=#$FF;
            Ascii:=#$FF;
            HandleKBMenuBoxEvent;
        End;

        MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
        MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
    End {IF Mouse}
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF ( (Ctrl=#9) and (Ascii=#0) ) OR ( (Ctrl=#0) and  (Ascii=#77)  )Then
    Begin
         ActiveMenuBoxColor;
         IF TMenuBox^.MBVerScrBar <> Nil Then
            TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
         MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
         MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
         Event:=TMenuBox^.MBCommand;
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
         ActiveMenuBoxColor;
         IF TMenuBox^.MBVerScrBar <> Nil Then
            TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
         MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
         MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
         Event:=TMenuBox^.MBCommand;
         HandleCommand;


         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    {Down Arrow come here......                                         }

    IF ((Ctrl=#0) and (Ascii=#80)) Then
    Begin
       IF TMenuBox^.MBText^.NextTextLine = Nil Then
          Exit;  {If we haven't any vertical scroller then exit}

       NormalMenuBoxColor; {Normal Colors}

       TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
       Inc(TMenuBox^.MBVisualYPosit);
       Inc(TMenuBox^.MBVirtualYPosit);

       {Scrolling Down Routine}

       IF TMenuBox^.MBVisualYPosit+TMenuBox^.MBY1 > TMenuBox^.MBY2-1 Then
       Begin
           Dec(TMenuBox^.MBVisualYPosit);
           YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
           TraceText:=TMenuBox^.MBText;
           TraceVY:=TMenuBox^.MBVisualYPosit;

           For I:=1 to YDif do
           Begin
               TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
               Dec(TMenuBox^.MBVisualYPosit);
               NormalMenuBoxColor;
           End;


           TMenuBox^.MBText:=TraceText;
           TMenuBox^.MBVisualYPosit:=TraceVY

       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Up Arrow come here.........                                        }

    IF ((Ctrl=#0) and (Ascii=#72)) Then
    Begin
       IF TMenuBox^.MBVirtualYPosit-1 = 0 Then
          Exit; {If we haven't any vertical scroller then exit}

       NormalMenuBoxColor;

       TMenuBox^.MBText:=TMenuBox^.MBText^.PrevTextLine;
       Dec(TMenuBox^.MBVisualYPosit);
       Dec(TMenuBox^.MBVirtualYPosit);

       {Scrolling Up Routine}

       IF TMenuBox^.MBVisualYPosit+TMenuBox^.MBY1 < TMenuBox^.MBY1+1 Then
       Begin
           Inc(TMenuBox^.MBVisualYPosit);
           YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1+1);
           TraceText:=TMenuBox^.MBText;
           TraceVY:=TMenuBox^.MBVisualYPosit;
           For I:=1 to YDif do
           Begin
              TMenuBox^.MBText:=TMenuBox^.MBText^.NextTextLine;
              Inc(TMenuBox^.MBVisualYPosit);
              NormalMenuBoxColor;
           End;

           TMenuBox^.MBText:=TraceText;
           TMenuBox^.MBVisualYPosit:=TraceVY
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Page Down}
    IF ((Ctrl=#0) and (Ascii=#81)) and (TMenuBox^.MBVirtualYPosit < TMenuBox^.MBMaxChoise) Then
    Begin
       YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1);
       I:=TMenuBox^.MBVirtualYPosit + ( (YDif - TMenuBox^.MBVisualYPosit) +1);
       IF I+Ydif > TMenuBox^.MBMaxChoise Then
          I:=TMenuBox^.MBMaxChoise;
       HiddenMouseCursor;
       ShowSelectedMenuText(I);
       ShowMouseCursor;
       IF TMenuBox^.MBVerScrBar<>Nil Then
       Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=I;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
         TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Page Up}
    IF ((Ctrl=#0) and (Ascii=#73)) and (TMenuBox^.MBVirtualYPosit > 1) Then
    Begin
       YDif:=(TMenuBox^.MBY2-1) - (TMenuBox^.MBY1);
       IF (TMenuBox^.MBVirtualYPosit + (YDif-1)) > (TMenuBox^.MBMaxChoise) Then
          J:=TMenuBox^.MBMaxChoise - (YDif-1)
       Else
          J:=TMenuBox^.MBVirtualYPosit - (TMenuBox^.MBVisualYPosit - 1) - YDif;

       IF J < 1 Then
          J:=1;

       HiddenMouseCursor;
       ShowSelectedMenuText(J);
       ShowMouseCursor;
       IF TMenuBox^.MBVerScrBar<>Nil Then
       Begin
         TMenuBox^.MBVerScrBar^.VSBVirtualYPosit:=J;
         TMenuBox^.MBVerScrBar^.AdjustVerScrollPointer;
         TMenuBox^.MBVerScrBar^.DefaultVerSCrollBarColor;
       End;

       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;

       DefaultMenuBoxColor;
       CallVerScrollKBEvent;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End
    Else

    {Enter come here.......                                             }

    IF ((Ctrl=#13) and (Ascii=#0)) Then
    Begin
       MenuBoxCurrentNum:=TMenuBox^.MBVirtualYPosit;
       MenuBoxCurrentStr:=TMenuBox^.MBText^.TextLine^;
       Event:=TMenuBox^.MBCommand;
       HandleCommand;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsMenuBoxEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
  Answer :Boolean;
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
           TMenuBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>TMenuBox Then
           Begin
             IF TMenuBox^.MBVerScrBar<>Nil Then
                TMenuBox^.MBVerScrBar^.NormalVerScrollBarColor;
             Win^.CurMenusSeq:=Trace;
             ActiveMenuBoxColor;
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
       0:HandleKBMenuBoxEvent;
       1:HandleMsMenuBoxEvent;
    End;
End;
{**************************** end of menu box ******************************}


Procedure HelpBox.InitHelpBox;
Var
   SaveObjX1    :Byte;
   VS           :PVerScrollBar;
Begin
    SaveObjX1:=ObjectX1;
    ObjectX1:=ObjectX2;

    IF HeapErrorCode=1 Then
    Begin
        THelpBox:=Nil;
        Exit;
    End;

    ScrollBarNormTxtColor    := 255;
    ScrollBarNormBckColor    := 6;
    ScrollBarRevTxtColor     := 0;
    ScrollBarRevBckColor     := 6;
    VS:=InitVerScrollBar(NoCm);

    New(THelpBox);

    IF THelpBox=Nil Then
       Exit;

    ObjectX1:=SaveObjX1;

    THelpBox^.HBX1:=ObjectX1;
    THelpBox^.HBY1:=ObjectY1;
    THelpBox^.HBX2:=ObjectX2;
    THelpBox^.HBY2:=ObjectY2;
    THelpBox^.HBVerScrBar:=VS;
    THelpBox^.HBMaxLines:=0;

    THelpBox^.HBVisualYPosit:=1;
    THelpBox^.HBVirtualYPosit:=1;


    Win^.MenusSeq^.IDByte:=HelpBoxes;
    Win^.MenusSeq^.NodePtr:=THelpBox;
    Win^.MenusSeq^.X1:=ObjectX1;
    Win^.MenusSeq^.Y1:=ObjectY1;
    Win^.MenusSeq^.X2:=ObjectX2+Abs(ObjectX2-THelpBox^.HBVerScrBar^.VSBX2);
    Win^.MenusSeq^.Y2:=ObjectY2;
    Win^.MenusSeq^.BroadCast:=0;

    WriteTextColor:=15;
    WriteTextBackGround:=Win^.WTextBackGround;
    TextBox(ObjectX1,ObjectY1,ObjectX2-1-Byte(VgaExist),ObjectY2,SingleLines);

    HelpBorderX1:=ObjectX1;HelpBorderY1:=ObjectY1;
    HelpBorderX2:=ObjectX2-1-Byte(VgaExist);HelpBorderY2:=ObjectY2;

    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;

    ShowHelpText;

End;

Procedure HelpBox.WriteHelpStr(Str :String);
Var
   InternX,InternTextColor,InternBackGround               :Byte;
   I                                                      :Byte;
   MyChar                                                 :String[1];
   NonPrintable                                           :Boolean;
   FoundTopic,NewTopic                                    :Boolean;
   StrReference,StrTopic                                  :String;
   Er                                                     :Integer;

Begin
    InternX:=Win^.X1+HelpCurX;

    InternTextColor:=HelpNormTxtColor;
    InternBackGround:=HelpNormBckColor;
    NonPrintable:=False;
    StrReference:='';
    StrTopic:='';
    NewTopic:=False;
    FoundTopic:=False;

    For I:=1 to Length(Str) do
    Begin
        MyChar:=Copy(Str,I,1);
        Case MyChar[1] of
        '{' :Begin
                 FoundTopic:=True;
                 NewTopic:=True;
                 InternTextColor:=HelpRevTxtColor;
                 InternBackGround:=HelpNormBckColor;
                 New(CurTopicHelpXY);
                 CurTopicHelpXY^.Next:=HeadTopicHelpXY;
                 HeadTopicHelpXY:=CurTopicHelpXY;

                 CurTopicHelpXY^.X:=InternX-Win^.X1;
                 CurTopicHelpXY^.Y:=HelpCurY;
             End;
        ':' :Begin
                 NonPrintable:=True;
                 NewTopic:=False;
             End;
        '}' :Begin
                 InternTextColor:=HelpNormTxtColor;
                 InternBackGround:=HelpNormBckColor;
                 NonPrintable:=False;
                 NewTopic:=False;
             End;
        #13 :;
        #10 :;
             Else
             Begin
                IF (NonPrintable=False) and (InternX > Win^.X1+HelpBorderX1) and (InternX < Win^.X1+HelpBorderX2) and
                          (Win^.Y1+HelpCurY > Win^.Y1+HelpBorderY1) and (Win^.Y1+HelpCurY < Win^.Y1+HelpBorderY2) Then
                Begin
                   WriteVirtWinChar(InternX,Win^.Y1+HelpCurY,InternTextColor,InternBackGround,ord(MyChar[1]));
                   Inc(InternX);
                   IF NewTopic Then
                      StrTopic:=StrTopic+MyChar;
                End
                Else
                IF NonPrintable=True Then
                Begin
                    StrReference:=StrReference+MyChar;
                End;

             End;
        End;
    End; {FOR}

    IF FoundTopic Then
    Begin
         CurTopicHelpXY^.Topic:=StrTopic;
         CurTopicHelpXY^.Active:=False;
         Val(StrReference,CurTopicHelpXY^.Reference,Er);
    End;

    IF (InternX < Win^.X1+HelpBorderX2) and (Win^.Y1+HelpCurY > Win^.Y1+HelpBorderY1) and
             (Win^.Y1+HelpCurY < Win^.Y1+HelpBorderY2) Then
    Begin
       For I:=InternX to Win^.X1+HelpBorderX2-1 do
           WriteVirtWinChar(I,Win^.Y1+HelpCurY,InternTextColor,InternBackGround,32);
    End;

End;

Procedure HelpBox.UnActiveTopic;
Begin
    IF (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil) Then
    Begin
       CurTopicHelpXY^.Active:=False;
       WriteTextColor:=HelpRevTxtColor;
       WriteTextBackGround:=HelpNormBckColor;
       HiddenMouseCursor;
       WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);
       ShowMouseCursor;
       CurTopicHelpXY:=Nil;
    End;
End;

Procedure HelpBox.CheckTopic;
Var
   Found              :Boolean;
   TempTopicHelpXY    :PTopicHelpXY;
Begin
    IF CurTopicHelpXY <> Nil Then
      IF (HelpCurX >= CurTopicHelpXY^.X) and (HelpCurX < (CurTopicHelpXY^.X+Length(CurTopicHelpXY^.Topic)))
         and (HelpCurY = CurTopicHelpXY^.Y) and (CurTopicHelpXY^.Active=True) Then
              Exit;

     Found:=False;
     TempTopicHelpXY:=HeadTopicHelpXY;
     Repeat
          IF TempTopicHelpXY <> Nil Then
          Begin
             IF (HelpCurX >= TempTopicHelpXY^.X) and (HelpCurX < (TempTopicHelpXY^.X+Length(TempTopicHelpXY^.Topic)))
                and (HelpCurY = TempTopicHelpXY^.Y) Then
             Begin
                 WriteTextColor:=HelpRevTxtColor;
                 WriteTextBackGround:=HelpRevBckColor;
                 HiddenMouseCursor;
                 WriteVirtWinOut(Win^.X1+TempTopicHelpXY^.X,Win^.Y1+TempTopicHelpXY^.Y,TempTopicHelpXY^.Topic);
                 ShowMouseCursor;
                 TempTopicHelpXY^.Active:=True;
                 Found:=True;

                 IF (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil) Then
                 Begin
                    CurTopicHelpXY^.Active:=False;
                    WriteTextColor:=HelpRevTxtColor;
                    WriteTextBackGround:=HelpNormBckColor;
                    HiddenMouseCursor;
                    WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);
                    ShowMouseCursor;
                 End;

                 CurTopicHelpXY:=TempTopicHelpXY;
             End;
             TempTopicHelpXY:=TempTopicHelpXY^.Next;
          End;
     Until (Found=True) or (TempTopicHelpXY=Nil);


     IF (Found=False) and (CurTopicHelpXY<>Nil) Then
     Begin
       IF CurTopicHelpXY^.Active=True Then
       Begin
          CurTopicHelpXY^.Active:=False;
          WriteTextColor:=HelpRevTxtColor;
          WriteTextBackGround:=HelpNormBckColor;
          HiddenMouseCursor;
          WriteVirtWinOut(Win^.X1+CurTopicHelpXY^.X,Win^.Y1+CurTopicHelpXY^.Y,CurTopicHelpXY^.Topic);
          ShowMouseCursor;
          CurTopicHelpXY^.Active:=False;
          CurTopicHelpXY:=Nil;
       End;
     End;
End;

Procedure HelpBox.ShowHelpText;
Var
   I                  :Word;
   X,Y                :Word;
   HelpSeg,HelpOfs    :Word;
   MyChar             :Char;
Begin
    CurHelpData:=HeadHelpData;

    IF CurHelpData = Nil Then
       Exit;

    THelpBox^.HBMaxLines:=0;

    HiddenMouseCursor;
    For Y:=Win^.Y1+HelpBorderY1+1 to Win^.Y1+HelpBorderY2-1 do
        For X:=Win^.X1+HelpBorderX1+1 to Win^.X1+HelpBorderX2-1 do
            WriteVirtWinChar(X,Y,HelpNormTxtColor,HelpNormBckColor,32);


    Repeat
       If CurHelpData <> Nil Then
       Begin
         WriteHelpStr(CurHelpData^.TextLine^);
         CurHelpData:=CurHelpData^.NextTextLine;
         Inc(THelpBox^.HBMaxLines);
         Inc(HelpCurY);
       End;
    Until CurHelpData = Nil;
    ShowMouseCursor;

    TVerScrollBar:=THelpBox^.HBVerScrBar;
    THelpBox^.HBVerScrBar^.SetVerScrBarMaximumChoises(THelpBox^.HBMaxLines);
    THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;

    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;
    CurTopicHelpXY:=Nil;
    CurHelpData:=HeadHelpData;
End;

{**********************************************************}
{Procedure Error_CloseHelp                                 }
{It used From internal error process and called from the   }
{ErrorProcessPtr.                                          }
{**********************************************************}
{$F+}
Procedure Error_CloseHelp;
Begin
    HelpWindowIsNotOpen:=True;
    AccessPDMenus:=True; {Back again to normal access}
    CloseWindow;
End;
{$F-}

Procedure HelpBox.FindReference(Ref :Word);
Var
   Err  :Byte;
Begin

    DisposeHelp;
    CurrentHelpPtr:=Ref;

    Err:=OpenHelpFile;
    IF Err=1 Then
    Begin
       ErrorMessage(' I can''t open the help file on disk.'+#10+
                    ' On line help window will close immediately.',bfOk);
       ErrorProcessPtr:=@Error_CloseHelp;
       Exit;
    End;

    Err:=FindTopic(Ref);

    IF Err=1 Then
    Begin
       Err:=FindTopic(HelpHistory[CurrentHelpHistory]);
       IF Err = 1 Then
       Begin
           ErrorMessage(' Fatal Error trying to load Help file.'+#10+
                        ' On line help window will close immediately.',bfOk);
           ErrorProcessPtr:=@Error_CloseHelp;
           Close(FileHlp);
           Exit;
       End;
       CurrentHelpPtr:=HelpHistory[CurrentHelpHistory];
    End;

    Close(FileHlp);


    HelpCurX:=HelpBorderX1+1;
    HelpCurY:=HelpBorderY1+1;

    THelpBox^.HBVisualYPosit:=1;
    THelpBox^.HBVirtualYPosit:=1;
    THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;


    CurOff;
    ShowHelpText;
    SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);

    THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;

End;

{*************************************************************************}
{Procedure HelpBox.HandleMenuBoxEvent                                     }
{Ñ°´ú¢ú† °òüú öúö¶§¶™ ú†´ú ß¢û°´®¶¢¶ö†¶¨ ú†´ú ß¶§´†°†¶¨.Ñ†§ò† û °ú§´®†°û  }
{®¶¨´†§ò ´¶¨ ò§´†°ú†£ú§¶¨ °ò† ßú®†¢ò£ôò§ú† ú©‡´ú®†°ò ò¢¢ú™ £†°®¶´ú®ú™     }
{õ†òõ†°ò©†ú™.                                                             }
{*************************************************************************}
Procedure HelpBox.HandleHelpBoxEvent;

Procedure CallVerScrollKBEvent;
Var
   TempObjectPtr        :Pointer;
   CurHlpPtr            :Word;
Begin
   CurHlpPtr:=CurrentHelpPtr;
   Event:=0;  {KeyBoard event}
   TempObjectPtr:=Win^.CurMenusSeq^.NodePtr; {Keep the current node somewhere temp}
   Win^.CurMenusSeq^.NodePtr:=THelpBox^.HBVerScrBar; {Put scroller pointer into}
   THelpBox^.HBVerScrBar^.HandleVerScrollBarEvent; {Call Scroller procedure}
   Win^.CurMenusSeq^.NodePtr:=TempObjectPtr; {And then come to previous position}
   CurrentHelpPtr:=CurHlpPtr;
End;


Procedure HandleKBHelpBoxEvent;
Var
        I                 :Integer;
        TraceText         :PDynText;
        YDif              :Byte;
        Delayer           :Word;
        Delayer2          :Word;
        TracePointer      :Byte;
        MyMouseX,MyMouseY :Byte;
        J                 :Integer;
        MouseResponse     :Boolean;
        Stepper           :ShortInt;

{**********************************}
{Procedure ShowTextDownWards       }
{Ñ£≠ò§†ùú† òß¶ ´û§ TraceText °ò†   }
{ò§‡ ´ò õúõ¶£ú§ò ´û™ ô¶ûüú†ò™.     }
{èêÑèÑà §ò õ†§¶¨£ú ò®Æ†°û ´†£û ©´û§}
{tracetext.                        }
{**********************************}

Procedure ShowTextDownWards;
Var
        TraceVY,TraceVX   :Byte;
        I                 :Word;
        YDif              :Byte;
Begin
    YDif:=(HelpBorderY2) - (HelpBorderY1);
    Dec(YDif);

    DisposeTopicHelpXY;
    WriteTextColor:=HelpNormTxtColor;
    WriteTextBackGround:=HelpNormBckColor;

    TraceVX:=HelpCurX;
    TraceVY:=HelpCurY;

    HelpCurX:=HelpBorderX1+1;
    CurOff;
    HiddenMouseCursor;
    For I:=1 to YDif do
    Begin
      WriteHelpStr(TraceText^.TextLine^);
      TraceText:=TraceText^.PrevTextLine;
      Dec(HelpCurY);
    End;
    ShowMouseCursor;
    HelpCurX:=TraceVX;
    HelpCurY:=TraceVY;
    CurTopicHelpXY:=Nil;
    CheckTopic;
End;


{**********************************}
{Procedure ShowTextUpWards         }
{Ñ£≠ò§†ùú† òß¶ ´û§ TraceText °ò†   }
{°ò´‡ ´ò õúõ¶£ú§ò ´û™ ô¶ûüú†ò™.    }
{èêÑèÑà §ò õ†§¶¨£ú ò®Æ†°û ´†£û ©´û§}
{tracetext.                        }
{**********************************}

Procedure ShowTextUpWards;
Var
        TraceVX,TraceVY   :Byte;
        I                 :Integer;
        YDif              :Byte;
Begin
    YDif:=(HelpBorderY2) - (HelpBorderY1);
    Dec(YDif);

    DisposeTopicHelpXY;
    WriteTextColor:=HelpNormTxtColor;
    WriteTextBackGround:=HelpNormBckColor;

    TraceVX:=HelpCurX;
    TraceVY:=HelpCurY;

    HelpCurX:=HelpBorderX1+1;
    CurOff;
    HiddenMouseCursor;
    For I:=1 to YDif do
    Begin
       WriteHelpStr(TraceText^.TextLine^);
       TraceText:=TraceText^.NextTextLine;
       Inc(HelpCurY);
    End;
    ShowMouseCursor;
    HelpCurX:=TraceVX;
    HelpCurY:=TraceVY;
    CurTopicHelpXY:=Nil;
    CheckTopic;

End;

{**************************************************************}
{Procedure AdjustHelpBox                                       }
{Adjusts text lines in proportion with the VerScrollBar Pointer}
{**************************************************************}

Procedure AdjustHelpBox;
Var
   MaxVisPtr            :Byte;
   CurrentChoise        :Integer;
   YDif                 :Byte;
   I                    :Integer;
Begin

   MaxVisPtr:=(THelpBox^.HBVerScrBar^.VSBY2-1)-(THelpBox^.HBVerScrBar^.VSBY1);
   YDif:=(HelpBorderY2) - (HelpBorderY1);
   Dec(YDif);

   {IF VerScrollBar Pointer is on the First Position}
   IF (THelpBox^.HBVerScrBar^.VSBPointer = 1) Then
   Begin
       TraceText:=HeadHelpData;
       CurHelpData:=HeadHelpData;

       HelpCurY:=HelpBorderY1+1;
       ShowTextUpWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=1;
       THelpBox^.HBVirtualYPosit:=1;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;
   End
   Else
   {IF VerScrollBar Pointer is on the Last Position}
   IF THelpBox^.HBVerScrBar^.VSBPointer = MaxVisPtr Then
   Begin
       TraceText:=TailHelpData;
       CurHelpData:=TailHelpData;

       HelpCurY:=HelpBorderY2-1;
       ShowTextDownWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=YDif;
       THelpBox^.HBVirtualYPosit:=THelpBox^.HBMaxLines;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBMaxLines;
   End
   Else
   {Anyware but Step > 1 Then}
   IF (THelpBox^.HBVerScrBar^.VSBPointerStep >= 1) Then
   Begin
       CurrentChoise:=THelpBox^.HBVerScrBar^.VSBPointer * THelpBox^.HBVerScrBar^.VSBPointerStep;
       IF ((CurrentChoise+YDif) <= THelpBox^.HBMaxLines) or
          ((CurrentChoise-YDif) < 1) and (THelpBox^.HBVerScrBar^.VSBPointerStep >1) Then
       Begin
            IF CurrentChoise+YDif > THelpBox^.HBMaxLines Then
               CurrentChoise:=1;

            THelpBox^.HBVisualYPosit:=1;
            THelpBox^.HBVirtualYPosit:=CurrentChoise;
            THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
            CurHelpData:=HeadHelpData;
            IF CurrentChoise > 1 Then
               For I:=1 to CurrentChoise-1 do
                   CurHelpData:=CurHelpData^.NextTextLine;

           TraceText:=CurHelpData;
           HelpCurY:=HelpBorderY1+1;
           ShowTextUpWards;
           SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
           CurOn;
       End
       Else
       IF ((CurrentChoise+YDif) > THelpBox^.HBMaxLines) or
          (THelpBox^.HBVerScrBar^.VSBPointerStep =1) Then
       Begin
            IF (THelpBox^.HBVerScrBar^.VSBPointerStep =1) Then
            Begin
               THelpBox^.HBVisualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               THelpBox^.HBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
               CurHelpData:=TailHelpData;

               TraceText:=CurHelpData;
               HelpCurY:=HelpBorderY2-1;
               ShowTextDownWards;

               CurHelpData:=HeadHelpData;
               For I:=1 to THelpBox^.HBVerScrBar^.VSBPointerStep-1 do
                   CurHelpData:=CurHelpData^.NextTextLine;

               HelpCurY:=HelpBorderY1+THelpBox^.HBVerScrBar^.VSBPointerStep;
            End
            Else
            Begin
               THelpBox^.HBVisualYPosit:=YDif;
               THelpBox^.HBVirtualYPosit:=CurrentChoise;
               THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=CurrentChoise;
               CurHelpData:=HeadHelpData;
               IF CurrentChoise > 1 Then
                  For I:=1 to CurrentChoise-1 do
                      CurHelpData:=CurHelpData^.NextTextLine;

               TraceText:=CurHelpData;
               HelpCurY:=HelpBorderY2-1;
               ShowTextDownWards;
            End;

            SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
            CurOn;
       End;
   End
   Else
   {Anyware but Step = 1 Then}
   IF (THelpBox^.HBVerScrBar^.VSBPointerStep > 1) Then
   Begin
       CurHelpData:=HeadHelpData;
       For I:=1 to THelpBox^.HBVerScrBar^.VSBPointerStep-1 do
          CurHelpData:=CurHelpData^.NextTextLine;

       TraceText:=CurHelpData;
       HelpCurY:=HelpBorderY1+1;
       ShowTextUpWards;
       SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
       CurOn;

       THelpBox^.HBVisualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
       THelpBox^.HBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;
       THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVerScrBar^.VSBPointerStep;

   End;


End;


Begin

    THelpBox:=Win^.CurMenusSeq^.NodePtr;
    TVerScrollBar:=THelpBox^.HBVerScrBar;
    IF CurHelpData = Nil Then
       Exit;

    {For Keyboard come here}
     IF (Ctrl=#$FF) and (Ascii=#$FF) Then
    Begin
        Win^.CurrentMessageLine:='';
        ShowHelpCtx('');
        SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
        CurOn;
        THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
        CheckTopic;
    End
    Else

    {For Mouse come here}
    IF (Ctrl=#$FE) and (Ascii=#$FE) Then
    Begin
        MouseResponse:=True;

        {Up Arrow}

        IF THelpBox^.HBVerScrBar <> Nil Then
        Begin
          IF (MouseX in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1);

             Repeat
               Ctrl:=#0;
               Ascii:=#72;
               HandleKBHelpBoxEvent;
               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;


               Repeat
                Delay(Delayer);
                Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Down Arrow}

          IF (MouseX in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2) Then
          Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
             Delayer2:=1;

             SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
             SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2);

             Repeat
               Ctrl:=#0;
               Ascii:=#80;
               HandleKBHelpBoxEvent;

               Case Delayer2 of
                 1:Delayer:=ProDelay1;
                 2:Delayer:=ProDelay2;
                 3:Delayer:=ProDelay3;
                 4:Delayer:=ProDelay4;
                 Else
                   Delayer:=ProDelay5;
               End;

               Repeat
                 Delay(Delayer);
                 Delayer:=0;
               Until (MouseButton=MsIdle) or (Delayer=0);

               Inc(Delayer2);
             Until (MouseButton=MsIdle);

             SetMouseMinMaxX(1,80);
             SetMouseMinMaxY(1,25);
          End
          Else

          {Get the Scroller Pointer and move it}

          IF ( (MouseX in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
              and (MouseY = Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+(THelpBox^.HBVerScrBar^.VSBPointer)) )
              AND ((THelpBox^.HBVerScrBar^.VSBMaxChoises)
                        >= ((THelpBox^.HBVerScrBar^.VSBY2-1)-(THelpBox^.HBVerScrBar^.VSBY1)+1)) Then
          Begin
            Win^.CurrentMessageLine:='';
            ShowHelpCtx('');
            SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
            CurOn;

            {Make the initials adjustments}
            THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;

            SetMouseMinMaxX(Win^.X1+THelpBox^.HBVerScrBar^.VSBX1,Win^.X1+THelpBox^.HBVerScrBar^.VSBX2);
            SetMouseMinMaxY(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1,Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2-1);

            Repeat
                MYMouseX:=MouseX;MYMouseY:=MouseY;

                IF (MyMouseX in [Win^.X1+THelpBox^.HBVerScrBar^.VSBX1..Win^.X1+THelpBox^.HBVerScrBar^.VSBX2])
                     and (MyMouseY in [Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1..Win^.Y1+THelpBox^.HBVerScrBar^.VSBY2-1]) Then
                Begin
                  TracePointer:=(MyMouseY-(Win^.Y1+THelpBox^.HBVerScrBar^.VSBY1+1))+1;
                  IF TracePointer <> THelpBox^.HBVerScrBar^.VSBPointer Then
                  Begin
                     THelpBox^.HBVerScrBar^.VSBPointer:=TracePointer;
                     THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
                  End;
                End;
            Until (MouseButton=MsIdle);

            AdjustHelpBox;

            SetMouseMinMaxX(1,80);
            SetMouseMinMaxY(1,25);
          End
          Else
            MouseResponse:=False;
        End; {IF HBVerScrBar <> Nil}


        {Mark the Choise}
        IF ( (MouseX in [Win^.X1+THelpBox^.HBX1+1..Win^.X1+THelpBox^.HBX2-1-Byte(VGAExist)])) AND (MouseResponse=False)
           AND ( (MouseY in [Win^.Y1+THelpBox^.HBY1+1..Win^.Y1+THelpBox^.HBY2-1]))Then
        Begin
             Win^.CurrentMessageLine:='';
             ShowHelpCtx('');
             THelpBox^.HBVerScrBar^.DefaultVerScrollBarColor;
             YDif:=(HelpBorderY2) - (HelpBorderY1);
             Dec(YDif);


             HelpCurX:=HelpBorderX1+(MouseX-(Win^.X1+THelpBox^.HBX1));
             HelpCurY:=HelpBorderY1+(MouseY-(Win^.Y1+THelpBox^.HBY1));

             IF HelpCurY-HelpBorderY1 > THelpBox^.HBMaxLines Then
                HelpCurY:=HelpBorderY1+THelpBox^.HBMaxLines;

             SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);

             Stepper:=THelpBox^.HBVisualYPosit;
             THelpBox^.HBVisualYPosit:=HelpCurY-HelpBorderY1;
             Stepper:=THelpBox^.HBVisualYPosit-Stepper;

             THelpBox^.HBVirtualYPosit:=THelpBox^.HBVirtualYPosit+Stepper;
             THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBVirtualYPosit;

             THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
             THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;


             I:=1;
             CurHelpData:=HeadHelpData;
             While (I < THelpBox^.HBVirtualYPosit) and (CurHelpData <> Nil) do
             Begin
                  IF CurHelpData <> Nil Then
                     CurHelpData:=CurHelpData^.NextTextLine;
                  Inc(I);
             End;

             CurOn;
             CheckTopic;

             IF (MsLeftDoubleClick)  Then
             Begin
               Ctrl:=#13;
               Ascii:=#0;
               HandleKBHelpBoxEvent;
             End;
        End
        Else
        IF MouseResponse=False Then
        Begin
             Ctrl:=#$FF;
             Ascii:=#$FF;
             HandleKBHelpBoxEvent;
        End;

    End {IF Mouse}
    Else

    {IF TAB was pressed then come here and move the CurMenusSeq pointer to}
    {The next node, or if it is NIL Then Go to HeadMenusSeq               }

    IF  (Ctrl=Chr(KbTab)) and (Ascii=#0) Then
    Begin
         THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
         UnActiveTopic;
         FindNextFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=0;
         WinHandleEvent;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú SHIFT-TAB ´¶´ú £†ò üú©û ß†©‡.                        }

    IF (Ctrl=#0) and (Ascii=Chr(KbShiftTab)) Then
    Begin
         THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
         UnActiveTopic;
         FindBackFreeObject;
         Ctrl:=#$FF;Ascii:=#$FF;
         Event:=0;
         BackFreeObject:=$FF;
         WinHandleEvent;
    End
    Else

    {Right Arrow}

    IF  (Ctrl=#0) and  (Ascii=Chr(KbArrowRight))   Then
    Begin
       IF Win^.X1+HelpCurX < Win^.X1+HelpBorderX2 Then
       Begin
           Inc(HelpCurX);
           SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
           CheckTopic;
       End;
    End
    Else

    {Left Arrow}

    IF ( (Ctrl=#0) and  (Ascii=Chr(KbArrowLeft))  ) Then
    Begin
       IF Win^.X1+HelpCurX > Win^.X1+HelpBorderX1+1 Then
       Begin
           Dec(HelpCurX);
           SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
           CheckTopic;
       End;
    End
    Else

    {Down Arrow come here......                                         }

    IF ((Ctrl=#0) and (Ascii=Chr(KbArrowDown))) and (CurHelpData <> Nil) Then
    Begin

       IF THelpBox^.HBVirtualYPosit >= THelpBox^.HBMaxLines Then
          Exit;

       IF HelpCurY < HelpBorderY2-1 Then
       Begin
         Inc(HelpCurY);
         Inc(THelpBox^.HBVirtualYPosit);
         Inc(THelpBox^.HBVisualYPosit);
         SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
         CheckTopic;
         CurHelpData:=CurHelpData^.NextTextLine;
       End
       Else
       IF (HelpCurY >= HelpBorderY2-1) and (THelpBox^.HBVirtualYPosit < THelpBox^.HBMaxLines) Then
       Begin

         Inc(THelpBox^.HBVirtualYPosit);
         CurHelpData:=CurHelpData^.NextTextLine;
         TraceText:=CurHelpData;

         {Scrolling Down Routine}
         ShowTextDownWards;
         HelpCurY:=HelpBorderY2-1;
         SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
         CurOn;
       End; {ELSE IF}

       CallVerScrollKBEvent;
    End
    Else

    {Up Arrow come here.........                                        }

    IF ((Ctrl=#0) and (Ascii=Chr(KbArrowUp))) and (THelpBox^.HBVirtualYPosit > 1) Then
    Begin

       IF THelpBox^.HBVirtualYPosit <=1 Then
          Exit;

       IF HelpCurY > HelpBorderY1+1 Then
       Begin
         Dec(HelpCurY);
         Dec(THelpBox^.HBVirtualYPosit);
         Dec(THelpBox^.HBVisualYPosit);
         SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
         CheckTopic;
         CurHelpData:=CurHelpData^.PrevTextLine;
       End
       Else
       IF (HelpCurY <= HelpBorderY1+1) and (THelpBox^.HBVirtualYPosit > 1) Then
       Begin

         Dec(THelpBox^.HBVirtualYPosit);
         CurHelpData:=CurHelpData^.PrevTextLine;
         TraceText:=CurHelpData;

         {Scrolling Down Routine}
         ShowTextUpWards;
         HelpCurY:=HelpBorderY1+1;
         SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
         CurOn;
       End; {End IF}

       CallVerScrollKBEvent;
    End
    Else

    {Page Down}
    IF ((Ctrl=#0) and (Ascii=Chr(KbPageDown))) and (THelpBox^.HBVirtualYPosit < THelpBox^.HBMaxLines) Then
    Begin
       YDif:=(HelpBorderY2) - (HelpBorderY1);
       Dec(YDif);

       IF THelpBox^.HBMaxLines <= YDif Then
          Exit;

       I:=THelpBox^.HBVirtualYPosit + ( (YDif - THelpBox^.HBVisualYPosit)+1);
       IF I+Ydif > THelpBox^.HBMaxLines Then
       Begin
          TraceText:=TailHelpData;
          CurHelpData:=TailHelpData;
          HelpCurY:=HelpBorderY2-1;
          ShowTextDownWards;
          HelpCurY:=HelpBorderY2-1;
          SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
          CurOn;
          THelpBox^.HBVirtualYPosit:=THelpBox^.HBMaxLines;
          THelpBox^.HBVisualYPosit:=YDif;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=THelpBox^.HBMaxLines;
       End
       Else
       Begin
          For J:=THelpBox^.HBVirtualYPosit to I-1 do
               CurHelpData:=CurHelpData^.NextTextLine;

          TraceText:=CurHelpData;
          HelpCurY:=HelpBorderY1+1;
          ShowTextUpWards;
          HelpCurY:=HelpBorderY1+1;
          SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
          CurOn;
          THelpBox^.HBVirtualYPosit:=I;
          THelpBox^.HBVisualYPosit:=1;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=I;
       End;

       CheckTopic;
       THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
       THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
       CallVerScrollKBEvent;

    End
    Else

    {Page Up}
    IF ((Ctrl=#0) and (Ascii=Chr(KbPageUp))) and (THelpBox^.HBVirtualYPosit > 1) Then
    Begin

       YDif:=(HelpBorderY2) - (HelpBorderY1);
       Dec(YDif);

       I:=THelpBox^.HBVirtualYPosit - (THelpBox^.HBVisualYPosit - 1) -1;
       IF I-YDif < 1 Then
       Begin
          TraceText:=HeadHelpData;
          CurHelpData:=HeadHelpData;
          HelpCurY:=HelpBorderY1+1;
          ShowTextUpWards;
          HelpCurY:=HelpBorderY1+1;
          SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
          CurOn;
          THelpBox^.HBVirtualYPosit:=1;
          THelpBox^.HBVisualYPosit:=1;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=1;
       End
       Else
       Begin
          For J:=THelpBox^.HBVirtualYPosit Downto I+1 do
               CurHelpData:=CurHelpData^.PrevTextLine;

          TraceText:=CurHelpData;
          HelpCurY:=HelpBorderY2-1;
          ShowTextDownWards;
          HelpCurY:=HelpBorderY2-1;
          SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
          CurOn;
          THelpBox^.HBVirtualYPosit:=I;
          THelpBox^.HBVerScrBar^.VSBVirtualYPosit:=I;
          THelpBox^.HBVisualYPosit:=1;
       End;

       CheckTopic;

       THelpBox^.HBVerScrBar^.AdjustVerScrollPointer;
       THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
       CallVerScrollKBEvent;

    End
    Else

    {End}

    IF (Ctrl=#0) and (Ascii=Chr(KbEnd)) Then
    Begin
        HelpCurX:=HelpBorderX1+Length(CurHelpData^.TextLine^)-1;
        IF HelpCurX >= HelpBorderX2 Then
           HelpCurX:=HelpBorderX2-1;
        SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
        CheckTopic;
    End
    Else

    {Home}

    IF (Ctrl=#0) and (Ascii=Chr(KbHome)) Then
    Begin
        HelpCurX:=HelpBorderX1+1;
        SetVirtCursorPosit(Win^.X1+HelpCurX,Win^.Y1+HelpCurY);
        CheckTopic;
    End
    Else

    {Enter}

    IF (Ctrl=#13) and (CurTopicHelpXY^.Active=True) and (CurTopicHelpXY<>Nil)
         and (CurHelpData <> Nil) Then
    Begin
        MakeHistory;
        IF CurTopicHelpXY^.Reference = CurrentHelpPtr Then
        Begin
            BackHistory;
            Exit;
        End;
        FindReference(CurTopicHelpXY^.Reference);
        THelpBox^.HBVerScrBar^.DefaultVerSCrollBarColor;
        CheckTopic;
        CurOn;
    End;

    MsLeftDoubleClick:=False;
End;

Procedure HandleMsHelpBoxEvent;
Var
  Trace  :PMenuNode;
  Found  :Boolean;
  WX1,WY1,
  WX2,WY2:Byte;
  Answer :Boolean;
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
           THelpBox:=Win^.CurMenusSeq^.NodePtr;

           IF Trace^.NodePtr<>THelpBox Then
           Begin
             THelpBox^.HBVerScrBar^.NormalVerScrollBarColor;
             UnActiveTopic;
             Win^.CurMenusSeq:=Trace;
             ActiveMenuBoxColor;
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
       0:HandleKBHelpBoxEvent;
       1:HandleMsHelpBoxEvent;
    End;
End;



Function OpenAndFindTopic(TopicNum :Word) :Byte;
Var
   Err  :Integer;
Begin
    Err:=OpenHelpFile;
    IF Err = 1 Then
    Begin
      ErrorMessage('     No help available.   ',bfOk);
      OpenAndFindTopic:=1;
      Exit;
    End;

    Err:=FindTopic(TopicNum);
    IF (Err = 1) and (HeapErrorCode=0) Then
    Begin
       ErrorMessage('No help available for this'+#10+
                   'topic.',BfOk);
       OpenAndFindTopic:=1;
       Close(FileHlp);
       Exit;
    End
    Else
    IF (Err = 1) and (HeapErrorCode=1) Then
    Begin
       Close(FileHlp);
       OpenAndFindTopic:=1;
       Exit;
    End;

    OpenAndFindTopic:=0;
    Close(FileHlp);
End;



Begin

End.