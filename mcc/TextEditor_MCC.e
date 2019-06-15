/*
**
** $VER: TextEditor_mcc.h V15.1 (12-Aug-97)
** Copyright © 1997 Allan Odgaard. All rights reserved.
**
** Translated to E by Neil Williams (23.11.97)
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'libraries/mui'

MODULE 'exec/types'

#define   MUIC_TextEditor     'TextEditor.mcc'
#define   TextEditorObject    Mui_NewObjectA(MUIC_TextEditor,[TAG_IGNORE,0

->CONST   TextEditor_Dummy  = $ad000000

CONST   MUIA_TextEditor_AreaMarked       = $ad000014
CONST   MUIA_TextEditor_ColorMap         = $ad00002f
CONST   MUIA_TextEditor_Contents         = $ad000002
CONST   MUIA_TextEditor_CursorX          = $ad000004
CONST   MUIA_TextEditor_CursorY          = $ad000005
CONST   MUIA_TextEditor_DoubleClickHook  = $ad000006
CONST   MUIA_TextEditor_ExportHook       = $ad000008
CONST   MUIA_TextEditor_ExportWrap       = $ad000009
CONST   MUIA_TextEditor_FixedFont        = $ad00000a
CONST   MUIA_TextEditor_Flow             = $ad00000b
CONST   MUIA_TextEditor_HasChanged       = $ad00000c
CONST   MUIA_TextEditor_HorizontalScroll = $ad00002d /* Private and experimental! */
CONST   MUIA_TextEditor_ImportHook       = $ad00000e
CONST   MUIA_TextEditor_ImportWrap       = $ad000010
CONST   MUIA_TextEditor_InsertMode       = $ad00000f
CONST   MUIA_TextEditor_InVirtualGroup   = $ad00001b
CONST   MUIA_TextEditor_KeyBindings      = $ad000011
CONST   MUIA_TextEditor_NumLock          = $ad000018
CONST   MUIA_TextEditor_Pen              = $ad00002e
CONST   MUIA_TextEditor_PopWindow_Open   = $ad000003 /* Private!!! */
CONST   MUIA_TextEditor_Prop_DeltaFactor = $ad00000d
CONST   MUIA_TextEditor_Prop_Entries     = $ad000015
CONST   MUIA_TextEditor_Prop_First       = $ad000020
CONST   MUIA_TextEditor_Prop_Release     = $ad000001 /* Private!!! */
CONST   MUIA_TextEditor_Prop_Visible     = $ad000016
CONST   MUIA_TextEditor_Quiet            = $ad000017
CONST   MUIA_TextEditor_ReadOnly         = $ad000019
CONST   MUIA_TextEditor_RedoAvailable    = $ad000013
CONST   MUIA_TextEditor_Separator        = $ad00002c
CONST   MUIA_TextEditor_Slider           = $ad00001a
CONST   MUIA_TextEditor_StyleBold        = $ad00001c
CONST   MUIA_TextEditor_StyleItalic      = $ad00001d
CONST   MUIA_TextEditor_StyleUnderline   = $ad00001e
CONST   MUIA_TextEditor_TypeAndSpell     = $ad000007
CONST   MUIA_TextEditor_UndoAvailable    = $ad000012
CONST   MUIA_TextEditor_WrapBorder       = $ad000021

CONST   MUIM_TextEditor_AddKeyBindings   = $ad000022
CONST   MUIM_TextEditor_ARexxCmd         = $ad000023
CONST   MUIM_TextEditor_ClearText        = $ad000024
CONST   MUIM_TextEditor_ExportText       = $ad000025
CONST   MUIM_TextEditor_HandleError      = $ad00001f
CONST   MUIM_TextEditor_InsertText       = $ad000026
CONST   MUIM_TextEditor_MacroBegin       = $ad000027
CONST   MUIM_TextEditor_MacroEnd         = $ad000028
CONST   MUIM_TextEditor_MacroExecute     = $ad000029
CONST   MUIM_TextEditor_MarkText         = $ad00002c
CONST   MUIM_TextEditor_Replace          = $ad00002a
CONST   MUIM_TextEditor_Search           = $ad00002b
OBJECT muip_texteditor_arexxcmd
    methodid
    command:PTR TO CHAR
