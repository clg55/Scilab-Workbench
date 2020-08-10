/*-------------------------------------------------------------------
 * Copyright Enpc/Cermics (Jean-Philippe Chancelier)
 * scigraph interface 
 *-------------------------------------------------------------------*/

#include <string.h>
#include <stdio.h>
#include "stack-c.h"

extern void set_node_strings _PARAMS((char **strings));
extern void set_arc_strings  _PARAMS((char **strings));

extern void  ShowNodeSetCurrentGraph _PARAMS((int *,int *,int));
extern void  ShowPathCurrentGraph _PARAMS((int *,int *,int));
extern void  ShowNamesCurrentGraph _PARAMS((char *,char *));
extern int Mymetane _PARAMS((char * path, int * wdim, 
			     int * wpdim, int win,char * mode,int flag));

extern void ShowSciGraph 
_PARAMS((
	 char *name, int *lname,int *directed,int *node_number,int *tail,int *head,
	 char ***node_name, 
	 int *nodes_type,int *node_x,int *node_y,int *node_color,int *node_diam,int *node_border,
	 int *node_font_size, double *node_demand,
	 char ***edge_name,
	 int *edge_color,int *edge_width,int *edge_hi_width,int *edge_font_size,
	 double *edge_length,double *edge_cost,double *edge_min_cap,double *edge_max_cap,
	 double *edge_q_weight,double *edge_q_orig,double *edge_weight,
	 int *default_node_diam,int  *default_node_border,int  *default_edge_width,
	 int *default_edge_hi_width,int  *default_font_size,
	 int *is_nlabel,char ***node_label,int *is_elabel,char ***edge_label,
	 int *ma,int  *window,int  *sup,
	 double *scale));


/*-----------------------------------------------------------
 * metanet with Scilab graphics 
 * scigraph( gmode= "rep" or "new, wdim= [w,h],wpdim=[w,h],window=[win],
 *           graph= g );
 * 
 *-----------------------------------------------------------*/

int intscigraph(fname, fname_len)
     char *fname;
     unsigned long fname_len;
{
  static int d_iwdim[2]={700,700},d_ewdim[2]={700,700};
  int *iwdim = d_iwdim, *ewdim = d_ewdim, window=0;
  static rhs_opts opts[]= { 
    {-1,"gmode","c",0,0,0},
    {-1,"graph","c",0,0,0},
    {-1,"wdim","i",0,0,0},
    {-1,"window","i",0,0,0},
    {-1,"wpdim","i",0,0,0},
    {-1,NULL,NULL,0,0}
  };
  int minrhs = -1,maxrhs = 0,minlhs=0,maxlhs=1,nopt;
  char d_mode[]="rep", *mode = d_mode;
  char *graph = NULL;

  nopt = NumOpt();
  CheckRhs(minrhs,maxrhs+nopt) ;
  CheckLhs(minlhs,maxlhs) ;

  if ( get_optionals(fname,opts) == 0) return 0;
  if ( opts[0].position != -1 ) 
    { 
      mode = cstk(opts[0].l);
    } 
  if ( opts[1].position != -1 ) 
    { 
      graph = cstk(opts[1].l);
    }

  if ( opts[2].position != -1 ) 
    {
      CheckLength(opts[2].position,opts[2].m*opts[2].n,2);
      iwdim= istk(opts[2].l);
    }

  if ( opts[3].position != -1 ) 
    { 
      CheckScalar(opts[3].position,opts[3].m,opts[3].n);
      window = *istk(opts[3].l);
    }

  if ( opts[4].position != -1 ) 
    { 
      CheckLength(opts[4].position,opts[4].m*opts[4].n,2);
      ewdim= istk(opts[4].l);
    }

  Mymetane(graph,iwdim,ewdim,window,mode,0);
  LhsVar(1) = 0;
  return 0;
}

/*-------------------------------------------
 * show_scig()
 *-------------------------------------------*/

