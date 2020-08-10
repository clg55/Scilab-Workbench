#include <stdio.h>
#ifdef __STDC__
#include <stdlib.h>
#else 
#ifdef WIN32 
#include <stdlib.h>
#endif 
#endif

#include "machine.h"

#define PI0 (integer *) 0
#define PD0 (double *) 0

#include "metaconst.h"
#include "graphics.h"

extern char beginHelp[];
extern char studyHelp[];
extern char modifyHelp[];


void DisplayHelp(file)
     char *file;
{
  char buf[256];
#ifdef WIN32
  char *local = (char *) 0;
  if ( file[0] == '\0') return;
  local = getenv("SCI");
  if ( local != (char *) 0)
    sprintf(buf, "%s/bin/xless  %s ",local, file);
  else
    /** maybe xless is in the path ? **/
    sprintf(buf, "xless  %s", file);
  /** sciprint("TestMessage : je lance un winsystem sur %s\r\n",buf); **/
  if (winsystem(buf,1))
    sciprint("help error: winsystem failed\r\n");
#else
  if ( file[0] == '\0') return;
  sprintf(buf, "$SCI/bin/xless %s 2> /dev/null &",file);
  system(buf);
#endif
}


void DisplayBeginHelp()
{
  DisplayHelp(beginHelp);
}

void DisplayStudyHelp()
{
  DisplayHelp(studyHelp);
}

void DisplayModifyHelp()
{
  DisplayHelp(modifyHelp);
}




