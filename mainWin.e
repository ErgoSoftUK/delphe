/*
** Main window
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster','libraries/mui','amigalib/boopsi','utility/tagitem',

       'Asl', 'libraries/Asl', 'dos/dos',

       'mui/infotext_mcc','mui/toolbar_mcc', 'mui/listtree_mcc',

       'DelphE/mccTextEditor', 'DelphE/mccToolbar', 'DelphE/mccListview',
       'DelphE/mccBalance', 'DelphE/mccRectangle', 'DelphE/mccWindow',
       'DelphE/mccApplication', 'DelphE/mccBase', 'DelphE/mccListTree',
       'DelphE/fileUtils', 'DelphE/stringUtils', 'DelphE/Array',
       'DelphE/mccCodeEditor', 'DelphE/mccCycle'

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
      exes:       PTR TO mccCycle,
      fu:         PTR TO fileUtils
      drawer, file
ENDOBJECT

OBJECT nodeData
  isFile,
  isExecutable
ENDOBJECT

PROC create() OF tMainWindow
  NEW self.fu
  NEW self.codeEditor.create()
  self.codeEditor.setFixedFont(MUI_TRUE)


  NEW self.toolbar.create([MUIA_Toolbar_ImageType, MUIV_Toolbar_ImageType_File,
              MUIA_Toolbar_ImageNormal, 'PROGDIR:Images/ButtonBank1.iff',
              MUIA_Toolbar_ImageSelect, 'PROGDIR:Images/ButtonBank1s.bsh',
              MUIA_Toolbar_ImageGhost, 'PROGDIR:Images/ButtonBank1g.bsh',
              MUIA_Toolbar_Description, buildBank([
                Toolbar_HintButton(0, 'Open',  "o"),
                Toolbar_HintButton(0, 'New',   "n"),
                Toolbar_HintButton(0, 'Save',  "s"),
                Toolbar_Space,
                Toolbar_HintButton(0, 'Compile',"c"),
                Toolbar_HintButton(0, 'Build',  "b"),
                Toolbar_HintButton(TDF_GHOSTED, 'Run',    "r"),
                Toolbar_HintButton(TDF_GHOSTED, 'Debug',  "d"),
                Toolbar_End
              ]),
              -> MUIA_Font, MUIV_Font_Small,
              MUIA_ShortHelp, TRUE,
              MUIA_Draggable, FALSE,
              TAG_END
            ])

  NEW self.b1.create()
  NEW self.b2.create()
  NEW self.spc.create()
  NEW self.con.create(20)
  NEW self.treelist.create(25)
->  NEW self.exes.create()

  self.setContent(VGroup,

          Child, HGroup,
            Child, self.toolbar.handle,
            Child, self.spc.handle,
->            Child, self.exes.handle,
          End,

          Child, HGroup,
            Child, self.treelist.handle,
            Child, self.b1.handle,
            Child, self.codeEditor.handle,
          End,
          Child, self.b2.handle,
          Child, self.con.handle,
        End)

  SUPER self.create()

ENDPROC

PROC hookEvents(app: PTR TO mccApplication) OF tMainWindow
  self.hookEvent(app, self.toolbar.onClick(BTN_NEW), `self.newClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_OPEN), `self.openClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_SAVE), `self.saveClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_COMPILE), `self.compileClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_BUILD), `self.buildClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_RUN), `self.runClick())
  self.hookEvent(app, self.toolbar.onClick(BTN_DEBUG), `self.debugClick())
  self.hookEvent(app, self.treelist.onDblClick(), `self.treeSelectChange())

ENDPROC

PROC newClick() OF tMainWindow
  self.log(['New!',NIL])
  self.codeEditor.setWeight(75)
ENDPROC

PROC openClick() OF tMainWindow
    self.openProject()
ENDPROC

PROC saveClick() OF tMainWindow
  DEF buffer, s

  buffer:=self.codeEditor.getText()

  s := strClone(self.drawer)
  s := strConcat(s, self.file)

  self.fu.writeFile(s, buffer)

  FreeVec(buffer)
ENDPROC

PROC compileClick() OF tMainWindow
  DEF cmd, r, buffer, node: muis_listtree_treenode
  self.log(['Compiling... ', self.file, NIL])

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\nec debug ')
  cmd := strConcat(cmd, self.file)
  cmd := strConcat(cmd, ' IGNORECACHE QUIET > T:delphe-compiler-out')

  r:=Execute(cmd, 0, 0)

  WriteF('Result \d\n', r)
    
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

  WriteF('Result \d\n', r)
    
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
DEF cmd, r, buffer, exe

  exe := String(StrLen(self.file))
  StrCopy(exe, self.file, StrLen(self.file)-2)

  cmd := strClone('cd ')
  cmd := strConcat(cmd, self.drawer)
  cmd := strConcat(cmd, '\n')
  cmd := strConcat(cmd, exe)
  cmd := strConcat(cmd, ' > T:delphe-execute-out')
  r:=Execute(cmd, 0, 0)

  WriteF('Result \d\n', r)
    
  buffer:=self.fu.readFile('T:delphe-execute-out')
  self.log([buffer, NIL])
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

  WriteF('Result \d\n', r)
    
  buffer:=self.fu.readFile('T:delphe-execute-out')
  self.log([buffer, NIL])
  self.checkForError(buffer)
ENDPROC

PROC treeSelectChange() OF tMainWindow
    DEF node: muis_listtree_treenode, s, data: nodeData

    node:=self.treelist.getEntryActive()

    self.file:=node.tn_Name
    data:=node.tn_User

    IF data.isFile
      WriteF('File!!')
    ELSE
      WriteF('Folder!!!')
    ENDIF

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
  DEF buf, r

   self.log(['Opening [', filename, ']'])

   self.codeEditor.clearText()

   IF (buf:=self.fu.readFile(filename))
     self.codeEditor.insertText(buf)
     self.codeEditor.gotoLine(0)
     r := InStr(buf, '\nPROC main()')
     self.setRunnable(r > -1)
   ENDIF
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
    self.drawer := self.fu.currentDir()    
    self.loadDrawer()
ENDPROC

PROC openProject() OF tMainWindow
    self.drawer:=self.fu.reqDrawer()
    self.loadDrawer()
ENDPROC

PROC loadDrawer() OF tMainWindow
    DEF s, rootnode

    s := strClone(self.drawer)
    s := strConcat(s, '/')
    rootnode:=self.treelist.addNode(s)

    self.loadDrawerContents(rootnode, self.drawer)
ENDPROC

PROC loadDrawerContents(rootnode, drawer) OF tMainWindow
    DEF names: arr, s, d, i, node, data: nodeData

    names:=self.fu.contents(drawer)

    WriteF('Found \d entries for \s\n', names.length(), drawer)
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
         WriteF('Loading child [\s]\n', d)
         self.loadDrawerContents(node, d) 
       ENDIF
    ENDFOR
ENDPROC
