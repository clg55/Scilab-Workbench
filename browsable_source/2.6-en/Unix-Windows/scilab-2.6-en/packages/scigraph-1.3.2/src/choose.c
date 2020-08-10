#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#else
#include "menusX/men_scilab.h"
#endif

#include "metaconst.h"
#include "graphics.h"

int MetanetChoose(description,strings,result)
     char *description;
     char *strings[];
     char *result;
{
  ChooseMenu Ch;
  static char *butn[]= { "Cancel",NULL};
  int Rep,i=0;
  while ( strings[i] != NULL ) i++;
  Ch.nstrings = i;
  Ch.nb = 1; 
  Ch.choice = 0;
  Ch.description = " Title";
  Ch.buttonname = butn;
  Ch.strings = strings;
  Rep = ExposeChooseWindow(&Ch);
  if ( Rep == TRUE )
    {
      strcpy(result,strings[Ch.choice]);
      return(1);
    }
  else 
    return(0);
}
