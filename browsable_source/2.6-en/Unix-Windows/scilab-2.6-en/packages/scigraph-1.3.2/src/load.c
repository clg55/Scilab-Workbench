/*---------------------------------------------------
 * Load graphs files 
 *--------------------------------------------------*/

#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#else
#include "menusX/men_scilab.h"
#endif

#include <math.h>
#include <stdio.h>
#include <string.h>

#ifndef __MSC__
#include <dirent.h>
#else 
#include <direct.h>
#endif

#include "graphics/Math.h"
#include "defs.h"
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "metio.h"
#include "color.h"
#include "functions.h"
#include "mysearch.h"

#define MIN(a,b) ((a) < (b) ? (a) : (b)) 

static ENTRY nodeH,*found;

static MetanetGraph *ReadGraphFromGraphFile _PARAMS((FILE *fg));
static int ReadArcFromGraphFile _PARAMS((int n, FILE *fg, graph *g));
static void ReadNodeFromGraphFile _PARAMS((FILE *fg, graph *g, int inode));
static int ComputeValues _PARAMS((MetanetGraph *));
static void ComputeCoord _PARAMS((MetanetGraph *,node *nod, int n));

/*------------------------------------------------------------------
 * create a new graph empty graph 
 *-----------------------------------------------------------------*/

MetanetGraph *NewGraph (win)
     int win;
{
  MetanetGraph *MG;
  char name[MAXNAM];
  sprintf(Description,"Graph name : ");
  if (!MetanetDialog("",name,Description)) return NULL;
  if (strcmp(name,"") == 0) return NULL;
  if ((MG=AllocMetanetGraph(name) ) == NULL) 
    {
      sprintf(Description,"Running out of memory\ngraph allocation failed");
      MetanetAlert();
      return NULL;
    }
  sprintf(Description,"Is the graph directed ?");
  MG->Graph->directed = MetanetYesOrNo();
  MG->win = win;
  set_graph_win(win,MG);
  ClearDraw(MG->win);
  ModifyGraph(MG);
  return MG ;
}

/*------------------------------------------------------------------
 * Load a graph and store the graph in the graph list 
 * at position win (window number )
 * graphic scales are changed too
 * The graph file i searched through menus 
 *--------------------------------------------------------------------*/

MetanetGraph *LoadGraph(win)
     int win;
{
  MetanetGraph *MG;
  char fname[2*MAXNAM];
  int ierr=0,rep;
  static char *init ="*.graph";
  char *res = NULL;
  rep = GetFileWindow(init,&res,".",0,&ierr,"Load a graph");
  if ( ierr >= 1 || rep == FALSE ) 
    return NULL;
  strcpy(fname,res) ;
  FREE(res);
  if ((MG = LoadComputeGraph(win,fname))==NULL) return NULL;
  set_graph_win(win,MG);
  return MG; /* this function could be void  */
}

/*------------------------------------------------------------------
 * Load a graph and store the graph in the graph list 
 * at position win (window number )
 * graphic scales are changed too
 *--------------------------------------------------------------------*/

MetanetGraph *LoadComputeGraph(win,name)
     int win;
     char *name;
{
  MetanetGraph *MG;
  char *gname;
  FILE *fg;
  if (( fg = fopen(name,"r")) == NULL) 
    {
      sprintf(Description,"File \"%s\" cannot be opened for read operation",name);
      MetanetAlert();
      return NULL;
    }
  if ((MG = ReadGraphFromGraphFile(fg)) == NULL) 
    {
      fclose(fg); return NULL;
    };
  MG->win=win;
  gname = mybasename(name);
  strcpy(MG->Graph->name,MStripGraph(gname));
  fclose(fg);
  if(!ComputeValues(MG)) return 0;
  ClearDraw(MG->win);
  DisplayMenu(MG->win,STUDY);
  ComputeBox(MG);
  DrawGraph(MG);
  SetGraphWinName(MG->win,MG->Graph->name);
  return MG;
}


