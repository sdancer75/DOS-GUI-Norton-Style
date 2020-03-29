{*********************************************************************}
{                        N E T F I L E                                }
{                                                                     }
{A Unit that takes care of all Netware file processing.               }
{                                                                     }
{Copyright 1996 by George Papaioannou                                 }
{*********************************************************************}

UNIT NetUnit;


INTERFACE


Uses Crt, Dos,WinInit;                        { Add CRT and DoS units }

Const
      {-- Types of file access available -----------------------------}

      fm_r    = 0;                                        { Read-only }
      fm_w    = 1;                                       { Write-only }
      fm_rw   = 2;             { Read and write in normal Pascal mode }

      {-- Types of file protection -----------------------------------}

      sm_comp = $00;         { Compatibility mode, no file protection }
      sm_rw   = $10;            { Read and write prohibited by others }
      sm_r    = $20;   { Read by others permitted, writing prohibited }
      sm_w    = $30;        { Reading and writing by others permitted }
      sm_no   = $40;        { All permitted, protected by record lock }

      {-- Possible errors during Procedure calls ---------------------}

      NE_OK            = $00;                              { No error }
      NE_FileNotFound  = $02;                 { Error: File not found }
      NE_PathNotFound  = $03;                 { Error: Path not found }
      NE_TooManyFiles  = $04;            { Error: Too many open files }
      NE_AccessDenied  = $05;          { Error: Access to file denied }
      NE_InvalidHandle = $06;            { Error: Invalid file handle }
      NE_AccessCode    = $07;            { Error: Illegal access code }
      NE_Share         = $20;             { Violation of Share rights }
      NE_Lock          = $21;      { Error while (un)locking a record }
      NE_ShareBuffer   = $24;                 { Share buffer overflow }

Var
   NetError : Integer;             { Error number from DoS interrupt }

Function ShareInst : Boolean;                      { Share installed? }

Function NetErrorMessage( Number : word ) : String;       { Error message }

Procedure NetReset(     FName  : String;                  { Open file }
                        AMode  : Integer;
                        RecS   : Word;
                    Var DFile );

Procedure NetRewrite(     FName  : String;            { Open new file }
                          AMode  : Integer;
                          RecS   : Word;
                      Var DFile );

Procedure NetClose( Var DFile );                         { Close file }

Function NetLock( Var DFile;                        { Lock file range }
                      RecNo  : longint;
                      RngNum : longint ) : Boolean;

Function NetUnlock( Var DFile;                    { Unlock file range }
                        RecNo  : longint;
                        RngNum : longint ) : Boolean;

Function Is_NetOpen( Var DFile ) : Boolean;           { Is file open? }

Function Is_NetWriteOk( Var DFile ) : Boolean; { Writing to file O.K. }

Function Is_NetReaDok( Var DFile ) : Boolean; { Reading from file O.K.}

{-- The Read, Write and Seek Procedures only work With files set in  -}
{-- input-output mode. The following Procedures must be used IF      -}
{-- files must be opened in other modes.                             -}

Procedure NetWrite( Var DFile;                      { Write to a file }
                    Var FData );

Procedure NetRead( Var DFile;                      { Read from a file }
                   Var FData );

Procedure NetSeek( Var DFile;                 { Position file pointer }
                       RecNo : Longint );

IMPLEMENTATION

Const
 {-- Function numbers for DoS calls -----------------------------}

      FCT_OPEN     = $3D;         { Function: Open file With handle   }
      FCT_CLOSE    = $3E;         { Function: Close file With handle  }
      FCT_CREATE   = $3C;         { Function: Create file With handle }
      FCT_WRITE    = $40;         { Function: Write to file           }
      FCT_READ     = $3F;         { Function: Read from file          }
      FCT_LSEEK    = $42;         { Function: Set file pointer        }
      FCT_REC_LOCK = $5C;         { Function: Record locking          }

      {-- Function & interrupt numbers for other interrupt calls -----}

      MULTIPLEX    = $2F;                       { Multiplex interrupt }
      FCT_SHARE    = $1000;                  { Install text for Share }

      {-- Turbo Pascal file identIFiers ------------------------------}

      fmClosed     = $D7B0;                             { File closed }
      fmInput      = $D7B1;                 { File opened for reading }
      fmOutput     = $D7B2;                 { File opened for writing }
      fmInOut      = $D7B3;     { File opened for reading and writing }

