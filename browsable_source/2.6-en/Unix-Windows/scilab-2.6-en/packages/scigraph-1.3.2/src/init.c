#include <stdio.h>
#ifndef __MSC__
#include <dirent.h>
#else 
#include <direct.h>
#endif

#include <stdlib.h>
#include <string.h>

#ifdef __STDC__
#include <unistd.h>
#endif

#include "list.h"
#include "graph.h"
#include "metio.h"
#include "menus.h"
#include "functions.h"

char beginHelp[2*MAXNAM];
char studyHelp[2*MAXNAM];
char modifyHelp[2*MAXNAM];


#if (defined __MSC__) || (defined __ABSC__)
/** only used for x=dir[1024] **/
#ifndef __ABSC__
#define  getwd(x) _getcwd(x,1024)
#else
#define  getwd(x) getcwd_(x,1024)
#endif
#endif


MetanetGraph * InitMetanet(path,win,flag)
     char *path;
     int win,flag;
{
  MetanetGraph *MG=NULL;
  char *name = NULL;
  if (path == NULL) 
    {
      DisplayMenu(win,BEGIN);
      return NULL;
    }
  name = mybasename(path);
  if ( name != NULL && check_graph_sufix(name) == 1) 
    {
      MG = LoadComputeGraph(win,path);
      if ( MG != NULL) set_graph_win(win,MG);
      if ( name != NULL && MG != NULL) return NULL;
      DisplayMenu(win,STUDY);
    }
  else 
    {
      sprintf(Description,"%s is not a graph file",path);
      MetanetAlert();
      DisplayMenu(win,BEGIN);
    }
  return MG;
}

void InitMetanetHelp()
{
  static char scigdir[2*MAXNAM];
  int hdne;
  char *dir;
#ifndef __MSC__
  DIR *dirp;
#else
  static char currentdir[2*MAXNAM];
  int it;
#endif
  FILE *f1, *f2, *f3;
  
  static int firstentry = 0;
  if ( firstentry != 0) return ;
  firstentry++;
  dir=getenv("SCI");
  hdne=0;
  if ( dir != NULL ) 
    {
      strcpy(scigdir,dir);
      strcat(scigdir,"/X11_defaults");
#ifdef __MSC__
      getwd(currentdir);
      it= _chdir(scigdir);
      _chdir(currentdir);
      if (it != 0) hdne=1;
#else
      if ((dirp=opendir(scigdir)) == NULL) hdne =1;
#endif 
    } 
  
  if ( dir == NULL || hdne == 1) 
    {
      sprintf(Description,"Help Directory does not exist\nHelp not available");
      MetanetAlert();
    }
  else 
    {
      strcpy(beginHelp,scigdir);
      strcat(beginHelp,"/MetanetBegin.help");
      strcpy(studyHelp,scigdir);
      strcat(studyHelp,"/MetanetStudy.help");
      strcpy(modifyHelp,scigdir);
      strcat(modifyHelp,"/MetanetModify.help");
      if ((f1=fopen(beginHelp,"r")) == NULL || 
	  (f2=fopen(studyHelp,"r")) == NULL ||
	  (f3=fopen(modifyHelp,"r")) == NULL) {
	sprintf(Description,"Help Files does not exist\nHelp not available");
	MetanetAlert();
      }
      else 
	{
	  fclose(f1); fclose(f2); fclose(f3);
	}
    }
#ifndef __MSC__
  closedir(dirp);
#endif 
}










