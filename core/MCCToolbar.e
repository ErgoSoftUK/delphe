/*
** DelphE MCCToolbar object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/toolbar_mcc'

OBJECT mccToolbar OF mccBase
ENDOBJECT

PROC create(attributes) OF mccToolbar
  self.handle := Mui_NewObjectA(MUIC_Toolbar, attributes)
ENDPROC

/** EVENTS **/

PROC onClick(idx) OF mccToolbar
ENDPROC [self, [MUIM_Toolbar_Notify, idx, MUIV_Toolbar_Notify_Pressed, FALSE]]
