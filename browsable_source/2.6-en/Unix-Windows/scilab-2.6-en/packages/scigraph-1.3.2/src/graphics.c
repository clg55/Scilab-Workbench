/* Copyright INRIA/ENPC */

#include <math.h>
#include <string.h>
#include <stdio.h>
#include "graphics/Math.h"

#define PI0 (integer *) 0
#define PD0 (double *) 0

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "color.h"
#include "menus.h"
#include "metio.h"
#include "graphics.h"
#include "font.h"
#include "functions.h"

typedef void (*voidf) _PARAMS((void *,void *));
static void graph_loop _PARAMS((MetanetGraph *, mylink *p, voidf));
static void set_arc_str_display _PARAMS(( MetanetGraph *MG, arc *a));
static void set_node_str_display _PARAMS(( MetanetGraph *MG, node *n));

/*---------------------------------------------------------
 * used to tell scilab graphics how to redraw a graph 
 * since a graph is not drawn with Rec driver for efficiency 
 *---------------------------------------------------------*/

int draw_graph(win_num) int win_num;
{
  MetanetGraph *MG = get_graph_win(win_num);
  /* sciprint("je suis ds le draw handler "); */
  if ( MG != NULL)  DrawGraph(MG); 
  return win_num;
}


type_id PointerInObject(MG,x,y,object)
     MetanetGraph *MG;
     int x,y;
     ptr *object;
{
  if (PointerInNode(MG,x,y,object)) 
    return NODE;
  else if (PointerInArc(MG,x,y,object)) 
    return ARC;
  else return 0;
}

void WhenPress1(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  ptr object = 0;
  type_id t;
  REMOVE_REC_DRIVER();
  t = PointerInObject(MG,x,y,&object);
  if (t != 0)
    switch (t) {
    case ARC:
      ActivateWhenPressArc(MG,(arc*)object);
      break;
    case NODE:
      ActivateWhenPress1Node(MG,(node*)object);
      break;
    }
  else {
    if (MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) {
      UnhiliteAll(MG);
    }
  }
  RESTORE_DRIVER();
}



void WhenOnStudyMove(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  ptr object = 0;
  type_id t = PointerInObject(MG,x,y,&object);
  if (MG->moveflag == 1 && t != 0)
    {
      REMOVE_REC_DRIVER();
      switch (t) {
      case ARC:
	if (MG->GG.n_hilited_arcs == 0 && MG->GG.n_hilited_nodes == 0) 
	  HiliteArc(MG,(arc *)object);
	else if (((arc *)object)->hilited) 
	  { }
	else 
	  {  UnhiliteAll(MG);  HiliteArc(MG,(arc *)object);}
	InfoArc(MG,(arc *)object);
	break;
      case NODE:
	if (MG->GG.n_hilited_arcs == 0 && MG->GG.n_hilited_nodes == 0) 
	  HiliteNode(MG,(node *)object);
	else if (((node *)object)->hilited) 
	  { }
	else 
	  {  UnhiliteAll(MG);  HiliteNode(MG,(node *)object);}
	InfoNode(MG,(node *)object);
	break;
      }
      RESTORE_DRIVER();
    }
}


void WhenPress3(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  ptr object = 0;
  type_id t;
  REMOVE_REC_DRIVER();
  t = PointerInObject(MG,x,y,&object);
  if (t != 0)
    switch (t) {
    case ARC:
      ActivateWhenPressArc(MG,(arc*)object);
      break;
    case NODE:
      ActivateWhenPress3Node(MG,(node*)object);
      break;
    }
  else {
    if (MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) {
      UnhiliteAll(MG);
    }
  }
  RESTORE_DRIVER();
}

void StopMoving(MG,x,y)
     MetanetGraph *MG;
     int x,y; 
{
  mylink *p;
  arc *a;
  REMOVE_REC_DRIVER();
  MoveNode(MG,x,y,MG->GG.moving);
  DrawNode(MG,MG->GG.moving);
  p = MG->GG.moving->connected_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    SetCoordinatesArc(MG,a);
    DrawArc(MG,a);
    p = p->next;
  }
  p = MG->GG.moving->loop_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    SetCoordinatesArc(MG,a);
    DrawArc(MG,a);
    p = p->next;
  }
  MG->GG.moving = 0;
  RESTORE_DRIVER();
}  

