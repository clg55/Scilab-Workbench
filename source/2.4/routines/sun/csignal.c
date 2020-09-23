/* Copyright INRIA */

#include "../machine.h"
#include <signal.h>

extern int   C2F(sigbas)(); /*  _PARAMS((integer *));*/

void controlC_handler (sig)
     int sig;
{
  int j;
  j = SIGINT;
  C2F(sigbas)(&j);
}

int C2F(csignal)()
{
  signal (SIGINT, controlC_handler);
  return(0);
}
