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
       'DelphE/fileUtils', 'DelphE/stringUtils', 'DelphE/Array', 'DelphE/String',
       'DelphE/mccCodeEditor'

ENUM BTN_OPEN, BTN_NEW, BTN_SAVE, BTN_SPC1, BTN_COMPILE, BTN_BUILD, BTN_RUN
ENUM NEW_CLICK=1, OPEN_CLICK, FILESELECT_CHANGE

OBJECT tMainWindow OF mccWindow
      codeEditor: PTR TO mccCodeEditor,
      toolbar:    PTR TO mccToolbar,
      b1:         PTR TO mccBalance,
      b2:         PTR TO mccBalance,
      spc:        PTR TO mccRectangle,
      con:        PTR TO mccListview,
      treelist:   PTR TO mccListTree,
      fu:         PTR TO fileUtils
      drawer, file
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
                Toolbar_TextButton(0, 'Open',  "o"),
                Toolbar_TextButton(0, 'New',   "n"),
                Toolbar_TextButton(0, 'Save',  "s"),
                Toolbar_Space,
                Toolbar_TextButton(0, 'Compile',"c"),
                Toolbar_TextButton(0, 'Build',  "b"),
                Toolbar_TextButton(0, 'Run',    "r"),
                Toolbar_TextButton(0, 'Debug',  "d"),
                Toolbar_End
              ]),
              -> MUIA_Font, MUIV_Font_Small,
              MUIA_ShortHelp, FALSE,
              MUIA_Draggable, FALSE,
              TAG_END
            ])

  NEW self.b1.create()
  NEW self.b2.create()
  NEW self.spc.create()
  NEW self.con.create(20)
  NEW self.treelist.create(25)

  self.setContent(VGroup,

          Child, HGroup,
            Child, self.toolbar.handle,
            Child, self.spc.handle,
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
  DEF buffer, s:string

  buffer:=self.codeEditor.getText()

  NEW s.create(self.drawer)
  s.concat(self.file)

  self.fu.writeFile(s.value, buffer)

  FreeVec(buffer)
ENDPROC

PROC compileClick() OF tMainWindow
  DEF cmd: string, r, buffer, node: muis_listtree_treenode
  self.log(['Compiling... ', self.file, NIL])

  NEW cmd.create('cd ')
  cmd.concat(self.drawer)
  cmd.concat('\nec ')
  cmd.concat(self.file)
  cmd.concat(' IGNORECACHE QUIET > T:delphe-compiler-out')

  r:=Execute(cmd.value, 0, 0)

  WriteF('Result \d\n', r)
    
  buffer:=self.fu.readFile('T:delphe-compiler-out')
  self.log([buffer, NIL])
ENDPROC

PROC buildClick() OF tMainWindow
  DEF cmd:string, r, buffer
  self.log(['Building... ', self.file, NIL])

  NEW cmd.create('cd ')
  cmd.concat(self.drawer)
  cmd.concat('\nbuild force > T:delphe-compiler-out\n')

  r:=Execute(cmd.value, 0, 0)

  WriteF('Result \d\n', r)
    
  buffer:=self.fu.readFile('T:delphe-compiler-out')
  self.log([buffer, NIL])
ENDPROC

PROC runClick() OF tMainWindow
    self.log(['Need to work out which is main!!!', NIL])
ENDPROC


PROC treeSelectChange() OF tMainWindow
    DEF buf, node: muis_listtree_treenode, s:string

    node:=self.treelist.getEntryActive()

    self.file:=node.tn_Name
    NEW s.create('')
    node:=self.treelist.getParent(node)
    WHILE (node>0)
        s.prepend(node.tn_Name)
        node:=self.treelist.getParent(node)
    ENDWHILE
    self.drawer:=s.value

    NEW s.create(self.drawer)
    s.concat(self.file)

    IF (s.endsWith('/'))
        self.log(['Cannot open a folder'])
    ELSE
       self.log(['Opening [', s.value, ']'])

       self.codeEditor.clearText()

       IF (buf:=self.fu.readFile(s.value))
         self.codeEditor.insertText(buf)
       ENDIF
    ENDIF
ENDPROC

PROC log(list:PTR TO LONG) OF tMainWindow
    DEF s:string, i, msg

    NEW s.create('')

    FOR i:=0 TO ListLen(list)
      s.concat(list[i])
    ENDFOR

    msg:=s.value

    self.con.insertBottom(msg)
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
    DEF s: string, rootnode

    NEW s.create(self.drawer)
    s.concat('/')
    rootnode:=self.treelist.addNode(s.value)

    self.loadDrawerContents(rootnode, self.drawer)
ENDPROC

PROC loadDrawerContents(rootnode, drawer) OF tMainWindow
    DEF names: arr, s: string, d: string, i, node

    names:=self.fu.contents(drawer)

    WriteF('Found \d entries for \s\n', names.length(), drawer)
    FOR i:=0 TO names.length()-1
       s:=names.getItem(i)
       IF (s.endsWith('.e'))
         node:=self.treelist.addNode(s.value, rootnode, 1)
       ELSEIF (s.endsWith('/'))
         node:=self.treelist.addNode(s.value, rootnode, 1)
         NEW d.create(self.drawer)
         d.concat('/')
         d.concat(s.value)
         WriteF('Loading child [\s]\n', d.value)
         self.loadDrawerContents(node,d.value) 
       ENDIF
    ENDFOR
ENDPROC