ENDOBJECT
OBJECT muip_texteditor_cleartext
    methodid
ENDOBJECT
OBJECT muip_texteditor_exporttext
    methodid
ENDOBJECT
OBJECT muip_texteditor_handleerror
    methodid
    errorcode
ENDOBJECT /* See below for error codes */
OBJECT muip_texteditor_inserttext
    methodid
    text:PTR TO CHAR
    pos
ENDOBJECT /* See below for positions */
OBJECT muip_texteditor_marktext
    methodid
    start_crsr_x
    start_crsr_y
    stop_crsr_x
    stop_crsr_y
ENDOBJECT

CONST   MUIV_TextEditor_ExportHook_Plain       = $00000000
CONST   MUIV_TextEditor_ExportHook_EMail       = $00000001

CONST   MUIV_TextEditor_Flow_Left              = $00000000
CONST   MUIV_TextEditor_Flow_Center            = $00000001
CONST   MUIV_TextEditor_Flow_Right             = $00000002
CONST   MUIV_TextEditor_Flow_Justified         = $00000003

CONST   MUIV_TextEditor_ImportHook_Plain       = $00000000
CONST   MUIV_TextEditor_ImportHook_EMail       = $00000002
CONST   MUIV_TextEditor_ImportHook_MIME        = $00000003
CONST   MUIV_TextEditor_ImportHook_MIMEQuoted  = $00000004

CONST   MUIV_TextEditor_InsertText_Cursor      = $00000000
CONST   MUIV_TextEditor_InsertText_Top         = $00000001
CONST   MUIV_TextEditor_InsertText_Bottom      = $00000002

CONST   MUIV_TextEditor_LengthHook_Plain       = $00000000
CONST   MUIV_TextEditor_LengthHook_ANSI        = $00000001
CONST   MUIV_TextEditor_LengthHook_HTML        = $00000002
CONST   MUIV_TextEditor_LengthHook_MAIL        = $00000003


/* Error codes given as argument to MUIM_TextEditor_HandleError */
CONST   ERROR_ClipboardIsEmpty         = $01
CONST   ERROR_ClipboardIsNotFTXT       = $02
CONST   ERROR_MacroBufferIsFull        = $03
CONST   ERROR_MemoryAllocationFailed   = $04
CONST   ERROR_NoAreaMarked             = $05
CONST   ERROR_NoMacroDefined           = $06
CONST   ERROR_NothingToRedo            = $07
CONST   ERROR_NothingToUndo            = $08
CONST   ERROR_NotEnoughUndoMem         = $09 /* This will cause all the stored undos to be freed */
CONST   ERROR_StringNotFound           = $0a
CONST   ERROR_NoBookmarkInstalled      = $0b
CONST   ERROR_BookmarkHasBeenLost      = $0c

OBJECT clickmessage
   linecontents:PTR TO CHAR  /* This field is ReadOnly!!! */
   clickposition:LONG
ENDOBJECT

/* Definitions for Separator type */

CONST LNSB_Top            = 0 /* Mutual exclude: */
CONST LNSB_Middle         = 1 /* Placement of    */
CONST LNSB_Bottom         = 2 /*  the separator  */
CONST LNSB_StrikeThru     = 3 /* Let separator go thru the textfont */
CONST LNSB_Thick          = 4 /* Extra thick separator */

CONST LNSF_Top            = 1  -> (1<<LNSB_Top)
CONST LNSF_Middle         = 2  -> (1<<LNSB_Middle)
CONST LNSF_Bottom         = 4  -> (1<<LNSB_Bottom)
CONST LNSF_StrikeThru     = 8  -> (1<<LNSB_StrikeThru)
CONST LNSF_Thick          = 16 -> (1<<LNSB_Thick)

