{*************************************************************************}
{UNIT PULL DOWN MENUS.                                                    }
{èú®†úÆú† ¶¢ú™ ´†™ ®¶¨´†§ú™ ß¶¨ Æú†®†ù¶§´ò† ´ò pull down.                 }
{Ñò§ õú§ Æ®û©†£¶ß¶†¶¨§´ò† ©´¶ ß®¶ö®ò££ò õú§ ú†§ò† ò§òö°û §ò ´û ≠¶®´‡©¶¨£ú }
{       ========================================================          }
{èòßò†‡ò§§¶¨ Çú‡®ö†¶™        áú©©ò¢¶§†°û 1994                             }
{*************************************************************************}


UNIT PullDnMenus;

INTERFACE

Uses WindowsObj,VarConstObj,GeneralObj,MouseObj;

Const


    MenuWinCounter    :Byte = 0;

    OverFlowFlag      :Boolean = False;
    DataByte          :Byte = 0;
    PDCheckerOnOff    :Boolean = False;


Type



    PField=^Field;
    Field = record
        Name     :Str40;   {í†´¢¶™}
        Param    :Str10;   {èò®ò£ú´®¶†}
        Command  :Word;    {Ü ¢ú†´¶¨®ö†ò ß¶¨ ú°´ú¢ú†}
        Disabled :Boolean; {Ñ§ú®ö¶ „ ¶Æ†}
        KeyCode  :Word;    {Hot Key}
        HelpCtx  :^Str80;  {Ç®ò££û ß¢û®¶≠¶®†ò™}
        Help     :Word;    {â‡õ†°¶™ ô¶ûüú†ò™ £ú©ò ©ú ò®Æú†¶}
        Next     :PField;  {Ñß¶£ú§¶ node}
        Sub      :PField;  {sub to sub õ¶£û (†ú®ò®Æ†°û)}
    End;

    PPDMouseCoord = ^PDMouseCoord;
    PDMouseCoord  = record
        X1,Y1,X2,Y2 :Byte;   {ë¨§´ú´òö£ú§ú™}
        MainChoise,
        SubChoise   :Byte;   {Éú†°´ú™ ©´ò £ú§¨ ´‡§ ßò®òü¨®‡§}
        WinNum      :Byte;
        NextNode    :PPDMouseCoord; {Ñß¶£ú§¶ node}
    End;

    PullDownObj  = object (View)
      PDTextColor,                      {Text color}
      PDTextBackGround      :Byte;      {Text background}
      PDX1,PDY1,PDX2,PDY2   :Byte;      {Coordinates}
      PDWhichMain,PDWhichSub:Byte;      {Pointers}
      MaxMain,MaxSub        :Byte;      {Max main choises,current max sub choises}
      XOffset,YOffset       :Byte;      {Internal x,y coords.They moving all the time}
      PDParams              :Word;      {The parameters like shadow,move,winchars..}
      PDHeapMarker          :Pointer;   {Variable For the ReleaseMem procedure}


      PDHeadNode,PDSub,PDMain :PField;  {Pointers ©´†™ ¢†©´ú™}
      PDHeadSub               :PField;

      Procedure   InitPD;
      Procedure   DrawPDMenus;
      Procedure   InitMenuBar; Virtual;
      Procedure   HandleCommand; Virtual;

      Function    NewMenu(SubItem:PField) :PField;
      Function    NewSubMenu(Name:Str40; Command :Word; InHelpCtx:Str80; DiskHelp:Word; NextItem,NextMain :PField) :PField;
      Function    NewMoreSubs(SubItem:PField) :PField;
      Function    NewItem(Name :Str40; Param:Str10; KeyCode:Word; Command:Word; InHelpCtx:Str80; DiskHelp:Word;
                                                                          InNext :PField):PField;
      Function    NewLine(InNext :PField) :PField;
      Function    NewCheck(Name :Str40; Param:Str10; Command:Word; InHelpCtx:Str80; DiskHelp:Word; InNext :PField) :PField;
      Procedure   DisablePDMenus;
      Procedure   EnablePDMenus;

      Procedure   SearchList(Num :Byte;Var VarPField :PField);
      Procedure   ShowPullDnMenus;
      Procedure   PDHandleEvent;

      Procedure   DonePD;
    End;

    PPointerStackRec =^PointerStackRec;
    PointerStackRec  = Record
         Data     :Pointer;
         ExtraData:Integer;
         Next     :PPointerStackRec;
    End;

Const
    TopStackPointer  :PPointerStackRec =Nil;
Var
   MenuWin,MenuWinHead     :PWinFunc;
   PullDownCurX,
   PullDownCurY,
   PullDownSScanL,
   PullDownEScanL          :Byte;
   HiddenMouse             :Boolean;

Const
   PDMouseNodeHead         :PPDMouseCoord = Nil;
   PDMouseAccessVar        :PPDMouseCoord = Nil;
   OpenClosePDMenuFlag     :Boolean       = False;


IMPLEMENTATION

Procedure SetVirtPDCursorPositHeight(X1,Y1,SSL,ESL :Byte);
Begin
   IF (X1 <= (BiosColumns div 2)) and (X1 >= 0) and (X1 <= SetWindowX2)
      and (Y1 <= (BiosRows)) and (Y1 >= 0) and (Y1 <= SetWindowY2) Then
      Begin
          Dec(X1);Dec(Y1);
          SetCurPositionXY(X1,Y1);
          SetCurLength(SSL,ESL);
      End
   Else
      CurOff;
End;



Procedure PushPointer(Item :Pointer;ExtraD :Integer);
Var
   Node         :PPointerStackRec;
Begin
     New(Node);
     Node^.Data:=Item;
     Node^.ExtraData:=ExtraD;
     Node^.Next:=TopStackPointer;
     TopStackPointer:=Node;
End;



Procedure PopPointer(Var Item :Pointer;Var ExtraD :Integer);
Var
   Temp         :PPointerStackRec;
Begin
     IF TopStackPointer<>Nil Then
     Begin
       Item:=TopStackPointer^.Data;
       ExtraD:=TopStackPointer^.ExtraData;
       Temp:=TopStackPointer;
       TopStackPointer:=TopStackPointer^.Next;
       Dispose(Temp);
     End
     Else
       Item:=Nil;
End;


{*************************************************************************}
{Procedure OpenMenuWindow                                                 }
{Ñ•¨ßû®ú´û©û ö†ò pull Down Menus ßò®òü¨®ò                                 }
{*************************************************************************}

Procedure OpenMenuWindow(InX1,InY1,InX2,InY2 :Byte;InTitle :Str80;Params :Word);
Begin
      New(MenuWin);

      If MenuWinCounter=0 then
          MenuWinHead:=Nil;
      Inc(MenuWinCounter);

      MenuWin^.Init(InX1,InY1,InX2,InY2,InTitle,Params);

      IF ( (MouseX in [InX1..InX2+2]) or (MouseX+1 in [InX1..InX2+2]) ) AND
         ( (MouseY in [InY1..InY2+2]) or (MouseY+1 in [InY1..InY2+2]) ) Then
      Begin
          HiddenMouse:=True;
          HiddenMouseCursor;
      End;

      If (Params and Shadow) <> 0 Then
         MenuWin^.SaveArea(InX1,InY1,InX2+2,InY2+1)
      Else
         MenuWin^.SaveArea(InX1,InY1,InX2,InY2);

      IF (Params and OpenFx) <> 0 Then
          MenuWin^.OpenFxWin;

      MenuWin^.DrawPysFrameWin;
      ScrollUp(InX1+1,InY1+1,InX2-1,InY2-1,(InY2-1)-InY1,0+(WinTextBackGround shl 4)+WinTextBackGround);

      IF (Params and Shadow) <> 0 Then
          MenuWin^.DrawShadowWin;

      MenuWin^.WinNumber:=MenuWinCounter;

      IF HiddenMouse Then
      Begin
          ShowMouseCursor;
          HiddenMouse:=False;
      End;

      MenuWin^.Next:=MenuWinHead;
      MenuWinHead:=MenuWin;
End;


{*********************************************************************}
{Procedure CloseMenuWindow                                            }
{â¢ú†§ú† ú§ò pull Down Menu ßò®òü¨®¶                                  }
{*********************************************************************}

Procedure CloseMenuWindow;
Var
   Temp         :PWinFunc;
Begin
    IF MenuWin <> Nil Then
    Begin
      Dec(MenuWinCounter);

      IF ( (MouseX in [MenuWin^.BX1..MenuWin^.BX2]) or (MouseX+1 in [MenuWin^.BX1..MenuWin^.BX2]) ) AND
         ( (MouseY in [MenuWin^.BY1..MenuWin^.BY2]) or (MouseY+1 in [MenuWin^.BY1..MenuWin^.BY2]) ) Then
      Begin
          HiddenMouseCursor;
          HiddenMouse:=True;
      End;

      MenuWin^.RestoreArea;

      IF HiddenMouse Then
      Begin
          ShowMouseCursor;
          HiddenMouse:=False;
      End;

      Temp:=MenuWin^.Next;
      Dispose(MenuWin);
      MenuWin:=Temp;
      MenuWinHead:=Temp;
    End;
End;

{**********************************************************************}
{Procedure SearchList                                                  }
{ñòÆ§ú† ö†ò £†ò ¢†©´ò ´¨ß¶¨ PField - Mo§¶§ ö†ò Pull Down Menus         }
{**********************************************************************}

Procedure PullDownObj.SearchList(Num :Byte;Var VarPField :PField);
Var
   Counter  :Byte;
Begin
  VarPField:=PDHeadNode;
  Counter:=0;

  Repeat
    Inc(Counter);

    If (VarPField<>Nil) and (Num<>Counter) then
        VarPField:=VarPField^.Next;

   Until (VarPField=Nil) OR (Num=Counter);

   IF Counter<>Num then
      VarPField:=Nil;

End;

{********************************************************************}
{Constructor Init                                                    }
{Ä®Æ†°¶ß¶†û©û ´‡§ Pull Down Menus                                    }
{********************************************************************}

Procedure PullDownObj.InitPD;
Begin

   IF WindowCounter=0 Then
   Begin
       PDX1:=1;PDY1:=1;
       PDX2:=BiosColumns div 2;PDY2:=BiosRows;
   End;

   PDWhichMain:=1;        {Ü Main õú†Æ§ú† ©´û§ ß®‡´û úß†¢¶öû}
   PDWhichSub:=1;         {Ü Sub ßò§´ò üò õú†Æ§ú† ©´û ß®‡´û úß†¢¶öû ´û™ Main}
   MaxMain:=0;            {O £úö†©´¶™ ´‡§ MaxMain üò ô®úüú† ò®ö¶´ú®ò}
   YOffset:=PDY1+1;       {Y coord for the subchoise}
   XOffset:=PDX1+PDSpace; {X coord for the  > >     }
   CommandsArray:=[];     {Ç†ò disable choises}
   InitHelpCtx:='';       {Ä®Æ†°¶ £¨§û£ò ö†ò ´¶ status line}
   PDTextColor:=0;        {Text Color}
   PDTextBackGround:=6;   {BackGround Color}
   PDParams:=WinChars;    {Parametres}
   CurrentHelpPtr:=0;
   AccessPDMenus:=True;
   ClearEvent;
   Mark(PDHeapMarker);
