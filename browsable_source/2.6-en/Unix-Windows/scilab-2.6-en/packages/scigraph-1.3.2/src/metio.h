#ifndef __METANET_METIO 
#define  __METANET_METIO 

#include "machine.h"

#define STRLEN 1000
extern char Description[STRLEN];

extern void AddMessage _PARAMS((char *description));
extern void AddText _PARAMS((char *description));
extern void MetanetAlert _PARAMS((void));
extern int MetanetChoose _PARAMS((char *description, char **strings, char *result));
extern int MetanetDialog _PARAMS((char *valueinit, char *result, char *description));
extern int MetanetDialogs _PARAMS((int n, char **valueinit, char **result, char **description, char *label));
extern int MetanetYesOrNo _PARAMS((void));

#endif /**  __METANET_METIO  **/


