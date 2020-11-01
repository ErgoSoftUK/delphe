/*
** DelphE MCCTextEditor object
*/

OPT    MODULE
OPT    EXPORT
OPT    PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/texteditor_mcc', 'DelphE/mccTextEditor', 'DelphE/array',
       'DelphE/stringUtils'

OBJECT mccCodeEditor OF mccTextEditor
ENDOBJECT

PROC setContents(value) OF mccCodeEditor
  set(self.editorHandle, MUIA_TextEditor_Contents, self.parse(value))
  -> set(self.editorHandle, MUIA_TextEditor_Contents, value)
ENDPROC

PROC insertText(text, position=MUIV_TextEditor_InsertText_Top) OF mccCodeEditor
  doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, self.parse(text), position])
  -> doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, text, position])
ENDPROC

PROC parse(text) OF mccCodeEditor
  DEF rslt

  rslt := text
  rslt := strReplace(rslt, 'DEF ',        '\eb\ep[18]DEF\en\ep[0] ')
  rslt := strReplace(rslt, 'PTR TO ',     '\eb\ep[18]PTR TO\en\ep[0] ')
  rslt := strReplace(rslt, 'OPT ',        '\eb\ep[18]OPT\en\ep[0] ')
  rslt := strReplace(rslt, 'ENDPROC\n',   '\eb\ep[18]ENDPROC\en\ep[0]\n')
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

PROC getText() OF mccCodeEditor
  DEF text, rslt
  text := SUPER self.getText()

  rslt := text
  rslt := strReplace(rslt, '\eb\ep[18]', '')
  rslt := strReplace(rslt, '\en\ep[0]',  '')

  FreeVec(text)
ENDPROC rslt
