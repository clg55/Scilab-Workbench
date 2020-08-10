#ifdef WIN32 
#include "menusX/wmen_scilab.h"
#else
#include "menusX/men_scilab.h"
#endif

#include <stdio.h>
#include "graphics/Math.h"
#include "metaconst.h"
#include "graphics.h"
#include "metio.h"
#include "stack-c.h" /* for IMPORT */

/*---------------------------------------------------
 * Interaction with user through Scilab dialog utilities 
 *---------------------------------------------------*/

IMPORT char *dialog_str;
IMPORT MDialog SciMDialog;        /** used to stored the mdialog data **/
IMPORT SciDialog ScilabDialog;
IMPORT SciMess ScilabMessage;

/*------------------------------------------
 * Global variable used to transmit messages 
 *------------------------------------------*/

#define STRINGLEN 100000
static int iStr = 0;
static char Str[STRINGLEN];
static int iStrflag=0;

char Description[STRLEN];

#ifdef WIN32 
static void Description_win32 _PARAMS((void));
#endif 

#define OK 1
#define CANCEL 2
#define DIALOG 1
#define DIALOGS 2

/*---------------------------------------------------
 * open a Scilab dialog window 
 *---------------------------------------------------*/

int MetanetDialog(valueinit,result,description)
     char *valueinit, *result, *description;
{
  int rep;
  static char *pButName[] = {
    "OK",
    "Cancel",
    NULL
    };
  ScilabDialog.description = description ;
  ScilabDialog.init = valueinit;
  ScilabDialog.pButName = pButName;
  ScilabDialog.nb = 2;
  rep = DialogWindow();
  if ( rep == 1) 
    {
      strcpy(result,dialog_str);
      return strlen(result);
    }
  else 
    return 0;
}

/*---------------------------------------------------
 * open a Scilab dialog window 
 *---------------------------------------------------*/

int MetanetDialogs(n,valueinit,result,description,label)
     int n;
     char *valueinit[], *result[], *description[], *label;
{
  int i,rep;
  SciMDialog.labels = label;
  SciMDialog.pszTitle = description;
  /* Warning pszName must be allocated because 
   * MatricDialogWindow will reallc it to store result 
   */
  SciMDialog.pszName  = (char **) MALLOC((n+1)*sizeof(char *));
  if ( SciMDialog.pszName == ( char **) 0 ) return(FALSE);
  for ( i = 0 ; i < n ; i++ )
    {
      SciMDialog.pszName[i] = (char *) MALLOC((strlen(valueinit[i])+1)
					      *sizeof(char));
      if ( SciMDialog.pszName[i] == ( char *) 0 ) return(FALSE);
      strcpy(SciMDialog.pszName[i],valueinit[i]);
    }
  SciMDialog.pszName[n]= (char*)0;
  SciMDialog.nv = n;
  SciMDialog.ierr=0;
  rep=mDialogWindow();
  if ( SciMDialog.ierr == 0 )
    {
      /** No errors **/
      if ( rep == FALSE ) 
	{
	  for (i=0; i< n;i++) FREE(SciMDialog.pszName[i]); 	  
	  FREE(SciMDialog.pszName);	  
	  return 0;
	}
      else 
	{
	  int change=0;
	  for (i = 0; i < n; i++)
	    strcpy(result[i],SciMDialog.pszName[i]);
	  for (i = 0; i < n; i++)
	    if (strcmp(result[i],valueinit[i]) != 0) 
	      {
		change=1;break;
	      }
	  for (i=0; i< n;i++) FREE(SciMDialog.pszName[i]); 	  
	  FREE(SciMDialog.pszName);	  
	  if ( change == 1) return 1;
	  else return 0;
	}
    }
  return 0;
}

/*-------------------------------------------------
 * functions used to create and expose a text message 
 *  StartAddText() 
 *  AddText(...)
 *  AddText(...)
 *  EndAddText();
 *------------------------------------------------*/

void StartAddText()
{
  iStrflag=0;
  iStr = 0;
  Str[0] = '\0';
}  

void AddText(description)
     char *description;
{
  if ( iStr + strlen(description) + 1 > STRINGLEN) 
    {
      if ( iStrflag == 0) 
	{
	  sprintf(Description,"Running out of space in a message display");
	  MetanetAlert();
	  iStrflag = 1;
	}
      return;
    }
#ifdef WIN32 
  while ( *description != '\0') 
    {
      if ( *description == '\n' ) 
	{ 
	  Str[iStr] = '\r';
	  Str[++iStr] = *description; 
	}
      else Str[iStr] = *description;
      iStr++; description++;
    }
  Str[iStr] ='\0';
#else 
  sprintf(&Str[iStr],description);
  iStr = strlen(Str);
#endif 
}

void EndAddText()
{
  int rep;
  static char* buttonname[] = {
        "OK",
	NULL
    };
  if ( iStrflag == 1) return ; /* overflow while adding text */
  ScilabMessage.nb= 1;
  ScilabMessage.pButName = buttonname;
  ScilabMessage.string = Str;
  rep= ExposeMessageWindow();
  /* sciprint("reponse[%d] \n",rep); */
}


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
#ifdef WIN32

static void Description_win32() 
{
  static char Description_loc[STRLEN];
  char *description = Description; 
  int istr=0;
  while ( *description != '\0') 
    {
      if ( *description == '\n' ) 
	{ 
	  Description_loc[istr] = '\r';
	  Description_loc[++istr] = *description; 
	}
      else Description_loc[istr] = *description;
      istr++; description++;
    }
  Description_loc[istr] ='\0';
  strcpy(Description,Description_loc);
}
#endif 