End;

Procedure PullDownObj.DrawPDMenus;
Begin

   IF AccessPDMenus = True Then
   Begin
     IF MonoCard Then
        PDParams:=PDParams and Not(Shadow);

     WinTextColor:=PDTextColor;
     WinTextBackGround:=PDTextBackGround;
     WriteTextBackGround:=PDTextBackGround;
     WriteTextColor:=PDTextColor;

     ShowPullDnMenus;

     PDMain:=PDHeadNode;
     PDSub:=PDMain^.Sub;
     ValidY1Coord:=PDY1;
   End;

End;


{*******************************************************************}
{Procedure InitMenuBar                                              }
{èú®ò©£ò ßò®ò£ú´®‡§ òß¶ ´û§ virtual procedure InitMenuBar ß¶¨ õ†§ú† }
{¶ Æ®û©´û™ òß¶ ´¶ °¨®†‡™ ß®¶ö®ò££ò                                  }
{*******************************************************************}

Procedure PullDownObj.InitMenuBar;
Begin
  {We haven't Pull Down Menus,So make the big step and adjust anything}
  {that program takes in mind.                                        }

  AccessPDMenus:=False;    {Disable Pull Down Menus}


  SetWindowX1:=1;
  SetWindowY1:=0;
  SetWindowX2:=(BiosColumns div 2);

  IF AllowHelpCtx = False Then
     SetWindowY2:=BiosRows
  Else
     SetWindowY2:=BiosRows-1;
End;


Procedure PullDownObj.HandleCommand;
Begin

End;

{*********************************************************************}
{Function NewMenu                                                     }
{Éû£†¶¨®öú† ú§ò ßúõ†¶ ´¨ß¶¨ PField ´¶ ¶ß¶†¶ õú†Æ§ú† ©ú £†ò ©ú†®ò Node }
{´ò ¶ß¶†ò úÆ¶¨§ õû£†¶¨®öûüú† òß¶ ´†™ :NewItem,NewLine,NewCheck °ò†    }
{úß†©´®ú≠ú† ´¶§ õú†°´û ´¶¨ ßúõ†¶¨ ß¶¨ úÆú† õû£†¶¨®öû©ú†.              }
{ë´û§ ßú®†ß´‡©û ß¶¨ úÆ¶¨£ú  Sub to Sub construction ´¶ß¶üú´ú† ´¶ ©¨£ô¶}
{¢¶  (* > *   Next Sub Menu) ©´¶ ßúõ†¶ Param                          }
{*********************************************************************}

Function PullDownObj.NewMenu;
Var
    Temp        :PField;
    ArrowChar   :Char;
{***********************************************************************}
{Procedure MakeSameLenAllSubMenus                                       }
{âò§ú† ¶¢¶¨™ ´¶¨™ ´†´¢¶¨™ †©¶¨™ £ú ´¶ £úö†©´¶ ©ú £†°¶™ ´†´¢¶            }
{***********************************************************************}

Procedure MakeSameLenAllSubMenus;
Var
   MaxLen       :Byte;
   Result,I     :Byte;
   Temp         :PField;
   FillChr      :Byte;

Function RealLength(Name :String) :Byte;
Var
    Res    :Byte;
Begin
     Res:=Pos('~',Name);
     IF Res=0 Then
        RealLength:=Length(Name)
     Else
        RealLength:=Length(Name)-1;
End;

Begin

    IF (PDSub^.Sub <> Nil) or (PDSub^.Next <> Nil) Then
    Begin

      {Ñò§ ¨ßò®Æú† °òß¶†¶ submenu ´¶´ú ô®ú™ ß¶†¶ ú†§ò† ´¶ £úöò¢¨´ú®¶}
      {£û°¶™ òß¶ ¶¢ò ´ò submenu °ò† °®ò´û©ú ´¶ ©´û§ £ú´òô¢û´û MaxLen}

       IF NewMoreSubsFlag>0 Then
          Temp:=PDSub^.Next
       Else
          Temp:=PDSub^.Sub;

       MaxLen:=RealLength(Temp^.Name);
       MaxLen:=MaxLen+Length(Temp^.Param);

       Repeat
          IF Temp<>Nil Then
          Begin

            Result:=RealLength(Temp^.Name);
            Result:=Result+Length(Temp^.Param);

            IF MaxLen < Result Then
               MaxLen:=Result;
            Temp:=Temp^.Sub;
          End;
       Until Temp=Nil;

       {Ä®Æ†ù¶¨£ú •ò§ò òß¶ ´û§ ò®Æû.Ñò§ ´¶ ´®úÆ¶§ submenu ú†§ò† £†-}
       {°®¶´ú®¶ òß¶ ´¶ MaxLen ´¶´ú ß®¶©üú©ú °ú§ò                   }

       Inc(MaxLen,2);

       IF NewMoreSubsFlag>0 Then
          Temp:=PDSub^.Next
       Else
          Temp:=PDSub^.Sub;

       Repeat
          IF Temp<>Nil Then
          Begin
             Result:=RealLength(Temp^.Name);
             Result:=Result+Length(Temp^.Param);

             IF Result < MaxLen Then
             Begin
                Result:=MaxLen - Result;
                IF Temp^.Name=Chr(PDLineFill) Then
                    FillChr:=PDLineFill
                Else
                    FillChr:=32;
                For I:=1 to Result do
                    Temp^.Name:=Temp^.Name+Chr(FillChr);
             End;
             Temp:=Temp^.Sub;
          End;
       Until Temp=Nil;

       IF NewMoreSubsFlag>0 Then
          Temp:=PDSub^.Next
       Else
          Temp:=PDSub^.Sub;


       Repeat
           IF Temp<>Nil Then
           Begin
               IF Temp^.KeyCode<>$FFFF Then
                  Temp^.Name:=Temp^.Name+Temp^.Param
               Else
                  Temp^.Name:=Temp^.Name+' ';
               Temp:=Temp^.Sub;
           End;
       Until Temp=Nil;
     End;

End;

Begin
     New(PDSub);
     PDSub^.Next:=Nil;
     PDSub^.Sub:=Nil;

     IF NewMoreSubsFlag>0 Then
     Begin
        PDSub^.Next:=SubItem;
         IF VgaExist=False Then
            ArrowChar:=Chr(SCRightArrow)
         Else
            ArrowChar:=Chr(WCRightPoint);

         PDSub^.Param:=ArrowChar;
         PDSub^.KeyCode:=$FF;
     End
     Else
        PDSub^.Sub:=SubItem;


     MakeSameLenAllSubMenus;

     NewMenu:=PDSub;
End;

{*********************************************************************}
{Function NewSubMenu                                                  }
{Çú£†ùú† ´ò ßúõ†ò ß¶¨ úÆú† õû£†¶¨®öû©ú† £†ò NewMenu ©¨§ò®´û©û °ò† ´¶ß¶}
{üú´ú† ´¶§ õú†°´û PDSub.Next §ò õú†Æ§ú† ©´¶ ß®¶ûö¶¨£ú§¶ NewSubMenu    }
{*********************************************************************}

Function PullDownObj.NewSubMenu;
Begin
     PDSub:=NextItem;
     PDSub^.Name:=Name;
     PDSub^.Command:=Command;
     PDSub^.Disabled:=False;
     PDSub^.Help:=DiskHelp;

     IF InHelpCtx<>'' Then
     Begin
       New(PDSub^.HelpCtx);
       PDSub^.HelpCtx^:=InHelpCtx;
     End
     Else
       PDSub^.HelpCtx:=Nil;

     IF NewMoreSubsFlag>0 Then
     Begin
         Dec(NewMoreSubsFlag);
         PDSub^.Sub:=NextMain
     End
     Else
     Begin
         PDSub^.Param:='';
         Inc(MaxMain);
         PDSub^.Next:=NextMain;
     End;


     NewSubMenu:=NextItem;
End;

{**********************************************************************}
{Function NewMoreSubs                                                  }
{ï®û©†£¶ß¶†û´ò† ©ò§ ß®‡´û õ†ò´òöû £ú´ò ´û§ NewMenu( ö†ò §ò õû¢‡©ú† ©´¶ }
{ß®¶ö®ò££ò ¶´† úÆ¶¨£ú Sub to Sub õ¶£û                                  }
{**********************************************************************}

Function PullDownObj.NewMoreSubs;
Begin
    Inc(NewMoreSubsFlag);
    NewMoreSubs:=PDSub;
End;

{**********************************************************************}
{Function NewItem                                                      }
{Éû£†¶¨®öú† ú§ò Node ´¨ß¶¨ PField °ò† ´¶ß¶üú´ú† ¶¢ú™ ´†™ ßò®ò£ú´®¶¨™   }
{ß¶¨ õ†§¶¨£ú ©´ò ßúõ†ò ´¶¨ Node.ÑÆú† ´ò ú•û™ ßúõ†ò :                   }
{   Name (´†´¢¶™) ,Command (´û§ õ†ò´òöû ß¶¨ üò ú°´ú¢ú©ú† £ú´ò ´¶ Enter)}
{   Disabled (Ñ§ú®ö¶ „ ¶Æ†), KeyCode (HotKey), HelpCtx (HelpLine),     }
{   Param (ßò®ò£ú´®¶† ¶ß‡™ 'F4')                                       }
{**********************************************************************}

Function PullDownObj.NewItem;
Begin
     New(PDSub);                   {Ä®Æ†°¶ß¶†û©û °ò† ú†©òö‡öû ßúõ†‡§}
     PDSub^.Name:=Name;
     PDSub^.Command:=Command;
     PDSub^.Disabled:=False;
     PDSub^.KeyCode:=KeyCode;
     PDSub^.Help:=DiskHelp;
     PDSub^.Next:=Nil;
     IF InHelpCtx='' Then
        PDSub^.HelpCtx:=Nil
     Else
     Begin
       New(PDSub^.HelpCtx);
       PDSub^.HelpCtx^:=InHelpCtx;
     End;
     PDSub^.Param:=Param;


     PDSub^.Sub:=InNext;     {Pointer ©´¶ úß¶£ú§¶}
     NewItem:=PDSub;
End;

{**********************************************************************}
{Function NewLine                                                      }
{Éû£†¶¨®öú† £†ò ö®ò££û õ†òÆ‡®†©û™ ©´¶ Pull Down Menu (Divider Line)    }
{**********************************************************************}


Function PullDownObj.NewLine;
Begin
     New(PDSub);
     PDSub^.Name:=Chr(PDLineFill);
     PDSub^.Command:=$0000;
     PDSub^.Disabled:=False;
     PDSub^.KeyCode:=$0000;
     PDSub^.Param:='';
     PDSub^.HelpCtx:=Nil;
     PDSub^.Next:=Nil;
     PDSub^.Sub:=InNext;

     NewLine:=PDSub;

End;

{***********************************************************************}
{Function NewCheck                                                      }
{Éû£†¶¨®öú† £†ò ú§´¶¢û ´©ú°ò®†©£ò´¶™ ©´¶ Pull Down Menu                 }
{***********************************************************************}

Function PullDownObj.NewCheck;
Begin
     New(PDSub);
     PDSub^.Name:=Name;
     PDSub^.Command:=Command;
     PDSub^.Disabled:=False;
     PDSub^.Help:=DiskHelp;

     {Ñò§ ´¶ Param ú†§ò† ´¶ °ú§¶ ´¶´ú úÆ¶¨£ú ò®Æ†°û ú£≠ò§†©û Æ‡®†™ check}
     {ò¢¢†‡™ ú£≠ò§†©ú ´¶ ©¨£ô¶¢¶-check.                                 }

     PDSub^.KeyCode:=$0;
     PDSub^.Param:=Chr(PDCheckSyb);

     IF Param = '' Then
        PDSub^.KeyCode:=$FFFF;

     PDSub^.Next:=Nil;

     IF InHelpCtx='' Then
        PDSub^.HelpCtx:=Nil
     Else
     Begin
       New(PDSub^.HelpCtx);
       PDSub^.HelpCtx^:=InHelpCtx;
     End;
     PDSub^.Sub:=InNext;

     NewCheck:=PDSub;
End;

{***********************************************************************}
{Procedure DisablePDMenus                                               }
{Äßú§ú®ö¶ß¶†û¶¨£ú °òüú úß†¢¶öû ´‡§ Pull Down Menus                      }
{***********************************************************************}

Procedure PullDownObj.DisablePDMenus;
Begin
    AccessPDMenus:=False;
End;


{***********************************************************************}
{Procedure EnablePDMenus                                                }
{ãß¶®¶¨£ú §ò ú§ú®ö¶ß¶†û©¶¨£ú ¶ß¶†òõûß¶´ú úß†¢¶öû ´‡§ Pull Down Menus    }
{***********************************************************************}

Procedure PullDownObj.EnablePDMenus;
Begin
    AccessPDMenus:=True;
End;


{**********************************************************************}
{Destructor Done                                                       }
{Äß¶õú©£ú¨ú† ´û§ £§û£û ´‡§ Pull Down Menus £ú ´û§ Release ú§´¶¢û.Ü Mark}
{ô®†©°ú´ò† ©´û§  Init Procedure.                                       }
{**********************************************************************}

Procedure PullDownObj.DonePD;
Begin
    Release(PDHeapMarker);
End;

{**********************************************************************}
{Procedure ShowPullDnMenus                                             }
{Ñ£≠ò§†©û ©´û§ ¶ü¶§û ´û Menu Bar,Main Choises and HelpLine             }
{**********************************************************************}

Procedure PullDownObj.ShowPullDnMenus;
Var
   HX1,HX,I             :Byte;
   TakeChar             :String[1];
   HiLight              :Boolean;
   Count                :Byte;

Begin

    WriteTextColor:=PDTextColor;
    WriteTextBackGround:=PDTextBackGround;

    HX1:=PDX1;

    HiddenMouseCursor;
    For I:=PDX1 to PDX2 do
    Begin
        WriteChar(I,PDY1,PDTextColor,PDTextBackGround,32);
        IF AllowHelpCtx Then
           WriteChar(I,PDY2,PDTextColor,PDTextBackGround,32);
    End;

    Count:=0;
    HX1:=PDX1+PDSpace;
    PDMain:=PDHeadNode;
    Repeat
           IF PDMain<>Nil then
           Begin
               Inc(Count);
               HiLight:=False;
               HX:=HX1;

               {Ñò§ ¶Æ† ú§ú®öû û õ†ò´òöû ´¶´ú °ò§ú ´û§ ú©‡´ú®†°û ßò®ò£ú´®¶}
               {True = disable °ò† ôöò¢ú ´¶ òß¶ ´¶§ ß†§ò°ò.               }

               IF PDMain^.Command in CommandsArray Then
               Begin
                    PDMain^.Disabled:=True;
                    EnableCommand([PDMain^.Command]);
               End;

               For I:=1 To Length(PDMain^.Name) do
               Begin
                    TakeChar:=Copy(PDMain^.Name,I,1);

                    IF TakeChar[1]='~' Then
                    Begin
                       TakeChar:=Copy(PDMain^.Name,I+1,1);
                       IF PDMain^.Disabled = False Then
                         WriteChar(HX,PDY1,MarkCharFgColor,PDTextBackGround,Ord(TakeChar[1]))
                       Else
                         WriteChar(HX,PDY1,DisableColor,PDTextBackGround,Ord(TakeChar[1]));
                       I:=I+1;
                       HiLight:=True;
                    End
                    Else
                       IF PDMain^.Disabled = False Then
                          WriteChar(HX,PDY1,PDTextColor,PDTextBackGround,Ord(TakeChar[1]))
                       Else
                          WriteChar(HX,PDY1,DisableColor,PDTextBackGround,Ord(TakeChar[1]));
                    Inc(HX);
               End;

               {Set Mouse Coordinates for The main menus}

               New(PDMouseAccessVar);
               PDMouseAccessVar^.Y1:=PDY1;
               PDMouseAccessVar^.Y2:=PDY1;
               PDMouseAccessVar^.X1:=HX1-Round(PDSpace/2);
               PDMouseAccessVar^.X2:=HX1+Length(PDMain^.Name)+Round(PDSpace/2);
               PDMouseAccessVar^.MainChoise:=Count;
               PDMouseAccessVar^.SubChoise:=0;
               PDMouseAccessVar^.WinNum:=0;
               PDMouseAccessVar^.NextNode:=PDMouseNodeHead;
               PDMouseNodeHead:=PDMouseAccessVar;

               IF HiLight=False Then
                  HX1:=HX1+Length(PDMain^.Name)+PDSpace
               Else
                  HX1:=HX1+Length(PDMain^.Name)+PDSpace-1;


              PDMain:=PDMain^.Next;
           End;
    Until  PDMain=Nil;

    {E£≠ò§†©ú ´¶ initiall status line úò§ ´¶ õ‡©ò£ú ò¢¢†‡™ ´¨ß‡©ú °ú§ò}

    WriteTextColor:=StatLineTxtColor;
    WriteTextBackGround:=StatLineBckColor;
    WriteOut(StatLineStartChar,PDY2,Copy(InitHelpCtx,1,StatLineMaxChars-StatLineStartChar+1));

    IF StatLineMaxChars >= StatLineStartChar+Length(InitHelpCtx) Then
      For I:=StatLineStartChar+Length(InitHelpCtx) to StatLineMaxChars do
          WriteChar(I,PDY2,StatLineTxtColor,StatLineBckColor,32);
    ShowMouseCursor;
End;

{**********************************************************************}
{Procedure PullDownObj.PDHandleEvent;                                  }
{èú®†úÆú† õ¨¶ ôò©†°ú™ ®¶¨´†§ú™ :                                       }
{         Procedure PDHandleKbEvent;                                   }
{         Procedure PDHandleMsEvent;                                   }
{**********************************************************************}

Procedure PullDownObj.PDHandleEvent;

{**********************************************************************}
{Procedure ReverseColor                                                }
{Ä§´†©´®ú≠ú† ´ò Æ®‡£ò´ò ©¨£≠‡§ò £ú ´û§ £ú´òô¢û´û PDRevColor            }
{**********************************************************************}

Procedure ReverseColor(InX1,InY1:Byte;InStr :Str40;TxtColor :Byte);
Var
   I        :Byte;
   TakeChar :String[1];
Begin
   IF ( (MouseX in [InX1..InX1+Length(InStr)]) or (MouseX+1 in [InX1..InX1+Length(InStr)]) ) AND
      ( (MouseY = InY1) or (MouseY+1 = InY1) ) Then
   Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
   End;

   WriteChar(InX1-1,InY1,TxtColor,PDRevBckColor,32);

   For I:=1 To Length(InStr) do
   Begin
       TakeChar:=Copy(InStr,I,1);
       IF TakeChar[1]='~' Then
       Begin
          TakeChar:=Copy(InStr,I+1,1);
          WriteChar(InX1,InY1,MarkCharFgColor,PDRevBckColor,Ord(TakeChar[1]));
          I:=I+1;
       End
       Else
          WriteChar(InX1,InY1,TxtColor,PDRevBckColor,Ord(TakeChar[1]));

       Inc(InX1);
   End;
   WriteChar(InX1,InY1,TxtColor,PDRevBckColor,32);


   IF HiddenMouse Then
   Begin
       ShowMouseCursor;
       HiddenMouse:=False;
   End;
End;

{**********************************************************************}
{Procedure NormalColor                                                  }
{Ñßò§ò≠ú®ú† ´ò Æ®‡£ò´ò ©´û§ ò®Æ†°û °ò´ò©´ò©û ©¨£≠‡§ò £ú ´†™ £ú´òô¢û´ú™ }
{ PDTextColor °ò† PDTextBackGround                                     }
{**********************************************************************}

Procedure NormalColor(InX1,InY1:Word;InStr :Str40;TxtColor,BckColor :Byte);
Var
   AsmSt        :Str40;
   STSeg        :Word;
   STOfs        :Word;
Begin

   AsmSt:=InStr;
   STSeg:=Seg(AsmSt);
   STOfs:=Ofs(AsmSt);
   IF ( (MouseX in [InX1..InX1+Length(InStr)]) or (MouseX+1 in [InX1..InX1+Length(InStr)]) ) AND
      ( (MouseY = InY1) or (MouseY+1 = InY1) ) Then
   Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
   End;

   {***************************************************************************
   HiddenMouseCursor;
   WriteChar(InX1-1,InY1,TxtColor,BckColor,32);

   For I:=1 To Length(InStr) do
   Begin
       TakeChar:=Copy(InStr,I,1);
       IF TakeChar[1]='~' Then
       Begin
          TakeChar:=Copy(InStr,I+1,1);
          WriteChar(InX1,InY1,MarkCharColor,BckColor,Ord(TakeChar[1]));
          I:=I+1;
       End
       Else
          WriteChar(InX1,InY1,TxtColor,BckColor,Ord(TakeChar[1]));

       Inc(InX1);
   End;

   WriteChar(InX1,InY1,TxtColor,BckColor,32);
   ShowMouseCursor;
   *****************************************************************************}

   Asm;
     push ds

     dec  Inx1
     dec  Iny1

     mov dh,MarkCharFgColor

     mov ax,VideoSeg
     mov es,ax

     mov ax,BiosColumns
     mov bx, word ptr Iny1

     push dx
     mul bx               {AX=AX*BX = 80 * Y1-1}
     pop dx


     mov bx,word ptr Inx1 {X offset            }
     shl bx,1             {BX=BX*2             }

     add ax,bx            {Now we have the real coords X,Y}

     {Ax points the start in to the video Buffer          }
     mov di,ax

     mov ah,BckColor

     shl ah,1
     shl ah,1
     shl ah,1
     shl ah,1

     or ah,TxtColor

     mov bx,StSeg      {ST[0]=Length                   }
     mov ds,bx
     mov bx,StOfs
     xor cx,cx
     mov cl,[bx]

     inc bx
     mov si,bx
     Cld

     mov al,32
     mov es:[di-2],al
     mov es:[di-1],ah

 @LoopCont:
     lodsb
     cmp al,'~'
     jz  @ShortCut
     mov es:[di],al
     mov es:[di+1],ah
     inc di
     inc di
 @Cont:
     loop @LoopCont
     jmp @Finish

 @ShortCut:
     lodsb
     push ax

     mov ah,BckColor

     shl ah,1
     shl ah,1
     shl ah,1
     shl ah,1

     or ah,dh

     mov es:[di],al
     mov es:[di+1],ah
     inc di
     inc di
     dec cx
     pop ax
     jmp @Cont

 @Finish:
     mov al,32
     mov es:[di],al
     mov es:[di+1],ah

     pop ds
   End;

   IF HiddenMouse Then
   Begin
       ShowMouseCursor;
       HiddenMouse:=False;
   End;

End;



{**********************************************************************}
{Procedure DisableChoise                                               }
{Åò≠ú† ´û§ úß†¢¶öû ©¨£≠‡§ò £ú ´û§ £ú´òô¢û´û DisableColor.Ñß†©û™ õú§    }
{ú£≠ò§†ùú† ´¶ Mark Char.                                               }
{**********************************************************************}

Procedure DisableChoise(InX1,InY1:Byte;InStr :Str40;BckColor :Byte);
Var
   I        :Byte;
   TakeChar :String[1];
Begin
   IF ( (MouseX in [InX1..InX1+Length(InStr)]) or (MouseX+1 in [InX1..InX1+Length(InStr)]) ) AND
      ( (MouseY = InY1) or (MouseY+1 = InY1) ) Then
   Begin
       HiddenMouseCursor;
       HiddenMouse:=True;
   End;

   WriteChar(InX1-1,InY1,DisableColor,BckColor,32);

   For I:=1 To Length(InStr) do
   Begin
       TakeChar:=Copy(InStr,I,1);
       IF TakeChar[1]='~' Then
       Begin
          TakeChar:=Copy(InStr,I+1,1);
          WriteChar(InX1,InY1,DisableColor,BckColor,Ord(TakeChar[1]));
          I:=I+1;
       End
       Else
          WriteChar(InX1,InY1,DisableColor,BckColor,Ord(TakeChar[1]));

       Inc(InX1);
   End;

   WriteChar(InX1,InY1,DisableColor,BckColor,32);

   IF HiddenMouse Then
   Begin
      ShowMouseCursor;
      HiddenMouse:=False;
   End;
End;

{***************************************************}
{Procedure ShowPDHelpCtx                              }
{Ñ£≠ò§†ùú† ´û§ ö®ò££û ´¶¨ Help ¶ß¶¨ Æ®úò†ùú´ò†      }
{***************************************************}
Procedure ShowPDHelpCtx(Point :PField);
Var
    I           :Byte;
Begin
 PDX2:=BiosColumns div 2;PDY2:=BiosRows;
 IF AllowHelpCtx=True Then
 Begin

   IF ( (MouseX in [1..StatLineMaxChars]) or (MouseX+1 in [1..StatLineMaxChars]) ) AND
      ( (MouseY = PDY2) or (MouseY+1 = PDY2) ) Then
   Begin
      HiddenMouseCursor;
      HiddenMouse:=True;
   End;

   IF (Point^.HelpCtx<>Nil) and (PDActive=True) Then
   Begin
       WriteTextColor:=StatLineTxtColor;
       WriteTextBackGround:=StatLineBckColor;
       WriteOut(StatLineStartChar,PDY2,Copy(Point^.HelpCtx^,1,StatLineMaxChars-StatLineStartChar+1));

       IF StatLineMaxChars > StatLineStartChar+Length(Point^.HelpCtx^) Then
          For I:=StatLineStartChar+Length(Point^.HelpCtx^) to StatLineMaxChars do
            WriteChar(I,PDY2,StatLineTxtColor,StatLineBckColor,32);

       PullDownCurrentHelpCtx:=Point^.HelpCtx^;
   End
   Else
   IF (Point^.HelpCtx=Nil) and (PDActive=True) Then
   Begin
     IF StatLineMaxChars > StatLineStartChar Then
        For I:=StatLineStartChar to StatLineMaxChars do
          WriteChar(I,PDY2,StatLineTxtColor,StatLineBckColor,32);

     PullDownCurrentHelpCtx:='';
   End
   Else
   IF Win=Nil Then
   Begin
       WriteTextColor:=StatLineTxtColor;
       WriteTextBackGround:=StatLineBckColor;
       WriteOut(StatLineStartChar,PDY2,Copy(InitHelpCtx,1,StatLineMaxChars-StatLineStartChar+1));

       IF StatLineMaxChars > StatLineStartChar+Length(InitHelpCtx) Then
          For I:=StatLineStartChar+Length(InitHelpCtx) to StatLineMaxChars do
            WriteChar(I,PDY2,StatLineTxtColor,StatLineBckColor,32);

       PullDownCurrentHelpCtx:=InitHelpCtx;
   End;

   IF HiddenMouse Then
   Begin
      ShowMouseCursor;
      HiddenMouse:=False;
   End;

 End;
End;


{**********************************************************************}
{Procedure FindNextFreeSub                                             }
{ãú´ò≠ú®ú† ´¶§ pointer PDSub ©´û§ úß¶£ú§û ú§ú®öû úß†¢¶öû.ï®û©†£¶ß¶†û´ò†}
{¢¶ö¶ ´¶¨ ¶´† úÆ¶¨£ú °ò† £û ú§ú®öú™ úß†¢¶öú™.                          }
{**********************************************************************}

Procedure FindNextFreeSub;
Begin

    IF PDSub^.Disabled=True Then
    Begin
      {ë¨§úÆ†©ú òß¶ ´û§ ´®úÆ¶¨©ò úß†¢¶öû °ò† ô®ú™ ´û§ úß¶£ú§û}

      Repeat
         IF PDSub<>Nil Then
         Begin
           PDSub:=PDSub^.Sub;
           Inc(PDWhichSub);
         End;
      Until (PDSub=Nil) or ( (PDSub^.Disabled=False) and (PDSub^.Name[1]<>Chr(PDLineFill)) );


      {Ñò§ òß¶ ´¶ ´®úÆ‡§ ©û£ú†¶ õú§ ô®úüû°ú õ†òüú©†£û úß†¢¶öû ´¶´ú ò®Æ†©ú     }
      {•ò§ò òß¶ ´û§ ò®Æû                                                      }
      {Ä¢¢†‡™ ò§ õú§ ô®úüú† ´†ß¶´ú ´¶´ú úßú©´®úØú NIL                         }

      IF PDSub=Nil Then
      Begin
        PDWhichSub:=1;
        PDSub:=PDHeadSub;
        Repeat
           IF (PDSub<>Nil) and (PDSub^.Disabled=True) Then
           Begin
              PDSub:=PDSub^.Sub;
              Inc(PDWhichSub);
           End;
        Until (PDSub=Nil) or ( (PDSub^.Disabled=False) and (PDSub^.Name[1]<>Chr(PDLineFill)) );
      End;
    End;
End;




Procedure DisposeMouseCoords;
Var
   I    :Byte;
Begin
    IF PDMain^.Sub<>Nil Then
    Begin
       PDMouseAccessVar:=PDMouseNodeHead;
       For I:=1 to MaxSub do
       Begin
              PDMouseNodeHead:=PDMouseAccessVar^.NextNode;
              Dispose(PDMouseAccessVar);
              PDMouseAccessVar:=PDMouseNodeHead;
       End;
    End;
End;

Procedure UnActivePDMenus;
Var
   I    :Word;
Begin
   YOffset:=PDY1+1;

   IF MenuWinCounter>1 Then
       Dec(XOffset,4*(MenuWinCounter-1));

   IF OverFlowFlag=True Then
      XOffset:=DataByte;

   IF PDMain^.Disabled=False Then
      NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);
   PDActive:=False;
   PDNotOpen:=True;
   ShowPDHelpCtx(PDMain);

   IF MenuWinCounter>0 then
   Begin
     For I:=1 to MenuWinCounter do
      CloseMenuWindow;

       PDMouseAccessVar:=PDMouseNodeHead;
       While (PDMouseAccessVar<>Nil) and (PDMouseAccessVar^.WinNum<>0) do
       Begin
            PDMouseNodeHead:=PDMouseAccessVar^.NextNode;
            Dispose(PDMouseAccessVar);
            PDMouseAccessVar:=PDMouseNodeHead;
       End;
   End;

End;





{************************************************************************}
{Procedure ShowSubMenu                                                   }
{Ñ£≠ò§†ùú† ´ò ßú®†úÆ¶£ú§ò ß¶¨ õú†Æ§ú† ¶ PDSub.                           }
{************************************************************************}

Procedure ShowSubMenu(InPoint :PField);
Var
    Len                 :Byte;
    Temp                :PField;
    YCoord,XCoord       :Byte;
    Count               :Byte;
    EndSize             :Byte;
Begin
   IF (PDMain^.Sub<>Nil) and (PDMain^.Disabled=False) Then
   Begin
     PDNotOpen:=False;                       {Now a Menu Window is open}
     Count:=1;

     Temp:=InPoint;
     Len:=Pos('~',Temp^.Name);
     IF Len=0 Then
        Len:=Length(Temp^.Name)
     Else
        Len:=Length(Temp^.Name)-1;

     Repeat                                  {Find how many subchoises}
        IF Temp<>Nil Then
        Begin
           Inc(Count);
           Temp:=Temp^.Sub;
        End;
     Until (Temp=Nil);
     OverFlowFlag:=False;
     MaxSub:=Count-1;                        {Keep MaxSub for this Main Menu}
     YCoord:=YOffset;
     XCoord:=XOffset-2;

     IF (PDParams and Shadow) = Shadow Then
        EndSize:=5
     Else
        EndSize:=3;

     {âò§ú ú¢úöÆ¶ úò§ ´¶ ßò®òü¨®¶ ô®†©°ú´ò† ú•‡ òß¶ ´ò ¶®†ò.Ä§ åÄà ´¶´ú °ò§ú}
     {´û§ ò§ò¢¶öû £ú´ò´¶ß†©û ß®¶™ ´û§ ò§´†üú´û °ò´ú¨ü¨§©û.                  }

     IF XCoord+Len+EndSize > PDX2 Then
     Begin
          DataByte:=XCoord+2;
          XCoord:=XCoord-((XCoord+Len+EndSize)-PDX2);
          OverFlowFlag:=True;
     End;

     WinTextColor:=PDTextColor;
     WinTextBackGround:=PDTextBackGround;
     OpenMenuWindow(XCoord,YCoord,XCoord+Len+3,YCoord+Count,'',PDParams);

     Count:=1;                       {Print SubChoises}
     Temp:=InPoint;
     XCoord:=XCoord+2;
     Repeat
        IF Temp<>Nil Then
        Begin
          IF Temp^.Command in CommandsArray Then
          Begin
              Temp^.Disabled:=True;
              EnableCommand([Temp^.Command])
          End;

          IF Temp^.Disabled=False Then
             NormalColor(XCoord,YCoord+Count,Temp^.Name,PDTextColor,PDTextBackGround)
          Else
             DisableChoise(XCoord,YCoord+Count,Temp^.Name,PDTextBackGround);


          New(PDMouseAccessVar);
          PDMouseAccessVar^.Y1:=YCoord+Count;
          PDMouseAccessVar^.Y2:=YCoord+Count;
          PDMouseAccessVar^.X1:=XCoord;
          PDMouseAccessVar^.X2:=XCoord+Length(Temp^.Name);
          PDMouseAccessVar^.MainChoise:=PDWhichMain;
          PDMouseAccessVar^.SubChoise:=Count;
          PDMouseAccessVar^.WinNum:=MenuWinCounter;
          PDMouseAccessVar^.NextNode:=PDMouseNodeHead;
          PDMouseNodeHead:=PDMouseAccessVar;
          Temp:=Temp^.Sub;

          Inc(Count);
        End;
     Until Temp=Nil;
     PDWhichSub:=1;             {Active first the sub choise  }
     Temp:=InPoint;
     PDActive:=True;            {Ñ§ú®ö¶ß¶†û©û £¶§¶§ ´‡§ Main choises}
     PDNotOpen:=False;          { > >         °ò† ´‡§ Sub Choises ( }
                                {õû¢·õû ò§¶†ö£ò ßò®òü¨®¶¨).         }
     PDSub:=Temp;
     PDHeadSub:=Temp;

     XOffset:=XCoord;
     YOffset:=YCoord;

   End
   Else
   IF (PDMain^.Sub=Nil) and (PDMain^.Disabled=False) Then
   Begin
      OverFLowFlag:=False;
      ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor);
      ShowPDHelpCtx(PDMain);
   End
   Else
   IF (PDMain^.Disabled=True) Then
   Begin
       OverFlowFlag:=False;
       PDActive:=True;            {Ñ§ú®ö¶ß¶†û©û £¶§¶§ ´‡§ Main choises}
       PDNotOpen:=False;           { > >         °ò† ´‡§ Sub Choises ( }
       ShowPDHelpCtx(PDMain);
   End;
End;


{*********************************************************************}
{Procedure CheckForAltKey                                             }
{*********************************************************************}

Procedure CheckForAltKey(Var YesOrNo :Boolean);
Var
    TempIn      :PField;
    MarkStr    :String[1];
    MarkChar   :Byte;
    OkFound,
    OkFound1   :Boolean;
    I,Count    :Byte;
    KeepX      :Byte;
Begin
  TempIn:=PDHeadNode;  {Ç†ò ß®¶©ßú¢ò©£ò ¢†©´ò™}
  OkFound:=False;      {Ç†ò ´¶ ò§ ô®úüû°ú û ùû´¶¨£ú§û ¢†©´ò}
  KeepX:=PDX1+PDSpace; {â®ò´û£ò ï ©¨©§´ú´òö£ú§û™}
  Count:=0;            {â®ò´û£ò ò®†ü£¶¨ ¢†©´ò™}

  Repeat
    IF PDHeadNode<>Nil then
    Begin

      Inc(Count);

      {â®ò´û©ú ©´û§ £ú´òô¢û´û MarkChar ´¶§ £ò®°ò®†©£ú§¶ Æò®ò°´û®ò}

      OkFound1:=False;
      I:=1;
      Repeat
        MarkStr:=Copy(TempIn^.Name,I,1);
        IF MarkStr='~' Then
        Begin
           MarkStr:=Copy(TempIn^.Name,I+1,1);
           OkFound1:=True;
        End;
        Inc(I);
      Until (I=Length(TempIn^.Name)) or (OkFound1=True);

      {ãú´ò´®¶ßû ©ú Scan Code}

      MarkChar:=Ord(MarkStr[1]);
      IF MarkChar >= 128 Then
          MarkChar:=GrUpCase(MarkChar);{íú¢¶™ ô®ú™ £ú©‡ ´¶¨ ß†§ò°ò }

      MarkChar:=Ord(UpCase(Chr(MarkChar))); {AsciiScanArray ´ò ScanCodes}
      MarkChar:=AsciiScanArray[(MarkChar-65)+1];

      {Ñò§ ´¶ mark char ú†§ò† †õ†¶ £ú ´¶ Scan Code ´¶´ú ò§¶†•ú ´û§ úß†¢¶öû}

      IF (MarkChar=KBScanCode) and (OkFound1=True) Then
          OkFound:=True
      Else
      Begin

         {ìß¶¢¶ö†©ú ´û§ ï £ú´ò´¶ß†©û ßò§‡ ©´û§ ¶ü¶§û ö†ò ´û§ ï ©¨§´ú´òö£ú§û}

          KeepX:=KeepX+Length(TempIn^.Name);
          KeepX:=KeepX+(PDSpace-1);

          TempIn:=TempIn^.Next;
      End;
    End;
  Until (TempIn=Nil) or (OkFound=True);


  IF ((OKFound=True) AND ( ((PDWhichMain=Count) and (PDNotOpen=True)) or (PDWhichMain<>Count) ) )
        OR  ( (OKFound=True) and (TempIn^.Sub=Nil) ) Then
  Begin
     UnActivePDMenus;

     IF PDActive=True Then
        NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);

    {Ñß†©´®¶≠û True ©´û§ °ò¢¶¨£ú§û ®¶¨´†§ò}

     YesOrNo:=True;

     {í¶ PDSub ßò†®§ú† ´û§ ´†£û ß¶¨ ô®û°ò£ú}

     PDMain:=TempIn;
     PDSub:=PDMain^.Sub;
     XOffset:=KeepX;
     PDWhichMain:=Count;
     PDWhichSub:=1;

     PDActive:=True;
     PDNotOpen:=False;

     {âò§ú ´ò reverse Æ®‡£ò´ò ©´¶ °ò†§¶¨®ö†¶ Main}

      ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor);
  End
  Else
     YesOrNo:=False;

