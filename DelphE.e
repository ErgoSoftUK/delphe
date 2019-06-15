/*
** DelphE by Ergonomic Software Solutions Ltd
*/

OPT PREPROCESS
OPT OSVERSION=39

MODULE 'DelphE/mccApplication', '*mainWin'

PROC main()
  DEF application: PTR TO mccApplication,
      mainWin: PTR TO tMainWindow

  NEW application.create()

  NEW mainWin.create()

  application.run(mainWin)
ENDPROC

