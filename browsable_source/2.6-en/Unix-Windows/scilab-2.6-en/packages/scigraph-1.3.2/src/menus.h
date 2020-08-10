
#ifndef __METANET_MENUS
#define __METANET_MENUS
#include "machine.h" 

#define BEGIN 1
#define STUDY 2
#define MODIFY 3

extern void DisplayMenu _PARAMS((int win,int i));
extern void ModifyGraph _PARAMS((MetanetGraph *));
extern void ModifyQuit _PARAMS((MetanetGraph *,int force ));
extern void StudyQuit _PARAMS((int win));

#endif 
