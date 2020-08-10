/* Copyright INRIA */

#include "../machine.h"

/** only used to force the linker to load all calelm functions **/

Intersci_contents(x) 
     int x;
{
  if ( x== 1) 
    {
      C2F(cchar)();
      C2F(ccharf)();
      C2F(cdouble)();
      C2F(cdoublef)();
      cerro();
      C2F(cint)();
      C2F(cboolf)();
      C2F(cintf)();
      cout();
      C2F(cstringf)();
      C2F(stringc)();
      C2F(int2cint)();
      C2F(dbl2cdbl)();
      C2F(freeptr)();
      FreeSparse();
      NewSparse();
      C2F(csparsef)();
      C2F(erro)();
      C2F(out)();
    }
}
