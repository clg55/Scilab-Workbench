/* Copyright INRIA/ENPC */
#include <stdio.h>
#include <string.h>

#include "../graphics/Math.h"

#define MAX_ENV 256 

extern void C2F(getenvc) 
     _PARAMS((int *ierr,char *var,char *buf,int *buflen,int *iflag));

static char *SCI_a[] = {  "SCI/", "sci/", "$SCI", (char *) 0 };
static char *HOME_a[] = {  "HOME/", "home/", "~/" , "$HOME", (char *) 0};
static char *TMP_a[] = {  "TMPDIR/", "tmpdir/", "$TMPDIR", (char *) 0};
void GetenvB _PARAMS(( char *name,char *env, int len));
static int Cluni0 _PARAMS((char *env,char **alias,char* in_name,char *out_name));

/************************************************
 * expand  in_name to produce out_name 
 *       
 ************************************************/

int C2F(cluni0)( in_name, out_name, out_n,lin,lout)
     char * in_name, *out_name ;
     int  *out_n;
     long int lin,lout;
{
  int  nc= MAX_ENV;
  static char SCI[MAX_ENV],HOME[MAX_ENV],TMP[MAX_ENV];
  static int firstentry=0;
  if ( firstentry == 0 ) 
    {
      GetenvB("SCI",SCI,nc);
      GetenvB("HOME",HOME,nc);
      GetenvB("TMPDIR",TMP,nc);
      firstentry++;
    }
  in_name[lin]='\0';
  if ( Cluni0(SCI,SCI_a,in_name,out_name) == 0 )
    if ( Cluni0(HOME,HOME_a,in_name,out_name) == 0 )
      if ( Cluni0(TMP,TMP_a,in_name,out_name) == 0 )
      strncpy(out_name,in_name,lout);
  *out_n = strlen(out_name);
#if defined(THINK_C)||defined(__MWERKS__)
  for (k=0 ; k < *out_n ;k++) if ( out_name[k]=='/') out_name[k]=':';
#endif
  /** sciprint( "out [%s] [%d]\r\n",out_name,*out_n); **/
  return(0);
}

/************************************************
 * getenv + squash trailing white spaces 
 ************************************************/

void GetenvB(name,env,len)
     char *name,*env;
     int len;
{
  int ierr,un=1;
  C2F(getenvc)(&ierr,name,env,&len,&un);
  if( ierr == 0) 
    {
      char *last = &env[len-1];
      while ( *last == ' ' ) { last = '\0' ; } last--;
    }
  else 
    {
      env[0] = '\0' ;
    }  
}

/************************************************
 * expand in_name to produce out_name 
 *     try to find alias[i] at the begining of in_name 
 *     and replaces it by env in out_name 
 *     out_name must be large enough to get the result 
 ************************************************/

static int Cluni0(env,alias, in_name,out_name)
     char *env,**alias,*in_name, *out_name ;
{
  int i=0;
  if ( env[0] == '\0' ) return(0);
  while ( alias[i] != (char *) 0) 
    {
      if ( strncmp(alias[i],in_name,strlen(alias[i])) == 0)
	{
	  sprintf(out_name,"%s/%s",env,in_name+strlen(alias[i]));
	  return(1);
	}
      i++;
    }
  return(0);
}

