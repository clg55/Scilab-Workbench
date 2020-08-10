#include <stdio.h>
#include <string.h>

#ifdef WIN32 
#include "menusX/wmen_scilab.h" 
#else
#include "menusX/men_scilab.h"
#include "xsci/All-extern.h"
#endif

#include "machine.h"
#include "defs.h"
#include "color.h"
#include "list.h"
#include "graph.h"
#include "graphics.h"
#include "menus.h"
#include "graphics/Graphics.h"
#include "sun/Sun.h"
#include "functions.h"

char SciGraphName[MAXNAM];
char *Version = "1.3.2";

/* constants */

int arrowLength = ARROWLENGTH;
int arrowWidth = ARROWWIDTH;
int bezierDy = BEZIERDY;
double arcDx = ARCDX;
int arcDy = ARCDY;
int incX = INCX;
int incY = INCY;


static void reset_metanet_handlers _PARAMS((void));

/*-----------------------------------------------------
 * set info field of graphic windows 
 * or graphic window name 
 *----------------------------------------------------*/

void SetTitle(win,menu,info)
     int win;
     int menu;
     char *info;
{
  int oldwin;
  char title[2 * MAXNAM];
  char icon[2 * MAXNAM];
  sprintf(title,"%s : %s",SciGraphName,info);
  strcpy(icon,"Metanet");
  oldwin= SetMetanetWin(win);
  wininfo(title);
  SetMetanetWin(oldwin);
}

void SetGraphWinName(win,gname)
     int win ;
     char *gname;
{
  int oldwin;
  char title[2 * MAXNAM];
  char icon[2 * MAXNAM];
  oldwin= SetMetanetWin(win);
  sprintf(title,"%s (%s)",gname,SciGraphName);
  sprintf(icon,"%s",gname);
  Setpopupname(title);
  SetMetanetWin(oldwin);
}

/*---------------------------------------------------------------
 * We change the default behaviour of Scilab event handling 
 * by providing handlers which are called before standard 
 * event handling 
 * command_handler: 
 *   take care of metanet commands 
 *   returns 1 if it take care of the command and 0 if the command 
 *   must be transmited 
 *---------------------------------------------------------------*/

int command_handler(command)
     char *command;
{
  /* sciprint("Je suis ds le command handler\r\n"); */
  /* check if command is a metanet command */
  return DecodeMenus(command,strlen(command));
}

/*---------------------------------------------------------------
 * Used to change default behaviour of Scilab clicks
 * returns 1 if it take care of the click and 0 if the click
 * must be transmited 
 *---------------------------------------------------------------*/

int click_handler(win,x,y,ibut,motion,release)
     int win,x,y,ibut,motion,release;
{
  MetanetGraph *MG;
  /* sciprint("Je suis ds le click handler %d\r\n",ibut); */
  if ( ibut == -100) return 0;
  if ((MG = get_graph_win (win))== NULL) return 0;
  if ( MG->Graph != NULL) 
    {
      static int n=1;
      double xx,yy;
      C2F(echelle2d)(&xx,&yy,&x,&y,&n,&n,"i2f",3L);
      x=xx; y=yy;
      switch ( ibut ) 
	{
	case  0 :  ActionWhenPress1(MG,x,y); break;
	case  2 :  ActionWhenPress3(MG,x,y); MG->but3f = 1; break;
	case -3 :  ActionWhenRelease3(MG,x,y); MG->but3f = 0; break;
	case -1 :  
	  if ( MG->but3f == 1 )  
	    ActionWhenDownMove3(MG,x,y); 
	  else 
	    ActionWhenMove(MG,x,y); 
	  break;
	}
    }
  return 1;
}


/*---------------------------------------------------------------
 * Used to change default behaviour of graphic windows quit 
 *---------------------------------------------------------------*/

void metanet_quit_handler(win)
     int win;
{
  /* sciprint("Je suis ds le quit handler XXX\r\n"); */
  delete_graph_win(win);
  if ( check_graph_win() == -1 ) 
    {
      /* XXX: we reset handlers when no graph are present 
       * but this is not a good idea if metanet windows still 
       * exist without a loaded graph inside 
       * sciprint("Plus de fenetre, je peux tuer les handlersXXX\r\n"); */
      reset_metanet_handlers();
    }
}

/*---------------------------------------------------------------
 * set and reset metanet handlers 
 *---------------------------------------------------------------*/

static void init_metanet_handlers()
{
  set_scig_command_handler(command_handler);
  set_scig_click_handler(click_handler);
  set_scig_deletegwin_handler(metanet_quit_handler);
  set_scig_handler(draw_graph); 
}

static void reset_metanet_handlers()
{
  reset_scig_handler();
  reset_scig_click_handler();
  reset_scig_deletegwin_handler();
  reset_scig_command_handler();
}


/*---------------------------------------------------------------
 * metanet call : the main function 
 *--------------------------------------------------------------*/

int Mymetane(path,wdim,wpdim,win,mode,flag)
     char *path,*mode;
     int *wdim,*wpdim,win,flag;
{
  MetanetGraph *MG=NULL, *MGold;
  if ( strcmp(mode,"new")==0)     win = check_graph_win()+1;
  SetMetanetWin(win);
  sprintf(SciGraphName,"SciGraph %s",Version);
  SetTitle(win,BEGIN,"begin menu");
  CreateMenus(win);
  /*  InitMetanetHelp(); */
  if ( flag == 1 ) 
    {
      /* Note that here the scales are supposed to be 
       * initialized by a previous call to Mymetane 
       * see (show_graph.sci)
       */
      MG=LoadCommGraph(win,path,1);
    }
  else 
    {
      if ((MGold = get_graph_win (win)) != NULL) 
	{
	  switch (MGold->menuId) {
	  case STUDY :  StudyQuit(win); break;
	  case MODIFY : ModifyQuit(MGold,1); break;
	  case BEGIN : break;
	  }
	}
      InitScale(MG,win,wdim,wpdim);
      MG=InitMetanet(path,win,flag);
    }
  init_metanet_handlers();
  return 0;
}


/*----------------------------------------------------
 * Quit button 
 *---------------------------------------------------*/

void MetanetQuit(win)
{
  /* delete win will delete the graphic window win and 
   * will call the metanet quit handler (see above) 
   */
  C2F(deletewin)(&win) ;
}




