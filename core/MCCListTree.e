/*
** DelphE MCCListTree object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','amigalib/boopsi', 'libraries/mui', 'utility/tagitem',
       'DelphE/mccBase', 'mui/listtree_mcc', 'utility/hooks', 'tools/installhook'

OBJECT mccListTree OF mccBase
  nodes
ENDOBJECT

PROC create() OF mccListTree
  self.nodes := ListtreeObject,
                    InputListFrame,
                    MUIA_Listtree_SortHook, MUIV_Listtree_SortHook_LeavesBottom,
                    MUIA_Listtree_DragDropSort, TRUE,
                    MUIA_Listtree_EmptyNodes, TRUE,
                    MUIA_Listtree_DoubleClick, MUIV_Listtree_DoubleClick_All,
                    MUIA_Listtree_DragDropSort, FALSE,
                    MUIA_Listtree_ConstructHook, MUIV_Listtree_ConstructHook_String,
                    MUIA_Listtree_DestructHook, MUIV_Listtree_DestructHook_String,
                End
  self.handle := ListviewObject,
                MUIA_CycleChain, 1,
                MUIA_Listview_Input, TRUE,
                MUIA_Listview_DragType, 1,
                MUIA_Listview_List, self.nodes,
            End
ENDPROC

/** PROPERTIES **/

PROC getEntryActive() OF mccListTree
  DEF node: muis_listtree_treenode

  node:=doMethodA(self.nodes, [MUIM_Listtree_GetEntry, NIL, MUIV_Listtree_GetEntry_Position_Active, 0])
ENDPROC node

PROC getParent(node=NIL) OF mccListTree
  DEF parent: muis_listtree_treenode
  IF (node=NIL)
    node:=self.getEntryActive()
  ENDIF

  parent:=doMethodA(self.nodes, [MUIM_Listtree_GetEntry, node, MUIV_Listtree_GetEntry_Position_Parent, 0])
ENDPROC parent

/** Methods **/

PROC clear() OF mccListTree
  doMethodA(self.nodes, [MUIM_Listtree_Remove, MUIV_Listtree_Remove_ListNode_Root, MUIV_Listtree_Remove_TreeNode_All, 0])
ENDPROC

PROC addNode(value, parent=NIL, data=NIL) OF mccListTree
  DEF node

  IF (parent=NIL)
    node:=doMethodA(self.nodes, [MUIM_Listtree_Insert, value, data, MUIV_Listtree_Insert_ListNode_Root, MUIV_Listtree_Insert_PrevNode_Tail, TNF_LIST])
  ELSE
    node:=doMethodA(self.nodes, [MUIM_Listtree_Insert, value, data, parent, MUIV_Listtree_Insert_PrevNode_Tail, TNF_LIST])
  ENDIF
ENDPROC node

/** EVENTS **/

PROC onDblClick() OF mccListTree
ENDPROC [self, [MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE]]
