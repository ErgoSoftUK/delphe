
OPT PREPROCESS

MODULE 'DelphE/stringUtils', 'DelphE/UnitTest'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual

  actual:=String(10)
  TEST('strConcat-memtest')
    actual:=StrConcat(actual, 'Hello ')
    actual:=StrConcat(actual, 'World!')
  CHECKMEM
  ENDTEST

  actual:=String(100)
  TEST('strConcat-big enough')
    StrConcat(actual, 'Hello ')
    StrConcat(actual, 'World!')
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(1)
  TEST('strConcat-too small')
    actual:=StrConcat(actual, 'Hello ')
    actual:=StrConcat(actual, 'World!')
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(100)
  TEST('strPrepend-big enough')
    actual := strPrepend(actual, 'World!')
    actual := strPrepend(actual, 'Hello ')
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(1)
  TEST('strPrepend-too small')
    actual := strPrepend(actual, 'World!')
    actual := strPrepend(actual, 'Hello ')
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  TEST('strEndsWith-TRUE')
    actual := strEndsWith('Hello World', 'World')
    AssertTrue(actual)
  ENDTEST

  TEST('strEndsWith-FALSE')
    actual := strEndsWith('Hello World', 'Hello')
    AssertFalse(actual)
  ENDTEST

  TEST('strCount')
    actual := strCount('Hello World', 'l')
    AssertEquals(actual, 3)
  ENDTEST

  actual:=String(1)
  actual:=StrConcat(actual, 'Hello World')
  TEST('strReplace')
    actual := strReplace(actual, 'll', 'DOUBLE_ELL')
    AssertStrEqual(actual, 'HeDOUBLE_ELLo World')
  ENDTEST

ENDPROC
