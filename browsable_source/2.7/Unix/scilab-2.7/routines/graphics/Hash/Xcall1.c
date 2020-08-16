/* C code produced by gperf version 2.7.1 (19981006 egcs) */
/* Command-line: gperf -C -t -k 2,3,4,$ Xcall1.gperf  */
/*------------------------------------------------------------------------
 *   Graphic library for 2D and 3D plotting 
 *   Copyright (C) 1998-2001 Chancelier Jean-Philippe 
 *   jpc@cereve.enpc.fr 
 *--------------------------------------------------------------------------*/

#include <string.h>
#include <stdio.h>
#include <math.h>
#include "Math.h"
#include "PloEch.h"

typedef void (f_xcall1) __PARAMS((char *,char *,integer *,integer *,integer *,integer *,integer *,integer *,
			       double *,double *,double *,double *,integer,integer ));
typedef void (*func) __PARAMS((char *,char *,integer *,integer *,integer *,integer *,integer *,integer *,
			       double *,double *,double *,double *,integer,integer ));
extern int C2F(sciwin) __PARAMS((void));

static void GSciString __PARAMS((int,integer *x,integer *y,char *StrMat,integer *w,integer *h));
static void Myalloc1 __PARAMS((integer **xm,integer n,integer *err));
static void Myalloc __PARAMS((integer **xm,integer **ym, integer n, integer *err));
static void xstringb __PARAMS(( char *string,integer x, integer y, integer w, integer h));

static f_xcall1 xset_1, drawarc_1, fillarcs_1  ,drawarcs_1  ,fillpolyline_1  ,drawarrows_1  ;
static f_xcall1 drawaxis_1  ,cleararea_1  ,xclick_1  ,xclick_any_1  ,xgetmouse_1  ,fillarc_1  ;
static f_xcall1 fillrectangle_1  ,drawpolyline_1  ,fillpolylines_1  ,drawpolymark_1  ,displaynumbers_1  ;
static f_xcall1 drawpolylines_1  ,drawrectangle_1  ,drawrectangles_1  ,drawsegments_1  ,displaystring_1  ;
static f_xcall1 displaystringa_1  ,boundingbox_1  ,xstringb_1  ;

static integer Ivide=0;
static double  Dvide;

#ifndef __STDC__ 
#define const 
#endif 

struct funreplace { char *name; f_xcall1 *action; };

#define TOTAL_KEYWORDS 38
#define MIN_WORD_LENGTH 4
#define MAX_WORD_LENGTH 9
#define MIN_HASH_VALUE 4
#define MAX_HASH_VALUE 120
/* maximum key range = 117, duplicates = 0 */

#ifdef __GNUC__
__inline
#endif
static unsigned int
hash (str, len)
     register const char *str;
     register unsigned int len;
{
  static const unsigned char asso_values[] =
    {
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121,  35,   0,   5,
        5,   0,  25,  30, 121,   0, 121,   5,  10,  20,
       60,  30,   0, 121,   0,   0,   0,  15, 121,  10,
       10,   0, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121, 121, 121, 121, 121,
      121, 121, 121, 121, 121, 121
    };
  return len + asso_values[(unsigned char)str[3]] + asso_values[(unsigned char)str[2]] + asso_values[(unsigned char)str[1]] + asso_values[(unsigned char)str[len - 1]];
}

