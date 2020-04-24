/*------------------------------------------------------------------------
 *    mexlib  library
 *    Copyright (C)  Enpc/Inria 
 *    Authors FD-JPC  (mail scilab@inria.fr)
 *
 *    This library emulates Matlab' API functions. It is not fully tested...
 *    -Assumes that Scilab string matrices have one column, e.g. 
 *    Str=["qwerty";"123456"]; here this is a 2 x 6 matrix but Scilab
 *    considers Str as a 2 x 1 matrix. ["123";"1234"] is a valid string
 *    matrix which cannot be used here.
 *    -Assumes that sparse matrices have been converted into the Matlab
 *    format. Scilab sparse matrices are stored in the transposed Matlab
 *    format. If A is a sparse Scilab matrix, it should be converted 
 *    by the command A=mtlb_sparse(A) in the calling sequence of the
 *    mex function.
 *    -Structs and Cells are Scilab mlists:
 *    Struct=mlist(["st","dims","field1",...,"fieldk"],
 *                 int32([d1,d2,...,dn]),
 *                 list(obj1,      objN),
 *                 .....
 *                 list(obj1,      objN))     k such lists
 *           N = d1 x d2    x dn
 *           obj = Scilab variable or pointer to Scilab variable.
 *     Cell = Struct with one field called "entries" and "st" <- "ce"
 *    One dimensional structs or cells are as follows:
 *    Struct=mlist(["st","dims","field1",...,"fieldk"],
 *                 int32([1,1]),
 *                 obj1,...,objk)
 *
 *    -Nd dimensional arrays are Scilab mlists (for Nd > 2):
 *     X = mlist(["hm","dims","entries"],
 *                 int32([d1,d2,...,dn]),
 *                 values)
 *     values = vector of doubles or int8-16-32 or char
 --------------------------------------------------------------------------*/
#include "../mex.h"
#include <string.h>
#include <stdio.h>
#if defined  sgi && ! defined  __STDC__
#define __STDC__
#endif
 
#ifdef __STDC__
#include <stdarg.h>
#else
#include <varargs.h>
#endif 

#include "../calelm/calelm.h"
static char *the_current_mex_name;

extern void cerro __PARAMS((char *str));
extern int C2F(dcopy) __PARAMS((int*, double *, int *, double *, int *));
extern int C2F(xscion)  __PARAMS((int *i));
extern void C2F (xscisncr) __PARAMS((char *str, integer *n, integer dummy)); 
extern int  C2F(mxgetm) __PARAMS((    mxArray *ptr));
extern int  C2F(mxgetn) __PARAMS((    mxArray *ptr));
extern void C2F(xscisrn) __PARAMS((char *str,int *n,int  dummy));
extern int  C2F(erro)  __PARAMS((char *str,int dummy));
extern int  C2F(hmcreate)  __PARAMS((int *lw,int *nz,int *sz,int *typv,int *iflag,int *retval));
extern int  C2F(stcreate)  __PARAMS((int *lw1,int *ndim,int *dims, int *nfields, char **field_names, int *retval));
extern double C2F(dlamch)  __PARAMS((char *CMACH, unsigned long int));
extern int arr2num __PARAMS(( mxArray  *ptr ));

extern int C2F(changetoref) __PARAMS((int number, int pointed));

extern int IsReference  __PARAMS((mxArray *array_ptr));

#define DOUBLEMATRIX 1
#define INTMATRIX 8
#define STRINGMATRIX  10
#define SPARSEMATRIX  7
#define LOGICAL 4
#define MLIST 17
#define AsIs  '$'
#define NDARRAY 1
#define CELL 2
#define STRUCT 3

/* s2iadr: value adress to header adress */
#define s2iadr(l) ((l)+(l)-1)
/* i2sadr: header adress to value adress */
#define i2sadr(l) ( ( (l)/2 ) +1 )

vraiptrst  stkptr(long int ptr_lstk)
{
  vraiptrst ptr =  C2F(locptr)(stk((long int)(ptr_lstk))); 
  return ptr;
}

int *Header(const mxArray *ptr)
{
  /* Retuns an integer pointer to the header of a mxArray */
  int *header = (int *) stkptr((long int)ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  return header;
}


mxArray *header2ptr(int *header)
{
  mxArray ptr;
  ptr=(mxArray) ((double *)header-(double *)stkptr(C2F(vstk).Lstk[0])+C2F(vstk).Lstk[0]) ;
  return (mxArray *) ptr;
}

int *listentry(int *header, int i)
{
  /*Usage int *header = header(array_ptr)   
   *      int *headersub = listentry(header, k)
   *   then headersub[0] ... is the header of the kth object in the
   *   list array_ptr  */
  int n, *ptr; 
  n = header[1]; 
  if (i <= n) {
    if ( n%2 == 0 ) n++;
    /* n = n if n odd, n=n+1 if n even (=> n is odd and ptr even !) */
    ptr = (int *) header + 3 + n + 2*( header[2 + (i - 1) ] -1);
  return ptr;
  } else {
    return NULL;
  }
}

int theMLIST(int *header)
{
  /* Returns the type of the mlist  (CELL, STRUCT or HYPERMATRIX)  */
  int *header1; int nfplus2, l;
  if (header[0]==MLIST && header[1]==3 && header[6]==STRINGMATRIX) {
    if (header[14]==12 && header[15]==14) return 2;  /* CELL "c"=12 "e"=14  */
    if (header[14]==17 && header[15]==22) return 1;  /* NDARRAY "h"=17 "m"=22   */
  }
  if (header[0]==MLIST) {
    header1 = (int *) listentry(header,1);
    nfplus2 = header1[1]*header1[2];
    l = 5 + nfplus2;
  /*  "s"=28,  "t"=29   */
    if (header1[0]==STRINGMATRIX && header1[l]==28 && header1[l+1]==29) return 3;  /* STRUCT */
  }
  return 0;
}

/*----------------------------------------------------------------
 *                       DOUBLEMATRIX                            
 *   header[0]= DOUBLEMATRIX  =1                                   
 *   header[1]= M (number of rows)                                 
 *   header[2]= N (number of cols)                                 
 *   header[3]= mxComplexity  (0 real, 1 complex)                  
 *   value[2] = real part                                          
 *   value[2+M*N] = imaginary part  (if mxComplexity =1)           
 *    
 *-----------------------------------------------------------------
 *                       INTMATRIX                               
 *   header[0]= INTMATRIX =8                                       
 *   header[1]= M (number of rows)                                 
 *   header[2]= N (number of cols)                                 
 *   header[3]= TYPE                                               
 *      TYPE=   01    02   04    11     12    14                      
 *             int8 int16 int32 uint8 uint16 uint32                   
 *   value[2] = real part                                               
 *
 *------------------------------------------------------------------
 *                    SPARSEMATRIX                                    
 *   header[0]= SPARSEMATRIX  =7 (converted from 8)                     
 *   header[1]= M (number of rows)                                      
 *   header[2]= N (number of cols)                                      
 *   header[3]= mxComplexity  (0 real, 1 complex)                       
 *   header[4]=nzmax                                                    
 *   header[5]=Jc[0]                                                    
 *   header[5+header[2]+1]=Ir[0]                                         
 *   value[(5+header[2]+header[4])/2 + 1] = real part                       
 *   value[(5+header[2]+header[4])/2 + 1 + M*N] = imag part                 
 *
 *-------------------------------------------------------------------
 *                    STRINGMATRIX                                        
 *    header[0]= STRINGMATRIX   = 10                                        
 *    header[1]=  nrows                                                     
 *    header[2]=  ncols  (MUST be 1 since Matlab string matrices are seen   
 *                           as Scilab  column matrices, all columns      
 *                           having  the same length                      
 *    header[3]=  0                                                         
 *    header[4:...]= 1, ptr1, ..., ptrnrows,                                
 *    header[5]=header[4] + length of string in row 1                         
 *    header[6]=header[5] + length of string in row 2                         
 *    header[5+header[1]:...] = code of strings  (int)                        
 *
 *--------------------------------------------------------------------
 *
 *                   MLIST                                      
 *           <=>  ndim matlab numeric or char array    
 *           <=>  mlist(["hm","dims","entries"],[dim1,...,dimk], vector)  
 *
 *            or
 *           <=>  matlab cell array
 *           <=> mlist(["ce","dims","entries"],[dim1,...,dimk], list())
 *
 *   header[0]=   MLIST  =  17                                      
 *   header[1]= 3   (3 elements in the mlist)                           
 *   header[2,3,4,5]= 1,12,*,*  <-> 4 pointers                          
 * 
 * ->header[6:27]  <-> ["hm","dims","entries"] = ...
 *                     HYPERMATRIX
 *             10,1,3,0,1,3,7,14,17,22,13,18,22,28,14,23,29,27,18,14,28,* 
 *                                h  m  d  i  m  s  e  n  t  r  i  e  s   
 *               <-> ["ce","dims","entries"] = ...
 *                     CELL
 *             10,1,3,0,1,3,7,14,12,14,13,18,22,28,14,23,29,27,18,14,28,* 
 *                                c  e  d  i  m  s  e  n  t  r  i  e  s   
 *
 * ->header[28:...] <-> [dim1, ..., dimk] = ...
 *                1,ndims,1,0,****** (dimensions)  28=6+2*(header[3]-1)
 *                            ^                                           
 *                            |                                           
 *                         header[32]                                       
 *
 * ->header[6+2*(header[4]-1):...] <-> vector
 *                            = 1,m,n,it,*  for double  array               
 *                            = 8,m,n,it,* for int array   with n=1 
 *                            = 10,m,n,0,1,len+1 for char array with m=1, n=1 
 *                            = 15,n,...         for cell array
 *                              ^                                         
 *                              |                                         
 *                     header[6+2*(header[4]-1)]   ( = 1, 8, 10)
 *   header[6+2*(header[4]-1)+4:...] = ***** (entries) for double or int array
 *   
 *   header[6+2*(header[4]-1)+4:6+2*(header[4]-1)+5] = [1,length+1]
 *   header[6+2*(header[4]-1)+6:...] = entries = code of string  (int)
 *
 *----------------------------------------------------------------------
 **************************************************************************/

mxClassID mxGetClassID(const mxArray *ptr)
{
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: 
    return mxDOUBLE_CLASS;
  case STRINGMATRIX:
    return mxCHAR_CLASS;
  case SPARSEMATRIX:
    return mxSPARSE_CLASS;
  case INTMATRIX:
    /*[8,m,n,it] it=01    02   04    11     12    14
                   int8 int16 int32 uint8 uint16 uint32    */
    switch (header[3]){
    case 1:
      return mxINT8_CLASS;
    case 2:
      return mxINT16_CLASS;
    case 4:
      return mxINT32_CLASS;
    case 11:
      return mxUINT8_CLASS;
    case 12:
      return mxUINT16_CLASS;
    case 14:
      return mxUINT32_CLASS;
    default:
      return mxUNKNOWN_CLASS;
    }
  case MLIST:
    switch (theMLIST(header)) {
    case CELL:
      return mxCELL_CLASS;
    case STRUCT:
      return mxSTRUCT_CLASS;
    case NDARRAY:
    /* header[6+2*(header[4]-1)]   ( = 1, 10, 8)  */
    switch (header[6+2*(header[4]-1)]) {
    case DOUBLEMATRIX:
      return mxDOUBLE_CLASS;
    case STRINGMATRIX:
      return mxCHAR_CLASS;
    case INTMATRIX:
      switch (header[6+2*(header[4]-1)+3]) {
      case 1:
	return mxINT8_CLASS;
      case 2:
	return mxINT16_CLASS;
      case 4:
	return mxINT32_CLASS;
      case 11:
	return mxUINT8_CLASS;
      case 12:
	return  mxUINT16_CLASS;
      case 14:
	return  mxUINT16_CLASS;
      default:
	return mxUNKNOWN_CLASS;
      }
    }
    default:
      return mxUNKNOWN_CLASS;
    }
  }
  return mxUNKNOWN_CLASS;
}


