
OPT PREPROCESS

MODULE 'DelphE/fileutils', 'DelphE/UnitTest', 'DelphE/array'

DEF ut: PTR TO unitTest

PROC main()
  DEF actual, contents: PTR TO arr, fu: fileUtils, testData, i

  NEW fu
  testData := String(100)
  StrCopy(testData, 'Hello world')

  -> Write once so doesnt show in mem use
  fu.writeFile('T:test', testData)
  TEST('writeFile memory')
    fu.writeFile('T:test', testData)
  CHECKMEM
  ENDTEST

  TEST('readFile memory')
    actual := fu.readFile('T:test')
    Dispose(actual)
  CHECKMEM
  ENDTEST

  TEST('contents memory')
    contents := fu.contents('T:test')
    contents.clear(TRUE)
    contents.end()
  CHECKMEM
  ENDTEST

ENDPROC
