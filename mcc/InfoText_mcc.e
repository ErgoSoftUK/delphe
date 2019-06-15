OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
**
** $VER: InfoText_mcc.h V15.3
** Copyright © 2018 Richard Collier. All rights reserved.
**
*/

#ifndef BKN_SERIAL
  #define BKN_SERIAL 0xfcf70000
#endif

#define MUIC_InfoText 'InfoText.mcc'
#define InfoTextObject Mui_NewObjectA(MUIC_InfoText,[TAG_IGNORE,0

/*** Methods ***/
#define MUIM_InfoText_TimeOut          (BKN_SERIAL | 0x101 )

/*** Attributes ***/
#define MUIA_InfoText_Contents         (BKN_SERIAL | 0x110 )
#define MUIA_InfoText_ExpirationPeriod (BKN_SERIAL | 0x111 )
#define MUIA_InfoText_FallBackText     (BKN_SERIAL | 0x112 )
