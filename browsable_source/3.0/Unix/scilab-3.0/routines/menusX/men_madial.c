/* Copyright ENPC */
#ifdef WIN32 
#include "wmen_scilab.h"
#else
#include "men_scilab.h"
#endif

int MatrixDialogWindow(void);

MADialog MAD = { NULL,NULL,NULL,NULL,-1,0,0,0};

/*************************************************     
 * Interface with Scilab 
 **********************************************************/

void C2F(xmatdg)(int *label, int *ptrlab, int *nlab, int *value, int *ptrv, int *descv, int *ptrdescv, int *desch, int *ptrdesch, int *nl, int *nc, int *res, int *ptrres, int *ierr)
{
  int i,rep;
  int maxchars; 
  if ( MAD.nv >= 0) 
    {
      sciprint("Only one madialog at a time please \r\n");
      return ;
    }
  maxchars = *ierr;
  *ierr=0;
  MAD.nv = *nl*(*nc);
  /* conversion of scilab characters into strings */
  ScilabMStr2C(label,nlab,ptrlab,&(MAD.labels),ierr);
  if ( *ierr == 1) { MAD.nv = -1; return; }
  ScilabMStr2CM(descv,nl,ptrdescv,&(MAD.VDesc),ierr);
  if ( *ierr == 1) { MAD.nv = -1; return; }
  ScilabMStr2CM(desch,nc,ptrdesch,&(MAD.HDesc),ierr);
  if ( *ierr == 1) { MAD.nv = -1; return; }
  ScilabMStr2CM(value,&(MAD.nv),ptrv,&(MAD.data),ierr);
  if ( *ierr == 1) { MAD.nv = -1; return; }
  MAD.nl = *nl;
  MAD.nc = *nc;
  MAD.ierr = 0;
  rep = MatrixDialogWindow();
  if ( rep == FALSE || MAD.ierr == 1 )
    {
      *nl = 0;
    }
  else
    {
      ScilabCM2MStr(MAD.data,MAD.nv,res,ptrres,maxchars,ierr);
    }

  FREE(MAD.labels);
  for (i=0;i< MAD.nl*MAD.nc;i++) FREE(MAD.data[i]); FREE(MAD.data);
  for (i=0;i< MAD.nl;i++) FREE(MAD.VDesc[i]); FREE(MAD.VDesc);
  for (i=0;i< MAD.nc;i++) FREE(MAD.HDesc[i]); FREE(MAD.HDesc);
  MAD.nv = -1;

}

/*************************************************     
 * Test function 
 **********************************************************/

int TestMatrixDialogWindow(void)
{
  int rep,i;
  static char *labels = "LaBel";
  static char *vdesc[] = {
    "row 1","row 2","row 3",
    NULL
    };
  static char *hdesc[] = {
    "col 1","col 2",
    NULL
    };
  MAD.nl = 3;
  MAD.nc = 2;
  MAD.nv = MAD.nc*MAD.nl;
  MAD.labels = labels;
  MAD.VDesc = vdesc;
  MAD.HDesc = hdesc;
  /** Warning data must be allocated because 
    MatricDialogWindow will reallc it to store result **/
  MAD.data  = (char **) malloc((6+1)*sizeof(char *));
  if ( MAD.data == ( char **) 0 ) return(FALSE);
  for ( i = 0 ; i < 6 ; i++ )
    {
      MAD.data[i] = (char *) malloc(2*sizeof(char));
      if ( MAD.data[i] == ( char *) 0 ) return(FALSE);
      sprintf(MAD.data[i],"%1d",i);
    }
  MAD.data[6]= (char*)0;
  rep = MatrixDialogWindow();
  return(rep);
}

