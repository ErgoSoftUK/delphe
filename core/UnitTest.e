/*
*	UNIT TEST HELPER
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'devices/timer', 'DelphE/timer'

#define TEST(name) NEW ut.create(name)
#define ENDTEST ut.finish()
#define CHECKS ut.checks()

#define AssertStrEqual(s1, s2) ut.assertStrEqual(s1, s2)
#define AssertTrue(s1) ut.assertTrue(s1)
#define AssertFalse(s1) ut.assertTrue(s1=FALSE)
#define AssertEquals(s1, s2) ut.assertEquals(s1, s2)

OBJECT unitTest
  name,
  t: PTR TO timer,
  time: PTR TO timeval,
  mmry: LONG
ENDOBJECT

PROC create(testName) OF unitTest
  DEF time: timeval

  self.name := testName

  WriteF('----------------------------------------\n')
  WriteF('Running test \s\n', self.name)

  NEW self.t
  self.time := self.t.getTime()

  self.mmry := AvailMem(0)
ENDPROC

PROC checks() OF unitTest
  DEF endTime: timeval

  endTime := self.t.getTime()
  self.mmry := self.mmry - AvailMem(0)

  WriteF('----------------------------------------\n')
  WriteF('S: \d.\d\n', self.time.secs, self.time.micro)
  WriteF('E: \d.\d\n', endTime.secs, endTime.micro)

  self.time.secs := endTime.secs - self.time.secs
  self.time.micro:= endTime.micro - self.time.micro
  WriteF('D: \d.\d\n', self.time.secs, self.time.micro)
  Dispose(endTime)

  IF (self.mmry > 0)
  	 WriteF('\e[37mPotential leak\e[39m: [\d] bytes\n', self.mmry)
  ENDIF
ENDPROC

PROC finish() OF unitTest
  Dispose(self.time)
  Dispose(self.t)
ENDPROC

PROC assertStrEqual(s1, s2) OF unitTest
  IF StrCmp(s1, s2)
    WriteF('\e[33mPass!\e[39m\n')
  ELSE
    WriteF('\e[37mFail!\e[39m\n')
    WriteF('Expected: [\s]\n', s2)
    WriteF('Actual  : [\s]\n', s1)
  ENDIF
ENDPROC

PROC assertTrue(s1) OF unitTest
  IF s1
    WriteF('\e[33mPass!\e[39m\n')
  ELSE
    WriteF('\e[37mFail!\e[39m\n')
  ENDIF
ENDPROC

PROC assertEquals(s1, s2) OF unitTest
  IF s1 = s2
    WriteF('\e[33mPass!\e[39m\n')
  ELSE
    WriteF('\e[37mFail!\e[39m\n')
    WriteF('Expected: [\s]\n', s2)
    WriteF('Actual  : [\s]\n', s1)
  ENDIF
ENDPROC
