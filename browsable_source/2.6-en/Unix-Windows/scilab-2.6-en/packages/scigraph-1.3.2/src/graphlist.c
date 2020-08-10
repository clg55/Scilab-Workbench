/*------------------------------------------------------------------------
 --------------------------------------------------------------------------*/

#include <string.h> /* in case of dbMALLOC use */
#include <stdio.h>
#include <math.h>
#include "graphics/Math.h"

#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "color.h"
#include "menus.h"
#include "metio.h"
#include "graphics.h"
#include "font.h"
#include "functions.h"


typedef struct metanelist
{
  MetanetGraph *Mg;
  integer Win;                        
  struct metanelist *next;
} MetanetList ;


/*----------------------------------------------
 * A List for storing Window scaling information 
 *----------------------------------------------*/

/* The scale List : one for each graphic window */

static MetanetList *The_List = NULL;

/*------------------------------------------------------------
 *-------------------------------------------------------------*/

static MetanetGraph * get_graph_win_1 _PARAMS((MetanetList *listptr, integer win));

MetanetGraph *get_graph_win(i)
     integer i;
{ 
  return get_graph_win_1(The_List,Max(0L,i));
}

static MetanetGraph * get_graph_win_1(listptr, wi)
     MetanetList *listptr;
     integer wi;
{
  if (listptr != (MetanetList  *) NULL)
    { 
      if (listptr->Win == wi)
	  return listptr->Mg;
      else 
	return get_graph_win_1(listptr->next,wi );
    }
  return 0;
}

/*------------------------------------------------------------
 *-------------------------------------------------------------*/

static void set_graph_win_1 _PARAMS((MetanetList **listptr, integer i,  MetanetGraph *MG));

void set_graph_win(i,MG)
     integer i;
     MetanetGraph *MG;
{ 
  set_graph_win_1(&The_List,Max(0L,i),MG);
}

static void set_graph_win_1(listptr, i,MG)
     MetanetList **listptr;
     integer i;
     MetanetGraph *MG;
{
  if ( *listptr == (MetanetList  *) NULL)
    {
      /* window i does not exist add an entry for it */
      if ((*listptr = (MetanetList *) MALLOC( sizeof (MetanetList)))==0)
	{
	  Scistring("AddWindowMetanet_ memory exhausted\n");
	  return;
	}
      else 
	{ 
	  (*listptr)->Win  = i;
	  (*listptr)->next = (MetanetList *) NULL ;
	  (*listptr)->Mg  = MG;
	  return ;
	}
    }
  if ( (*listptr)->Win == i) 
    { 
      DestroyMetanetGraph((*listptr)->Mg);
      (*listptr)->Mg = MG;
    }
  else 
    set_graph_win_1( &((*listptr)->next),i,MG);
}
 

/*------------------------------------------------------------
 *-------------------------------------------------------------*/

void delete_graph_win(i)
     integer i;
{ 
  MetanetList *L = The_List, *prev= NULL;
  while ( L != (MetanetList  *) NULL) 
    {
      if ( L->Win  == i )
	{
	  DestroyMetanetGraph(L->Mg);
	  if ( prev == NULL) 
	    {
	      The_List = L->next;
	      free(L);
	      return ;
	    }
	  else
	    {
	      prev->next = L->next ;
	      free(L);
	      return ;
	    }
	}
      else 
	{ prev = L ; L=L->next;
	}
    }
}


/*------------------------------------------------------------
 * return the max number of window which is is used 
 * or -1 if no window is used 
 *-------------------------------------------------------------*/

int check_graph_win()
{ 
  MetanetList *L = The_List; 
  int count =-1;
  while ( L != (MetanetList  *) NULL) 
    {
      count = Max(count, L->Win );
      L=L->next;
    }
  return count;
}

