/*
** DelphE MCCWindow object
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'amigalib/boopsi', 'utility/tagitem',
       'DelphE/mccBase', 'DelphE/Logger'

OBJECT mccWindow OF mccBase
ENDOBJECT

PROC onOpen() OF mccWindow IS EMPTY
