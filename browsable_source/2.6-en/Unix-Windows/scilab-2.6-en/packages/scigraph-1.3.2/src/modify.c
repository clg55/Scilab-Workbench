#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "metio.h"
#include "functions.h" 

#include "graphics.h"
#define PI0 (integer *) 0
#define PD0 (double *) 0


void ModifyGraph(MG)
     MetanetGraph *MG;
{
  REMOVE_REC_DRIVER();
  if ( MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) {
    UnhiliteAll(MG);
  }
  RESTORE_DRIVER();

  if (( MG->oldGraph = DuplicateGraph(MG->Graph)) == NULL) 
    {
      sprintf(Description,"Running out of memory\ngraph allocation failed");
      MetanetAlert();
      return ;
    }

  DisplayMenu(MG->win,MODIFY);
}

/* if force == 1 we force the Quit without asking */

void ModifyQuit(MG,force )
     MetanetGraph *MG;
     int force ;
{
  graph *g;
  if (MG->GG.modified) 
    {
      sprintf(Description,
	      "Graph \"%s\" has been modified and not saved.\nQuit Modify Mode anyway?",
	      MG->Graph->name);
      if (force == 1 || MetanetYesOrNo()) 
	{
	  if (MG->GG.n_hilited_arcs != 0 || MG->GG.n_hilited_nodes != 0) 
	    UnhiliteAll(MG);
	  if ( MG->oldGraph != NULL )
	    {
	      /* we restore saved graph state */
	      g = MG->Graph ;
	      MG->Graph = MG->oldGraph;
	      /* before destroying the graph we must rebuilt 
	       * ArraysGraph which can be unsynchronides 
	       */
	      MakeArraysGraph(g);
	      DestroyGraph(g);
	      MG->oldGraph =NULL;
	    }
	  MG->GG.modified = 0;
	  if (MG->Graph->node_number == 0) {
	    DisplayMenu(MG->win,BEGIN);
	    ClearDraw(MG->win);
	  } else {
	    DisplayMenu(MG->win,STUDY);
	    ComputeBox(MG);
	    scig_replay(MG->win);
	  }
	}
      else return;
    }
  else DisplayMenu(MG->win,STUDY);
}