bool mxIsInt8(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxINT8_CLASS;
}

bool mxIsInt16(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxINT16_CLASS;
}

bool mxIsInt32(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxINT32_CLASS;
}

bool mxIsUint8(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxUINT8_CLASS;
}

bool mxIsUint16(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxUINT16_CLASS;
}

bool mxIsUint32(mxArray *ptr)
{
  return mxGetClassID(ptr)==mxUINT32_CLASS;
}

double mxGetEps(void)
{
  double eps;
  eps=C2F(dlamch)("e",1L);
  return eps;
}


double mxGetInf(void)
{
  double big;
  big=C2F(dlamch)("o",1L);
  return big*big;
}

double mxGetNaN(void)
{
double x,y;
x=mxGetInf();
y=x/x;
  return y;
}

int mxIsInf(double x)
{
  if (x == x+1)
    return 1;
  else return 0;
}

int mxIsFinite(double x)
{
  if (x < x+1)
    return 1;
  else return 0;
}

int mxIsNaN(double x)
{
  if ( x != x ) 
    return 1;
  else return 0;
}

int *RawHeader(mxArray *ptr)
{
  /* Utility function : return an integer pointer to   *
   * a Scilab variable. The variable can be            *
   * a reference (header[0] < 0)                       */
  int *header = (int *) stkptr((long int)ptr);
  return header;
}

int Is1x1(mxArray *ptr)
{
  int proddims,k;
  int *header = RawHeader(ptr);
  int *headerdims = listentry(header,2);
  proddims=1;
  for (k=0; k<headerdims[1]*headerdims[2]; k++) {
    proddims=proddims*headerdims[4+k];
  }
  return (int) proddims==1;
}


mxArray *mxCreateData(int m)
     /* Utility fctn : create a no-header, unpopulated  *
      * mxArray of size=m*sizeof(double)               */
{
  static int lw, lr;
  int n; int size;
  lw = Nbvars + 1;
  size=m-2;
  if (! C2F(createvar)(&lw, "d", &size, (n=1,&n), &lr, 1L)) {
    mexErrMsgTxt("No more memory available: increase stacksize");
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(intersci).iwhere[lw-1];
}


int mxGetNumberOfElements(mxArray *ptr)
{
  int m, commonlength;
  int *header=Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX:
    return header[1]*header[2];
  case MLIST:   /* TO BE DONE */
    return header[6+2*(header[4]-1)+1];
    /* debut=listentry(header,3); (debut)... */
  case STRINGMATRIX:
    m=header[1];
    commonlength=header[5]-header[4];
    return m*commonlength;
    /*case SPARSEMATRIX to be done */
  default:
    return 0;
  }
}


double *mxGetPr(mxArray *ptr)
{
  double *value;
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX:
    /*    return (header[1]==0 || header[2] == 0) ? NULL : &header[4]; */
    return (header[1]==0 || header[2] == 0) ? NULL : (double *) &header[4];
  case MLIST:
    switch (header[6+2*(header[4]-1)]){
    case DOUBLEMATRIX: case INTMATRIX:
      return (double *) &header[6+2*(header[4]-1)+4];
    case STRINGMATRIX:
      return (double *) &header[6+2*(header[4]-1)+6];
    default:
      return 0;
    }
  case STRINGMATRIX:
    value = (double *) header;
    return &value[i2sadr(5 + header[2])];
  case SPARSEMATRIX:
    value = (double *) header;
    return &value[ i2sadr(5+header[2]+header[4]) ];
  default:
    return 0;
  }
}



double *mxGetPi(mxArray *ptr)
{ 
  int debut; int m,n,it;
  /*  double *value = (double *) stkptr((long int)ptr); */
  double *value;
  int *header = Header(ptr);
  value = (double *) header;
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX:
    if (header[3]==0 || header[1]==0 || header[2] == 0) return NULL;
    return  &value[2 + header[1] * header[2]]; 
  case MLIST:
    debut=6+2*(header[4]-1);
    switch (header[debut]){
    case DOUBLEMATRIX: case INTMATRIX:
      m=header[debut+1];n=header[debut+2];
      it=header[debut+3];  /* it should be 1 */
      return (double *) &header[debut+4+2*m*n];
    default:
      return 0;
    }
  case SPARSEMATRIX:
    if (header[3]==0) return NULL;
    return &value[ i2sadr(5+header[2] +header[4]) + header[1]*header[2]];
  default:
    return 0;
 }
}

int mxGetNumberOfDimensions(mxArray *ptr)
{
  int *header1;
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX: case SPARSEMATRIX: case STRINGMATRIX:
    return 2;
  case MLIST:
    switch (theMLIST(header)) {
    case NDARRAY:
      return header[29]*header[30]; /* header[29] or header[30] = 1  */
    case CELL: case STRUCT:
      header1 = (int *) listentry(header,2)  ;
      return header1[1]*header1[2];
    default:
      return 0;
	}
  default:
    return 0;
  }
}

int *mxGetDimensions(mxArray *ptr)
{
  int *header1;
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX: case STRINGMATRIX:
    return &header[1];
  case SPARSEMATRIX: /* to be done  */
    return &header[1];
    break;
  case MLIST:
    switch (theMLIST(header)) {
      /*  case NDARRAY       return &header[32];       break;  */
    case NDARRAY: case CELL: case STRUCT:
      header1 = (int *) listentry(header,2);
      return &header1[4];
  default:
    return 0;
    }
  }
  return 0;
}

int mxGetM(mxArray *ptr)
{
  int *header1;
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX: case STRINGMATRIX: case SPARSEMATRIX:
    return header[1];
  case MLIST:
    switch (theMLIST(header)) {
    case NDARRAY:
      return header[32]; 
    case CELL: case STRUCT:
      header1 = (int *) listentry(header,2);
      return header1[4];
    default:
      return 0;
    }
  default:
    return 0;
  }
}

void mxSetM(mxArray *ptr, int M)
{
  mxArray *mxNew;
  int size;
  int oldM; int commonlength; int j;
  int *headernew;
  double *valueold, *valuenew;
  int *header = Header(ptr);
  switch (header[0]) {
  case STRINGMATRIX:
    /* string: copy header[5+oldM] to header[5+mnew]  */    
    oldM=header[1];
    commonlength=header[5]-header[4];
    for (j=0; j<=M*commonlength; ++j) {
      header[5+j+M]=header[5+j+oldM];
    }
    header[1]=M;
    break;
  case DOUBLEMATRIX: case INTMATRIX: 
    /* make ptr a reference */
    size=2+M*header[2];  /*  oldN=header[2] */
    mxNew = mxCreateData(size);   /* performs Nbvars++ */
    headernew = (int *) stkptr((long int) mxNew);
    headernew[0]=header[0];
    headernew[1]=M;
    headernew[2]=header[2];
    headernew[3]=header[3];
    valueold = (double *) &header[4]; valuenew = (double *) &headernew[4];
    memcpy(valuenew, valueold, M*header[2]*sizeof(double));
    ChangeToRef(arr2num(ptr),Nbvars);
    break;
  default:
    break;
  }
}


int *mxGetJc(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0] != SPARSEMATRIX) {
    return 0;}
  /*  header[0]=7;  M=header[1];  N=header[2];  it =header[3];  nzmax=header[4];
      Jc[0]=header[5];  Jc[1]=header[6]; etc; Jc[N]=nnz; */
  return &header[5];
}

