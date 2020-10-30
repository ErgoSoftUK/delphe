/*
** DelphE MCCTextEditor object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/texteditor_mcc', 'DelphE/mccTextEditor', 'DelphE/array',
       'DelphE/stringUtils'

OBJECT mccCodeEditor OF mccTextEditor
ENDOBJECT

PROC setContents(value) OF mccCodeEditor
  -> set(self.editorHandle, MUIA_TextEditor_Contents, self.parse(value))
  set(self.editorHandle, MUIA_TextEditor_Contents, value)
ENDPROC

PROC insertText(text, position=MUIV_TextEditor_InsertText_Top) OF mccCodeEditor
  -> doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, self.parse(text), position])
  doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, text, position])
ENDPROC

PROC parse(text) OF mccCodeEditor
  DEF keywords:arr, s, i, match, matchword, pos, t, txt, result, end

  NEW keywords
  keywords.add('PROC ')
  keywords.add('DEF ')
  keywords.add('PTR TO ')
  keywords.add('OPT ')
  keywords.add('ENDPROC\n')
  keywords.add('ENDPROC ')
  keywords.add('NEW ')

  result := String(0)
  pos:=0
  end:=StrLen(text) + 1

  WriteF('Parsing...')

  REPEAT
    matchword:=NIL
    match:=end
    FOR i:=0 TO keywords.length()-1
      s:=keywords.getItem(i)
      t:=InStr(text, s, pos)
      IF ((t > -1) AND (t < match))
        WriteF('Matched [\s] @ \d\n', s, t)
        match:=t
        matchword:=s
      ENDIF
    ENDFOR

    IF match < end
      WriteF('Found matching [\s] @ \d\n', matchword, match)
      txt:=String(match-pos)
      MidStr(txt, text, pos, match-pos)
      result := strConcat(result, txt)
      result := strConcat(result, '\eb\ep[18]')
      result := strConcat(result, matchword)
      result := strConcat(result, '\en\ep[0]')
      pos:=match + StrLen(matchword)
      WriteF('Output [\s]\n', result)
    ENDIF

  UNTIL (matchword = NIL)

  IF (pos < end)
    txt:=String(end-pos)
    MidStr(txt, text, pos, end-pos)
    result := strConcat(result, txt)
  ENDIF

  WriteF('Result [\s]\n', result)

  text:=result
ENDPROC text
