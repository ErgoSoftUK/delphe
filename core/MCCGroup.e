/*
** DelphE MCCGroup object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes'

OBJECT mccGroup OF mccBase
ENDOBJECT

PROC create(atts) OF mccGroup
  self.handle := Mui_NewObjectA(MUIC_Balance, atts)
ENDPROC

PROC createHoriz() OF mccGroup
  self.create([MUIA_Group_Horiz, MUI_TRUE])
ENDPROC

PROC createVert() OF mccGroup
  self.create(NIL)
ENDPROC

PROC createPaged() OF mccGroup
  self.create([MUIA_Group_PageMode, MUI_TRUE])
ENDPROC


