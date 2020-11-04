
OPT PREPROCESS

MODULE 'DelphE/UnitTest', 'DelphE/array'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual: PTR TO arr, i

  TEST('add - memory')
    NEW actual.create(10)
    FOR i:=0 TO 9
      actual.add(String(10))
    ENDFOR

    actual.clear(TRUE)
    actual.end()
  CHECKS
  ENDTEST

  TEST('add expand -  memory')
    NEW actual.create(2)
    FOR i:=0 TO 100
      actual.add(String(10))
    ENDFOR

    actual.clear(TRUE)
    actual.end()
  CHECKS
  ENDTEST

ENDPROC
