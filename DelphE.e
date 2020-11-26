/*
** DelphE by Ergonomic Software Solutions Ltd
**
** CONTENTS OF THIS FILE TO BE AUTO GENERATED IN FUTURE!
*/

OPT PREPROCESS
OPT OSVERSION=39

MODULE 'muimaster', 'libraries/mui', 'DelphE/mccApplication', 'DelphE/mccCodeEditor', 'DelphE/Logger', 
    'DelphE/StringUtils', 'DelphE/mccToolbar', 'DelphE/mccBalance', 'DelphE/mccRectangle', 'DelphE/mccListTree', 'DelphE/FileUtils',
    'mui/toolbar_mcc', 'utility/tagitem', 'amigalib/boopsi', '*mainWin', 'DelphE/mccBase'

DEF application: PTR TO mccApplication,
     mainWin: PTR TO tMainWindow

PROC main()
  DEBUG('Initialize')
  initialize()

  /*** MAIN WINDOW ***/
  DEBUG('Create main window\n')
  NEW mainWin
  DEBUG('Instanciate components\n')

  NEW mainWin.fu
  NEW mainWin.codeEditor.create()
  mainWin.codeEditor.setFixedFont(MUI_TRUE)

  NEW mainWin.toolbar
  mainWin.toolbar.definition := [MUIA_Toolbar_ImageType, MUIV_Toolbar_ImageType_File,
              MUIA_Toolbar_ImageNormal, 'PROGDIR:Images/ButtonBank1.iff',
              MUIA_Toolbar_ImageSelect, 'PROGDIR:Images/ButtonBank1s.bsh',
              MUIA_Toolbar_ImageGhost, 'PROGDIR:Images/ButtonBank1g.bsh',
              MUIA_Toolbar_Description, buildBank([
                Toolbar_HintButton(0, 'Open',  "o"),
                Toolbar_HintButton(0, 'New',   "n"),
                Toolbar_HintButton(0, 'Save',  "s"),
                Toolbar_Space,
                Toolbar_HintButton(0, 'Compile',"c"),
                Toolbar_HintButton(0, 'Build',  "b"),
                Toolbar_HintButton(TDF_GHOSTED, 'Run',    "r"),
                Toolbar_HintButton(TDF_GHOSTED, 'Debug',  "d"),
                Toolbar_End
              ]),
              -> MUIA_Font, MUIV_Font_Small,
              MUIA_ShortHelp, TRUE,
              MUIA_Draggable, FALSE,
              TAG_END
            ]
  mainWin.toolbar.create()
  NEW mainWin.b1.create()
  NEW mainWin.b2.create()
  NEW mainWin.spc.create()
  NEW mainWin.con.create()
  mainWin.con.setWeight(20)
  NEW mainWin.treelist.create()
    mainWin.treelist.setWeight(25)


  DEBUG('Window create\n')
    mainWin.handle := WindowObject,
      MUIA_Window_Title    , 'ErgoSoft DelphE v0.1 (beta)',
      MUIA_Window_ID       , 'APPW',
      MUIA_Window_AppWindow, MUI_TRUE,
      WindowContents,
        VGroup,
          Child, HGroup,
            Child, mainWin.toolbar.handle,
            Child, mainWin.spc.handle,
          End,

          Child, HGroup,
            Child, mainWin.treelist.handle,
            Child, mainWin.b1.handle,
            Child, mainWin.codeEditor.handle,
          End,
          Child, mainWin.b2.handle,
          Child, mainWin.con.handle,
        End,
      End


  /*** APPLICATION ***/
  DEBUG('Create application\n')
  NEW application
  application.title       := 'DelphE'
  application.version     := '$VER: DelphE 0.1 (22.06.2018)'
  application.copyright   := '(c)2018 Ergonomic Software Solutions Ltd'
  application.author      := 'Richard Collier'
  application.description := 'Borland Delphi inspired development enviroment for Amiga '
  application.base        := 'DELPHE'

  application.create([mainWin])

    /*** EVENT HOOKS ***/
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_NEW), `mainWin.newClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_OPEN), `mainWin.openClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_SAVE), `mainWin.saveClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_COMPILE), `mainWin.compileClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_BUILD), `mainWin.buildClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_RUN), `mainWin.runClick())
  mainWin.hookEvent(application, mainWin.toolbar.onClick(BTN_DEBUG), `mainWin.debugClick())
  mainWin.hookEvent(application, mainWin.treelist.onDblClick(), `mainWin.treeSelectChange())


    /*** RUN APP ***/

    DEBUG('Run window\n')
    application.openWindow(mainWin)

    DEBUG('Quit application\n')
  cleanup()
ENDPROC

PROC initialize() HANDLE
  DEBUG('Opening MUI\n')
  IF (muimasterbase:= OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimaster.library')
EXCEPT
  cleanup()
ENDPROC

PROC cleanup()
  DEBUG('Cleanup\n')
  IF application.handle THEN Mui_DisposeObject(application.handle)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n', exception)
ENDPROC
