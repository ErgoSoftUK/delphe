/*
** DelphE MCCRectangle object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes'

OBJECT mccRectangle OF mccBase
ENDOBJECT

PROC create() OF mccRectangle
  self.handle := Mui_NewObjectA(MUIC_Rectangle, NIL)
ENDPROC


