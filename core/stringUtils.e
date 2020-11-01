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

PROC strReplace(str, from, to)
  DEF i, l, buf, pos, chunk
  i := strCount(str, from)

  l := StrLen(str) + ((StrLen(to)-StrLen(from))*i)
  buf := String(l)
  
  i := 0
  pos := InStr(str, from)
  WHILE pos > -1
    IF (pos > 0)
      l := pos - i
      chunk := String(l)
      MidStr(chunk, str, i, l)
      StrAdd(buf, chunk)
      Dispose(chunk)
    ENDIF
    StrAdd(buf, to)
    i := pos + StrLen(from)
    pos := InStr(str, from, pos + 1)
  ENDWHILE

  l := StrLen(str) - i
  IF l > 0
    chunk := String(l)
    MidStr(chunk, str, i, l)
    StrAdd(buf, chunk)
    Dispose(chunk)   
  ENDIF
ENDPROC buf

PROC strCount(str, text)
  DEF i, pos
  i:=0
  pos := InStr(str, text)
  WHILE pos > -1
    i++
    pos := InStr(str, text, pos+1)
  ENDWHILE
ENDPROC i
