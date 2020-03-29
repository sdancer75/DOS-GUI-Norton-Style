;***************************************************************************
;                           ASM_INTS  ver 2.00
;
;A collection of asm routines that used in conjuction with the Pascal's code.
;The assembly routines for my Objects text oriented programs created in
;Turbo Pascal.
;
;-------------------------------------------------------------------------
;An object file .OBJ That contains the follow Public procedures :
;
; ---> A) InitNewInt16_NewInt9_Asm <----
;
;This routine replace the old interrupt 16h with a new one that clears Ctrl-C
;or Ctrl-Break symbols.It also intercept the hardware interrupt 09h.
;We use it with Turbo Pascal Code like this :
;
;{$L C:\.....< Path > .... \Asm_Ints.Obj}
;Procedure InitNewInt16_Asm;external;
;
; Begin
;            GetIntVec($16,OldInt16);
;            InitNewInt16_Asm;
;                    .
;                    . {Code}
;                    .
;            SetIntVec($16,OldInt16);
; End;
;
;
; -----> B) InitNewInt24 <-----
;
;This routine initialize my own interrupt 24h (Critical Error Interrupt)
;It used like the above and must called for Pascal's code like this:
;
;{$L C:\... < Path >...\Asm_Ints.Obj>
;Procedure InitNewInt24_Asm;external;
;
;--------------------------------------------------------------------------
;
;Programmed By    George Papaioannou Thessaloniki (c) copyright 1995
;
;
;**************************************************************************
;                   From here starts the programs
;**************************************************************************

Data Segment Word Public

 ;These variables are declareted in Pascal Code
 ;=============================================
 Extrn CriticalError :Word, CriticalErType :Word, CriticalInfo :Word

 ;---------------------------------------------------------------------
 ;Here goes nothing.It will joined with the Turbo Pascal's Data Segment
 ;---------------------------------------------------------------------

Data ends



Code Segment Public
     assume Cs:Code,Ds:Data


;----------------------- PUBLIC --------------------------------------------
Public InitNewInt16_NewInt9_Asm    ;Make the procedure public so we can have access
                                   ;into Turbo Pascal Code.
Public InitNewInt24_Asm            ;Public declaretion
;---------------------------------------------------------------------------


;---------------------- DATA ----------------------------------------------
OldInt16 dd ?       ;Interrupt 16h (Keyborad - Software)
OldInt09 dd ?       ;Interrupt 09h (Keyborad - Hardware)
OldInt24 dd ?       ;Interrupt 24h (Critical Error - Software)
;--------------------------------------------------------------------------

;**************************************************************************
;************************** INT 16H ***************************************
;**************************************************************************
NewInt16 Proc Far

    ;€¨® ¡¦ª œ¢œš®¦ª ˜¤ œ®¦¬£œ ˜¤˜£¦¤ž š ˜ §˜«ž£˜ §¢ž¡«¨¦¬ ã ˜¤ ¬§˜¨®œ  ž›ž
    ;§¢ž¡«¨¦ ©«¦¤ Keyboard Buffer.ƒž¢˜›ž œ˜¤ œ®¦¬£œ ¡˜¢œ©£˜ «à¤ SubFuction
    ;0h or 1h.„˜¤ ¦ AH<>1 and AH<>0 «¦«œ ­¬šœ «œ¢œ àª ¡˜  ¡˜¢œ©œ «ž¤ §˜¢ ˜
    ;¨¦¬« ¤˜.


    cmp ah,0             ;Check For Subfunction 0 of int16 ? (Read Char)
    je  DoTest           ;If yes do the check
    cmp ah,1             ;Check For Subfunction 1 of int16 ? (Read Char)
    je  DoTest           ;If yes do the check


    pushf
    call OldInt16        ;If any other subfunction then call old interrupt
    jmp Done

DoTest:

    ;Now we are sure that we have called the routine with the AH containing
    ;the values 1h or 0h

    cmp ah,0             ;Check for SubFuction 0 of Int 16
    jne Preview          ;If not then go to @Preview.Obviously we have SubFuction 1h

Wait_Ch: ;====== AH=0 of Int 16 ======
         ;Now we are sure that the AH contains the value 0h

    pushf                ;Call Old interrupt 16 and come back to continue
    call cs:OldInt16
    pushf
    call cs:TestCtrl_Break;Check for Ctrl-Break
    jnz Return           ;If ZF=0 Then no Ctrl-Break compination was pressed

    ;============ Ctrl-Break ? If Yes return Ctrl=ff and Ascii=0 =========

    mov ah,0ffh ;if ctrl-break don't wait because if you use mouse then will
    mov al,0h   ;freeze until another key will be pressed.
    jz  return
                ;If you don't use mouse then can use the follow three commands
                ;to wait for another key.

;    sub ah,ah  ;else go back and wait for a new enter
;    popf
;    jmp Wait_Ch

Return:
    popf
    jmp Done

Preview: ;==== AH=1 of Int 16 ===========
    ;At this point AH contains the value 1h
    ;Ah =1 int16 ==> Check for Character into the keyboard buffer
    ;It's the same with the command KeyPressed on Turbo Pascal

    pushf             ;Just call the original int
    call cs:OldInt16  ;Check Zero Flag. (ZF=1 no char avail,ZF=0 char is avail)
    je Done           ;If ZF=1 then exit from the handler
    pushf             ;else 1)Push Flags
    call cs:TestCtrl_Break ;2)Call the routine to check for Ctrl-Break
    jz Pop_Ch         ;If it's Ctrl-Break then set ZF and jmp to Pop_Ch to clear it
    popf              ;else walk as normal

