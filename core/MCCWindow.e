/*
** DelphE MCCWindow object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'amigalib/boopsi', 'utility/tagitem',
       'DelphE/mccBase', 'DelphE/mccApplication', 'DelphE/Logger'

OBJECT mccWindow OF mccBase
PRIVATE
    content
ENDOBJECT

DEF delpheApplication: PTR TO mccApplication

PROC setContent(c) OF mccWindow
  DEBUG('Set window content\n')
  self.content := c
ENDPROC

PROC create() OF mccWindow
  DEBUG('Window create\n')
    self.handle := WindowObject,
        MUIA_Window_Title    , 'ErgoSoft DelphE v0.1 (beta)',
        MUIA_Window_ID       , "APPW",
        MUIA_Window_AppWindow, MUI_TRUE,
        WindowContents, self.content, End
ENDPROC

PROC show() OF mccWindow
  DEBUG('Window show\n')
  delpheApplication.openWindow(self)
ENDPROC

PROC hookEvents(app) OF mccWindow IS EMPTY

PROC onOpen() OF mccWindow IS EMPTY