void WhenRelease3(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  ptr object = 0;
  REMOVE_REC_DRIVER();
  if (MG->menuId == MODIFY) {
    if (MG->GG.moving != 0) StopMoving(MG,x,y);
    else {
      if (!PointerInObject(MG,x,y,&object)) {
	DrawNode(MG,AddNode(MG,x,y));
	MG->GG.modified = 1;
      }
    }
  }
  RESTORE_DRIVER();
}

void WhenDownMove(MG,sx,sy,x,y)
     MetanetGraph *MG;
     int sx,sy,x,y;
{
  ptr object = 0;
  node *n;
  REMOVE_REC_DRIVER();
  if (MG->GG.moving == 0 && PointerInObject(MG,sx,sy,&object) == NODE) {
    /* there is no moving object and the pointer is in a node,
       it becomes the moving node */
    n = (node*)object;
    MG->GG.moving = n;
    UnhiliteNode(MG,n);
    EraseNode(MG,n);
    MG->GG.modified = 1;
    graph_loop( MG, n->connected_arcs->first, (voidf) EraseArc);
    graph_loop( MG, n->connected_arcs->first, (voidf) DrawMovingArc);
    graph_loop( MG, n->loop_arcs->first,   (voidf) EraseArc);
    graph_loop( MG, n->loop_arcs->first,   (voidf) DrawMovingArc);
    DrawMovingNode(MG,n);
  }
  else if (MG->GG.moving != 0) {
    MoveNode(MG,x,y,MG->GG.moving);
  }
  RESTORE_DRIVER();
}

/* GRAPH */

void DrawGraph(MG)
     MetanetGraph *MG;
{
  int oldwin;
  if ( MG->Graph == NULL) return ;
  {
    REMOVE_REC_DRIVER();
    /* fix graphics boundaries for drawing graph */
    oldwin =  SetMetanetWin(MG->win);
    SetMGScales(MG);
    /* draw the graph */ 
    graph_loop( MG,  MG->Graph->arcs->first , (voidf) DrawArc) ;
    graph_loop( MG,  MG->Graph->nodes->first, (voidf) DrawNode);
    SetMetanetWin(oldwin);
    RESTORE_DRIVER();
  }
}

/* ARC */

#ifdef WIN32 
typedef struct xpoint_ { int x;int y;} XPoint;
static int EvenOddRule = 0;
#else 
#include <X11/Intrinsic.h>
#endif 

int PointerInArrowOld(MG,x, y, a)
     MetanetGraph *MG;
     int x, y;
     arc *a;
{
#ifndef WIN32 
  Region R;
  XPoint points[5];
  int rep,i=0;
#endif 
  double xx, yy;
  int width, length;

  xx = a->co;
  yy = - a->si;

  if (a->hilited) {
    width =  ArcHiWidth(MG,a) + arrowWidth;
    length = ArcHiWidth(MG,a) + arrowLength;    
  } else {
    width =  ArcWidth(MG,a) + arrowWidth;
    length = ArcWidth(MG,a) + arrowLength;
  }
#ifndef WIN32 
  /* A0 */
  points[i].x = (short)((a->xmax)  + (width * a->si) );
  points[i].y = (short)((a->ymax)  + (width * a->co) );
  i++;
  /* A1 */
  points[i].x = (short)((a->xmax)  + (length * xx) );
  points[i].y = (short)((a->ymax)  + (length * yy) );
  i++;
  /* A2 */
  points[i].x = (short)((a->xmax)  - (width * a->si) );
  points[i].y = (short)((a->ymax)  - (width * a->co) );
  i++;
  /* symmetric of A1 */
  points[i].x = (short)((a->xmax)  - (length * xx) );
  points[i].y = (short)((a->ymax)  - (length * yy) );
  i++;
  /* A0 */
  points[i].x = points[0].x;
  points[i].y = points[0].y;
  i++;
  R = XPolygonRegion(points,i,EvenOddRule);
  rep = XPointInRegion(R,x,y);
  XDestroyRegion(R);
  return rep;
#else 
  /* simpler method for windows */
  if ( (double) x < (a->xmax) + length/2.0 && (double) x > a->xmax - length/2.0
       && (double) y < (a->ymax) + length/2.0 && (double) y > a->ymax - length/2.0 )
    return 1;
  else 
    return 0;
#endif 
}