Done:
    call cs:ClearKeybBuffer
    Iret              ;...and come back to the caller

Pop_Ch:  ;==== Clears the current character from the keyboard buffer
         ;by calling old int16 with ah,0

    popf
    mov ah,0       ;Ah:=0
    pushf
    call cs:OldInt16  ;Int 16h

    mov ah,1       ;Now check again for an available character
    jmp Preview

NewInt16 endp

;**************************************************************************
;Procedure ClearKeybBuffer
;It Called from My new int handler and all that
;it does is to set Keyboard buffer at memory positions
;0040h:001Ah and 0040h:001C with the value 001Eh which is
;the start of Keyboard buffer.With this trick we have successed
;to avoid the overflow of the keyboard buffer.So we'll never listen
;again the known noise from our keyboard.
;IMPORTANT NOTE:It must called from int9h handler because if cpu is busy Then
;               no int16 occurs with result the procedure becomes useless
;***************************************************************************

ClearKeybBuffer Proc Near

    push es
    push ax

    mov ax,0040h
    mov es,ax
    mov ax,001Eh
    mov es:[001Ah],ax
    mov es:[001Ch],ax

    pop ax
    pop es


    ret
ClearkeybBuffer endp

;***********************************************************************
;Procedure TextCtrl_Break
;Inputs  :None
;Returns :ZF=0 means No Ctrl-Break pressed,ZF=1 Yes Ctrl-Break pressed
;************************************************************************

TestCtrl_Break Proc Near

   cmp al,3     ;IF al=3 (Ctrl-C) then Set ZF and return
   je RetInst
   or al,al     ;IF al<>0 Then return with ZF=0
   jne RetInst
   cmp ah,3     ;Else check ah for scan code = 3
   je RetInst   ;IF yes then return with ZF=1
   or ah,ah     ;Check ah for zero value.If yes then Set ZF else clear ZF.

RetInst:
   ret
TestCtrl_Break endp

;*************************************************************************
;************************** INT 09H **************************************
;*************************************************************************
;Procedure NewInt09
;It's my new int09 Handler.It prevents keyboard buffer fullness.
;*************************************************************************

