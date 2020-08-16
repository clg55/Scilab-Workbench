#include "mex.h"
#include <stdio.h>

void mexfunction11(nlhs, plhs, nrhs, prhs)
     int nlhs, nrhs;
     Matrix *plhs[]; Matrix *prhs[];
{   
  if (nrhs != 0) mexErrMsgTxt("Invalid number of inputs!");
  mexEvalString("A11=[1,2,3,4];");
  return ;
}

