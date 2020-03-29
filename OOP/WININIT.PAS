UNIT WININIT;

INTERFACE

Uses SavRstObj,WindowsObj,VarConstObj,GeneralObj,MouseObj,DemoFx,PullDnMenus,
              ErrorDlg,WinApplObj,WinObjA,WinObjB,WinObjC,HelpObj,Dos,Crt;


{$L C:\bp7\Obj\Asm_Ints.Obj}
{$I C:\bp7\include\Elingr.Inc}

Const
    ExitFromProgram  :Boolean = False;  {íû§ âò§¶¨£ú True ¶´ò§ üú¢¶¨£ú ú•¶õ¶ òß¶ ´¶ ß®¶ö®ò££ò}
    SetBackGround    :Boolean = True;
    DosFonts         :Boolean = False;
    VgaFonts         :Boolean = True;
    ExclusiveVGA     :Boolean = False;

Type


   Application = Object (TxtBox)
        Constructor Init;
        Procedure   Run;
        Destructor  Done;

        Procedure WinHandleEvent; Virtual;
        Procedure RunHelp;
        Procedure OpenHelpContext;

   End;

   MonType = (Color,Bw,LCD);

Const
   MONITOR   :MonType = Color;
   LCDPalette:Array [0..16] of Byte =
       (Black,Black,Black,Black,Black,Black,63,LightGray,LightGray,
       LightGray,LightGray,LightGray,LightGray,LightGray,63,63,Black);

   DefaultPalette:Array [0..16] of Byte =
       (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0);

Var
  CurX,CurY,
  CurSScanL,CurEScanL           :Byte;
  Ec                            :Byte;
  MsDosX,
  MsDosY,
  MsDosSScanL,
  MsDosEScanL,
  MsDosScreenPage               :Byte;


  OldInt16,OldInt1B,OldInt23    :Pointer;
  OldInt9,OldInt24              :Pointer;
  UnitScr,UnitScr2              :ScreenBasics;

  SaveDosFont                   :FontData;
  DeskTopPalette                :RGBType;

Procedure InitKeybBuffer;
Procedure InitColorCard;
Procedure InitMonoCard;
Procedure InitVgaCard;
Procedure DeskTopHead(TxtColor,BckColor :Byte;Title :String);
Procedure ShowNewMode;
Procedure ContrastNewMode;
Procedure SetText80x25;
Procedure SetText80x30;
Procedure SetText80x43;
Procedure SetText80x60;
Procedure SetText132x25;
Procedure SetText132x30;
Procedure SetText132x43;
Procedure SetText132x60;
Procedure WindowErrorMessage;
Procedure MoveWinErrorMessage;
Function  CriticalErrorMessage :String;
Procedure ShowCriticalErrorWin;
Function  TDosErrorMessage(DosErrorType :Integer) :String;
Procedure InitErrorMem;
Procedure DoneErrorMem;
Procedure CloseVgaCard;
Procedure InitApplication;
Procedure DoneApplication;
{$F+}
Procedure DoneWindowObjects;
{$F-}



IMPLEMENTATION

