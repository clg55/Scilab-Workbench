/* Copyright INRIA */

#ifndef STACK_DEF 
#define STACK_DEF 

#ifdef FORDLL 
#define IMPORT  __declspec (dllimport)
#else 
#define IMPORT 
#endif


/* typedef int integer ; */

#define csiz 63  
#define bsiz 4096  
#define isiz 1024
#define psiz 256  
#define nsiz 6  
#define lsiz 8192 
#define nlgh nsiz*4  
#define vsiz 2 
#define intersiz 60

IMPORT struct {
    double Stk[vsiz];
} C2F(stack);


IMPORT struct {
    int bot, top, idstk[nsiz*isiz], lstk[isiz], leps, 
	    bbot, bot0, infstk[isiz];
} C2F(vstk);


IMPORT struct {
    int ids[nsiz*psiz], pstk[psiz], rstk[psiz], pt, niv, 
	    macr, paus, icall;
} C2F(recu);

IMPORT struct {
    int ddt, err, lct[8], lin[lsiz], lpt[6], hio, rio, wio, rte, wte;
} C2F(iop);

IMPORT struct {
    int err1, err2, errct, toperr, errpt, ieee;
} C2F(errgst); 

IMPORT struct {
    int sym, syn[nsiz], char1, fin, fun, lhs, rhs, ran[2], comp[3];
} C2F(com);


IMPORT struct {
    int lbot, ie, is, ipal, nbarg, ladr[intersiz];
} C2F(adre);


IMPORT struct {
  int nbvars, nbrows[intersiz], nbcols[intersiz], itflag[intersiz],
    ntypes[intersiz], lad[intersiz],ladc[intersiz],lhsvar[intersiz];
} C2F(intersci);

#endif /** STACK_DEF  **/

