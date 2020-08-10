#include <stdio.h>

#include "metaconst.h"
#include "bezier.h"
#include "color.h"
#include "graphics.h"
#include "font.h"
#include "graphics/Math.h"

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "functions.h"

static int flag=0;
static double angle=0.0;
static int in;
static double kname = 1.0/3.0;

static void draw_sink_source_arrow _PARAMS((MetanetGraph *MG,void *o,int flag1));
static void draw_straight_arc  _PARAMS((MetanetGraph *MG,arc *a));
static void draw_curved_arc   _PARAMS((MetanetGraph *MG,arc *a));
static void draw_loop_arc  _PARAMS((MetanetGraph *MG,arc *a));

#define PI0 (integer *) 0
#define PD0 (double *) 0

#define DrawString(xf,yf,str,lstr) C2F(dr1)("xstring",str,PI0,PI0,PI0,&flag,PI0,PI0,&xf,&yf,&angle,PD0,0L,0L)
#define SetWidth(width) C2F(dr1)("xset","thickness",&width,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
#define DrawLine(x0,y0,x1,y1) xv[0]=x0;yv[0]=y0;xv[1]=x1;yv[1]=y1; C2F(dr1)("xsegs","v",&dstyle,&dflag, &nsegs,PI0,PI0,PI0,xv,yv,PD0,PD0,0L,0L)

static int color;

#define ClearMode()  C2F(dr1)("xset","alufunction",(in=0,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
#define XorMode()    C2F(dr1)("xset","alufunction",(in=6,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
#define StdMode()    C2F(dr1)("xset","alufunction",(in=3,&in),PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);  
#define SetColor(x)  C2F(dr1)("xset","pattern",(color=x,&color),PI0,PI0,PI0, PI0,PI0,PD0,PD0,PD0,PD0,0L,0L)

/** A revoir XXXXXXXX **/

#define white 8 

/*********************************
 * graphic scales and window
 **********************************/

