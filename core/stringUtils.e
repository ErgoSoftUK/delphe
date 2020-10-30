/*
** StringUtils
*/

OPT MODULE
OPT EXPORT

PROC strClone(str)
  DEF clone, l
  l := StrLen(str)
  clone := String(l)
  StrCopy(clone, str, l)
ENDPROC clone

PROC strConcat(s, v)
    DEF t
    t:=String(StrLen(s) + StrLen(v))
    StrCopy(t, s)
    StrAdd(t, v)
    Dispose(s)
ENDPROC t

PROC strPrepend(s, v)
    DEF t
    t:=String(StrLen(v) + StrLen(s))
    StrCopy(t, v)
    StrAdd(t, s)
    Dispose(s)
ENDPROC t

PROC strEndsWith(s, v)
  DEF t, l
  l:=StrLen(v)
  t:=String(l)
  RightStr(t, s,l)
ENDPROC StrCmp(t,v)