int *mxGetIr(mxArray *ptr)
{
  int *header = Header(ptr);
  /* ... N=header[2],  nzmax=header[4]; then Jc,  then Ir   */
  return &header[5+header[2]+1];
}

void mxSetJc(mxArray *array_ptr, int *jc_data)
{
 int * start_of_jc; 
 int N;
 int *header = Header(array_ptr);
 
 start_of_jc = (int *) mxGetJc(array_ptr);
 N = header[2];
 memcpy(start_of_jc, jc_data, (N+1)*sizeof(int));
}

void mxSetIr(mxArray *array_ptr, int *ir_data)
{
  int * start_of_ir;
  int NZMAX;
  int *header = Header(array_ptr);
  start_of_ir = (int *) mxGetIr(array_ptr);
  NZMAX = header[4];
  memcpy(start_of_ir, ir_data, NZMAX*sizeof(int));
}

void mxSetNzmax(mxArray *array_ptr, int nzmax)
{
  int isize, Mold, Nold, NZMAXold, ITold;
  double *Prold, *Piold;
  int *Irold, *Jcold;
  mxArray *mxNew; int *headernew;
  int *header = Header(array_ptr);
  Mold=header[1]; Nold=header[2]; ITold=header[3]; NZMAXold=header[4]; 
  Jcold=mxGetJc(array_ptr);
  Irold=mxGetIr(array_ptr);
  Prold=mxGetPr(array_ptr); 
  isize = 5 + (Nold+1) + nzmax + (ITold+1)*2*nzmax; 
  mxNew = mxCreateData( sadr(isize));   /* performs Nbvars++ */
  headernew = (int *) stkptr((long int) mxNew);
  headernew[0]=header[0];
  headernew[1]=Mold;  headernew[2]=Nold;  headernew[3]=ITold;
  headernew[4]=nzmax;
  memcpy( mxGetJc(mxNew), Jcold, (Nold+1)*sizeof(int));
  memcpy( mxGetIr(mxNew), Irold, NZMAXold*sizeof(int));
  memcpy( mxGetPr(mxNew), Prold, NZMAXold*sizeof(double));
  if (ITold==1) {
    Piold = mxGetPi(array_ptr); 
    memcpy( mxGetPi(mxNew), Piold, NZMAXold*sizeof(double));
  }
  ChangeToRef(arr2num(array_ptr),Nbvars);
}

int mxGetN(mxArray *ptr)
{
  int ret;int j;
  int *header1;
  int numberofdim;
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: case INTMATRIX: case SPARSEMATRIX:
    return header[2];
  case STRINGMATRIX:
    /*  for strings, N=length of first (and unique, header[2]=1) column 
        (all rows have same Matlab-length) */
    return header[5]-header[4];
  case MLIST:
    switch (theMLIST(header)) {
    case NDARRAY: case CELL: case STRUCT:
      header1 = (int *) listentry(header,2);
      numberofdim = header1[1]*header1[2];
      if (numberofdim==2)
      return header1[5];
      else
	ret=header1[5];
      for (j=0; j < numberofdim-2; ++j) ret=ret*header1[6+j]; 
      return ret;
    default:
      return 0;
	}
  default:
    return 0;
  }
}

void mxSetN(mxArray *ptr, int N)
{
  mxArray *mxNew;
  int i,m,new,size;
  int *headernew;
  double *valueold, *valuenew;
  int *header = Header(ptr);
  switch (header[0]) { 
  case STRINGMATRIX:
    m=header[1];
    /* oldN = header[5]-header[4];  */
    for (i=0; i<m; ++i) {
      header[5+i]=header[4+i]+N;
      /* to be done: compress header[5+m]  */
    }
    break;
  case DOUBLEMATRIX: case INTMATRIX: 
    /* make ptr a reference */
    size=2+header[1]*N;  /*  oldM=header[1] */
    mxNew = mxCreateData(size);
    headernew = (int *) stkptr((long int) mxNew);
    headernew[0]=header[0];
    headernew[1]=header[1];
    headernew[2]=N;
    headernew[3]=header[3];
    new = Nbvars;
    valueold = (double *) &header[4]; valuenew = (double *) &headernew[4];
    memcpy(valuenew, valueold, header[1]*N*sizeof(double));
    ChangeToRef(arr2num(ptr),new);
    break;
  case SPARSEMATRIX:
    /* TO BE DONE */
    break;
  default:
    break;
  }
}


int mxIsString(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0] == STRINGMATRIX) 
    return 1;
  else return 0;
} 

int mxIsChar(mxArray *ptr)
{
  int *header = Header(ptr);
  switch (header[0]) {
  case STRINGMATRIX:
    return 1;
  case MLIST:
    switch (header[6+2*(header[4]-1)]){
    case STRINGMATRIX:
      return 1;
    default:
      return 0;
    }
  default:
    return 0;
  } 
}

int mxIsNumeric(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0] != STRINGMATRIX)
    return 1;
  else
    return 0;
}

int mxIsDouble(mxArray *ptr)
{
  int *header = Header(ptr);
  if ((header[0] == DOUBLEMATRIX) | (header[0] == SPARSEMATRIX) | ( (header[0] == MLIST) && (header[6+2*(header[4]-1)] == DOUBLEMATRIX)))
    return 1;
  else 
    return 0;
}

int mxIsEmpty(mxArray *ptr)
{
  int *header = Header(ptr);
  if ( (header[0] == DOUBLEMATRIX) | (header[0] == SPARSEMATRIX) ) 
    return 1-header[1]*header[2];
  else 
    return 0;
}

int mxIsFull(mxArray *ptr)
{
  int *header = Header(ptr);
  if ( header[0] != SPARSEMATRIX)
    return 1;
  else
    return 0;
}

int mxIsSparse(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0] == SPARSEMATRIX) 
    return 1;
  else
    return 0;
}

int mxIsLogical(mxArray *ptr)
{
  int *header = Header(ptr);
  /*     TO BE DONE ND Array */
  if (header[0] == LOGICAL) 
    return 1;
  else
    return 0;
}

void mxSetLogical(mxArray *ptr)
{
  int *header = Header(ptr);
  header[0] = LOGICAL;
}

void mxClearLogical(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0] != LOGICAL)
    mexErrMsgTxt("Variable is not logical");
  header[0] = DOUBLEMATRIX;
}

int mxIsComplex(mxArray *ptr)
{
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX:
    return header[3];
  case MLIST:
    if (header[6+2*(header[4]-1)] == DOUBLEMATRIX) {
      return header[6+2*(header[4]-1)+3];
    }
  default:
    return 0;
  }
}

double mxGetScalar(mxArray *ptr)
{ 
  double *value;
  int *header = Header(ptr);
  value = (double *) header;
  if (header[0] == DOUBLEMATRIX) {
    return  value[2];
  }
  else if (header[0] == SPARSEMATRIX) {
    /* nnz = header[4];    N = header[2]; */
    return value[ i2sadr(5+header[2]+header[4]) ];
  }
  else {
    return 0;
  }
}

void *mxGetData(mxArray *ptr)
{
  return mxGetPr(ptr);
}

void *mxGetImagData(mxArray *ptr)
{
  return mxGetPi(ptr);
}

void mexErrMsgTxt(char *error_msg)
{
  cerro(error_msg);
  errjump();
}

void mxAssert(int expr, char *error_message)
{
  if (!expr) mexErrMsgTxt(error_message);
}

mxArray *mxCreateDoubleMatrix(int m, int n, int it)
{
  static int lw, lr, lc;
  int k;
  lw = Nbvars + 1;
  if (! C2F(createcvar)(&lw, "d", &it, &m, &n, &lr, &lc, 1L)) {
    mexErrMsgTxt("No more memory available: increase stacksize");
  }
  for ( k=0; k<m*n*(it+1); k++ ) {
   *stk(lr+k)=0;
  }
   return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1];  /* C2F(intersci).iwhere[lw-1]);  */
}

mxArray *mxCreateDoubleScalar(double value)
{
  mxArray *pa;
  pa = mxCreateDoubleMatrix(1, 1, mxREAL);
  *mxGetPr(pa) = value;
  return (mxArray *) pa;
}

int mxIsClass(mxArray *ptr, char *name)
{
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: 
    if ( strcmp(name,"double") == 0) return 1;
    break;
  case MLIST:
    switch (header[6+2*(header[4]-1)]){
    case DOUBLEMATRIX:
      if ( strcmp(name,"double") == 0) return 1;
      break;
    case INTMATRIX:
      if ( strcmp(name,"double") == 0) return 1;
      break;
    }
    break;
  case STRINGMATRIX:
    if ( strcmp(name,"char") == 0) return 1;
    break;
  case SPARSEMATRIX:
    if ( strcmp(name,"sparse") == 0) return 1;
    break;
  default:
    return 0;
  }
  return 0;
}

mxArray *mxCreateStructArray(int ndim, int *dims, int nfields, char **field_names)
{
  static int lw,lw1;
  int retval;
  Nbvars++;
  lw = Nbvars;
  lw1 = lw + Top - Rhs;
  C2F(stcreate)(&lw1, &ndim, dims, &nfields, field_names, &retval);
  if( !retval) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1 ];
}

mxArray *mxCreateStructMatrix(int m, int n, int nfields, char **field_names)
{
  static int lw,lw1;
  int ndim; 
  int retval; 
  int dims[2];

  dims[0] = m; dims[1] = n;

  Nbvars++;
  lw = Nbvars;
  lw1 = lw + Top - Rhs;
  C2F(stcreate)(&lw1, (ndim=2, &ndim), dims, &nfields, field_names, &retval);
  if( !retval) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1 ];
}

