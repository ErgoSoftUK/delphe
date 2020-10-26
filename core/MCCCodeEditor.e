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
  DEF keywords:arr, s:string, i, match, matchword:string, pos, t, txt: string, result:string, end

  NEW keywords
  NEW s.create('PROC ')
  keywords.add(s)
  NEW s.create('DEF ')
  keywords.add(s)
  NEW s.create('PTR TO ')
  keywords.add(s)
  NEW s.create('OPT ')
  keywords.add(s)
  NEW s.create('ENDPROC\n')
  keywords.add(s)
  NEW s.create('ENDPROC ')
  keywords.add(s)
  NEW s.create('NEW ')
  keywords.add(s)

  NEW result.create('')
  pos:=0
  end:=StrLen(text) + 1

  WriteF('Parsing...')

  REPEAT
    matchword:=NIL
    match:=end
    FOR i:=0 TO keywords.length()-1
      s:=keywords.getItem(i)
      t:=InStr(text, s.value, pos)
      IF ((t > -1) AND (t < match))
        WriteF('Matched [\s] @ \d\n', s.value, t)
        match:=t
        matchword:=s
      ENDIF
    ENDFOR

    IF match < end
      WriteF('Found matching [\s] @ \d\n', matchword.value, match)
      txt:=String(match-pos)
      MidStr(txt, text, pos, match-pos)
      result.concat(txt)
      result.concat('\eb\ep[18]')
      result.concat(matchword.value)
      result.concat('\en\ep[0]')
      pos:=match + StrLen(matchword.value)
      WriteF('Output [\s]\n', result.value)
    ENDIF

  UNTIL (matchword = NIL)

  IF (pos < end)
    txt:=String(end-pos)
    MidStr(txt, text, pos, end-pos)
    result.concat(txt)
  ENDIF

  WriteF('Result [\s]\n', result.value)

  text:=result.value
ENDPROC text