int PointerInArrow(MG,x, y, a)
     MetanetGraph *MG;
     int x, y;
     arc *a;
{
  double xx, yy;
  int width, length;

  xx = a->co;
  yy = - a->si;

  if (a->hilited) {
    width =  ArcHiWidth(MG,a) + arrowWidth;
    length = ArcHiWidth(MG,a) + arrowLength;    
  } else {
    width =  ArcWidth(MG,a) + arrowWidth;
    length = ArcWidth(MG,a) + arrowLength;
  }
  if ( (double) x < (a->xmax) + length/2.0 && (double) x > a->xmax - length/2.0
       && (double) y < (a->ymax) + length/2.0 && (double) y > a->ymax - length/2.0 )
    return 1;
  else 
    return 0;
}



int PointerInThisArc(MG,x, y, a)
     MetanetGraph *MG;
     int x, y;
     arc *a;
{
  if (a->x0 == HIDDEN) return 0;
  return PointerInArrow(MG,x, y ,a);
}

int PointerInArc(MG,x, y, object)
     MetanetGraph *MG;
     int x, y;
     ptr *object;
{
  arc *a;
  mylink *p;

  if(MG->Graph->arcs->first == 0) return 0;
  p = MG->Graph->arcs->first;
  while(p) {
    a = (arc*)(p->element);
    if (PointerInThisArc(MG,x,y,a)) {
      *object = p->element;
      return 1;
    }
    p = p->next;
  }
  return 0;
} 



void ActivateWhenPressArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  if (MG->GG.n_hilited_arcs == 0 && MG->GG.n_hilited_nodes == 0) {
    /* there is no hilited object: this arc is hilited */
    HiliteArc(MG,a);
  }
  else if (a->hilited) {
    /* this arc is already hilited: unhilite everything */
    UnhiliteAll(MG);
  }
  else {
    /* there are hilited objects: unhilited them and this arc is
       hilited */
    UnhiliteAll(MG);
    HiliteArc(MG,a);
  }
}

void SetArrowCoordinatesArc(a)
     arc *a;
{
  double xx, yy;
  xx = a->co;
  yy = - a->si;
  a->xa0 = a->xmax + (int)(arrowWidth * a->si);
  a->ya0 = a->ymax + (int)(arrowWidth * a->co);
  a->xa2 = a->xmax - (int)(arrowWidth * a->si);
  a->ya2 = a->ymax - (int)(arrowWidth * a->co);
  a->xa1 = a->xmax + (int)(arrowLength * xx);
  a->ya1 = a->ymax + (int)(arrowLength * yy);
}

void SetCoordinatesArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  int direction, x00, y00, x11, y11;
  int nrt, nrh;
  double l, d;
  double w, h;
  double inc0, inc;

  direction = (a->head->number > a->tail->number) ? a->g_type : - a->g_type;
  /* (x00,y00) and (x11,y11) are the center of the head and tail nodes */
  nrt = NodeDiam(MG,a->tail) / 2; nrh = NodeDiam(MG,a->head) / 2;
  x00 = a->tail->x + nrt;
  y00 = a->tail->y + nrt;
  x11 = a->head->x + nrh;
  y11 = a->head->y + nrh;
  /* (x0,y0) and (x1,y1) are the ends of the segment used to draw
     this arc */
  if (a->g_type >= LOOP) {
    a->x0 = x00 + nrt;
    a->y0 = y00;
    a->x1 = x00;
    a->y1 = y00 - nrh;
    d = sqrt((double)((a->x1 - a->x0)*(a->x1 - a->x0) + 
		      (a->y1 - a->y0)*(a->y1 - a->y0)));
    a->si = (a->y0 - a->y1) / d;
    a->co = (a->x1 - a->x0) / d;
    inc0 = (4 * bezierDy / 3 + 1.3 * (ArcWidth(MG,a) - 1)) + nrt;
    inc = (a->g_type - LOOP) * 
      (4 * bezierDy / 3 + 1.3 * (ArcWidth(MG,a) - 1));
    a->x2 = a->x0 + (int)((inc0 + inc) * 1.414);
    a->y2 = a->y0;
    a->x3 = a->x1;
    a->y3 = a->y1 - (int)((inc0 + inc) * 1.414);
    a->xmax = (a->x0 + 4 * a->x1 + 3 * a->x2) / 8;
    a->ymax = (4 * a->y0 + a->y1 + 3 * a->y3) / 8;
  }
  else {
    l = sqrt((double)((x11 - x00)*(x11 - x00) + (y11 - y00)*(y11 - y00)));
    /* arc is hidden: nodes too near */
    if (l <= nrt + nrh) {
      a->x0 = HIDDEN;
      return;
    }
    a->co = (x11 - x00) / l;
    a->si = (y00 - y11) / l;
    a->x0 = x00 + (int)(nrt * a->co);
    a->y0 = y00 - (int)(nrt * a->si);
    a->x1 = x11 - (int)(nrh * a->co);
    a->y1 = y11 + (int)(nrh * a->si);
    if (direction == 0) {
      a->xmax = (a->x0 + a->x1) / 2;
      a->ymax = (a->y0 + a->y1) / 2;
    }
    else {
      d = l - nrt - nrh;
      w = arcDx * d;
      h = direction * arcDy;
      a->x2 = a->x0 + (int)(w * a->co - h * a->si);
      a->y2 = a->y0 - (int)(w * a->si + h * a->co);
      a->x3 = a->x2 + (int)((d - 2 * w) * a->co);
      a->y3 = a->y2 - (int)((d - 2 * w) * a->si);
      a->xmax = (a->x2 + a->x3) / 2;
      a->ymax = (a->y2 + a->y3) / 2;
    }
  }
  SetArrowCoordinatesArc(a);
}


static void set_arc_str_display(MG,a )
     MetanetGraph *MG;
     arc *a;
{
  static char str[MAXNAM];
  a->work = 0;
  switch (MG->arcStrDisplay) {
  case INT_ARCDISP:
    sprintf(str,"%d",a->number);
    a->work = str;
    break;
  case NAME_ARCDISP:
    if (a->name != 0) a->work = a->name;
    break;
  case COST_ARCDISP:
    sprintf(str,"%g",a->unitary_cost);
    a->work = str;
    break;
  case MINCAP_ARCDISP:
    sprintf(str,"%g",a->minimum_capacity);
    a->work = str;
    break;
  case MAXCAP_ARCDISP:
    sprintf(str,"%g",a->maximum_capacity);
    a->work = str;
    break;
  case LENGTH_ARCDISP:
    sprintf(str,"%g",a->length);
    a->work = str;
    break;
  case QWEIGHT_ARCDISP:
    sprintf(str,"%g",a->quadratic_weight);
    a->work = str;
    break;
  case QORIG_ARCDISP:
    sprintf(str,"%g",a->quadratic_origin);
    a->work = str;
    break;
  case WEIGHT_ARCDISP:
    sprintf(str,"%g",a->weight);
    a->work = str;
    break;
  case LABEL_ARCDISP:
    if (a->label != 0) a->work= a->label;
    break;
  case NODISP :
  default : 
    break;
  }
}


void DrawArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  if (a->x0 == HIDDEN) return;
  FontSelect(ArcFontSize(MG,a));
  Meta_Draw(MG,a,draw_arc);
  if (MG->Graph->directed) Meta_Draw(MG,a,draw_arc_arrow);
  set_arc_str_display(MG,a);
  Meta_Draw(MG,a,draw_arc_name);
  if ( a->hilited == 1) 
    {
      DrawNode(MG,a->tail);
      DrawNode(MG,a->head);
    }
}

void DrawMovingArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  if (a->x0 == HIDDEN) return;
  FontSelect(ArcFontSize(MG,a));
  Meta_DrawXor(MG,a,draw_arc);
}

void EraseArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  if (a->x0 == HIDDEN) return;
  FontSelect(ArcFontSize(MG,a));
  Meta_Clear(MG,a,draw_arc);
  if (MG->Graph->directed) Meta_Clear(MG,a,draw_arc_arrow);
  set_arc_str_display(MG,a);
  Meta_Clear(MG,a,draw_arc_name);
}

void EraseMovingArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{ 
  if (a->x0 == HIDDEN) return;
  FontSelect(ArcFontSize(MG,a));
  Meta_DrawXor(MG,a,draw_arc);
}

void HiliteArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  if (a->x0 == HIDDEN) return;
  a->hilited = 1;
  MG->GG.n_hilited_arcs++;
  AddListElement((ptr)a,MG->GG.hilited_arcs);    
  DrawArc(MG,a);
}

void UnhiliteArc1(MG,a)
     MetanetGraph *MG;
     arc *a;
{  
  if (a->x0 == HIDDEN) return;
  EraseArc(MG,a);
  a->hilited = 0;
  DrawArc(MG,a);
  DrawNode(MG,a->tail);
  DrawNode(MG,a->head);
}

void UnhiliteArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{  
  if (a->x0 == HIDDEN) return;
  MG->GG.n_hilited_arcs--;
  RemoveListElement((ptr)a,MG->GG.hilited_arcs);
  UnhiliteArc1(MG,a);
}

/* NODE */

int PointerInNode(MG,x, y, object)
     MetanetGraph *MG;
     int x, y;
     ptr *object;
{
  node *n;
  int x0, y0, r;
  mylink *p;
  if (MG->Graph->nodes->first == 0) return 0;
  p = MG->Graph->nodes->first;
  while(p) {
    n = (node*)(p->element);
    x0 = (int)((n->x + NodeDiam(MG,n) / 2));
    y0 = (int)((n->y + NodeDiam(MG,n) / 2));
    r = (int)( NodeDiam(MG,n) / 2);
    if ((x - x0)*(x - x0) + (y - y0)*(y - y0) < r * r) {
      *object = p->element;
      return 1;
    }
    p = p->next;
  }
  return 0;
} 

void ActivateWhenPress1Node(MG,n)
     MetanetGraph *MG;
     node *n;
{
  if (MG->GG.n_hilited_arcs == 0 && MG->GG.n_hilited_nodes == 0) {
    /* there is no hilited object */
    HiliteNode(MG,n);
  }
  else if (n->hilited) {
    /* this node is already hilited: unhilite everything */
    UnhiliteAll(MG);
  }
  else {    
    /* there are hilited objects: unhilited them and this node is
     *   hilited 
     */
    UnhiliteAll(MG);
    HiliteNode(MG,n);
  }
}

void ActivateWhenPress3Node(MG,n)
     MetanetGraph *MG;
     node *n;
{
  arc *a1;
  node *n1;

  if (MG->GG.n_hilited_arcs == 0 && MG->GG.n_hilited_nodes == 0) {
    /* there is no hilited object */
    HiliteNode(MG,n);
  }
  else if (n->hilited) {
    /* this node is already hilited: unhilite everything */
    UnhiliteAll(MG);
  }
  else if (MG->menuId == MODIFY && MG->GG.n_hilited_arcs == 0 && 
	   MG->GG.n_hilited_nodes == 1) {
      /* we are in modify menu and there is another hilited node: draw a new 
	 arc from the hilited node to this node and unhilite the nodes */
    UnhiliteNode(MG,n);
    n1 = (node*)MG->GG.hilited_nodes->first->element;
    UnhiliteNode(MG,n1);
    a1 = AddArc(MG,n1,n);
    if (a1 == 0) return;
    DrawArc(MG,a1);
    DrawNode(MG,a1->tail);
    DrawNode(MG,a1->head);
    MG->GG.modified = 1;
  }
  else {    
    /* there are hilited objects: unhilited them and this node is
       hilited */
    UnhiliteAll(MG);
    HiliteNode(MG,n);
  }
}

/* utility function for nodes */