#ifdef __GNUC__
__inline
#endif
const struct funreplace *
in_word_set (str, len)
     register const char *str;
     register unsigned int len;
{
  static const struct funreplace wordlist[] =
    {
      {""}, {""}, {""}, {""},
      {"xset",		xset_1},
      {""},
      {"xsetdr",		(func) C2F(dr)},
      {"xreplay",	(func) C2F(dr)},
      {"xstringb",	xstringb_1},
      {""},
      {"xrect",		drawrectangle_1},
      {"xrects",		drawrectangles_1},
      {""}, {""}, {""}, {""}, {""},
      {"xselect",	(func) C2F(dr)},
      {"xstringl",	boundingbox_1},
      {""}, {""},
      {"xclear",		(func) C2F(dr)},
      {""}, {""},
      {"xclickany",	xclick_any_1},
      {""},
      {"xclick",		xclick_1},
      {""}, {""}, {""}, {""},
      {"xfrect",		fillrectangle_1},
      {""}, {""},
      {"xget",		(func) C2F(dr)},
      {"xsegs",		drawsegments_1},
      {"xgetdr",		(func) C2F(dr)},
      {"xstring",	displaystring_1},
      {""},
      {"xgetmouse",	xgetmouse_1},
      {""},
      {"xstart",		(func) C2F(dr)},
      {""},
      {"xstringa",	displaystringa_1},
      {""},
      {"xarcs",		drawarcs_1},
      {"xpolys",		drawpolylines_1},
      {""}, {""},
      {"xarc",		drawarc_1},
      {"xaxis",		drawaxis_1},
      {"xarrow",		drawarrows_1},
      {""}, {""}, {""},
      {"xclea",		cleararea_1},
      {"xpause",		(func) C2F(dr)},
      {""}, {""}, {""}, {""},
      {"xmarks",		drawpolymark_1},
      {""}, {""}, {""},
      {"xinit",		(func) C2F(dr)},
      {"xfarcs",		fillarcs_1},
      {""}, {""}, {""},
      {"xfarc",		fillarc_1},
      {"xlfont",		(func) C2F(dr)},
      {""}, {""},
      {"xend",		(func) C2F(dr)},
      {"xarea",		fillpolyline_1},
      {"xlines",		drawpolyline_1},
      {"xliness",	fillpolylines_1},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {""}, {""}, {""}, {""},
      {"xgfont",		(func) C2F(dr)},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {"xnum",		displaynumbers_1},
      {"xname",		(func) C2F(dr)}
    };

  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register int key = hash (str, len);

      if (key <= MAX_HASH_VALUE && key >= 0)
        {
          register const char *s = wordlist[key].name;

          if (*str == *s && !strcmp (str + 1, s + 1))
            return &wordlist[key];
        }
    }
  return 0;
}


int C2F(dr1)(char x0[],char x1[],integer *x2,integer *x3,integer *x4,integer *x5,integer *x6,
	    integer *x7,double *dx1,double *dx2,double *dx3,double *dx4,
	    integer lx0, integer lx1)
{ 
  const struct funreplace *fr;
  fr=in_word_set(x0,strlen(x0));
  if ( fr != NULL ) 
    {
      (*(fr->action))(x0,x1,x2,x3,x4,x5,x6,x7,dx1,dx2,dx3,dx4,lx0,lx1);
    }
  else 
    {
      sciprint("\n Unknow X operator <%s>\r\n",x0);
    }
  return(0);
}

/**************************************************
 * Global values which are set at this level and 
 * not redirected to each driver
 **************************************************/

static char FPF[32]={'\0'};
static int Autoclear = 0;

void C2F(setautoclear)(integer *num,integer * v2,integer * v3,integer * v4)
{ 
  Autoclear = Max(0,Min(1,*num));
}

void C2F(getautoclear)(integer * verbose,integer * num,integer * narg,double *dummy)
{ 
  *narg=1;
  *num = Autoclear;
  if (*verbose == 1) 
    sciprint("\n Autoclear : %d\r\n",*num);
}

char *getFPF(void)
{
  return(FPF);
}

int C2F(xsetg)(char * str,char * str1,integer lx0,integer lx1)
{
  if ( strcmp(str,"fpf") == 0) 
    {
      strncpy(FPF,str1,32);
    }
  else if ( strcmp(str,"auto clear")==0) 
    {
      if (strcmp(str1,"on")==0 )
	Autoclear = 1;
      else
	Autoclear = 0;
    }
  else if ( strcmp(str,"default")==0)
    {
      Autoclear =0;
      FPF[0]='\0';
    }
  else 
    {
      sciprint("xset(arg,<string>): Unrecognized arg: %s\r\n",str);
    }
  return 0;
}

