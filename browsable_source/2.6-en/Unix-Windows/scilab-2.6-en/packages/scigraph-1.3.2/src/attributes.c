#include "list.h"
#include "graph.h"
#include "menus.h"
#include "functions.h"

void ObjectCharacteristics(MG) 
     MetanetGraph *MG;
{
  if (MG->GG.n_hilited_nodes == 1 && MG->GG.n_hilited_arcs == 0) {
    StartAddText();
    PrintNode(MG,(node*)MG->GG.hilited_nodes->first->element,1);
    EndAddText();
  }
  else if (MG->GG.n_hilited_nodes == 0 && MG->GG.n_hilited_arcs == 1) {
    StartAddText();
    PrintArc(MG,(arc*)MG->GG.hilited_arcs->first->element,1);
    EndAddText();    
  }
  else {
    StartAddText();
    PrintGraph(MG,0);
    EndAddText();
  }
}

void ObjectAttributes(MG)
     MetanetGraph *MG;
{
  if (MG->GG.n_hilited_nodes == 1 && MG->GG.n_hilited_arcs == 0) {
    PrintModifyNode(MG,(node*)MG->GG.hilited_nodes->first->element);
  }
  else if (MG->GG.n_hilited_nodes == 0 && MG->GG.n_hilited_arcs == 1) {
    PrintModifyArc(MG,(arc*)MG->GG.hilited_arcs->first->element);
  }
}
