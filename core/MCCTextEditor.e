/*
** DelphE MCCTextEditor object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/texteditor_mcc'

OBJECT mccTextEditor OF mccBase
    editorHandle
    sliderHandle
ENDOBJECT

PROC create(weight=100) OF mccTextEditor

  self.sliderHandle :=
    ScrollbarObject,
      MUIA_Group_Horiz, FALSE,
    End

  self.editorHandle :=
    TextEditorObject,
      MUIA_TextEditor_ExportHook, MUIV_TextEditor_ExportHook_Plain,
      MUIA_TextEditor_Slider, self.sliderHandle,
   End

  self.handle := HGroup,
     MUIA_Group_Spacing, 0,
     Child, self.editorHandle,
     Child, self.sliderHandle,
     MUIA_Weight, weight,
  End

ENDPROC

/** PROPERTIES **/

PROC setContents(value) OF mccTextEditor
  set(self.editorHandle, MUIA_TextEditor_Contents, value)
ENDPROC

PROC setFixedFont(value) OF mccTextEditor
  set(self.editorHandle, MUIA_TextEditor_FixedFont, MUI_TRUE)
ENDPROC

PROC getHasChanged() OF mccTextEditor
  DEF changed
  get(self.editorHandle, MUIA_TextEditor_HasChanged, {changed})
ENDPROC changed

PROC clearChanges() OF mccTextEditor
  set(self.editorHandle, MUIA_TextEditor_HasChanged, FALSE)
ENDPROC

/** METHODS **/

PROC clearText() OF mccTextEditor
  doMethodA(self.editorHandle, [MUIM_TextEditor_ClearText])
  self.clearChanges()
ENDPROC

PROC insertText(text, position=MUIV_TextEditor_InsertText_Top) OF mccTextEditor
  doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, text, position])
ENDPROC

PROC appendText(text) OF mccTextEditor
  doMethodA(self.editorHandle, [MUIM_TextEditor_InsertText, text, MUIV_TextEditor_InsertText_Bottom])
ENDPROC

PROC getText() OF mccTextEditor
  DEF buffer
  set(self.editorHandle, MUIA_TextEditor_ExportHook, MUIV_TextEditor_ExportHook_Plain)
  buffer:=doMethodA(self.editorHandle, [MUIM_TextEditor_ExportText])
ENDPROC buffer

PROC scrollBottom() OF mccTextEditor
ENDPROC

PROC gotoLine(line) OF mccTextEditor
  set(self.editorHandle, MUIA_TextEditor_CursorY, line)
ENDPROC
