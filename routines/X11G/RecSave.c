#include <string.h> /* in case of dbmalloc use */
#ifdef THINK_C
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include <stdio.h>
#include "Math.h"

#include "Rec.h"
extern int Store();

/*---------------------------------------------------------------------
Partie save/load en utilisant xdr 
---------------------------------------------------------------------------*/

int SaveXcall1(plot)
     char *plot;
{
  struct xcall1_rec *lplot = (struct xcall1_rec *) plot;
  if ( SaveVectC((lplot->fname),((int)strlen(lplot->fname))+1) == 0) return(0);
  if ( SaveVectC((lplot->string),((int)strlen(lplot->string))+1) == 0) return(0);
  if ( SaveLI(lplot->n1 )== 0) return(0);
  if ( SaveLI(lplot->n2 )== 0) return(0);
  if ( SaveLI(lplot->n3 )== 0) return(0);
  if ( SaveLI(lplot->n4 )== 0) return(0);
  if ( SaveLI(lplot->n5 )== 0) return(0);
  if ( SaveLI(lplot->n6 )== 0) return(0);
  if ( SaveLI(lplot->ndx1 )== 0) return(0);
  if ( SaveLI(lplot->ndx2 )== 0) return(0);
  if ( SaveLI(lplot->ndx3 )== 0) return(0);
  if ( SaveLI(lplot->ndx4 )== 0) return(0);
  if ( SaveVectLI((lplot->x1),lplot->n1) == 0) return(0);
  if ( SaveVectLI((lplot->x2),lplot->n2) == 0) return(0);
  if ( SaveVectLI((lplot->x3),lplot->n3) == 0) return(0);
  if ( SaveVectLI((lplot->x4),lplot->n4) == 0) return(0);
  if ( SaveVectLI((lplot->x5),lplot->n5) == 0) return(0);
  if ( SaveVectLI((lplot->x6),lplot->n6) == 0) return(0);
  if ( SaveVectF((lplot->dx1),lplot->ndx1) == 0) return(0);
  if ( SaveVectF((lplot->dx2),lplot->ndx2) == 0) return(0);
  if ( SaveVectF((lplot->dx3),lplot->ndx3) == 0) return(0);
  if ( SaveVectF((lplot->dx4),lplot->ndx4) == 0) return(0);
}

/*---------------------------------------------------------------------
\encadre{Le cas des changement d'echelle}
---------------------------------------------------------------------------*/

SaveEch(plot)
     char *plot; 
{
  struct scale_rec *lplot = (struct scale_rec *) plot;
  if ( SaveC(lplot->logflag,2L)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->Wrect),4L) == 0) return(0);
  if ( SaveVectF((lplot->Frect),4L) == 0) return(0);
  if ( SaveVectF((lplot->Frect_kp),4L) == 0) return(0);
}

  
/*---------------------------------------------------------------------
\encadre{Le cas des plot2d}
---------------------------------------------------------------------------*/

/* Save the plot2d  in the plot list 
   same arguments as plot2d */

    SavePlot(plot)
     char *plot;
{
  integer n=0, nstyle;
  struct plot2d_rec *lplot = (struct plot2d_rec *) plot;
  if (lplot->n1==1 ) nstyle= lplot->n1+1;else nstyle= lplot->n1;
  switch (lplot->xf[0])
    {
    case 'g': n=(lplot->n1)*(lplot->n2);break;
    case 'e': n=0;break;
    case 'o': n=(lplot->n2);break;
    }
  if ( SaveLI(lplot->n1)== 0) return(0);
  if ( SaveLI(lplot->n2)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectC((lplot->xf),((int)strlen(lplot->xf))+1) == 0) return(0);
  if ( ((n == 0) ? 1 : SaveVectF((lplot->x),n)) == 0) return(0);
  if ( SaveVectF((lplot->y),(lplot->n1)*(lplot->n2)) == 0) return(0);
  if ( SaveVectLI((lplot->style),nstyle) == 0) return(0);
  if ( SaveVectC((lplot->strflag),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->strflag_kp),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->legend),((int)strlen(lplot->legend))+1) == 0) return(0);
  if ( SaveVectF((lplot->brect),4L) == 0) return(0);
  if ( SaveVectF((lplot->brect_kp),4L) == 0) return(0);
  if ( SaveVectLI((lplot->aint),4L) == 0) return(0);
  if ( SaveVectLI((lplot->aint_kp),4L) == 0) return(0);
}

  
/*---------------------------------------------------------------------
\encadre{Le cas de xgrid}
---------------------------------------------------------------------------*/

SaveGrid(plot)
     char *plot;
{
  struct xgrid_rec *lplot = (struct xgrid_rec *) plot;
  if ( SaveLI(lplot->style)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1)== 0) return(0);
}