End;



{-------------------------------------------------------------------------}
{ìß¶®¶¨´†§ò ö†ò Æú†®†©£¶ ´‡§ öúö¶§¶´‡§ ´¶¨ ß¢û°´®¶¢¶ö†¶¨                  }
{-------------------------------------------------------------------------}

Procedure PDHandleKbEvent;
Var
   Count,MaxLen   :Byte;
   OKFound        :Boolean;
   MemByte        :Byte;
   TrueOrFalse    :Boolean;
   HelpPointer    :Pointer;
   IntegParam     :Integer;


Procedure SubToSubConstruct;
Begin
    IntegParam:=0;
    IntegParam:=MaxSub;
    IntegParam:=IntegParam shl 8; {Transfer maxsub to hi byte of IntegParam}
    IntegParam:=IntegParam or YOffset;

    PushPointer(PDHeadSub,IntegParam);

    NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround);

    PDSub:=PDSub^.Next;
    YOffset:=YOffset+PDWhichSub+1;
    XOffset:=XOffset+4;
    ShowSubMenu(PDSub);
    FindNextFreeSub;
    ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
End;

Procedure UnActiveCurrentWin;
Var
   I    :Word;
Begin
    IF MenuWinCounter>0 Then
    Begin
        IF OverFlowFlag=True Then
          XOffset:=DataByte;
        OverFlowFlag:=False;

        IF MenuWinCounter<2 Then
        Begin
           CloseMenuWindow;
           DisposeMouseCoords;
        End
        Else
        Begin
           YOffset:=PDY1+1;

           IF MenuWinCounter>1 Then
             Dec(XOffset,4*(MenuWinCounter-1));

           IF OverFlowFlag=True Then
             XOffset:=DataByte;

           IF PDMain^.Disabled=False Then
             NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);

           IF MenuWinCounter>0 then
           Begin
             For I:=1 to MenuWinCounter do
                CloseMenuWindow;

             PDMouseAccessVar:=PDMouseNodeHead;
             While (PDMouseAccessVar<>Nil) and (PDMouseAccessVar^.WinNum<>0) do
             Begin
               PDMouseNodeHead:=PDMouseAccessVar^.NextNode;
               Dispose(PDMouseAccessVar);
               PDMouseAccessVar:=PDMouseNodeHead;
            End;
           End;
        End;
    End;