int intsshowscig(fname)
   char *fname;
{
 int m1,n1,l1,m1e3,n1e3,l1e3,m1e4,n1e4,l1e4,m1e5,n1e5,l1e5,l1mn5,m1e6,n1e6,l1e6,l1mn6,m1e7,n1e7,m1e8
 ,n1e8,l1e8,l1mn8,m1e9,n1e9,l1e9,l1mn9,m1e10,n1e10,l1e10,l1mn10,m1e11,n1e11,l1e11,l1mn11,m1e12,n1e12
 ,l1e12,l1mn12,m1e13,n1e13,l1e13,l1mn13,m1e14,n1e14,l1e14,l1mn14,m1e15,n1e15,l1e15,l1mn15,m1e16,n1e16
 ,m1e17,n1e17,l1e17,l1mn17,m1e18,n1e18,l1e18,l1mn18,m1e19,n1e19,l1e19,l1mn19,m1e20,n1e20,l1e20,l1mn20
 ,m1e21,n1e21,l1e21,l1mn21,m1e22,n1e22,l1e22,l1mn22,m1e23,n1e23,l1e23,l1mn23,m1e24,n1e24,l1e24,l1mn24
 ,m1e25,n1e25,l1e25,l1mn25,m1e26,n1e26,l1e26,l1mn26,m1e27,n1e27,l1e27,l1mn27,m1e28,n1e28,l1e28,m1e29
 ,n1e29,l1e29,m1e30,n1e30,l1e30,m1e31,n1e31,l1e31,m1e32,n1e32,l1e32,m1e33,n1e33,m1e34,n1e34,m2,n2,l2
 ,m3,n3,l3,m4,n4,l4,m5,n5,l5,m6,n6,l6,m7,n7,l7,m8,n8,l8;
 char  **Str1e7,**Str1e16,**Str1e33,**Str1e34;
 CheckRhs(8,8);
 CheckLhs(1,1);
 GetRhsVar(1,"t",&m1,&n1,&l1);
 /* list element 3 directed(g) */
 GetListRhsVar(1,3,"i",&m1e3,&n1e3,&l1e3);
 CheckListScalar(1,3,m1e3,n1e3);
 /* list element 4 node_number(g) */
 GetListRhsVar(1,4,"i",&m1e4,&n1e4,&l1e4);
 CheckListScalar(1,4,m1e4,n1e4);
 /* list element 5 tail(g) */
 GetListRhsVar(1,5,"i",&m1e5,&n1e5,&l1e5);
 CheckListRow(1,5,m1e5,n1e5);
 l1mn5=m1e5*n1e5;
 /* list element 6 head(g) */
 GetListRhsVar(1,6,"i",&m1e6,&n1e6,&l1e6);
 CheckListRow(1,6,m1e6,n1e6);
 l1mn6=m1e6*n1e6;
 /* list element 7 node_name(g) */
 GetListRhsVar(1,7,"S",&m1e7,&n1e7,&Str1e7);
 CheckListOneDim(1,7,1,m1e7,1);
 /* list element 8 node_type(g) */
 GetListRhsVar(1,8,"i",&m1e8,&n1e8,&l1e8);
 CheckListRow(1,8,m1e8,n1e8);
 l1mn8=m1e8*n1e8;
 /* list element 9 node_x(g) */
 GetListRhsVar(1,9,"i",&m1e9,&n1e9,&l1e9);
 CheckListRow(1,9,m1e9,n1e9);
 l1mn9=m1e9*n1e9;
 /* list element 10 node_y(g) */
 GetListRhsVar(1,10,"i",&m1e10,&n1e10,&l1e10);
 CheckListRow(1,10,m1e10,n1e10);
 l1mn10=m1e10*n1e10;
 /* list element 11 node_color(g) */
 GetListRhsVar(1,11,"i",&m1e11,&n1e11,&l1e11);
 CheckListRow(1,11,m1e11,n1e11);
 l1mn11=m1e11*n1e11;
 /* list element 12 node_diam(g) */
 GetListRhsVar(1,12,"i",&m1e12,&n1e12,&l1e12);
 CheckListRow(1,12,m1e12,n1e12);
 l1mn12=m1e12*n1e12;
 /* list element 13 node_border(g) */
 GetListRhsVar(1,13,"i",&m1e13,&n1e13,&l1e13);
 CheckListRow(1,13,m1e13,n1e13);
 l1mn13=m1e13*n1e13;
 /* list element 14 node_font_size(g) */
 GetListRhsVar(1,14,"i",&m1e14,&n1e14,&l1e14);
 CheckListRow(1,14,m1e14,n1e14);
 l1mn14=m1e14*n1e14;
 /* list element 15 node_demand(g) */
 GetListRhsVar(1,15,"d",&m1e15,&n1e15,&l1e15);
 CheckListRow(1,15,m1e15,n1e15);
 l1mn15=m1e15*n1e15;
 /* list element 16 edge_name(g) */
 GetListRhsVar(1,16,"S",&m1e16,&n1e16,&Str1e16);
 CheckListOneDim(1,16,1,m1e7,1);
 /* list element 17 edge_color(g) */
 GetListRhsVar(1,17,"i",&m1e17,&n1e17,&l1e17);
 CheckListRow(1,17,m1e17,n1e17);
 l1mn17=m1e17*n1e17;
 /* list element 18 edge_width(g) */
 GetListRhsVar(1,18,"i",&m1e18,&n1e18,&l1e18);
 CheckListRow(1,18,m1e18,n1e18);
 l1mn18=m1e18*n1e18;
 /* list element 19 edge_hi_width(g) */
 GetListRhsVar(1,19,"i",&m1e19,&n1e19,&l1e19);
 CheckListRow(1,19,m1e19,n1e19);
 l1mn19=m1e19*n1e19;
 /* list element 20 edge_font_size(g) */
 GetListRhsVar(1,20,"i",&m1e20,&n1e20,&l1e20);
 CheckListRow(1,20,m1e20,n1e20);
 l1mn20=m1e20*n1e20;
 /* list element 21 edge_length(g) */
 GetListRhsVar(1,21,"d",&m1e21,&n1e21,&l1e21);
 CheckListRow(1,21,m1e21,n1e21);
 l1mn21=m1e21*n1e21;
 /* list element 22 edge_cost(g) */
 GetListRhsVar(1,22,"d",&m1e22,&n1e22,&l1e22);
 CheckListRow(1,22,m1e22,n1e22);
 l1mn22=m1e22*n1e22;
 /* list element 23 edge_min_cap(g) */
 GetListRhsVar(1,23,"d",&m1e23,&n1e23,&l1e23);
 CheckListRow(1,23,m1e23,n1e23);
 l1mn23=m1e23*n1e23;
 /* list element 24 edge_max_cap(g) */
 GetListRhsVar(1,24,"d",&m1e24,&n1e24,&l1e24);
 CheckListRow(1,24,m1e24,n1e24);
 l1mn24=m1e24*n1e24;
 /* list element 25 edge_q_weight(g) */
 GetListRhsVar(1,25,"d",&m1e25,&n1e25,&l1e25);
 CheckListRow(1,25,m1e25,n1e25);
 l1mn25=m1e25*n1e25;
 /* list element 26 edge_q_orig(g) */
 GetListRhsVar(1,26,"d",&m1e26,&n1e26,&l1e26);
 CheckListRow(1,26,m1e26,n1e26);
 l1mn26=m1e26*n1e26;
 /* list element 27 edge_weight(g) */
 GetListRhsVar(1,27,"d",&m1e27,&n1e27,&l1e27);
 CheckListRow(1,27,m1e27,n1e27);
 l1mn27=m1e27*n1e27;
 /* list element 28 default_node_diam(g) */
 GetListRhsVar(1,28,"i",&m1e28,&n1e28,&l1e28);
 CheckListScalar(1,28,m1e28,n1e28);
 /* list element 29 default_node_border(g) */
 GetListRhsVar(1,29,"i",&m1e29,&n1e29,&l1e29);
 CheckListScalar(1,29,m1e29,n1e29);
 /* list element 30 default_edge_width(g) */
 GetListRhsVar(1,30,"i",&m1e30,&n1e30,&l1e30);
 CheckListScalar(1,30,m1e30,n1e30);
 /* list element 31 default_edge_hi_width(g) */
 GetListRhsVar(1,31,"i",&m1e31,&n1e31,&l1e31);
 CheckListScalar(1,31,m1e31,n1e31);
 /* list element 32 default_font_size(g) */
 GetListRhsVar(1,32,"i",&m1e32,&n1e32,&l1e32);
 CheckListScalar(1,32,m1e32,n1e32);
 /* list element 33 node_label(g) */
 GetListRhsVar(1,33,"S",&m1e33,&n1e33,&Str1e33);
 CheckListOneDim(1,33,1,m1e7,1);
 /* list element 34 edge_label(g) */
 GetListRhsVar(1,34,"S",&m1e34,&n1e34,&Str1e34);
 CheckListOneDim(1,34,1,m1e7,1);
 /*  checking variable name */
 GetRhsVar(2,"c",&m2,&n2,&l2);
 /*  checking variable ma */
 GetRhsVar(3,"i",&m3,&n3,&l3);
 CheckScalar(3,m3,n3);
 /*  checking variable window */
 GetRhsVar(4,"i",&m4,&n4,&l4);
 CheckScalar(4,m4,n4);
 /*  checking variable sup */
 GetRhsVar(5,"i",&m5,&n5,&l5);
 CheckScalar(5,m5,n5);
 /*  checking variable scale */
 GetRhsVar(6,"d",&m6,&n6,&l6);
 CheckScalar(6,m6,n6);
 /*  checking variable is_nlabel */
 GetRhsVar(7,"i",&m7,&n7,&l7);
 CheckScalar(7,m7,n7);
 /*  checking variable is_elabel */
 GetRhsVar(8,"i",&m8,&n8,&l8);
 CheckScalar(8,m8,n8);
 /* cross variable size checking */
 ShowSciGraph (cstk(l2),&m2,istk(l1e3),istk(l1e4),istk(l1e5),istk(l1e6),&Str1e7,istk(l1e8),istk(l1e9),istk
 (l1e10),istk(l1e11),istk(l1e12),istk(l1e13),istk(l1e14),stk(l1e15),&Str1e16,istk(l1e17),istk(l1e18)
 ,istk(l1e19),istk(l1e20),stk(l1e21),stk(l1e22),stk(l1e23),stk(l1e24),stk(l1e25),stk(l1e26),stk(l1e27)
 ,istk(l1e28),istk(l1e29),istk(l1e30),istk(l1e31),istk(l1e32),istk(l7),&Str1e33,istk(l8),&Str1e34,istk
 (l3),istk(l4),istk(l5),stk(l6));
 LhsVar(1)=0;
 ;return 0;
}