/*---------------------------------------------------------------------
\encadre{Le cas du param3d}
---------------------------------------------------------------------------*/

SaveParam3D(plot)
     char *plot;
{
  struct param3d_rec *lplot = (struct param3d_rec *) plot;
  if ( SaveLI(lplot->n)== 0) return(0);
  if ( SaveD(lplot->teta)== 0) return(0);
  if ( SaveD(lplot->alpha)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),lplot->n) == 0) return(0);
  if ( SaveVectF((lplot->y),lplot->n) == 0) return(0);
  if ( SaveVectF((lplot->z),lplot->n) == 0) return(0);
  if ( SaveVectC((lplot->legend), ((int)strlen(lplot->legend))+1) == 0) return(0);
  if ( SaveVectLI((lplot->flag),3L) == 0) return(0);
  if ( SaveVectF((lplot->bbox),6L)== 0) return(0);
}


/*---------------------------------------------------------------------
\encadre{Le cas des plot3d}
---------------------------------------------------------------------------*/

SavePlot3D(plot)
     char *plot;
{
  struct plot3d_rec *lplot = (struct plot3d_rec *) plot;
  if ( SaveLI(lplot->p)== 0) return(0);
  if ( SaveLI(lplot->q)== 0) return(0);
  if ( SaveD(lplot->teta)== 0) return(0);
  if ( SaveD(lplot->alpha)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),lplot->p) == 0) return(0);
  if ( SaveVectF((lplot->y),lplot->q) == 0) return(0);
  if ( SaveVectF((lplot->z),(lplot->p)*(lplot->q)) == 0) return(0);
  if ( SaveVectC((lplot->legend), ((int)strlen(lplot->legend))+1) == 0) return(0);
  if ( SaveVectLI((lplot->flag),3L) == 0) return(0);
  if ( SaveVectF((lplot->bbox),6L)== 0) return(0);
}

/*---------------------------------------------------------------------
\encadre{Le cas des fac3d}
---------------------------------------------------------------------------*/

SaveFac3D(plot)
     char *plot;
{
  struct fac3d_rec *lplot = (struct fac3d_rec *) plot;
  if ( SaveLI(lplot->p)== 0) return(0);
  if ( SaveLI(lplot->q)== 0) return(0);
  if ( SaveD(lplot->teta)== 0) return(0);
  if ( SaveD(lplot->alpha)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),(lplot->p)*(lplot->q)) == 0) return(0);
  if ( SaveVectF((lplot->y),(lplot->p)*(lplot->q)) == 0) return(0);
  if ( SaveVectF((lplot->z),(lplot->p)*(lplot->q)) == 0) return(0);
  if ( SaveVectC((lplot->legend), ((int)strlen(lplot->legend))+1) == 0) return(0);
  if ( SaveVectLI((lplot->flag),3L) == 0) return(0);
  if ( SaveVectF((lplot->bbox),6L)== 0) return(0);
}

/*---------------------------------------------------------------------
\encadre{Le cas des fec}
---------------------------------------------------------------------------*/

SaveFec(plot)
     char *plot;
{
  struct fec_rec *lplot = (struct fec_rec *) plot;
  if ( SaveLI(lplot->Nnode)== 0) return(0);
  if ( SaveLI(lplot->Ntr)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),lplot->Nnode) == 0) return(0);
  if ( SaveVectF((lplot->y),lplot->Nnode) == 0) return(0);
  if ( SaveVectF((lplot->triangles),(lplot->Ntr)*5) == 0) return(0);
  if ( SaveVectF((lplot->func),lplot->Nnode ) == 0) return(0);
  if ( SaveVectF((lplot->brect),4L) == 0) return(0);
  if ( SaveVectF((lplot->brect_kp),4L) == 0) return(0);
  if ( SaveVectLI((lplot->aaint),4L) == 0) return(0);
  if ( SaveVectLI((lplot->aaint_kp),4L) == 0) return(0);
  if ( SaveVectC((lplot->strflag),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->strflag_kp),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->legend),((int)strlen(lplot->legend))+1)  == 0) return(0);
}


/*---------------------------------------------------------------------
\encadre{Le cas des contours}
---------------------------------------------------------------------------*/