End;


{***************************************************}
{Function FindMarkChar                              }
{úß†©´®ú≠ú† òß¶ ´¶ ©¨°öú°®†£ú§¶ item (Temp^.Name)   }
{´¶ £ò®°ò®†©£ú§¶ ö®ò££ò ©ú °ú≠ò¢ò†¶.                }
{***************************************************}
Function FindMarkChar(Temp :PField) :Byte;
Var
   I            :Byte;
   CharByte     :String[1];
Begin
    FindMarkChar:=0;
    For I:=1 to Length(Temp^.Name) do
    Begin
        CharByte:=Copy(Temp^.Name,I,1);
        IF CharByte='~' Then
        Begin
           CharByte:=Copy(Temp^.Name,I+1,1);
           FindMarkChar:=Ord(CharByte[1]);
        End;
    End;

End;


{*************************************************}
{Procedure CheckForHotKey                         }
{Ñò§ úÆ¶¨£ú ßò´û©ú† ´¶ Hot Key totú               }
{´®ú•ú ´û§ ò§´†©´¶†Æû õ†ò´òöû                     }
{*************************************************}

Procedure CheckForHotKey;
Var
   I            :Byte;
   MarkChar     :Byte;
   Temp         :PField;
   TempPP       :PField;
   SaveEvent    :Byte;
