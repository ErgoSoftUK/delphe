/*
** DelphE MCCCycle object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes'

OBJECT mccCycle OF mccBase
ENDOBJECT

PROC create() OF mccCycle
  self.handle := Mui_NewObjectA(MUIC_Cycle, NIL)
ENDPROC
