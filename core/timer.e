
OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'devices/timer', 'exec/io', 'exec/ports'

ENUM ER_NONE, ER_KICK, ER_NOPORT, ER_NOIOREQ, ER_NODEV

OBJECT timer
ENDOBJECT

PROC getTime() OF timer HANDLE
  DEF timerMP=NIL:PTR TO mp
  DEF timerIO=NIL:PTR TO timerequest
  DEF timerDEV=-1

  DEF result: timeval

  IF KickVersion(37)=FALSE THEN Raise(ER_KICK)

  IF (timerMP := CreateMsgPort())=NIL THEN Raise(ER_NOPORT)
  IF (timerIO := CreateIORequest(timerMP, SIZEOF timerequest))=NIL THEN Raise(ER_NOIOREQ)
  IF (timerDEV:= OpenDevice(TIMERNAME, 0, timerIO, 0)) THEN Raise(ER_NODEV)

  timerIO.io.command := TR_GETSYSTIME

  SendIO(timerIO)

  NEW result
  result.secs := timerIO.time.secs
  result.micro := timerIO.time.micro

EXCEPT DO

  IF timerDEV=0 THEN CloseDevice(timerIO)
  IF timerIO THEN DeleteIORequest(timerIO)
  IF timerMP THEN DeleteMsgPort(timerMP)

  SELECT exception
    CASE ER_KICK;    WriteF('Incorrect Kickstart\n')
    CASE ER_NOPORT;  WriteF('No port\n')
    CASE ER_NOIOREQ; WriteF('No IO request\n')
    CASE ER_NODEV;   WriteF('No device\n')
  ENDSELECT
ENDPROC result

PROC difference(t1: PTR TO timeval, t2: PTR TO timeval) OF timer
  DEF dif: timeval
  
  NEW dif
  
  dif.secs  := t1.secs - t2.secs
  dif.micro := t1.micro - t2.micro
ENDPROC dif
