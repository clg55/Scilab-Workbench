#include "graphics.h"
#include "list.h"
#include "graph.h"
#include "menus.h"
#include "functions.h"
#include "metaconst.h"

/*---------------------------------------------------------------------
 * handlers for buttons 
 *---------------------------------------------------------------------*/

static int sx = 0; /* store current position */
static int sy = 0; /* store current position */

#define MINMOVE 10

void ActionWhenExpose(MG)
     MetanetGraph *MG;
{
  switch (MG->menuId) {
  case BEGIN:    break;
  case STUDY:    ComputeBox(MG);DrawGraph(MG);    break;
  case MODIFY:   ComputeBox(MG);scig_replay(MG->win); break;
  }
}

void ActionWhenPress1(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  sx = x;  sy = y;
  if (MG->menuId == STUDY )  ObjectCharacteristics(MG);
  else 
    {
      if (MG->menuId != BEGIN)    WhenPress1(MG,x,y);
    }
}

void ActionWhenMove(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  if (MG->menuId == STUDY )    WhenOnStudyMove(MG,x,y);
}


void ActionWhenPress3(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  sx = x;  sy = y;
  if (MG->menuId != BEGIN)    WhenPress3(MG,x,y);
}

void ActionWhenRelease3(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  sx = x;  sy = y;
  WhenRelease3(MG,x,y);
}

void ActionWhenDownMove3(MG,x,y)
     MetanetGraph *MG;
     int x,y;
{
  double w = (MG->drawWidth/100.0);
  double h = (MG->drawHeight/100.0);

  if (MG->menuId == MODIFY && 
      ((sx - x) * (sx - x) > w*w ||
       (sy - y) * (sy - y) > h*h)) 
    {
      WhenDownMove(MG,sx,sy,x,y);
      sx = x;
      sy = y;
    }
}








