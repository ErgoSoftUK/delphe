/*
** Logger module
*/

OPT MODULE
OPT EXPORT

ENUM LEVEL_ERROR,
     LEVEL_WARNING,
     LEVEL_INFO,
     LEVEL_DEBUG,
     LEVEL_TRACE

OBJECT logger
  level
ENDOBJECT

PROC create(level) OF logger
  self.level:=level
ENDPROC

PROC info(data: PTR TO LONG) OF logger
  DEF i
  FOR i:=0 TO ListLen(data)
    WriteF('\s', data[i])
  ENDFOR
  WriteF('\n')
ENDPROC

PROC debug(data: PTR TO LONG) OF logger
  DEF i
  FOR i:=0 TO ListLen(data)
    WriteF('\s', data[i])
  ENDFOR
  WriteF('\n')
ENDPROC
