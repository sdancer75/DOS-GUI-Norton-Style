Uses WindowsObj,VarConstObj,WinObjA,WinObjB,WinInit,GeneralObj,Crt,Dos,
      ErrorDlg,MouseObj,WinApplObj,TopicHlp,HelpObj;

Const

     CancelFor   :Boolean = False;      {It used from the User Interrupt}
     MaxNumTries = 5;                      { Maximum number of tries }
     MaxDrives   :Byte = 0;

     CmQuit      = 1;
     cmMainMenu  = 2;
     cmOptions   = 3;
     cmFormat    = 4;
     cmAbout     = 5;

     cmSystem    = 6;
     cmVoice     = 7;
     cmVerify    = 8;
     cmDrive     = 9;
     cmLabel     = 10;
     cmDos       = 11;
     cmQuick     = 12;
     cmDensity   = 13;
     cmCancelOrResume = 14;
     cmContinueFormat = 15;
     cmCancelFormat   = 16;
     cmFormatCompleted= 16; {It's same with the CmCancelFormat =16}
     cmAskUserForFormat = 17;

      NO_DRIVE    = 0;                                     { No drive }
      DD_525      = 1;                              { Drive: 5.25" DD }
      HD_525      = 2;                              { Drive: 5.25" HD }
      DD_35       = 3;                              { Drive: 3.5" DD  }
      HD_35       = 4;                              { Drive: 3.5" HD  }

      SDD_525     =' 360  DD ';
      SHD_525     =' 1.20 HD ';
      SDD_35      =' 720  DD ';
      SHD_35      =' 1.44 HD ';


      {-- Defaults for the BOOT sector with load program -------------}

      BootMask  : array[ 1..102 ] of byte =
                   ( $EB, $35,                { 0000   JMP 0037       }
                     $90,                     { 0002   NOP            }
                     {-- Data of the BPB -----------------------------}

                     $50, $43, $49, $4E, $54, $45, $52, $4E,
                     $00, $00, $00, $01, $00, $00, $00, $00,
                     $00, $00, $00, $00, $00, $00, $00, $00,
                     $00, $00, $00, $00, $00, $00, $00, $00,
                     $00, $00, $00, $00, $00, $00, $00, $00,
                     $00, $00, $00, $00, $00, $00, $00, $00,
                     $00, $00, $00, $00,

                     {-- Actual load program -------------------------}

                     $FA,                    { 0037   CLI             }
                     $B8, $30, $00,          { 0038   MOV     AX,0030 }
                     $8E, $D0,               { 003B   MOV     SS,AX   }
                     $BC, $FC, $00,          { 003D   MOV     SP,00FC }
                     $FB,                    { 0040   STI             }
                     $0E,                    { 0041   PUSH    CS      }
                     $1F,                    { 0042   POP     DS      }
                     $BE, $66, $7C,          { 0043   MOV     SI,7C66 }
                     $B4, $0E,               { 0046   MOV     AH,0E   }
                     $FC,                    { 0048   CLD             }
                     $AC,                    { 0049   LODSB           }
                     $0A, $C0,               { 004A   OR      AL,AL   }
                     $74, $04,               { 004C   JZ      0052    }
                     $CD, $10,               { 004E   INT     10      }
                     $EB, $F7,               { 0050   JMP     0049    }
                     $B4, $01,               { 0052   MOV     AH,01   }
                     $CD, $16,               { 0054   INT     16      }
                     $74, $06,               { 0056   JZ      005E    }
                     $B4, $00,               { 0058   MOV     AH,00   }
                     $CD, $16,               { 005A   INT     16      }
                     $EB, $F4,               { 005C   JMP     0052    }
                     $B4, $00,               { 005E   MOV     AH,00   }
                     $CD, $16,               { 0060   INT     16      }
                     $33, $D2,               { 0062   XOR     DX,DX   }
                     $CD, $19 );             { 0064   INT     19      }

      BootMes : string =
       #13#10'Quick Format ver 1.00a  (c) 1992,96 by Digital ToolWorks'+ #13#10 +
       #13#10'Defective diskette or non-system diskette'#13#10 +
       'Please change your diskette and press any key . . .' +
       #13#10;


Type

   MDrives   = Record
       DrvNum  :Byte;
       Size    :String[20];
   End;

   DriveParams = Record
       Drive     :Byte;                {A:=0 ,B:=1.....}
       DriveNum  :Byte;                 {Internal}
       Density   :String[20];           {'1440','1200','720','360'}
       DLabel    :String[11];         {Disk label}
       Voice     :Boolean;            {If voice=True}
       Verify    :Boolean;            {Verify}
       DOSorQuick:Byte;               {0=Dos Format,1=Quick}
       System    :Byte;               {1=None,2=Space,3=System}
   End;

     DdptType = array[ 0..10 ] of byte;          { Structure for DDPT }
     DdptPtr = ^DdptType;                           { Pointer to DDPT }

     PhysDataType = record               { Physical format parameters }
       DSides,                 { Desired number of sides for diskette }
       STrax,                            { Number of tracks per side }
       TSectors : byte;                 { Number of sectors per track }
       DDPT     : DdptPtr;    { Pointer to disk drive parameter table }
     End;

     LogDataType = record                     { DOS format parameters }
       Media,                                            { Media byte }
       Cluster,                          { Number sectors per cluster }
       FAT,                              { Number sectors for the FAT }
       RootSize : byte;               { Entries in the root directory }
    End;

    TrackBfType = array[ 1..18, 1..512 ] of byte;  { Buffer for track }



   TMyApp = Object (Application)
      Procedure HandleCommand; Virtual;

      Procedure MainMenu;
      Procedure Format;
      Procedure About;
      Procedure AskUser;
      Procedure AskUserForFormat;
      Procedure FormatCompleted;
      Function  PhysicalFormat( Drive:Byte;PData:PhysDataType;Verify:Boolean):Boolean;
      Procedure DoFormat;
      Procedure ShowUpAnErrorMessage;
   End;

Var
   Conf         :DriveParams;
   PData        : PhysDataType;        { Physical format information }
   LData        : LogDataType;          { Logical format information }
   POldDDPT     : pointer;                     { Pointer to old DDPT }
   OK           : boolean;                   { Flag for program flow }
   DosLineParams:Boolean;

   TimerTicks,TimerMinutes,
   TimerSeconds            :Byte;    {Counter for our Format Elapse time}
   TimerWorking            :Boolean; {Working Routine Timer Flag}
   TimerWinX,TimerWinY     :Byte;
   Stat                    :Byte; {The error code from phisical formatting}
   TrackF,                                           { Current track }
   SideNum                 :Byte;                      { Current side }
   MenuAskUser             :Boolean;
   R                       :ProgressBar;
   DrvInfo                 :Array [1..4] of MDrives;

{*****************************************************************}
{Procedure TestForDiskette                                        }
{It doesn't nothing special just set the CritialError Flag if a   }
{Disk is not present on the specific Drive.                       }
{*****************************************************************}

Procedure TestForDiskette;
Var
   Buffer       :String;
   AFile        :File;
   I            :Integer;
Begin
     Buffer:='xx--xx--.x-x';

     Buffer:=Chr(Conf.Drive+65)+':\'+Buffer;
     Assign(AFile,Buffer);
     Rewrite(AFile,1);
     I:=IOResult;

End;


{*********************************************************************}
{* GetFormatParameter: Determines the logical and physical           *}
{*                     parameters necessary for formatting.          *}
{* Input         : FORMSTRING = Desired capacity as string           *}
{*                              "360", "1200", "720", "1440"         *}
{*                 DRIVETYPE  = Drive code as returned from          *}
{*                              GetDriveType                         *}
{*                 PDATA      = Loaded by procedure with the         *}
{*                              specIfications of the physical       *}
{*                              format                               *}
{*                 LDATA      = Like PDATA, only DOS specs           *}
{* Output        : True, If the format is possible, otherwise False  *}
{* Info          : New formats can be added by extEnding this        *}
{*                 procedure                                         *}
{*********************************************************************}

Function GetFormatParameter(FormString : string;DriveType:byte;Var PData:PhysDataType;
                                Var LData:LogDataType) : Boolean;

Const DDPT_360  : DdptType = ( $DF, $02, $25, $02, $09, $2A,
                               $FF, $50, $F6, $0F, $08 );
      DDPT_1200 : DdptType = ( $DF, $02, $25, $02, $0F, $1B,
                               $FF, $54, $F6, $0F, $08 );
      DDPT_720  : DdptType = ( $DF, $02, $25, $02, $09, $2A,
                               $FF, $50, $F6, $0F, $08 );
      DDPT_1440 : DdptType = ( $DF, $02, $25, $02, $12, $1B,
                               $FF, $6C, $F6, $0F, $08 );

      LOG_360  : LogDataType = ( Media : $FD; Cluster  : 2;
                                 FAT   : 2;   RootSize : $70 );
      LOG_1200 : LogDataType = ( Media : $F9; Cluster  : 1;
                                 FAT   : 7;   RootSize : $E0 );
      LOG_720  : LogDataType = ( Media : $F9; Cluster  : 2;
                                 FAT   : 3;   RootSize : $70 );
      LOG_1440 : LogDataType = ( Media : $F0; Cluster  : 1;
                                 FAT   : 9;   RootSize : $E0 );

      PHYS_360  : PhysDataType = ( DSides   :  2; STrax : 40;
                                   TSectors :  9; DDPT   : @DDPT_360 );
      PHYS_1200 : PhysDataType = ( DSides   :  2; STrax : 80;
                                   TSectors : 15; DDPT   : @DDPT_1200);
      PHYS_1440 : PhysDataType = ( DSides   :  2; STrax : 80;
                                   TSectors : 18; DDPT   : @DDPT_1440);
      PHYS_720  : PhysDataType = ( DSides   :  2; STrax : 80;
                                   TSectors :  9; DDPT   : @DDPT_720 );

Begin
  If ( FormString = SHD_525 ) Then                 { 1.2 Meg on 5.25"? }
    If ( DriveType = HD_525 ) Then    { Format compatible with drive? }
      Begin                                      { Yes, set parameter }
        PData := PHYS_1200;
        LData := LOG_1200;
        GetFormatParameter := True;               { End without error }
      End
    Else
      GetFormatParameter := False     { Drive and format incompatible }
  Else If ( FormString = SDD_525 ) Then                         { 360K? }
    If ( DriveType = HD_525 ) or ( DriveType = DD_525 ) Then
      Begin              { Format and drive compatible, set parameter }
        PData := PHYS_360;
        LData := LOG_360;
        GetFormatParameter := True;               { End without error }
      End
    Else
      GetFormatParameter := False     { Drive and format incompatible }
  Else If ( FormString = SHD_35 ) Then            { 1.44 Meg on 3.5"? }
    If ( DriveType = HD_35 ) Then     { Format compatible with drive? }
      Begin                                     { Yes, set parameters }
        PData := PHYS_1440;
        LData := LOG_1440;
        GetFormatParameter := True;               { End without error }
      End
    Else
      GetFormatParameter := False     { Drive and format incompatible }
  Else If ( FormString = SDD_35 ) Then                 { 720K on 3.5"? }
    If ( DriveType = HD_35 ) or ( DriveType = DD_35 ) Then
      Begin             { Format and drive compatible, set parameters }
        PData := PHYS_720;
        LData := LOG_720;
        GetFormatParameter := True;               { End without error }
      End
    Else
      GetFormatParameter := False     { Drive and format incompatible }
  Else
    GetFormatParameter := False;           { Invalid format specIfied }
End;


{*********************************************************************}
{* GetDriveType  : Gets disk drive type.                             *}
{* Input         : DRIVE = Drive number (0, 1 etc.)                  *}
{* Output        : Drive code as constant (DD_525, HD_525 etc.)      *}
{*********************************************************************}

Function GetDriveType( Drive : byte ) : byte;

Var Regs     : Registers;    { Processor registers for interrupt call }

Begin
  Regs.ah := $08;                    { Function: Determine drive type }
  Regs.dl := Drive;                                    { Drive number }
  Intr( $13, Regs );                            { Call BIOS interrupt }
  If ( Regs.flags and fcarry = 0 ) Then {Call completed without error?}
    GetDriveType := Regs.bl                              { Drive type }
  Else
    GetDriveType := DD_525;          { Function 08H of interrupt does }
End;                                { not exist => Computer type = XT }

{*********************************************************************}
{* ResetDisk     : Disk reset on all drives.                         *}
{* Input         : None                                              *}
{* Output        : None                                              *}
{* Info          : Regardless of drive number loaded in DL, reset    *}
{*                 executed on all drives.                           *}
{*********************************************************************}

procedure DiskReset;

Var Regs : Registers;        { Processor registers for interrupt call }

Begin
  With Regs do
    Begin
      ah := $00;                 { Function number for interrupt call }
      dl := 0;                                  { Drive a: (see Info) }
    End;
  intr( $13, Regs );                                 { Interrupt call }
End;


{*********************************************************************}
{* DiskPrepare   : Prepare drive, set data transfer rate.            *}
{* Input         : DRIVE = Drive number                              *}
{*                 PDATA = Physical parameters                       *}
{* Output        : None                                              *}
{*********************************************************************}

procedure DiskPrepare( Drive : byte; PData : PhysDataType );

Var Regs : Registers;        { Processor registers for interrupt call }

Begin
  {-- Set media type for format call ---------------------------------}

  With Regs do
    Begin
      ah := $18;                 { Function number for interrupt call }
      ch := PData.STrax - 1;              { Number of tracks per side }
      cl := PData.TSectors;             { Number of sectors per track }
      dl := Drive;                                     { Drive number }
    End;
  Intr( $13, Regs );                                 { Interrupt call }
End;


{*********************************************************************}
{* FormatTrack   : Formats a track.                                  *}
{* Input         : See below                                         *}
{* Output        : Error status                                      *}
{*********************************************************************}

function Formattrack( DriveNum,               { The disk drive number }
                      SideNum,                      { The side number }
                      TrackF,                 { Track to be formatted }
                      SecPTr      : byte ) : byte;{ Sectors per track }

Type FormatTyp = Record
                   DTrack, DSideNum, DCounter, DLength : byte;
                 End;

Var Regs      : Registers;   { Processor registers for interrupt call }
    DataField : array[ 1..18 ] of FormatTyp;     { Maximum 18 sectors }
    Counter   : byte;                                  { Loop counter }
    Attempts  : byte;                       { Maximum number of tries }

Begin
  for Counter := 1 to SecPTr do
    with DataField[ Counter ] do
      Begin
        DTrack := TrackF;                              { Track number }
        DSideNum := SideNum;                          { Diskette side }
        DCounter := Counter;                          { Sector number }
        DLength := 2;              { Number of bytes per sector (512) }
      End;
  Attempts := MaxNumTries;              { Set maximum number of tries }
  repeat
    with Regs do
      Begin
        ah := 5;                 { Function number for interrupt call }
        al := SecPTr;               { Number of sectors for one track }
        es := Seg( DataField );               { Address of data field }
        bx := Ofs( DataField );               { to register es:bx     }
        dh := SideNum;                                  { Side number }
        dl := DriveNum;                                { Drive number }
        ch := TrackF;                                  { Track number }
      End;
    Intr( $13, Regs );                          { Call BIOS interrupt }
    If ( Regs.flags and fcarry = 1 ) Then                    { Error? }
      DiskReset;                 { Yes --> Disk reset before next try }
    Dec( Attempts );
  Until ( Regs.flags and fcarry = 0 ) or ( Attempts = 0 );
  Formattrack := Regs.ah;                         { Read error status }
End;

{*********************************************************************}
{* VerifyTrack   : Verify track                                      *}
{* Input         : Drive, side, track, sector number                 *}
{* Output        : Error code (0=OK)                                 *}
{*********************************************************************}

function VerifyTrack( DriveNum, SideNum, TrackF, TSectors : byte ) : byte;

Var Attempts   : byte;                      { Maximum number of tries }
    Regs       : Registers;  { Processor registers for interrupt call }
    TrackBuffer : TrackBfType;                   { Memory for a track }

Begin
  Attempts := MaxNumTries;              { Set maximum number of tries }
  Repeat
    With Regs do
      Begin
        ah := $04;               { Function number for interrupt call }
        al := TSectors;                 { Number of sectors per track }
        ch := TrackF;                                  { Track number }
        cl := 1;                                  { Start at sector 1 }
        dl := DriveNum;                                { Drive number }
        dh := SideNum;                                  { Side number }
        es := Seg( TrackBuffer );                { Address for buffer }
        bx := Ofs( TrackBuffer );
      End;
    intr( $13, Regs );                          { Call BIOS interrupt }
    If ( Regs.flags and fcarry = 1 ) Then                    { Error? }
      DiskReset;                 { Yes --> Disk reset before next try }
    dec( Attempts );
  Until ( Regs.flags and fcarry = 0 ) or ( Attempts = 0 );
  VerifyTrack := Regs.ah;
End;

{*********************************************************************}
{* WriteTrack    : Write track                                       *}
{* Input         : Drive, side, track, start sector, number, data    *}
{* Output        : Error code (0=OK)                                 *}
{*********************************************************************}

function WriteTrack(     DriveNum, SideNum, TrackF,
                         Start, SecPTr           : byte;
                     Var Buffer ) : byte;

Var Attempts : byte;                        { Maximum number of tries }
    Regs     : Registers;    { Processor registers for interrupt call }

Begin
  Attempts := MaxNumTries;              { Set maximum number of tries }
  Repeat
    With Regs do
      Begin
        ah := $03;               { Function number for interrupt call }
        al := SecPTr;                   { Number of sectors per track }
        ch := TrackF;                                  { Track number }
        cl := Start;                              { Start at sector 1 }
        dl := DriveNum;                                { Drive number }
        dh := SideNum;                                  { Side number }
        es := Seg( Buffer );                     { Address for buffer }
        bx := Ofs( Buffer );
      End;
    Intr( $13, Regs );                          { Call BIOS interrupt }
    If ( Regs.flags and fcarry = 1 ) Then                    { Error? }
      DiskReset;                 { Yes --> Disk reset before next try }
    Dec( Attempts );
  Until ( Regs.flags and fcarry = 0 ) or ( Attempts = 0 );
  WriteTrack := Regs.ah;
End;


{*********************************************************************}
{* PhysicalFormat: Physical formatting of the diskette (Division     *}
{*                 into tracks, sectors).                            *}
{* Input         : DRIVE  = Drive code                               *}
{*                 PDATA  = Physical parameters                      *}
{*                 Verify = True, If Verify is to be executed        *}
{* Output        : False If error, otherwise True                    *}
{*********************************************************************}

Function TMyApp.PhysicalFormat( Drive  : byte;
                         PData  : PhysDataType;
                         Verify : boolean ) : boolean;

Var Attempts : byte;                        { Maximum number of tries }
    Regs     : Registers;    { Processor registers for interrupt call }

Begin
  {===============Format a diskette ===================================}

    TextColor(14);
    TextBackGround(5);

    While (TrackF <= (PData.STrax - 1)) And (CancelFor=False) do
    Begin
      SideNum:=0;
      While (SideNum <= (PData.DSides - 1)) And (CancelFor=False) do
      Begin
         Gotoxy(Win^.X1+8,Win^.Y1+8+1);Write(TrackF:2);
         Gotoxy(Win^.X1+24,Win^.Y1+8+1);Write(SideNum);
         Attempts := MaxNumTries;        { Set maximum number of tries }

         Repeat
           Stat := FormatTrack( Drive, SideNum, TrackF, PData.TSectors );

           If ( ( Stat = 0 ) And (Verify=True) ) OR ( (Stat=0) and (TrackF=0)
               and (SideNum=0) ) Then
              Stat:=VerifyTrack( Drive, SideNum, TrackF, PData.TSectors );

           Dec( Attempts );

           If ( Stat > 0 ) Then                  { Format unsuccessful }
           Begin
              DiskReset;
              PhysicalFormat:=False;
              Exit;
           End;

         Until ( Stat = 0 ) or ( Attempts = 0 );


         If ( Stat > 0 )  Then               { Error during formatting }
         Begin
            TextColor(14);
            TextBackGround(Red);
            Gotoxy(Win^.X1+57,Win^.Y1+10);
            Write(' ');
            TextBackGround(5);
         End;

         Inc(SideNum);
      End; {Nested While}



      IF BiosKeyPressed Then
      Begin
          ReadKbd(Ctrl,Ascii);
          IF Ctrl=#27 Then
          Begin
             AskUser;
             MenuAskUser:=True;
             Exit;
          End;
      End;

      R.UpDateProgressBar(1);


      Inc(TrackF);
    End;  {Global While}

  PhysicalFormat:=True; {No Error }

End;

{*********************************************************************}
{* LogicalFormat : Logical formatting of diskette (Writing boot      *}
{*                 sector, FAT and root directory)                   *}
{* Input         : DRIVE = Drive number                              *}
{*                 PDATA = Physical formatting information           *}
{*                 LDATA = Logical formatting information            *}
{* Output        : True, If no error occurs                          *}
{*********************************************************************}

function LogicalFormat( Drive : byte;
                        PData : PhysDataType;
                        LData : LogDataType ) : boolean;

Var Stat         : byte;               { Feedback of called functions }
    TotalNoSectors : word;                  { Total number of sectors }
    i              : byte;                             { Loop counter }
    CurSector,
    CurSide,
    CurTrack       : byte;
    SecPTr         : integer;        { Number of tracks to be written }
    TrackBuffer    : TrackBfType;               { Memory for a track }

Begin
  fillchar( TrackBuffer, word( PData.TSectors ) * 512, 0 ); { Empty buf}

  {-- Bootsector: Fixed part -----------------------------------------}

  Move( BootMask, TrackBuffer, 102 );         { Copy boot sector mask }
  move( BootMes[1], TrackBuffer[ 1, 103 ],          { Copy boot texts }
        ord(BootMes[0]) );
  TrackBuffer[ 1, 511 ] := $55;           { End marker of boot sector }
  TrackBuffer[ 1, 512 ] := $AA;

  {-- Bootsector: Variable part --------------------------------------}

  TotalNoSectors := PData.STrax * PData.TSectors * Pdata.DSides;
  TrackBuffer[ 1, 14 ] := LData.Cluster;               { Cluster size }
  TrackBuffer[ 1, 18 ] := LData.RootSize; { Num. entries in root dir. }
  TrackBuffer[ 1, 20 ] := lo( TotalNoSectors );{ Total number sectors }
  TrackBuffer[ 1, 21 ] := hi( TotalNoSectors );{ on the diskette      }
  TrackBuffer[ 1, 22 ] := LData.Media;             { Media descriptor }
  TrackBuffer[ 1, 23 ] := LData.FAT;                    { Size of FAT }
  TrackBuffer[ 1, 25 ] := PData.TSectors;         { Sectors per track }
  TrackBuffer[ 1, 27 ] := PData.DSides;             { Number of sides }

  {-- Make FAT and FAT copy (Contents 00)-----------------------------}

  TrackBuffer[ 2, 1 ] := LData.Media;                { Create 1st FAT }
  TrackBuffer[ 2, 2 ] := $FF;
  TrackBuffer[ 2, 3 ] := $FF;
  TrackBuffer[ LData.FAT + 2, 1 ] := LData.Media;    { Create 2nd FAT }
  TrackBuffer[ LData.FAT + 2, 2 ] := $FF;
  TrackBuffer[ LData.FAT + 2, 3 ] := $FF;

  {-- Write boot sector and FAT --------------------------------------}

  Stat := WriteTrack( Drive, 0, 0, 1, PData.TSectors, TrackBuffer );
  If Stat <> 0 Then
    LogicalFormat := False

  {-- No error, write root directory ---------------------------------}

  Else
    Begin
      fillchar( TrackBuffer, 512, 0 );                 { Empty sector }
      CurSector := PData.TSectors;     { Write first track completely }
      CurTrack := 0;                                  { Current track }
      CurSide := 0;                                    { Current side }

      {-- Determine number of remaining sectors and write ------------}

      SecPTr := LData.FAT * 2 + ( LData.Rootsize * 32 div 512 ) +
                1 - PData.TSectors;

      i := 1;
      Repeat
        Inc( CurSector );                               { Next sector }
        If ( CurSector > PData.TSectors ) Then         { Track Ended? }
          Begin
            CurSector := 1;                  { Continue with sector 1 }
            inc( CurSide );                              { Next side? }
            If ( CurSide = PData.DSides ) Then      { Side 2 already? }
              Begin
                CurSide := 0;                        { Back to side 0 }
                inc( CurTrack );
              End;
          End;
        Stat := WriteTrack( Drive, CurSide, CurTrack,
                              CurSector, 1, TrackBuffer );
        inc( i );
      until ( i > SecPTr ) or ( Stat <> 0 );
      LogicalFormat := ( Stat = 0 )
    End;
End;


Procedure TMyApp.AskUser;
Begin
    UserInterrupt:=False;

    WinTextColor:=15;
    WinTextBackGround:=4;
    OpenWindow(19,7,61,17,'',WinChars+OpenFx+CloseFx+Movement+Shadow);
    Win^.CloseCommand:=cmContinueFormat;
    If HeapErrorCode = 1 Then
       Exit;

    WriteTextColor:=14;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'Ü É†òõ†°ò©Âò õ†ò°Êß´û°ú òß¶ ´¶§ Æ®„©´û.');

    WriteTextColor:=15;
    CentreWinMessage(4,'á‚¢ú†™ §ò ò°¨®È©‡ ´û§ õ†òõ†°ò©Âò');
    CentreWinMessage(5,'„ §ò ©¨§úÆÂ©‡;');

    AssignXY(2,GetWindowMaxY-1,0,0);
    InitButton('   ~Ä°Á®‡©û   ',cmCancelFormat,PushButton,BfDefault);
    ButtonHelp('',0);

    AssignXY(27,GetWindowMaxY-1,0,0);
    InitButton('   ~ë¨§‚Æú†ò  ',cmContinueFormat,PushButton,BfNormal);
    ButtonHelp('',0);


End;

{$F+}
Procedure FormatTime;
Begin
   Inc(TimerTicks);

   If (TimerTicks >= 18) and (TimerWorking=False) Then
   Begin
      TimerWorking:=True;  { A Flag that cares about the Flickering that }
                      { might occures If the service routine is too slow }

      Inc(TimerSeconds);
      TimerTicks:=0;
      If TimerSeconds = 60 Then
      Begin
        Inc(TimerMinutes);
        TimerSeconds:=0;
      End;
      WriteTextBackGround:=5;
      WriteTextColor:=15;

      HiddenMouseCursor;

      WriteWinChar(TimerWinX+12,TimerWinY+13,WriteTextColor,WriteTextBackGround,48+Trunc(TimerMinutes/10 ));
      WriteWinChar(TimerWinX+13,TimerWinY+13,WriteTextColor,WriteTextBackGround,48+Trunc(TimerMinutes mod 10));
      WriteWinChar(TimerWinX+14,TimerWinY+13,WriteTextColor,WriteTextBackGround,Ord(':'));

      WriteWinChar(TimerWinX+15,TimerWinY+13,WriteTextColor,WriteTextBackGround,48+Trunc(TimerSeconds/10 ));
      WriteWinChar(TimerWinX+16,TimerWinY+13,WriteTextColor,WriteTextBackGround,48+Trunc(TimerSeconds mod 10 ));

      ShowMouseCursor;

      TimerWorking:=False;

   End;

End;
{$F-}

Procedure TMyApp.AskUserForFormat;
Var
   TraceStr     :String[15];
Begin
    {Do check for a disk present}
    TestForDiskette;
    IF (CriticalError=1) and (CriticalErType<>12) Then
    Begin
        ShowUpAnErrorMessage;
        Exit;
    End;

    CriticalError:=0;
    WinTextColor:=15;
    WinTextBackGround:=4;
    OpenWindow(16,5,64,18,'èêéëéïÜ',WinChars+OpenFx+CloseFx+Movement+Shadow+WinCharsWindow);
    Win^.CloseCommand:=cmContinueFormat;
    If HeapErrorCode = 1 Then
       Exit;

    TraceStr:=Chr(WCDriveA1)+Chr(WCDriveA2)+Chr(WCDriveA3)+' '+Char(Conf.Drive+65)+': ';

    WriteTextColor:=15;
    WriteTextBackGround:=3;
    TextPaint(3,2,GetWindowMaxX-3,GetWindowMaxY-3,Shadow);
    TextBox(3,2,GetWindowMaxX-3,GetWindowMaxY-3,SingleLines);


    WriteTextColor:=15;
    CentreWinMessage(3,'Ü É†òõ†°ò©Âò õ†ò£Ê®≠‡©û™ üò °ò´ò©´®‚Øú†');
    CentreWinMessage(4,'¶ß¶†òõ„ß¶´ú ß¢û®¶≠¶®Âò ßú®†‚Æú´ò† ©´û');
    CentreWinMessage(5,'õ†©°‚´ò.ÑÂ©ò† ©Âö¶¨®¶™ ¶´† ü‚¢ú†™ §ò');
    CentreWinMessage(6,'©¨§úÆÂ©‡ ´û§ õ†òõ†°ò©Âò ≠¶®£ò®Â©£ò´¶™');
    CentreWinMessage(7,'©´¶§ ¶õûöÊ   *> '+TraceStr+' <*   ;');


    AssignXY(12,GetWindowMaxY-1,0,0);
    InitButton('    ~NòÂ   ',cmFormat,PushButton,BfDefault);
    ButtonHelp('',0);


    AssignXY(GetWindowMaxX-12-Length('    éÆ†   '),GetWindowMaxY-1,0,0);
    InitButton('    ~éÆ†   ',cmMainMenu,PushButton,BfNormal);
    ButtonHelp('',0);

End;

Procedure TMyApp.FormatCompleted;
Var
        StrDrv  :String[3];
Begin


    StrDrv:=Chr(Conf.Drive+65)+':';

    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(20,10,60,17,'Format '+StrDrv,WinChars+OpenFx+CloseFx+Movement+Shadow+WinCharsWindow);
    Win^.CloseCommand:=cmContinueFormat;
    If HeapErrorCode = 1 Then
       Exit;

    WriteTextColor:=1;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(2,'Ü É†òõ†°ò©Âò ´ú¢úÂ‡©ú úß†´¨ÆÈ™.');

    AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
    InitButton('   ~Ñ§´·•ú†   ',cmFormatCompleted,PushButton,BfDefault);
    ButtonHelp('',0);

End;

Procedure TMyApp.DoFormat;
Var
   TraceStr     :String;
   Stat         :Byte;
   Attempts,I   :Byte;
Begin
    {Dos Format}
    IF Conf.DosOrQuick = 0 Then
    Begin
       OK := PhysicalFormat(Byte(Conf.Drive), PData, Conf.Verify);
       IF MenuAskUser=True Then
         Exit;
    End
    {Quick Format}
    Else
    Begin
       I:=0;
       Repeat

         Attempts:=1;
         Repeat
           Stat := FormatTrack( Conf.Drive, I, 1, PData.TSectors );
           Stat :=VerifyTrack( Conf.Drive, I, 1, PData.TSectors );

           Dec( Attempts );

           If ( Stat > 0 ) Then                  { Format unsuccessful }
              DiskReset;

         Until (Stat = 0) or ( Attempts = 0 );
         Inc(I);

       Until (I>1) or (Stat<>0);

        IF Stat=0 then
        Begin
           Ok:=True;
           R.FinishProgressBar(100);
        End
        Else
           Ok:=False;
    End;


    UserInterrupt:=False;
    UserTimerInterruptPtr:=Nil;
    If OK=True Then
    Begin
         WinTextColor:=15;
         WinTextBackGround:=2;
         OpenWindow(10,11,70,16,'',OpenFx+CloseFx+WinChars+Shadow);
         Win^.CloseCommand:=cmMainMenu;
         If HeapErrorCode = 1 Then
            Exit;

         WriteTextColor:=WinTextColor;
         WriteTextBackGround:=WinTextBackGround;
         CentreWinMessage(1,'î´†·Æ§‡ ´¶§ Boot Sector °ò† ´¶ FAT...');
         CentreWinMessage(3,'èò®ò°ò¢È ßú®†£‚§ú´ú ö†ò ¢Âöò õú¨´ú®Ê¢úß´ò');

         Ok:=LogicalFormat(Byte(Conf.Drive), PData, LData );
         RetraceDelay(400);

         CloseWindow;

         If OK=False Then
         Begin

               WinTextColor:=15;
               WinTextBackGround:=4;
               OpenWindow(13,9,68,17,'',OpenFx+CloseFx+WinChars+Shadow+Movement);
               Win^.CloseCommand:=cmMainMenu;
               If HeapErrorCode = 1 Then
                  Exit;

               WriteTextColor:=WinTextColor;
               WriteTextBackGround:=WinTextBackGround;
               CentreWinMessage(2,'èò®¶¨©†·©´û°ú ¢·ü¶™ °ò´· ´û§ úöö®ò≠„');
               CentreWinMessage(3,'´¶¨ Boot Sector °ò† ´¶¨ FAT.Ü õ†òõ†°ò©Âò');
               CentreWinMessage(4,'≠¶®£ò®Â©£ò´¶™ òß‚´¨Æú.');

               AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
               InitButton('   ~Ñ§´·•ú†   ',cmCancelFormat,PushButton,BfDefault);
               ButtonHelp('',0);


               SetIntVec( $1E, POldDDPT );
               Exit;
         End;
    End
    Else
    IF OK=False Then  {Error While formatting}
    Begin
       WinTextColor:=14;
       WinTextBackGround:=4;
       OpenWindow(13,9,68,18,'',OpenFx+CloseFx+WinChars+Shadow+Movement);
       Win^.CloseCommand:=cmMainMenu;
       If HeapErrorCode = 1 Then
          Exit;

       WriteTextColor:=15;
       WriteTextBackGround:=7;
       TextPaint(1,1,GetWindowMaxX,GetWindowMaxY-3,0);
       TextBox(1,1,GetWindowMaxX,GetWindowMaxY-3,SingleLines);

       WriteTextColor:=14;
       IF (Stat > 0) and (TrackF=0) and (SideNum=0) Then
       Begin
           CentreWinMessage(2,'Ü ßú®†¶Æ„ ´¶¨ FAT úÂ§ò† °ò´ú©´®ò£‚§û');
           CentreWinMessage(3,'„ ¨ß·®Æú† ò©¨£ôò´Ê´û´ò õ†©°‚´ò™-¶õûö¶Á.');
           CentreWinMessage(4,'Ü õ†©°‚´ò úÂ§ò† òõÁ§ò´¶§ §ò ≠¶®£ò®†©´úÂ.');
       End
       Else
       Begin
          Case Stat of
            $1:TraceStr:='Illegal function number. (01h)';
            $2:TraceStr:='Address marking not found. (02h)';
            $3:TraceStr:='Attempt to write to write-protecetd diskette. (03h)';
            $4:TraceStr:='Addressed sector not found. (04h)';
            $6:TraceStr:='Diskette was changed. (06h)';
            $8:TraceStr:='DMA overflow. (08h)';
            $9:TraceStr:='Data transfer past the segment limit. (09h)';
            $10:TraceStr:='Read error. (10h)';
            $20:TraceStr:='Diskette controller error. (20h)';
            $40:TraceStr:='Track not found. (40h)';
            $80:TraceStr:='Time out error,Drive does not respond. (80h)';
             Else
                TraceStr:='Äö§‡©´¶ ¢·ü¶™.Ü õ†òõ†°ò©Âò ≠¶®£ò®Â©£ò´¶™ ò°¨®Èüû°ú.';
          End;

          CentreWinMessage(3,TraceStr);
       End;


       AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
       InitButton('   ~Ñ§´·•ú†   ',cmCancelFormat,PushButton,BfDefault);
       ButtonHelp('',0);


       SetIntVec( $1E, POldDDPT );
       Exit;
    End;



   SetIntVec( $1E, POldDDPT );

   FormatCompleted;
End;


Procedure TMyApp.Format;
Var
   ChkDrive     :Byte;
   Drive        :String;
   TraceStr     :String;
Begin

    ChkDrive:=GetDriveType(Byte(Conf.Drive));
    If ChkDrive=No_Drive Then
    Begin
       ErrorMessage('í¶ Drive ß¶¨ úß‚¢ú•ú™ ÉÑå ¨ß·®Æú†.',BfOk);
       Exit;
    End;

    Drive:=Conf.Density;

    If GetFormatParameter(Drive,ChkDrive,PData,LData) = False Then
    Begin
       ErrorMessage('íò õúõ¶£‚§ò ´û™ õ†ò£Ê®≠‡©û™ °ò† ´¶¨ éõûö¶¨ (Drive)'+#10+
                    'õú§ úÂ§ò† ©¨£ôò´·.'  ,BfOk);
       Exit;
    End;

    If DosLineParams=False Then
       CloseWindow;


    WinTextColor:=15;
    WinTextBackGround:=3;
    OpenWindow(5,4,73,22,'Format',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Shadow);
    Win^.CloseCommand:=cmCancelOrResume;
    If HeapErrorCode = 1 Then
       Exit;

    WriteTextColor:=15;
    WriteTextBackGround:=1;

    TextPaint(1,2,GetWindowMaxX-1,6,Shadow);
    TextBox(1,2,GetWindowMaxX-1,6,SingleLines);

    WriteTextBackGround:=5;
    TextPaint(1,8,GetWindowMaxX div 2,14,Shadow);
    TextBox(1,8,GetWindowMaxX div 2,14,SingleLines);

    WriteTextBackGround:=4;
    TextPaint((GetWindowMaxX div 2)+4,8,GetWindowMaxX-1,14,Shadow);
    TextBox((GetWindowMaxX div 2)+4,8,GetWindowMaxX-1,14,SingleLines);

    {************* Start of Info Box ******************}

    WriteTextColor:=10;
    WRiteTextBackGround:=1;

    If Conf.Verify=True Then
       TraceStr:='åòÂ'
    Else
       TraceStr:='éÆ†';

    WriteTextColor:=10;
    WriteWindow(2,3,'[ Verify      ]:');
    WriteTextColor:=15;
    WriteWindow(18,3,TraceStr);

    If Conf.DosOrQuick=1 Then
       TraceStr:='Quick Format'
    Else
       TraceStr:='Dos Format';


    WriteTextColor:=10;
    WriteWindow(2,4,'[ Format mode ]:');
    WriteTextColor:=15;
    WriteWindow(18,4,TraceStr);


    If Conf.System=1 Then
       TraceStr:='None'
    Else
    If Conf.System=2 Then
       TraceStr:='Leave Space'
    Else
       TraceStr:='Put System';


    WriteTextColor:=10;
    WriteWindow(2,5,'[ System      ]:');
    WriteTextColor:=15;
    WriteWindow(18,5,TraceStr);


    TraceStr:=Chr(WCDriveA1)+Chr(WCDriveA2)+Chr(WCDriveA3)+' Drive '+Chr(Conf.Drive+65);


    WriteTextColor:=10;
    WriteWindow(35,3,'[ Drive      ]:');
    WriteTextColor:=15;
    WriteWindow(50,3,TraceStr);

    TraceStr:=Conf.Density;

    WriteTextColor:=10;
    WriteWindow(35,4,'[ Density    ]:');
    WriteTextColor:=15;
    WriteWindow(50,4,TraceStr);

    WriteTextColor:=10;
    WriteWindow(35,5,'[ Label      ]:');
    WriteTextColor:=15;
    WriteWindow(50,5,Conf.DLabel);

    WriteTextColor:=14;
    WriteTextBackGround:=WinTextBackGround;
    CentreWinMessage(GetWindowMaxY,'è·´û©ú ´¶ ß¢„°´®¶ ESC ö†ò ò°Á®‡©û.');

    {************* Start of Progress box ****************************}

    WriteTextColor:=6;
    WriteTextBackGround:=7;
    R.InitProgressBar(2,11,30,0,PData.STrax-1);

    WriteTextColor:=15;
    WriteTextBackGround:=5;

    WriteWindow(2,9,'Track:00         Head:0');
    WriteWindow(2,13,'ï®¶§¶™ :  00:00');

    { Set Timer}

    TimerTicks:=0;
    TimerMinutes:=0;
    TimerSeconds:=0;

    TimerWinX:=Win^.X1;
    TimerWinY:=Win^.Y1;

    TimerWorking:=False;
    UserTimerInterruptPtr:=@FormatTime;
    UserInterrupt:=True;

    {Set Status Informations}

    WriteTextBackGround:=4;
    WriteWindow(40,9,'Total  Space       0 Kb');
    WriteWindow(40,10,'Bad    Space       0 Kb');
    WriteWindow(40,11,'-----------------------');
    WriteWindow(40,12,'Usable  Space      0 Kb');


    {************* Start of Status Box ****************************}



    {Set to Bios the appropriate Values}
    DiskPrepare(Byte(Conf.Drive),PData);

    {Get The Disk Drive Parameter Table}
    GetIntVec( $1E, POldDDPT );
    SetIntVec( $1E, PData.DDPT );

    DoFormat;


End;



Procedure TMyApp.ShowUpAnErrorMessage;
Var
   Buffer       :String[4];
   I            :Integer;
Begin

       Buffer:=Chr(Conf.Drive+65)+':\';

       WinTextColor:=15;
       WinTextBackGround:=4;
       OpenWindow(13,6,68,18,'',OpenFx+CloseFx+WinChars+Shadow+Movement);
       Win^.CloseCommand:=cmMainMenu;
       If HeapErrorCode = 1 Then
          Exit;

       WriteTextColor:=10;
       WriteTextBackGround:=WinTextBackGround;
       InfoBox(1,1,GetWindowMaxX,GetWindowMaxY-3,' Dos Critical Error ',14);

       WriteTextColor:=15;
       CentreWinMessage(3,'é ¶õûöÊ™ '+Buffer+' õú§ úÂ§ò† ‚´¶†£¶™ „');
       Str(CriticalErType,Buffer);
       CentreWinMessage(4,'°·ß¶†¶ ·¢¢¶ ¢·ü¶™ ‚Æú† ©¨£ôúÂ.');
       WriteTextColor:=7;
       CentreWinMessage(6,'Dos Report :  '+CriticalErrorMessage);

       AssignXY(Trunc( (GetWindowMaxX -Length('   Ñ§´·•ú†   ') ) / 2),GetWindowMaxY-1,0,0);
       InitButton('   ~Ñ§´·•ú†   ',cmMainMenu,PushButton,BfDefault);
       ButtonHelp('',0);

       CriticalError:=0;

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
      cmAskUserForFormat:AskUserForFormat;
      cmFormat     :Begin
                        CloseWindow;
                        Format;
                    End;
      cmAbout      :About;

      cmDrive      :Conf.Drive:=DropDownCurrentNum-1;
      cmDensity    :Begin
                      Conf.Density:=DropDownCurrentStr;
                      Conf.DriveNum:=DropDownCurrentNum;
                    End;
      cmLabel      :Conf.DLabel:=InputLineStr;
      cmVerify     :Conf.Verify:=Boolean(CheckBoxActive);
      cmVoice      :Conf.Voice:=Boolean(CheckBoxActive);
      cmDos        :Conf.DosOrQuick:=(RadioButtonCurrentNum-1);
      cmSystem     :Conf.System:=DropDownCurrentNum;
      cmCancelOrResume:AskUser;
      cmContinueFormat:Begin
                        CloseWindow;
                        UserInterrupt:=True;
                        MenuAskUser:=False;
                        DoFormat;
                       End;
      cmCancelFormat:Begin
                        CancelFor:=True;
                        UserInterrupt:=False;
                        UserTimerInterruptPtr:=Nil;
                        CloseWindow;
                        CloseWindow;
                        MainMenu;
                     End;
   End;
End;


Procedure TMyApp.About;
Var
   KBytes       :String;
Begin
      WinTextColor:=15;
      WinTextBackGround:=3;
      OpenWindow(12,2,66,23,'ëÆú´†°·',WinChars+OpenFx+CloseFx+CloseIcon+WinCharsWindow+Movement+Shadow);
      Win^.CloseCommand:=cmMainMenu;
      If HeapErrorCode = 1 Then
         Exit;

      Str(Round(MemAvail/1024),Kbytes);
      WriteTextColor:=15;
      WriteTextBackGround:=WinTextBackGround;
      CentreWinMessage(2,'Quick Format ');
      CentreWinMessage(3,'‚°õ¶©û 1.00a  * Evaluation *');
      CentreWinMessage(5,'(c) Copyright 1993,96  by Digital ToolWorks');
      WriteTextColor:=10;
      CentreWinMessage(7,'<< This program is NOT a Public Domain so any use >>');
      CentreWinMessage(8,'<< wihtout the written permission is illegal.>>');


      WriteTextColor:=14;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,12,GetWindowMaxX,17,' Hello again !! ',14);

      WriteTextColor:=1;
      CentreWinMessage(14,'˚ ìß·®Æ¶¨§ '+KBytes+'KB ©´¶ ©Á©´û£ò ú¢úÁüú®ò.');
      CentreWinMessage(15,'˚ Ü ‚°õ¶©û ´¶¨ Dos úÂ§ò† '+DosVer);


      AssignXY((GetWindowMaxX-Length('  ~Ñ§´·•ú† ')) div 2,GetWindowMaxY-1,0,0);
      InitButton('  ~Ñ§´·•ú† ',CmMainMenu,PushButton,BfDefault);
      ButtonHelp('',0);
End;



Procedure TMyApp.MainMenu;
Var
   I     :Byte;
   Count :Byte;
Begin
      WinTextColor:=15;
      WinTextBackGround:=1;
      OpenWindow(10,3,70,22,'Quick Format',WinChars+OpenFx+CloseFx+Shadow+Movement+CloseIcon+WinCharsWindow);
      If HeapErrorCode = 1 Then
         Exit;

      Win^.CloseCommand:=CmQuit;

      CancelFor:=False;
      TrackF:=0;
      SideNum:=0;
      MenuAskUser:=False;

      WriteTextColor:=7;
      WriteTextBackGround:=WinTextBackGround;
      InfoBox(1,2,GetWindowMaxX,11,' Ñß†¢¶ö‚™ É†ò£Ê®≠‡©û™ ',14);

      AssignXY(2,3,0,0);

      If Conf.DosOrQuick=1 Then
          InitRadioButton(NewRItem('~Dos Format',CmDos,'',NoCm,BfNormal,
                         NewRItem('~Quick Format',CmDos,'',NoCm,BfDefault,
                            Nil)))
      Else
          InitRadioButton(NewRItem('~Dos Format',CmDos,'',NoCm,BfDefault,
                         NewRItem('~Quick Format',CmDos,'',NoCm,BfNormal,
                            Nil)));



      InitText;
      For I:=0 to MaxDrives-1 do
          InsertText(' '+Chr(WCDriveA1)+Chr(WCDriveA2)+Chr(WCDriveA3)+' Drive '+Chr(65+I)+'  ',$FF,$FF);

      AssignXY(30,4,50,4+MaxDrives);
      InitDropDown(cmDrive);
      ShowDropDownText(GeneralHeadText,GeneralTailText,Byte(Conf.Drive)+1);
      DropDownLabel(30,3,'D~rive');
      DropDownHelp('',0);

      AssignXY(30,7,50,7);
      InitInputLine(cmLabel,11,Conf.DLabel);
      InputLineLabel(30,6,'~Label');
      InputLineHelp('',0);

      AssignXY(2,6,0,0);
      InitCheckBox('V~oice',cmVoice,Byte(Conf.Voice));
      CheckBoxHelp('',0);

      AssignXY(2,7,0,0);
      InitCheckBox('~Verify',cmVerify,Byte(Conf.Verify));
      CheckBoxHelp('',0);

      InitText;
      InsertText(' None ',$FF,$FF);
      InsertText(' Leave Space',$FF,$FF);
      InsertText(' Put System',$FF,$FF);

      AssignXY(3,10,20,13);
      InitDropDown(cmSystem);
      ShowDropDownText(GeneralHeadText,GeneralTailText,Conf.System);
      DropDownLabel(3,9,'~System');
      DropDownHelp('',0);

      InitText;
      Count:=0;
      For I:=1 to MaxDrives do
      Begin
          IF DrvInfo[I].Size=SDD_525 Then
          Begin
             InsertText(SDD_525,$FF,$FF);
             Inc(Count);
          End
          Else
          IF DrvInfo[I].Size=SHD_525 Then
          Begin
             InsertText(SHD_525,$FF,$FF);
             InsertText(SDD_525,$FF,$FF);
             Inc(Count,2);
          End
          Else
          IF DrvInfo[I].Size=SDD_35 Then
          Begin
             InsertText(SDD_35,$FF,$FF);
             Inc(Count);
          End
          Else
          IF DrvInfo[I].Size=SHD_35 Then
          Begin
             InsertText(SHD_35,$FF,$FF);
             InsertText(SDD_35,$FF,$FF);
             Inc(Count,2);
          End;

      End;

      AssignXY(30,10,50,10+Count);
      InitDropDown(cmDensity);
      ShowDropDownText(GeneralHeadText,GeneralTailText,Conf.DriveNum);
      DropDownLabel(30,9,'D~ensity');
      DropDownHelp('',0);


      AssignXY(2,13,0,0);
      InitButton('       ~Format          ',cmAskUserForFormat,PushButton,BfNormal);
      ButtonHelp('',0);

      AssignXY(2,15,0,0);
      InitButton('        ë~Æú´†°·        ',cmAbout,PushButton,BfNormal);
      ButtonHelp('',0);

      AssignXY(2,17,0,0);
      InitButton('        Ñ~•¶õ¶™         ',CmQuit,PushButton,BfDefault);
      ButtonHelp('',0);

      WriteTextColor:=11;
      WriteTextBackGround:=Win^.WTextBackGround;

      WriteWindow(28,13,'É†òõ†°ò©Âò õ†ò£Ê®≠‡©û™.');
      WriteWindow(28,15,'è¢û®¶≠¶®Âú™ °ò´ò©°ú¨ò©´„.');
      WriteWindow(28,17,'Ñ•¶õ¶™ ßÂ©‡ ©´¶ Dos.');



End;

Procedure PrintParams;
Begin
   TextColor(7);
   TextBackGround(0);
   Clrscr;

   TextColor(11);
   Writeln('QFormat  ver 1.00a,    Copyright (c) 1992,96 By Digital ToolWorks');
   TextColor(7);
   Writeln;
   Writeln('QFormat [Drive:] [Switches]');
   Writeln;
   Writeln('         Drive              Drive letter of disk to format.');
   Writeln('         /l:<Label>         Disk Label.');
   Writeln('         /v                 For verIfication.');
   Writeln('         /q                 Quick Format.');
   Writeln('         /s                 Put System Files.');
   Writeln('         /360               For 360Kb   DD.');
   Writeln('         /720               For 720Kb   DD.');
   Writeln('         /1.2               For 1.2Kb   HD.');
   Writeln('         /1.44              For 1.44Kb  HD.');
   Writeln('         /a                 For auto detect.');
   Writeln('         /Sound             Set Voice-Sound On');
   Writeln;

End;

Function CheckParameters :Boolean;
Begin
    If ParamCount>0 Then
    Begin
       DosLineParams:=True;

       If ParamStr(1)='/?' Then
       Begin

         PrintParams;

       End
       Else
       Begin

       End;

       CheckParameters:=True;
    End
    Else
      CheckParameters:=False;
End;

Procedure CheckSetDrives;
Var
   I    :Byte;
   Regs :Registers;
Begin
      For I:=0 to 3 do
      begin
        Regs.Ah:=$08;
        Regs.Dl:=I;
        Intr($13,Regs);
        Case Regs.BL of
              $01 :Begin
                      DrvInfo[I+1].DrvNum:=I;
                      DrvInfo[I+1].Size:=SDD_525;
                      Inc(MaxDrives);
                   End;
              $02 :Begin
                      DrvInfo[I+1].DrvNum:=I;
                      DrvInfo[I+1].Size:=SHD_525;
                      Inc(MaxDrives);
                   End;
              $03 :Begin
                      DrvInfo[I+1].DrvNum:=I;
                      DrvInfo[I+1].Size:=SDD_35;
                      Inc(MaxDrives);
                   End;
	      $04 :Begin
                      DrvInfo[I+1].DrvNum:=I;
                      DrvInfo[I+1].Size:=SHD_35;
                      Inc(MaxDrives);
                   End;
	      $05 :Begin
                      DrvInfo[I+1].DrvNum:=I;
                      DrvInfo[I+1].Size:=' '; {Not supported 2.88}
                      Inc(MaxDrives);
                   End;
            End;
      End;
End;

Var
   MyApp        :TMyApp;
   Params       :Boolean;

Begin
    CheckSetDrives;
    DosLineParams:=False;

    Conf.Drive:=0; {A:}
    Conf.DriveNum:=1;
    Conf.Density:=DrvInfo[1].Size;
    Conf.DLabel:='QFormat';
    Conf.Voice:=True;
    Conf.Verify:=False;
    Conf.DOSorQuick:=0;
    Conf.System:=1;

    DosFonts:=True;
    SetBackGround:=False;
    AllowDiskHelp:=True;

    Params:=CheckParameters;
    If Params=False Then
    Begin
      MyApp.Init;
      MyApp.MainMenu;
      MyApp.Run;
      MyApp.Done;
    End;
End.
