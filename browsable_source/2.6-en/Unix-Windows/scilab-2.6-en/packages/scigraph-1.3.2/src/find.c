#ifdef __STDC__
#include <stdlib.h>
#else 
#ifdef WIN32 
#include <stdlib.h>
#endif 
#endif

#include <string.h>
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "graphics.h"
#include "functions.h"

void FindNode(MG)
     MetanetGraph *MG;
{
  char strn[MAXNAM];
  int n;
  mylink *p; node *nod, *nod1;

  if (MG->Graph->node_number == 0) return;
  
  if (MG->intDisplay) {
    sprintf(Description,"%s","Node internal number");
    if (!MetanetDialog("",strn,Description)) return;
    n = atoi(strn);
    if (n <= 0 || n > MG->Graph->node_number) {
      sprintf(Description,"%d is not an internal node number",n);
      MetanetAlert();
      return;
    }
    p = MG->Graph->nodes->first;
    nod = 0;
    while (p) {
      if (((node*)(p->element))->number == n) {
	nod = (node*)(p->element);
	break;
      }
      p = p->next;
    }
    if (nod == 0) {
      sprintf(Description,"%s is not an internal node number",strn);
      MetanetAlert();
      return;
    }
  }
  else {
    sprintf(Description,"%s","Node name");      
    if (!MetanetDialog("",strn,Description)) return;
    p = MG->Graph->nodes->first;
    nod = 0;
    while (p) {
      nod1 = (node*)(p->element);
      if (nod1->name != 0 && !strcmp(nod1->name,strn)) {
	nod = nod1;
	break;
      }
      p = p->next;
    }
    if (nod == 0) {
      sprintf(Description,"%s is not a node name",strn);
      MetanetAlert();
      return;
    }
  }
  
  UnhiliteAll(MG);
  HiliteNode(MG,nod);
}

int NodeVisible(MG,n)
     MetanetGraph *MG;
     node *n;
{
  int dx, dy, w, h;
  
  GetDrawGeometry(MG,&dx,&dy,&w,&h);

  if ((int)(n->x) >= dx &&
      (int)((n->x + NodeDiam(MG,n))) <= dx + w &&
      (int)(n->y) >= dy && 
      (int)((n->y + NodeDiam(MG,n))) <= dy + h)
    return 1;
  else return 0;
}

void FindArc(MG)
     MetanetGraph *MG;
{
  char strn[MAXNAM];
  int n;
  mylink *p; arc *a,*a1;

  if (MG->Graph->arc_number == 0) return;
 
  if (MG->intDisplay) {
    sprintf(Description,"%s","Arc internal number");
    if (!MetanetDialog("",strn,Description)) return;
    n = atoi(strn);
    if (n <= 0 || n > MG->Graph->arc_number) {
      sprintf(Description,"%d is not an internal arc number",n);
      MetanetAlert();
      return;
    }
    p = MG->Graph->arcs->first;
    a = 0;
    while (p) {
      a1 = (arc*)(p->element);
      if (a1->number == n) {
	a = a1;
	break;
      }
      p = p->next;
    }
    if (a == 0) {
      sprintf(Description,"%s is not an internal arc number",strn);
      MetanetAlert();
      return;
    }
  }
  else {
    sprintf(Description,"%s","Arc name");      
    if (!MetanetDialog("",strn,Description)) return;
    p = MG->Graph->arcs->first;
    a = 0;
    while (p) {
      a1 = (arc*)(p->element);
      if (a1->name != 0 && !strcmp(a1->name,strn)) {
	a = a1;
	break;
      }
      p = p->next;
    }
    if (a == 0) {
      sprintf(Description,"%s is not an arc name",strn);
      MetanetAlert();
      return;
    }
  }

  UnhiliteAll(MG);
  HiliteArc(MG,a);
}

int ArcVisible(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  int dx, dy, w, h;
  
  GetDrawGeometry(MG,&dx,&dy,&w,&h);

  if (NodeVisible(MG,a->tail) && NodeVisible(MG,a->head) &&
      (int)(a->xmax) >= dx && (int)(a->xmax) <= dx + w &&
      (int)(a->ymax) >= dy && (int)(a->ymax) <= dy + h)
    return 1;
  else return 0;
}
