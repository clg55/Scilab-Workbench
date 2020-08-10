#include "list.h"
#include "graph.h"
#include "color.h"
#include "metio.h"
#include "functions.h"

#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#else
#include "menusX/men_scilab.h"
#endif

static char* items[] = {
  "colors", "1","2","3","4","5","6","7","8","9",
  "10","11", "12","13","14","15","16","17","18","19",
  "20","21", "22","23","24","25","26","27","28","29",
  NULL
};

static int defch[]={1};
static int nitems= 1;

void ColorArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  int rep;
  if (( rep = SciChoice("Choose a color",items,defch,nitems)) < 0 )
    return;
  a->col = defch[0];
  DrawArc(MG,a);
}

void ColorNode(MG,n)
     MetanetGraph *MG;
     node *n;
{
  int rep;
  if (( rep = SciChoice("Choose a color",items,defch,nitems)) < 0 )
    return;
  n->col = defch[0];
  DrawNode(MG,n);
}

void ColorObject(MG)
     MetanetGraph *MG;
{
  if (MG->GG.n_hilited_nodes == 0 && MG->GG.n_hilited_arcs == 1) {
    ColorArc(MG,(arc*)MG->GG.hilited_arcs->first->element);
    MG->GG.modified = 1;
  }
  else if (MG->GG.n_hilited_nodes == 1 && MG->GG.n_hilited_arcs == 0) {
    ColorNode(MG,(node*)MG->GG.hilited_nodes->first->element);
    MG->GG.modified = 1;
  }
}








