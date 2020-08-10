#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#else
#include "menusX/men_scilab.h"
#endif

#include <stdio.h>
#ifndef __MSC__
#include <dirent.h>
#else 
#include <direct.h>
#endif

#include "graphics/Math.h"
#include <string.h>

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "menus.h"
#include "functions.h"
#include "graphics.h"

int Named(MG)
     MetanetGraph *MG;
{
  list *unnamed_arc, *unnamed_node;
  int i = 0;
  mylink *p;
  arc *a; node *n;

  unnamed_arc = ListAlloc();
  unnamed_node = ListAlloc();
  p = MG->Graph->arcs->first;
  while (p) {
    a = (arc*)p->element;
    if (a->name == 0) {
      AddListElement((ptr)a,unnamed_arc);
      i++;
    }
    p = p->next;
  }
  p = MG->Graph->nodes->first;
  while (p) {
    n = (node*)p->element;
    if (n->name == 0) {
      AddListElement((ptr)n,unnamed_node);
      i++;
    }
    p = p->next;
  }
  if (i != 0) {
    REMOVE_REC_DRIVER();
    /* first hilite arcs */
    p = unnamed_arc->first;
    while (p) {
      HiliteArc(MG,(arc*)p->element);
      p = p->next;
    }
    /* then hilite nodes */
    p = unnamed_node->first;
    while (p) {
      HiliteNode(MG,(node*)p->element);
      p = p->next;
    }
    sprintf(Description,"The highlighted nodes and/or arcs have not been named");
    MetanetAlert();
    p = unnamed_arc->first;
    while (p) {
      UnhiliteArc(MG,(arc*)p->element);
      p = p->next;
    }
    p = unnamed_node->first;
    while (p) {
      UnhiliteNode(MG,(node*)p->element);
      p = p->next;
    }
    RESTORE_DRIVER();
    return 0;
  }
  return 1;
}

int SaveGraph(MG)
     MetanetGraph *MG;
{
  FILE *fo;
  char fname[2 * MAXNAM],*gname;
  int ierr=0,rep;
  static char *init ="*.graph";
  char *res = NULL;

  if (MG->Graph->arc_number < 1) 
    {
      sprintf(Description,"Graph %s must at least have one arc",
	      MG->Graph->name);
      MetanetAlert();
      return 0;
    }
  if (MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) {
    UnhiliteAll(MG);
  }
  
  if (!Named(MG)) return 0;
  
  RenumberGraph(MG->Graph);
  sprintf(Description,"Graph %s renumbered\n",MG->Graph->name);
  AddMessage(Description);

  MakeArraysGraph(MG->Graph);

  rep = GetFileWindow(init,&res,".",0,&ierr,"Load a graph");
  if ( ierr >= 1 || rep == FALSE ) 
    return 0;
  strcpy(fname,res) ;
  FREE(res);
  fo = fopen(fname,"w");
  if (fo == NULL) {
    sprintf(Description,
	    "Unable to write file %s\nCheck access",fname);
    MetanetAlert();
    return 0;
  }

  gname = mybasename(fname);
  strcpy(MG->Graph->name,MStripGraph(gname));

  WriteGraphToGraphFile(fo,MG->Graph);
  fclose(fo);

  sprintf(Description,"Graph %s saved\n",MG->Graph->name);
  AddMessage(Description);

  MG->GG.modified = 0;
  MG->oldGraph = DuplicateGraph(MG->Graph);
  return 1;
}

