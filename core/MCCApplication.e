/*
** Application class
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'amigalib/boopsi', 'utility/tagitem',
       'DelphE/mccBase', 'DelphE/mccWindow', 'DelphE/Logger'

OBJECT mccApplication OF mccBase
  title,
  version,
  copyright,
  author,
  description,
  base
ENDOBJECT

DEF application: PTR TO mccApplication

PROC create(winList: PTR TO LONG) OF mccApplication
    DEF win: PTR TO mccWindow
    DEF app, i, l

    l := ListLen(winList)
    WriteF('Window count \d\n', l)

    IF l = 0 THEN Raise('Application has no windows')

   app := List((ListLen(winList) * 2) + 15)

   app := ListCopy(app, [TAG_IGNORE, 0,
        MUIA_Application_Title      , self.title,
        MUIA_Application_Version    , self.version,
        MUIA_Application_Copyright  , self.copyright,
        MUIA_Application_Author     , self.author,
        MUIA_Application_Description, self.description,
        MUIA_Application_Base       , self.base])

   FOR i:=0 TO ListLen(winList) - 1
      win := winList[i]
        app := ListAdd(app, [SubWindow, win.handle])
   ENDFOR

   app := ListAdd(app, [TAG_DONE])

   l := ListLen(app)
    WriteF('App count \d\n', l)

   DEBUG('Create app object\n')
   self.handle := Mui_NewObjectA(MUIC_Application, app)

    IF self.handle = NIL THEN Raise('Failed to create application')
ENDPROC

PROC openWindow(win:PTR TO mccWindow) OF mccApplication
  DEF sigs, running, result, evt: PTR TO mccEvent

  -> Add application quit handler to window
  DEBUG('Hook close event\n')

  DEBUG('Open window\n')
  set(win.handle, MUIA_Window_Open, MUI_TRUE)

  DEBUG('Call windows onOpen()\n')
  win.onOpen()

  doMethodA(win.handle, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE, self.handle, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])

  running:=TRUE

  WHILE running
    result:=doMethodA(self.handle,[MUIM_Application_Input,{sigs}])

    SELECT result
      CASE MUIV_Application_ReturnID_Quit
        DEBUG('App quit\n')
        running := FALSE
      DEFAULT
        IF (result > 0)
          evt:=result
          evt.handler.handleEvent(evt)
        ENDIF
    ENDSELECT

    IF sigs THEN sigs:=Wait(sigs)
  ENDWHILE

  DEBUG('Close window\n')
  set(win.handle, MUIA_Window_Open, FALSE)
ENDPROC