void mxSetFieldByNumber(mxArray *array_ptr, int index, int field_number, mxArray *value)
{
  int pointed, point_ed;
  int *headerobj; int *headervalue;
  int *header = Header(array_ptr);
  if (Is1x1(array_ptr)) {
    headerobj = listentry( header, field_number+3);}
  else {
    headerobj = listentry( listentry(header, field_number+3)  ,index+1);}
  if (IsReference(value))
    {
      headervalue = RawHeader(value);
      headerobj[0] = headervalue[0];
      headerobj[1] = headervalue[1];
      headerobj[2] = headervalue[2];
      headerobj[3] = headervalue[3];
    }
  else 
    {
      pointed = arr2num(value);
      point_ed = Top - Rhs + pointed;
      headerobj[0]= - *istk( iadr(*lstk( point_ed )) );  /* reference : 1st entry (type) is opposite */
      headerobj[1]= *lstk(point_ed);  /* pointed adress */
      headerobj[2]= pointed; /* pointed variable */
      headerobj[3]= *lstk(point_ed + 1) - *lstk(point_ed);  /* size of pointed variable */
    }
}

void mxSetField(mxArray *array_ptr, int index, char *field_name, mxArray *value)
{
  int field_num;
  field_num = mxGetFieldNumber(array_ptr, field_name);
  mxSetFieldByNumber(array_ptr, index, field_num, value);
}

char *mxGetFieldNameByNumber(mxArray *array_ptr, int field_number)
{
  int k, longueur, istart, nf, job;
  int *headerstr;
  int *header = Header(array_ptr);
  char *str = (char *) mxMalloc_m(25*sizeof(char));
  headerstr = listentry(header,1);
  nf=headerstr[1]*headerstr[2]-2;  /* number of fields */
  k=field_number;
  if (k>nf) return (char *) 0;  /*  ?  */
  longueur=Min(headerstr[7+k]-headerstr[6+k],24);  /* size of kth fieldname */
  istart=6+nf+headerstr[6+k];    /* start of kth fieldname code */
  C2F(cvstr)(&longueur, &headerstr[istart], str, (job=1, &job),longueur);
  str[longueur]='\0';
  return str;
}

/*
mxCHAR *mxGetChars(mxArray *array_ptr)
{
  mexPrintf("%Not yet implemented\n");
}  */


int IsReference(mxArray *array_ptr)
{
  if ((int) RawHeader(array_ptr)[0]<0) 
    return 1;
  else
    return 0;
}

mxArray *mxCreateNumericArray(int ndim, int *dims, int CLASS, int cmplx)
{
  static int lw,lw1;
  int retval;
  Nbvars++;
  lw = Nbvars;
  lw1 = lw + Top - Rhs;
  C2F(hmcreate)(&lw1, &ndim, dims, &CLASS, &cmplx,&retval);
  if( !retval) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1 ];  /* C2F(intersci).iwhere[lw-1])  */
}

mxArray *mxCreateCharArray(int ndim, int *dims)
{
  static int lw,lw1, CLASS, cmplx;
  int retval;
  Nbvars++;
  lw = Nbvars;
  lw1 = lw + Top - Rhs;
  C2F(hmcreate)(&lw1, &ndim, dims, (CLASS=11, &CLASS),(cmplx=0, &cmplx),&retval);
  if( !retval) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw+ Top - Rhs - 1];  /* C2F(intersci).iwhere[lw-1])  */
}

mxArray *mxCreateCellArray(int ndim, int *dims)
{
  static int lw,lw1;
  int retval;
  int nfields;char *field_names[] = {"entries"};
  Nbvars++;
  lw = Nbvars;
  lw1 = lw + Top - Rhs;
  C2F(stcreate)(&lw1, &ndim, dims, (nfields=1,&nfields), field_names , &retval);
  if( !retval) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1 ];
}

mxArray *mxCreateCellMatrix(int nrows, int ncols)
{
  int two=2;int dims[2];
  dims[0] = nrows; dims[1] = ncols;
  return mxCreateCellArray(two, dims);
}

mxArray *mxGetCell(mxArray *ptr, int index)
{
  int kk,lw,isize;
  int *headerlist,*headerobj,*headerobjcopy;
  int *header = Header(ptr);
  if (Is1x1(ptr)) {
    headerobj = listentry( header, index+1);
    isize = header[5]- header[4];
  }
  else {
    headerlist = listentry(header,3);
    headerobj = listentry(headerlist,index+1);
    isize=2*(headerlist[index+3]-headerlist[index+2]);
  }
  Nbvars++;  lw=Nbvars;
  CreateData(lw,4*isize);
  headerobjcopy=GetData(lw);
  for (kk = 0; kk < isize; ++kk) headerobjcopy[kk]=headerobj[kk];
  C2F(intersci).ntypes[lw-1]=AsIs;
  C2F(intersci).iwhere[lw-1]=C2F(vstk).Lstk[lw+ Top - Rhs - 1];
  return (mxArray *) C2F(intersci).iwhere[lw-1];
}

int mxGetFieldNumber(mxArray *ptr, char *string)
{
  int nf, longueur, istart, k, ilocal, retval;
  int *headerstr;
  static char str[24];
  int *header = Header(ptr);
  headerstr = listentry(header,1);
  nf=headerstr[1]*headerstr[2]-2;  /* number of fields */
  retval=-1;
  for (k=0; k<nf; k++) {
    longueur=Min(headerstr[7+k]-headerstr[6+k],24);  /* size of kth fieldname */
    istart=6+nf+headerstr[6+k];    /* start of kth fieldname code */
    /*    istart=8+headerstr[4+nf+k]; */
    C2F(cvstr)(&longueur, &headerstr[istart], str, (ilocal=1, &ilocal),longueur);
    str[longueur]='\0';
    if (strcmp(string, str) == 0) {
      retval=k;
      break;}
  }
  return retval;
}

mxArray *mxGetField(mxArray *ptr, int index, char *string)
{
  int kk,lw,isize,fieldnum;
  int *headerlist, *headerobj, *headerobjcopy;
  int *header = Header(ptr);
  fieldnum=mxGetFieldNumber(ptr, string);
  if (fieldnum==-1) return (mxArray *) 0;

  if (Is1x1(ptr)) {
    headerobj = listentry( header, 3+fieldnum);
    isize = header[5+fieldnum]- header[4+fieldnum];
  }
  else {
    headerlist = listentry(header,3+fieldnum);
    headerobj = listentry(headerlist,index+1);
    isize=2*(headerlist[index+3]-headerlist[index+2]);
  }

  Nbvars++; lw=Nbvars;
  CreateData(lw,4*isize);
  headerobjcopy=GetData(lw);
  for (kk = 0; kk < isize; ++kk) headerobjcopy[kk]=headerobj[kk];
  C2F(intersci).ntypes[lw-1]=AsIs;
  C2F(intersci).iwhere[lw-1]=C2F(vstk).Lstk[lw+ Top - Rhs - 1];
  return (mxArray *) C2F(intersci).iwhere[lw-1];
}

mxArray *mxGetFieldByNumber(mxArray *ptr, int index, int field_number)
{
  int kk,lw,isize,fieldnum;  /* maxfieldnum, maxindex; */
  int *headerlist, *headerobj, *headerobjcopy;
  int *header = Header(ptr);
  fieldnum = field_number;
  /* maxfieldnum = mxGetNumberOfFields(ptr);
   * maxindex = mxGetM(ptr)*mxGetN(ptr);
   * if (maxfieldnum < fieldnum) return (mxArray *) NULL;
   * if (maxindex < index) return (mxArray *) NULL;  */


  if (Is1x1(ptr)) {
    headerobj = listentry( header, 3+fieldnum);
    isize = header[5+fieldnum]- header[4+fieldnum];
  }
  else {
    headerlist = listentry(header,3+fieldnum);
    headerobj = listentry(headerlist,index+1);
    isize=2*(headerlist[index+3]-headerlist[index+2]);
  }

  Nbvars++; lw=Nbvars;
  CreateData(lw,isize*sizeof(int));
  headerobjcopy=GetData(lw);
  for (kk = 0; kk < isize; ++kk) headerobjcopy[kk]=headerobj[kk];
  C2F(intersci).ntypes[lw-1]=AsIs;
  C2F(intersci).iwhere[lw-1]=C2F(vstk).Lstk[lw+ Top - Rhs - 1];
  return (mxArray *) C2F(intersci).iwhere[lw-1];
}

int mxGetNumberOfFields(mxArray *ptr)
{
  int *header = Header(ptr);
  if (header[0]==MLIST) return header[1]-2;
  else return 0;
}

/*----------------------------------------------------
 * mxCalloc is supposed to initialize data to 0 
 * but what does it means since size can be anythink 
 * we initialize to zero for double and int data types 
 *----------------------------------------------------*/

void *mxCalloc(unsigned int n, unsigned int size)
{
  int m;  vraiptrst lrd; 
  static int one=1; int N;
  static double zero =0.0;
  m = (n * size) /sizeof(double) + 1;
  if (! C2F(createstkptr)( &m, &lrd)) {
    return 0;
  }
  if ( size ==  sizeof(double)) 
    {
      N=(int) n; C2F(dset)(&N,&zero,(double *) lrd,&one);
    }
  else 
    {
      int i;
      for (i=0; i < n*size ; i++) ((char *) lrd)[i]=0;
    }
  return (void *) lrd;
}


void *mxMalloc(unsigned int nsize)
{
  int m;  vraiptrst lrd;
  m = (nsize) /sizeof(double) + 1;
  if (! C2F(createstkptr)( &m, &lrd)) {
    return 0;
  }
  return (void *) lrd;
}

