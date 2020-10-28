/*
** Application class
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'amigalib/boopsi', 'utility/tagitem',
       'DelphE/mccBase', 'DelphE/mccWindow'

OBJECT mccApplication OF mccBase
  window: PTR TO mccWindow
PRIVATE
ENDOBJECT

PROC create() OF mccApplication HANDLE
  WriteF('Opening muimaster\n')
  IF (muimasterbase:= OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimaster.library')
EXCEPT
  self.cleanup()
ENDPROC

PROC initialize() OF mccApplication HANDLE
 WriteF('Initializing\n')
  self.handle := ApplicationObject,
    MUIA_Application_Title      , 'DelphE',
    MUIA_Application_Version    , '$VER: DelphE 0.1 (22.06.2018)',
    MUIA_Application_Copyright  , 'c2018 Ergonomic Software Solutions Ltd',
    MUIA_Application_Author     , 'Richard Collier',
    MUIA_Application_Description, 'Borland Delphi inspired development enviroment for Amiga ',
    MUIA_Application_Base       , 'DELPHE',
    SubWindow, self.window.handle,
  End

  IF self.handle = NIL THEN Raise('Failed to create application')

  self.window.hookEvents(self)

  WriteF('Open window\n')
  set(self.window.handle,MUIA_Window_Open,MUI_TRUE)
  self.window.onOpen()
EXCEPT
  self.cleanup()
ENDPROC

PROC run(mainWin:PTR TO mccWindow) OF mccApplication
  DEF sigs, running, result, evt: PTR TO mccEvent

  self.window := mainWin
  self.initialize()

  -> Add application quit handler to window
  doMethodA(self.window.handle, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE, self.handle,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  WriteF('Run!!!\n')
  running:=TRUE

  WHILE running
    result:=doMethodA(self.handle,[MUIM_Application_Input,{sigs}])

    SELECT result
      CASE MUIV_Application_ReturnID_Quit
        running := FALSE
      DEFAULT
        IF (result > 0)
          WriteF('Notified!\n')
          evt:=result
          evt.handler.handleEvent(evt)
        ENDIF
    ENDSELECT

    IF sigs THEN sigs:=Wait(sigs)
  ENDWHILE

  set(self.window.handle,MUIA_Window_Open,FALSE)
  self.cleanup()
ENDPROC

PROC cleanup() OF mccApplication
  WriteF('Cleaning up\n')
  IF self.handle THEN Mui_DisposeObject(self.handle)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n', exception)
ENDPROC

