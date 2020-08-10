#include <stdio.h>

#include "graphics.h"
#include "metio.h"

#include "machine.h"
#include "graphics/Graphics.h"

#define PI0 (integer *) 0
#define PD0 (double *) 0

int FontSelect(s)
     int s;
{
  int fontid=2,size=1;
  switch (s) {
  case 8:    size=0;    break;
  case 10:   size=1;    break;
  case 12:   size=2;    break;
  case 14:   size=3;    break;
  case 18:   size=4;    break;
  case 24:   size=5;    break;
  default:   break;
  }
  C2F(dr)("xset","font",&fontid,&size,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  return size;
}



