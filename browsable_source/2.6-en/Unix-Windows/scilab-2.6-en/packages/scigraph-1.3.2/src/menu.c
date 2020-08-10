#include "machine.h" 
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "font.h"
#include "metio.h"
#include "functions.h"
#include "graphics/Math.h" 

#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#include "wsci/wcommon.h"
#else
#include "menusX/men_scilab.h"
#include "xsci/All-extern.h"
#endif

static int v;
#define SetMenu(win,name,ne) C2F(setmen)(win,name,&v,&v,ne,&v)
#define UnsetMenu(win,name,ne) C2F(unsmen)(win,name,&v,&v,ne,&v)



static int arc_name_display_choose _PARAMS((void));
static int node_name_display_choose _PARAMS((void));
static int FilesSelect _PARAMS((int win,int number));

/*------------------------------------------------
 * menu File 
 *------------------------------------------------*/

static void  QuitOrQuitModify(MG,win)
     MetanetGraph *MG;
     int win;
{
  if (MG == NULL) MetanetQuit(win);
  else 
    {
      if (MG->menuId == MODIFY) 
	ModifyQuit(MG,0);
      else 
	MetanetQuit(win);
    }
}


static int FilesSelect( win,number)
     int win,number ; 
{
  MetanetGraph *MG;
  MG = get_graph_win(win);

  switch (number) {
  case 0:     MG=NewGraph(win);     break;
  case 1:     MG=LoadGraph(win);    break;
  case 2:     SaveGraph(MG);        break;
  case 3:     RenameSaveGraph(MG);  break;
#ifndef WIN32 
  case 4:     scig_print(win); break;
  case 5:     scig_export(win) ; break;
  case 6:     QuitOrQuitModify(MG,win); break;
#else 
  case 4: scig_h_copyclip(win); break;
  case 5: scig_h_copyclip1(win);break;
  case 6: scig_h_winmeth_print(win);break;
  case 7:     scig_print(win); break;
  case 8:     scig_export(win) ; break;
  case 9:     QuitOrQuitModify(MG,win); break;
#endif
  }
  return 0;
}

void GraphSelect(win,number)
     int win;
     int number;
{
  MetanetGraph *MG;
  int newnodeStrDisplay;
  int newarcStrDisplay;
  int num = (int)number;
  int ne;

  if ((MG = get_graph_win(win))== NULL) return ;
  
  switch (num) {
  case 0:
    ObjectCharacteristics(MG);
    break;
  case 1:
    FindArc(MG);
    break;
  case 2:
    FindNode(MG);
    break;
  case 3:
    ModifyGraph(MG);
    break;
  case 4: 
    ne = 5; UnsetMenu(&win,"Graph",&ne);
    ne = 6; SetMenu(&win,"Graph",&ne);
    MG->intDisplay = 1;
    ComputeBox(MG);
    scig_replay(MG->win);
    break;
  case 5:
    ne = 5; SetMenu(&win,"Graph",&ne);
    ne = 6; UnsetMenu(&win,"Graph",&ne);
    MG->intDisplay = 0;
    scig_replay(MG->win);
    break;
  case 6:
    newarcStrDisplay= arc_name_display_choose();
    if ( newarcStrDisplay == CANCEL_ARCDISP || MG->arcStrDisplay == newarcStrDisplay ) return ;
    MG->arcStrDisplay = newarcStrDisplay;
    scig_replay(MG->win);
    break;
  case 7:
    newnodeStrDisplay= node_name_display_choose();
    if ( newnodeStrDisplay == CANCEL_NODEDISP || newnodeStrDisplay ==MG->nodeStrDisplay ) return ;
    MG->nodeStrDisplay = newnodeStrDisplay;
    scig_replay(MG->win);
    break;
  }
}

void ModifySelect(win,number)
     int win,number;
{
  MetanetGraph *MG;

  int num = (int)number;
  if ((MG = get_graph_win(win))== NULL) return ;
  
  {
    REMOVE_REC_DRIVER();
    switch (num) {
    case 0:
      ObjectAttributes(MG);
      break;
    case 1:
      XmetaDelObject(MG);
      break;
    case 2:
      NameObject(MG);
      break;
    case 3:
      ColorObject(MG);
      break;
    case 4:
      CreateLoop(MG);
      break;
    case 5:
      CreateSink(MG);
      break;
    case 6:
      CreateSource(MG);
      break;
    case 7:
      RemoveSourceSink(MG);
      break;
    case 8:
      AutomaticName(MG);
      break;
    case 9:
      ChooseDefaults(MG);
      break;
    case 10:
      ModifyQuit(MG,0);
      break;
    }
    RESTORE_DRIVER();
  }
}

