/* Copyright INRIA */
#include "../machine.h"
#ifdef WIN32 
#ifndef __CYGWIN32__
#include <direct.h>
#define chdir(x) _chdir(x)
#define GETCWD(x,y) _getcwd(x,y)
#else 
#include <unistd.h>
extern void sciprint(char *fmt,...);
#define GETCWD(x,y) getcwd(x,y)
#endif 
#endif 

#define FSIZE 1024
static char     cur_dir[FSIZE];

#if defined(SYSV) || defined(SVR4)
extern char	   *getcwd();
#define GETCWD(x,y) getcwd(x,y)
#else
#ifndef WIN32
extern char	   *getwd();
#define GETCWD(x,y) getwd(x)
#endif
#endif

/*******************************
 * Changes scilab current directory 
 *******************************/

int C2F(scichdir)(path,err)
     char *path;
     int *err;
{
  *err=0;
  if (path == (char*) 0) {
    *cur_dir = '\0';
    return (0);
  }
  if (chdir(path) == -1) {
    sciprint("Can't go to directory %s \r\n", path); 
    /** XXX : a remettre , sys_errlist[errno]); **/
    *err=1;
  } 
  /** a rajouter en XWindow ? pour transmettre l'info au menu 
    if (get_directory(cur_dir)==0) 
    *err=1; **/
  return 0;
}

/*******************************
 * Get scilab current directory 
 *******************************/

int C2F(scigetcwd)(path,lpath,err)
     char **path;
     int *lpath;
     int *err;
{
    if (GETCWD(cur_dir, 1024) == (char*) 0)
      {	/* get current working dir */
	sciprint("Can't get current directory\r\n");
	*cur_dir = '\0';
	*lpath=0;
	*err=1;
      }
    else 
      {
	*path= cur_dir;
	*lpath=strlen(cur_dir);
	*err=0;
      }
    return 0;
}

