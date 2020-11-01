/*
** File utilities
*/

OPT MODULE
OPT EXPORT

MODULE 'Asl', 'libraries/Asl', 'dos/dos',
       'DelphE/Array', 'DelphE/stringUtils'


OBJECT fileUtils
ENDOBJECT

PROC readFile(filename) OF fileUtils
 DEF fh, buffer, len

 IF (len:=FileLength(filename))
   buffer:=New(len+1)
   IF (fh:=Open(filename, OLDFILE))
     Read(fh, buffer, len)
     Close(fh)
   ENDIF
 ENDIF
ENDPROC buffer

PROC writeFile(filename, buffer) OF fileUtils
  DEF fh
  IF (fh:=Open(filename, NEWFILE))
    Write(fh, buffer, StrLen(buffer))
    Close(fh)
  ENDIF
ENDPROC

PROC contents(drawer) OF fileUtils
  DEF names, files, lock, fib: PTR TO fileinfoblock, name, ext, i, l, cnt, tmp,
      al: arr, s

    NEW al

    IF (drawer)
        lock := Lock(drawer, ACCESS_READ)
        IF lock
            fib:=AllocDosObject(DOS_FIB, NIL)
            Examine(lock, fib)
            cnt:=0;
            WHILE ExNext(lock, fib)
                s := strClone(fib.filename)
                IF (fib.direntrytype > 0)
                  s := strConcat(s, '/')
                ENDIF
                al.add(s)
            ENDWHILE
            FreeDosObject(DOS_FIB, fib)
            UnLock(lock)
        ENDIF
    ENDIF

ENDPROC al

PROC currentDir() OF fileUtils
  DEF dir[200]    : ARRAY OF CHAR
  
  IF GetCurrentDirName(dir, 200)
    dir := strClone(dir)
  ELSE
    dir := NIL
  ENDIF
ENDPROC dir

PROC reqDrawer() OF fileUtils
  DEF req:PTR TO filerequester, d, options

  d:=NIL
  options:= [
    ASL_HAIL,       'Select project drawer',
    ASL_HEIGHT,     400,
    ASL_WIDTH,      320,
    ASL_LEFTEDGE,   0,
    ASL_TOPEDGE,    0,
    ASL_OKTEXT,     'Open',
    ASL_CANCELTEXT, 'Cancel',
    ASL_FILE,       'asl.library',
    ASL_DIR,        'files:e',
    ASL_EXTFLAGS1,  FIL1F_NOFILES,
    NIL
  ]

  IF (aslbase:=OpenLibrary('asl.library',37))
    IF (req:=AllocAslRequest(ASL_FILEREQUEST, NIL))
      IF (AslRequest(req, options))
        d:=strClone(req.drawer)
      ENDIF
      FreeAslRequest(req)
    ENDIF
    CloseLibrary(aslbase)
  ENDIF
ENDPROC d
