
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
  CHECKMEM
  ENDTEST

  TEST('add expand -  memory')
    NEW actual.create(2)
    FOR i:=0 TO 100
      actual.add(String(10))
    ENDFOR

    actual.clear(TRUE)
    actual.end()
  CHECKMEM
  ENDTEST

  TEST('Sort')
    NEW actual.create(5)
    actual.add('Hello')
    actual.add('To')
    actual.add('The')
    actual.add('Entire')
    actual.add('Planet')
    actual.sortStr()
    FOR i:=0 TO 4
      WriteF('\d: [\s]\n', i, actual.getItem(i))
    ENDFOR
  ENDTEST


ENDPROC