SaveContour(plot)
     char *plot;
{
  struct contour_rec *lplot = (struct contour_rec *) plot;
  int res=1;
  if ( SaveLI(lplot->n1)== 0) return(0);
  if ( SaveLI(lplot->n2)== 0) return(0);
  if ( SaveLI(lplot->nz)== 0) return(0);
  if ( SaveLI(lplot->flagnz)== 0) return(0);
  if (lplot->flagnz != 0) 
    if ( SaveVectF((lplot->zz),lplot->nz) == 0) return(0);
  if ( SaveD(lplot->teta)== 0) return(0);
  if ( SaveD(lplot->alpha)== 0) return(0);
  if ( SaveD(lplot->zlev)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),lplot->n1) == 0) return(0);
  if ( SaveVectF((lplot->y),lplot->n2) == 0) return(0);
  if ( SaveVectF((lplot->z),(lplot->n1)*(lplot->n2)) == 0) return(0);
  if ( SaveVectC((lplot->legend), ((int)strlen(lplot->legend))+1) == 0) return(0);
  if ( SaveVectLI((lplot->flag),3L) == 0) return(0);
  if ( SaveVectF((lplot->bbox),6L) == 0) return(0);
}

/*---------------------------------------------------------------------
\encadre{Le cas des niveaux de gris }
---------------------------------------------------------------------------*/

/* Save the plot in the plot list
   same arguments as gray */

SaveGray(plot)
     char *plot;
{
  struct gray_rec *lplot = (struct gray_rec *) plot;
  if ( SaveLI(lplot->n1)== 0) return(0);
  if ( SaveLI(lplot->n2)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),lplot->n1) == 0) return(0);
  if ( SaveVectF((lplot->y),lplot->n2) == 0) return(0);
  if ( SaveVectF((lplot->z),(lplot->n1)*(lplot->n2)) == 0) return(0);
  if ( SaveVectC((lplot->strflag),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->strflag_kp),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectF((lplot->brect),4L) == 0) return(0);
  if ( SaveVectF((lplot->brect_kp),4L) == 0) return(0);
  if ( SaveVectLI((lplot->aaint),4L)  == 0) return(0);
  if ( SaveVectLI((lplot->aaint_kp),4L) == 0) return(0);
}


/*---------------------------------------------------------------------
\encadre{Le cas des champs de vecteurs}
---------------------------------------------------------------------------*/