Begin
  TempPP:=PDHeadNode;
  OkFound:=False;
  SaveEvent:=Event;

  Repeat
     IF TempPP<>Nil then
     Begin
       IF TempPP^.Sub <> Nil Then
       Begin
          Temp:=TempPP^.Sub;
          Repeat
            IF Temp<>Nil Then
            Begin
               IF (Hi(Temp^.KeyCode)=Ord(Ascii)) Then
               Begin
                  Event:=Temp^.Command;
                  OkFound:=True;
                End
                Else
                   Temp:=Temp^.Sub;
            End;
          Until (Temp=Nil) or (OkFound=True);

       End;
       TempPP:=TempPP^.Next;
     End;
  Until  (TempPP=Nil) or (OkFound=True);

  IF (OKFound=True) and (Temp^.Disabled=False) Then
  Begin
        Ascii:=#0;Ctrl:=#0;

        IF Win<>Nil Then
        Begin
          ReadCurPositHeight;
          PullDownCurX:=CurColumn+1;
          PullDownCurY:=CurRow+1;
          PullDownSScanL:=SScanL;
          PullDownEScanL:=EScanL;
        End;

        UnActivePDMenus;
        HandleCommand;
  End;
  Event:=SaveEvent;
End;

{***********************************************************}
{Procedure CheckForMarkChar                                 }
{***********************************************************}

