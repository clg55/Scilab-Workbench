#include "list.h"
#include "graph.h"
#include "menus.h"
#include "functions.h"

void StudyQuit(win)
     int win;
{
  ClearDraw(win);
  DisplayMenu(win,BEGIN);
}
