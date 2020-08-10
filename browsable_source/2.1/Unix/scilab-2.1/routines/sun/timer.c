#include <stdio.h>
#include <time.h>
#include "../machine.h"

#ifndef CLOCKS_PER_SEC
#if defined(sun)
#define CLOCKS_PER_SEC 1000000
#endif
#endif

static clock_t t1;
static int init_clock = 1;

C2F(timer)(etime)
double *etime;
{
  clock_t t2;
  char str[80];
  t2 = clock();
  if (init_clock == 1) {init_clock = 0; t1 = t2;}
  *etime=(double)((double)(t2 - t1)/(double)CLOCKS_PER_SEC);
  t1 = t2;
}