/*-------------------------------------------
 * used in show_scig_nodes()
 *-------------------------------------------*/

int intsshowscigns(fname)
   char *fname;
{
  int m1,n1,l1,mn1,m2,n2,l2,irep2=0;
  CheckRhs(1,2);
  CheckLhs(1,1);
  /*  checking variable ns */
  GetRhsVar(1,"i",&m1,&n1,&l1);
  mn1=m1*n1;
  /*  checking variable sup */
  if ( Rhs == 2) 
    {
      GetRhsVar(2,"c",&m2,&n2,&l2);
      if ( strcmp(cstk(l2),"sup")==0) irep2 =1;
    }
  /* cross variable size checking */
  ShowNodeSetCurrentGraph(istk(l1),&mn1,irep2);
  LhsVar(1)=0;
  ;return 0;
}

/*-------------------------------------------
 * used in show_scig_arcs()
 *-------------------------------------------*/

int intsshowscignp(fname)
   char *fname;
{
  int m1,n1,l1,mn1,m2,n2,l2,irep2=0;
  CheckRhs(1,2);
  CheckLhs(1,1);
  /*  checking variable p */
  GetRhsVar(1,"i",&m1,&n1,&l1);
  mn1=m1*n1;
  /*  checking variable sup */
  /*  checking variable sup */
  if ( Rhs == 2) 
    {
      GetRhsVar(2,"c",&m2,&n2,&l2);
      if ( strcmp(cstk(l2),"sup")==0) irep2 =1;
    }
  /* cross variable size checking */
  ShowPathCurrentGraph(istk(l1),&mn1,irep2);
  LhsVar(1)=0;
  return 0;
}

