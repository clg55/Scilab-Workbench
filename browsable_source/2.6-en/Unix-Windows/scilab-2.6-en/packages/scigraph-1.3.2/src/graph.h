#ifndef __METANET_GRAPH 
#define  __METANET_GRAPH 
#include "machine.h"

#include <stdio.h>

typedef int node_type;
#define PLAIN 0
#define SINK 1
#define SOURCE 2

#define LOOP 1000
#define HIDDEN -9999

#define MAXARCS 21
#define ERRTYPE -9999

#define MAXNAM 1024 

/*---------------------------------
 * A graph node 
 *--------------------------------*/

typedef struct nodedef {
  int number;
  char *name;
  char *label;
  char *work;
  list *connected_arcs;
  list *loop_arcs;
  double demand;
  node_type type;
  int x, y;
  int col;
  int diam;
  int border;
  int fontSize;
  int hilited;
} node, *nodeptr;


/*---------------------------------
 * An arc 
 *--------------------------------*/

typedef struct arcdef {
  int number;
  char *name;
  char *label;
  char *work ; /* internal use */
  node *head;
  node *tail;
  double unitary_cost;
  double minimum_capacity;
  double maximum_capacity;
  double length;
  double quadratic_weight;
  double quadratic_origin;
  double weight;
  int g_type;
  int x0, y0, x1, y1, x2, y2, x3, y3, xmax, ymax, xa0, ya0,
  xa1, ya1, xa2, ya2;
  double si, co;
  int col;
  int width;
  int hiWidth;
  int fontSize;
  int hilited;
} arc, *arcptr;
 


/*---------------------------------
 * A graph
 *--------------------------------*/

typedef struct graphdef {
  char name[MAXNAM];
  int directed;
  int node_number;
  int arc_number;
  int sink_number;
  int source_number;
  list *sinks; 
  list *sources;
  list *arcs; /* in decreasing order of arc numbers */
  list *nodes; /* in decreasing order of node numbers */
  int arcArraysize;
  int nodeArraysize;
  arc **arcArray;
  node **nodeArray;
  int nodeDiam;
  int nodeBorder;
  int arcWidth;
  int arcHiWidth;
  int fontSize;
} graph;

/*---------------------------------
 * A graph Graphic context 
 *--------------------------------*/

typedef struct GG {
  int n_hilited_arcs;
  int n_hilited_nodes;
  list *hilited_arcs;
  list *hilited_nodes;
  node *moving;
  int modified;
} GG;


/*---------------------------------
 * A metanet graph 
 *--------------------------------*/

typedef struct metanet_graph {
  int win;
  int drawHeight;
  int drawWidth;
  int drawX;
  int drawY;
  int intDisplay;
  int nodeNameDisplay;
  int arcNameDisplay;
  int arcStrDisplay;
  int nodeStrDisplay;
  int menuId;
  int but3f;
  int moveflag;
  graph *Graph;
  graph *oldGraph;
  GG    GG;
} MetanetGraph;


#define NodeDiam(mg,n) ((n->diam) ? (n->diam) : ((mg)->Graph->nodeDiam))
#define NodeBorder(mg,n) ((n->border) ? (n->border) : ((mg)->Graph->nodeBorder))
#define NodeFontSize(mg,n) ((n->fontSize) ? (n->fontSize) :((mg)->Graph->fontSize))

#define ArcWidth(mg,a) ((a->width) ? (a->width) : ((mg)->Graph->arcWidth))
#define ArcHiWidth(mg,a) ((a->hiWidth) ? (a->hiWidth) : ((mg)->Graph->arcHiWidth))
#define ArcFontSize(mg,n) ((a->fontSize) ? (a->fontSize) : ((mg)->Graph->fontSize))


/* nodes */

extern void InfoNode _PARAMS((MetanetGraph *MG,node *n));
extern void PrintNode _PARAMS(( MetanetGraph *MG,node *n, int level));
extern void DrawNode _PARAMS((MetanetGraph *, node *n));
extern void EraseNode _PARAMS((MetanetGraph *,node *n));
extern void HiliteNode _PARAMS((MetanetGraph *,node *n));
extern void HiliteNode1 _PARAMS((MetanetGraph *,node *n));
extern node *NodeAlloc _PARAMS((int i));
extern void UnhiliteNode _PARAMS((MetanetGraph *,node *n));
extern void UnhiliteNode1 _PARAMS((MetanetGraph *,node *n));


/* arcs */

extern void InfoArc _PARAMS((MetanetGraph *MG,arc *a));
extern void PrintArc _PARAMS(( MetanetGraph *MG,arc *a, int level));
extern void SetCoordinatesArc _PARAMS((MetanetGraph *MG,arc *a));
extern arc *ArcAlloc _PARAMS((int i));
extern void DrawArc _PARAMS((MetanetGraph *,arc *a));
extern void EraseArc _PARAMS((MetanetGraph *,arc *a));
extern void HiliteArc _PARAMS((MetanetGraph *,arc *a));
extern void HiliteArc1 _PARAMS((MetanetGraph *,arc *a));
extern void UnhiliteArc _PARAMS((MetanetGraph *,arc *a));
extern void UnhiliteArc1 _PARAMS((MetanetGraph *,arc *a));


/* graph */

extern void DestroyGraph _PARAMS((graph *g));
extern void DrawGraph _PARAMS(( MetanetGraph *MG));
extern graph *DuplicateGraph _PARAMS((graph *oldg));
extern graph *GraphAlloc _PARAMS((char *n));
extern arc *AddArc _PARAMS(( MetanetGraph *MG,node *t, node *h));
extern node *AddNode _PARAMS(( MetanetGraph *MG,int x, int y));
extern arc *GetArc _PARAMS((int n, graph *g));
extern node *GetNode _PARAMS((int n, graph *g));
extern void MakeArraysGraph _PARAMS((graph *g));



#endif /**  __METANET_GRAPH  **/