NewInt09 Proc Far

   push ax    ;push all registers that they will change
   push es
   pushf

   mov ax,0040h  ;Check Head and Tail keyboard buffer addresses,
   mov es,ax         ;to see if we have already a character into our buffer.
   mov ax,es:[001Ah]
   cmp ax,es:[001Ch]
   jnz NoOtherChar   ;If we have,then ignore it by jumping into NoOtherChar
                     ;Label.
   popf              ;Else call the original hardware interrupt.
   pop es
   pop ax
   jmp dword ptr cs:OldInt09

NoOtherChar:
   in  al,60h ;We must always read the scan code from port 60h to inform the 8042
   in  al,61h ;Now make a keyboard reset by setting the 7th bit in
   mov ah,al  ;port 61h
   or  al,80h ;Then just put the original byte into port 61h and continue
   out 61h,al ;normally
   xchg ah,al
   out 61h,al

   cli
   mov al,20h ;Inform PPI 8255a that he can continue his triggering to
   out 20h,al ;all hardware interrupts.

   popf       ;pop all registers that we have touched
   pop es
   pop ax

   iret       ;Back to caller
NewInt09 endp


;*******************************************************************
;Install int16h and int09h.
;A routine that intercept the original interrupt vectors and substitute
;with my own interrupts.
;********************************************************************



InitNewInt16_NewInt9_Asm Proc Far

       push ax
       push bx

       push es
       push ds

       ;*********************** INT 16h ************************

       mov ah,35h      ;Take address of the old Int 16
       mov al,16h
       int 21h

       mov word ptr cs:OldInt16,bx      ;Save it somewhere
       mov word ptr cs:OldInt16+2,es


       mov ah,25h           ;Now replace it with the new procedure
       mov al,16h
       push cs
       pop ds
       mov dx,Offset NewInt16
       int 21h

       ;*********************** INT 09h ***************************

       mov ah,35h      ;Take address of the old Int 09
       mov al,09h
       int 21h

       mov word ptr cs:OldInt09,bx      ;Save it somewhere
       mov word ptr cs:OldInt09+2,es


       mov ah,25h           ;Now replace it with the new procedure
       mov al,09h
       push cs
       pop ds
       mov dx,Offset NewInt09
       int 21h

       ;************************ Go out *******************************

       pop ds
       pop es

       pop bx
       pop ax

       retf

InitNewInt16_NewInt9_Asm endp

;***********************************************************************
;*************************** INT 24H ***********************************
;***********************************************************************

NewInt24 Proc Far

       push ds

       sti             ;enable interrupts

       push ax         ;Preserve ax
       mov  ax,Data
       mov  ds,ax
       pop  ax



       mov  CriticalError,1    ;The Flag the every piece of code is checking
       mov  CriticalErType,di  ;Type of the Error Code
       xchg ah,al              ;
       xor  ah,ah              ;
       mov  CriticalInfo,ax    ;Retry-Ignore-Fail and some other info

       mov al,3                ;Return with error code
                               ;YOU MUST ABSOLUTE RETURN AN ERROR CODE
                               ;'COS IF YOU DON'T THE PROGRAM HALTS
       pop ds

       Iret
NewInt24 endp

;**************************************************************************
;Install new interrupt handler for int24h (Critical Errors)
;Just make it to point to my Interrupt handler
;**************************************************************************

InitNewInt24_Asm Proc Far

       push ax
       push bx

       push es
       push ds

       ;*********************** INT 24h ************************

       mov ah,35h      ;Take address of the old Int 24
       mov al,24h
       int 21h

       mov word ptr cs:OldInt24,bx      ;Save it somewhere
       mov word ptr cs:OldInt24+2,es


       mov ah,25h           ;Now replace it with the new procedure
       mov al,24h
       push cs
       pop ds
       mov dx,Offset NewInt24
       int 21h

       ;************************ Go out *******************************

       pop ds
       pop es

       pop bx
       pop ax

       retf

InitNewInt24_Asm endp



Code ends

     end
