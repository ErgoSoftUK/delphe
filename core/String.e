OPT MODULE
OPT EXPORT

/*** GLOBAL STRING FUNCTIONS ***/
PROC strClone(str)
  DEF clone, l
  l := StrLen(str)
  clone := String(l)
  StrCopy(clone, str, l)
ENDPROC clone

/*** STRING OBJECT FUNCTIONS ***/
OBJECT string
  value
ENDOBJECT

PROC create(v) OF string
  self.value:=String(StrLen(v))
  StrCopy(self.value, v)
ENDPROC

PROC len() OF string
ENDPROC StrLen(self.value)

PROC clone() OF string
    DEF s: PTR TO string
    NEW s.create(self.value)
ENDPROC s

PROC concat(v) OF string
    DEF t
    t:=self.value
    self.value:=String(StrLen(self.value) + StrLen(v))
    StrCopy(self.value, t)
    StrAdd(self.value, v)
    Dispose(t)
ENDPROC

PROC prepend(v) OF string
    DEF t
    t:=String(StrLen(v) + StrLen(self.value))
    StrCopy(t, v)
    StrAdd(t, self.value)
    Dispose(self.value)
    self.value:=t
ENDPROC

PROC end() OF string
    Dispose(self.value)
ENDPROC

PROC endsWith(v) OF string
  DEF s, l

  l:=StrLen(v)

  s:=String(l)
  RightStr(s, self.value,l)
ENDPROC StrCmp(s,v)