/*-------------------------------------------
 * used in show_scig_names('node'|'arc', name )
 *-------------------------------------------*/

int intsshowscignames(fname)
   char *fname;
{
 int m1,n1,l1,m2,n2,l2;
 CheckRhs(2,2);
 CheckLhs(1,1);
 /*  checking variable p */
 GetRhsVar(1,"c",&m1,&n1,&l1);
 GetRhsVar(2,"c",&m2,&n2,&l2);
 /* cross variable size checking */
 if ( strcmp(cstk(l1),"arc")==0 || strcmp(cstk(l1),"node")==0 )
   ShowNamesCurrentGraph(cstk(l1),cstk(l2));
 else
   {
     Scierror(999,"%s: first argument \"%s\" should be \"arc\" or \"node\"\r\n",fname,cstk(l1));
     return 0;
   }
 LhsVar(1)=0;
 ;return 0;
}

/*-------------------------------------------
 * used to change the  node names menus 
 *-------------------------------------------*/

int int_scignodenames(fname)
   char *fname;
{
  char **Node_Names;
  int m1,n1;
  CheckRhs(1,1);
  CheckLhs(0,1);
  /*  checking variable p */
  GetRhsVar(1,"S",&m1,&n1,&Node_Names);
  CheckDims(1,m1,n1,5,1) ;
  if ( Node_Names != NULL ) 
    set_node_strings(Node_Names);
  LhsVar(1)=0;
  return 0;
}

/*-------------------------------------------
 * used to change the  node names menus 
 *-------------------------------------------*/

int int_scigarcnames(fname)
   char *fname;
{
  char **Arc_Names;
  int m1,n1;
  CheckRhs(1,1);
  CheckLhs(0,1);
  /*  checking variable p */
  GetRhsVar(1,"S",&m1,&n1,&Arc_Names);
  CheckDims(1,m1,n1,10,1) ;
  if ( Arc_Names != NULL ) 
    set_arc_strings(Arc_Names);
  LhsVar(1)=0;
  return 0;
}