void MenuRedraw(win)
     int win;
{
  MetanetGraph *MG;
  if ((MG = get_graph_win(win))== NULL) return ;
  scig_replay(win);
}

void MenuGraphZoom(win)
     int win;
{
  int ne=0;
  MetanetGraph *MG;
  double bbox[4];
  if ((MG = get_graph_win(win))== NULL) return ;
  UnsetMenu(&win,"Gzoom",&ne);
  UnsetMenu(&win,"Redraw",&ne);
  UnsetMenu(&win,"Files",&ne);
  UnsetMenu(&win,"Graph",&ne);
  UnsetMenu(&win,"UnGzoom",&ne);
  MG->moveflag=0; /* unset the automatic highlight */
  scig_replay(win);
  /* restore scales before getting the zoom rectangle */
  SetMGScales(MG);
  graph_zoom_get_rectangle(bbox);
  NewScales(MG, (int) bbox[0],(int) bbox[1],(int) bbox[2],(int) bbox[3]);
  scig_replay(win);
  SetMenu(&win,"Gzoom",&ne);
  SetMenu(&win,"Redraw",&ne);
  SetMenu(&win,"Files",&ne);
  SetMenu(&win,"Graph",&ne);
  SetMenu(&win,"UnGzoom",&ne);
  MG->moveflag=1; /* restore automatic highlight */
}

void MenuGraphUnzoom(win)
     int win;
{
  MetanetGraph *MG;
  if ((MG = get_graph_win(win))== NULL) return ;
  ComputeBox(MG);
  SetMGScales(MG);
  scig_replay(win);
}

void MenuHelp(win)
     int win;
{
  MetanetGraph *MG=  get_graph_win(win);
  int menuId = ( MG != NULL) ? MG->menuId : BEGIN;

  switch (menuId) {
  case BEGIN:
    DisplayBeginHelp();
    break;
  case STUDY:
    DisplayStudyHelp();
    break;
  case MODIFY:
    DisplayModifyHelp();
    break;
  }
}


void CreateMenus(win)
     int win;
{
  int ne,ierr=0,typ=0,oldwin;
#ifndef WIN32
  static char * file_entries[]={
    "New","Load","Save","Save As","Print","Export","Quit",NULL};
#else 
  static char * file_entries[]={
    "New","Load","Save","Save As","Copy to clipboard (EnhMetafile)",
    "Copy to clipboard (Metafile + DIB)",
    "Print (Windows)","Print (Scilab)","Export (Scilab)","Quit",NULL};
#endif 

  static char * graph_entries[]={
    "Characteristics","Find Arc","Find Node","Modify Graph",
    "Use internal numbers as names","Do not use internal numbers as names",
    "Display arc names","Display node names",NULL};

  static char * modify_entries[]={
    "Attributes","Delete","Name","Color","Create Loop","Create Sink",
    "Create Source","Remove Sink/Source","Automatic Name","Default Values",
    "Quit Modify Mode",NULL };

  oldwin= SetMetanetWin(win);
  /* CheckSciWin(); */
#ifndef WIN32 
  C2F(delbtn)(&win,"File");
  C2F(delbtn)(&win,"2D Zoom");
  C2F(delbtn)(&win,"3D Rot.");
  C2F(delbtn)(&win,"UnZoom"); 
#else 
  C2F(delbtn)(&win,"&File");
  C2F(delbtn)(&win,"2D &Zoom");
  C2F(delbtn)(&win,"3D &Rot.");
  C2F(delbtn)(&win,"&UnZoom"); 
#endif 
  C2F(delbtn)(&win,"Files");
  C2F(delbtn)(&win,"Graph");
  C2F(delbtn)(&win,"Modify");
  C2F(delbtn)(&win,"Redraw"); 
  C2F(delbtn)(&win,"Gzoom"); 
  C2F(delbtn)(&win,"UnGzoom"); 
  /*  C2F(delbtn)(&win,"Help"); */
#ifndef WIN32 
  ne=7;AddMenu(&win,"Files",file_entries,&ne,&typ,"Files",&ierr);
#else 
  ne=10;AddMenu(&win,"Files",file_entries,&ne,&typ,"Files",&ierr);
#endif 
  ne=8;AddMenu(&win,"Graph",graph_entries,&ne,&typ,"Graph",&ierr);
  ne = 5; SetMenu(&win,"Graph",&ne);
  ne = 6; UnsetMenu(&win,"Graph",&ne);
  ne=11;AddMenu(&win,"Modify",modify_entries,&ne,&typ,"Modify",&ierr);
  ne=0;AddMenu(&win,"Redraw",file_entries,&ne,&typ,"Redraw",&ierr);
  ne=0;AddMenu(&win,"Gzoom",file_entries,&ne,&typ,"Gzoom",&ierr);
  ne=0;AddMenu(&win,"UnGzoom",file_entries,&ne,&typ,"UnGzoom",&ierr);
  /*  ne=0;AddMenu(&win,"Help",file_entries,&ne,&typ,"Help",&ierr);*/
  SetMetanetWin(oldwin);
}