static MetanetGraph *ReadGraphFromGraphFile(fg)
     FILE *fg;
{
  MetanetGraph *MG;
  graph *g;
  char line[5 * MAXNAM];
  int i;
  char **lar;
  node *nod;
  /* Allocate space */
  if ((MG= AllocMetanetGraph(""))==NULL) return NULL;
  g = MG->Graph;

  /* Read from graph file */

  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d %d %d %d %d %d",&(g->directed),
	 &(g->nodeDiam),&(g->nodeBorder),
	 &(g->arcWidth),&(g->arcHiWidth),&(g->fontSize));
  if (g->nodeDiam <= 0) g->nodeDiam = NODEDIAM;
  if (g->nodeBorder <= 0) g->nodeBorder = NODEW;
  if (g->arcWidth <= 0) g->arcWidth = ARCW;
  if (g->arcHiWidth <= 0) g->arcHiWidth = ARCH;
  if (FontSelect(g->fontSize) == -1) g->fontSize = DRAWFONTSIZE;
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d",&(g->arc_number));
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d",&(g->node_number));
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  for (i = 1; i <= g->arc_number; i++)
    AddListElement((ptr)ArcAlloc(i),g->arcs);
  for (i = 1; i <= g->node_number; i++)
    AddListElement((ptr)NodeAlloc(i),g->nodes);
  MakeArraysGraph(g);

  /* jump to node description */
  for (i = 0; i < 2 * g->arc_number; i++)
    fgets(line,5 * MAXNAM,fg);

  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);
  fgets(line,5 * MAXNAM,fg);

  myhcreate(g->node_number);
  for (i = 0; i < g->node_number; i++)
    ReadNodeFromGraphFile(fg,g,i + 1);

  /* check uniqueness of node names */
  if (g->node_number != 1) {
    if ((lar = (char **)MALLOC(sizeof(char *) * (g->node_number + 1))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return 0;
    }
    for (i = 0; i < g->node_number; i++) {
      nod = GetNode(i + 1,g);
      lar[i] = nod->name;
    }
    lar[g->node_number] = 0;
    SortLarray(lar);
    for (i = 0; i < g->node_number - 1; i++) {
      if (!strcmp(lar[i],lar[i+1])) {
	sprintf(Description,
		"Bad graph file. Node \"%s\" is duplicated",lar[i]);
	MetanetAlert();
	free(lar);
	return 0;
      }
    }
    if (!strcmp(lar[g->node_number - 2],lar[g->node_number - 1])) {
      sprintf(Description,
	      "Bad graph file. Node \"%s\" is duplicated",
	      lar[g->node_number - 2]);
      MetanetAlert();
      free(lar);
      return 0;
    }
    free(lar);
  }

  /* rewind and go to arc description */
  rewind(fg);
  for (i = 0; i < 11; i++)
    fgets(line,5 * MAXNAM,fg);

  for (i = 0; i < g->arc_number; i++) {
    if (!ReadArcFromGraphFile(i+1,fg,g)) return 0;
  }
  myhdestroy();
  return MG;
}


