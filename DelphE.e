/*
** DelphE by Ergonomic Software Solutions Ltd
*/

OPT PREPROCESS
OPT OSVERSION=39

MODULE 'DelphE/mccApplication', 'DelphE/Logger', '*mainWin'

PROC main()
  DEF application: PTR TO mccApplication,
      mainWin: PTR TO tMainWindow

  DEBUG('Create application\n')
  NEW application.create()

  DEBUG('Create main window\n')
  NEW mainWin.create()

  DEBUG('Run application\n')
  application.run(mainWin)

ENDPROC

