/*
** DelphE MCCTextEditor object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/texteditor_mcc', 'DelphE/mccTextEditor', 'DelphE/array',
       'DelphE/string'

OBJECT mccCodeEditor OF mccTextEditor
ENDOBJECT

PROC setContents(value) OF mccCodeEditor
  set(self.editorHandle, MUIA_TextEditor_Contents, self.parse(value))
ENDPROC

PROC insertText(text, position=MUIV_TextEditor_InsertText_Top) OF mccCodeEditor
  doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, self.parse(text), position])
ENDPROC

PROC parse(text) OF mccCodeEditor
  DEF keywords:arr, s:string, i, match, matchword:string, pos, t, result:string, end

  NEW keywords
  NEW s.create('\nPROC ')
  keywords.add(s)
  NEW s.create(' OF ')
  keywords.add(s)

  NEW result.create('')
  pos:=0
  end:=StrLen(text) + 1

  matchword:=NIL
  
  WriteF('Parsing...')

  WHILE (matchword = NIL)
    matchword:=NIL
    match:=end
    FOR i:=0 TO keywords.length()-1
      s:=keywords[i]
      t:=InStr(text, s.value, pos)
      IF (t > -1 AND t < match) 
        match:=t
        matchword:=s
      ENDIF
    ENDFOR

    IF match < end
      WriteF('Found matching [\s] @ \d\n', matchword.value, match)
      t:=String(match-pos)
      MidStr(t, text, pos, match-pos)
      result.concat(t)
      result.concat('\eb\ep[18]')
      result.concat(matchword.value)
      result.concat('\en\ep[0]')
      pos:=match + StrLen(matchword.value)
      WriteF('Output [\s]\n', result.value)
    ENDIF

  ENDWHILE
  
  IF (pos < end)
    t:=String(end-pos)
    MidStr(t, text, pos, end-pos)
    result.concat(t)
  ENDIF

  -> text:=result.value

/*
    DEF i, s, res:string, buf, t, l, x, keyword:arr, ki, kv:string

    NEW keyword
    NEW kv.create('\nPROC ')
    keyword.add(kv)
    NEW kv.create(' OF ')
    keyword.add(kv)


    buf:=StrLen(text)
    NEW res.create('')

    FOR ki:=0 TO keyword.length()-1
        kv:=keyword.getItem(ki)
        WriteF('Parsing [\s]\n', kv.value)

        i:=InStr(text, kv.value)
        WHILE i > -1
          l:=i-s

          x:=StrLen(res)
          IF buf<(x+8+l)
            buf:=buf+256
            t:=String(buf)
            t:=StrCopy(t, res, ALL)
            res:=t
          ENDIF

          t:=String(l)
          MidStr(t,text,s,i)
          res.concat(t)
          res.concat('\n\eb\ep[18]')
          res.concat(kv.value)
          res.concat('\en\ep[0]')
          s:=i+StrLen(kv.value)
          i:=InStr(text, kv.value,s)
        ENDWHILE

    ENDFOR

    l:=StrLen(text)-s
    IF l > 0
      t:=String(l)
      RightStr(t, text, l)
      res.concat(t)
    ENDIF
*/
ENDPROC text

