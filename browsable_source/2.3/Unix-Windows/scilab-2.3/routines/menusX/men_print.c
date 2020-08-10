#ifdef WIN32 
#include "wmen_scilab.h"
#else
#include "men_scilab.h"
#endif

#define OK 1
#define CANCEL 2
#define MEMERR 3

PrintDial ScilabPrintD;

static char *Print_Formats[] = {
  "Postscript",
  "Postscript No Preamble",
  "Postscript-Latex",
  "Xfig",
};

static int nF=4;

/******************************************
 * main function 
 ******************************************/

int prtdlg(flag,printer,colored,orientation,file,ok)
     integer *colored,*orientation,*flag,*ok;
     char printer[],file[];
{ 
  static int firstentry=0;
  int rep ;
  *ok=1;
  if ( firstentry == 0) 
    {
      ScilabPrintD.numChoice=1;
      ScilabPrintD.Pbuffer = NULL;
      ScilabPrintD.PList = NULL;
      firstentry++;
    }
  rep = ExposePrintdialogWindow((int) *flag,colored,orientation);
  if ( rep == TRUE ) 
    {
      strcpy(printer,ScilabPrintD.PList[ScilabPrintD.numChoice-1]);
      if (*flag==2) {strcpy(file,ScilabPrintD.filename);FREE(ScilabPrintD.filename);}
    }
  else 
    {
      *ok=0;
    }
  if (*flag==1) 
    {
      FREE(ScilabPrintD.Pbuffer);
      FREE(ScilabPrintD.PList);
    }
  return(0);
}

/******************************************
 * Test function 
 ******************************************/

int TestPrintDlg()
{
  static char file[100],printer[20];
  integer flag,colored,orientation,ok;
  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
  return(0);
}


/******************************************
 * Initialize list of printers 
 ******************************************/

int SetPrinterList(flag)
     int flag;
{
  int n,i,npr;
  char *getenv(),*str,*p;
  if (flag == 1) 
    {
      /* searching for printers */

      if ( (str=getenv("PRINTERS")) == 0) str="lp";
      n=strlen(str);
      if (n==0) 
	{
	  str="lp";n=strlen(str);
	}
      /* counting number of printers */
      npr=1;
      for (i=0 ; str[i] != '\0' ;i++)
	if(str[i]==':' ) npr++;
      ScilabPrintD.PList=(char **) MALLOC((npr)*sizeof(char *));
      ScilabPrintD.Pbuffer=(char *) MALLOC( (strlen(str)+1)*sizeof(char));
      if ( ScilabPrintD.Pbuffer != (char *) 0 && ScilabPrintD.PList != (char **) 0)
	{
	  strcpy(ScilabPrintD.Pbuffer,str);
	  ScilabPrintD.ns=0;
	  while ( ScilabPrintD.ns < npr ) 
	    {
	      p=(ScilabPrintD.ns == 0) ? strtok(ScilabPrintD.Pbuffer,":") : strtok((char *)0,":");
	      ScilabPrintD.PList[ScilabPrintD.ns]=p;
	      ScilabPrintD.ns++;
	    }
	}
      else 
	{
	  sciprint("x_choices : No more place\r\n");
	  return(MEMERR);
	}
    }
  else 
    {
      ScilabPrintD.PList=Print_Formats;
      ScilabPrintD.ns=nF;
    }
  return(OK);
}

