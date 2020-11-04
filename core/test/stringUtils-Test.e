
OPT PREPROCESS

MODULE 'DelphE/stringUtils', 'DelphE/UnitTest'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual

  actual:=String(100)

  TEST('StrAdd')
  	 StrAdd(actual, 'Hello ')
    StrAdd(actual, 'World')
  CHECKS
    AssertStrEqual(actual, 'Hello World')
  ENDTEST

  actual:=String(100)
  TEST('strConcat-big enough')
    StrConcat(actual, 'Hello ')
    StrConcat(actual, 'World!')
  CHECKS
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(1)
  TEST('strConcat-too small')
    StrConcat(actual, 'Hello ')
    StrConcat(actual, 'World!')
  CHECKS
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(100)
  TEST('strPrepend-big enough')
    actual := strPrepend(actual, 'World!')
    actual := strPrepend(actual, 'Hello ')
  CHECKS
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  actual:=String(1)
  TEST('strPrepend-too small')
    actual := strPrepend(actual, 'World!')
    actual := strPrepend(actual, 'Hello ')
  CHECKS
    AssertStrEqual(actual, 'Hello World!')
  ENDTEST

  TEST('strEndsWith-TRUE')
    actual := strEndsWith('Hello World', 'World')
  CHECKS
    AssertTrue(actual)
  ENDTEST

  TEST('strEndsWith-FALSE')
    actual := strEndsWith('Hello World', 'Hello')
  CHECKS
    AssertFalse(actual)
  ENDTEST

  TEST('strCount')
    actual := strCount('Hello World', 'l')
  CHECKS
    AssertEquals(actual, 3)
  ENDTEST

  actual:=String(100)
  StrCopy(actual, 'Hello World')
  TEST('strReplace')
    actual := strReplace(actual, 'll', 'DOUBLE_ELL')
  CHECKS
    AssertStrEqual(actual, 'HeDOUBLE_ELLo World')
  ENDTEST

ENDPROC
