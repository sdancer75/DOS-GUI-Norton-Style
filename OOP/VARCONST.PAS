{**************************************************************************}
{UNIT VarConstObj                                                          }
{FileName      :VarConst.Pas                                               }
{èú®†úÆú† ¶¢ú™ ´†™ öú§†°ú™ £ú´òô¢û´ú™ ß¶¨ Æ®û©†£¶ß¶†¶¨§´ò† ©ú ¶ß¶†òõûß¶´ú  }
{ú≠ò®£¶öû.                                                                 }
{**************************************************************************}




UNIT VARCONSTOBJ;

INTERFACE

Uses Dos,Crt,ErrorDlg;

Type
    FontData = Array [1..4080] of Byte;

    {It loaded from The WindowBroadCastEvent procedure in the WinInit unit}
    {and it used from all Keyboard events from all objects.               }

    CtrlStruc = Record
       Address       :Pointer; {Precalculated address from the WindowBroad}
       Ctrl,Ascii    :Char;    {CastEvent and the Ctrl-Ascii Character.}
    End;

Const
    CtrlPressed                   :CtrlStruc =
                                        (Address:Nil;Ctrl:#0;Ascii:#0);
    {The Main Variable.All Keyboard}
    {handle procedures are depending from this Variable.If The Address=Nil}
    {then no BroadCast enent has occured.}

    VideoSeg                      :Word =$B800;
    SystemDelay                   :Word =0; {For Interrupt 1Ch}

    {******** Clocks Variables ***********************}

    ShowClock                     :Boolean = False;
    Ticks                         :Byte    = 0;
    Seconds                       :Word    = 0;
    Minutes                       :Word    = 0;
    Hours                         :Word    = 0;
    ClockX                        :Byte    = 1;
    ClockY                        :Byte    = 1;
    ClockTxtColor                 :Byte    = 15;
    ClockBckColor                 :Byte    = 0;

    {*************************************************}


    Movement                      = 1;
    Shadow                        = 2;
    OpenFx                        = 4;
    CloseFx                       = 8;
    WinChars                      = 16;
    WinCharsWindow                = 32;
    OptionChars                   = 64;
    StandardChars                 = 128;
    OverLap                       = 256;
    CloseIcon                     = 512;
    SizeIcon                      = 1024;
    ZoomIcon                      = 2048;

    StandardWindow                = 1+2+4+8+16+32+512;{Move+Shadow+WinCharsWindow}
    OptionWindow                  = 2+64;             {Shadow+OptionChars  }

    {Win Chars Draw Lines}

    WCUpHorLine                  :Byte = 212;
    WCDnHorLine                  :Byte = 248;
    WCLfVerLine                  :Byte = 1;
    WCRgVerLine                  :Byte = 2;
    WCDnRgCorner                 :Byte = 4;
    WCDnLfCorner                 :Byte = 3;
    WCUpRgCorner                 :Byte = 6;
    WCUpLfCorner                 :Byte = 5;

    WCCheckBoxLB                 :Byte = 15;
    WCEmptyCheckBox              :Byte = 9;
    WCCheckBoxRB                 :Byte = 210;
    WCMarkCheckBox               :Byte = 28;

    WCRadioButRB                 :Byte = 245;
    WCEmptyRadioBut              :Byte = 246;
    WCRadioButLB                 :Byte = 13;
    WCMarkRadioBut               :Byte = 14;

    WCUpArrow1                   :Byte = 21;
    WCUpArrow2                   :Byte = 22;
    WCDownArrow1                 :Byte = 23;
    WCDownArrow2                 :Byte = 11;
    WCLeftArrow                  :Byte = 210;
    WCRightArrow                 :Byte = 212;

    WCScrLineFillChar1           :Byte = 10;
    WCScrLineFillChar2           :Byte = 18;
    WCScrLinePointer1            :Byte = 19;
    WCScrLinePointer2            :Byte = 20;

    WCUpHorLineS                 :Byte = 182;
    WCDnHorLineS                 :Byte = 183;
    WCLfVerLineS                 :Byte = 180;
    WCRgVerLineS                 :Byte = 181;
    WCDnRgCornerS                :Byte = 185;
    WCDnLfCornerS                :Byte = 184;
    WCUpRgCornerS                :Byte = 189;
    WCUpLfCornerS                :Byte = 188;

    WCCloseIcon1                 :Byte = 29;
    WCCloseIcon2                 :Byte = 211;

    WCInputLineFillChar          :Byte = 250;
    WCCheckIcon                  :Byte = 251;
    WCLeftPoint                  :Byte = 252;
    WCRightPoint                 :Byte = 253;
    WCNoticeIcon                 :Byte = 7;

    WCDriveC1                    :Byte = 198;
    WCDriveC2                    :Byte = 199;
    WCDriveC3                    :Byte = 200;
    WCDriveA1                    :Byte = 214;
    WCDriveA2                    :Byte = 215;
    WCDriveA3                    :Byte = 216;
    WCDirectory1                 :Byte = 234;
    WCDirectory2                 :Byte = 235;
    WCExeFile1                   :Byte = 236;
    WCExeFile2                   :Byte = 237;
    WCFile1                      :Byte = 238;
    WCFile2                      :Byte = 239;



    {Options Chars Draw Lines}

    OCUpHorLine                  :Byte = 180;
    OCDnHorLine                  :Byte = 181;
    OCLfVerLine                  :Byte = 182;
    OCRgVerLine                  :Byte = 183;
    OCDnRgCorner                 :Byte = 185;
    OCDnLfCorner                 :Byte = 184;
    OCUpRgCorner                 :Byte = 189;
    OCUpLfCorner                 :Byte = 188;

    {Standard Chars Draw Lines}

    SCUpHorLine                  :Byte = 196;
    SCDnHorLine                  :Byte = 196;
    SCLfVerLine                  :Byte = 179;
    SCRgVerLine                  :Byte = 179;
    SCDnRgCorner                 :Byte = 217;
    SCDnLfCorner                 :Byte = 192;
    SCUpRgCorner                 :Byte = 191;
    SCUpLfCorner                 :Byte = 218;

    SCCheckBoxLB                 :Byte = 91;
    SCEmptyCheckBox              :Byte = 32;
    SCCheckBoxRB                 :Byte = 93;
    SCMarkCheckBox               :Byte = 88;

    SCRadioButLB                 :Byte = 40;
    SCEmptyRadioBut              :Byte = 32;
    SCRadioButRB                 :Byte = 41;
    SCMarkRadioBut               :Byte = 7;

    SCUpArrow                    :Byte = 30;
    SCDownArrow                  :Byte = 31;
    SCLeftArrow                  :Byte = 17;
    SCRightArrow                 :Byte = 16;

    SCScrLineFillChar            :Byte = 178;
    SCScrLinePointer             :Byte = 254;

    SCCloseIcon1                 :Byte = 91;
    SCCloseIcon2                 :Byte = 42;
    SCCloseIcon3                 :Byte = 93;

    SCInputLineFillChar          :Byte = 46;
    SCCheckIcon                  :Byte = 251;
    SCLeftPoint                  :Byte = 27;
    SCRightPoint                 :Byte = 26;
    SCNoticeIcon                 :Byte = 254;

   {*****************************************}

    WindowCounter                :Byte = 0;
    TopWindow                    :Byte = 0;
    MaxWindows                         = 255;

    WinTextColor                 :Byte = 15;
    WinTextBackground            :Byte = 0;

    SetWindowX1                  :Byte = 1;
    SetWindowY1                  :Byte = 1;
    SetWindowX2                  :Byte = 80;
    SetWindowY2                  :Byte = 25;

    MoveX1Limit                  :Word = 1;
    MoveX2Limit                  :Word = 78;
    MoveY1Limit                  :Word = 1;
    MoveY2Limit                  :Word = 25;
    MoveColor                    :Byte = 2;

    ValidY1Coord                 :Byte = 2;

    NortonStyle                  :Byte = 1;
    InStyle                      :Byte = 2;
    OutStyle                     :Byte = 3;
    WindowStyle                  :Byte = 4;

    NotActiveColorFrame          :Byte = 7;
    PDRevBckColor                :Byte = 0;
    PDRevTxtColor                :Byte = 15;
    PDSpace                      :Byte = 2;
    PDActive                     :Boolean = False;
    PDNotOpen                    :Boolean = True;

    PDLineFill                         = 196;
    PDCheckSyb                         = 251;
    PDMoreSub                          = 16;



    KbF1                               =$3b00;
    KbF2                               =$3c00;
    KbF3                               =$3d00;
    KbF4                               =$3e00;
    KbF5                               =$3f00;
    KbF6                               =$4000;
    KbF7                               =$4100;
    KFF8                               =$4200;
    KbF9                               =$4300;
    KbF10                              =$4400;

    KbQ                                =$1000;
    KbW                                =$1100;
    KbE                                =$1200;
    KbR                                =$1300;
    KbT                                =$1400;
    KbY                                =$1500;
    KbU                                =$1600;
    KbI                                =$1700;
    KbO                                =$1800;
    KbP                                =$1900;
    KbA                                =$1e00;
    KbS                                =$1f00;
    KbD                                =$2000;
    KbF                                =$2100;
    KbG                                =$2200;
    KbH                                =$2300;
    KbJ                                =$2400;
    KbK                                =$2500;
    KbL                                =$2600;
    KbZ                                =$2c00;
    KbX                                =$2d00;
    KbC                                =$2e00;
    KbV                                =$2f00;
    KbB                                =$3000;
    KbN                                =$3100;
    KbM                                =$3200;

    KbAltF1                            =$6800;
    KbAltF2                            =$6900;
    KbAltF3                            =$6a00;
    KbAltF4                            =$6b00;
    KbAltF5                            =$6c00;
    KbAltF6                            =$6d00;
    KbAltF7                            =$6e00;
    KbAltF8                            =$6f00;
    KbAltF9                            =$7000;
    KbAltF10                           =$7100;

    KbCtrlF1                           =$5e00;
    KbCtrlF2                           =$5f00;
    KbCtrlF3                           =$6000;
    KbCtrlF4                           =$6100;
    KbCtrlF5                           =$6200;
    KbCtrlF6                           =$6300;
    KbCtrlF7                           =$6400;
    KbCtrlF8                           =$6500;
    KbCtrlF9                           =$6600;
    KbCtrlF10                          =$6700;

    KbShiftF1                          =$5400;
    KbShiftF2                          =$5500;
    KbShiftF3                          =$5600;
    KbShiftF4                          =$5700;
    KbShiftF5                          =$5800;
    KbShiftF6                          =$5900;
    KbShiftF7                          =$5a00;
    KbShiftF8                          =$5b00;
    KbShiftF9                          =$5c00;
    KbShiftF10                         =$5d00;

    KbAltQ                             =$1000;
    KbAltW                             =$1100;
    KbAltE                             =$1200;
    KbAltR                             =$1300;
    KbAltT                             =$1400;
    KbAltY                             =$1500;
    KbAltU                             =$1600;
    KbAltI                             =$1700;
    KbAltO                             =$1800;
    KbAltP                             =$1900;
    KbAltA                             =$1e00;
    KbAltS                             =$1f00;
    KbAltD                             =$2000;
    KbAltF                             =$2100;
    KbAltG                             =$2200;
    KbAltH                             =$2300;
    KbAltJ                             =$2400;
    KbAltK                             =$2500;
    KbAltL                             =$2600;
    KbAltZ                             =$2c00;
    KbAltX                             =$2d00;
    KbAltC                             =$2e00;
    KbAltV                             =$2f00;
    KbAltB                             =$3000;
    KbAltN                             =$3100;
    KbAltM                             =$3200;


    KbShiftDel                         =$0700;
    KbShiftIns                         =$0500;

    KbCtrlDel                          =$0600;
    KbCtrlIns                          =$0400;

    AsciiScanArray               :Array [1..26] Of Byte =
       ( $1e,$30,$2e,$20,$12,$21,$22,$23,$17,$24,$25,$26,$32,
         $31,$18,$19,$10,$13,$1f,$14,$16,$2f,$11,$2d,$15,$2c  );

    {****************************************************************}
    {èú®†úÆú† ´¶¨™ ú¢¢û§†°¶¨™ °‡õ†°¶¨™ ò§†Æ§ú¨©û™ òß¶ ´¶ Ä £úÆ®† ´¶  }
    {ó ©ú ©¨§õ†ò©£¶ £ú ´û ß¢û°´®¶ Alt.é 26¶™ °‡õ†°¶™ ú†§ò† ö†ò ´¶    }
    {£†°®¶ ´ú¢†°¶ ú¢¢û§†°¶ "™".                                      }
    {****************************************************************}

    AsciiGrScanArray             :Array [1..25] Of Byte =
       ($1e,$30,$22,$20,$12,$2c,$23,$16,$17,$25,$26,$32,$31,$24,
        $18,$19,$13,$1f,$14,$15,$21,$2d,$2e,$2f,$11);

   {èú®†úÆú† ´¶¨™ ú¢¢û§†°¶¨™ °‡õ†°¶¨™ ß¶¨ ßò†®§¶¨£ú ¶´ò§ ßò´û©¶¨£ú ´¶}
   {Ctrl-<Char> ¶ß¶¨ Char ú§ò™ Æò®ò°´û®ò™.é ß†§ò°ò™ ßò®ò°ò´‡ ßú®†úÆú†}
   {£¶§¶ ´¶¨™ ú¢¢û§†°¶¨™ Æò®ò°´û®ú™ ò®Æ†ù¶§´ò™ òß¶ ´¶ Ä..ó.é 25¶™    }
   {Æò®ò°´û®ò™ ò§´†©´¶†Æú† ©´¶ ú¢¢û§†°¶ £†°®¶ ´ú¢†°¶ <™>.Ç†ò ´¶¨™    }
   {òöö¢†°¶¨™ Æò®ò°´û®ú™ õú§ ¨ßò®Æú† ß®¶ô¢û£ò £†ò °ò† ´¶ A=1,B=2,C=3.}

    CtrlvsGreeks                 :Array [1..25] Of Byte =
       (1,2,7,4,5,26,8,21,9,11,12,13,14,10,15,16,18,19,20,25,6,24,3,22,23);

    MarkCharFgColor              :Byte = 12;
    MarkCharBgColor              :Byte = $FF;
    DisableColor                 :Byte = 7;
    NoHelp                       :Word = 0;

    Event                        :Word = 0;

    StatLineMaxChars             :Byte = 80;
    StatLineStartChar            :Byte = 2;
    StatLineTxtColor             :Byte = 0;
    StatLineBckColor             :Byte = 6;

    BottomLine                   :Byte = 25;
    InitHelpCtx                  :String[80] ='';     {í¶ ò®Æ†°¶ £¨§û£ò °®ò´†ú´ò† úõ‡}
    AllowHelpCtx                 :Boolean = False;
    MoveHelpCtx                  :String[80] = 'Moving Current Window....';
    MenusCheckerOnOff            :Boolean = False;
    AccessPDMenus                :Boolean = False;   {Ñò§ ú†§ò† True úÆ¶¨£ú ß®¶©ßú¢ò©û ò¢¢†‡™ ¶Æ†}
    PullDownCurrentHelpCtx       :String  = '';


    DeskTopHeadTitle             :String = '';
    DeskTopHeadTxtColor          :Byte   = 15;
    DeskTopHeadBckColor          :Byte   = 3;

    BiosColumns                  :Word   = 160;
    BiosRows                     :Byte   = 25;

    {*************** Critical Errors Variables ****************}
    {Note :  They Returned from ah register oh int 24h         }

    Fail                                 = 8;
    Retry                                = 16;
    Ignore                               = 32;

    SysErr                               = 0;
    FatErr                               = 1;
    DirErr                               = 2;
    DatErr                               = 3;

    ReadOrWriteErr                       = 1;

    DiskOrDeviceErr                      = 128;

    CriticalError                  :Integer = 0;    {1 = Error ,0 = No Error}
    CriticalErType                 :Word = 0;    {Error Code             }
    CriticalInfo                   :Word = 0;    {Error Detection Form AH (For internal use)}

  {******************* HELP SECTION ******************************}

  HelpHotKey           :Word    = KBF1;
  HelpWindowIsNotOpen  :Boolean = True;
  CurrentHelpPtr       :Word    = 0;
  AllowDiskHelp        :Boolean = False;


  {******************** MOVE SECTION ******************************}

  MoveWindowHotKey     :Word    = KbCtrlF5;

Type
    Str255      = String[255];
    Str80       = String[80];
    Str40       = String[40];
    Str10       = String[10];

    PStr255     = ^Str255;
    PStr80      = ^Str80;
    PStr40      = ^Str40;
    PStr10      = ^Str10;

    PScreenImage= ^ScreenImage;
    ScreenImage = Array [0..3999] of Byte;
    MaskImage   = Array [0..1999] of Byte;

    WinCoord = Record
        X1,Y1,X2,Y2 :Byte;
    End;


   PDynText = ^DynText;
   DynText  = Record
       TextLine        :PStr255;
       TLineColor,
       TLineBackGround :Byte;
       NextTextLine    :PDynText;
       PrevTextLine    :PDynText;
   End;

   PLinkStr = ^LinkStr;
   LinkStr  = Record
       TextLine        :PStr255;
       NodeNum         :Word;
       TLineColor,
       TLineBackGround :Byte;
       ExtraFunc       :Pointer;
       NextTextLine    :PLinkStr;
       PrevTextLine    :PLinkStr;
   End;

   {It used for dynamic link to link string functions}

   LinkText     = Object
      HeadText,             {The head of the allocated link}
      TailText,             {The end  of the allocated link}
      Text                 :PLinkStr; {The Current Text of the link}
      Edge                 :Boolean;  {It's True whenever the Text=HeadText}
                                      {or Text=TailText else it's False}
                                      {After all the inserts the Egde:=True}

      Procedure InitText;                    {Initialize Pointers}
      Procedure InsertText(InText:String;TColor,TBackGround :Byte);   {Insert new text}
      Procedure FindNodeNum(Num :Word);      {find text by searching the serial number}
      Procedure FindText(Str :String);        {find text with the actual string}
      Procedure DeleteText;           {Deletes the Current Text}
      Procedure NextText;             {move current pointer on the next node}
      Procedure PrevText;             {move current pointer on the prev node}
      Function  GetText :String;
      Procedure GoStart;      {Points to the first node}
      Procedure GoEnd;        {Points to the last node}
      Procedure DeInitText;           {release all the occupied memory}
   End;



Var
    WinLayer      :Array [1..MaxWindows] of Byte;
    ProDelay1,ProDelay2,ProDelay3,
    ProDelay4,ProDelay5           :Word;  {delayers}
    WindowDelay                   :Byte;  {Window Zoom Delay}
    GeneralHeadText,GeneralTailText,
    GeneralCurText                :PDynText;
Const
    TempScreen    :^ScreenImage  = Nil;
    VgaExist      :Boolean       = False;
    ColorCard     :Boolean       = False;
    MonoCard      :Boolean       = False;
    FontHeight    :Byte          = 8;



Procedure InitText;
Procedure InsertText(InText:String;TxtColor,BckColor :Byte);
Procedure DeleteText;

Procedure CLI;inline($FA);
Procedure STI;inline($FB);
Function  IsVga :Boolean;
Procedure SetCharWidth(Hwidth :Byte);
Procedure ReadFontsByManual(Var Read_4080_Bytes :FontData);
Procedure UseFontsByManual(Read_4080_Bytes :FontData);
Procedure UsePartFontsByManual(Start,Count :Byte;Read_4080_Bytes :FontData);
Procedure UseFontsByBiosInt(Start,MaxChars :Word;Read_4080_Bytes :FontData);
Procedure InitVga8x16(FileName:String; Var ErrorCode :Byte);
Procedure InitVga8x8(FileName:String; Var ErrorCode :Byte);
Procedure InitVga8x14(FileName :String;Var ErrorCode :Byte);
Procedure CloseVga;

IMPLEMENTATION

Procedure LinkText.InitText;
Begin
    HeadText:=Nil;
    TailText:=Nil;
    Text:=Nil;
    Edge:=True;
End;

Procedure LinkText.InsertText;
Var
   Number       :Word;
Begin
     IF HeapErrorCode <> 0 Then
        Exit;

     New(Text);

     IF Text<>Nil Then
     Begin

       {Current Text Fields}
       Text^.PrevTextLine:=TailText;
       Text^.NextTextLine:=Nil;
       Text^.ExtraFunc:=Nil;

       {Previous Text Field}
       IF TailText<>Nil Then
       Begin
          TailText^.NextTextLine:=Text;
          Number:=TailText^.NodeNum;
       End;

       {New value into RearPtr}
        TailText:=Text;

       {Change Head only the first time}
       IF HeadText=Nil Then
       Begin
          HeadText:=Text;
          Number:=0;
       End;

       IF MemAvail > Length(InText)+1 Then
       Begin
          GetMem(Text^.TextLine,Length(InText)+1); {add 1 byte for the Str Size}
          Text^.TextLine^:=InText; {Insert Text}
       End
       Else
       Begin
          Text^.TextLine^:=''; {No mem available.Insert Blank}
          Text^.NextTextLine:=Nil;
          Text:=Nil;
          HeapErrorCode:=2;
          Exit;
       End;

       Text^.NodeNum:=Number+1;   {Node Number}
       Text^.TLineColor:=TColor;
       Text^.TLineBackGround:=TBackGround;
       Text^.ExtraFunc:=Nil;
     End
     Else
        HeapErrorCode:=2;
End;

Procedure LinkText.FindNodeNum;
Var
   Found        :Boolean;
Begin
    Text:=HeadText;
    IF Text = Nil Then
       Exit;
    Found:=False;
    Edge:=False;
    Repeat

        IF Text <> Nil Then
        Begin
            IF Text^.NodeNum = Num Then
               Found:=True
            Else
               Text:=Text^.NextTextLine;
        End;

    Until  (Text = Nil) or (Found=True);


    IF (Text=TailText) or (Text=HeadText) Then
       Edge:=True;

End;

Procedure LinkText.FindText;
Var
   Found        :Boolean;
Begin
    Text:=HeadText;
    IF Text=Nil Then
       Exit;
    Found:=False;
    Edge:=False;
    Repeat

        IF Text <> Nil Then
        Begin
            IF Text^.TextLine^ = Str Then
               Found:=True
            Else
               Text:=Text^.NextTextLine;
        End;

    Until  (Text = Nil) or (Found=True);


    IF (Text=TailText) or (Text=HeadText) Then
       Edge:=True;

End;

Procedure LinkText.DeleteText;
Var
   Prev,Next    :PLinkStr;
Begin
    IF Text = Nil Then
       Exit;

    IF Text = HeadText Then
    Begin
       HeadText:=Text^.NextTextLine;
       HeadText^.PrevTextLine:=Nil;
    End
    Else
    IF Text = TailText Then
    Begin
       TailText:=Text^.PrevTextLine;
       TailText^.NextTextLine:=Nil;
    End
    Else
    Begin
        Prev:=Text^.PrevTextLine;
        Next:=Text^.NextTextLine;

        Prev^.NextTextLine:=Next;
        Next^.PrevTextLine:=Prev;
    End;

    FreeMem(Text^.TextLine,Length(Text^.TextLine^)+1);
    Dispose(Text);
    Text:=Prev;
End;

Procedure LinkText.NextText;
Begin
    Edge:=False;

    IF Text <> Nil Then
       Text:=Text^.NextTextLine;

    IF Text=Nil Then
       Edge:=True;
End;

Procedure LinkText.PrevText;
Begin
    Edge:=False;
    IF Text <> Nil Then
       Text:=Text^.PrevTextLine;

    IF Text=Nil Then
       Edge:=True;

End;

Function LinkText.GetText;
Begin
    Edge:=False;
    IF Text = Nil Then
    Begin
       GetText:='';
       Edge:=True;
    End
    Else
       GetText:=Text^.TextLine^;
End;

Procedure LinkText.GoStart;
Begin
    Text:=HeadText;
    Edge:=True;
End;

Procedure LinkText.GoEnd;
Begin
    Text:=TailText;
    Edge:=True;
End;

Procedure LinkText.DeInitText;
Begin
    Text:=HeadText;
    IF Text = Nil Then
       Exit;

    Repeat
      IF Text <> Nil Then
      Begin
         HeadText:=HeadText^.NextTextLine;
         FreeMem(Text^.TextLine,Length(Text^.TextLine^)+1);
         Dispose(Text);
         Text:=HeadText;
      End;

    Until Text = Nil;

    LinkText.InitText;
End;

{******************** Global Texts *****************************}
Procedure InitText;
Begin
    GeneralHeadText:=Nil;
    GeneralTailText:=Nil;
    GeneralCurText:=Nil;
End;

Procedure InsertText(InText:String;TxtColor,BckColor :Byte);
Var
   NewMaxLen    :Byte;
Begin
     IF HeapErrorCode <> 0 Then
        Exit;

     New(GeneralCurText);

     IF GeneralCurText<>Nil Then
     Begin

       {Current Text Fields}
       GeneralCurText^.PrevTextLine:=GeneralTailText;
       GeneralCurText^.NextTextLine:=Nil;

       {Previous Text Field}
       IF GeneralTailText<>Nil Then
          GeneralTailText^.NextTextLine:=GeneralCurText;

       {New value into RearPtr}
        GeneralTailText:=GeneralCurText;

       {Change Head only the first time}
       IF GeneralHeadText=Nil Then
          GeneralHeadText:=GeneralCurText;

       IF MemAvail > Length(InText)+1 Then
       Begin
          GetMem(GeneralCurText^.TextLine,Length(InText)+1); {add 1 byte for the Str Size}
          GeneralCurText^.TextLine^:=InText; {Insert Text}
       End
       Else
       Begin
          GeneralCurText^.TextLine^:=''; {No mem available.Insert Blank}
          GeneralCurText^.NextTextLine:=Nil;
          GeneralCurText:=Nil;
          HeapErrorCode:=2;
          Exit;
       End;

       GeneralCurText^.TLineColor:=TxtColor;   {Text Color}
       GeneralCurText^.TLineBackGround:=BckColor; {BackGround Color}
     End
     Else
       HeapErrorCode:=2;
End;

Procedure DeleteText;
Begin
    GeneralCurText:=GeneralHeadText;
    IF GeneralCurText = Nil Then
       Exit;

    Repeat
      IF GeneralCurText <> Nil Then
      Begin
         GeneralHeadText:=GeneralCurText^.NextTextLine;
         FreeMem(GeneralCurText^.TextLine,Length(GeneralCurText^.TextLine^)+1);
         Dispose(GeneralCurText);
         GeneralCurText:=GeneralHeadText;
      End;
    Until GeneralCurText = Nil;

    InitText;
End;


{**********************************************************************}
{Procedure IsVga                                                       }
{Ñ¢ú§Æú† úò§ ´¶ ©¨©´û£ò úÆú† Vga Card.                                 }
{It returns True = IF Vga exist and False if not.                      }
{**********************************************************************}

Function IsVga :Boolean;
Var
   Result    :Byte;
Begin

  asm;
    mov ax,1a00h
    int 10h
    cmp al,1ah
    jnz @1
    mov Result,1
    jmp @2
@1: mov Result,0

@2:

  End;
  IF Result=0 Then
     IsVga:=False
  Else
    IsVga:=True;

End;

{*****************************************************}
{Procedure UseFontsByBiosInt                          }
{Ñ§ú®ö¶ß¶†¶¨£ú ´¶ ©ú´ Æò®ò°´û®‡§ òß¶ °òß¶†¶ buffer £ú }
{´û§ ô¶ûüú†ò ´¶¨ Å†¶™.                                }
{*****************************************************}
Procedure UseFontsByBiosInt(Start,MaxChars :Word;Read_4080_Bytes :FontData);
Var
    Regs        :Registers;
    FOfs        :Word;
Begin
   FOfs:=Ofs(Read_4080_Bytes)+(Start shl 4);
   Regs.ah:=$11;
   Regs.al:=$10;
   Regs.cx:=MaxChars;
   Regs.bl:=0;
   Regs.bh:=16;
   Regs.dx:=Start;
   Regs.es:=Seg(Read_4080_Bytes);
   Regs.bp:=FOfs;
   Intr($10,Regs);
End;

{*****************************************************}
{Procedure ReadFontsByManual.                         }
{Ñ§ú®ö¶ß¶†¶¨£ú °òß¶†¶ ©ú´ Æò®ò°´û®‡§ £ú òßú¨üú†ò™     }
{ß®¶©ßú¢ò©û ©´¶ BitPlane2.ãú ò¨´¶§ ´¶§ ´®¶ß¶ úÆ¶¨£ú   }
{£†°®¶´ú®¶ ´®ú£¶¨¢†ò©£ò ´û™ ¶ü¶§û™.                   }
{*****************************************************}

Procedure ReadFontsByManual(Var Read_4080_Bytes :FontData);
Var
   VarOffs,VarSeg       :Word;
Begin
       Asm CLI End;
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006;

       Asm Sti End;

       VarOffs:=Ofs(Read_4080_Bytes);
       VarSeg:=Seg(Read_4080_Bytes);


       Asm;
           push ds

           mov ax,0040h
           mov es,ax
           mov dx,es:[0063h]   {Vertival Retrace}
           add dx,6
       @L02:
           in al,dx
           test al,8
           jz @L02

       @L03:
           in al,dx
           test al,8
           jnz @L03


           mov ds,VarSeg
           mov si,VarOffs
           mov di,0
           mov ax,0A000h
           mov es,ax
           mov dx,0

           mov cx,4080


      @lo1:
          mov al,es:[di]
          mov ds:[si],al
          inc si
          inc dx
          inc di
          Cmp dx,16
          Jz @ZeroDx
     @con1:
          loop @lo1
          jmp @con2

     @ZeroDx:
          mov dx,0
          add di,16
          jmp @con1
     @con2:

           pop ds
       End;

       Asm CLI End;
       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm STI End;
End;



{*****************************************************}
{Procedure UseFontsByManual.                          }
{Ñ§ú®ö¶ß¶†¶¨£ú °òß¶†¶ ©ú´ Æò®ò°´û®‡§ £ú òßú¨üú†ò™     }
{ß®¶©ßú¢ò©û ©´¶ BitPlane2.ãú ò¨´¶§ ´¶§ ´®¶ß¶ úÆ¶¨£ú   }
{£†°®¶´ú®¶ ´®ú£¶¨¢†ò©£ò ´û™ ¶ü¶§û™.                   }
{*****************************************************}

Procedure UseFontsByManual(Read_4080_Bytes :FontData);
Var
   VarOffs,VarSeg       :Word;
Begin
       Asm CLI End;
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006;
       Asm STI End;

       VarOffs:=Ofs(Read_4080_Bytes);
       VarSeg:=Seg(Read_4080_Bytes);


       Asm;
           push ds

           mov ax,0040h
           mov es,ax
           mov dx,es:[0063h]   {Vertival Retrace}
           add dx,6
       @L02:
           in al,dx
           test al,8
           jz @L02

       @L03:
           in al,dx
           test al,8
           jnz @L03

           mov ds,VarSeg
           mov si,VarOffs
           mov di,0
           mov ax,0A000h
           mov es,ax
           mov dx,0

           mov cx,4080


      @lo1:
          mov al,ds:[si]
          mov es:[di],al
          inc si
          inc dx
          inc di
          Cmp dx,16
          Jz @ZeroDx
     @con1:
          loop @lo1
          jmp @con2

     @ZeroDx:
          mov dx,0
          add di,16
          jmp @con1
     @con2:

           pop ds
       End;

       Asm CLI End;
       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm STI End;
End;

Procedure UsePartFontsByManual(Start,Count :Byte;Read_4080_Bytes :FontData);
Var
   VarOffs,VarSeg       :Word;
Begin
       Asm CLI End;
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006;
       Asm STI End;

       VarOffs:=Ofs(Read_4080_Bytes);
       VarSeg:=Seg(Read_4080_Bytes);


       Asm;
           push ds

           mov ax,0040h
           mov es,ax
           mov dx,es:[0063h]   {Vertival Retrace}
           add dx,6
       @L02:
           in al,dx
           test al,8
           jz @L02

       @L03:
           in al,dx
           test al,8
           jnz @L03

           mov ds,VarSeg
           mov si,VarOffs

           xor cx,cx
           mov cl,Start {mul by 16}
           shl cx,1
           shl cx,1
           shl cx,1
           shl cx,1
           add si,cx

           mov di,0
           xor cx,cx
           mov cl,Start {mul by 32}
           shl cx,1
           shl cx,1
           shl cx,1
           shl cx,1
           shl cx,1
           add di,cx

           mov ax,0A000h
           mov es,ax
           mov dx,0

           xor cx,cx
           mov cl,Count
           shl cx,1 {mul by 16}
           shl cx,1
           shl cx,1
           shl cx,1


      @lo1:
          mov al,ds:[si]
          mov es:[di],al
          inc si
          inc dx
          inc di
          Cmp dx,16
          Jz @ZeroDx
     @con1:
          loop @lo1
          jmp @con2

     @ZeroDx:
          mov dx,0
          add di,16
          jmp @con1
     @con2:

           pop ds
       End;

       Asm CLI End;
       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm STI End;
End;


{***********************************************************************}
{Procedure SetCharWidth                                                 }
{Ñò§ ¨ßò®Æú† Vga ´¶´ú £ß¶®¶¨£ú ©´û§ ò§ò¢¨©û 80ï25 §ò ò¢ò•¶¨£ú ´¶ ß¢ò´¶™ }
{´¶¨ Æò®ò°´û®ò òß¶ 9 ß†Æú¢™ ©ú 8 ö†ò §ò úÆ¶¨£ú ©¨§úÆ¶£ú§¶¨™ Æò®ò°´û®ú™. }
{***********************************************************************}

Procedure SetCharWidth(Hwidth :Byte);
var
    Regs        :Registers;
    X           :Byte;
begin
    Asm;
           mov ax,0040h
           mov es,ax
           mov dx,es:[0063h]   {Vertival Retrace}
           add dx,6
       @L02:
           in al,dx
           test al,8
           jz @L02

       @L03:
           in al,dx
           test al,8
           jnz @L03
    End;

    if (hwidth=8) then
        Regs.Bx:=$0001
    Else
        Regs.Bx:=$0800;

    X:=port[$3cc] and not(4+8);
    If hwidth=9 then
       x:=x or 4;
    port[$3c2]:=x;
    Cli;
    portw[$3c4]:=$0100;
    portw[$3c4]:=$01+Regs.Bl shl 8;
    portw[$3c4]:=$0300;
    Sti;

    Regs.AX:=$1000;
    Regs.Bl:=$13;
    Intr($10,Regs);
end;

{***************************************************************}
{Procedure InitVga                                              }
{î¶®´‡§ú† òß¶ ´¶§ õ†©°¶ ú§ò ò®Æú†¶ SYB °ò† ´¶ ú§ú®ö¶ß¶†ú†.Ñß†©û™}
{ò¢¢òùú† ´¶ ß¢ò´¶™ ´¶¨ Æò®ò°´û®ò òß¶ 9 ©ú 8.                    }
{Ñß†©´®ú≠ú† 0 ¶´ò§ ¶¢ò ú†§ò† ú§´ò•ú† °ò† 1 ¶´ò§ ¨ßò®Æú† ¢òü¶™   }
{***************************************************************}

Procedure InitVga8x16(FileName :String;Var ErrorCode :Byte);
Type
    DiskData = Array [1..4080] of Byte;
Var
    MyFile              :File of DiskData;
    Read_4080_Bytes     :DiskData;
    Exist               :Boolean;

{*****************************************************}
{Procedure UseFontsByBiosInt                          }
{Ñ§ú®ö¶ß¶†¶¨£ú ´¶ ©ú´ Æò®ò°´û®‡§ òß¶ °òß¶†¶ buffer £ú }
{´û§ ô¶ûüú†ò ´¶¨ Å†¶™.                                }
{*****************************************************}
Procedure UseFontsByBiosInt;
Var
    Regs        :Registers;
Begin
   Regs.ah:=$11;
   Regs.al:=$10;
   Regs.cx:=255;
   Regs.bl:=0;
   Regs.bh:=16;
   Regs.dx:=0;
   Regs.es:=Seg(Read_4080_Bytes);
   Regs.bp:=ofs(Read_4080_Bytes);
   Intr($10,Regs);
End;


Begin
     IF IsVga Then
     Begin
       Assign(MyFile,FileName);
  {$I-}Reset(MyFile); {$I+}
       IF IoResult=0 Then
       Begin
  {$I-}    Read(MyFile,Read_4080_Bytes); {$I+}
           IF IoResult=0 Then
           Begin
               Close(MyFile);
               IF Mem[$0040:$004A] <= 80 Then
               Begin
                 While ((Port[$3DA] and 8) = 8) do;
                 While ((Port[$3DA] and 8) <> 8) do;
                 SetCharWidth(8);
               End;
               While ((Port[$3DA] and 8) = 8) do;
               While ((Port[$3DA] and 8) <> 8) do;
               UseFontsByBiosInt;
               ErrorCode:=0;
               VgaExist:=True;
           End
           Else
           Begin
             ErrorCode:=1;
             Close(MyFile);
           End;
       End
       Else
         ErrorCode:=1;
  End
  Else
    ErrorCode:=1;
End;

Procedure InitVga8x8(FileName :String;Var ErrorCode :Byte);
Type
    DiskData = Array [1..2040] of Byte;
Var
    MyFile              :File of DiskData;
    Read_2040_Bytes     :DiskData;
    Exist               :Boolean;

Procedure UseFontsByManual;
Var
   VarOffs,VarSeg       :Word;
Begin
       Asm CLI End;
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006;

       VarOffs:=Ofs(Read_2040_Bytes);
       VarSeg:=Seg(Read_2040_Bytes);


       Asm;
           push ds

           mov ds,VarSeg
           mov si,VarOffs
           mov di,0
           mov ax,0A000h
           mov es,ax
           mov dx,0

           mov cx,2040


      @lo1:
          mov al,ds:[si]
          mov es:[di],al
          inc si
          inc dx
          inc di
          Cmp dx,8
          Jz @ZeroDx
     @con1:
          loop @lo1
          jmp @con2

     @ZeroDx:
          mov dx,0
          add di,24
          jmp @con1
     @con2:

           pop ds
       End;

       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm STI End;
End;

Begin
     IF IsVga Then
     Begin
       Assign(MyFile,FileName);
  {$I-}Reset(MyFile); {$I+}
       IF IoResult=0 Then
       Begin
  {$I-}    Read(MyFile,Read_2040_Bytes); {$I+}
           IF IoResult=0 Then
           Begin
               Close(MyFile);
               While ((Port[$3DA] and 8) = 8) do;
               While ((Port[$3DA] and 8) <> 8) do;
{               SetCharWidth(8);}
               While ((Port[$3DA] and 8) = 8) do;
               While ((Port[$3DA] and 8) <> 8) do;
               UseFontsByManual;
               ErrorCode:=0;
               VgaExist:=True;
           End
           Else
             ErrorCode:=1;
       End
       Else
         ErrorCode:=1;
  End
  Else
    ErrorCode:=1;
End;

Procedure InitVga8x14(FileName :String;Var ErrorCode :Byte);
Type
    DiskData = Array [1..3570] of Byte;
Var
    MyFile              :File of DiskData;
    Read_3570_Bytes     :DiskData;
    Exist               :Boolean;

Procedure UseFontsByManual;
Var
   VarOffs,VarSeg       :Word;
Begin
       Asm CLI End;
       portw[ $3C4 ] := $0402;
       portw[ $3C4 ] := $0704;

       portw[ $3CE ] := $0204;
       portw[ $3CE ] := $0005;
       portw[ $3CE ] := $0006;

       VarOffs:=Ofs(Read_3570_Bytes);
       VarSeg:=Seg(Read_3570_Bytes);


       Asm;

           push es
           push ds

           mov ds,VarSeg
           mov si,VarOffs
           mov di,0
           mov ax,0A000h
           mov es,ax
           mov dx,0

           mov cx,3570


      @lo1:
          mov al,ds:[si]
          mov es:[di],al
          inc si
          inc dx
          inc di
          Cmp dx,14
          Jz @ZeroDx
     @con1:
          loop @lo1
          jmp @con2

     @ZeroDx:
          mov dx,0
          add di,18
          jmp @con1
     @con2:

           pop ds
           pop es

       End;

       portw[ $3C4 ] := $0302;
       portw[ $3C4 ] := $0304;

       portw[ $3CE ] := $0004;
       portw[ $3CE ] := $1005;
       portw[ $3CE ] := $0E06;
       Asm STI End;
End;

Begin
     IF IsVga Then
     Begin
       Assign(MyFile,FileName);
  {$I-}Reset(MyFile); {$I+}
       IF IoResult=0 Then
       Begin
  {$I-}    Read(MyFile,Read_3570_Bytes); {$I+}
           IF IoResult=0 Then
           Begin
               Close(MyFile);
               While ((Port[$3DA] and 8) = 8) do;
               While ((Port[$3DA] and 8) <> 8) do;
{               SetCharWidth(8);}
               While ((Port[$3DA] and 8) = 8) do;
               While ((Port[$3DA] and 8) <> 8) do;
               UseFontsByManual;
               ErrorCode:=0;
               VgaExist:=True;
           End
           Else
             ErrorCode:=1;
       End
       Else
         ErrorCode:=1;
  End
  Else
    ErrorCode:=1;
End;

{*****************************************************************}
{Procedure CloseVga                                               }
{äú†´¶¨®öú† ©ú ©¨§õ†ò©£¶ £ú ´û§ InitVga.Ä¢¢òùú† ´¶ ß¢ò´¶™ ©´¶ °ò§¶}
{§†°¶ (9) °ò† ≠¶®´‡§ú† ´¶¨™ ò®Æ†°¶¨™ Æò®ò°´û®ú™ òß¶ ´¶ Bios       }
{*****************************************************************}

Procedure CloseVga;
Procedure Load8x16FromBios;assembler;
Asm;
    mov ax,0040h
    mov es,ax
    mov dx,es:[0063h]
    add dx,6

@Lo1:
    in al,dx
    test al,8
    jnz @Lo1

@Lo2:
    in al,dx
    test al,8
    jz @Lo2


    mov ah,11h
    mov al,04h
    mov bl,0h
    int 10h

End;
Begin
    IF VgaExist=True Then
    Begin
      While ((Port[$3DA] and 8) = 8) do;
      While ((Port[$3DA] and 8) <> 8) do;
      SetCharWidth(9);
    End;
End;
Begin
     BiosColumns:=Mem[$0040:$004A];
     BiosColumns:=BiosColumns shl 1;
     BiosRows:=Mem[$0040:$0084]+1;
End.