Procedure CheckForMarkChar;
Var
   I            :Byte;
   MarkChar     :Byte;
   Temp         :PField;
Begin
  OkFound:=False;
  I:=0;
  IF PDMain<>Nil then
  Begin
    IF PDMain^.Sub <> Nil Then
    Begin
          Temp:=PDHeadSub;
          Repeat
            IF Temp<>Nil Then
            Begin
               IF Temp^.Disabled=False Then
                  MarkChar:=FindMarkChar(Temp)
               Else
                  MarkChar:=0;

               IF MarkChar >= 128 Then
               Begin                            {Å®ú™ ´ò °ú≠ò¢ò†ò ´‡§ Æò®ò°.}
                  MarkChar:=GrUpCase(MarkChar); {°ò† £ú´ò ©´ò °ú≠ò¢ò†ò òöö¢.}
               End
               Else                             {íú¢¶™ ô®ú™ £ú©‡ ´¶¨ ß†§ò°ò }
                  MarkChar:=Ord(UpCase(Chr(MarkChar))); {AsciiScanArray ´ò ScanCodes}

               IF MarkChar > 0 Then
                  MarkChar:=AsciiScanArray[(MarkChar-65)+1];



               Inc(I);

               IF MarkChar=KBScanCode Then
               Begin
                  Event:=Temp^.Command;
                  OkFound:=True;
                End
                Else
                   Temp:=Temp^.Sub;
            End;
          Until (Temp=Nil) or (OkFound=True);
    End;
  End;

  IF OKFound=True Then
  Begin
        NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround);

        PDSub:=Temp;
        PDWhichSub:=I;

        IF (PDSub<>Nil) and ( (Ord(PDSub^.Param[1])) = (PDCheckSyb) ) Then
        Begin
           IF Ord(PDSub^.Name[Length(PDSub^.Name)]) = PDCheckSyb Then
              PDSub^.Name[Length(PDSub^.Name)]:=' '
           Else
              PDSub^.Name[Length(PDSub^.Name)]:=Chr(PDCheckSyb);
           UnActivePDMenus;
        End
        Else
        IF (PDSub^.Next<>Nil) and (PDSub<>Nil) Then
            SubToSubConstruct
        Else
        Begin
           UnActivePDMenus;
           HandleCommand;
        End;

  End;
End;

Procedure IncORDecSubChoise(DecOrInc :Byte);
Var
   Temp         :PField;
Begin
     Temp:=PDHeadSub;
     Count:=0;
     Repeat
        Inc(Count);
        IF (Temp<>Nil) and (Count<>PDWhichSub) Then
            Temp:=Temp^.Sub
        Else
        IF (Temp<>Nil) and (Count=PDWhichSub) Then
           IF (Temp^.Name[1]=Chr(PDLineFill)) Or
               (Temp^.Disabled=True)  Then {If Line then Next one}
           Begin
               Temp:=PDHeadSub;
               Count:=0;

               IF DecOrInc=0 Then
               Begin
                  Inc(PDWhichSub);
                  IF PDWhichSub > MaxSub Then
                     PDWhichSub:=1;
               End
               Else
               Begin
                  Dec(PDWhichSub);
                  IF PDWhichSub < 1 Then
                     PDWhichSub:=MaxSub;
               End;
           End;
     Until (Temp=Nil) or (Count=PDWhichSub);

     IF Temp<>Nil Then
        PDSub:=Temp;
End;