/* a version which make use of malloc */ 

typedef struct _rec_calloc { 
  void *adr; 
  int  keep; /* 0: free 1: allocated 2: allocated and must be preserved */
} rec_calloc;

#define rec_size 512 
static rec_calloc calloc_table[rec_size]={{0,0}}; 


void *mxCalloc_m(unsigned int n, unsigned int size) 
{
  void *loc = calloc(n,size);
  if ( loc != NULL) {
    int i;
    for ( i = 0 ; i < rec_size ; i++) 
      {
	if (calloc_table[i].keep == 0 ) 
	  {
	    /* sciprint("calloc installed at position %d\r\n",i); */
	    calloc_table[i].adr = loc;
	    calloc_table[i].keep = 1;
	    return loc ; 
	  }
      }
    free(loc);
    return NULL;
  }
  return NULL;
}

void *mxMalloc_m(unsigned int n)
{
  void *loc = malloc(n);
  if ( loc != NULL) {
    int i;
    for ( i = 0 ; i < rec_size ; i++) 
      {
	if (calloc_table[i].keep == 0 ) 
	  {
	    /* sciprint("malloc installed at position %d\r\n",i); */
	    calloc_table[i].adr = loc;
	    calloc_table[i].keep = 1;
	    return loc ; 
	  }
      }
    free(loc);
    return NULL;
  }
  return NULL;
}


void mexMakeMemoryPersistent(void *ptr) {
  int i;
  for ( i = 0 ; i < rec_size ; i++) {
    if (calloc_table[i].adr == ptr)
      {
	if  (calloc_table[i].keep == 1 ) 
	  {
	    calloc_table[i].keep = 2;
	  }
      }
  }
}

/* free : explicit free of a mxCalloc_m allocated space 
 *        except if space is protected 
 */ 

void mxFree_m(void *ptr){ 
  int i;
  
  for ( i = 0 ; i < rec_size ; i++) {
    if (calloc_table[i].adr == ptr)
      {
	/* allocated and preserved */
	if  (calloc_table[i].keep != 0 ) 
	  {
	    /* sciprint("mxFree position %d \r\n",i); */
	    free(ptr);
	    calloc_table[i].keep = 0;
	    calloc_table[i].adr = NULL;
	    return;
	  }
      }
  }
}

/* free : explicit free of all mxCalloc_m allocated space 
 *        except if space is protected 
 */ 

static void mxFree_m_all() {
  int i;
  for ( i = 0 ; i < rec_size ; i++) {
    if  (calloc_table[i].keep == 1 ) 
      {
	/* sciprint("mxFree all position %d \r\n",i); */
        free(calloc_table[i].adr);
	calloc_table[i].keep = 0;
	calloc_table[i].adr = NULL;
      }
  }
}


/*----------------------------------------------------
 * mxCalloc is supposed to initialize data to 0 
 * but what does it means since size can be anythink 
 * we initialize to zero for double and int data types 
 *----------------------------------------------------*/

int mxIsCell(mxArray *ptr)
{
  int *header1; int l;
  int *header = Header(ptr);

  /* mlist(["ce","dims","entries"],[d1,..,dk],list(...)) */
  if (header[0]==MLIST) {
    header1 = (int *) listentry(header,1);
    l = 8;
  /*  "c"=12,  "e"=14   */
    if (header1[0]==STRINGMATRIX && header1[l]==12 && header1[l+1]==14) return 1;
    else return 0;
      }
  else return 0;
}

int mxIsStruct(mxArray *ptr)
{
  int *header1; int nfplus2, l;
  int *header = Header(ptr);
  /* mlist(["st","dims","field1",...,"fieldp"],[d1,..,dk],list1(...),listp(...)) */
  if (header[0]==MLIST) {
    header1 = (int *) listentry(header,1);
    nfplus2 = header1[1]*header1[2];
    l = 5 + nfplus2;
  /*  "s"=28,  "t"=29   */
    if (header1[0]==STRINGMATRIX && header1[l]==28 && header1[l+1]==29) return 1;
    else return 0;
  }
  else return 0;
}
 
int IsstOrce(mxArray *ptr)
{
  int *header1; int l; int nfplus2;
  int *header = Header(ptr);
  if (header[0]==MLIST) {
    header1 = (int *) listentry(header,1);
    nfplus2 = header1[1]*header1[2];
    l = 5 + nfplus2;
    if (header1[0]==STRINGMATRIX)
	if (header1[l]==12 && header1[l+1]==14) return 1;  /*  "ce"  */
	if (header1[l]==28 && header1[l+1]==29) return 1;  /*  "st"  */
    else return 0;
      }
  else return 0;
}
     
/***************************************************************
 * Return in str at most strl characters from first element of 
 * string Matrix pointed to by ptr ( ptr is assumed to be a String Matrix )
 **************************************************************/

int mxGetString(mxArray *ptr, char *str, int strl)
{
  int commonlength, firstchain, nrows; 
  int *header = Header(ptr);

  /*  int ncols = header[2]; This is 1 */
  /* commonlength=nrows*(header[5]-header[4]); */
  nrows = header[1];
  commonlength=header[5]-header[4];
  firstchain=5+nrows;
  C2F(in2str)(&commonlength, &header[firstchain], str,0L);
  return 0;
}

/*-------------------------------------------------
 * mxFreeMatrix : 
 * mxFreeMatrix will do something only if it is called 
 * in the reverse order of variable allocation 
 * Thus after calling mexCallScilab in order to 
 * free the stack, one has to call mxFree as in the 
 * following example :
 *
 * int nlhs = 3; int nrhs = 2;
 * rhs[0] = mxCreateString(filename);
 * rhs[1] = mxCreateFull(1,1,REAL);
 * mexCallMATLAB(nlhs, lhs, nrhs, rhs, "gm_ifile");
 *  free space in reverse order 
 * for (i= nlhs -1 ; i >=0 ; i--) mxFreeMatrix(lhs[i]);
 * for (i= rhs -1 ; i >=0 ; i--) mxFreeMatrix(rhs[i]);
 *-------------------------------------------------*/

void mxFreeMatrix(mxArray *ptr)
{
  /* If we free the last stored object we can decrement Nbvars */
  if ( (int)ptr == C2F(vstk).Lstk[Top - Rhs + Nbvars - 1]) {
    /* sciprint("XXXX OK %dvar %d \r\n",(int)ptr,Nbvars); */
    Nbvars--;
  }
  else {
    /* sciprint("XXXX Fail %d var %d\r\n",(int)ptr,Nbvars); */
  }
  /* Automatically freed when return from mexfunction */
  return ;
}

void  numberandsize(const mxArray  *ptr, int *number, int *size)
     /* utility fct : its number as scilab variable 
      * and its size in Scilab double stack */
{
  int kk,lst_k;
  lst_k=(int) ptr;
  *number=0;*size=0;
  for (kk = 1; kk <= Nbvars; kk++)
    {
      *number=kk;
      if (lst_k == C2F(vstk).Lstk[kk+ Top - Rhs -1]) break;
    }
  *size = C2F(vstk).Lstk[*number+ Top - Rhs] - lst_k;
}

int arr2num( mxArray  *ptr )
{
  int kk,lst_k,number;
  lst_k=(int) ptr;
  number=0;
  for (kk = 1; kk <= Nbvars; kk++)
    {
      number=kk;
      if (lst_k == C2F(vstk).Lstk[kk+ Top - Rhs -1]) break;
    }
  return number;
}
 
mxArray *mxDuplicateArray(const mxArray *ptr)
{
  int start_in;
  int lw, number, size, k;
  double *old , *data;
  start_in = (int) ptr;
  old = stk(start_in);
  Nbvars++; lw = Nbvars;
  numberandsize( ptr, &number, &size);
  CreateData(lw, size*sizeof(double));
  data = (double *) GetData(lw);
  for (k = 0; k <size; ++k)
  data[k]=old[k];
  return (mxArray *) C2F(vstk).Lstk[lw+ Top - Rhs - 1];
}

