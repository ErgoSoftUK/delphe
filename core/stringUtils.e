/*
** StringUtils
*/

OPT MODULE
OPT EXPORT

OBJECT stringUtils
ENDOBJECT

PROC clone(str) OF stringUtils
  DEF clone, l
  l := StrLen(str)
  clone := String(l)
  StrCopy(clone, str, l)
ENDPROC clone