static void set_node_str_display(MG,n)
     MetanetGraph *MG;
     node *n;
{
  static char str[MAXNAM];
  n->work = 0;
  switch (MG->nodeStrDisplay) {
  case INT_NODEDISP:
    sprintf(str,"%d",n->number);
    n->work = str;
    break;
  case NAME_NODEDISP:
    if (n->name != 0) n->work = n->name;
    break;
  case DEMAND_NODEDISP:
    sprintf(str,"%g",n->demand);
    n->work = str;
    break;
  case LABEL_NODEDISP:
    if (n->label != 0) n->work = n->label;
  case NODISP :
  default : 
    break;
  }
  return ;
}

void MoveNode(MG,nx, ny, n)
     MetanetGraph *MG;
     int nx, ny;
     node *n;
{
  mylink *p;
  arc *a;

  EraseMovingNode(MG,n);
  n->x = (int)((double)(nx - (int)(NodeDiam(MG,n)) / 2));
  n->y = (int)((double)(ny - (int)(NodeDiam(MG,n)) / 2));
  /* move arcs */
  p = n->connected_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    EraseMovingArc(MG,a);
    SetCoordinatesArc(MG,a);
    DrawMovingArc(MG,a);
    p = p->next;
  }
  p = n->loop_arcs->first;
  while (p) {
    a = (arc*)(p->element);
    EraseMovingArc(MG,a);
    SetCoordinatesArc(MG,a);
    DrawMovingArc(MG,a);
    p = p->next;
  }
  /* move node */
  DrawMovingNode(MG,n);
}

extern void draw_plain_node();
extern void draw_sink_arrow();
extern void draw_source_arrow();
extern void draw_node_name();

void DrawNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_Draw(MG,n,draw_plain_node);
  set_node_str_display(MG,n);
  Meta_Draw(MG,n,draw_node_name);
}

void DrawMovingNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_DrawXor(MG,n,draw_plain_node);
}

void EraseNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_Clear(MG,n,draw_plain_node);
  set_node_str_display(MG,n);
  Meta_Clear(MG,n,draw_node_name);
}

void EraseMovingNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_DrawXor(MG,n,draw_plain_node);
}

void HiliteNode1(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_Draw(MG,n,draw_plain_node);
  set_node_str_display(MG,n);
  Meta_Draw(MG,n,draw_node_name);
}

void HiliteNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  n->hilited = 1;
  MG->GG.n_hilited_nodes++;
  AddListElement((ptr)n,MG->GG.hilited_nodes);
  HiliteNode1(MG,n);
}

void UnhiliteNode1(MG,n)
     MetanetGraph *MG;
     node *n;
{
  Meta_Draw(MG,n,draw_plain_node);
  set_node_str_display(MG,n);
  Meta_Draw(MG,n,draw_node_name);
}

void UnhiliteNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  MG->GG.n_hilited_nodes--;
  RemoveListElement((ptr)n,MG->GG.hilited_nodes);
  UnhiliteNode1(MG,n);
  n->hilited = 0;
}

void CreateLoop(MG)
     MetanetGraph *MG;
{
  node *n; arc *a;

  if (MG->GG.n_hilited_nodes == 1) {
    n = (node*)MG->GG.hilited_nodes->first->element;
    a = AddArc(MG,n,n);
    if (a == 0) return;
    DrawArc(MG,a);
    DrawNode(MG,a->tail);
    DrawNode(MG,a->head);
    MG->GG.modified = 1;
  }
}

void CreateSource(MG)
     MetanetGraph *MG;
{
  node *n;

  if (MG->GG.n_hilited_nodes == 1) {
    n = (node*)MG->GG.hilited_nodes->first->element;
    if (n->type != SOURCE) {
      if (n->type == SINK) {
	/* node was a sink, remove it from graph */
	MG->Graph->sink_number--;
	RemoveListElement((ptr)n,MG->Graph->sinks);
      }
      /* add new source to graph */
      MG->Graph->source_number++;
      AddListElement((ptr)n,MG->Graph->sources);
      /* draw new source */
      EraseNode(MG,n);
      n->type = SOURCE;
      DrawNode(MG,n);
    }
  }
}

