/*
** DelphE MCCBalance object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes'

OBJECT mccBalance OF mccBase
ENDOBJECT

PROC create() OF mccBalance
  self.handle := Mui_NewObjectA(MUIC_Balance, NIL)
ENDPROC