/* returns 1 if menu is a metanet menu returns 0 otherwise */

int DecodeMenus(str,lstr)
     char *str;
     int lstr;
{
  char name[56];
  int win,sub,oldwin,rep=1;
  sscanf(str,"execstr(%[^_]_%d(%d)",name,&win,&sub);
  oldwin= SetMetanetWin(win);

  /* fprintf(stderr,"%s %d %d \n",name,win,sub); */
  if ( strcmp(name,"Files")== 0) 
    FilesSelect(win,sub-1);
  else   if ( strcmp(name,"Graph")== 0) 
    GraphSelect(win,sub-1);
  else   if ( strcmp(name,"Modify")== 0) 
    ModifySelect(win,sub-1);
  else   if ( strcmp(name,"Redraw")==0)
    MenuRedraw(win);
  else   if ( strcmp(name,"Gzoom")==0)
    MenuGraphZoom(win);
  else   if ( strcmp(name,"UnGzoom")==0)
    MenuGraphUnzoom(win);
  /*  else   if ( strcmp(name,"Help")==0)
      MenuHelp(win); */
  else 
    {
      /* not a metanet menu */
      rep = 0 ;
    }
  SetMetanetWin(oldwin);
  return rep;
}


void DisplayBeginMenu(win_num)
     int win_num;
{
  int ne;
  MetanetGraph *MG= get_graph_win(win_num);
  if ( MG != NULL) MG->menuId = BEGIN;
  ne = 1; SetMenu(&win_num,"Files",&ne);
  ne = 2; SetMenu(&win_num,"Files",&ne);
  ne = 3; UnsetMenu(&win_num,"Files",&ne);
  ne = 4; UnsetMenu(&win_num,"Files",&ne);
  ne = 0; UnsetMenu(&win_num,"Graph",&ne);
  ne = 0; UnsetMenu(&win_num,"Modify",&ne);
  ne = 0; UnsetMenu(&win_num,"Redraw",&ne);
  SetTitle(win_num,BEGIN,"begin menu");
}

void DisplayStudyMenu(win_num)
     int win_num;
{
  int ne;
  MetanetGraph *MG= get_graph_win(win_num);
  if ( MG != NULL) MG->menuId = STUDY;
  ne = 0; SetMenu(&win_num,"Graph",&ne);
  ne = 0; SetMenu(&win_num,"Modify",&ne);
  ne = 0; SetMenu(&win_num,"Redraw",&ne);
  ne = 1; SetMenu(&win_num,"Files",&ne);
  ne = 2; SetMenu(&win_num,"Files",&ne);
  ne = 4; SetMenu(&win_num,"Files",&ne);
  ne = 4; SetMenu(&win_num,"Graph",&ne);
  ne = 3; UnsetMenu(&win_num,"Files",&ne);
  ne = 0; UnsetMenu(&win_num,"Modify",&ne);
  SetTitle(win_num,STUDY,"study menu");
}


void DisplayModifyMenu(win_num)
     int win_num;
{
  int ne;
  MetanetGraph *MG= get_graph_win(win_num);
  if ( MG != NULL) MG->menuId = MODIFY;
  ne = 4; SetMenu(&win_num,"Files",&ne);
  ne = 3; SetMenu(&win_num,"Files",&ne);
  ne = 0; SetMenu(&win_num,"Graph",&ne);
  ne = 0; SetMenu(&win_num,"Modify",&ne);
  ne = 0; SetMenu(&win_num,"Redraw",&ne);
  ne = 4; UnsetMenu(&win_num,"Graph",&ne);
  ne = 1; UnsetMenu(&win_num,"Files",&ne);
  ne = 2; UnsetMenu(&win_num,"Files",&ne);
  SetTitle(win_num,MODIFY,"modify menu");
}