void CreateSink(MG)
     MetanetGraph *MG;
{
  node *n;
  if (MG->GG.n_hilited_nodes == 1) {
    n = (node*)MG->GG.hilited_nodes->first->element;
    if (n->type != SINK) {
      if (n->type == SOURCE) {
	/* node was a source, remove it from graph */
	MG->Graph->source_number--;
	RemoveListElement((ptr)n,MG->Graph->sources);
      }
      /* add new sink to graph */
      MG->Graph->sink_number++;
      AddListElement((ptr)n,MG->Graph->sinks);
      /* draw new sink */
      EraseNode(MG,n);
      n->type = SINK;
      DrawNode(MG,n);
    }
  }
}

void RemoveSourceSink(MG)
     MetanetGraph *MG;
{
  node *n;

  if (MG->GG.n_hilited_nodes == 1) {
    n = (node*)MG->GG.hilited_nodes->first->element;
    switch (n->type) {
    case SOURCE:
      /* node was a source, remove it from graph */
      MG->Graph->source_number--;
      RemoveListElement((ptr)n,MG->Graph->sources);
      break;
    case SINK:
      /* node was a sink, remove it from graph */
      MG->Graph->sink_number--;
      RemoveListElement((ptr)n,MG->Graph->sinks);
      break;
    default:
      return;
    }
    /* draw new node */
    UnhiliteNode(MG,n);
    EraseNode(MG,n);
    n->type = PLAIN;
    DrawNode(MG,n);
  }
}