{*********************************************************************}
{* ShareInst   : Installs test for Share.                            *}
{* Input       : None                                                *}
{* Output      : TRUE IF Share is installed                          *}
{* Global Var. : NetError/W (error status after call)                *}
{*********************************************************************}

Function ShareInst : boolean;

Var regs   : registers;      { Processor registers for interrupt call }

Begin
 regs.ax := FCT_SHARE;                     { Test for installed Share }
 intr( MULTIPLEX, regs );                  { Call multiplex interrupt }
 ShareInst := ( regs.al = $FF );                      { Return result }
 NetError := NE_OK;                                        { No error }
End;

{*********************************************************************}
{* NetErrorMsg : Error message text.                                 *}
{* Input       : Error number                                        *}
{* Output      : Meaning                                             *}
{*********************************************************************}

Function NetErrorMessage( Number : word ) : string;

Var Sdummy : string;

Begin
  case Number of
    NE_OK            : NetErrorMessage := 'No error (Net Error Code = 0).';
    NE_FileNotFound  : NetErrorMessage := 'File not found (Net Error Code = 2h).';
    NE_PathNotFound  : NetErrorMessage := 'Path not found (Net Error Code = 3h).';
    NE_TooManyFiles  : NetErrorMessage := 'Too many files open (Net Error Code = 4h).';
    NE_AccessDenied  : NetErrorMessage := 'File access denied (Net Error Code = 5h).';
    NE_InvalidHandle : NetErrorMessage := 'Invalid file handle (Net Error Code = 6h).';
    NE_AccessCode    : NetErrorMessage := 'Illegal access code (Net Error Code = 7h).';
    NE_Share         : NetErrorMessage := 'Violation of Share rights (Net Error Code = 20h).';
    NE_Lock          : NetErrorMessage := 'Error during record lock (Net Error Code = 21h).';
    NE_ShareBuffer   : NetErrorMessage := 'Share buffer overflow (Net Error Code = 24h).';
    Else               Begin
                         Str( Number, Sdummy );
                         NetErrorMessage := TDosErrorMessage(Number);
                       End;
  End;

  NetError:=0;
End;

{*********************************************************************}
{* NetCreate   : Creates a file.                                     *}
{* Input       : Filename, opening mode, record size                 *}
{* Output      : Opened file                                         *}
{* Global Var. : NetError/W (error status after call)                *}
{*********************************************************************}

Procedure NetRewrite(     FName  : string;
                          AMode  : integer;
                          RecS   : word;
                      Var DFile );

Var regs   : registers;      { Processor registers for interrupt call }
    FName2 : string;                      { Filename for local access }

Begin
  FName2 := FName + #0;                   { Copy and prepare filename }
  With regs Do
    Begin
      ds := seg( FName2[ 1 ] );                     { Assign filename }
      dx := ofs( FName2[ 1 ] );
      ah := FCT_CREATE;                  { Function number: Open file }
      cx := 0 ;                                      { File attribute }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then         { Open successful? }
        Begin
          bx := ax;                           { Handle in register BX }
          ah := FCT_CLOSE;              { Function number: Close file }
          msDos( regs );
          IF ( ( flags and fcarry ) = 0 ) Then    { Close successful? }
            NetReset( FName, AMode, Recs, DFile )         { Open file }
          Else
            NetError := ax;                       { Note error number }
        End
      Else
        NetError := ax;                           { Note error number }
    End;
End;

{*********************************************************************}
{* NetReset    : Opens a specIFic file.                              *}
{* Input       : Filename, open mode, record size                    *}
{* Output      : Opened file                                         *}
{* Global Var. : NetError/W (error status after call)                *}
{*********************************************************************}

Procedure NetReset(     FName  : string;
                        AMode  : integer;
                        RecS   : word;
                    Var DFile );

Var regs : registers;        { Processor registers for interrupt call }

