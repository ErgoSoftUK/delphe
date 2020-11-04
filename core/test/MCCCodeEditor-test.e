
OPT PREPROCESS

MODULE 'DelphE/UnitTest', 'DelphE/MCCCodeEditor', 'DelphE/StringUtils'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual, obj: PTR TO mccCodeEditor

  NEW obj

  TEST('parse - memory')
    actual := String(5)
    actual := StrConcat(actual, 'OPT PREPROCESS\nOBJECT foo\nENDOBJECT\nPROC main() OF foo\n\tDEF f:PTR TO foo\n\tNEW f\n\tWriteF(\aHello world\\n\a)\nENDPROC\n')
    actual := obj.parse(actual)
    DisposeLink(actual)
  CHECKMEM
  ENDTEST

  TEST('add expand -  memory')
    actual := String(5)
    actual := StrConcat(actual, 'OPT PREPROCESS\nOBJECT foo\nENDOBJECT\nPROC main() OF foo\n\tDEF f:PTR TO foo\n\tNEW f\n\tWriteF(\aHello world\\n\a)\nENDPROC\n')
    actual := obj.parse(actual)
    AssertStrEqual(actual, '\eb\ep[18]OPT\en\ep[0] PREPROCESS\n\eb\ep[18]OBJECT\en\ep[0] foo\n\eb\ep[18]ENDOBJECT\en\ep[0]\n\eb\ep[18]PROC\en\ep[0] main() \eb\ep[18]OF\en\ep[0] foo\n\t\eb\ep[18]DEF\en\ep[0] f:\eb\ep[18]PTR TO\en\ep[0] foo\n\t\eb\ep[18]NEW\en\ep[0] f\n\tWriteF(\aHello world\\n\a)\n\eb\ep[18]ENDPROC\en\ep[0]\n')
    DisposeLink(actual)
  ENDTEST

ENDPROC
