/*
** DelphE MCCTextEditor object
*/

OPT    MODULE
OPT    EXPORT
OPT    PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/texteditor_mcc', 'DelphE/mccTextEditor', 'DelphE/array',
       'DelphE/stringUtils', 'DelphE/SyntaxHighlighter'

OBJECT mccCodeEditor OF mccTextEditor
ENDOBJECT

PROC loadFile(filename) OF mccCodeEditor
  DEF buf

  buf := loadAndHighlight(filename)

  self.clearText()
  set(self.editorHandle, MUIA_TextEditor_Contents, buf)

  -> DisposeLink(buf)
ENDPROC

PROC saveFile(filename) OF mccCodeEditor
  DEF buf
  buf := SUPER self.getText()

  stripAndSave(buf, filename)

  -> DisposeLink(buf)
ENDPROC