Begin
  FName := FName + #0;                    { Filename must End With #0 }
  With regs Do
    Begin
      ds := seg( FName[ 1 ] );                      { Assign filename }
      dx := ofs( FName[ 1 ] );
      ah := FCT_OPEN;                    { Function number: Open file }
      al := AMode;          { Status byte for access mode and locking }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then         { Open successful? }
        Begin
          NetError := NE_OK;                               { No error }
          With filerec( DFile ) Do
            Begin
              move( FName[ 1 ], filerec( DFile ).Name,     { Assign   }
                    length( FName ) );                     { filename }
              Handle := ax;                             { File handle }
              RecSize := RecS;                  { SpecIFy record size }
              case ( AMode and $0F ) of    { SpecIFy Pascal file mode }
                fm_r   : Mode := fmInput;
                fm_w   : Mode := fmOutput;
                fm_rw  : Mode := fmInOut;
              End;
            End;
        End
      Else
        Begin
          NetError := ax;                         { Note error number }
          filerec( DFile ).Mode := fmClosed;        { File not opened }
        End;
    End;
End;

{*********************************************************************}
{* NetClose  : Closes a file.                                        *}
{* Input     : File handle                                           *}
{* Output    : None                                                  *}
{*********************************************************************}

Procedure NetClose( Var DFile );

Var regs : registers;        { Processor registers for interrupt call }

Begin
  IF ( Filerec( DFile ).Mode <> fmClosed ) Then          { File open? }
    Begin
      With regs Do
        Begin
          ah := FCT_CLOSE;              { Function number: Close file }
          bx := FileRec( DFile ).Handle;                { File handle }
          msDos( regs );                             { Interrupt call }
        End;
      FileRec( DFile ).Mode := fmClosed;                 { Close file }
      NetError := NE_OK;                                   { No error }
    End
  Else
    NetError := NE_InvalidHandle;                     { File not open }
End;

{*********************************************************************}
{* Locking     : Locks or unlocks a file range.                      *}
{* Input       : File handle, operation, offset for start of file,   *}
{*               length of range to be (un)locked                    *}
{* Output      : TRUE IF successful                                  *}
{* Global Var. : NetError/W (error status after call)                *}
{* Info        : Call NetLock and NetUnlock for internal access only.*}
{*********************************************************************}

Function Locking( Handle    : word;
                  Operation : byte;
                  Offset    : longint;
                  WrdLen    : longint ) : boolean;

Var regs : registers;        { Processor registers for interrupt call }

Begin
  With regs Do
    Begin
      ah := FCT_REC_LOCK;        { Function number for interrupt call }
      al := Operation;                         { 0 = Lock, 1 = Unlock }
      bx := Handle;                                     { File handle }
      cx := offset shr 16;                         { High word offset }
      dx := offset and $FFFF;                       { Low word offset }
      si := WrdLen shr 16;                         { High word length }
      di := WrdLen and $FFFF;                       { Low word length }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then      { Locking successful? }
        Begin
          Locking := true;                                 { No error }
          NetError := NE_OK;
        End
      Else
        Begin
          Locking := false;
          NetError := ax;                         { Note error number }
        End;
    End;
End;

{*********************************************************************}
{* NetLock     : Locks records.                                      *}
{* Input       : File, record number, number of records to be locked *}
{* Output      : TRUE IF successful                                  *}
{* Global Var. : NetError/W (error status after call)                *}
{*********************************************************************}

Function NetLock( Var DFile;
                      RecNo  : longint;
                      RngNum : longint ) : boolean;

Begin
  NetLock := Locking( filerec( DFile ).Handle, 0,
                      filerec( DFile ).Recsize * RecNo,
                      filerec( DFile ).Recsize * RngNum );
End;

{*********************************************************************}
{* NetUnLock   : Unlocks locked records.                             *}
{* Input       : File, record number, number of records to be locked *}
{* Output      : TRUE IF successful                                  *}
{* Global Var. : NetError/W (error status after call)                *}
{*********************************************************************}

Function NetUnlock( Var DFile;
                        RecNo  : longint;
                        RngNum : longint ) : boolean;
Begin
  NetUnLock := Locking( filerec( DFile).Handle, 1,
                        filerec( DFile ).Recsize * RecNo,
                        filerec( DFile ).Recsize * RngNum );
End;

