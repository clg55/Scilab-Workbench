#include <mex.h> 
extern Gatefunc intscigraph;
extern Gatefunc intsshowscig;
extern Gatefunc intsshowscigns;
extern Gatefunc intsshowscigns;
extern Gatefunc intsshowscignp;
extern Gatefunc intsshowscignp;
extern Gatefunc intsshowscignames;
extern Gatefunc intsshowscignames;
extern Gatefunc int_scignodenames;
extern Gatefunc int_scignodenames;
extern Gatefunc int_scigarcnames;
extern Gatefunc int_scigarcnames;
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,intscigraph,"scigraph"},
  {(Myinterfun)sci_gateway,intsshowscig,"m6show_scig"},
  {(Myinterfun)sci_gateway,intsshowscigns,"show_scig_nodes"},
  {(Myinterfun)sci_gateway,intsshowscigns,"show_nodes"},
  {(Myinterfun)sci_gateway,intsshowscignp,"show_scig_arcs"},
  {(Myinterfun)sci_gateway,intsshowscignp,"show_arcs"},
  {(Myinterfun)sci_gateway,intsshowscignames,"show_scig_names"},
  {(Myinterfun)sci_gateway,intsshowscignames,"show_names"},
  {(Myinterfun)sci_gateway,int_scignodenames,"scigraph_set_node_menu"},
  {(Myinterfun)sci_gateway,int_scignodenames,"set_node_menu"},
  {(Myinterfun)sci_gateway,int_scigarcnames,"scigraph_set_arc_menu"},
  {(Myinterfun)sci_gateway,int_scigarcnames,"set_arc_menu"},
};
 
int C2F(libscigraph)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  return 0;
}
