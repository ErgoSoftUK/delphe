/*
** DelphE MMCBase object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'amigalib/boopsi', 'libraries/mui',
       'mui/toolbar_mcc', 'mui/texteditor_mcc'

OBJECT mccEvent
  handler : PTR TO mccBase
  source  : PTR TO mccBase
  callback: PTR TO LONG
ENDOBJECT

OBJECT mccBase
  handle
ENDOBJECT

/** PROPERTIES **/

PROC setWeight(value) OF mccBase IS set(self.handle, MUIA_Weight, value)
PROC setFont(value) OF mccBase IS set(self.handle, MUIA_Font, value)
PROC setDraggable(value) OF mccBase IS set(self.handle, MUIA_Draggable, value)

/** EVENTS */

PROC hookEvent(app: PTR TO mccBase, data, callback) OF mccBase
  DEF p, evt: PTR TO mccEvent, source, params

  source:=ListItem(data, 0)
  params:=ListItem(data, 1)

  NEW evt
  evt.handler  := self
  evt.source   := source
  evt.callback := callback


  p:=List(ListLen(params)+4)
  p:=ListCopy(p, params, ALL)
  p:=ListAdd(p, [app.handle, 2, MUIM_Application_ReturnID, evt])

  doMethodA(evt.source.handle, p)
ENDPROC

PROC handleEvent(event: PTR TO mccEvent) OF mccBase
  IF (event.handler = self)
    Eval(event.callback)
  ENDIF
ENDPROC
