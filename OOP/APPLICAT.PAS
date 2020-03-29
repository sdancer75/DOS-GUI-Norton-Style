UNIT APPLICATIONOBJ;

INTERFACE

Uses WindowsObj,GeneralObj,MouseObj,PullDnMenus;
Const
    ExitFromProgram :Boolean = False;

Type
    Application = object (PullDownObj)
        Constructor Init;
        Procedure Run;
        Destructor Done;
    End;


IMPLEMENTATION

Constructor Application.Init;
Begin
    Application.InitViews;
    Application.InitPD;
    MouseInit;
    ShowMouseCursor;
End;

Procedure Application.Run;
Begin
   Repeat
       WaitForEvent;
       PDHandleEvent;
   Until (ExitFromProgram=True);
End;

Destructor Application.Done;
Begin
    DonePD;
    DoneViews;
    MouseDone;
    HiddenMouseCursor;
End;


End.

