/* Copyright INRIA */
#include <string.h>
#include "../machine.h"
#include "men_Sutils.h"

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#define MALLOC(x) malloc(((unsigned) x))
#define FREE(x) if (x  != NULL) free((char *) x);

/* Subroutine */ 
extern int C2F(cvstr) _PARAMS((integer *n, integer *line, char *str, integer *job,long int str_len));



/********************************************************
 *  generic functions for strings 
 ********************************************************/

void strwidth(string,max_width,height)
     char * string;
     int  *max_width;
     int  *height;
{
  int width=0,i;
  *height=0;
  *max_width=1;
  for (i = 0 ; i < (int)strlen(string);i++)
    {
      width++;
      if ( string[i]=='\n' || i == strlen(string)  -1)
	{
	  *max_width= (*max_width > width ) ?  *max_width : width;
	  width=0;
	  *height = *height+1;
	}
    }
}


/********************************************************
 *  Converts a Scilab String coded as integer array [ a crazy old feature]
 *  into a C string [ the C string is allocated with maloc ]
 *  this routine calls a Fortran Function.
 *  WARNING : we MUST add a last argument giving the size of p 
 *  when calling the cvstr Fortran routine [ see Fortran compiler 
 *   documentation ]
 ********************************************************/


void ScilabStr2C(n,Scistring,strh,ierr)
     int *n,*ierr;
     int *Scistring;
     char **strh;
     
{
  int job=1;
  *strh =(char *) MALLOC( (*n)+1);
  if ((*strh) == NULL)    {*ierr=1;     return;}
  F2C(cvstr)(n,Scistring,*strh,&job,(long int)*n);
  (*strh)[*n]='\0';
}

/********************************************************
 * Converts a Scilab array of 
 * String coded as integer array [ a crazy old feature]
 * into a C array of strings [ NULL terminated ]
 * as 
 *   char*  items[] = {
 *      "first list entry",
 *      "second list entry",
 *      NULL
 *      };
 *   
 ********************************************************/

void ScilabMStr2CM(Scistring,nstring,ptrstrings,strh,ierr)
     int *Scistring,*nstring,*ptrstrings,*ierr;
     char ***strh;
{
  char **strings,*p;
  int li,ni,*SciS,i;
  strings=(char **) MALLOC( ((*nstring)+1)*sizeof(char *));
  if (strings==NULL) {*ierr=1; return;}
  li=1;
  SciS= Scistring;
  for ( i=1 ; i<*nstring+1 ; i++) 
    {
      ni=ptrstrings[i]-li;
      li=ptrstrings[i];
      ScilabStr2C(&ni,SciS,&p,ierr);
      strings[i-1]=p;
      if ( *ierr == 1) return;
      SciS += ni;
    }
  strings[*nstring]=NULL;
  *strh=strings;
}

/********************************************************
 * Converts a Scilab array of 
 * String coded as integer array [ a crazy old feature]
 * into a C  string where all the Scilab strings are
 * separated by '\n' or '\r\n'
 * desc,nd,ptrdesc : scilab string info 
 * strh : the C coded string 
 ********************************************************/


void ScilabMStr2C(desc,nd,ptrdesc,strh,ierr)
     int *desc,*nd,*ptrdesc,*ierr;
     char **strh;
{
  int ln,li=1,di=0,*SciS,job=1,i,ni;
  char *description,*p;
#ifdef WIN32 
  ln=ptrdesc[*nd]+2*(*nd)+1;
#else 
  ln=ptrdesc[*nd]+*nd+1;
#endif 
  description=(char *) MALLOC( ln*sizeof(char));
  if (description==NULL) {*ierr=1; return;}
  SciS= desc;
  for (i=1 ; i<*nd+1 ; i++) 
    {
      p= &(description[di]);
      ni=ptrdesc[i]-li;
      F2C(cvstr)(&ni,SciS,p,&job,(long int)0);
      SciS += ni;
#ifdef WIN32 
      p[ni]= '\r';
      ni=ni+1;
#endif 
      di += ni+1;
      p[ni]= '\n';
      li=ptrdesc[i];
    }
  description[ln-2]='\0';
  *strh=description;
}


/********************************************************
 * Converts a C string containing \n or \r\n 
 * into a Scilab matrix of String 
 ********************************************************/

void ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines)
     int *res,*ptrres,*nr,*ierr,maxchars,maxlines;
     char *str;
{
  int job=0,li=0,n,i,ni;
  *nr=0;
  ptrres[0]=1;
  n=strlen(str);
  if (n <= maxchars) 
    {
      str[n]='\n';
      for (i=0;i < n+1;i++)
	{
	  if(str[i]=='\n') 
	    {
	      int ni1;
	      ni1=ni=i-li;
#ifdef WIN32 
	      if (i > 0 && str[i-1]=='\r' ) ni1=ni-1;
#endif 
	      ptrres[*nr+1]=ptrres[*nr]+ni1;
	      F2C(cvstr)(&ni1,res,&str[li],&job,(long int)0);
	      res+=ni1;
	      li += ni+1;
	      ni= -1;
	      *nr += 1;
	      if (*nr>maxlines) { *ierr=3; return;}
	    }
	}
    }
  else  *ierr=2;
}



/****************************************
 * ScilabCM2MStr 
 * back convertion from a C 
 * array of string pointers to a Scilab 
 * description 
 * nv is the number of strings 
 * the result is stored in res and ptrres
 * Warning : res and ptrres must have been 
 * allocated in the scilab interface 
 * ( see : in xawelm.f  the xmdial example )
 * 
 * Squash \r in the given string (DFK) 
 * Done in place. 
 ********************************************/

#ifdef WIN32 
void squash_r(char *s)
{
  register char *r = s;		/* reading point */
  register char *w = s;		/* writing point */
  for (w = r = s; *r != '\0'; r++) {
    if ( *r != '\r' )  *w++ = *r;
  }
  *w = '\0';				
}
#endif /* WIN32 */


void ScilabCM2MStr(str,nv,res,ptrres,maxchars,ierr)
     char **str;
     int nv, *res, *ptrres,maxchars,*ierr;
{
  int job=0,nr=0,i,ni,ntot=0;
  ptrres[0]=1;
  for (i= 0 ; i < nv ;i++) 
    {
#ifdef WIN32 
      /** cvstr changes \n to ! : we suppress \r in str **/
      squash_r(str[i]);
#endif 
      ni=strlen(str[i]);
      ntot += ni;
      if ( ntot > maxchars ) 
	{
	  *ierr=2;
	  return;
	}
      ptrres[nr+1]=ptrres[nr]+ni;
      nr++;
      F2C(cvstr)(&ni,res,str[i],&job,(long int) 0);
      res +=ni;
    }
}



