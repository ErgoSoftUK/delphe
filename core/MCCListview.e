/*
** DelphE MCCListview object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'intuition/classes'

OBJECT mccListview OF mccBase
  PRIVATE lines
ENDOBJECT

PROC create() OF mccListview
  self.lines:=0
  self.handle := ListviewObject,
    MUIA_Listview_Input, MUI_TRUE,
    MUIA_Listview_List , ListObject,
      InputListFrame,
      MUIA_ShortHelp, 'This is a listview',
      MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
      MUIA_List_DestructHook , MUIV_List_DestructHook_String,
    End,
  End
ENDPROC

/** PROPERTIES **/

PROC getEntryActive() OF mccListview
  DEF text

  doMethodA(self.handle, [MUIM_List_GetEntry, MUIV_List_GetEntry_Active, {text}])
ENDPROC text

/** METHODS **/

PROC insertBottom(item) OF mccListview
  doMethodA(self.handle, [MUIM_List_InsertSingle, item, MUIV_List_Insert_Bottom])
  self.lines:=self.lines+1
ENDPROC

PROC scrollBottom() OF mccListview
  doMethodA(self.handle, [MUIM_List_Jump, self.lines])
ENDPROC

/** EVENTS **/

PROC onDblClick() OF mccListview
  -> doMethodA(self.handle, [MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE, app, 2, MUIM_Application_ReturnID, return])
ENDPROC [self, [MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE]]