mxArray *UnrefStruct(mxArray *ptr)
{
  /*   Unreference objects in a struct or cell */
  int number, k;
  int list, index, offset; int sizeobj;
  int nb, nbobj, suite, newbot;

  int oldsize, newsize;

  int *header, *headernew;
  int *headerlist, *headerlistnew; 
  int *headerobj, *headerobjnew;
  int *headerdims; int proddims;int obj;

  mxArray *mxNew;
  header = RawHeader(ptr);
  mxNew = mxDuplicateArray(ptr);
  headernew = RawHeader(mxNew);
  
  offset = Top - Rhs;
  newsize=header[4];   /* Initialize */
  nb=header[1]-2;      /* Number of fields  */
  headerdims = listentry(header,2);
  proddims=1;
  for (k=0; k<headerdims[1]*headerdims[2]; k++) {
    proddims=proddims*headerdims[4+k];
  }
  if (!(proddims==1)) {
    suite=0;
    for (list=0; list<nb; list++) {
      headerlist= listentry(header, list+3);  /* pointing to the field list */
      nbobj=headerlist[1];   /* number of objects in the field */
      for (index=0; index < nbobj; index++)
	{
	  headerobj = listentry( headerlist,index+1);  
	  /* pointing to the object in the field */
	  if (headerobj[0] < 0)
	    sizeobj=headerobj[3];
	  else
	    sizeobj=headerlist[index+3]-headerlist[index+2];
	  newsize += sizeobj;   /* update size of the field */
	}
      suite++;
      newsize += (2+nbobj/2);   /* size of list = size of inside + ... */
      headernew[4+suite] = newsize;
    }
    numberandsize( mxNew, &number, &oldsize);
    newsize += 3;   /* taking account begining of list */
    newbot=*lstk(number+offset)+newsize;
    if( (newbot - *lstk(Bot)) > 0) 
      {Error(17); return 0;}
    *lstk(number+offset+1)=newbot;
    for (list=0; list<nb; list++) {
      headerlist= listentry(header, list+3);
      headerlistnew=listentry(headernew, list+3);
      nbobj=headerlist[1]; 
      headerlistnew[0]= 15;
      headerlistnew[1]= nbobj;
      headerlistnew[2]= 1;
      for (index=0; index < nbobj; index++)
	{	headerobj = listentry( headerlist,index+1);
	if (headerobj[0] < 0)
	  sizeobj=headerobj[3];  /* reference (size of ) */
	else
	  sizeobj=headerlist[index+3]-headerlist[index+2];
	headerlistnew[3+index]=headerlistnew[2+index]+sizeobj;
	}
    }
    for (list=0; list<nb; list++) {
      headerlist= listentry(header, list+3);
      headerlistnew=listentry(headernew, list+3);
      nbobj=headerlist[1]; 
      for (index=0; index < nbobj; index++)
	{	
	  headerobj = listentry( headerlist,index+1);
	  headerobjnew = listentry( headerlistnew,index+1);	
	  if (headerobj[0] < 0)   /* reference */
	    {
	      sizeobj=headerobj[3];
	      headerobj = (int *) stk(headerobj[1]);   /* dereference */
	    }
	  else
	    {
	      sizeobj=headerlist[index+3]-headerlist[index+2];
	    }
	  for (k=0; k<2*sizeobj; k++)
	    headerobjnew[k]=headerobj[k];  /* OUF! */
	}
    }
  }
  else {
    /*   1 x 1 x ... x 1 struct */
    suite=0;
    for (obj=0; obj<nb; obj++) {
      headerobj = listentry(header,3+obj);
      if (headerobj[0] < 0)
	sizeobj=headerobj[3];
      else
	sizeobj = header[5+obj] - header[4+obj];
      newsize += sizeobj;
    suite++;
    newsize += sizeobj;
    headernew[4+suite]=newsize;
    }
    numberandsize( mxNew, &number, &oldsize);
    newsize +=3;
    newbot = *lstk(number+offset)+newsize;
    if ( (newbot - *lstk(Bot)) > 0)
      {Error(17); return 0;}
    *lstk(number+offset+1)=newbot;
    for (obj=0; obj<nb; obj++)
      {
	headerobj = listentry(header, 3+obj);
	headerobjnew = listentry(headernew, 3+obj);
	if (headerobj[0] < 0)
	  {
	    sizeobj=headerobj[3];
	    headerobj = (int *) stk(headerobj[1]);
	  }
	else
	  {
	    sizeobj=header[5+obj]-header[4+obj];
	  }
	for (k=0; k<2*sizeobj; k++)
	  headerobjnew[k]=headerobj[k];
      }
  }
  return mxNew;
}

void mxDestroyArray(mxArray *ptr)
{   /* No need */
  return; 
}

void mxFree(void *ptr)
{
  /* If we free the last stored object we can decrement Nbvars */
  if ( Nbvars >= 1) { 
    if ( (vraiptrst) ptr ==  C2F(locptr)(stk(C2F(intersci).lad[Nbvars - 1]))) 
      {
	/* sciprint("XXXX mxfree OK  %d \r\n",Nbvars); */ 
	Nbvars--;
      }
    else 
      {
	/* sciprint("XXXX mxfree NOTOK %d \r\n",Nbvars); */ 
      }
  }
  return ;
}

int mexAtExit(mxArray *ptr)
{
  /* XXXXX To be done....*/
  return 0;
}

mxArray *mxCreateSparse(int m, int n, int nzmax, int cmplx)
{
  static int lw, iprov;
  Nbvars++;
  lw=Nbvars;
  iprov = lw + Top - Rhs;
  if( ! C2F(mspcreate)(&iprov, &m, &n, &nzmax, &cmplx)) {
    return (mxArray *) 0;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1];     /* C2F(intersci).iwhere[lw-1])  */
}

/***************************************************************
 * Create on Scilab Stack a 1x1 string matrix filled with string
 **************************************************************/

mxArray *mxCreateString(const char *string)
{
  static int i, lw;
  static int one=1;
  i = strlen(string);
  lw=Nbvars+1;
  /* we do not increment Nbvars since it is done inside createvar */
  if ( ! C2F(createvarfromptr)(&lw, "c", &one, &i, (double *) &string, 1L) ) {
    return (mxArray *) 0;
  }
  /* back conversion to Scilab coding */
  Convert2Sci(lw);
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw + Top - Rhs - 1];
}

mxArray *mxCreateLogicalMatrix(int m, int n)
{
  int new, k; int *header;
  Nbvars++;
  new=Nbvars;
  CreateData(new, (3+m*n)*sizeof(int));
  header =  (int *) GetData(new);
  header[0]=LOGICAL;
  header[1]= m; 
  header[2]= n; 
  for (k=0; k<m*n; k++) 
    header[3+k]= 0;
  return (mxArray *) C2F(intersci).iwhere[new-1]; 
}

mxArray *mxCreateLogicalScalar(mxLOGICAL *value)
{
  mxArray *pa; int *header;
  pa = mxCreateLogicalMatrix(1, 1);
  header = (int *) stkptr((long int) pa);
  header[3]=(int) value;
  return (mxArray *) pa;
}

bool mxIsLogicalScalarTrue(mxArray *pa)
{
  bool retval;
  retval = mxIsLogical(pa) && mxGetNumberOfElements(pa) == 1 && *mxGetLogicals(pa) == 1;
  return retval;
}


bool mxIsLogicalScalar(mxArray *pa)
{
  bool retval;
  retval = mxIsLogical(pa) && mxGetNumberOfElements(pa) == 1;
  return retval;
}
/* 
  Print function which prints (format,args,....) 
  in Scilab window
*/


/*
#ifdef __STDC__ 
void  C2F(mexprintf)(char *fmt,...) 
#else 
void  C2F(mexprintf)(va_alist) va_dcl
#endif 
{
  int i;  integer lstr;  va_list ap;  char s_buf[1024];
#ifdef __STDC__
  va_start(ap,fmt);
#else
  char *fmt;
  va_start(ap);
  fmt = va_arg(ap, char *);
#endif
  C2F(xscion)(&i);
  if (i == 0) 
    {
      (void)  vfprintf(stdout, fmt, ap );
    }
  else 
    {
      (void ) vsprintf(s_buf, fmt, ap );
      lstr=strlen(s_buf);
      C2F(xscisrn)(s_buf,&lstr,0L);
    }
  va_end(ap);
}
*/


void mexWarnMsgTxt(char *error_msg)
{
  mexPrintf("Warning: ");
  mexPrintf(error_msg);
  mexPrintf("\n\n");
  /*  mexPrintf(strcat("Warning: ",error_msg)); */
}

/* 1 is returned in case of failure */

static int mexCallSCI(int nlhs, mxArray **plhs, int nrhs, mxArray **prhs, char *name,int jumpflag)
{
  static int i1, i2;
  static int k, kk, nv;
  nv = Nbvars;
  for (k = 1; k <= nrhs; ++k) 
    {
      for (kk = 1; kk <= nv; ++kk) 
	if ((int) prhs[k-1] == C2F(vstk).Lstk[kk + Top - Rhs - 1]) break;
      if (kk == nv + 1) 
	{
	  mexErrMsgTxt("mexCallSCILAB: invalid pointer passed to called function");
	  return 1;
	} 
      else 
	{
	  ++Nbvars;
	  i1 = Top - Rhs + kk;
	  i2 = Top - Rhs + Nbvars;
	  C2F(vcopyobj)("mexCallSCILAB", &i1, &i2, 13L);
	}
    }
  i1 = nv + 1;
  if (! C2F(scistring)(&i1, name, &nlhs, &nrhs, strlen(name) )) { 
    if ( jumpflag == 1) 
      {
	mexErrMsgTxt("mexCallSCILAB: evaluation failed ");
      }
    return 1; 
    /*	return 0;  */
  }
  for (k = 1; k <= nlhs; ++k) {
    plhs[k-1] = (mxArray *) C2F(vstk).Lstk[nv + k + Top - Rhs - 1];
  }
  Nbvars = nv+nlhs;
  return 0;
}


int mexCallSCILAB(int nlhs, mxArray **plhs, int nrhs, mxArray **prhs, char *name) {
  return mexCallSCI(nlhs,plhs,nrhs,prhs,name,1); 
}

int mxCalcSingleSubscript(mxArray *ptr, int nsubs, int *subs)
{
  int k, retval, coeff;
  int *dims = mxGetDimensions(ptr);
  retval=0;coeff=1;
  for  (k=0; k<nsubs; k++) {
    retval=retval+subs[k]*coeff;
    coeff=coeff*dims[k];
  }
  return retval;
}

int C2F(mexcallscilab)(integer *nlhs, mxArray **plhs, integer *nrhs, mxArray **prhs, char *name, int namelen)
{
  return mexCallSCILAB(*nlhs, plhs, *nrhs, prhs, name);
}

/** generic mex interface **/
const char *mexFunctionName(void) { return the_current_mex_name;}

int mex_gateway(char *fname, GatefuncH F)
{
  int nlhs,nrhs;
  mxArray * plhs[intersiz];  mxArray * prhs[intersiz];
  the_current_mex_name=fname;
  C2F(initmex)(&nlhs, plhs, &nrhs, prhs);
  (*F)(nlhs, plhs, nrhs, prhs);
  C2F(endmex)(&nlhs, plhs, &nrhs, prhs);
  return 0;
}

