/*
** StringUtils
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

#define StrConcat(s1, s2) s1:=strConcat(s1, s2)

PROC strClone(str)
  DEF clone, l
  l := StrLen(str)
  clone := String(l)
  StrCopy(clone, str, l)
ENDPROC clone

PROC strConcat(s, v)
  DEF t, len

  len := StrLen(s) + StrLen(v)

  IF StrMax(s) >= len
    StrAdd(s, v)
  ELSE
    t:=String(len)
    StrCopy(t, s)
    StrAdd(t, v)
    DisposeLink(s)
    s:=t
  ENDIF
ENDPROC s

PROC strPrepend(s, v)
  DEF t

  t:=String(StrLen(v) + StrLen(s))
  StrCopy(t, v)
  StrAdd(t, s)
  DisposeLink(s)
  s:=t
ENDPROC s

PROC strEndsWith(s, v)
  DEF t, l, r
  l:=StrLen(s) - StrLen(v)

  t:=String(l)
  MidStr(t, s, l)
  r:=StrCmp(t, v)

  DisposeLink(t)
ENDPROC r

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
      DisposeLink(chunk)
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
    DisposeLink(chunk)
  ENDIF

  DisposeLink(str)
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
