{***************************************************************************}
{UNIT ErrorDialogs                                                          }
{АдлабШЯайлЬа лак standard ижмладЬк New бШа GetMem                          }
{                                                                           }
{ПШзШарШдджм ВЬриЪажк     , ЗЬййШвждабЮ 1994                                }
{***************************************************************************}

Unit ErrorDlg;


INTERFACE

Uses Crt;

Const
   HeapPtr      :Pointer = Nil;

   {ОлШд ЫЮгажмиЪЮЯЬа бШзжаж вШЯжк ЬожмгЬ лЮд ЫмдШлжлЮлШ рШ бШвЬйжмгЬ гаШ}
   {жзжаШЫЮзжлЬ ЫабЮ гШк ижмладШ гЬ лЮд ЬеЮк ЫаШЫабШйаШ :                }
   { <$F+> Procedure MyProc <$F-> бШа ЬождлШк бШдЬа зижЮЪжмгЬджк лж ЬеЮк:}
   { HeapPtr:=@MyProc                                                    }

   HeapErrorCode:Byte    = 0;

 Function EDsGetMem(Node :Pointer; Size :Word) :Pointer;

IMPLEMENTATION


Function EDsGetMem(Node :Pointer; Size :Word) :Pointer;
Begin
    HeapErrorCode:=0;
    IF Size < MemAvail Then
    Begin
       GetMem(Node,Size);
       EdsGetMem:=Node;
    End
    Else
    Begin
       HeapErrorCode:=1;
       EdsGetMem:=Nil;
       IF HeapPtr<>Nil Then
         Asm;
           Call HeapPtr
         End;
    End;
End;

END.