int fortran_mex_gateway(char *fname, FGatefuncH F)
{
  int nlhs,nrhs;
  mxArray * plhs[intersiz];  mxArray * prhs[intersiz];
  C2F(initmex)(&nlhs, plhs, &nrhs, prhs);
  (*F)( &nlhs, plhs, &nrhs, prhs);
  C2F(endmex)(&nlhs, plhs, &nrhs, prhs);
  return 0;
}


/** generic scilab interface **/

int sci_gateway(char *fname, GatefuncS F)
{
  (*F)(fname,strlen(fname));
  if (!C2F(putlhsvar)()) {return 0;}
  return 0;
}

int mxGetElementSize(mxArray *ptr)
{ int k, it; 
 int *header = Header(ptr);
 switch (header[0]) {
 case DOUBLEMATRIX: case SPARSEMATRIX:
   return sizeof(double);
 case STRINGMATRIX:
   return 2*sizeof(char);    /* ? Matlab returns 2 */
 case MLIST:
   k=header[4];
   /*   header[6+2*(k-1)]  =  1 if double matrix, 8 if integer  */
   if (header[6+2*(k-1)]==DOUBLEMATRIX)  return sizeof(double);
   if (header[6+2*(k-1)]==INTMATRIX) {
     it= header[6+2*(k-1)+3]; return( it%10 );   
   }
   break;
 case INTMATRIX:
   /*[8,m,n,it] it=01    02   04    11     12    14
     int8 int16 int32 uint8 uint16 uint32    */
   it=header[3];
   return( it%10 );
 default:
   mexErrMsgTxt("GetElementSize error");
   return 0;
 }
 return 0;
}

mxArray *mxCreateCharMatrixFromStrings(int m, char **str)
{
  static int i, lr1, lw, ilocal, n, k,kk, nmax;
  nmax = strlen(str[0]);
  for (k=1; k<m; ++k) {
    n=strlen(str[k]);
    if (n > nmax) nmax=n;
  }
  Nbvars++;
  lw = Nbvars + Top -Rhs;
  /*      logical function cresmat3(fname,lw,m,n,nchar,lr) */
  if( ! C2F(cresmat4)("mxCreateString:", &lw, &m, &nmax, &lr1, 15L)) {
    return (mxArray *) 0;
  }
  /*    Convert string to integer code    */
  /*   subroutine cvstr(n,line,str,job) */
  for (k=0; k<m; ++k) {
    n=strlen(str[k]);
    /* fill with blanks (40) if n<nmax !!*/
    C2F(cvstr)(&n, istk(lr1), str[k], (ilocal=0, &ilocal),i);
    if (nmax>n) {
      for (kk=0; kk<nmax-n; ++kk) *istk(lr1+n+kk)=40;
    };
    lr1=lr1+nmax;
  }
  C2F(intersci).ntypes[lw-1]=AsIs;
  return (mxArray *) C2F(vstk).Lstk[lw - 1];
}

int mexEvalString(char *name)
{
  double *val ;
  int rep;
  mxArray *ppr[3];mxArray *ppl[1];
  int nlhs;     int nrhs;
  ppr[0] = mxCreateString(name);
  ppr[1] = mxCreateString("errcatch");
  ppr[2] = mxCreateString("m");
  nrhs=3;nlhs=1;
  rep = mexCallSCI(nlhs, ppl, nrhs, ppr, "execstr",0); 
  /* check returned value */ 
  val = mxGetPr(ppl[0]); 
  mxFreeMatrix(ppl[0]);
  mxFreeMatrix(ppr[2]);
  mxFreeMatrix(ppr[1]);
  mxFreeMatrix(ppr[0]);
  if ( rep == 1 || (int) (*val) != 0 )
    {
      errjump();
    }
  return rep;
}

mxArray *mexGetArray(char *name, char *workspace)
{
  int lw, fin, new ; int *header;
  /* mxArray *mxPointed; */
  if (C2F(objptr)(name,&lw,&fin,strlen(name))) {
    /*    mxPointed = (mxArray *) lw;   */
    Nbvars++; new=Nbvars; 
    CreateData(new, 4*sizeof(int));
    header =  (int *) GetData(new);
    header[0]=- *istk( iadr(*lstk(fin))); 
    header[1]= lw; 
    header[2]= fin; 
    header[3]= *lstk(fin+1) -*lstk(fin) ;
    /*    C2F(intersci).ntypes[new-1]=45;  */
    return (mxArray *) C2F(intersci).iwhere[new-1]; } 
  else
    return (mxArray *) 0;
}

int mexPutArray(mxArray *array_ptr, char *workspace)
{
  /* TO BE DONE obsolete ?  */
  mexPrintf( "Function mexPutArray is obsolete, use mexPutVariable! \n");
  return 1;
}

int mexPutVariable(const char *workspace, char *var_name, mxArray *array_ptr)
{
  /*  workspace ignored: to be done .... */
  PutVar( arr2num( array_ptr) , var_name);
  return 0;  /* CHECK THIS !!!!!! */
}

void mxSetName(mxArray *array_ptr, const char *name)
{
  mexPrintf("Routine mxSetName  not implemented \r\n");
  exit(1);  /* TO BE DONE */
}

void mxSetPr(mxArray *array_ptr, double *pr)
{
  int size;
  double *value;
  value = mxGetPr(array_ptr);
  size=mxGetM(array_ptr)*mxGetN(array_ptr);
  memcpy(mxGetPr(array_ptr), pr, size*sizeof(double));
}

void mxSetPi(mxArray *array_ptr, double *pi)
{
  /* TO BE DONE */
  int size;
  size=mxGetM(array_ptr)*mxGetN(array_ptr);
  memcpy(mxGetPi(array_ptr), pi, size*sizeof(double));
}

const char *mxGetName(const mxArray *array_ptr)
{
    mexPrintf("Routine mxGetName  not implemented \r\n");
    exit(1); 
}

int mxSetDimensions(mxArray *array_ptr, const int *dims, int ndim)
{
  mexPrintf("Routine mxSetDimensions  not implemented \r\n");
  exit(1);  /* TO BE DONE */
}

const char *mxGetClassName(const mxArray *ptr)
{
  int *header = Header(ptr);
  switch (header[0]) {
  case DOUBLEMATRIX: 
    return "double";
  case STRINGMATRIX:
    return "char";
  case SPARSEMATRIX:
    return "sparse";
  case INTMATRIX:
    /*[8,m,n,it] it=01    02   04    11     12    14
      int8 int16 int32 uint8 uint16 uint32    */
    switch (header[3]){
    case 1:
      return "int8";
    case 2:
      return "int16";
    case 4:
      return "int32";
    case 11:
      return "uint8";
    case 12:
      return "uint16";
    case 14:
      return "uint32";
    default:
      return "unknown";
    }
  case MLIST:
    /* to be done return mxCELL_CLASS or mxCHAR_CLASS or mxSTRUCT_CLASS */
    /* header[6+2*(header[4]-1)]   ( = 1, 10, 8)  */
    switch (theMLIST(header)) {
    case CELL:
      return "cell";
    case STRUCT:
      return "struct";
    case NDARRAY:
    switch (header[6+2*(header[4]-1)]) {
      /* listentry(header,3) */
    case DOUBLEMATRIX:
      return "double";
    case STRINGMATRIX:
      return "char";
    case INTMATRIX:
      switch (header[6+2*(header[4]-1)+3]) {
      case 1:
	return "int8";
      case 2:
	return "int16";
      case 4:
	return "int32";
      case 11:
	return "uint8";
      case 12:
	return "uint16";
      case 14:
	return "uint32";
      default:
	return "unknown";
      }
    }
    default:
      return "unknown";
    }
  }
  return "unknown";
}

void mxSetCell(mxArray *array_ptr, int index, mxArray *value)
{
  mxSetFieldByNumber(array_ptr, index, 0 , value);
  return;
}

/*
const char *mxGetFieldNameByNumber(const mxArray *array_ptr, int field_number)
{
  return "not implemented";
}
*/

int mxGetNzmax(mxArray *ptr)
{
  int *header = Header(ptr);
  /* ... N=header[2],  nzmax=header[4]; then Jc,  then Ir   */
  return header[4];
}

mxLOGICAL *mxGetLogicals(mxArray *array_ptr)
{
  int *header = Header(array_ptr);
  /*  TO BE DONE : ND Arrays  */
  if (header[0] != LOGICAL) return  NULL;
  return (mxLOGICAL *) &header[3];
}

int C2F(initmex)(integer *nlhs, mxArray **plhs, integer *nrhs, mxArray **prhs)
{
  int *header;int *header1;
  static int output, k, RhsVar;
  static int m, commonlength, line;
  if (Rhs==-1) Rhs++;
  Nbvars = 0;
  *nlhs = Lhs;  *nrhs = Rhs;
  for (output = 1; output <= *nlhs ; ++output) plhs[output-1]=0;
  for (k = 1; k <= *nrhs ; ++k) 
    {
      RhsVar = k  + Top - Rhs;
      prhs[k-1] = (mxArray *) C2F(vstk).Lstk[RhsVar - 1];
      C2F(intersci).ntypes[k-1]=AsIs;
      header = (int *) stkptr((long int)prhs[k-1]);
      /*
	Indirect
       */
      if (header[0] < 0) header = (int *) stk(header[1]);
      switch (header[0]) {
      case DOUBLEMATRIX: case INTMATRIX: case SPARSEMATRIX:
	break;
      case STRINGMATRIX:
	if (header[2] !=1) mexErrMsgTxt("Invalid string matrix (at most one column!)");
	m=header[1];
	commonlength=header[5]-header[4];
	if (m > 1) {
 	  for (line = 1; line < m; line++)
	    {
	      if (header[5+line] - header[4+line] != commonlength)
		mexErrMsgTxt("Column length of string matrix must agree!");
	    }
	}
	break;
      case 5:
	mexErrMsgTxt("Use mtlb_sparse(sparse( ))!");
	/*   scilab sparse  should be matlabified  */
	return 0;
      case MLIST:
	header1 = (int *) listentry(header,2);
	/* m = header1[1]*header1[2]; */
	/* C2F(entier)(&m, (double *) &header1[4], &header1[4]); */
	break;
      case LOGICAL :
	break;
      default:
	mexErrMsgTxt("Invalid input");
	return 0;
      }
    }
  Nbvars = Rhs ;
  return 0;
}