Begin

    {============================ F10 ================================}

    IF (Ctrl=#0) and (Ascii=#68) and (PDActive=False) Then
    Begin
         Ascii:=#0;Ctrl:=#0;
         PDNotOpen:=True;                    {Active but not open window}
         PDActive:=True;                     {Ok F10 pressed}
         YOffset:=PDY1+1;

         IF PDWhichMain>1 Then               {IF Main>1 Then Find X Offset}
         Begin
           Count:=0;
           XOffset:=PDX1+PDSpace;
           Repeat
              Inc(Count);
              SearchList(Count,PDMain);
              XOffset:=XOffset+Length(PDMain^.Name);
              XOffset:=(XOffset+PDSpace)-1;
           Until Count=PDWhichMain-1;
         End;

         SearchList(PDWhichMain,PDMain);    {Find and Activate In List->Main}
         ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor); {Reverse Colors}
         ShowPDHelpCtx(PDMain);
         CurrentHelpPtr:=PDMain^.Help;
    End
    Else

    {===================== Right Arrow =================================}

    IF (Ctrl=#0) and (Ascii=#77) and (PDActive=True) Then
    Begin
         Ascii:=#0;Ctrl:=#0;
         UnActiveCurrentWin;
         NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);{Normal Colors}
         Inc(PDWhichMain);                      {Next in Right}

         IF PDWhichMain > MaxMain Then          {Bigger than MaxMain ?}
         Begin
            PDWhichMain:=1;                     {Start again From Start}
            XOffset:=PDSpace+PDX1;
         End
         Else
         Begin
              XOffset:=XOffset+Length(PDMain^.Name);
              XOffset:=(XOffset+PDSpace)-1;
         End;

         SearchList(PDWhichMain,PDMain);    {Find and Activate In List->Main}
         ShowPDHelpCtx(PDMain);
         CurrentHelpPtr:=PDMain^.Help;

         ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor);

         IF (PDNotOpen=False) and (PDMain^.Sub<>Nil) Then
         Begin
           ShowSubMenu(PDMain^.Sub);
           FindNextFreeSub;
           ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
           ShowPDHelpCtx(PDSub);
           CurrentHelpPtr:=PDSub^.Help;
         End
         Else
         IF (MenuWinCounter>0) and (PDNotOpen=False) Then
         Begin
           PDSub:=Nil;
           PDHeadSub:=Nil;
           MaxSub:=0;
         End;

    End
    Else

    {===================== Left Arrow =================================}

    IF (Ctrl=#0) and (Ascii=#75) and (PDActive=True) Then
    Begin
         Ascii:=#0;Ctrl:=#0;
         UnActiveCurrentWin;
         NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);{Normal Colors}
         Dec(PDWhichMain);                      {Next in Left}
         IF PDWhichMain < 1 Then                {Smaller than 1 ?}
         Begin
            PDWhichMain:=MaxMain;               {Start again From End}
            XOffset:=PDSpace+1;
            For Count:=1 To MaxMain-1 Do
            Begin
              SearchList(Count,PDMain);
              XOffset:=XOffset+Length(PDMain^.Name);
              XOffset:=(XOffset+PDSpace)-1;
              SearchList(PDWhichMain,PDMain);    {Find and Activate In List->Main}
              ShowPDHelpCtx(PDMain);
           End;
         End
         Else
         Begin
              XOffset:=(XOffset-PDSpace)+1;
              SearchList(PDWhichMain,PDMain);    {Find and Activate In List->Main}
              ShowPDHelpCtx(PDMain);
              XOffset:=XOffset-Length(PDMain^.Name);
         End;
         ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor);

         CurrentHelpPtr:=PDMain^.Help;

         IF (PDNotOpen=False) and (PDMain^.Sub<>Nil) Then
         Begin
            ShowSubMenu(PDMain^.Sub);
            FindNextFreeSub;
            ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
            ShowPDHelpCtx(PDSub);
            CurrentHelpPtr:=PDSub^.Help;
         End
         Else
         IF (MenuWinCounter > 0) and (PDNotOpen=False) Then
         Begin
           PDSub:=Nil;
           PDHeadSub:=Nil;
           MaxSub:=0;
         End;

    End
    Else

    {====================== Down Arrow ==================================}

    IF (Ctrl=#0) and (Ascii=#80) and (PDActive=True) Then
    Begin
        Ascii:=#0;Ctrl:=#0;
        IF (PDNotOpen=True) and (PDMain^.Sub<>Nil) Then
        Begin
           ShowSubMenu(PDMain^.Sub);
           FindNextFreeSub;
           ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
           ShowPDHelpCtx(PDSub);
           CurrentHelpPtr:=PDSub^.Help;
        End
        Else
        IF (PDNotOpen=False) and (MaxSub>1) and (PDMain^.Sub<>Nil) Then
        Begin

            NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround);

            Inc(PDWhichSub);

            IF PDWhichSub > MaxSub Then
               PDWhichSub:=1;

            IncORDecSubChoise(0);

            IF PDSub<>Nil Then
            Begin
               ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
               ShowPDHelpCtx(PDSub);
               CurrentHelpPtr:=PDSub^.Help;
            End;
        End;
    End
    Else

    {====================== Up Arrow ==================================}

    IF (Ctrl=#0) and (Ascii=#72) and (PDActive=True) and (PDMain^.Sub<>Nil) Then
    Begin
        IF (PDNotOpen=False)  and (MaxSub>1) Then
        Begin
            Ascii:=#0;Ctrl:=#0;
            NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround);


            Dec(PDWhichSub);
            IF PDWhichSub < 1 Then
               PDWhichSub:=MaxSub;

            IncOrDecSubChoise(1);

            IF PDSub<>Nil Then
            Begin
              ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
              ShowPDHelpCtx(PDSub);
              CurrentHelpPtr:=PDSub^.Help;
            End;
        End;
    End
    Else



    {====================== Enter =======================================}

    IF (Ctrl=#13) and (PDActive=True) Then
    Begin
        {í¶ ßò®òü¨®¶ õú§ ú†§ò† ò§¶†°´¶ .Ñ¢ò úõ‡}
        Ascii:=#0;Ctrl:=#0;
        IF (PDNotOpen=True) and (PDMain^.Sub<>Nil) Then
        Begin
           ShowSubMenu(PDMain^.Sub);
           FindNextFreeSub;
           ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
           ShowPDHelpCtx(PDSub);
        End
        Else

        {Ñò§ PDSub^.Next õú§ ú†§ò† nil ´¶´ú úÆ¶¨£ú sub to sub construct}

        IF (PDSub^.Next<>Nil) and (PDSub<>Nil) and (PDMain^.Sub<>Nil) Then
        Begin
            SubToSubConstruct;
        End
        Else

        {Ñò§ ßò´û©ò£ú enter ©ú °òß¶†ò úß†¢¶öû ß¶¨ "´®úÆú†" ´¶´ú ú¢ò úõ‡}
        {Ñ°´ú¢ú©û ´û™ cmXXXXX command                                  }

        IF (PDSub<>Nil) and ( (Ord(PDSub^.Param[1])<>PDCheckSyb) ) and (PDMain^.Sub<>Nil) Then
        Begin
             UnActiveCurrentWin;
             NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);{Normal Colors}
             PDActive:=False;
             PDNotOpen:=True;
             ShowPDHelpCtx(PDSub);
             Event:=PDSub^.Command;
             HandleCommand;
        End;

        { Ñò§ ú†§ò† ö†ò ´©ú°ò®†©£ò ´¶´ú ú¢ò úõ‡}

        IF (PDSub<>Nil) and ( (Ord(PDSub^.Param[1])) = (PDCheckSyb) ) and (PDMain^.Sub<>Nil) Then
        Begin
              IF Ord(PDSub^.Name[Length(PDSub^.Name)]) = PDCheckSyb Then
              Begin
                   PDSub^.Name[Length(PDSub^.Name)]:=' ';
                   PDCheckerOnOff:=False;
              End
              Else
              Begin
                   PDSub^.Name[Length(PDSub^.Name)]:=Chr(PDCheckSyb);
                   PDCheckerOnOff:=True;
              End;
              ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
              Event:=PDSub^.Command;
              HandleCommand;
        End
        Else

        {Ñò§ û Main õú§ úÆú† ¨ß¶úß†¢¶öú™ ´¶´ú ú¢ò úõ‡}

        IF (PDMain^.Sub=Nil) Then
        Begin
             NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);{Normal Colors}
             PDActive:=False;
             PDNotOpen:=True;
             ShowPDHelpCtx(PDMain);
             Event:=PDMain^.Command;
             HandleCommand;
        End;
    End
    Else

    {Ñò§ ßò´û©¶¨£ú Escape °ò† úÆ¶¨£ú Sub to Sub É¶£û ´¶´ú ßûöò†§¶¨£ú ©´¶
     ß®¶ûö¶¨£ú§¶ ßò®òü¨®¶ ò¢¢†‡™ ©ô¨©ú ´û§ Main ú§´¶¢û.                 }

    IF (Ctrl=#27) and (PDActive=True) Then
    Begin
        IF (MenuWinCounter-1) > 0 Then
        Begin

            IF OverFlowFlag=True Then
               XOffset:=DataByte;

            CloseMenuWindow;

            DisposeMouseCoords;

            PopPointer(HelpPointer,IntegParam);
            PDSub:=HelpPointer;
            PDHeadSub:=HelpPointer;

            XOffset:=XOffset-4;
            YOffset:=Lo(IntegParam);
            MaxSub:=Hi(IntegParam);
            PDWhichSub:=1;
            FindNextFreeSub;

            ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
            ShowPDHelpCtx(PDSub);

            Ascii:=#0;Ctrl:=#0;
        End
        Else
        Begin

           IF OverFlowFlag=True Then
              XOffset:=DataByte;

           NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);
           PDActive:=False;
           PDNotOpen:=True;
           ShowPDHelpCtx(PDMain);
           IF MenuWinCounter>0 Then
           Begin
             CloseMenuWindow;
             DisposeMouseCoords;
           End;

           IF Win<>Nil Then
              ShowHelpCtx(Win^.CurrentMessageLine);

           OpenClosePDMenuFlag:=True;
           Ascii:=#0;Ctrl:=#0;
        End;


    End
    Else


    {Ñò§ ú†§ò† Hot Key „ ßò´û£ò ALT (£ò®°ò®†©£ú§¶¨ ö®ò££ò´¶™) ´¶´ú ú¢ò úõ‡}

    IF (Ctrl=#0) Then
    Begin
        CheckForHotKey;
        MemByte:=Mem[$0040:$0017];
        IF (MemByte and 8)=8 Then
        Begin
            CheckForAltKey(TrueOrFalse);
            IF TrueOrFalse=True Then        {True=Ñò§ ´¶ úÆ¶¨£ú ô®ú†}
            Begin
                IF PDMain^.Sub<>Nil Then
                Begin
                  ShowSubMenu(PDSub);
                  FindNextFreeSub;
                  ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
                  ShowPDHelpCtx(PDSub);
                  CurrentHelpPtr:=PDSub^.Help;
                  OpenClosePDMenuFlag:=False;
                  Ascii:=#0;Ctrl:=#0;
                End
                Else
                Begin
                  ShowSubMenu(PDSub);   {PDSub in this case is NIL}
                  Event:=PDMain^.Command;
                  UnActivePDMenus;
                  HandleCommand;
                End;
            End;
        End
    End
    Else

    {ò¢¢†‡™ úò§ ú†§ò† £ò®°ò®†©£ú§¶ ö®ò££ò ´¶´ú ú¢ò úõ‡}

    IF (Ctrl<>#0) and (PDNotOpen=False) Then
        CheckForMarkChar;

End;

{------------------------------------------------------------------------}
{ìß¶®¶¨´†§ò ö†ò Æú†®†©£¶ ´‡§ öúö¶§¶´‡§ ´¶¨ ß¶§´†°†¶¨                     }
{------------------------------------------------------------------------}

Procedure PDHandleMsEvent;
Var
  IntegParam            :Integer;
  HelpPointer           :Pointer;
  Found                 :Boolean;


Procedure PreviousMenu;
Begin
   CloseMenuWindow;
   DisposeMouseCoords;
   PopPointer(HelpPointer,IntegParam);
   PDSub:=HelpPointer;
   PDHeadSub:=HelpPointer;

   XOffset:=XOffset-4;
   YOffset:=Lo(IntegParam);
   MaxSub:=Hi(IntegParam);
   PDWhichSub:=1;

   FindNextFreeSub;
   ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
   ShowPDHelpCtx(PDSub);
End;

Var
   Count,I      :Byte;
   Pass         :Boolean;
   FirstTime    :Boolean;
   InSec,Mous,
   MenuW        :WinCoord;
   OldMX,OldMY  :Byte;
Begin
    Pass:=False;       {Ñ¢úöÆú† úò§ ´¶ ß¶§´†°† ú†§ò† ´û§ £ò†§ úß†¢¶öû ò¢¢ò}
                       {ßò´û£ú§¶.Ñò§ ú†§ò† ©´û £ò†§ úÆú† ´†£û True ò¢¢†‡™ }
                       {ú†§ò† False.                                      }
    FirstTime:=False;  {èò†®§ú† True £¶§¶§ ´û§ ß®‡´û ≠¶®ò ß¶¨ ßò†®§òú† òß¶}
                       {´¶§ ô®¶Æ¶.ï®ú†òùú´ò† ö†ò §ò •ú®¶¨£ú ò§ ´û§ ß®‡´û  }
                       {≠¶®ò,õú§ ô®úüú† £ú©ò ©ú °òß¶†¶ ßúõ†¶ °ò† ´¶ button}
                       {ú†§ò† ßò´û£ú§¶ §ò £û§ ú§ú®ö¶ß¶†û©ú† ´†ß¶´ò.       }


    IF MouseButton = msLeft Then
    Begin
      FirstTime:=True;
      Found:=False;
      OldMx:=0;
      OldMY:=0;
      Repeat

        Found:=False;
        PDMouseAccessVar:=PDMouseNodeHead;
        While (PDMouseAccessVar<>Nil) and (Found=False) do
        Begin
            IF (MouseX in [PDMouseAccessVar^.X1..PDMouseAccessVar^.X2]) and
               (MouseY in [PDMouseAccessVar^.Y1..PDMouseAccessVar^.Y2]) and
                ((PDMouseAccessVar^.WinNum=MenuWinCounter) or (PDMouseAccessVar^.WinNum=0)) Then
                 Found:=True
            Else
               PDMouseAccessVar:=PDMouseAccessVar^.NextNode;
        End;
        {Ü ®¶¨´†§ò ß¶¨ Æú†®†ùú´ò† ´û§ £ú´òô¢û´û FirstTime}

        IF (Found=False) and (FirstTime=True) Then
        Begin
              Mous.X1:=MouseX;
              Mous.Y1:=MouseY;
              Mous.X2:=MouseX;
              Mous.Y2:=MouseY;

              IF MenuWinCounter>0 Then
              Begin
                MenuW.X1:=MenuWin^.X1;
                MenuW.Y1:=MenuWin^.Y1;
                MenuW.X2:=MenuWin^.X2;
                MenuW.Y2:=MenuWin^.Y2;
              End
              Else
              Begin
                MenuW.X1:=PDX1;
                MenuW.Y1:=PDY1;
                MenuW.X2:=PDX2;
                MenuW.Y2:=PDY1;
              End;

              InterSection(Mous,MenuW,InSec);

              IF InSec.X1=$FF Then
                 Repeat
                 Until MouseButton=0;
            FirstTime:=False;
        End;


        IF Found=True Then
        Begin

          IF ((PDWhichMain<>PDMouseAccessVar^.MainChoise) or (PDNotOpen=True)) Then
          Begin
             {Éú§ ß®úßú† §ò ò¢¢òùú† û üú©û ´û™ ßò®ò°ò´‡ ú§´¶¢û™ õ†¶´† £ú}
             {´û§ DisposeMouseCoords ò¢¢òùú† û PDMouseAccessVar^        }

             FirstTime:=False;
             PDWhichMain:=PDMouseAccessVar^.MainChoise;

             {â¢ú†©ú ¶©ò ßò®òü¨®ò ú†§ò† ò§¶†Æ´ò}

              IF (MenuWinCounter>0) and (MenuWinCounter<2) then {Only One Window}
              Begin
                  CloseMenuWindow;
                  DisposeMouseCoords;
              End
              Else

              {if we have more than one window then go to this part}

              IF MenuWinCounter>1 Then
                 UnActivePDMenus;

              {Ñò§ ú•‡ òß¶ ´ò ¶®†ò ´û™ ¶ü¶§û™ ´¶´ú OverFlowFlag=True}

              IF OverFlowFlag=True Then
                 XOffset:=DataByte;

              {âò§ú ´ò normal Æ®‡£ò´ò}

              IF (PDActive=True) and (PDMain^.Disabled=False) Then
                 NormalColor(XOffset,PDY1,PDMain^.Name,PDTextColor,PDTextBackGround);

              PDNotOpen:=False;                   {Active and open window}
              PDActive:=True;                     {active}

              IF PDWhichMain>1 Then               {IF Main>1 Then Find X Offset}
              Begin
               Count:=0;
               XOffset:=PDX1+PDSpace;
               Repeat
                  Inc(Count);
                  SearchList(Count,PDMain);
                  XOffset:=XOffset+Length(PDMain^.Name);
                  XOffset:=(XOffset+PDSpace)-1;
               Until Count=PDWhichMain-1;
              End
              Else
                XOffset:=PDX1+PDSpace;
              YOffset:=PDY1+1;

              SearchList(PDWhichMain,PDMain);
              PDWhichSub:=1;
              PDSub:=PDMain^.Sub;

              IF (PDMain^.Disabled=False) Then
                  ReverseColor(XOffset,PDY1,PDMain^.Name,PDRevTxtColor);

              ShowSubMenu(PDSub);
              ShowPDHelpCtx(PDMain);
              CurrentHelpPtr:=PDMain^.Help;
              Pass:=True;
          End
          Else

          {Ä¢¢†‡™ úò§ ú†§ò† ûõû ò§¶†ö£ú§¶ ´¶ ßò®òü¨®¶ ´¶´ú ú•ò≠ò§†©ú ´û§}
          {≠‡´†§û ¢¶¨®†õò °ò† ú£≠ò§†©ú ´¶ ò§ò¢¶ö¶ HelpCtx               }

          IF (PDWhichMain=PDMouseAccessVar^.MainChoise) and (PDMouseAccessVar^.SubChoise=0) and
              (PDNotOpen=False) and (PDMain^.Sub<>Nil) and (Pass=False) and
                (PDMain^.Disabled=False)  Then
          Begin
            {âò§ú ´ò normal Æ®‡£ò´ò}
            FirstTime:=False;
            IF (PDNotOpen=False) and (PDMain^.Sub<>Nil)  and (PDSub^.Disabled=False) Then
               NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround)
            Else
               DisableChoise(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextBackGround);
            ShowPDHelpCtx(PDMain);
            CurrentHelpPtr:=PDMain^.Help;
            Pass:=True;
          End

          {Ñò§ úÆ¶¨£ú ò¢¢òöû ´û™ ≠‡´†§û™ ´ò†§†ò™ ´‡§ sub choises ú¢ò úõ‡}

          Else
          IF (PDWhichMain=PDMouseAccessVar^.MainChoise) and (PDNotOpen=False)
             and (PDMain^.Sub<>Nil) and ( (PDWhichSub<>PDMouseAccessVar^.SubChoise) or (Pass=True) )
                 and (PDMouseAccessVar^.SubChoise<>0) Then
          Begin
             Pass:=False;
             FirstTime:=False;
             IF PDSub^.Disabled = False Then
                NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround)
             Else
                 DisableChoise(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextBackGround);
             PDSub:=PDHeadSub;
             Count:=PDMouseAccessVar^.SubChoise;
             IF Count>1 Then
                For I:=1 to Count-1 do
                    PDSub:=PDSub^.Sub;
             PDWhichSub:=Count;

             IF PDSub^.Name[1] <> Chr(PDLineFill) Then
             Begin
               IF PDSub^.Disabled = False Then
                   ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor)
               Else
                   DisableChoise(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextBackGround);

               ShowPDHelpCtx(PDSub);
               CurrentHelpPtr:=PDSub^.Help;
             End;
          End

        End; {Found=True}

        {Wait until a mouse event occur}

        OldMX:=MouseX;OldMY:=MouseY;
        Repeat
        Until (OldMX<>MouseX) or (MouseY<>OldMY) or (MouseButton=0);

      Until (MouseButton=0);

      {Ñò§ úÆ¶¨£ú ßò´û£ò ú•‡ òß¶ ´û§ úß†´®úß´û ßú®†¶Æû ´¶´ú úÆ¶¨£ú}
      {òßú§ú®ö¶ß¶†û©û ´‡§ pull down menus.Ñò§ úÆ¶¨£ú sub to sub   }
      {´¶´ú ßò£ú ©´¶ ß®¶ûö¶¨£ú§¶ ßò®òü¨®¶.                        }

      IF (Found=False) and (PDActive=True) Then
      Begin
         IF MenuWinCounter>1 Then
            PreviousMenu
         Else
         Begin
            UnActivePDMenus;
            OpenClosePDMenuFlag:=True;
            IF Win<>Nil Then
              ShowHelpCtx(Win^.CurrentMessageLine);
            Event:=255;
         End;
      End
      Else

      {Ñò§ úÆ¶¨£ú Main choise Æ‡®†™ ¶£‡™ úß†¢¶öú™  ´¶´ú ú¢ò úõ‡}

      IF (Found=True) and (PDMain^.Sub=Nil) and (PDMain^.Disabled=False) Then
      Begin
          UnActivePDMenus;
          Event:=PDMain^.Command;
          SetVirtPDCursorPositHeight(PullDownCurX,PullDownCurY,PullDownSScanL,PullDownEScanL);
          HandleCommand;
          OpenClosePDMenuFlag:=True;
      End
      Else

      {Ñò§ úÆ¶¨£ú Disable úß†¢¶öû ´¶´ú ú¢ò úõ‡                  }

      IF (Found=True) and  ( (PDMain^.Disabled=True) )  Then
      Begin
         UnActivePDMenus;
         OpenClosePDMenuFlag:=True;
         IF Win<>Nil Then
            ShowHelpCtx(Win^.CurrentMessageLine);
         Event:=255;
      End
      Else

      {Ñò§ úÆ¶¨£ú ßò´û£ò ©ú sub úß†¢¶öû ´¶´ú °ò§ú :             }
      {E§ú®ö¶ß¶†û©ú ´û§ ´®úÆ¶§ úß†¢¶öû ´¶¨ ¨ß¶£ú§¶¨ °ò† ú°´ú¢ú©ú}
      {´û§ õ†ò´òöû ©ò§ event                                    }

      IF (PDNotOpen=False) and (Found=True) and (PDMain^.Sub<>Nil) and (Pass=False)
          and (PDSub^.Next=Nil) and (Ord(PDSub^.Param[1]) <> PDCheckSyb) and (PDWhichSub<>0) Then
      Begin
          UnActivePDMenus;

          OpenClosePDMenuFlag:=True;
          Event:=255;
          IF PDSub^.Disabled=False Then
          Begin
            SetVirtPDCursorPositHeight(PullDownCurX,PullDownCurY,PullDownSScanL,PullDownEScanL);
            Event:=PDSub^.Command;
            HandleCommand;
          End
          Else
          IF PDSub^.Disabled=True Then
          Begin
            IF Win<>Nil Then
               ShowHelpCtx(Win^.CurrentMessageLine);
            Event:=255;
          End;
      End
      Else

      {Ñò§ úÆ¶¨£ú sub to sub õ¶£û ´¶´ú ú¢ò úõ‡.}

      IF (PDNotOpen=False) and (Found=True) and (PDMain^.Sub<>Nil) and (Pass=False)
          and (PDSub^.Sub<>Nil) and (Ord(PDSub^.Param[1]) <> PDCheckSyb)  Then
      Begin
           IntegParam:=0;
           IntegParam:=MaxSub;
           IntegParam:=IntegParam shl 8; {Transfer maxsub to hi byte of IntegParam}
           IntegParam:=IntegParam or YOffset;

           PushPointer(PDHeadSub,IntegParam);

           NormalColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDTextColor,PDTextBackGround);

           PDSub:=PDSub^.Next;
           YOffset:=YOffset+PDWhichSub+1;
           XOffset:=XOffset+4;
           ShowSubMenu(PDSub);
           FindNextFreeSub;
           ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor);
           ShowPDHelpCtx(PDSub);
           CurrentHelpPtr:=PDSub^.Help;
      End
      Else

      {Ñò§ úÆ¶¨£ú ßò´û£ò £¶§¶§ ´¶¨ main £ú§¶¨ ´¶´ú òß¢ò ò§òØú ´û§ ß®‡´û úß†¢¶öû}
      {´¶¨ sub choise.                                                         }

      IF (PDNotOpen=False) and (Found=True) and (PDMain^.Sub<>Nil) and (Pass=True) Then
      Begin
         IF PDSub^.Disabled=False Then
            ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor)
         Else
         Begin
            FindNextFreeSub;
            ReverseColor(XOffset,YOffset+PDWhichSub,PDSub^.Name,PDRevTxtColor)
         End;
         ShowPDHelpCtx(PDSub);
         CurrentHelpPtr:=PDSub^.Help;
      End
      Else

      {Ñò§ ÑÆ¶¨£ú check sub ´¶´ú ò§´ú©´®úØú ´û§ úß†¢¶öû °ò† ≠¨öú}

      IF (Ord(PDSub^.Param[1]) = PDCheckSyb) and (PDNotOpen=False) and (Found=True) and
           (PDMain^.Sub<>Nil) and (Pass=False) and (PDSub^.Next=Nil) Then
      Begin
           IF Ord(PDSub^.Name[Length(PDSub^.Name)]) = PDCheckSyb Then
           Begin
              PDSub^.Name[Length(PDSub^.Name)]:=' ';
              PDCheckerOnOff:=False;
           End
           Else
           Begin
              PDSub^.Name[Length(PDSub^.Name)]:=Chr(PDCheckSyb);
              PDCheckerOnOff:=True;
           End;
           UnActivePDMenus;
           Event:=PDSub^.Command;
           HandleCommand;
           OpenClosePDMenuFlag:=True;
      End;
    End {If msLEFT}
    Else
    IF (PDActive=True)  and (MouseButton=msRight) Then
    Begin
        UnActivePDMenus;
        OpenClosePDMenuFlag:=True;
        IF Win<>Nil Then
           ShowHelpCtx(Win^.CurrentMessageLine);
        Event:=255;
        Repeat
        until MouseButton = msIdle;
    End;
