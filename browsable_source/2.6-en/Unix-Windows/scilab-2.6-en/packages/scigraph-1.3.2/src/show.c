/*--------------------------------------------------------
 * function called from Scilab through interfaces 
 *--------------------------------------------------------*/

#include <string.h>
#include <stdio.h>

#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"
#include "functions.h"
#include "graphics.h"
#include "graphics/Math.h"

#ifdef __STDC__
#include <unistd.h>
#endif 
#ifdef __ABSC__
#define getpid() getpid_()
#endif

extern int Mymetane _PARAMS((char * path, int * wdim, 
			     int * wpdim, int win,char * mode,int flag));

static  void ShowPath _PARAMS((MetanetGraph *,int *p,int *psize, int sup));
static  void ShowNodeSet _PARAMS((MetanetGraph *,int *ns,int *nsize, int sup));
static void ShowNames  _PARAMS((MetanetGraph *, char * nodeorarc,char *name));


/*-----------------------------------------------
 * Hilight arcs or nodes on current graph 
 * i.e graph on current graphic window 
 *-----------------------------------------------*/

void ShowPathCurrentGraph(p,psize,sup)
     int *p;
     int *psize;
     int sup;
{
  MetanetGraph *MG;
  int verb=0,win=0,na;
  C2F(dr)("xget","window",&verb,&win,&na, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  if ((MG = get_graph_win (win))== NULL) return ;
  if ( *psize != 0 )
    MG->moveflag = 0; /* we do not hilight during move */ 
  else 
    MG->moveflag = 1; /* we restore hilight during move */ 
  /* block */
  {
    REMOVE_REC_DRIVER();
    ShowPath(MG,p,psize,sup);
    RESTORE_DRIVER();
  }
}

void   ShowNodeSetCurrentGraph(ns,nsize,sup)
     int *ns;
     int *nsize;
     int sup;
{
  MetanetGraph *MG;
  int verb=0,win=0,na;
  C2F(dr)("xget","window",&verb,&win,&na, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  if ((MG = get_graph_win (win))== NULL) return ;
  if ( *nsize != 0 )
    MG->moveflag = 0; /* we do not hilight during move */ 
  else 
    MG->moveflag = 1; /* we restore hilight during move */ 
  /* block */
  {
    REMOVE_REC_DRIVER();
    ShowNodeSet(MG,ns,nsize,sup);
    RESTORE_DRIVER();
  }
}

void  ShowNamesCurrentGraph( nodeorarc, name ) 
     char * nodeorarc,*name;
{
  MetanetGraph *MG;
  int verb=0,win=0,na;
  C2F(dr)("xget","window",&verb,&win,&na, PI0,PI0,PI0,PD0,PD0,PD0,PD0,4L,6L);
  if ((MG = get_graph_win (win))== NULL) return ;
  ShowNames(MG,nodeorarc,name);
}


/*-----------------------------------------------
 * changes the names displayed with current graph 
 *-----------------------------------------------*/

static void ShowNames(MG,nodeorarc,name) 
     MetanetGraph *MG;
     char * nodeorarc,*name;
{
  if ( strcmp(nodeorarc,"arc")==0) 
    {
      int newarcStrDisplay= get_arc_name_info(name);
      if ( newarcStrDisplay == CANCEL_ARCDISP || MG->arcStrDisplay == newarcStrDisplay ) return ;
      MG->arcStrDisplay = newarcStrDisplay;
      scig_replay(MG->win);
    }
  else if  ( strcmp(nodeorarc,"node")==0)
    {
      int newnodeStrDisplay= get_node_name_info(name);
      if ( newnodeStrDisplay == CANCEL_NODEDISP || newnodeStrDisplay ==MG->nodeStrDisplay ) return ;
      MG->nodeStrDisplay = newnodeStrDisplay;
      scig_replay(MG->win);
    }
}


/*-----------------------------------------------
 * Highlight a path in a graph 
 * according to sup other arcs are first unhilighted 
 *-----------------------------------------------*/

static void ShowPath(MG,p,psize,sup)
     MetanetGraph *MG;
     int *p;
     int *psize;
     int sup;
{
  arc *a;
  int ia;
  if (MG->menuId == BEGIN) {
    sprintf(Description,"There is no loaded graph");
    MetanetAlert();
    return;
  }
  
  if (!sup) UnhiliteAll(MG);

  for ( ia = 0 ; ia < *psize ; ia++)
    {
      a = GetArc(p[ia],MG->Graph);
      if (a == 0) {
	sprintf(Description,"%d is not an internal arc number",p[ia]);
	MetanetAlert();
	return;
      }
      if (!a->hilited) {
	HiliteArc(MG,a);
      }
    }
}

/*-----------------------------------------------
 * Highlight a set of node in a graph 
 * according to sup other nodes are first unhilighted 
 *-----------------------------------------------*/

static void ShowNodeSet (MG,ns,nsize,sup)
     MetanetGraph *MG;
     int *ns;
     int *nsize;
     int sup;
{
  node *n;
  int in;
  if (MG->menuId == BEGIN) {
    sprintf(Description,"There is no loaded graph");
    MetanetAlert();
    return;
  }
  if (!sup) UnhiliteAll(MG);

  for ( in = 0 ; in < *nsize ; in++) 
    {
      n = GetNode(ns[in],MG->Graph);
      if (n == 0) {
	sprintf(Description,"%d is not an internal node number",ns[in]);
	MetanetAlert();
	return;
      }
      if (!n->hilited) {
	HiliteNode(MG,n);
      }
    }
}



/*-----------------------------------------------
 * displays a graph 
 *-----------------------------------------------*/

extern void cerro();

typedef int (*PF)();

#define mystrcat(s1,s2) istr=0;while(s2[istr]!='\0'){s1[ib++]=s2[istr++];}s1[ib++]=CHARSEP;

#define MAXISIZE 16 /* estimated maximum number of digits in an int */
static char description[2*MAXNAM];


extern char *get_sci_tmp_dir(void);

void ShowSciGraph(
		  name,lname,directed,node_number,tail,head,
		  node_name,nodes_type,node_x,node_y,node_color,node_diam,node_border,
		  node_font_size,node_demand,
		  edge_name,edge_color,edge_width,edge_hi_width,edge_font_size,
		  edge_length,edge_cost,edge_min_cap,edge_max_cap,edge_q_weight,edge_q_orig,
		  edge_weight,
		  default_node_diam,default_node_border,default_edge_width,
		  default_edge_hi_width,default_font_size,
		  is_nlabel,node_label,is_elabel,edge_label,
		  ma,window,sup,scale)
     char *name; int *lname;int *directed,*node_number,*tail,*head;
     char ***node_name; 
     int *nodes_type,*node_x,*node_y,*node_color,*node_diam,*node_border;
     int *node_font_size; double *node_demand;
     char ***edge_name;
     int *edge_color,*edge_width,*edge_hi_width,*edge_font_size;
     double *edge_length,*edge_cost,*edge_min_cap,*edge_max_cap;
     double *edge_q_weight,*edge_q_orig,*edge_weight;
     int *default_node_diam,*default_node_border,*default_edge_width;
     int *default_edge_hi_width,*default_font_size;
     char ***node_label, ***edge_label;
     int *is_nlabel, *is_elabel;
     int *ma, *window, *sup;
     double *scale;
{
  static int iwdim[]={1000,1000},ewdim[]={600,600};
  int i,ln;
  char fname[2 * MAXNAM];
  FILE *f;
  int isize = sizeof(int);
  int dsize = sizeof(double);
  int csize = sizeof(char);
  int pid;
  char **lar;

  /* check uniqueness of node names */
  if (*node_number != 1) {
    if ((lar = (char **)MALLOC(sizeof(char *) * *node_number)) == NULL) {
      cerro("Running out of memory");
      return;
    }
    for (i = 0; i < *node_number; i++) lar[i] = (*node_name)[i];
    qsort((char*)lar,*node_number,sizeof(char*),(PF)CompString);
    for (i = 0; i < *node_number - 1; i++) {
      if (!strcmp(lar[i],lar[i+1])) {
	sprintf(description,
		"Bad graph file. Node \"%s\" is duplicated",lar[i]);
	cerro(description);
	free(lar);
	return;
      }
    }
    if (!strcmp(lar[*node_number - 2],lar[*node_number - 1])) {
      sprintf(description,
	      "Bad graph file. Node \"%s\" is duplicated",lar[*node_number - 2]);
      cerro(description);
      free(lar);
      return;
    }
    free(lar);
  }

  pid = getpid();
#ifdef WIN32 
  sprintf(fname,"%s\\metanet.%d",get_sci_tmp_dir() ,*window);
#else 
  sprintf(fname,"%s/metanet.%d",get_sci_tmp_dir() ,*window);
#endif
  f = fopen(fname,"wb");
  if (f == NULL) {
    cerro("Unable to write in temp directory \"%s\"",get_sci_tmp_dir() );
    return;
  }
  
  /* name */
  name[*lname] = '\0';

  /* directed */
  fwrite((char*)directed,isize,1,f);

  /* scale */
  fwrite((char*)scale,dsize,1,f);

  /* n */
  fwrite((char*)node_number,isize,1,f);

  /* ma */
  fwrite((char*)ma,isize,1,f);

  /* tail */
  fwrite((char*)tail,isize,*ma,f);
  /* head */
  fwrite((char*)head,isize,*ma,f);
  /* node_name */
  for (i = 0; i < *node_number; i++) {
    ln = strlen((*node_name)[i]);
    fwrite((char*)&ln,isize,1,f);
    fwrite((*node_name)[i],csize,ln+1,f);
    free((*node_name)[i]);
  }
  free((char *)*node_name);

  /* nodes_type */
  fwrite((char*)nodes_type,isize,*node_number,f);

  /* node_x */
  fwrite((char*)node_x,isize,*node_number,f);

  /* node_y */
  fwrite((char*)node_y,isize,*node_number,f);

  /* node_color */
  fwrite((char*)node_color,isize,*node_number,f);

  /* node_diam */
  fwrite((char*)node_diam,isize,*node_number,f);

  /* node_border */
  fwrite((char*)node_border,isize,*node_number,f);

  /* node_font_size */
  fwrite((char*)node_font_size,isize,*node_number,f);

  /* node_demand */
  fwrite((char*)node_demand,dsize,*node_number,f);

  /* edge_name */
  for (i = 0; i < *ma; i++) {
    ln = strlen((*edge_name)[i]);
    fwrite((char*)&ln,isize,1,f);
    fwrite((*edge_name)[i],csize,ln+1,f);
    free((*edge_name)[i]);
  }
  free((char *)*edge_name);

  /* edge_color */
  fwrite((char*)edge_color,isize,*ma,f);

  /* edge_width */
  fwrite((char*)edge_width,isize,*ma,f);

  /* edge_hi_width */
  fwrite((char*)edge_hi_width,isize,*ma,f);

  /* edge_font_size */
  fwrite((char*)edge_font_size,isize,*ma,f);

  /* edge_length */
  fwrite((char*)edge_length,dsize,*ma,f);

  /* edge_cost */
  fwrite((char*)edge_cost,dsize,*ma,f);

  /* edge_min_cap */
  fwrite((char*)edge_min_cap,dsize,*ma,f);

  /* edge_max_cap */
  fwrite((char*)edge_max_cap,dsize,*ma,f);

  /* edge_q_weight */
  fwrite((char*)edge_q_weight,dsize,*ma,f);

  /* edge_q_orig */
  fwrite((char*)edge_q_orig,dsize,*ma,f);

  /* edge_weight */
  fwrite((char*)edge_weight,dsize,*ma,f);

  /* default_node_diam */
  fwrite((char*)default_node_diam,isize,1,f);

  /* default_node_border */
  fwrite((char*)default_node_border,isize,1,f);

  /* default_edge_width */
  fwrite((char*)default_edge_width,isize,1,f);

  /* default_edge_hi_width */
  fwrite((char*)default_edge_hi_width,isize,1,f);

  /* default_font_size */
  fwrite((char*)default_font_size,isize,1,f);
  
  /* node_label */
  fwrite((char*)is_nlabel,isize,1,f);
  if (*is_nlabel) {
    for (i = 0; i < *node_number; i++) {
      ln = strlen((*node_label)[i]);
      fwrite((char*)&ln,isize,1,f);
      fwrite((*node_label)[i],csize,ln+1,f);
      free((*node_label)[i]);
    }
    free((char *)*node_label);
  }

  /* edge_label */
  fwrite((char*)is_elabel,isize,1,f);
  if (*is_elabel) {
    for (i = 0; i < *ma; i++) {
      ln = strlen((*edge_label)[i]);
      fwrite((char*)&ln,isize,1,f);
      fwrite((*edge_label)[i],csize,ln+1,f);
      free((*edge_label)[i]);
    }
    free((char *)*edge_label);
  }

  fclose(f);

  /* now call scigraph */
  Mymetane(fname,iwdim,ewdim,*window,"rep",1);
  return;
}