void ChooseDefaults(MG)
     MetanetGraph *MG;
{
  char *label = "Graphic attributes";
  char *init[5];
  char *result[5];
  char *description[5];
  char str[64];
  int v;
  int snodeDiam, snodeW, sarcW, sarcH, sfontSize;
  int fontstruct;
  mylink *p;
  int i = 0;
  int redraw = 0;

  sprintf(str,"%d",MG->Graph->fontSize);
  if ((init[i] = 
       (char*)MALLOC((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)MALLOC((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Default font size: ";
  i++;

  sprintf(str,"%d",MG->Graph->nodeDiam);
  if ((init[i] = 
       (char*)MALLOC((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)MALLOC((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Default node diameter: ";
  i++;

  sprintf(str,"%d",MG->Graph->nodeBorder);
  if ((init[i] = 
       (char*)MALLOC((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)MALLOC((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Default border node width: ";
  i++;

  sprintf(str,"%d",MG->Graph->arcWidth);
  if ((init[i] = 
       (char*)MALLOC((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)MALLOC((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Default arc width: ";
  i++;

  sprintf(str,"%d",MG->Graph->arcHiWidth);
  if ((init[i] = 
       (char*)MALLOC((unsigned)(strlen(str) + 1) * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  strcpy(init[i],str);
  if ((result[i] = (char*)MALLOC((unsigned)64 * sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  } 
  description[i] = "Default highlighted arc width: ";
  i++;
  
  if (MetanetDialogs(i,init,result,description,label)) {
    i = 0;

    sfontSize = MG->Graph->fontSize;
    sscanf(result[i],"%d",&v);
    if ((fontstruct = FontSelect(v)) == -1) {
      sprintf(Description,
	      "Unknown font size %d\nUse only 8, 10, 12 14, 18 or 24",v);
      MetanetAlert();
      return;
    }
    MG->Graph->fontSize = v; i++;
    if (MG->Graph->fontSize != sfontSize) 
      {
	int fontid=2;
	C2F(dr1)("xset","font",&fontid,&v,
		 PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0,0L,0L);
	MG->GG.modified = 1;
      }
    
    snodeDiam = MG->Graph->nodeDiam;
    if (sscanf(result[i],"%d",&v) > 0)
      MG->Graph->nodeDiam = v; i++;
    if (MG->Graph->nodeDiam < 2) MG->Graph->nodeDiam = snodeDiam;
    if (MG->Graph->nodeDiam != snodeDiam) MG->GG.modified = 1;
    
    snodeW = MG->Graph->nodeBorder;
    if (sscanf(result[i],"%d",&v) > 0)
      MG->Graph->nodeBorder = v; i++;
    if (MG->Graph->nodeBorder <= 0 || 
	MG->Graph->nodeBorder > MG->Graph->nodeDiam/2) 
      MG->Graph->nodeBorder = snodeW;
    if (MG->Graph->nodeBorder != snodeW) MG->GG.modified = 1;
    
    sarcW = MG->Graph->arcWidth;
    if (sscanf(result[i],"%d",&v) > 0)
      MG->Graph->arcWidth = v; i++;
    if (MG->Graph->arcWidth <= 0) MG->Graph->arcWidth = sarcW;
    if (MG->Graph->arcWidth != sarcW) MG->GG.modified = 1;
    
    sarcH = MG->Graph->arcHiWidth;
    if (sscanf(result[i],"%d",&v) > 0)
      MG->Graph->arcHiWidth = v; i++;
    if (MG->Graph->arcHiWidth <= 0) MG->Graph->arcHiWidth = sarcH;
    if (MG->Graph->arcHiWidth != sarcH) MG->GG.modified = 1;
    
    if (MG->GG.modified) {
      p = MG->Graph->arcs->first;
      while (p) {
	SetCoordinatesArc(MG,(arc*)p->element);
	p = p->next;
      }
      redraw = 1;
    }
    
    if (redraw) {
      /* redraw the graph with new computed scales */
      ComputeBox(MG);
      scig_replay(MG->win);
    }
  }
}

void UnhiliteAll(MG)
     MetanetGraph *MG;
{
  arc *a1;
  node *n1;
  mylink *p;

  p = MG->GG.hilited_arcs->first;
  while(p) {
    a1 = (arc*)(p->element);
    UnhiliteArc1(MG,a1);
    p = p->next;
  }
  MG->GG.n_hilited_arcs = 0;
  /* destroy the previous links */
  DestroyLinks(MG->GG.hilited_arcs->first);
  MG->GG.hilited_arcs->first = 0;

  p = MG->GG.hilited_nodes->first;
  while(p) {
    n1 = (node*)(p->element);
    n1->hilited = 0;
    UnhiliteNode1(MG,n1);
    p = p->next;
  }
  MG->GG.n_hilited_nodes = 0;
  /* destroy the list links */
  DestroyLinks(MG->GG.hilited_nodes->first);
  MG->GG.hilited_nodes->first = 0;
}

/*-------------------------------------------------------
 * Compute scales such that the full graph will fit into
 * the graphic window 
 *-------------------------------------------------------*/

int ComputeBox(MG)
     MetanetGraph *MG;
{
  double x,y,xmax,ymax,nn;
  mylink *p;
  node *n;
  p = MG->Graph->nodes->first;
  n = (node*)p->element;
  x =  n->x ;
  nn = NodeDiam(MG,n);
  xmax =  n->x + NodeDiam(MG,n);
  y =  n->y - NodeDiam(MG,n);
  ymax =  n->y ;
  while (p) {
    n = (node*)p->element;
    x = Min(x, n->x ) ;
    xmax = Max(xmax, n->x + NodeDiam(MG,n));
    y = Min(y, n->y - NodeDiam(MG,n));
    ymax = Max(ymax, n->y);
    nn = Max(nn,NodeDiam(MG,n));
    p = p->next;
  }
  x -= nn; y -= nn;
  xmax += nn; ymax += nn;
  NewScales(MG,(int)x,(int)y,(int)xmax,(int)ymax);
  return 0;
}


static void graph_loop( MG, p, f) 
     MetanetGraph *MG;
     mylink *p; 
     void (*f) _PARAMS((void *,void *));
{
  while (p) { 
    (*f)(MG, p->element ) ;
    p = p->next;
  }
}

/*---------------------------------------------------------
 * Utility function 
 *---------------------------------------------------------*/

int scig_driverX11(old)
     char *old;
{
  GetDriver1(old,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( old[0] == 'R' ) 
    {
      C2F(SetDriver)("X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
      return 1;
    }
  return 0;
}


/*---------------------------------------------------------
 * Utility function 
 *---------------------------------------------------------*/

void graph_zoom_get_rectangle(bbox)
     double bbox[4];
{
  char old[4];
  GetDriver1(old,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  if ( old[0] == 'R' ) 
    C2F(SetDriver)("X11",PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
  zoom_get_rectangle(bbox);
  C2F(SetDriver)(old,PI0,PI0,PI0,PI0,PI0,PI0,PD0,PD0,PD0,PD0);
}