/****************************************************
 * A set of utility functions 
 ****************************************************/

vraiptrst C2F(locptr)(void * x)
{
  return((vraiptrst) x);
}

int C2F(createstkptr)(integer *m, vraiptrst *ptr)
{
  int lr, n=1, lw;
  Nbvars++;
  lw = Nbvars;
  if (! C2F(createvar)(&lw, "d", m, &n, &lr, 1L)) {
    return 0;
  }
  *ptr = C2F(locptr)(stk(lr));
  return 1;
} 

int C2F(createptr)(char *type, int *m, int *n, int *it, int *lr, int *ptr, long int type_len)
{
  static int lc, lw;
  Nbvars++;
  lw = Nbvars;
  /* sciprint("createptr XXXX  %d\n\r",lw); */
  if (! C2F(createcvar)(&lw, type, it, m, n, lr, &lc, 1L)) {
    return 0;
  }
  *ptr = C2F(vstk).Lstk[lw + Top - Rhs - 1];
  return 1;
} 

int C2F(endmex)(integer *nlhs, mxArray **plhs, integer *nrhs, mxArray **prhs)
{
  int nv,kk,k,plhsk;
  for (k = 1; k <= *nlhs; k++) {
    if (IsstOrce(plhs[k-1])) plhs[k-1]=UnrefStruct(plhs[k-1]);
  }
  nv=Nbvars;
  for (k = 1; k <= *nlhs; k++)
    {
      plhsk = (int) plhs[k-1];
      LhsVar(k) = 0;
      for (kk = 1; kk <= nv; kk++)
	{
	  if (plhsk == C2F(vstk).Lstk[kk+ Top - Rhs -1]) 
	    {
	      LhsVar(k) = kk;
	      break;
	    }
	}
    }
  C2F(putlhsvar)();
  /** clear mxMalloc_m and and mxCalloc_m  **/
  mxFree_m_all();
  return 0;
}

/* a utility function to recover available Vars position */ 

void clear_mex(integer nlhs, mxArray **plhs, integer nrhs, mxArray **prhs)
{
  int nv=Nbvars ,k; 
  int max = (int) plhs[0] ; 
  for (k = 1; k <= nlhs; k++)
    if (  (int)plhs[k-1] > max ) max =  (int)plhs[k-1];
  for (k = 1; k <= nrhs; k++)
    if ( (int)  prhs[k-1] > max ) max =  (int) prhs[k-1];
  for (k = 1; k <= nv; k++)
    if ( max <  C2F(vstk).Lstk[k + Top - Rhs -1]) Nbvars--;
}

void mexInfo(char *str) {
  fprintf(stderr,"%s %d\r\n",str,Nbvars);
  fflush(stderr);
}

int mexCheck(char *str,int nbvars) { 
  if ( nbvars != -1 && Nbvars != nbvars) 
    fprintf(stderr,"%s %d %d\r\n",str,Nbvars,nbvars);
  return Nbvars ;
}


/****************************************************
 * C functions for Fortran  mexfunctions 
 ****************************************************/

double * C2F(mxgetpr)(mxArray *ptr)
{
  /*  double *value = (double *) stkptr(*ptr); */
  double *value;
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  value = (double *) header;
  if (header[0]==DOUBLEMATRIX) {
    return &value[2];
  }
  else if ( header[0]==SPARSEMATRIX ) { 
    /*    nnz = header[4];  N = header[2];  */
    return &value[ i2sadr(5+header[2]+header[4]) ];
  }
  else {
    return 0;
  }
}


double * C2F(mxgetpi)(mxArray *ptr)
{
  /*  double *value = (double *) stkptr(*ptr); */
  double *value;
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  value = (double *) header;
  return &value[2 +  C2F(mxgetm)(ptr) *  C2F(mxgetn)(ptr)];
}

int  C2F(mxgetm)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  return header[1] ;
}

int  C2F(mxgetn)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if ( header[0] == STRINGMATRIX) {
    return header[5]-1;
  }
  return header[2] ;
}

int  C2F(mxisstring)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if (header[0] == STRINGMATRIX) 
    return 1;
  else return 0;
} 

int  C2F(mxisnumeric)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if ( header[0] == DOUBLEMATRIX) 
    return 1;
  else 
    return 0;
}

int  C2F(mxisfull)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if ( header[0] == DOUBLEMATRIX) {
    return 1;
  }
  return 0;
}

int  C2F(mxissparse)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if (header[0] == SPARSEMATRIX) {
    return 1;
  }
  return 0;
}


int  C2F(mxiscomplex)(mxArray *ptr)
{
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  if (header[3] == DOUBLEMATRIX) {
    return 1;
  }
  return 0;
}

double  C2F(mxgetscalar)(mxArray *ptr)
{ 
  static int N,nnz;
  double *value;
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  value = (double *) header;
 if (header[0] == DOUBLEMATRIX) {
   return  value[2];
 }
 else if (header[0] == SPARSEMATRIX) {
   nnz = header[4];   N = header[2];
   return value[(5+nnz+N)/2+1];
 }
 else {
   return 0;
 }
}

void  C2F(mexprintf)(char *error_msg, int len)
{
  char * buf;
  if ((buf = (char *)malloc((unsigned)sizeof(char)*(len+1)))
      == NULL) {
    cerro("Running out of memory");
    return;
  }
  buf[len]='\0';
  strncpy(buf, error_msg, (size_t)len);
  sciprint("%s\n\r",buf);
  free(buf);
}

void C2F(mexerrmsgtxt)(char *error_msg, int len)
{
  C2F(erro)(error_msg,len);
  errjump();
}

mxArray *C2F(mxcreatefull)(int *m, int *n, int *it)
{
  static int lr1;
  int lrd;
  if (! C2F(createptr)("d", m, n, it, &lr1, &lrd,1L)) {
    return  (mxArray *) 0;
  }
  return (mxArray *) lrd ;
} 


unsigned long int C2F(mxcalloc)(unsigned int *n, unsigned int *size)
{
  int m;
  vraiptrst lrd;
  m = (*n * *size) /sizeof(double) + 1;
  if (! C2F(createstkptr)(&m, &lrd)) {
    return 0;
  }
  return (unsigned long int) lrd;
}

int  C2F(mxgetstring)(mxArray *ptr, char *str, int *strl)
{
  int commonlength; int nrows;
  int *header = (int *) stkptr(*ptr);
  if (header[0] < 0) header = (int *) stk(header[1]);
  nrows = header[1];
  /*  int ncols = value[2]; This is 1 */
  commonlength=nrows*(header[5]-header[4]);
  C2F(in2str)(&commonlength, &header[5+nrows], str,0L);
  *strl = Min(*strl,commonlength);
  return 0;
}

void C2F(mxfreematrix)(mxArray *ptr)
{
  return ;
}


mxArray * C2F(mxcreatestring)(char *string, long int l)
{
  static int i, lr1, lw, iprov, ilocal; 
  /** i = strlen(string); **/
  i= l;
  Nbvars++;
  lw=Nbvars;
  iprov = lw + Top -Rhs;
  if( ! C2F(cresmat2)("mxCreateString:", &iprov, &i, &lr1, 15L)) {
    return (mxArray *) 0;
  }
  C2F(cvstr)(&i, istk(lr1), string, (ilocal=0, &ilocal),l);
  C2F(intersci).ntypes[lw-1]=36;
  return (mxArray *) C2F(vstk).Lstk[Top -Rhs + lw - 1];
}


int C2F(mxcopyreal8toptr)(double *y, mxArray *ptr, integer *n)
{
  int one=1;
  double *value = ((double *) *ptr); 
  C2F(dcopy)(n,y,&one,value,&one);
  return 0;
}

int C2F(mxcopycomplex16toptr)(double *y, mxArray *ptr, mxArray *pti, integer *n)
{
  int one=1; int two=2;
  double *value = ((double *) *ptr);  
  double *headerm = ((double *) *pti);
  C2F(dcopy)(n,y,&two,value,&one);
  C2F(dcopy)(n,++y,&two,headerm,&one);
  return 0;
}

int C2F(mxcopyptrtoreal8)(mxArray *ptr, double *y, integer *n)
{
  int one=1;
  double *value = ((double *) *ptr); 
  C2F(dcopy)(n,value,&one,y,&one);
  return 0;
}

int C2F(mxcopyptrtocomplex16)(mxArray *ptr, mxArray *pti, double *y, integer *n)
{
  int one=1; int two=2;
  double *value = ((double *) *ptr);
  double *headerm = ((double *) *pti);
  C2F(dcopy)(n,value,&one,y,&two);
  C2F(dcopy)(n,headerm,&one,++y,&two);
  return 0;
}


/* mxCreateLogicalArray
 * mxIsLogicalScalar
 * mxIsLogicalScalarTrue  */