void WriteGraphToGraphFile(f,g)
FILE *f;
graph *g;
{
  int i;
  arc *a;

  fprintf(f,"GRAPH TYPE (0 = UNDIRECTED, 1 = DIRECTED), DEFAULTS (NODE DIAMETER, NODE BORDER, ARC WIDTH, HILITED ARC WIDTH, FONTSIZE):\n");
  fprintf(f,"%d %d %d %d %d %d\n",g->directed,g->nodeDiam,g->nodeBorder,
	  g->arcWidth,g->arcHiWidth,g->fontSize);
  if (g->directed) fprintf(f,"NUMBER OF ARCS:\n");
  else fprintf(f,"NUMBER OF EDGES:\n");
  fprintf(f,"%d\n",g->arc_number);
  fprintf(f,"NUMBER OF NODES:\n");
  fprintf(f,"%d\n",g->node_number);
  fprintf(f,"****************************************\n");
  if (g->directed) {
    fprintf(f,"DESCRIPTION OF ARCS:\n");
    fprintf(f,"ARC NAME, TAIL NODE NAME, HEAD NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  else {
    fprintf(f,"DESCRIPTION OF EDGES:\n");
    fprintf(f,"EDGE NAME, NODE NAME, NODE NAME, COLOR, WIDTH, HIWIDTH, FONTSIZE\n");
  }
  fprintf
    (f,"COST, MIN CAP, MAX CAP, LENGTH, Q WEIGHT, Q ORIGIN, WEIGHT\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->arc_number; i++) {
    a = GetArc(i,g);
    WriteArcToGraphFile(f,a);
  }
  fprintf(f,"****************************************\n");
  fprintf(f,"DESCRIPTION OF NODES:\n");
  fprintf(f,"NODE NAME, POSSIBLE TYPE (1 = SINK, 2 = SOURCE)\n");
  fprintf(f,"X, Y, COLOR, DIAMETER, BORDER, FONTSIZE\n");
  fprintf(f,"DEMAND\n");
  fprintf(f,"\n");
  for (i = 1; i <= g->node_number; i++) {
    WriteNodeToGraphFile(f,GetNode(i,g));
  }
} 

void WriteArcToGraphFile(f,a)
FILE *f;
arc *a;
{
  fprintf(f,"%s %s %s %d %d %d %d\n",a->name,a->tail->name,
	  a->head->name,a->col,a->width,a->hiWidth,a->fontSize);
  fprintf(f,"%e %e %e %e %e %e %e\n",
	  a->unitary_cost,a->minimum_capacity,a->maximum_capacity,
	  a->length,a->quadratic_weight,a->quadratic_origin,a->weight);
}

void WriteNodeToGraphFile(f,n)
     FILE *f;
     node *n;
{
  if (n->type == PLAIN)
    fprintf(f,"%s\n",n->name);
  else fprintf(f,"%s %d\n",n->name,n->type);
  fprintf(f,"%d %d %d %d %d %d \n",
	  n->x,n->y,n->col,n->diam,n->border,n->fontSize);
  fprintf(f,"%e\n",n->demand);
}

int RenameSaveGraph(MG) 
     MetanetGraph *MG;
{
  char fname[2 * MAXNAM];
  int ierr=0,rep;
  static char *init ="*.graph";
  char *res = NULL;
  FILE *fo;
  char name[2 * MAXNAM];

  if (MG->Graph->arc_number < 1) {
    sprintf(Description,"Graph %s must at least have one arc",
	    MG->Graph->name);
    MetanetAlert();
    return 0;
  }
  if (MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) {
    UnhiliteAll(MG);
  }

  if (!Named(MG)) return 0;

  rep = GetFileWindow(init,&res,".",0,&ierr,"Load a graph");
  if ( ierr >= 1 || rep == FALSE ) 
    return 0;
  strcpy(fname,res) ;

  strcpy(name,MStripGraph(mybasename(fname)));
  strcpy(MG->Graph->name,name);

  RenumberGraph(MG->Graph);
  sprintf(Description,"Graph %s renumbered\n",MG->Graph->name);
  AddMessage(Description);

  MakeArraysGraph(MG->Graph);

  fo = fopen(fname,"w");
  if (fo == NULL) {
    sprintf(Description, "Unable to write file %s",fname);
    MetanetAlert();
    return 0;
  }

  WriteGraphToGraphFile(fo,MG->Graph);
  fclose(fo);

  sprintf(Description,"Graph %s saved\n",MG->Graph->name);
  AddMessage(Description);
  SetGraphWinName(MG->win,MG->Graph->name);
  SetTitle(MG->win,MG->menuId," ");
  MG->GG.modified = 0;
  return 1;
}
