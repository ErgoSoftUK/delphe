/*
** Application class
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'amigalib/boopsi', 'utility/tagitem',
       'DelphE/mccBase', 'DelphE/mccWindow', 'DelphE/Logger'

OBJECT mccApplication OF mccBase
ENDOBJECT

PROC create() OF mccApplication HANDLE
  DEBUG('Opening MUI\n')
  IF (muimasterbase:= OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimaster.library')

EXCEPT
  self.cleanup()
ENDPROC

PROC run(win: PTR TO mccWindow) OF mccApplication

  DEBUG('Create app object\n')
  self.handle := ApplicationObject,
    MUIA_Application_Title      , 'DelphE',
    MUIA_Application_Version    , '$VER: DelphE 0.1 (22.06.2018)',
    MUIA_Application_Copyright  , 'c2018 Ergonomic Software Solutions Ltd',
    MUIA_Application_Author     , 'Richard Collier',
    MUIA_Application_Description, 'Borland Delphi inspired development enviroment for Amiga ',
    MUIA_Application_Base       , 'DELPHE',
    SubWindow, win.handle,
  End

  IF self.handle = NIL THEN Raise('Failed to create application')

  DEBUG('Run window\n')
  self.openWindow(win)

  DEBUG('Quit application\n')
  self.cleanup()
ENDPROC

PROC openWindow(win:PTR TO mccWindow) OF mccApplication
  DEF sigs, running, result, evt: PTR TO mccEvent

  -> Add application quit handler to window
  DEBUG('Hook close event\n')

  DEBUG('Hook windows own events\n')
  win.hookEvents(self)

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

PROC cleanup() OF mccApplication
  DEBUG('Cleanup\n')
  IF self.handle THEN Mui_DisposeObject(self.handle)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n', exception)
ENDPROC