int CheckSciWin()
{
  int verb=0,win,na;
  C2F(dr)("xget","window",&verb,&win,&na, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  C2F(dr)("xset","window",&win,PI0,PI0, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  return 0;
}

void ClearDraw(win)
     int win;
{
  int verb=0,win1,na;
  C2F(dr)("xget","window",&verb,&win1,&na, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  if ( win != win1 )
    C2F(dr)("xset","window",&win,PI0,PI0, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  C2F(dr)("xclear","v",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( win != win1 )
    C2F(dr)("xset","window",&win1,PI0,PI0, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
}

int SetMetanetWin(win)
     int win;
{
  static int oldwin= -1;
  if ( win != oldwin && win >=0 )
    C2F(dr)("xset","window",&win,PI0,PI0, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  return oldwin;
}

/* initialize window dimensions and scales */

int InitScale(MG,win,iwdim,ewdim)
     MetanetGraph *MG;
     int win,*iwdim,*ewdim;
{
  int oldwin,zero=0;
  double *wrect = 0;
  static double arect[] ={0,0,0,0};
  static double frect[4] ={0,0,0,0};
  static char logflag[]="nn";
  double dv;
  integer v;
  char old[4]; int rem_flag =0;
  frect[2]=iwdim[0];frect[3]=iwdim[1];
  /* changes driver and set scales */
  GetDriver1(old,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( old[0] == 'R' ) 
    {
      C2F(SetDriver)("X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      rem_flag=1;
    }
  oldwin = SetMetanetWin(win);
  C2F(dr1)("xset","wresize",&zero,&v,&v,&v,&v,&v,&dv,&dv,&dv,&dv,4L,4L);
  C2F(dr1)("xset","wpdim",ewdim,ewdim+1,&v,&v,&v,&v,&dv,&dv,&dv,&dv,4L,4L);
  C2F(dr1)("xset","wdim",iwdim,iwdim+1,&v,&v,&v,&v,&dv,&dv,&dv,&dv,4L,4L);
  C2F(Nsetscale2d)(wrect,arect,frect,logflag,0L);
  C2F(dr1)("xset","clipgrf",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
  if ( MG != NULL) 
    {
      MG->drawWidth = (int) iwdim[0] ;
      MG->drawHeight =(int) iwdim[1];
      MG->drawX = 0;
      MG->drawY = 0;
    }
  SetMetanetWin(oldwin);
  if (rem_flag == 1) 
    C2F(SetDriver)(old,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  return 0;
}

/*----------------------------------------------------------
 * NewScales changes scales parameters that can be used 
 * for drawing graph using xmin,xmax,ymin,ymax 
 * (This values are used by SetMGScales(MG) 
 *  to explicitely change the graphic scales )
 *-----------------------------------------------------------*/

int NewScales(MG,xmin,ymin,xmax,ymax)
     MetanetGraph *MG;
     int xmin,ymin,xmax,ymax;
{
  double w = xmax - xmin, h = ymax - ymin,d = Max(w,h);
  double frect[4] ={xmin,ymin,xmin+d,ymin+d };
  if ( w < h ) 
    { frect[0] -= (h-w)/2; frect[2] -=	  (h-w)/2;}
  else
    { frect[1] += (h-w)/2; frect[3] +=	  (h-w)/2;}
  MG->drawWidth =  MG->drawHeight = (int) d;
  MG->drawX = (int) frect[0];
  MG->drawY = (int) frect[1];
  return 0;
}

/*-----------------------------------------------------
 * Set MG scales : used when redrawing graph 
 * set scales with data stored in graph 
 *----------------------------------------------------*/

int SetMGScales(MG) 
     MetanetGraph *MG;
{
  double *wrect = 0, arect[]={0,0,0,0};
  double frect[4];
  char logflag[]="nn";
  frect[0] = (double) MG->drawX;
  frect[1] = (double) MG->drawY;
  frect[2] = (double) MG->drawX+MG->drawWidth;
  frect[3] = (double) MG->drawY+MG->drawHeight;
  {
    REMOVE_REC_DRIVER();
    C2F(Nsetscale2d)(wrect,arect,frect,logflag,0L);
    C2F(dr1)("xset","clipgrf",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
    RESTORE_DRIVER();
  }
  return 0;
}

void GetDrawGeometry(MG,x,y,w,h)
     MetanetGraph *MG;
     int *x,*y,*w,*h;
{
  *x = MG->drawX ;
  *y = MG->drawY ;
  *w = MG->drawWidth;
  *h = MG->drawHeight;
}


/*********************************
 *  Drawing Methods 
 *  Object to be drawn is tranmited 
 *  a metanet_graph is also transmmited 
 *  to get default values. 
 **********************************/

void Meta_Draw(MG,obj,f) 
     MetanetGraph *MG;
     void *obj ;
     void (*f) _PARAMS((MetanetGraph *,void *));
{
  (*f)(MG,obj);
}

void Meta_Clear(MG,obj,f)
     MetanetGraph *MG;
     void *obj ;
     void (*f) _PARAMS((MetanetGraph *,void *));
{
  ClearMode();
  (*f)(MG,obj);
  StdMode();
}

void Meta_DrawXor(MG,obj,f)
     MetanetGraph *MG;
     void *obj ;
     void (*f) _PARAMS((MetanetGraph *,void *));
{
  XorMode();
  (*f)(MG,obj);
  StdMode();
}

/*********************************
 *  ARC 
 **********************************/

void draw_arc_name(MG,o)
     MetanetGraph *MG;
     void *o;
{
  double xname,yname;
  arc *a = (arc *) o;
  int width ; 
  if ( a->work == 0) return ;
  width = (a->hilited == 1) ? ArcHiWidth(MG,a) :  ArcWidth(MG,a);
  FontSelect(ArcFontSize(MG,a));
  SetWidth(width);
  xname = a->xmax; yname = a->ymax;
  if (a->g_type == 0) {
    xname = a->x0 + (a->x1 - a->x0) * kname; 
    yname = a->y0 + (a->y1 - a->y0) * kname;
  }
  xname += 2;
  yname -= 2;
  if ( a->hilited == 1) 
    {
      double rect[4];
      SetColor(a->col);
      C2F(dr1)("xstringl",a->work,PI0,PI0,PI0,PI0,PI0,PI0,&xname,&yname,rect,PD0,0L,0L);
      C2F(dr1)("xfrect","v",PI0,PI0,PI0,PI0,PI0,PI0,rect,rect+1,rect+2,rect+3,0L,0L);
      SetColor(white);
      DrawString(xname,yname,a->work,strlen(a->work));       
    }
  else
    {
      SetColor(a->col);
      DrawString(xname,yname,a->work,strlen(a->work)); 
    }
}

/*********************************
 *  Arc 
 **********************************/

void draw_arc(MG,o)
     MetanetGraph *MG;
     void *o ;
{
  arc *a = (arc *) o;
  int width = (a->hilited == 1) ? ArcHiWidth(MG,a) :  ArcWidth(MG,a);
  FontSelect(ArcFontSize(MG,a));
  SetWidth(width);
  SetColor(a->col);
  if (a->g_type == 0)
    draw_straight_arc(MG,a);
  else if (a->g_type < LOOP)
    draw_curved_arc(MG,a);
  else 
    draw_loop_arc(MG,a);
}

/*********************************
 *  Straight Arc 
 **********************************/

static void draw_straight_arc(MG,a) 
     MetanetGraph *MG;
     arc *a;
{
  static int close=0,mn2=2;
  double xv[2],yv[2];
  xv[0]=a->x0;yv[0]=a->y0;xv[1]=a->x1;yv[1]=a->y1;
  C2F(dr1)("xlines","xv",&mn2,PI0,PI0,&close,PI0,PI0,xv,yv,PD0,PD0,0L,0L);
  /* DrawLine(a->x0,a->y0,a->x1,a->y1); */
} 

/*********************************
 *  Curved  Arc 
 **********************************/

static void draw_curved_arc(MG,a)
     MetanetGraph *MG;
     arc *a ;
{
  double xp[4],yp[4];
  int i = 0,close=0,mn2;
  xp[i] = (a->x0); yp[i] = (a->y0);  i++;
  xp[i] = (a->x2); yp[i] = (a->y2);  i++;
  xp[i] = (a->x3); yp[i] = (a->y3);  i++;
  xp[i] = (a->x1); yp[i] = (a->y1);  i++;
  C2F(dr1)("xlines","xv",(mn2=4,&mn2),PI0,PI0,&close,PI0,PI0,xp,yp,PD0,PD0,0L,0L);
}

/*********************************
 *  Loop Arc 
 **********************************/

static void draw_loop_arc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  xBezier points[1];
  points[0].x0 = (a->x0);
  points[0].y0 = (a->y0);
  points[0].x1 = (a->x2);
  points[0].y1 = (a->y2);
  points[0].x2 = (a->x3);
  points[0].y2 = (a->y3);
  points[0].x3 = (a->x1);
  points[0].y3 = (a->y1);
  DrawBezier(points);
}

/*********************************
 *  ArcArrow
 **********************************/

void draw_arc_arrow(MG,o)
     MetanetGraph *MG;
     void *o ;
{
  int i = 0,close=0,mn2;
  double xp[4],yp[4];
  arc *a = (arc *) o;
  xp[i] = (a->xa0); yp[i] = (a->ya0);  i++;
  xp[i] = (a->xa1); yp[i] = (a->ya1);  i++;
  xp[i] = (a->xa2); yp[i] = (a->ya2);  i++;
  xp[i] = (a->xa0); yp[i] = (a->ya0);  i++;
  C2F(dr1)("xlines","xv",(mn2=4,&mn2),PI0,PI0,&close,PI0,PI0,xp,yp,PD0,PD0,0L,0L);
}

/********************************
 * NODE 
 *********************************/

void draw_node_name(MG,o)
     MetanetGraph *MG;
     void *o;
{
  int nodeDiam;
  node *n = (node *) o;
  double xf,yf,rect[4];

  if (n->work  == 0) return;
  nodeDiam = NodeDiam(MG,n);
  C2F(dr1)("xstringl",n->work,PI0,PI0,PI0,PI0,PI0,PI0,(xf=n->x,&xf),(yf=n->y,&yf),rect,PD0,0L,0L);
  xf = n->x +(nodeDiam  - rect[2]) / 2.0;
  yf = n->y +(nodeDiam  - rect[3]) / 2.0;
  if (n->hilited == 1) 
    SetColor(white);      
  else 
    SetColor(n->col);      
  DrawString(xf,yf,n->work,strlen(n->work)); 
}

/************************************
 * PlainNode 
 ************************************/

void draw_plain_node(MG,o) 
     MetanetGraph *MG;
     void *o;
{
  int nodeDiam,nodeW;
  double dx,dy,dw,dh;
  int angle1=0,angle2=360*64;
  node *n = (node *)o;
  nodeDiam = NodeDiam(MG,n);
  nodeW = NodeBorder(MG,n);
  SetWidth(nodeW);
  FontSelect(NodeFontSize(MG,n));
  dx = n->x;
  dw = NodeDiam(MG,n);
  dh = NodeDiam(MG,n);
  dy = n->y +dh ;
  /* remplir en blanc */
  if ( n->hilited == 1) 
    {
      SetColor(n->col);
      C2F(dr1)("xfarc","xv",PI0,PI0,PI0,PI0,&angle1,&angle2,&dx,&dy, &dw,&dh,0L,0L);
    }
  else 
    {
      SetColor(white);
      C2F(dr1)("xfarc","xv",PI0,PI0,PI0,PI0,&angle1,&angle2,&dx,&dy, &dw,&dh,0L,0L);
      SetColor(n->col);
      C2F(dr1)("xarc","xv",PI0,PI0,PI0,PI0,&angle1,&angle2,&dx,&dy,&dw,&dh,0L,0L);
    }
  switch (n->type) {
  case PLAIN:
    break;
  case SINK:
    draw_sink_source_arrow(MG,n,1) ;
    break;
  case SOURCE:
    draw_sink_source_arrow(MG,n,0) ;
    break;
  }
}

/************************************
 * SArrow
 ************************************/

static void draw_sink_source_arrow(MG,o,flag1) 
     MetanetGraph *MG;
     void *o;
     int flag1;
{
  int nodeDiam,nodeW;
  int i = 0,close=0,mn2;
  double xp[10],yp[10];
  double x,y,w,h,l;
  node *n = (node *)o;
  nodeDiam = NodeDiam(MG,n);
  nodeW = NodeBorder(MG,n);
  SetWidth(nodeW);
  FontSelect(NodeFontSize(MG,n));
  x= n->x + nodeDiam / 2.0;
  if ( flag1 == 1) 
    y= 1 + n->y + 3 * nodeDiam;
  else 
    y= n->y -1;
  w= nodeDiam;
  h=2 * nodeDiam;
  l= nodeDiam / 3.0;
  xp[i] = (x); yp[i] = (y); i++;
  xp[i] = ((x + w)); yp[i] = ((y - w));  i++;
  xp[i] = ((x + w - l));  yp[i] = ((y - w));  i++;
  xp[i] = ((x + l));  yp[i] = ((y - 2 * l));  i++;
  xp[i] = ((x + l));  yp[i] = ((y - h));  i++;
  xp[i] = ((x - l));  yp[i] = ((y - h));  i++;
  xp[i] = ((x - l));  yp[i] = ((y - 2 * l));  i++;
  xp[i] = ((x + l - w));  yp[i] = ((y - w));  i++;
  xp[i] = ((x - w));  yp[i] = ((y - w));  i++;
  xp[i] = (x); yp[i] = (y); i++;
  SetColor(white);
  C2F(dr1)("xarea","xv",(mn2=10,&mn2),PI0,PI0,&close,PI0,PI0,xp,yp,PD0,PD0,0L,0L);
  SetColor(n->col);
  C2F(dr1)("xlines","xv",(mn2=10,&mn2),PI0,PI0,&close,PI0,PI0,xp,yp,PD0,PD0,0L,0L);
}















