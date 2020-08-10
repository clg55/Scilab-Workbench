/* Copyright INRIA */

#include "C-LAB_Interf.h"
#include "TK_uicontrol.h"
#include "TK_ScilabCallback.h"
#include "tksci.h"


void LAB_get()


{


  Matrix *MHandle;
  int Handle;

  Matrix *Mfield;
  char *field;

  Matrix *Mvalue;
  char *value;

 
  
  MHandle = (Matrix *)Interf.Param[0];
  if (!MatrixIsReal(MHandle) )
    {
      InterfError("Handle must be an integer");
      return;
    }
  Handle = (int)MatrixGetScalar(MHandle);

  Mfield  = (Matrix *)Interf.Param[1];
  if (!MatrixIsString(Mfield) )
    {
      InterfError("Field parameter must be a string");
      return;
    }

  
  
  if (TK_UiGet(Handle, Mfield, &Mvalue)==-1)
    {
      InterfError("get()");
      return;
    }
  else {    ReturnParam(Mvalue); }
}
