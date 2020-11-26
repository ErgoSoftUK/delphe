/*
** Main window
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','libraries/mui','amigalib/boopsi','utility/tagitem',

       'Asl', 'libraries/Asl', 'dos/dos', 'tools/file',

       'mui/infotext_mcc','mui/toolbar_mcc', 'mui/listtree_mcc',

       'DelphE/mccTextEditor', 'DelphE/mccToolbar', 'DelphE/mccListview',
       'DelphE/mccBalance', 'DelphE/mccRectangle', 'DelphE/mccWindow',
       'DelphE/mccApplication', 'DelphE/mccBase', 'DelphE/mccListTree',
       'DelphE/fileUtils', 'DelphE/stringUtils', 'DelphE/Array',
       'DelphE/mccCodeEditor', 'DelphE/Logger'

ENUM BTN_OPEN, BTN_NEW, BTN_SAVE, BTN_SPC1, BTN_COMPILE, BTN_BUILD, BTN_RUN, BTN_DEBUG
ENUM NEW_CLICK=1, OPEN_CLICK, FILESELECT_CHANGE

OBJECT tMainWindow OF mccWindow
      codeEditor: PTR TO mccCodeEditor,
      toolbar:    PTR TO mccToolbar,
      b1:         PTR TO mccBalance,
      b2:         PTR TO mccBalance,
      spc:        PTR TO mccRectangle,
      con:        PTR TO mccTextEditor,
      treelist:   PTR TO mccListTree,
      fu:         PTR TO fileUtils
      drawer, file
ENDOBJECT

DEF mainWin : PTR TO tMainWindow

OBJECT nodeData
  isFile,
  isExecutable
ENDOBJECT

PROC newClick() OF tMainWindow
  self.log(['New!',NIL])
  self.codeEditor.setWeight(75)
ENDPROC

PROC openClick() OF tMainWindow
    self.openProject()
ENDPROC

PROC saveClick() OF tMainWindow
  DEF f, d, filename, new
  new := FALSE
  IF self.file = NIL
    d,f := self.fu.reqFile()
    self.drawer := d
    self.file := f
    new := TRUE
  ENDIF

  IF self.file <> NIL
    filename := strClone(self.drawer)
    filename := strConcat(filename, self.file)
    self.log(['Saving ', filename, NIL])
    self.codeEditor.saveFile(filename)

    IF new
      self.loadDrawer()
    ENDIF
  ENDIF
ENDPROC

PROC compileClick() OF tMainWindow
  DEF cmd, r, buffer, node: muis_listtree_treenode

  self.log(['Saving... ', self.file, NIL])
  self.saveClick()
  self.log(['Compiling... ', self.file, NIL])

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\nec debug ')
  cmd := strConcat(cmd, self.file)
  cmd := strConcat(cmd, ' IGNORECACHE QUIET > T:delphe-compiler-out')

  r:=Execute(cmd, 0, 0)

  buffer:=self.fu.readFile('T:delphe-compiler-out')
  self.log([buffer, NIL])
  self.checkForError(buffer)
ENDPROC

PROC buildClick() OF tMainWindow
  DEF cmd, r, buffer
  self.log(['Building... ', self.file, NIL])

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\nbuild force > T:delphe-compiler-out\n')

  r:=Execute(cmd, 0, 0)

  buffer:=self.fu.readFile('T:delphe-compiler-out')
  self.log([buffer, NIL])
  self.checkForError(buffer)
ENDPROC

PROC checkForError(buffer) OF tMainWindow
  DEF r, l, s

  IF InStr(buffer, 'ERROR:') > -1
    self.log(['Compilation Error!', NIL])
    r := InStr(buffer, 'LINE') + 5
    l := InStr(buffer, ':', r) - r
    s := String(l)
    MidStr(s, buffer, r, l)
    self.log(['At line [', s, ']', NIL])
    r,l := Val(s)
    self.codeEditor.gotoLine(r-1) 
  ENDIF
ENDPROC

PROC runClick() OF tMainWindow
DEF cmd, r, buffer, exe, l, lines: PTR TO LONG, c, i

  exe := String(StrLen(self.file))
  StrCopy(exe, self.file, StrLen(self.file)-2)

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\n')
  cmd := strConcat(cmd, exe)
  cmd := strConcat(cmd, ' > T:delphe-execute-out')
  r:=Execute(cmd, 0, 0)

  buffer, l:=readfile('T:delphe-execute-out')

  -> Log lines individually, just in case!
  c:=countstrings(buffer, l)
  lines:=stringsinfile(buffer, l, c)

  FOR i:=0 TO c-1
    self.log([lines[i], NIL])
  ENDFOR

  self.checkForError(buffer)
ENDPROC

PROC debugClick() OF tMainWindow
DEF cmd, r, buffer, exe

  exe := String(StrLen(self.file))
  StrCopy(exe, self.file, StrLen(self.file)-2)

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\nedbg ')
  cmd := strConcat(cmd, exe)
  cmd := strConcat(cmd, ' > T:delphe-execute-out')
  r:=Execute(cmd, 0, 0)

  buffer:=self.fu.readFile('T:delphe-execute-out')
  self.log([buffer, NIL])
  self.checkForError(buffer)
ENDPROC

PROC treeSelectChange() OF tMainWindow
    DEF node: muis_listtree_treenode, s, data: nodeData

    node:=self.treelist.getEntryActive()

    self.file:=node.tn_Name
    data:=node.tn_User

    s := strClone('')
    node:=self.treelist.getParent(node)
    WHILE (node>0)
        s := strPrepend(s, node.tn_Name)
        node:=self.treelist.getParent(node)
    ENDWHILE
    self.drawer:=s

    s := strClone(self.drawer)
    s := strConcat(s, self.file)

    IF (strEndsWith(s, '/'))
        self.log(['Cannot open a folder'])
    ELSE
        self.loadFile(s)
    ENDIF
ENDPROC

PROC loadFile(filename) OF tMainWindow
  self.codeEditor.loadFile(filename)
ENDPROC

PROC setRunnable(runnable) OF tMainWindow
  self.toolbar.enabled(BTN_RUN, runnable)
  self.toolbar.enabled(BTN_DEBUG, runnable)
ENDPROC

PROC log(list:PTR TO LONG) OF tMainWindow
    DEF s, i

    s := strClone('')

    FOR i:=0 TO ListLen(list)
      s := strConcat(s, list[i])
    ENDFOR

    s := strConcat(s, '\n')

    self.con.appendText(s)
    self.con.scrollBottom()
ENDPROC

PROC onOpen() OF tMainWindow
  DEBUG('Get current DIR\n')
    self.drawer := self.fu.currentDir()    
  DEBUG('load drawer contents\n')
    self.loadDrawer()
ENDPROC

PROC openProject() OF tMainWindow
  DEF drawer
  drawer := self.fu.reqDrawer()
  IF drawer <> NIL
    self.drawer:=drawer
    self.loadDrawer()
  ENDIF
ENDPROC

PROC loadDrawer() OF tMainWindow
    DEF s, rootnode

    DEBUG('Clearing tree list\n')
    self.treelist.clear()

    DEBUG('Building path\n')
    s := strClone(self.drawer)
    s := strConcat(s, '/')

    DEBUG('Adding root node\n')
    rootnode:=self.treelist.addNode(s)

    DEBUG('Loading contents\n')
    self.loadDrawerContents(rootnode, self.drawer)
ENDPROC

PROC loadDrawerContents(rootnode, drawer) OF tMainWindow
    DEF names: arr, s, d, i, node, data: nodeData

    names:=self.fu.contents(drawer)
    names.sortStr()

    FOR i:=0 TO names.length()-1
       s:=names.getItem(i)
       IF (strEndsWith(s, '.e'))
         NEW data
         data.isFile := TRUE
         node:=self.treelist.addNode(s, rootnode, data)
       ELSEIF (strEndsWith(s, '/'))
         NEW data
         data.isFile := FALSE
         node:=self.treelist.addNode(s, rootnode, data)
         
         d := strClone(self.drawer)
         d := strConcat(d, '/')
         d := strConcat(d, s)
         self.loadDrawerContents(node, d) 
       ENDIF
    ENDFOR
ENDPROC