static int ReadArcFromGraphFile(n,fg,g)
     int n;
     FILE *fg;
     graph *g;
{
  char line[5 * MAXNAM];
  char name[MAXNAM], tail_name[MAXNAM], head_name[MAXNAM];
  int col, width, hiwidth, fontsize;
  arc *a;
  node *tail, *head;

  col = 0; width = 0; hiwidth = 0; fontsize = 0;
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%s %s %s %d %d %d %d\n",name,tail_name,head_name,
	 &col,&width,&hiwidth,&fontsize);
  
  a = GetArc(n,g);
    
  /* link number to name */
  if ((a->name = 
       (char*)MALLOC((unsigned)(strlen(name) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(a->name,name);
  
  if ((nodeH.key = (char *)MALLOC((unsigned)strlen(head_name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(nodeH.key,head_name);
  found = myhsearch(nodeH,FIND);
  if (found == NULL) {
    sprintf(Description,
	    "Bad graph file. Node \"%s\" referenced by arc \"%s\" not found",
	    head_name,a->name);
    MetanetAlert();
    return 0;
  }
  
  head = (node *)found->data;
  if ((nodeH.key = (char *)MALLOC((unsigned)strlen(tail_name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return 0;
  }
  strcpy(nodeH.key,tail_name);
  found = myhsearch(nodeH,FIND);
  if (found == NULL) {
    sprintf(Description,
	    "Bad graph file. Node \"%s\" referenced by arc \"%s\" not found",
	    tail_name,a->name);
    MetanetAlert();
    return 0;
  }
  tail = (node *)found->data;

  if (tail == 0 || head == 0) {
    sprintf(Description,"Bad node name while reading arc %d in graph file\n",
	    n);
    MetanetAlert();  
    return 0;
  }
  a->tail = tail; a->head = head; 
  a->col = col;
  if (width < 0) width = 0; a->width = width; 
  if (hiwidth < 0) hiwidth = 0; a->hiWidth = hiwidth; 
  if (FontSelect(fontsize) == -1) fontsize = 0; a->fontSize = fontsize;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le %le %le %le %le %le %le",
	 &(a->unitary_cost),
	 &(a->minimum_capacity),
	 &(a->maximum_capacity),
	 &(a->length),
	 &(a->quadratic_weight),
	 &(a->quadratic_origin),
	 &(a->weight));
  return 1;
}

static void ReadNodeFromGraphFile(fg, g, inode)
     FILE *fg;
     graph *g;
     int inode;
{
  char line[5 * MAXNAM];
  char name[MAXNAM];
  int type = 0;
  node *nod;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%s %d",name,&type);
  nod = GetNode(inode,g);
  if ((nod->name = 
       (char*)MALLOC((unsigned)(strlen(name) + 1)*sizeof(char))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(nod->name,name);

  if ((nodeH.key = (char *)MALLOC((unsigned)strlen(name)+1)) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  strcpy(nodeH.key,name);
  if ((nodeH.data = (char *)MALLOC((unsigned)sizeof(node))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return;
  }
  nodeH.data = (char *)nod;
  myhsearch(nodeH,ENTER);

  nod->type = type;
  if (nod->type == SOURCE) {
    g->source_number++;
    AddListElement((ptr)nod,g->sources);
  }
  if (nod->type == SINK) {
    g->sink_number++;
    AddListElement((ptr)nod,g->sinks);
  }
  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%d %d %d %d %d %d",&(nod->x),&(nod->y),&(nod->col),
	 &(nod->diam),&(nod->border),&(nod->fontSize));
  nod->col = nod->col;
  if (nod->diam < 0) nod->diam = 0;
  if (nod->border < 0) nod->border = 0;
  if (FontSelect(nod->fontSize) == -1) nod->fontSize = 0;

  fgets(line,5 * MAXNAM,fg);
  sscanf(line,"%le",&(nod->demand));
}

/*----------------------------------------------------
 * Compute Coordinates of node and args if they have 
 * 0 coordinates 
 * MG dimensions must be set 
 *----------------------------------------------------*/

static int ComputeValues(MG)
     MetanetGraph *MG;
{
  graph *g=MG->Graph;
  mylink *p;
  node *n, *tail, *head;
  int c;
  arc *a;
  int iscoord;

  p = g->nodes->first;
  /* if all nodes have coordinates equal to 0, compute new ones */
  iscoord = 0;
  while (p) {
    n = (node*)p->element;
    if ((n->x != 0) || (n->y != 0)) {
      iscoord = 1;
      break;
    }
    p = p->next;
  }

  p = g->nodes->first;
  if (!iscoord) {
    while (p) {
      n = (node*)p->element;
      ComputeCoord(MG,n,g->node_number);
      p = p->next;
    }
  }

  p = g->arcs->first;
  while (p) {
    a = (arc*)p->element;
    tail = a->tail;
    head = a->head;
    c = ComputeNewType(tail,head);
    if (c == ERRTYPE) return 0;
    a->g_type = c;
    SetCoordinatesArc(MG,a);
    if (tail == head) AddListElement((ptr)a,tail->loop_arcs);
    else {
      AddListElement((ptr)a,tail->connected_arcs);
      AddListElement((ptr)a,head->connected_arcs);
    }
    p = p->next;
  }
  return 1;
}

static void ComputeCoord(MG,nod,n)
     MetanetGraph *MG;
     node *nod;
     int n;
{
  int i, xnumber, ynumber, pas, xi, yi, maxn;
  int dx, dy, w, h;
  double ww,hh,sqr;
  
  if (n == 1) {
    nod->x = 2 * NodeDiam(MG,nod);
    nod->y = 2 * NodeDiam(MG,nod);
    return;
  }

  GetDrawGeometry(MG,&dx,&dy,&w,&h);
  ww = (double)(w - 4 * NodeDiam(MG,nod)); hh = (double)(h - 4 * NodeDiam(MG,nod));
  maxn = (int)((ww/NodeDiam(MG,nod) + 1)/2 * (hh/NodeDiam(MG,nod) + 1)/2);
  if (n > maxn) {
    ww = (double)(w  - 4 * NodeDiam(MG,nod)); 
    hh = (double)(h  - 4 * NodeDiam(MG,nod));
  }
  /* xnumber = number of nodes in a row */
  sqr = sqrt((ww-hh)*(ww-hh)+4*n*(NodeDiam(MG,nod)*(NodeDiam(MG,nod)-ww-hh)+ww*hh));
  xnumber = (int)((ww - hh - sqr)/(NodeDiam(MG,nod)-hh)/2) + 1;
  ynumber = n / xnumber + 1;
  /* pas = distance between 2 nodes */
  pas = MIN(((int)ww - NodeDiam(MG,nod)*xnumber)/(xnumber - 1),
	    ((int)hh - NodeDiam(MG,nod)*ynumber)/(ynumber - 1));

  i = nod->number - 1;
  xi = i % xnumber;
  yi = i / xnumber;

  nod->x = 2 * NodeDiam(MG,nod) + xi * (NodeDiam(MG,nod) + pas);
  nod->y = 2 * NodeDiam(MG,nod) + yi * (NodeDiam(MG,nod) + pas);
}



/*---------------------------------------------------
 * Load a binary representation of a graph stored in a file 
 * This is used when Scilab send a Graph 
 * Graphic scales are changed in such a way that the graph must fit 
 * in the current window 
 *--------------------------------------------------*/

#define ReadAlloc(V,size,number,file)  \
  if ((V = MALLOC((unsigned) size*number))== NULL) \
    { sciprint("Running out of memory\n"); \
    return 0; } \
  ifread= fread((char *) V,size,number,file); \
  if ( ifread != number ) \
    { sciprint("failed to read graph \n"); \
    return 0; } 

MetanetGraph * LoadCommGraph(win,b, sup)
     char *b;
     int sup;
{
  MetanetGraph *MG,*MGold;

  int directed,n,ma,*he,*ta,ifread;
  double scale;
  int *ntype,*xnode,*ynode,*ncolor,*ndiam,*nborder,*nfontsize;
  double *demand;
  int *acolor,*awidth,*ahiwidth,*afontsize; 
  double *length,*cost,*mincap,*maxcap,*qweight,*qorig,*weight;
  int gndiam,gnborder,gawidth,gahiwidth,gfontsize;
  FILE* f;
  int i,ln;
  /* char *name; */
  char **nameEdgeArray,**nameNodeArray;
  char **labelEdgeArray,**labelNodeArray;
  int is_elabel, is_nlabel;
  node *nod;
  arc *a;
  int isize = sizeof(int);
  int dsize = sizeof(double);
  int csize = sizeof(char);

  if ((MGold = get_graph_win (win)) != NULL) 
    {
      if (sup == 0) {
	if ((MGold->menuId == STUDY) || (MGold->menuId == MODIFY)) {
	  sprintf(Description,"There is already a loaded graph");
	  MetanetAlert();
	  return NULL;
	}
      }
      else {
	if (MGold->menuId == MODIFY) {
	  sprintf(Description,"There is a modified graph");
	  MetanetAlert();
	  return NULL;
	}
	if (MGold->menuId == STUDY) StudyQuit(win);
      }
    }

  f = fopen(b,"rb");
  if (f == NULL) {
    sprintf(Description,
	    "Unable to read transmited graph in file \"%s\" ",b);
    MetanetAlert();
    return NULL;
  }

  /* directed */
  fread((char*)&directed,isize,1,f);

  /* scale */
  fread((char*)&scale,dsize,1,f);

  /* n */
  fread((char*)&n,isize,1,f);

  /* ma */
  fread((char*)&ma,isize,1,f);

  /* tail */
  ReadAlloc(ta,isize,ma,f);
  /* head */
  ReadAlloc(he,isize,ma,f);

  /* node_name */
  if ((nameNodeArray = 
       (char**)MALLOC((unsigned)n*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return NULL;
  }
  for (i = 0; i < n; i++) {
    fread((char*)&ln,isize,1,f);
    if ((nameNodeArray[i] = (char *)MALLOC((unsigned)ln + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return NULL;
    }    
    fread(nameNodeArray[i],csize,ln+1,f);
  }

  /* node_type */
  ReadAlloc(ntype,isize,n,f);
  /* node_x */
  ReadAlloc(xnode,isize,n,f);
  /* node_y */
  ReadAlloc(ynode,isize,n,f);
  /* node_color */
  ReadAlloc(ncolor,isize,n,f);
  /* node_diam */
  ReadAlloc(ndiam,isize,n,f);
  /* node_border */
  ReadAlloc(nborder,isize,n,f);
  /* node_font_size */
  ReadAlloc(nfontsize,isize,n,f);
  /* node_demand */
  ReadAlloc(demand,dsize,n,f);
  /* edge_name */
  if ((nameEdgeArray = 
       (char**)MALLOC((unsigned)ma*sizeof(char*))) == NULL) {
    fprintf(stderr,"Running out of memory\n");
    return NULL;
  }
  for (i = 0; i < ma; i++) {
    fread((char*)&ln,isize,1,f);
    if ((nameEdgeArray[i] = (char *)MALLOC((unsigned)ln + 1)) 
	== NULL) {
      fprintf(stderr,"Running out of memory\n");
    return NULL;
    }    
    fread(nameEdgeArray[i],csize,ln+1,f);
  }

  /* edge_color */
  ReadAlloc(acolor,isize,ma,f);
  /* edge_width */
  ReadAlloc(awidth,isize,ma,f);
  /* edge_hi_width */
  ReadAlloc(ahiwidth,isize,ma,f);
  /* edge_font_size */
  ReadAlloc(afontsize,isize,ma,f);
  /* edge_length */
  ReadAlloc(length,dsize,ma,f);
  /* edge_cost */
  ReadAlloc(cost,dsize,ma,f);
  /* edge_min_cap */
  ReadAlloc(mincap,dsize,ma,f);
  /* edge_max_cap */
  ReadAlloc(maxcap,dsize,ma,f);
  /* edge_q_weight */
  ReadAlloc(qweight,dsize,ma,f);
  /* edge_q_orig */
  ReadAlloc(qorig,dsize,ma,f);
  /* edge_weight */
  ReadAlloc(weight,dsize,ma,f);
  /* default_node_diam */
  fread((char*)&gndiam,isize,1,f);

  /* default_node_border */
  fread((char*)&gnborder,isize,1,f);

  /* default_edge_width */
  fread((char*)&gawidth,isize,1,f);

  /* default_edge_hi_width */
  fread((char*)&gahiwidth,isize,1,f);

  /* default_font_size */
  fread((char*)&gfontsize,isize,1,f);

  /* node_label */
  fread((char*)&is_nlabel,isize,1,f);
  if (is_nlabel) {
    if ((labelNodeArray = 
	 (char**)MALLOC((unsigned)n*sizeof(char*))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return NULL;
    }
    for (i = 0; i < n; i++) {
      fread((char*)&ln,isize,1,f);
      if ((labelNodeArray[i] = (char *)MALLOC((unsigned)ln + 1)) 
	  == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return NULL;
      }    
      fread(labelNodeArray[i],csize,ln+1,f);
    }
  }

  /* edge_label */
  fread((char*)&is_elabel,isize,1,f);
  if (is_elabel) {
    if ((labelEdgeArray = 
	 (char**)MALLOC((unsigned)ma*sizeof(char*))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return NULL;
    }
    for (i = 0; i < ma; i++) {
      fread((char*)&ln,isize,1,f);
      if ((labelEdgeArray[i] = (char *)MALLOC((unsigned)ln + 1)) 
	  == NULL) {
	fprintf(stderr,"Running out of memory\n");
	return NULL;
      }    
      fread(labelEdgeArray[i],csize,ln+1,f);
    }
  }

  fclose(f);

  /* Compute graph */
  /* XXXX : remetre le nom du graphe */
  if ((MG = AllocMetanetGraph("pipo")) == NULL) return NULL;

  MG->Graph->directed = directed;
  MG->Graph->nodeDiam = gndiam;
  MG->Graph->nodeBorder = gnborder;
  MG->Graph->arcWidth = gawidth;
  MG->Graph->arcHiWidth = gahiwidth;
  MG->Graph->fontSize = gfontsize;

  if (MG->Graph->nodeDiam <= 0) MG->Graph->nodeDiam = NODEDIAM;
  if (MG->Graph->nodeBorder <= 0) MG->Graph->nodeBorder = NODEW;
  if (MG->Graph->arcWidth <= 0) MG->Graph->arcWidth = ARCW;
  if (MG->Graph->arcHiWidth <= 0) MG->Graph->arcHiWidth = ARCH;
  if (FontSelect(MG->Graph->fontSize) == -1) 
    MG->Graph->fontSize = DRAWFONTSIZE;

  MG->Graph->arc_number = ma;
  MG->Graph->node_number = n;
  
  for (i = 1; i <= ma; i++)
    AddListElement((ptr)ArcAlloc(i),MG->Graph->arcs);
  for (i = 1; i <= n; i++)
    AddListElement((ptr)NodeAlloc(i),MG->Graph->nodes);
  MakeArraysGraph(MG->Graph);

  /* Nodes */

  for (i = 1; i <= n; i++) {
    nod = GetNode(i,MG->Graph);
    nod->name = nameNodeArray[i-1];
    if (is_nlabel) nod->label = labelNodeArray[i-1];

    nod->type = ntype[i-1];
    if (nod->type == SOURCE) {
      MG->Graph->source_number++;
      AddListElement((ptr)nod,MG->Graph->sources);
    }
    if (nod->type == SINK) {
      MG->Graph->sink_number++;
      AddListElement((ptr)nod,MG->Graph->sinks);
    }

    nod->x = xnode[i-1];
    nod->y = ynode[i-1];
    nod->col = ncolor[i-1];
    nod->diam = ndiam[i-1];
    if (nod->diam < 0) nod->diam = 0;
    nod->border = nborder[i-1];
    if (nod->border < 0) nod->border = 0;
    nod->fontSize = nfontsize[i-1];
    if (FontSelect(nod->fontSize) == -1) nod->fontSize = 0;
    nod->demand = demand[i-1];
  }

  /* Arcs */

  for (i = 1; i <= ma; i++) {
    a = GetArc(i,MG->Graph);
    a->name = nameEdgeArray[i-1];
    if (is_elabel) a->label = labelEdgeArray[i-1];

    a->head = GetNode(he[i-1],MG->Graph);

    a->tail = GetNode(ta[i-1],MG->Graph);

    if (a->tail == 0 || a->head == 0) {
      sprintf(Description,"Bad node name while reading arc %d in graph file\n",
	      i);
      MetanetAlert();  
      return NULL;
    }

    a->col = acolor[i-1];
    a->width = awidth[i-1];
    if (a->width < 0) a->width = 0;
    a->hiWidth = ahiwidth[i-1];
    if (a->hiWidth < 0) a->hiWidth = 0;
    a->fontSize = afontsize[i-1];
    if (FontSelect(a->fontSize) == -1) a->fontSize = 0;
    a->unitary_cost = cost[i-1];
    a->minimum_capacity = mincap[i-1];
    a->maximum_capacity = maxcap[i-1];
    a->length = length[i-1];
    a->quadratic_weight = qweight[i-1];
    a->quadratic_origin = qorig[i-1];
    a->weight = weight[i-1];
  }

  free((char*)ta); free((char*)he); 
  free((char*)ntype);
  free((char*)xnode); free((char*)ynode); free((char*)ncolor);
  free((char*)ndiam); free((char*)nborder); free((char*)nfontsize);
  free((char*)demand);
  free((char*)acolor); free((char*)awidth); free((char*)ahiwidth);  
  free((char*)afontsize); free((char*)length); 
  free((char*)cost); free((char*)mincap); free((char*)maxcap); 
  free((char*)qweight);  free((char*)qorig); free((char*)weight);

  if(!ComputeValues(MG)) return NULL;

  MG->win = win;
  set_graph_win(win,MG);
  DisplayMenu(MG->win,STUDY);
  ComputeBox(MG);
  DrawGraph(MG);
  return MG;
}