SaveChamp(plot)
     char *plot;
{
  struct champ_rec *lplot = (struct champ_rec *) plot;
  if ( SaveLI(lplot->n1)== 0) return(0);
  if ( SaveLI(lplot->n2)== 0) return(0);
  if ( SaveD(lplot->arfact)== 0) return(0);
  if ( SaveVectC((lplot->name),((int)strlen(lplot->name))+1) == 0) return(0);
  if ( SaveVectF((lplot->x),(lplot->n1)) == 0) return(0);
  if ( SaveVectF((lplot->y),(lplot->n2)) == 0) return(0);
  if ( SaveVectF((lplot->fx),(lplot->n1)*(lplot->n2)) == 0) return(0);
  if ( SaveVectF((lplot->fy),(lplot->n1)*(lplot->n2)) == 0) return(0);
  if ( SaveVectC((lplot->strflag),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectC((lplot->strflag_kp),((int)strlen(lplot->strflag))+1) == 0) return(0);
  if ( SaveVectF((lplot->vrect),4L) == 0) return(0);
  if ( SaveVectF((lplot->vrect_kp),4L)== 0) return(0);
}

/*---------------------------------------------------------------------
Sauvegarde 
---------------------------------------------------------------------------*/

#ifdef macintosh
#	include "types.h"
#else /* not macintosh */
#       ifndef VMS
#   	include <sys/types.h>	/* for <netinet/in.h> on some systems */
#   	ifndef MSDOS 
#          include <netinet/in.h>	/* for htonl() */
#   	endif
#	endif
#endif /* not macintosh */


#define assert(ex) {if (!(ex)){ sciprint("Graphic Load/Save Error \r\n");return(0);}} 

#include <rpc/types.h>
#include <rpc/xdr.h>

static char fname[128];
static FILE *F ;
static XDR xdrs[1] ;
static u_int count ;
static u_int szof ;


typedef  struct  {
  char *name;
  int  (*Save)();} SaveTable;

static SaveTable SaveCTable[] ={
    "champ",SaveChamp,
    "contour",SaveContour,
    "fac3d",SaveFac3D,
    "fac3d1",SaveFac3D,
    "fec",SaveFec,
    "gray",SaveGray,
    "param3d",SaveParam3D,
    "plot2d",SavePlot,
    "plot3d",SavePlot3D,
    "plot3d1",SavePlot3D,
    "scale",SaveEch,
    "xcall1",SaveXcall1,
    "xgrid",SaveGrid,
    (char *)NULL,NULL};


C2F(xsaveplots)(winnumber,fname1,lxv)
     integer *winnumber;
     char *fname1 ;
     integer lxv ;
{
  static char endplots[]={"endplots"};
  static char scig[]={"SciG1.0"};
  struct listplot *list;
#ifdef lint 
  *unused;
#endif
  strncpy(fname,fname1,128);
#ifdef __STDC__
  F = fopen(fname,"wb") ;
#else
  F = fopen(fname,"w") ;
#endif
  if( F == NULL)
    {
      sciprint("fopen failed\r\n") ;
      return;
    }
  xdrstdio_create(xdrs, F, XDR_ENCODE) ;
  SaveVectC(scig,((int)strlen(scig))+1) ;
  list=ListPFirst;
  while (list)
    {
      if (list->window == *winnumber && list->theplot != NULL) 
	if ( SaveTPlot(list->type,list->theplot) == 0)
	  break;
      list =list->ptrplot;
    }
  SaveVectC(endplots,((int)strlen(endplots))+1) ;
  assert(fflush((FILE *)xdrs->x_private) != EOF) ; 
  assert(fclose(F) != EOF) ;
}

int SaveTPlot(type,plot)
     char type[];
     char *plot;
{
  int i=0;
  while (SaveCTable[i].name != (char *) NULL)
     {
       int j;
       j = strcmp(type,SaveCTable[i].name);
       if ( j == 0 ) 
	 { 
	   if (SaveVectC(type,((int)strlen(type))+1) == 0) return(0);
	   return( (*(SaveCTable[i].Save))(plot));
	 }
       else 
	 { if ( j <= 0)
	     {
	       /** sciprint("Unknown Plot type <%s>\r\n",type); **/
	       return(0);
	     }
	   else { i++; }
	 }
     }
  return(0);
}

int SaveD(x)
     double x;
{
  szof = sizeof(double) ;
  count = 1;
  assert( xdr_vector(xdrs, (char *) &x, count, szof, xdr_double)) ;
  return(1);
}

int SaveLI(ix)
     integer ix;
{
  szof = sizeof(int) ;
  count = 1;
  assert( xdr_vector(xdrs, (char *)&ix, count, szof, xdr_int)) ;
  return(1);
}

int SaveC(c,lc)
     char *c;
     integer lc;
{
  szof = lc*sizeof(char);
  assert( xdr_vector(xdrs,(char *) &szof,(unsigned)1,(unsigned) sizeof(unsigned), xdr_u_int)) ;
  assert( xdr_opaque(xdrs,c,szof));
  return(1);
}

int SaveVectI(nx,l)
     int *nx;
     integer l;
{ 
  int nx1=1;
  szof = sizeof(int) ;
  count = (int) l;
  assert( xdr_vector(xdrs,(char *) &count,(unsigned)1,(unsigned) sizeof(unsigned), xdr_u_int)) ;
  if ( nx == (int *) NULL && l == (integer) 1)
    {
      assert( xdr_vector(xdrs, (char *)&nx1, count, szof, xdr_int));
    }
  else 
    {
      assert( xdr_vector(xdrs, (char *)nx, count, szof, xdr_int)) ;
    }
  return(1);
}


int SaveVectLI(nx,l)
     integer *nx;
     integer l;
{ 
  integer nx1=1;
  /** Attention integer peut etre un long int **/
  szof = sizeof(int) ;
  count = (int) l;
  assert( xdr_vector(xdrs,(char *) &count,(unsigned)1,(unsigned) sizeof(unsigned), xdr_u_int)) ;
  if ( nx == (integer  *) NULL && l == (integer) 1)
    {
      assert( xdr_vector(xdrs, (char *)&nx1, count, szof, xdr_int)) ;
    }
  else
    {
      assert( xdr_vector(xdrs, (char *)nx, count, szof, xdr_int)) ;
    }
  return(1);
}

int SaveVectF(nx,l)
     double *nx;
     integer l;
{
  double nx1=0.0;
  szof = sizeof(double) ;
  count = (int) l;
  assert( xdr_vector(xdrs,(char *) &count,(unsigned)1,(unsigned) sizeof(unsigned), xdr_u_int)) ;
  if ( nx == (double  *) NULL && l == (integer) 1)
    { assert( xdr_vector(xdrs, (char *)&nx1, count, szof, xdr_double)) ; } 
  else
    { assert( xdr_vector(xdrs, (char *)nx, count, szof, xdr_double)) ; } 
  return(1);
}

int SaveVectC(nx,l)
     char *nx;
     int l;
{
  char nx1='1';
  szof = l*sizeof(char);
  assert( xdr_vector(xdrs,(char *) &szof,(unsigned)1,(unsigned) sizeof(unsigned), xdr_u_int)) ;
  if ( nx == (char  *) NULL && l == (integer) 1)
    { assert( xdr_opaque(xdrs, &nx1,szof)); } 
  else 
    { assert( xdr_opaque(xdrs, nx,szof)); }
  return(1);
}

