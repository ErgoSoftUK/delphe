
OPT PREPROCESS

MODULE 'DelphE/timer', 'DelphE/UnitTest', 'devices/timer'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual: timeval, t1: timeval, t: PTR TO timer

  NEW t

  TEST('GetTime memory')
    actual := t.getTime()
    Dispose(actual)
  CHECKMEM
  ENDTEST

  TEST('Difference memory')
    NEW t1
    t1.secs := 0
    t1.micro:= 0

    actual := t.difference(t1, t1)

    Dispose(t1)
    Dispose(actual)
  CHECKMEM
  ENDTEST
ENDPROC
