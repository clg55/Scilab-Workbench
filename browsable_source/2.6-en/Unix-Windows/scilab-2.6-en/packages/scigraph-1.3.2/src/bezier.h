#ifndef __METANET_BEZI 
#define  __METANET_BEZI 

#include "machine.h"

typedef struct {
     int x0,y0,x1,y1,x2,y2,x3,y3;
} xBezier;

extern void DrawBezier  _PARAMS((xBezier *bpoints));


#endif /**  __METANET_BEZI  **/