End;

Procedure CheckMouseEvent(Var YesOrNo:Boolean);
Var
   Found        :Boolean;
Begin
  IF (MouseY=PDY1) and (PDActive=False) Then
  Begin
    Found:=False;
    PDMouseAccessVar:=PDMouseNodeHead;
    While (PDMouseAccessVar<>Nil) and (Found=False) do
    Begin
     IF (MouseX in [PDMouseAccessVar^.X1..PDMouseAccessVar^.X2]) and
        (MouseY in [PDMouseAccessVar^.Y1..PDMouseAccessVar^.Y2]) and
          ((PDMouseAccessVar^.WinNum=MenuWinCounter) or (PDMouseAccessVar^.WinNum=0)) Then
                 Found:=True
     Else
        PDMouseAccessVar:=PDMouseAccessVar^.NextNode;
    End;
    IF Found=True Then
    Begin
      YesOrNo:=True;

      IF (OpenClosePDMenuFlag=False) Then
      Begin
         OpenClosePDMenuFlag:=True;

         IF Win<>Nil Then
         Begin
           ReadCurPositHeight;
           PullDownCurX:=CurColumn+1;
           PullDownCurY:=CurRow+1;
           PullDownSScanL:=SScanL;
           PullDownEScanL:=EScanL;
           CurOff;
         End;
      End;
    End
    Else
    Begin
       IF PDActive Then
          YesOrNo:=True
       Else
          YesOrNo:=False;
    End;
  End
  Else
  Begin
     IF PDActive Then
        YesOrNo:=True
     Else
        YesOrNo:=False;
  End;
End;
{-------------------------------------------------------------------}
{Now Starts the real PDEventHandler routine.                        }
{-------------------------------------------------------------------}
Var
  Yes   :Boolean;
Begin
  IF AccessPDMenus=True Then
  Begin
     Case Event Of
        0:PDHandleKbEvent;
        1:Begin
           CheckMouseEvent(Yes);
           IF Yes=True Then
              PDHandleMsEvent;
          End;
     End;

     IF (PDActive=True) and (OpenClosePDMenuFlag=False) Then
     Begin
        OpenClosePDMenuFlag:=True;

        IF Win<>Nil Then
        Begin
           ReadCurPositHeight;
           PullDownCurX:=CurColumn+1;
           PullDownCurY:=CurRow+1;
           PullDownSScanL:=SScanL;
           PullDownEScanL:=EScanL;
           CurOff;
        End;
     End
     Else
     IF (PDActive=False) and (OpenClosePDMenuFlag=True) Then
     Begin
        OpenClosePDMenuFlag:=False;
        IF (Win <> Nil)  Then
           SetVirtPDCursorPositHeight(Win^.WinCurX,Win^.WinCurY,Win^.WinSScanL,Win^.WinEScanL);
     End;
  End;
End;

END.