{*********************************************************************}
{Procedure WindowBroadCast                                            }
{Checks every PMenuNode to find if the Ctrl character matches with the}
{PMenusNode^.BroadCast's one.                                         }
{If Yes then take the X and Y coordinates and put them into MouseX and}
{MouseY variables.Then Set Event var so that it means that we have a  }
{mouse event and not a keyboard and continue normally.                }
{It used only for window objects and not for PullDownMenus.           }
{*********************************************************************}

Procedure WindowBroadCastEvent;
Var
   Temp         :PMenuNode;
Begin
    IF Event<>0 Then {if not Keyboard event then exit}
       Exit;

    IF (Mem[$0040:$0017] and 4) <> 4 Then {If not Ctrl Pressed the exit}
       Exit;

    Temp:=Win^.HeadMenusSeq;
    Repeat
       IF Temp<>Nil Then
       Begin
           IF (Temp^.BroadCast=Ord(Ctrl)) and (Ascii=#0) Then
           Begin
               Event:=0; {Set Keyboard event}
               CtrlPressed.Address:=Temp;
               CtrlPressed.Ascii:=#0;
               CtrlPressed.Ctrl:=Ctrl;
               Ctrl:=#0;Ascii:=#0;
               Exit;
           End
           Else
              Temp:=Temp^.Next;
       End;
    Until Temp=Nil;

End;


{***********************************************************************}
{Procedure WinHandleEvent;Virtual                                       }
{It takes from the CurMenusSeq:PMenuNode The IDByte and then just follow}
{the flow.                                                              }
{It called every time we press Tab,Shift-Tab,Mouse Left Button,....     }
{***********************************************************************}

Procedure Application.WinHandleEvent;
Begin
   IF (Win<>Nil) Then
     IF (Win^.CurMenusSeq<>Nil) Then
     Begin
        Case Win^.CurMenusSeq^.IDByte of
           Buttons        :HandleButtonEvent;
           InputLines     :HandleInputLineEvent;
           CheckBoxes     :HandleCheckBoxEvent;
           RadioButtons   :HandleRadioButtonEvent;
           VerScrollBars  :HandleVerScrollBarEvent;
           MenuBoxes      :HandleMenuBoxEvent;
           DropDowns      :HandleDropDownEvent;
           HelpBoxes      :HandleHelpBoxEvent;
           TextBoxes      :HandleTextBoxEvent;
        End;

        MouseX:=InterMX+1;MouseY:=InterMY+1;
     End;
End;




{-------------------------END OF OBJECTS----------------------------------}

{***************************************************************************}
{Procedure DownWindowObjects :Far                                           }
{It used from the CloseWindow Procedure to Delete and DeAllocate every obect}
{in the Current window.Just we take the IDByte and every case handled       }
{separately.                                                                }
{Note:The Procedure declarated Far,because we call it from a previous unit  }
{     (Father Unit) and not a child unit - WindowsObj.Tpu -.                }
{***************************************************************************}


{$F+}
Procedure DoneWindowObjects;
Var
   Trace        :PMenuNode;
Begin
     IF Win^.HeadMenusSeq=Nil Then
        Exit;

     Win^.CurMenusSeq:=Win^.HeadMenusSeq;
     Trace:=Win^.CurMenusSeq;

     Repeat
         IF Win^.CurMenusSeq<>Nil Then
         Begin
             Case Win^.CurMenusSeq^.IDByte OF
               Buttons      :Begin
                               TButton:=Win^.CurMenusSeq^.NodePtr;
                               IF TButton^.BHelpCtx<>Nil Then
                                  Dispose(TButton^.BHelpCtx);
                               Dispose(TButton);
                             End;
               InputLines   :Begin
                               TInputLine:=Win^.CurMenusSeq^.NodePtr;
                               IF TInputLine^.ILHelpCtx<>Nil Then
                                  Dispose(TInputLine^.ILHelpCtx);
                               IF TInputLine^.ILMask <> Nil Then
                                  Dispose(TInputLine^.ILMask);
                               Dispose(TInputLine);
                             End;
               CheckBoxes   :Begin
                               TCheckBox:=Win^.CurMenusSeq^.NodePtr;
                               IF TCheckBox^.CBHelpCtx<>Nil Then
                                  Dispose(TCheckBox^.CBHelpCtx);
                               Dispose(TCheckBox);
                             End;
               RadioButtons :Begin
                               TRadioButton:=Win^.CurMenusSeq^.NodePtr;
                               IF TRadioButton^.RBHelpCtx<>Nil Then
                                  Dispose(TRadioButton^.RBHelpCtx);
                               Dispose(TRadioButton);
                             End;
               VerScrollBars:Begin
                               TVerScrollBar:=Win^.CurMenusSeq^.NodePtr;
                               IF TVerScrollBar^.VSBHelpCtx<>Nil Then
                                  Dispose(TVerScrollBar^.VSBHelpCtx);
                               Dispose(TVerScrollBar);
                             End;
               MenuBoxes    :Begin
                               TMenuBox:=Win^.CurMenusSeq^.NodePtr;
                               TMenuBox^.MenuBoxDeleteAllText;
                               IF TMenuBox^.MBHelpCtx<>Nil Then
                                  Dispose(TMenuBox^.MBHelpCtx);
                               IF TMenuBox^.MBVerScrBar<>Nil Then
                               Begin
                                  IF TMenuBox^.MBVerScrBar^.VSBHelpCtx<>Nil Then
                                     Dispose(TMenuBox^.MBVerScrBar^.VSBHelpCtx);
                                  Dispose(TMenuBox^.MBVerScrBar);
                               End;
                               Dispose(TMenuBox);
                             End;
               HelpBoxes    :Begin
                               THelpBox:=Win^.CurMenusSeq^.NodePtr;
                               Dispose(THelpBox^.HBVerScrBar);
                               Dispose(THelpBox);
                             End;
               DropDowns    :Begin
                               TDropDown:=Win^.CurMenusSeq^.NodePtr;
                               IF TDropDown^.DDHelpCtx<>Nil Then
                                  Dispose(TDropDown^.DDHelpCtx);
                               TDropDown^.DropDownDeleteAllText;
                               Dispose(TDropDown);
                             End;
               TextBoxes    :Begin
                               TTxtBox:=Win^.CurMenusSeq^.NodePtr;
                               IF TTxtBox^.TBHelpCtx<>Nil Then
                                  Dispose(TTxtBox^.TBHelpCtx);
                               TTxtBox^.TextBoxDeleteAllText;
                               Dispose(TTxtBox);
                             End;
             End;
             Win^.CurMenusSeq:=Win^.CurMenusSeq^.Next;
             Dispose(Trace);
             Trace:=Win^.CurMenusSeq;
         End;
     Until Win^.CurMenusSeq=Nil
End;
{$F-}


{**************************************************************************}
{Procedure OpenHelpContext                                                 }
{The name of the procedure talks by itself.                                }
{**************************************************************************}
Procedure Application.OpenHelpContext;
Var
   Er   :Byte;
   Vs   :PVerScrollBar;
Begin

    Er:=OpenAndFindTopic(CurrentHelpPtr);
    IF Er = 1 Then
       Exit;

    WinTextColor:=15;
    WinTextBackGround:=5;
    OpenWindow(HelpWinX1,4,HelpWinX2,22,'On Line Help',Movement+WinChars+WinCharsWindow+OpenFx+CloseFx+Shadow+CloseIcon);
    IF HeapErrorCode <> 0 Then
    Begin
       DisposeHelp;
       HeapErrorCode:=0;
       Exit;
    End;

    HelpWindowIsNotOpen:=False;
    AccessPDMenus:=False;

    Win^.CloseCommand:=ReservedCmHelpCancel;

    AssignXY(2,16,0,0);
    InitButton('  ~âò´ò¢¶ö¶™  ',ReservedCmHelpIndex,PushButton,BfDefault);
    ButtonHelp('âò´ò¢¶ö¶™ ¶¢û™ ´û™ ô¶ûüú†ò™.',NoHelp);

    AssignXY(20,16,0,0);
    InitButton(' ~è®¶ûö¶¨£ú§¶ ',ReservedCmHelpPrev,PushButton,BfNormal);
    ButtonHelp('èûöò†§¶¨£ú ©´¶ ß®¶ûö¶¨£ú§¶ topic.',NoHelp);

    AssignXY(38,16,0,0);
    InitButton('   ~Ä°Á®‡©û   ',ReservedCmHelpCancel,PushButton,BfNormal);
    ButtonHelp('Ñ•¶õ¶ òß¶ ´û§ ô¶ûüú†ò.',NoHelp);

    HelpBorderX2:=(HelpWinX2-HelpWinX1)-2;

    AssignXY(HelpBorderX1,2,HelpBorderX2,14);
    InitHelpBox;

    IF MouseButton=msRight Then
    Begin
        Repeat
        Until MouseButton=msIdle;
    End;

    Ctrl:=#$FF;
    Ascii:=#$FF;
    ClearEvent;

End;

{*******************************************************************}
{Procedure InitNewInt16_Asm                                         }
{Called from Keyboard.Obj.It MUST be far because we call it from a  }
{unit.                                                              }
{*******************************************************************}

{$F+}
Procedure InitNewInt16_NewInt9_Asm;External;
{$F-}

{*******************************************************************}
{Procedure NewInt1B                                                 }
{New interrupt handler for int 1bh                                  }
{*******************************************************************}
{$F+}
Procedure NewInt1B(Flags, CS, IP, AX, BX, CX, DX, SI, DI, DS, ES, BP: Word);Interrupt;
Begin
       {Nothing Here}
       asm;
         sti
       end;
End;
{$F-}
{******************************************************************}
{Procedure NewInt23                                                }
{New interrupt handler for int 23h                                 }
{******************************************************************}
{$F+}
Procedure NewInt23(Flags, CS, IP, AX, BX, CX, DX, SI, DI, DS, ES, BP: Word);Interrupt;
Begin
       {Nothing Here}
       asm;
         sti
       end;
End;
{$F-}
{*****************************************************************}
{Procedure InitKeybBuffer                                         }
{Initialize the Keyboard buffer to point at the Start of the      }
{Buffer.                                                          }
{*****************************************************************}

Procedure InitKeybBuffer;
Begin
    Mem[$0040:$001A]:=$001E;  {Head Pointer}
    Mem[$0040:$001C]:=$001E;  {Tail Pointer}
End;



{*****************************************************************}
{Procedure NewInt9                                                }
{New Interrupt handler for int 9h                                 }
{*****************************************************************}
{$F+}
Procedure NewInt9(Flags, CS, IP, AX, BX, CX, DX, SI, DI, DS, ES, BP: Word);Interrupt;
Begin
  {The new interrupt handler contained to assembly code,not here}
End;
{$F-}

{******************************************************************}
{Procedure NewInt24                                                }
{NewInterrupt Handler for int 24                                   }
{Input :Ah = Error Information, DI = Error Type.                   }
{OutPut:Set Critical Error =1,CriticalErType and CriticalInfo.     }
{******************************************************************}
{$F+}
Procedure InitNewInt24_Asm;External;
{$F-}


{***************************************************************************}
{Procedure InitColorCard                                                    }
{âò§ú† initialize ©´†™ ú•ú†™ °ò®´ú™ ¶ü¶§û™ :EGA,CGA                         }
{Ç†§¶§´ò† ®¨ü£†©ú†™ Æ®‡£ò´‡§.                                               }
{***************************************************************************}

Procedure InitColorCard;
Begin
    ColorCard:=True;

    ButRevBckColor:=ButNormalBckColor;
    ButRevTxtColor:=15;

    WindowFrame:=StandardChars;
    DisableColor:=8;

    StatLineTxtColor:=0;
    StatLineBckColor:=7;

    PullDnTextColor:=0;
    PullDnTextBackGround:=7;

    DeskTopBackGroundColor:= 7;
    DeskTopTextColor:= 1;
    DeskTopFillChar:= 176;

    ScrollBarNormTxtColor:=15;
    ScrollBarNormBckColor:=255;
    ScrollBarRevTxtColor:=15;
    ScrollBarRevBckColor:=0;

    DropDownTableColor:=3;


    WTitleTextColor:=15;
    WTitleTextBackGround:=3;
End;

{***************************************************************************}
{Procedure InitMonoCard                                                     }
{âò§ú† initialize ©´†™ ú•ú†™ °ò®´ú™ :Hercules,MDA                           }
{Ñß†©û™ ö†§¶§´ò† ®¨ü£†©ú†™ Æ®‡£ò´‡§                                         }
{***************************************************************************}

Procedure InitMonoCard;
Begin
    MonoCard:=True;

    ButRevBckColor:=7;
    ButRevTxtColor:=0;
    ButNormalTxtColor:=3;
    ButNormalBckColor:=0;

    WindowFrame:=StandardChars;
    DisableColor:=8;

    PullDnTextBackGround:=0;
    PullDnTextColor:=3;

    StatLineTxtColor:=15;
    StatLineBckColor:=0;

    DeskTopBackGroundColor:= 0;
    DeskTopTextColor:= 8;
    DeskTopFillChar:= 177;

    MarkCharFgColor:= 9;

    PDRevBckColor:=7;
    PDRevTxtColor:=0;

    MoveX1Limit:=1;
    MoveX2Limit:=80;
    MoveY1Limit:=2;
    MoveY2Limit:=24;

    WTitleTextColor:=0;
    WTitleTextBackGround:=7;
End;


Procedure SetNinthPixel;
Begin
    {Now we have to duplicate the ninth pixel of the character}

    Asm;
       mov dx,3C1h    {Read the Attribute Controller}
       {in  al,dx}
       mov ah,al

       mov dx,3dAh    {reset the internal flip flop}
       in  al,dx

       mov al,10h
       or  al,32      {inform Attr. Controller that is working normally}
       mov dx,3C0h
       out dx,al
       mov al,12      {8+4}
       out dx,al

    End;

End;

{**************************************************************************}
{Procedure InitVgaCard                                                     }
{âò§ú† initialize ©´û§ VGA                                                 }
{**************************************************************************}
Procedure InitVgaCard;
Begin

    SetCharWidth(8); {change character breadth in 8 pixel}

    IF DosFonts Then
    Begin
       ReadFontsByManual(SaveDosFont);
       UsePartFontsByManual(0,16,Elingr);
       UsePartFontsByManual(18,12,Elingr);
       UsePartFontsByManual(180,10,Elingr);
       UsePartFontsByManual(198,3,Elingr);
       UsePartFontsByManual(210,7,Elingr);
       UsePartFontsByManual(234,21,Elingr);
    End
    Else
    Begin
       ReadFontsByManual(SaveDosFont);
       UseFontsByManual(Elingr);
    End;

    VgaExist:=True;
    ButRevBckColor:=6;
    WindowFrame:=WinCharsWindow+WinChars;
    DisableColor:=7;
    PullDnTextBackGround:=6;
    PullDnTextColor:=0;
    StatLineTxtColor:=0;
    StatLineBckColor:=6;
    ReadRGBColors(DeskTopPalette);
    IF Monitor=Color Then
       ChangePalette(63,6)
    Else
    IF Monitor=BW Then
    Begin
       ChangePalette(63,6);
       Asm;
         mov ah,10h
         mov al,1bh
         mov bx,0
         mov cx,255
         int 10h
       End;
    End
    Else
    IF Monitor=LCD Then
    Begin
       Asm;
          mov ah,10h
          mov al,09h
          mov cx,Seg DefaultPalette
          mov es,cx
          mov dx,Offset DefaultPalette
          Int 10h

          mov ah,10h
          mov al,02h
          mov cx,Seg LCDPalette
          mov es,cx
          mov dx,Offset LCDPalette
          Int 10h
       End;
       MarkCharFgColor:=15;
       MarkCharBgColor:=0;
       MenuBoxSelectBckColor:=7;
    End;

    WTitleTextColor:=1;
    WTitleTextBackGround:=6;
End;

Procedure DeskTopHead(TxtColor,BckColor :Byte;Title :String);
Var
   I         :Byte;
   XOffset   :Byte;
Begin

    IF Title='' Then
       Exit;

    DeskTopHeadTitle:=Title;
    DeskTopHeadTxtColor:=TxtColor;
    DeskTopHeadBckColor:=BckColor;

    HiddenMouseCursor;

    For I:=1 to (BiosColumns div 2) do
       WriteChar(I,1,TxtColor,BckColor,32);

    WriteTextColor:=TxtColor;
    WriteTextBackGround:=BckColor;
    XOffset:=Round(((BiosColumns div 2)-Length(Title)) Div 2);
    WriteOut(XOffset,1,Title);

    ShowMouseCursor;
End;

Procedure ShowNewMode;
Var
   I    :Byte;
Begin

   SavePalette;
   ChangePalette(63,6);

   BiosColumns:=Mem[$0040:$004A];
   BiosColumns:=BiosColumns shl 1;
   BiosRows:=Mem[$0040:$0084]+1;

   BottomLine:=BiosRows;


   MakeBackGround(DeskTopTextColor,DeskTopBackGroundColor,DeskTopFillChar);

   For I:=1 to (BiosColumns div 2) do
   Begin
       WriteChar(I,ValidY1Coord,PullDnTextColor,PullDnTextBackGround,32);

       IF AllowHelpCtx then
          WriteChar(I,BiosRows,PullDnTextColor,PullDnTextBackGround,32);
   End;

   IF AllowHelpCtx=True Then
   Begin
       UnitScr.RestoreArea;
       UnitScr2.BY1:=BiosRows;
       UnitScr2.BY2:=BiosRows;
       UnitScr2.RestoreArea;
   End
   Else
     UnitScr.RestoreArea;

   ShowMouseCursor;

   DeskTopHead(DeskTopHeadTxtColor,DeskTopHeadBckColor,DeskTopHeadTitle);

   SetVirtCursorPosit(CurColumn,CurRow);
   SetCurLength(CurSScanL,CurEScanL);
{
   MoveX1Limit:=1;
   MoveY1Limit:=ValidY1Coord+1;
   MoveX2Limit:=BiosColumns div 2;
   MoveY2Limit:=BiosRows-1;
}
   MoveX1Limit:=1;
   MoveY1Limit:=1;
   MoveX2Limit:=255;
   MoveY2Limit:=255;

   SetWindowX2:=BiosColumns div 2;
   SetWindowY2:=BiosRows-1;

   MouseXMax:=((BiosColumns div 2)-1) * 8;
   MouseYMax:=(BiosRows-1) * 8;
End;

Procedure ContrastNewMode;
Begin
   IF MemAvail < 7000 Then
   Begin
       ErrorMessage('Not enough memory to change the current mode',BfOk);
       HeapErrorCode:=1;
       Exit;
   End;

   IF AllowHelpCtx=True Then
   Begin
     UnitScr.SaveArea(1,1,80,24);
     UnitScr2.SaveArea(1,BiosRows,80,BiosRows);
   End
   Else
     UnitScr.SaveArea(1,1,BiosColumns div 2,BiosRows);

    ReadCurPositHeight;

    CurX:=CurColumn;
    CurY:=CurRow;
    CurSScanL:=SScanL;
    CurEScanL:=EScanL;

    MakeBackGround(15,0,32);
End;

Procedure SetText80x25;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 then
   Begin
     SetVideoMode(3);
     InitVga8x16('C:\tp7\exe\gothic.syb',Ec);
     FontHeight:=16;
     VgaMouse:=True;
     ResetVgaMouse;
     SetMousePosition(1,1);
     MouseSensitivity(8,16);

     ShowNewMode;
   End;

   ShowMouseCursor;

End;

Procedure SetText80x30;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 then
   Begin
     SetVideoMode($50);
     InitVga8x16('C:\tp7\exe\gothic.syb',Ec);
     FontHeight:=16;
     VgaMouse:=True;
     ResetVgaMouse;
     SetMousePosition(1,1);
     MouseSensitivity(8,16);

     ShowNewMode;
   End;

   ShowMouseCursor;
End;

Procedure SetText80x43;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 Then
   Begin
     SetVideoMode($51);
     InitVga8x14('C:\tp7\exe\norm8x14.fnt',Ec);
     FontHeight:=11;
     VgaMouse:=False;
     SetMousePosition(1,1);
     MouseSensitivity(8,4);

     ShowNewMode;
   End;

   ShowMouseCursor;
End;

Procedure SetText80x60;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 then
   Begin
     SetVideoMode($52);
     InitVga8x8('C:\tp7\exe\norm8x8.fnt',Ec);
     FontHeight:=8;
     VgaMouse:=False;
     SetMousePosition(1,1);
     MouseSensitivity(8,4);

     ShowNewMode;
   End;

   ShowMouseCursor;
End;

Procedure SetText132x25;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 Then
   Begin
     SetVideoMode($53);
     InitVga8x14('C:\tp7\exe\norm8x14.fnt',Ec);
     FontHeight:=14;
     VgaMouse:=False;
     SetMousePosition(1,1);
     MouseSensitivity(4,4);

     ShowNewMode;
   End;

   ShowMouseCursor;
End;

Procedure SetText132x30;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 Then
   Begin
     SetVideoMode($54);
     InitVga8x16('C:\tp7\exe\gothic.syb',Ec);
     VgaMouse:=True;
     FontHeight:=16;
     ResetVgaMouse;
     SetMousePosition(1,1);
     MouseSensitivity(4,4);

     ShowNewMode;
   End;
   ShowMouseCursor;
End;

Procedure SetText132x43;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 Then
   Begin
     SetVideoMode($55);
     InitVga8x8('C:\tp7\exe\norm8x8.syb',Ec);
     VgaMouse:=False;
     FontHeight:=11;
     SetMousePosition(1,1);
     MouseSensitivity(4,4);

    ShowNewMode;
   End;

   ShowMouseCursor;
End;

Procedure SetText132x60;
Begin
   HiddenMouseCursor;

   ContrastNewMode;

   IF HeapErrorCode=0 Then
   Begin
     SetVideoMode($56);
     InitVga8x8('C:\tp7\exe\norm8x8.syb',Ec);
     VgaMouse:=False;
     FontHeight:=8;
     SetMousePosition(1,1);
     MouseSensitivity(4,4);

     ShowNewMode;
   End;
End;



{$F+}
Procedure WindowErrorMessage;
Begin
    ErrorMessage('Not enough memory to CREATE another'+#10+
                 'window.Close some others windows to free'+#10+
                 'some memory.',BfOk);
End;
{$F-}

{$F+}
Procedure MoveWinErrorMessage;
Begin
    ErrorMessage('Not enougth memory to MOVE your current'+#10+
                 'window.',BfOk);
End;
{$F-}

Function CriticalErrorMessage :String;
Var
   Message      :String;
   I            :Integer;
Begin
    Case CriticalErType of
        0:Message:='Disk is write protected. (Error Code = 0)';
        1:Message:='Unknown Unit. (Error Code = 1)';
        2:Message:='Device not ready. (Error Code = 2)';
        3:Message:='Unknown command. (Error Code = 3)';
        4:Message:='CRC error in data. (Error Code = 4)';
        5:Message:='Bad drive request structure. (Error Code = 5)';
        6:Message:='Seek error. (Error Code = 6)';
        7:Message:='Unknown media type. (Error Code = 7)';
        8:Message:='Sector not found. (Error Code = 8)';
        9:Message:='Printer out of paper. (Error Code = 9)';
       10:Message:='Write fault. (Error Code = 10)';
       11:Message:='Read fault. (Error Code = 11)';
       12:Message:='General failure. (Error Code = 12)';
       15:Message:='Invalid disk change. (Error Code = 15)';
          Else
             Message:='UnKnown error code.';
    End;

    CriticalErrorMessage:=Message;
    CriticalError:=0;
    I:=IOResult;

End;

{********************************************************************}
{Procedure ShowCriticalErrorWin                                      }
{IT opens up an error window with the CriticalErrorMessage within and}
{the coresponding buttons (Retry-Ignore-Fail-Ok).                    }
{********************************************************************}

Procedure ShowCriticalErrorWin;
Var
   Message      :String;
   Button       :Byte;
   I            :Integer;
Begin

    I:=IOResult;
    Button:=0;

    IF (CriticalInfo and Retry) = Retry Then
       Button:=BfRetry;

    IF (CriticalInfo and Ignore) = Ignore Then
       Button:=Button+BfIgnore;

    IF (CriticalInfo and Fail) = Fail Then
       Button:=Button+BfFail;

    IF Button = 0 Then
       Button:=BfOk;

    ErrorMessage(CriticalErrorMessage,Button);

    IF IOResult <> 0 Then
       CriticalError:=IOResult;

    CriticalError:=0;

End;

{*************************************************************************}
{TDosErrorMessage                                                         }
{They are the DOS error code reported from Turbo Pascal.                  }
{They are the codes returned from IOResult.                               }
{*************************************************************************}

Function TDosErrorMessage(DosErrorType :Integer) :String;
Var
   Message      :String;
   S            :String;
Begin
    Case DosErrorType of
        1:Message:='Invalid function number. (Error Code = 1)';
        2:Message:='File not Found. (Error Code = 2)';
        3:Message:='Path not Found. (Error Code = 3)';
        4:Message:='Too many open files. (Error Code = 4)';
        5:Message:='File access denied. (Error Code = 5)';
        6:Message:='Invalid file handle. (Error Code = 6)';
        8:Message:='Not enough memory. (Error Code = 8)';
       10:Message:='Invalid environment. (Error Code = 10)';
       11:Message:='Invalid Format. (Error Code = 11)';
       12:Message:='Invalid file access code. (Error Code = 12)';
       15:Message:='Invalid drive number. (Error Code = 15)';
       16:Message:='Cannot remove current directory. (Error Code = 16)';
       17:Message:='Cannot rename across drives. (Error Code = 17)';
       18:Message:='No more files. (Error Code = 18)';
      100:Message:='Disk read error (Error Code = 100)';
      101 :Message:='Disk write error (Error Code = 101)';
      102 :Message:='File not assigned (Error Code = 102)';
      103 :Message:='File not open (Error Code = 103)';
      104 :Message:='File not open for input (Error Code = 104)';
      105 :Message:='File not open for output (Error Code = 105)';
      106 :Message:='Invalid numeric format (Error Code = 106)';
      150 :Message:='Disk is write-protected (Error Code = 150)';
      151 :Message:='Bad drive request struct length (Error Code = 151)';
      152 :Message:='Drive not ready (Error Code = 152)';
      154 :Message:='CRC error in data (Error Code = 154)';
      156 :Message:='Disk seek error (Error Code = 156)';
      157 :Message:='Unknown media type (Error Code = 157)';
      158 :Message:='Sector Not Found (Error Code = 158)';
      159 :Message:='Printer out of paper (Error Code = 159)';
      160 :Message:='Device write fault (Error Code = 160)';
      161 :Message:='Device read fault (Error Code = 161)';
      162 :Message:='Hardware failure (Error Code = 162)';
      200 :Message:='Division by zero (Error Code = 200)';
      201 :Message:='Range check error (Error Code = 201)';
      202 :Message:='Stack overflow error (Error Code = 202)';
      203 :Message:='Heap overflow error (Error Code = 203)';
      204 :Message:='Invalid pointer operation (Error Code = 204)';
      205 :Message:='Floating point overflow (Error Code = 205)';
      206 :Message:='Floating point underflow (Error Code = 206)';
      207 :Message:='Invalid floating point operation (Error Code = 207)';
      208 :Message:='Overlay manager not installed (Error Code = 208)';
      209 :Message:='Overlay file read error (Error Code = 209)';
      210 :Message:='Object not initialized (Error Code = 210)';
      211 :Message:='Call to abstract method (Error Code = 211)';
      212 :Message:='Stream registration error (Error Code = 212)';
      213 :Message:='Collection index out of range (Error Code = 213)';
      214 :Message:='Collection overflow error (Error Code = 214)';
      215 :Message:='Arithmetic overflow error (Error Code = 215)';
      216 :Message:='General Protection fault (Error Code = 216)';
         Else
         Begin
           Str(DosErrorType,S);
           Message:='UnKnown error code. (Error Code ='+S+')';
         End;
    End;

    TDosErrorMessage:=Message;
End;


{***************************************************************************}
{Procedure InitErrorMem                                                     }
{âò§¶¨£ú °ò´ò§¶£û £§û£û™ ©´û§ ò®Æû ú´©† ‡©´ú §ò úÆ¶¨£ú Æ‡®¶ ö†ò ´¶ ßò®òü¨®¶ }
{¢òü‡§.                                                                     }
{***************************************************************************}

Procedure InitErrorMem;
Var
   I               :Byte;
   TBut            :Button;
   WinSize         :Word;
   XSize,YSize     :Byte;
Begin

   {è®‡´ò ß®¶©õ†¶®†ù¶¨£ú ´†™ Far procedures                             }

   ErrorWinFarCallPtr:=@WindowErrorMessage;
   ErrorMoveFarCallPtr:=@MoveWinErrorMessage;

    New(ErrorWin);

    XSize:=(80-1)+1;
    XSize:=XSize*2;
    YSize:=(25-1)+1;
    WinSize:=YSize * XSize;

    ErrorWin^.WinSize:=WinSize;
    ErrorWin^.BX1:=1;ErrorWin^.BY1:=1;
    ErrorWin^.BX2:=80;ErrorWin^.BY2:=25;
    ErrorWin^.CloseCommand:=0;

    GetMem(ErrorWin^.SnapShot,WinSize);
    Win:=ErrorWin;

    Win^.HeadMenusSeq:=Nil;
    Win^.CurMenusSeq:=Nil;
    Win^.TailMenusSeq:=Nil;

    TBut.InitButton(OkStr    ,ReservedCmOk,PushButton,BfNormal);
    TBut.InitButton(CancelStr,ReservedCmCancel,PushButton,BfNormal);
    TBut.InitButton(IgnoreStr,ReservedCmIgnore,PushButton,BfNormal);
    TBut.InitButton(RetryStr ,ReservedCmRetry,PushButton,BfNormal);
    TBut.InitButton(FailStr  ,ReservedCmFail,PushButton,BfNormal);

    Win:=Nil;
End;

{***************************************************************************}
{Procedure DoneErrorMem                                                     }
{Dispose ErrorMem variable.                                                 }
{***************************************************************************}

Procedure DoneErrorMem;
Var
   I    :Byte;
Begin

    ErrorWinFarCallPtr:=Nil;
    ErrorMoveFarCallPtr:=Nil;

    Win:=ErrorWin;
    Win^.CurMenusSeq:=Win^.HeadMenusSeq;

    For I:=1 to 5 do
    Begin
        Win^.HeadMenusSeq:=Win^.CurMenusSeq^.Next;
        TButton:=Win^.CurMenusSeq^.NodePtr;
        Dispose(TButton);
        Dispose(Win^.CurMenusSeq);
        Win^.CurMenusSeq:=Win^.HeadMenusSeq;
    End;

    Win^.HeadMenusSeq:=Nil;
    Win^.CurMenusSeq:=Nil;
    Win^.TailMenusSeq:=Nil;

    FreeMem(ErrorWin^.SnapShot,ErrorWin^.WinSize);
    Dispose(ErrorWin);
End;


Procedure SetBlankNinthPixel;
Begin
      {Set Blank the ninth pixel of the character matrix}

      Asm;
       mov dx,3C1h    {Read the Attribute Controller}
       {in  al,dx}    {Never combine internal reset and Read Attribute}
       mov ah,al

       mov dx,3dAh    {reset the internal flip flop}
       in  al,dx


       mov al,10h
       or  al,32      {inform Attr. Controller that is working normally}
       mov dx,3C0h
       out dx,al
       mov al,8
       out dx,al
      End;
End;


{**************************************************************************}
{Procedure CloseVgaCars                                                    }
{Ñßò§ò≠ú®ú† ´¶ ©¨©´û£ò ©´û§ ß®¶ûö¶¨£ú§û °ò´ò©´ò©û                          }
{**************************************************************************}

Procedure CloseVgaCard;
Begin
    IF VgaExist=True Then
    Begin
      BiosColumns:=TextMaxX shl 1;
      BiosRows:=TextMaxY;

      IF Monitor = LCD Then
      Begin
         Asm;
             mov ah,10h
             mov al,02h
             mov cx,Seg DefaultPalette
             mov es,cx
             mov dx,Offset DefaultPalette
             Int 10h
         End;
      End;
      SetRGBColors(DeskTopPalette);
      SetCharWidth(9);
    End;
End;

Procedure InitApplication;
Begin
    SavePic('First',Ec);
End;

Procedure DoneApplication;
Begin
    HiddenMouseCursor;
    Fx7;
    ShowMouseCursor;
    DisposePics;
End;

{*************************************************************************}
{Constructor Init                                                         }
{Initialize the System.The main procedure which a programmer must call    }
{in the beginning of the program.It's constructor because it must         }
{initialize all virtual methods.                                          }
{*************************************************************************}

Constructor Application.Init;
Var
    TView        :View;
    TPullDnMenu  :PullDownObj;
Begin

    WriteTextColor:=7;
    WriteTextBackGround:=0;

    IF DosVer5 = False Then
    Begin
        TextColor(7);TextBackGround(0);
        Clrscr;
        WriteOut(1,1,'Sorry you need Dos 5.00 or above to run this program.');
        Halt(0);
    End;

    IF ExclusiveVga Then
    Begin
        IF IsVga=False Then
        Begin
           TextColor(7);TextBackGround(0);
           Clrscr;
           WriteOut(1,1,'Sorry you need a VGA video card to run this program.');
           Halt(0);
        End;
    End;

    IF Round(MemAvail/1024) < 200 Then
    Begin
        TextColor(7);TextBackGround(0);
        Clrscr;
        WriteOut(1,1,'Sorry you need at least 450Kb to run this program.');
        Halt(0);
    End;


    ReadVideoStatus;
    MsDosScreenPage:=CurrentPage;
    ReadCurPositHeight;
    MsDosX:=CurColumn;
    MsDosY:=CurRow;
    MsDosSScanL:=SScanL;
    MsDosEScanL:=EScanL;
    MsDosScreenPage:=ScreenPage;

    IF DosFonts = False Then
       SavePic('First',Ec);



    {Ñò§ Hercules û MDA ´¶´ú ú¢ò úõ‡}

    IF (Mem[$0040:$0063]=$3B4) or (Mem[$0040:$0049]=7) Then
    Begin
       VgaFonts:=False;
       VideoSeg:=$B000;
       SetVideoMode(7);
       InitMonoCard;
    End
    Else
    {Ñò§ Vga ´¶´ú ú¢ò úõ‡}

    IF (IsVga=True) And (VgaFonts=True) {And (MicroSoftWindows=False)} Then
    Begin
       InitVgaCard;
       VgaMouse:=True;
    End
    Else
    Begin
       {Ä¢¢†‡™ EGA,CGA ú¢ò úõ‡}
       VgaFonts:=False;
       InitColorCard;
    End;



    CurOff;          {TextCursor OFF}
    InitErrorMem;    {Space for errors}
    DoneWinObjFarCallPtr:=@DoneWindowObjects;
    MouseInit;       {Start Mouse}
    InitKeybBuffer;  {Initialize KeyBoard Buffer}
    InternalHandlePtr:=@InternalHandleCommand;


    {-------------- Set Interrupt Handlers --------------------------}

    GetIntVec($16,OldInt16); {Save old interrup 16h}
    GetIntVec($1B,OldInt1B); {Save old interrupt 1Bh}
    GetIntVec($23,OldInt23); {Save old interrupt 23h}
    GetIntVec($9,OldInt9);   {Save Old Interrupt 9h}
    GetIntVec($24,OldInt24); {Save old Interrupt 24h}

    InitNewInt16_NewInt9_Asm; {Call assembly (.OBJ) for new int handler}
    SetIntVec($1B,@NewInt1B);{New interrupt handler for 1Bh}
    SetIntVec($23,@NewInt23);{New interrupt handler for 23h}
    InitNewInt24_Asm; {Call assembly (.Obj) for new int handler}

    {----------------------- Make the rest work ---------------------------}


    IF SetBackGround Then
       MakeBackGround(DeskTopTextColor,DeskTopBackGroundColor,DeskTopFillChar);

    ShowMouseCursor; {Show Mouse Text Cursor}
    InitPD;          {Init Pull Down Menus}
    InitMenuBar;     {Take parametres (Virtual Method)}
    DrawPDMenus;     {Show up in to the Screen}
    SetPreferences;
End;


{**********************************************************************}
{Procedure Application.RunHelp                                         }
{Check for Help event.                                                 }
{**********************************************************************}
Procedure Application.RunHelp;
Var
   ScanCode     :Word;
Begin

   ScanCode:=(KbScanCode shl 8) OR KbAsciiCode;

   IF ((ScanCode = HelpHotKey) Or (MouseButton = msRight))  AND (HelpWindowIsNotOpen = True)
           AND (ActiveErrorWindow = False) And (AllowDiskHelp = True) Then
       {Not open help window if PD menus are active and the right mouse}
       {button is true 'cos we use it for the closing procedure}

       IF  (PDActive=True) and  (MouseButton = msRight) Then
       Begin
           {Do nothing and go to the PDHandleEvent to Close the}
           {sub windows of the pull down menu.                 }
       End
       Else
           OpenHelpContext;
End;

{***************************************************************************}
{Procedure Run.                                                             }
{The Body of the program.It controlls everything.                           }
{***************************************************************************}
Procedure Application.Run;
Var
   CloseIconString      :String[4];
   ScanCode             :Word;
   IconSize             :Byte;
   T                    :View;
Begin
   CriticalError:=0;

   Repeat
       WaitForEvent;
       ScanCode:=(KbScanCode shl 8) OR KbAsciiCode;

       {Check if HelpHotKey was pressed}
       RunHelp;

       {Check Pull down menu event}
       PDHandleEvent;

       IF (Win<>Nil) Then
       Begin

         {Check to see if we have for the current window Close Icon}
         {We need the Var. IconSize for mouse moving window section}

         IF (Win^.Params and CloseIcon) = CloseIcon Then
            IconSize:=3
         Else
            IconSize:=0;

         {Enter Command}
         IF (Ctrl=#13) and (DoCheckEveryThing) and (Win^.EnterCommand <> 0)
          and (Win^.CurMenusSeq^.IDByte <> Buttons) Then
         Begin
             IF Win^.EnterCommand<>0 Then
             Begin
                Event:=Win^.EnterCommand;
                IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
                   InternalHandleCommand
                Else
                   HandleCommand;
                ClearEvent;
             End
             Else
             Begin
                IF ActiveErrorWindow=True Then
                   InternalHandleCommand;
                ClearEvent;
             End
         End
         Else
         {Close Command}
         IF ( (Win^.Params and CloseIcon) = CloseIcon ) AND ( (Ctrl=#27) or ( (MsLeftDoubleClick=True)
             and (MouseX in [Win^.X1..Win^.X1+2]) and (MouseY = Win^.Y1) ) )
              AND (DoCheckEveryThing) Then
         Begin
             {CHECK FOR DOUBLE CLICK ONTO CLOSEICON}

             MsLeftDoubleClick:=False;

             {Last time canceling                                       }

             IF Event=1 {Mouse} Then
             Begin
                Repeat
                Until MouseButton=msIdle;
                IF (MouseX in [Win^.X1..Win^.X1+2]) and (MouseY = Win^.Y1) Then
                  ClearEvent
                Else
                Begin
                    ClearEvent;
                    Exit;
                End;
             End;

             IF (Win^.Params and WinChars) = WinChars Then
                 CloseIconString:=Chr(WCCloseIcon1)+Chr(WCCloseIcon2)
             Else
                 CloseIconString:=Chr(SCCloseIcon1)+Chr(SCCloseIcon2)+Chr(SCCloseIcon3);

             WriteTextColor:=15;
             WriteTextBackGround:=2;
             WriteVirtWinOut(Win^.X1,Win^.Y1,CloseIconString);

             Delay(100);

             IF Win^.CloseCommand<>0 Then
             Begin
                Event:=Win^.CloseCommand;
                IF (Event >= ReservedCmStart) and (Event <= ReservedCmEnd) Then
                   InternalHandleCommand
                Else
                   HandleCommand;
                ClearEvent;
             End
             Else
             Begin
                IF ActiveErrorWindow=True Then
                   InternalHandleCommand
                Else
                   CloseWindow;
                ClearEvent;
             End
         End
         Else
         IF ( ( ((Win^.Params and Movement) = Movement ) and (MouseButton=MsLeft) and
              (MouseX in [Win^.X1+IconSize..Win^.X2]) and (MouseY = Win^.Y1))
              OR (ScanCode = MoveWindowHotKey) ) AND (DoCheckEveryThing) Then
              {CHECK FOR WINDOW MOVE}
              IF MouseButton = msLeft Then
                 MoveMsWin
              Else
                 MoveWindow
         Else
         Begin
           {CHECK FOR BROADCAST EVENT}
           IF (DoCheckEveryThing) Then
               WindowBroadCastEvent;
           IF (PDActive=False) Or (HelpWindowIsNotOpen = False) Or (ActiveErrorWindow) Then
              WinHandleEvent;
         End;
       End;

       IF (WindowCounter=0) and (PDActive=False) Then
       Begin
           CurrentHelpPtr:=0;
           T.ShowHelpCtx(InitHelpCtx);
       End;

       Repeat
       Until MouseButton=MsIDle;


   Until (ExitFromProgram=True);
End;

{*************************************************************************}
{Destructor Done                                                          }
{DeInit system varibles and DeAllocate everything that allocated Before.  }
{It's Definitelly the Tail of The Program.Just return to Dos or whatever..}
{*************************************************************************}

Destructor Application.Done;
Var
   TPullDnMenu  :PullDownObj;
   TView        :View;
Begin
    HiddenMouseCursor;
    DoneErrorMem;
    DonePD;
    ShowClock:=False;
    MouseDone;

    SetIntVec($9,OldInt9);
    SetIntVec($16,OldInt16);
    SetIntVec($1B,OldInt1B);
    SetIntVec($23,OldInt23);
    SetIntVec($24,OldInt24);

    IF DosFonts = False Then
    Begin
      Fx7;
      DisposePics;
    End;

    CloseVgaCard;
    IF (DosFonts) and (VgaExist) Then
        UseFontsByManual(SaveDosFont)
    Else
    IF VgaExist Then
       UseFontsByManual(SaveDosFont);

    SetVideoPage(MsDosScreenPage);
    SetCurLength(MsDosSScanL,MsDosEScanL);
    SetCurPositionXY(MsDosX,MsDosY);
End;



Begin


End.