int C2F(xgetg)( char * str, char * str1, integer * len,integer  lx0,integer lx1)
{
  if ( strcmp(str,"fpf") == 0) 
    {
      strncpy(str1,FPF,32);
      *len= strlen(str1);
    }
  else if ( strcmp(str,"auto clear")==0) 
    {
      if ( Autoclear == 1) 
	{
	  strncpy(str1,"on",2);
	  *len=2;
	}
      else 
	{
	  strncpy(str1,"off",3);
	  *len=3;
	}
    }
  return 0;
}


/*-----------------------------------------------------------------------------
 *  xset_1 
 *-----------------------------------------------------------------------------*/

void xset_1(char *fname, char *str, integer *x1, integer *x2, integer *x3, integer *x4, integer *x5, integer *x6, double *dx1, double *dx2, double *dx3, double *dx4, integer lx0, integer lx1)
{
  /** Warning : we must not record : wdim,wpos,colormap,window and viewport **/
  if (GetDriver()=='R' &&strcmp(str,"wdim")!=0 && strcmp(str,"wpos")!=0 && strcmp(str,"colormap") !=0
      && strcmp(str,"window") != 0 && strcmp(str,"viewport") != 0 && strcmp(str,"wresize") !=0 
      && strcmp(str,"wpdim") !=0 
      ) 
    StoreXcall1(fname,str,x1,1L,x2,1L,x3,1L,x4,1L,x5,1L,x6,1L,dx1,1L,dx2,1L,dx3,1L,dx4,1L);
  if (strcmp(str,"clipping")==0)
    {
      /** and clipping is special its args are floats **/
      integer xx1,yy1,w1,h1,n=1;
      C2F(echelle2d)(dx1,dx2,&xx1,&yy1,&n,&n,"f2i",3L);
      C2F(echelle2dl)(dx3,dx4,&w1,&h1,&n,&n,"f2i");
      C2F(dr)(fname,str,&xx1,&yy1,&w1,&h1,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
    }
  else if (strcmp(str,"clipping-p")==0) 
    {
      /* clip given in pixel */
      C2F(dr)(fname,"clipping",x1,x2,x3,x4,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
    }
  else if (strcmp(str,"clipgrf")==0)
    {
      /** getting clip rect **/
      frame_clip_on();
    }
  else
    {
      C2F(dr)(fname,str,x1,x2,x3,x4,x5,x6,dx1,dx2,dx3,dx4,lx0,lx1);
    }
}

/*-----------------------------------------------------------------------------
 *  drawarc_1
 *-----------------------------------------------------------------------------*/

void drawarc_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *angle1, integer *angle2, double *x, double *y, double *width, double *height, integer lx0, integer lx1)
{ 
  integer x1,yy1,w1,h1,n=1;
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  C2F(echelle2dl)(width,height,&w1,&h1,&n,&n,"f2i"); 
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,angle1,1L,angle2,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,angle1,angle2,PD0,PD0,PD0,PD0,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 * 
 *-----------------------------------------------------------------------------*/

void fillarcs_1(char *fname, char *str, integer *v1, integer *fillvect, integer *n, integer *x6, integer *x7, integer *x8, double *vects, double *dx2, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,6*(*n),&err);
  if (err ==  1) return;
  C2F(ellipse2d)(vects,xm,(n2=6*(*n),&n2),"f2i");
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,fillvect,*n,n,1L,&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,6*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 *  
 *-----------------------------------------------------------------------------*/

void drawarcs_1(char *fname, char *str, integer *v1, integer *style, integer *n, integer *x6, integer *x7, integer *x8, double *vects, double *dx2, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,6*(*n),&err);
  if (err ==  1) return;
  C2F(ellipse2d)(vects,xm,(n2=6*(*n),&n2),"f2i");
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,style,*n,n,1L,&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,6*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,style,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  
 *-----------------------------------------------------------------------------*/

void fillpolyline_1(char *fname, char *str, integer *n, integer *v1, integer *v2, integer *closeflag, integer *x7, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0,n2=1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,"f2i",3L);
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,closeflag,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 *  arrows
 *-----------------------------------------------------------------------------*/

void drawarrows_1(char *fname, char *str, integer *style, integer *iflag, integer *n, integer *v3, integer *x7, integer *x8, double *vx, double *vy, double *as, double *dx4, integer lx0, integer lx1)
{ 
  integer *xm,*ym,err=0,n2=1,n1=1,ias,ias1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,"f2i",3L);
  /* is as < 0 --> not set */
  if ( *as < 0.0 ) 
    {
      int i;
      double Mnorm=0.0;
      for (i=0 ; i < *n/2 ; i++)
	{ 
	  double dx,dy;
	  dx=( vx[2*i+1]-vx[2*i]);
	  dy=( vy[2*i+1]-vy[2*i]);
	  Mnorm += sqrt(dx*dx+dy*dy);
	}
      if ( *n != 0) 
	Mnorm /= (*n/2);
      *as = Mnorm/5.0;
    }
  C2F(echelle2dl)(as,as,&ias,&ias1,&n1,&n1,"f2i"); 
  if (GetDriver()=='R') 
    {
      if ( (int) *iflag== 1) 
	StoreXcall1(fname,str,style,*n,iflag,1L,n,1L,v3,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,as,1L,dx4,1L);
      else 
	StoreXcall1(fname,str,style,1L,iflag,1L,n,1L,v3,1L,&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,as,1L,dx4,1L);
    }
  ias=10*ias;
  C2F(dr)(fname,str,xm,ym,n,&ias,style,iflag,PD0,PD0,PD0,dx4,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 * axis 
 *-----------------------------------------------------------------------------*/

void drawaxis_1(char *fname, char *str, integer *v1, integer *nsteps, integer *v2, integer *v3, integer *x7, integer *x8, double *alpha, double *size, double *initpoint, double *dx4, integer lx0, integer lx1)
{
  integer initpoint1[2],alpha1;
  double size1[3];
  alpha1=inint( *alpha);
  C2F(axis2d)(alpha,initpoint,size,initpoint1,size1);  
  if (GetDriver()=='R') 
    StoreXcall1(fname,str,&Ivide,1L,nsteps,2L,&Ivide,1L,&Ivide,1L,&Ivide,1L,&Ivide,1L,alpha,1L,size,3L,initpoint,2L,&Dvide,1L);

  C2F(dr)(fname,str,&alpha1,nsteps,PI0,initpoint1,x7,x8,size1,PD0,PD0,PD0,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  cleararea
 *-----------------------------------------------------------------------------*/

void cleararea_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *x7, integer *x8, double *x, double *y, double *w, double *h, integer lx0, integer lx1)
{
  integer x1,yy1,w1,h1,n=1;
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  C2F(echelle2dl)(w,h,&w1,&h1,&n,&n,"f2i"); 
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,w,1L,h,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 * click 
 *-----------------------------------------------------------------------------*/
void xclick_1(char *fname, char *str, integer *ibutton, integer *iflag, integer *istr, integer *x5, integer *x6, integer *x7, double *x, double *y, double *dx3, double *dx4, integer lx0, integer lx1)
{ 
  integer x1,yy1,n=1;
  C2F(dr)(fname,str,ibutton,&x1,&yy1,iflag,istr,x7,PD0,PD0,dx3,dx4,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,"i2f",3L);
}
/*-----------------------------------------------------------------------------
 *  click_any
 *-----------------------------------------------------------------------------*/
void xclick_any_1(char *fname, char *str, integer *ibutton, integer *iwin, integer *iflag, integer *x5, integer *x6, integer *x7, double *x, double *y, double *dx3, double *dx4, integer lx0, integer lx1)
{ 
  integer x1,y1,n=1;
  integer verb=0,cur,na;
  C2F(dr)(fname,str,ibutton,&x1,&y1,iwin,iflag,x7,PD0,PD0,PD0,PD0,lx0,lx1);
  if (*ibutton>=0){
    C2F(dr)("xget","window",&verb,&cur,&na,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(dr)("xset","window",iwin,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    C2F(echelle2d)(x,y,&x1,&y1,&n,&n,"i2f",3L);
    C2F(dr)("xset","window",&cur,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  }
}

/*-----------------------------------------------------------------------------
 *   xgetmouse
 *-----------------------------------------------------------------------------*/
void xgetmouse_1(char *fname, char *str, integer *ibutton, integer *iflag, integer *v2, integer *x5, integer *x6, integer *x7, double *x, double *y, double *dx3, double *dx4, integer lx0, integer lx1)
{ 
  integer x1,yy1,n=1;
  C2F(dr)(fname,str,ibutton,&x1,&yy1,iflag,x6,x7,PD0,PD0,dx3,dx4,lx0,lx1);
  C2F(echelle2d)(x,y,&x1,&yy1,&n,&n,"i2f",3L);
}

/*-----------------------------------------------------------------------------
 *   fillarc
 *-----------------------------------------------------------------------------*/

void fillarc_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *angle1, integer *angle2, double *x, double *y, double *width, double *height, integer lx0, integer lx1)
{ 
  integer x1,yy1,w1,h1,n=1;
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  C2F(echelle2dl)(width,height,&w1,&h1,&n,&n,"f2i"); 
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,
	angle1,1L,angle2,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,angle1,angle2,PD0,PD0,PD0,PD0,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  fillrectangle
 *-----------------------------------------------------------------------------*/

void fillrectangle_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *x7, integer *x8, double *x, double *y, double *width, double *height, integer lx0, integer lx1)
{ 
  integer x1,yy1,w1,h1,n=1;
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  C2F(echelle2dl)(width,height,&w1,&h1,&n,&n,"f2i"); 
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,
				&Ivide,1L,&Ivide,1L,x,1L,y,1L,width,1L,height,1L);
  C2F(dr)(fname,str,&x1,&yy1,&w1,&h1,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}


/*-----------------------------------------------------------------------------
 *  drawpolyline
 *-----------------------------------------------------------------------------*/
void drawpolyline_1(char *fname, char *str, integer *n, integer *v1, integer *v2, integer *closeflag, integer *x7, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0,n2=1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,"f2i",3L);
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,closeflag,1L,
				&Ivide,1L,&Ivide,1L,vx,*n,vy,*n,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,closeflag,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 *  fillpolylines
 *-----------------------------------------------------------------------------*/

void fillpolylines_1(char *fname, char *str, integer *v1, integer *v2, integer *fillvect, integer *n, integer *p, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0,i;
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,"f2i",3L);

  if (GetDriver()=='R') { 	  
  /* Code modified by polpoth 11/7/2000 (interpolated shading) */
  
     if (*v1==2) 
	StoreXcall1(fname,str,v1,1L,v2,1L,fillvect,(*n)*(*p),
	n,1L,p,1L,&Ivide,1L,vx,(*n)*(*p),vy,(*n)*(*p),dx3,1L,dx4,1L);

     else /* other cases v1==1 or v1==0 */
     
       	StoreXcall1(fname,str,v1,1L,v2,1L,fillvect,*n,
	n,1L,p,1L,&Ivide,1L,vx,(*n)*(*p),vy,(*n)*(*p),dx3,1L,dx4,1L);
  }
  if (*v1==2) {
     for (i=0 ; i< (*n) ;i++) shade(&xm[(*p)*i],&ym[(*p)*i],&fillvect[(*p)*i],*p,0);
  }
  else C2F(dr)(fname,str,xm,ym,fillvect,n,p,x8,PD0,PD0,dx3,dx4,lx0,lx1);

  /* end of code modified by polpoth 11/7/2000 */

}
/*-----------------------------------------------------------------------------
 *  drawpolymark
 *-----------------------------------------------------------------------------*/
void drawpolymark_1(char *fname, char *str, integer *n, integer *v1, integer *v2, integer *x6, integer *x7, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0,n2=1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,"f2i",3L);
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,n,1L,v1,1L,v2,1L,
		&Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,(*n),dx3,1L,dx4,1L);
  C2F(dr)(fname,str,n,xm,ym,x6,x7,x8,PD0,PD0,dx3,dx4,lx0,lx1);

}

/*-----------------------------------------------------------------------------
 *  displaynumbers
 *-----------------------------------------------------------------------------*/

void displaynumbers_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *n, integer *flag, double *x, double *y, double *z, double *alpha, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0,n2=1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(x,y,xm,ym,n,&n2,"f2i",3L);
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,n,1L,flag,1L,x,(*n),y,(*n),z,*n,alpha,*n);
  C2F(dr)(fname,str,xm,ym,PI0,PI0,n,flag,z,alpha,PD0,PD0,lx0,lx1);
}

/*-----------------------------------------------------------------------------
 *   drawpolylines
 *-----------------------------------------------------------------------------*/

void drawpolylines_1(char *fname, char *str, integer *v1, integer *v2, integer *drawvect, integer *n, integer *p, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,*ym,err=0;
  Myalloc(&xm,&ym,(*n)*(*p),&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,p,"f2i",3L);
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,drawvect,*n,n,1L,p,1L,&Ivide,1L,vx,(*n)*(*p),vy,(*n)*(*p),dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,ym,drawvect,n,p,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *   drawrectangle
 *-----------------------------------------------------------------------------*/
void drawrectangle_1(char *fname, char *str, integer *v1, integer *v2, integer *v3, integer *v4, integer *x7, integer *x8, double *x, double *y, double *w, double *h, integer lx0, integer lx1)
{
  integer xm[4],n2=4;
  double vect[4];
  vect[0]=*x;vect[1]=*y;vect[2]=*w;vect[3]=*h;
  C2F(rect2d)(vect,xm,&n2,"f2i");
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,w,1L,h,1L);
  C2F(dr)(fname,str,xm,xm+1,xm+2,xm+3,x7,x8,PD0,PD0,PD0,PD0,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *   drawrectangles
 *-----------------------------------------------------------------------------*/
void drawrectangles_1(char *fname, char *str, integer *v1, integer *fillvect, integer *n, integer *x6, integer *x7, integer *x8, double *vects, double *dx2, double *dx3, double *dx4, integer lx0, integer lx1)
{
  integer *xm,err=0,n2;
  Myalloc1(&xm,4*(*n),&err);
  if (err ==  1) return;
  C2F(rect2d)(vects,xm,(n2=4*(*n),&n2),"f2i");
  if (GetDriver()=='R') 
	StoreXcall1(fname,str,v1,1L,fillvect,*n,n,1L,
		&Ivide,1L,&Ivide,1L,&Ivide,1L,vects,4*(*n),dx2,1L,dx3,1L,dx4,1L);
  C2F(dr)(fname,str,xm,fillvect,n,x6,x7,x8,PD0,dx2,dx3,dx4,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  drawsegments
 *-----------------------------------------------------------------------------*/
void drawsegments_1(char *fname, char *str, integer *style, integer *iflag, integer *n, integer *x6, integer *x7, integer *x8, double *vx, double *vy, double *dx3, double *dx4, integer lx0, integer lx1)
{ 
  integer *xm,*ym,err=0,n2=1;
  Myalloc(&xm,&ym,*n,&err);
  if (err ==  1) return;
  C2F(echelle2d)(vx,vy,xm,ym,n,&n2,"f2i",3L);
  if (GetDriver()=='R') 
    {
      if ( (int) *iflag== 1) 
	StoreXcall1(fname,str,style,*n,iflag,1L,n,1L,
		    &Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,*n,dx3,1L,dx4,1L);
      else 
	StoreXcall1(fname,str,style,1L,iflag,1L,n,1L,
		    &Ivide,1L,&Ivide,1L,&Ivide,1L,vx,(*n),vy,*n,dx3,1L,dx4,1L);
    }
  C2F(dr)(fname,str,xm,ym,n,style,iflag,x8,PD0,PD0,dx3,dx4,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  displaystring
 *-----------------------------------------------------------------------------*/
void displaystring_1(char *fname, char *string, integer *v1, integer *v2, integer *v3, integer *flag, integer *x7, integer *x8, double *x, double *y, double *angle, double *dx4, integer lx0, integer lx1)
{
  integer x1,yy1;
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  if (GetDriver()=='R') 
	StoreXcall1(fname,string,v1,1L,v2,1L,v3,1L,flag,1L,&Ivide,1L,&Ivide,1L,x,1L,y,1L,angle,1L,dx4,1L);
  C2F(dr)(fname,string,&x1,&yy1,PI0,flag,x7,x8,angle,PD0,PD0,dx4,lx0,lx1);
}
/*-----------------------------------------------------------------------------
 *  displaystringa
 *-----------------------------------------------------------------------------*/
void displaystringa_1(char *fname, char *string, integer *ipos, integer *v2, integer *v3, integer *v4, integer *x7, integer *x8, double *dx1, double *dx2, double *dx3, double *dx4, integer lx0, integer lx1)
{
  if (GetDriver()=='R') 
	StoreXcall1(fname,string,ipos,1L,v2,1L,v3,1L,v4,1L,&Ivide,1L,&Ivide,1L,dx1,1L,dx2,1L,dx3,1L,dx4,1L);
  switch ( *ipos )
    {
    case 1:
      xstringb(string,Cscale.WIRect1[0],Cscale.WIRect1[1],Cscale.WIRect1[2],Cscale.WIRect1[3]/6);
      break;
    case 2:
      xstringb(string,Cscale.WIRect1[0]+Cscale.WIRect1[2],Cscale.WIRect1[1]+Cscale.WIRect1[3],Cscale.WIRect1[2]/6,Cscale.WIRect1[3]/6);
      break;
    case 3:
      xstringb(string,Cscale.WIRect1[0],Cscale.WIRect1[1],Cscale.WIRect1[2]/6,Cscale.WIRect1[3]/12);
      break;
    }
}
/*-----------------------------------------------------------------------------
 * display a set of lines coded with 'line1@line2@.....@'
 *   centred in the rectangle [x,y,w=wide,h=height] 
 *-----------------------------------------------------------------------------*/

static void xstringb(char *string, integer x, integer y, integer w, integer h)
{
  char *loc,*loc1;
  loc= (char *) MALLOC( (strlen(string)+1)*sizeof(char));
  if ( loc != 0)
    {
      integer wmax=0,htot=0,x1=0,yy1=0,rect[4];
      strcpy(loc,string);
      loc1=strtok(loc,"@");
      while ( loc1 != ( char * ) 0) 
	{  
	  C2F(dr)("xstringl",loc1,&x1,&yy1,rect,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  if ( rect[2] >= wmax ) wmax=rect[2];
	  htot += (int) (1.2*((double) rect[3]));
	  loc1=strtok((char *) 0,"@");
	}
      x1=x+ (w- wmax)/2;
      yy1=y - h + ( h - htot)/2 + rect[3];
      strcpy(loc,string);
      loc1=strtok(loc,"@");
      while ( loc1 != ( char * ) 0) 
	{  
	  double angle=0.0;
	  integer flag=0;
	  C2F(dr)("xstring",loc1,&x1,&yy1,PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
	  yy1 += (int) (1.2*((double)rect[3]));
	  loc1=strtok((char *) 0,"@");
	}
      FREE(loc);
    }
  else
    {
      Scistring("xstring : No more Place  \n");
    }
}

/*-----------------------------------------------------------------------------
 *  boundingbox_1
 *  To get the bounding rectangle of a string
 *-----------------------------------------------------------------------------*/

void boundingbox_1(char *fname, char *string, integer *v1, integer *v2, integer *v3, integer *x6, integer *x7, integer *x8, double *x, double *y, double *rect, double *dx4, integer lx0, integer lx1)
{ 
  integer x1,yy1,n=1,rect1[4];
  x1 = XDouble2Pixel(*x);
  yy1 = YDouble2Pixel(*y);
  C2F(dr)(fname,string,&x1,&yy1,rect1,x6,x7,x8,PD0,PD0,PD0,dx4,lx0,lx1);
  C2F(echelle2d)(rect,rect+1,rect1,rect1+1,&n,&n,"i2f",3L);
  C2F(echelle2dl)(rect+2,rect+3,rect1+2,rect1+3,&n,&n,"i2f");
}

/*-----------------------------------------------------------------------------
 * a string in a bounded box : with font size change to fit into the 
 * specified box (only works with driver which properly estimate string sizes)
 *-----------------------------------------------------------------------------*/

#define FONTMAXSIZE 6

void xstringb_1(char *fname, char *str, integer *fflag, integer *v2, integer *v3, integer *v4, integer *x7, integer *x8, double *xd, double *yd, double *wd, double *hd, integer lx0, integer lx1)
{
  integer x,y,w,h,wbox,hbox,size,n=1;
  integer fontid[2],narg,verbose=0;
  if (GetDriver()=='R') 
    StoreXcall1(fname,str,fflag,1L,v2,1L,v3,1L,v4,1L,
		&Ivide,1L,&Ivide,1L,xd,1L,yd,1L,wd,1L,hd,1L);
  x = XDouble2Pixel(*xd);
  y = YDouble2Pixel(*yd);
  C2F(echelle2dl)(wd,hd,&wbox,&hbox,&n,&n,"f2i"); 
  C2F(sciwin)();
  C2F(dr)("xget","font",&verbose,fontid,&narg,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  size = FONTMAXSIZE;
  w = wbox +1;
  if ( *fflag == 1 ) 
    {
      while ( (w > wbox || h > hbox) && size >=0  ) 
	{
	  size--;
	  C2F(dr)("xset","font",fontid,&size,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	  GSciString(0,&x,&y,str,&w,&h);
	}
    }
  else 
    GSciString(0,&x,&y,str,&w,&h);
  x = x +  (wbox - w)/2.0;
  y = y -  (hbox - h)/2.0; 
  GSciString(1,&x,&y,str,&w,&h);
  C2F(dr)("xset","font",fontid,fontid+1,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
}


/**********************************
 * StrMat = 'xxxxZxxxxZxxx....' Z = \n 
 * find the enclosing rectangle for drawing 
 * the string StrMat 
 * and the string is Drawn if Dflag ==1 ;
 **********************************/

void GSciString(int Dflag, integer *x, integer *y, char *StrMat, integer *w, integer *h)
{
  char *p = StrMat,*p1,*p2,*plast;
  integer yi=*y;
  integer wc =0;
  char name[4];
  GetDriver1(name,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  p1 = plast = p+ strlen(p);
  while (1) 
    {
      integer logrect[4];
      double angle=0.0;
      integer flag=1;
      p2 =p1 ; *p1 = '\0';
      while ( p1 != p && *p1 != '\n' ) 
	p1--;
      if ( Dflag == 1) 
	C2F(dr)("xstring",( p1 == p ) ? p1 : p1 +1,
		x,&yi,PI0,&flag,PI0,PI0,&angle,PD0,PD0,PD0,0L,0L);
      C2F(dr)("xstringl",
	      ( p1 == p ) ? p1 : p1 +1,
	      x,&yi,logrect,PI0,PI0,PI0,
	      PD0,PD0,PD0,PD0,0L,0L);	
      if ( p2 != plast) 	*p2 = '\n';
      wc = Max( wc , logrect[2]);
      if ( p == p1 ) 
	{
	  yi=yi- logrect[3];
	  break;
	}	
      else 
	{
	  yi=yi-1.2*logrect[3];
	}
    }
  *w = wc ;
  *h = *y - yi;
}

/*-----------------------------------------------------------------------------
 * Utilities : Allocation 
 *-----------------------------------------------------------------------------*/

static void Myalloc(integer **xm, integer **ym, integer n, integer *err)
{
  if ( n != 0) 
    {
      *xm= graphic_alloc(6,n,sizeof(integer));
      *ym= graphic_alloc(7,n,sizeof(integer));
      if ( *xm == 0 || *ym == 0 )
	{
	  Scistring("malloc: Running out of memory\n");
	  *err=1;
	}
    }
}

static void Myalloc1(integer **xm, integer n, integer *err)
{
  if ( n != 0) 
    {
      if (( *xm= graphic_alloc(6,n,sizeof(integer)))  == 0  )
	{
	  Scistring("malloc: Running out of memory\n");
	  *err=1;
	}
    }
}






