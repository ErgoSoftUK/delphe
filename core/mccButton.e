/*
** DelphE MCCButton object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes', 'DelphE/StringUtils'

OBJECT mccButton OF mccBase
ENDOBJECT

PROC create(label) OF mccButton
  self.handle := SimpleButton(StrAlloc(label))
ENDPROC

PROC onClick() OF mccButton
ENDPROC [self, [MUIM_Notify, MUIA_Pressed, FALSE]]
