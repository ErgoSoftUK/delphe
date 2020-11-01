

PROC main()
  DEF str[100]:STRING, res

  str:=StrAdd(str, 'PROC main() WriteF(Hello World) ENDPROC leftover')
  WriteF('str : [\s]\n', str)

  res := strReplace(str, 'PROC', '')
  WriteF('Result [\s]\n', res)
ENDPROC

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