void DisplayMenu(win,i)
     int win,i;
{
  switch (i) {
  case BEGIN:
    DisplayBeginMenu(win);
    break;
  case STUDY:
    DisplayStudyMenu(win);
    break;
  case MODIFY:
    DisplayModifyMenu(win);
    break;
  }
}



/*****************************************
 * Menu for name selection for node or arcs  
 *****************************************/

static char *DefNodeStrings[]= { "name","label","demand","internal number","None",NULL};
static int NodeRep[]= { CANCEL_NODEDISP, NAME_NODEDISP,LABEL_NODEDISP,DEMAND_NODEDISP,INT_NODEDISP,NODISP };
static char **NodeStrings= NULL;

void init_node_strings()
{
  if ( NodeStrings == NULL) 
    NodeStrings = DefNodeStrings;
}

void set_node_strings(strings) 
     char **strings;
{
  if (NodeStrings != NULL &&  NodeStrings != DefNodeStrings ) 
    {
      int i =0; 
      while ( NodeStrings[i] != 0) { 
	FREE(NodeStrings[i]);i++;
      }; 
      FREE(NodeStrings);
    }
  NodeStrings = strings;
}


int get_node_name_info(name) 
     char *name;
{
  int i=0;
  init_node_strings();
  while ( NodeStrings[i] != NULL) 
    {
      if (strcmp(NodeStrings[i],name)==0) return NodeRep[i+1];
      i++;
    }
  return NodeRep[0];
}


int node_name_display_choose()
{
  ChooseMenu Ch;
  int Rep;
  static char *butn[]= { "cancel" , NULL};
  /*  NAME_NODEDISP,INT_NODEDISP,DEMAND_NODEDISP */
  Ch.nstrings = 4;
  Ch.nb = 1; 
  Ch.choice = 0;
  Ch.description = "Node Display";
  Ch.buttonname = butn;
  init_node_strings();
  Ch.strings = NodeStrings;
  Rep = ExposeChooseWindow(&Ch);
  if ( Rep == TRUE )
    return NodeRep[Ch.choice+1];
  else 
    return NodeRep[0];
}


/*--------------------------------------------
 * choose menu for Arc name display 
 *--------------------------------------------*/

static char *DefArcStrings[]= {"internal number","name", "cost","minimum capacity", 
			 "maximum capacity", "length","quadratic weight", "quadratic origin",
			 "weight","None",NULL};

static char ** ArcStrings= NULL;

static int ArcRep[]= { CANCEL_ARCDISP,INT_ARCDISP, NAME_ARCDISP, COST_ARCDISP, MINCAP_ARCDISP,
		       MAXCAP_ARCDISP, LENGTH_ARCDISP, QWEIGHT_ARCDISP, QORIG_ARCDISP,
		       WEIGHT_ARCDISP, NODISP};


void init_arc_strings()
{
  if ( ArcStrings == NULL) 
    ArcStrings = DefArcStrings;
}

void set_arc_strings(strings) 
     char **strings;
{
  if (ArcStrings != NULL &&  ArcStrings != DefArcStrings ) 
    {
      int i =0; 
      while ( ArcStrings[i] != 0) { 
	FREE(ArcStrings[i]);i++;
      }; 
      FREE(ArcStrings);
    }
  ArcStrings = strings;
}



int get_arc_name_info(name) 
     char *name;
{
  int i=0;
  init_arc_strings();
  while ( ArcStrings[i] != NULL) 
    {
      if (strcmp(ArcStrings[i],name)==0) return ArcRep[i+1];
      i++;
    }
  return ArcRep[0];
}

static int arc_name_display_choose()
{
  ChooseMenu Ch;
  int Rep;
  static char *butn[]= { "cancel" , NULL};

  Ch.nstrings = 9;
  Ch.nb = 1; 
  Ch.choice = 0;
  Ch.description = "Arc Display";
  Ch.buttonname = butn;
  init_arc_strings();
  Ch.strings = ArcStrings;
  Rep = ExposeChooseWindow(&Ch);
  if ( Rep == TRUE )
    return ArcRep[Ch.choice+1];
  else 
    return ArcRep[0];
}







