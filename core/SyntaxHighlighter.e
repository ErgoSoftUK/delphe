/*
*  Syntax highlighting functions
*/

OPT MODULE

MODULE 'DelphE/stringutils', 'Tools/file'

EXPORT PROC loadAndHighlight(filename)
  DEF buf, t, l, c, lines: PTR TO LONG, i
  
  buf,l:=readfile(filename)
  buf[l] := 0

  c:=countstrings(buf, l)
  lines:=stringsinfile(buf, l, c)
  -> DisposeLink(buf)

  l := 0
  FOR i:=0 TO c-1
    t := lines[i]
    lines[i] := highlightKeywords(t)
    l := l + StrLen(lines[i])
    -> DisposeLink(t)
  ENDFOR

  -> buf := lines

  -> Rebuild lines back into buffer
  buf := New(l+c+1)

  i:=0
  FOR l:=0 TO ListLen(lines)-1
    FOR c:=0 TO StrLen(lines[l])-1
      buf[i] := lines[l][c]
      INC i
    ENDFOR
    buf[i] := "\n"
    INC i
  ENDFOR
  buf[i] := 0

ENDPROC buf

EXPORT PROC stripAndSave(text, filename)
  DEF l, c, lines: PTR TO LONG, i, fh

  IF (fh:=Open(filename, NEWFILE))=NIL THEN Throw("OPEN", filename)

  l := StrLen(text)
  c := countstrings(text, l)
  lines := stringsinfile(text, l, c)

  FOR i := 0 TO c-1
    text := stripHighlights(lines[i])
    Write(fh, text, StrLen(text))
    Write(fh, '\n', 1)
  ENDFOR
  Close(fh)
  Dispose(fh)
ENDPROC

PROC highlightKeywords(text)
  DEF rslt

  rslt := text
  rslt := strReplace(rslt, 'DEF ',        '\eb\ep[18]DEF\en\ep[0] ')
  rslt := strReplace(rslt, 'PTR TO ',     '\eb\ep[18]PTR TO\en\ep[0] ')
  rslt := strReplace(rslt, 'OPT ',        '\eb\ep[18]OPT\en\ep[0] ')
  rslt := strReplace(rslt, 'ENDPROC\0',   '\eb\ep[18]ENDPROC\en\ep[0]\0')
  rslt := strReplace(rslt, 'ENDPROC ',    '\eb\ep[18]ENDPROC\en\ep[0] ')
  rslt := strReplace(rslt, 'PROC ',       '\eb\ep[18]PROC\en\ep[0] ')
  rslt := strReplace(rslt, 'NEW ',        '\eb\ep[18]NEW\en\ep[0] ')
  rslt := strReplace(rslt, 'MODULE ',     '\eb\ep[18]MODULE\en\ep[0] ')
  rslt := strReplace(rslt, 'ENDOBJECT\n', '\eb\ep[18]ENDOBJECT\en\ep[0]\n')
  rslt := strReplace(rslt, 'OBJECT ',     '\eb\ep[18]OBJECT\en\ep[0] ')
  rslt := strReplace(rslt, ' OF ',        ' \eb\ep[18]OF\en\ep[0] ')
  rslt := strReplace(rslt, 'NEW ',        '\eb\ep[18]NEW\en\ep[0] ')
  rslt := strReplace(rslt, 'ENUM ',       '\eb\ep[18]ENUM\en\ep[0] ')
  rslt := strReplace(rslt, 'ENDWHILE\n',  '\eb\ep[18]ENDWHILE\en\ep[0]\n')
  rslt := strReplace(rslt, 'WHILE ',      '\eb\ep[18]WHILE\en\ep[0] ')
  rslt := strReplace(rslt, 'ELSEIF ',     '\eb\ep[18]ELSEIF\en\ep[0] ')
  rslt := strReplace(rslt, 'ELSE\n',      '\eb\ep[18]ELSE\en\ep[0]\n')
  rslt := strReplace(rslt, 'IF ',         '\eb\ep[18]IF\en\ep[0] ')
  rslt := strReplace(rslt, 'ENDIF\n',     '\eb\ep[18]ENDIF\en\ep[0]\n')
  rslt := strReplace(rslt, 'ENDFOR\n',    '\eb\ep[18]ENDFOR\en\ep[0]\n')
  rslt := strReplace(rslt, 'FOR ',        '\eb\ep[18]FOR\en\ep[0] ')
ENDPROC rslt

PROC stripHighlights(text)
  DEF rslt

  rslt := text
  rslt := strReplace(rslt, '\eb\ep[18]', '')
  rslt := strReplace(rslt, '\en\ep[0]',  '')
ENDPROC rslt
