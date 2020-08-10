/* Copyright INRIA */
/*********************************
 * Link version for SYSV machine 
 *********************************/


#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <windows.h>

#define round(x,s) (((x) + ((s)-1)) & ~((s)-1))
#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

extern char *strchr();


static void Sci_Delsym _PARAMS((int ));
static int Sci_dlopen _PARAMS((char *loaded_files[]));
static int Sci_dlsym _PARAMS((char *ename,int  ishared,char * strf));

/*************************************
 * New version : link entry names 
 *   from new shared lib created with 
 *   files.
 *   -1 : the shared archive was not loaded 
 *   -5 : pb with one of the entry point 
 *************************************/

void SciLink(iflag,rhs,ilib,files,en_names,strf)
     int iflag,*ilib,*rhs;
     char *files[],*en_names[],*strf;
{
  int i;
  if ( iflag == 0 )
    {
      *ilib  = Sci_dlopen(files);
    }
  if (*ilib  == -1 ) return;

  if ( *rhs >= 2) 
    {
      i=0 ;
      while ( en_names[i] != (char *) 0)
	{
	  if ( Sci_dlsym(en_names[i],*ilib,strf) == FAIL) 
	    *ilib=-5;
	  i++;
	}
    }
}

/**************************************
 * return 1 if link accepts multiple file iin one call
 * or 0 elsewhere 
 *************************************/

int LinkStatus()
{
  return(1);
}

/**************************************
 * Unlink a shared lib 
 *************************************/

void C2F(isciulink)(i) 
     integer *i;
{
  Sci_Delsym(*i);
}


/*************************************
 * This routine 
 *   load a shared archive and call dlopen (here LoadLibrary)
 *   the shared lib handler is stored in a Table 
 *   The return value is == -1 if the dlopen failed 
 *************************************/

int Sci_dlopen(loaded_files)
     char *loaded_files[];
{
  static HINSTANCE  hd1 = NULL;
  int   i;
  /** XXXXX **/
  int count =0;
  while ( loaded_files[count] != NULL) count++;
  if ( count != 1 ) 
    {
      sciprint("link: first argument must be a unique dll name\r\n");
    }
  hd1 =   LoadLibrary (loaded_files[0]);
  if ( hd1 == NULL ) 
    {
      sciprint("link failed for dll %s\r\n",loaded_files[0]);
      return(-1);
    }
  for ( i = 0 ; i < Nshared ; i++ ) 
    {
      if ( hd[i].ok == FAIL) 
	{
	  hd[i].shl =  (unsigned long)hd1;
	  hd[i].ok = OK;
	  return(i);
	}
    }
  
  if ( Nshared == ENTRYMAX ) 
    {
      sciprint("You can't open shared files maxentry %d reached\r\n",ENTRYMAX);
      return(FAIL);
    }

  hd[Nshared].shl = (unsigned long)hd1;
  hd[Nshared].ok = OK;
  Nshared ++;
  return(Nshared-1);
}


/*************************************
 * This routine load the entryname ename 
 *     from shared lib ishared 
 *************************************/

int Sci_dlsym(ename,ishared,strf)
     int ishared;
     char *ename;
     char *strf;
{
  HINSTANCE  hd1 = NULL;
  int ish = Min(Max(0,ishared),ENTRYMAX-1);
  char enamebuf[MAXNAME];
  if ( strf[0] == 'f' )
    Underscores(1,ename,enamebuf);
  else 
    Underscores(0,ename,enamebuf);

  /* lookup the address of the function to be called */
  if ( NEpoints == ENTRYMAX ) 
    {
      sciprint("You can't link more functions maxentry %d reached\r\n",ENTRYMAX);
      return(FAIL);
    }
  if ( hd[ish].ok == FAIL ) 
    {
      sciprint("Shared lib %d does not exists\r\n",ish);
      return(FAIL);
    }
  /** entry was previously loaded **/
  if ( SearchFandS(ename,ish) >= 0 ) 
    {
      sciprint("Entry name %s is already loaded from lib %d\r\n",ename,ish);
      return(OK);
    }
  hd1 = (HINSTANCE)  hd[ish].shl;
  EP[NEpoints].epoint = (function) GetProcAddress (hd1,enamebuf);
  if ( EP[NEpoints].epoint == NULL )
    {
      sciprint("%s is not an entry point \r\n",enamebuf);
      return(FAIL);
    }
  else 
    {
      /* we don't add the _ in the table */
      sciprint("Linking %s (in fact %s)\r\n",ename,enamebuf);
      strncpy(EP[NEpoints].name,ename,MAXNAME);
      EP[NEpoints].Nshared = ish;
      NEpoints++;
    }
  return(OK);  
}


/***************************************************
 * Delete entry points associated with shared lib ishared
 * then delete the shared lib 
 ****************************************************/

void Sci_Delsym( ishared) 
     int ishared;
{
  int ish = Min(Max(0,ishared),ENTRYMAX-1);
  int i=0;
  for ( i = NEpoints-1 ; i >=0 ; i--) 
    {
      if ( EP[i].Nshared == ish )
	{
	  int j;
	  for ( j = i ; j <= NEpoints - 2 ; j++ )
	    {
	      EP[j].epoint = EP[j+1].epoint;
	      EP[j].Nshared = EP[j+1].Nshared;
	      strcpy(EP[j].name,EP[j+1].name);
	    }
	  NEpoints--;
	}
    }
  if ( hd[ish].ok != FAIL)
    {
      FreeLibrary ((HINSTANCE) hd[ish].shl);
      hd[ish].ok = FAIL;
    }
}
