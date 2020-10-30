OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
**
** $VER: Toolbar_mcc.h V15.3
** Copyright © 2018 Richard Collier. All rights reserved.
**
*/

#define MUIC_Toolbar 'Toolbar.mcc'
#define ToolbarObject Mui_NewObjectA(MUIC_Toolbar,[TAG_IGNORE,0

/*** Methods ***/
#define MUIM_Toolbar_BottomEdge      $fcf70007
#define MUIM_Toolbar_CheckNotify     $fcf7000d
#define MUIM_Toolbar_DrawButton      $fcf7000c
#define MUIM_Toolbar_KillNotify      $fcf70002
#define MUIM_Toolbar_KillNotifyObj   $fcf70003
#define MUIM_Toolbar_LeftEdge        $fcf70008
#define MUIM_Toolbar_MultiSet        $fcf70004
#define MUIM_Toolbar_Notify          $fcf70001
#define MUIM_Toolbar_Redraw          $fcf70005
#define MUIM_Toolbar_ReloadImages    $fcf7000b
#define MUIM_Toolbar_RightEdge       $fcf70009
#define MUIM_Toolbar_Set             $fcf70006
#define MUIM_Toolbar_TopEdge         $fcf7000a

/*** Structs ***/


/*** Values ***/
#define MUIV_Toolbar_Set_Ghosted     $04
#define MUIV_Toolbar_Set_Gone        $08
#define MUIV_Toolbar_Set_Selected    $10

#define MUIV_Toolbar_Notify_Pressed    0
#define MUIV_Toolbar_Notify_Active     1
#define MUIV_Toolbar_Notify_Ghosted    2
#define MUIV_Toolbar_Notify_Gone       3
#define MUIV_Toolbar_Notify_LeftEdge   4
#define MUIV_Toolbar_Notify_RightEdge  5
#define MUIV_Toolbar_Notify_TopEdge    6
#define MUIV_Toolbar_Notify_BottomEdge 7

/*** Special value for MUIM_Toolbar_Notify ***/
#define MUIV_Toolbar_Qualifier $49893135

/*** Attributes ***/
#define MUIA_Toolbar_Description     $fcf70016
#define MUIA_Toolbar_HelpString      $fcf70017
#define MUIA_Toolbar_Horizontal      $fcf70015
#define MUIA_Toolbar_ImageGhost      $fcf70013
#define MUIA_Toolbar_ImageNormal     $fcf70011
#define MUIA_Toolbar_ImageSelect     $fcf70012
#define MUIA_Toolbar_ImageType       $fcf70010
#define MUIA_Toolbar_ParseUnderscore $fcf70018
#define MUIA_Toolbar_Path            $fcf7001b
#define MUIA_Toolbar_Permutation     $fcf7001a
#define MUIA_Toolbar_Qualifier       $fcf7001c
#define MUIA_Toolbar_Reusable        $fcf70019

/*** Special attribute values ***/

#define MUIV_Toolbar_ImageType_File     0
#define MUIV_Toolbar_ImageType_Memory   1
#define MUIV_Toolbar_ImageType_Object   2

/*** Structures, Flags & Values ***/

#define TP_SPACE -2
#define TP_END   -1

OBJECT muip_toolbar_description
  type: CHAR               /* Type of button - see possible values below (TDT_). - UBYTE */
  key: CHAR                /* Hotkey - UBYTE */
  flags: INT               /* The buttons current setting - see the TDF_ flags - UWORD */
  toolText: PTR TO CHAR    /* The text beneath the icons. - STRPTR */
  helpString: PTR TO CHAR  /* The string used for help-bubbles or MUIA_Toolbar_HelpString - STRPTR */
  mutualExclude: LONG      /* Buttons to be released when this button is pressed down - ULONG */
ENDOBJECT


/*** Toolbar Description Types ***/

#define TDT_BUTTON  0
#define TDT_SPACE   1
#define TDT_IGNORE  2 // Obsolete
#define TDT_END     3

#define TDT_IGNORE_FLAG 128

/*** Toolbar Description Flags ***/

#define TDF_TOGGLE      $01 /* Set this if it's a toggle-button */
#define TDF_RADIO       $02 /* AND this if it's also a radio-button */
#define TDF_GHOSTED     $04
#define TDF_GONE        $08 /* Make the button temporarily go away */
#define TDF_SELECTED    $10 /* State of a toggle-button */

#define TDF_RADIOTOGGLE TDF_TOGGLE+TDF_RADIO /* A practical definition */

/* TDF_RADIO and TDF_SELECTED only makes sense
   if you have set the TDF_TOGGLE flag.          */

/*** Toolbar Macros ***/

#define Toolbar_Button(flags, text)          [TDT_BUTTON, NIL, flags, text, NIL,  NIL]:muip_toolbar_description
#define Toolbar_TextButton(flags, text, key) [TDT_BUTTON, key, flags, text, NIL,  NIL]:muip_toolbar_description
#define Toolbar_HintButton(flags, hint, key) [TDT_BUTTON, key, flags, NIL,  hint, NIL]:muip_toolbar_description
#define Toolbar_Space                        [TDT_SPACE,  NIL, NIL,   NIL,  NIL,  NIL]:muip_toolbar_description
#define Toolbar_End                          [TDT_END,    NIL, NIL,   NIL,  NIL,  NIL]:muip_toolbar_description

PROC buildBank(list:PTR TO LONG)
  DEF result,l,s,cc

  l:=ListLen(list)
  s:=SIZEOF muip_toolbar_description
  WriteF('List length is \d\n', l)
  WriteF('Element size is \d\n', s)


  result:=New(l * s)
  FOR cc:=0 TO l-1 DO CopyMem(list[cc], result+(cc*s), s)
ENDPROC result


