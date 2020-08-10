#include <stdio.h>

#ifdef WIN32 
#include "menusX/wmen_scilab.h"
#else
#include "menusX/men_scilab.h"
#endif

extern SciMess ScilabMessage;

#include "metaconst.h"
#include "graphics.h"

/*------------------------------------------
 * Global variable used to transmit messages 
 *------------------------------------------*/

char Description[STRLEN];
static void Description_win32 _PARAMS((void));

/*------------------------------------------
 * Message window 
 *------------------------------------------*/

void MetanetAlert()
{
  int rep;
  static char* buttonname[] = {
        "OK",
	NULL
    };
#ifdef WIN32 
  Description_win32() ;
#endif 
  ScilabMessage.nb= 1;
  ScilabMessage.pButName = buttonname;
  ScilabMessage.string = Description;
  rep= ExposeMessageWindow();
}

/*------------------------------------------
 * Yes or No window 
 *------------------------------------------*/

int MetanetYesOrNo() 
{
  int rep;
  static char* buttonname[] = {
        "Yes",
	"No",
	NULL
    };
#ifdef WIN32 
  Description_win32() ;
#endif 
  ScilabMessage.nb= 2;
  ScilabMessage.pButName = buttonname;
  ScilabMessage.string = Description;
  rep= ExposeMessageWindow();
  rep = ( rep == 1 ) ? 1 : 0;
  return(rep);
}

/*------------------------------------------
 * \n -> \r\n  on win32 
 *------------------------------------------*/

static void Description_win32() 
{
  static char Description_loc[STRLEN];
  char *description = Description; 
  int istr=0;
  while ( *description != '\0') 
    {
      if ( *description == '\n' ) 
	{ 
	  Description_loc[iStr] = '\r';
	  Description_loc[++iStr] = *description; 
	}
      else Description_loc[iStr] = *description;
      iStr++; description++;
    }
  Description_loc[iStr] ='\0';
  strcpy(Description,Description_loc);
}