{*********************************************************************}
{* Is_NetWriteOk : Enables file output.                              *}
{* Input         : File                                              *}
{* Output        : TRUE IF output is enabled                         *}
{*********************************************************************}

Function Is_NetWriteOk( Var DFile ) : boolean;

Begin
  With Filerec( DFile ) Do
    Is_NetWriteOk := ( Mode = fmOutput ) or ( Mode = fmInOut );
End;

{*********************************************************************}
{* Is_NetReaDok : Enables file input.                                *}
{* Input        : File                                               *}
{* Output       : TRUE IF output is enabled                          *}
{*********************************************************************}

Function Is_NetReaDok( Var DFile ) : boolean;

Begin
  With Filerec( DFile ) Do
    Is_NetReaDok := ( Mode = fmInput ) or ( Mode = fmInOut );
End;

{*********************************************************************}
{* Is_NetOpen  : Opens file.                                         *}
{* Input       : File                                                *}
{* Output      : TRUE IF file is open                                *}
{*********************************************************************}

Function Is_NetOpen( Var DFile ) : boolean;

Begin
  With Filerec( DFile ) Do
    Is_Netopen := ( Mode = fmInput ) or ( Mode = fmOutput ) or
               ( Mode = fmInOut );
End;

{*********************************************************************}
{* NetWrite    : Writes to file.                                     *}
{* Input       : File, data                                          *}
{* Output      : None                                                *}
{* Info        : Output is only possible in Pascal Procedures when   *}
{*               files have been opened in input-output mode.        *}
{*               Attention: No type checking performed here.         *}
{*********************************************************************}

Procedure NetWrite( Var DFile;
                    Var FData );

Var regs : registers;        { Processor registers for interrupt call }

Begin
  With regs Do
    Begin
      ds := seg( FData );                              { Data address }
      dx := ofs( FData );
      ah := FCT_WRITE;                  { Function number: Write file }
      bx := filerec( DFile ).Handle;                    { File handle }
      cx := filerec( DFile ).Recsize;               { Number of bytes }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then        { Write successful? }
        NetError := NE_OK                                  { No error }
      Else
        NetError := ax;                           { Note error number }
    End;
End;

{*********************************************************************}
{* NetRead     : Reads from file.                                    *}
{* Input       : File, Variable for accessing data                   *}
{* Output      : Data                                                *}
{* Info        : Output is only possible in Pascal Procedures when   *}
{*               files have been opened in input-output mode.        *}
{*               Attention: No type checking performed here.         *}
{*********************************************************************}

Procedure NetRead( Var DFile;
                   Var FData );

Var regs : registers;        { Processor registers for interrupt call }

Begin
  With regs Do
    Begin
      ds := seg( FData );                              { Data address }
      dx := ofs( FData );
      ah := FCT_READ;                    { Function number: Read file }
      bx := filerec( DFile ).Handle;                    { File handle }
      cx := filerec( DFile ).Recsize;               { Number of bytes }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then        { Write successful? }
        NetError := NE_OK                                  { No error }
      Else
        NetError := ax;                           { Note error number }
    End;
End;

{*********************************************************************}
{* NetSeek     : Sets file pointer.                                  *}
{* Input       : File, record number                                 *}
{* Output      : None                                                *}
{* Info        : Output is only possible in Pascal Procedures when   *}
{*               files have been opened in input-output mode.        *}
{*********************************************************************}

Procedure NetSeek( Var DFile;
                       RecNo : longint );

Var regs : registers;        { Processor registers for interrupt call }

Begin
  With regs Do
    Begin
      ah := FCT_LSEEK;            { Function number: Set file pointer }
      al := 0;                  { Absolute position for start of file }
      bx := filerec( DFile ).Handle;                    { File handle }
      RecNo := RecNo * filerec( DFile ).Recsize;    { Offset in bytes }
      cx := RecNo shr 16;                          { High word offset }
      dx := recNo and $FFFF;                        { Low word offset }
      msDos( regs );                                 { Interrupt call }
      IF ( ( flags and fcarry ) = 0 ) Then        { Write successful? }
        NetError := NE_OK                                  { No error }
      Else
        NetError := ax;                           { Note error number }
    End;
End;

Begin

End.
