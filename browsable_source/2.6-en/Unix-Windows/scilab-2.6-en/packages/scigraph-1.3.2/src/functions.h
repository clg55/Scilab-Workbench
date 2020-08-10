#ifndef METANET_PROTOS 
#define METANET_PROTOS 

/* scilab */

extern void  scig_replay _PARAMS((int win));
extern void  scig_print _PARAMS((int win));
extern void  scig_export _PARAMS((int win));
extern void     Setpopupname _PARAMS((char *));
#ifdef WIN32 
extern void scig_h_winmeth_print _PARAMS((int win));
void scig_h_copyclip _PARAMS((int win));
void scig_h_copyclip1 _PARAMS((int win));
#endif 

/* graphics.c */

void graph_zoom_get_rectangle _PARAMS(( double bbox[4]));
int scig_driverX11 _PARAMS((char *old));

/* graphlist */

extern void set_graph_win   _PARAMS((   integer i, MetanetGraph *MG));
extern MetanetGraph *get_graph_win _PARAMS(( int win_num));
extern void delete_graph_win _PARAMS((integer i));
extern int check_graph_win _PARAMS((void));

/* font.c */

int FontSelect _PARAMS((int s));

/* actions.c */

extern void ActionWhenExpose _PARAMS((MetanetGraph *MG));
extern void ActionWhenPress1 _PARAMS((MetanetGraph *MG,int x, int y));
extern void ActionWhenMove _PARAMS((MetanetGraph *MG,int x, int y));
extern void ActionWhenPress3 _PARAMS((MetanetGraph *MG,int x, int y));
extern void ActionWhenRelease3 _PARAMS((MetanetGraph *MG,int x, int y));
extern void ActionWhenDownMove3 _PARAMS(( MetanetGraph *MG,int x, int y));
extern void WhenOnStudyMove _PARAMS(( MetanetGraph *MG,int x, int y));

/* attributes.c */ 

extern void ObjectCharacteristics _PARAMS((MetanetGraph *MG));
extern void ObjectAttributes _PARAMS((MetanetGraph *MG));

/* bezier.c */ 

extern int bez _PARAMS((int x0, int y0, int x1, int y1, int x2, int y2, int x3, int y3));

/* color.c */ 

extern void ColorArc _PARAMS((MetanetGraph *,arc *a));
extern void ColorNode _PARAMS((MetanetGraph *,node *n));
extern void ColorObject _PARAMS((MetanetGraph *));

/* comm.c */ 

extern MetanetGraph *LoadCommGraph _PARAMS((int win,char *b, int sup));

/* draw.c */

extern int CheckSciWin _PARAMS((void));
extern void ClearDraw _PARAMS((int win));
extern int SetMetanetWin _PARAMS((int win));

extern int InitScale _PARAMS( (MetanetGraph *,int win,int *iwdim,int* ewdim));
extern int NewScales _PARAMS((MetanetGraph *,int xmin, int ymin, int xmax, int ymax));
extern void GetDrawGeometry _PARAMS( (MetanetGraph *,int *x, int *y, int *w, int *h));
extern int SetMGScales  _PARAMS( (MetanetGraph *));


typedef void (*draw_fun) _PARAMS((MetanetGraph *,void *));
extern void Meta_Draw _PARAMS( (MetanetGraph *MG, void *obj, draw_fun));
extern void Meta_Clear _PARAMS((MetanetGraph *MG,void *obj, draw_fun));
extern void Meta_DrawXor _PARAMS((MetanetGraph *MG,void *obj, draw_fun));
extern void draw_arc_name _PARAMS( (MetanetGraph *MG,void *o));
extern void draw_arc _PARAMS((MetanetGraph *MG,void *o));
extern void draw_arc_arrow _PARAMS((MetanetGraph *MG,void *o));
extern void draw_node_name _PARAMS((MetanetGraph *MG,void *o));
extern void draw_plain_node _PARAMS((MetanetGraph *MG,void *o));

/* file.c */ 

extern int check_graph_sufix  _PARAMS((char *name));
extern char *MStripGraph _PARAMS((char *name));
extern char *mybasename _PARAMS((char *name));
extern char *metanedirname _PARAMS((char *pat));

/* find.c */ 

extern void FindNode _PARAMS((     MetanetGraph *MG));
extern int NodeVisible _PARAMS(( MetanetGraph *MG,node *n));
extern void FindArc _PARAMS((     MetanetGraph *MG));
extern int ArcVisible _PARAMS(( MetanetGraph *MG,arc *a));

/* font.c */ 

extern int FontSelect _PARAMS((int i));

/* graph.c */

extern void DestroyMetanetGraph _PARAMS(( MetanetGraph *MG));
extern void DestroyNode _PARAMS(( graph *,node *n));
extern void DestroyArc _PARAMS(( graph *,arc *a));
extern void DestroyNodes _PARAMS(( graph *));
extern void DestroyArcs _PARAMS(( graph *));

extern node *NodeAlloc _PARAMS((int i));
extern void XmetaDelObject _PARAMS(( MetanetGraph *MG));
extern void DeleteNode _PARAMS(( MetanetGraph *MG,node *n, graph *g));
extern int ComputeNewType _PARAMS((node *t, node *h));
extern void DeleteArc _PARAMS(( MetanetGraph *MG,arc *a, graph *g));
extern void PrintGraph _PARAMS((MetanetGraph *MG, int level));
extern void PrintModifyNode _PARAMS(( MetanetGraph *MG,node *n));
extern void PrintModifyArc _PARAMS(( MetanetGraph *MG,arc *a));
extern void RenumberGraph _PARAMS((graph *g));
extern void CopyArcInGraph _PARAMS((arc *a1, graph *g, arc *a2));
extern void CopyNodeInGraph _PARAMS((node *n1, graph *g, node *n2));
extern void ClearGG  _PARAMS(( MetanetGraph *MG));
extern int  AllocGG _PARAMS(( MetanetGraph *MG));
extern MetanetGraph *AllocMetanetGraph _PARAMS((char *name));
extern int draw_graph _PARAMS((int win_num));
 
extern void ExposeBegin _PARAMS((void));
extern void ExposeStudy _PARAMS((void));
extern void ExposeModify _PARAMS((void));
extern type_id PointerInObject _PARAMS((   MetanetGraph *MG,int x, int y, ptr *object));
extern void WhenPress1 _PARAMS((MetanetGraph *MG,int x, int y));
extern void WhenPress3 _PARAMS((MetanetGraph *MG,int x, int y));
extern void StopMoving _PARAMS((MetanetGraph *MG,int x, int y));
extern void WhenRelease3 _PARAMS((MetanetGraph *MG,int x, int y));
extern void WhenDownMove _PARAMS((MetanetGraph *MG,int sx, int sy, int x, int y));
extern int PointerInArrow _PARAMS((MetanetGraph *,int x, int y, arc *a));
extern int PointerInThisArc _PARAMS((MetanetGraph *,int x, int y, arc *a));
extern int PointerInArc _PARAMS((MetanetGraph *,int x, int y, ptr *object));
extern void ActivateWhenPressArc _PARAMS((   MetanetGraph *MG,arc *a));
extern void SetCoordinatesArc _PARAMS((   MetanetGraph *MG,arc *a));
extern void DrawMovingArc _PARAMS(( MetanetGraph *MG,arc *a));
extern void EraseMovingArc _PARAMS(( MetanetGraph *MG,arc *a));
extern int PointerInNode _PARAMS((MetanetGraph *,int x, int y, ptr *object));
extern void ActivateWhenPress1Node _PARAMS((   MetanetGraph *MG,node *n));
extern void ActivateWhenPress3Node _PARAMS((   MetanetGraph *MG,node *n));
extern void MoveNode _PARAMS(( MetanetGraph *MG,int nx, int ny, node *n));

extern void DrawMovingNode _PARAMS(( MetanetGraph *MG,node *n));
extern void EraseMovingNode _PARAMS(( MetanetGraph *M,node *n));
extern void CreateLoop _PARAMS(( MetanetGraph *M));
extern void CreateSource _PARAMS(( MetanetGraph *M));
extern void CreateSink _PARAMS(( MetanetGraph *M));
extern void RemoveSourceSink _PARAMS(( MetanetGraph *M));
extern void ChooseDefaults _PARAMS(( MetanetGraph *M));
extern void UnhiliteAll _PARAMS((    MetanetGraph *MG));
extern int ComputeBox _PARAMS((    MetanetGraph *MG));

/* help.c */ 

extern void DisplayHelp _PARAMS((char *file));
extern void DisplayBeginHelp _PARAMS((void));
extern void DisplayStudyHelp _PARAMS((void));
extern void DisplayModifyHelp _PARAMS((void));

/* init.c */

extern  MetanetGraph * InitMetanet _PARAMS((char *path,int win,int flag));
extern void InitMetanetHelp _PARAMS( (void));

/* list.c */ 

extern void DestroyLinks  _PARAMS(( mylink *l));
extern void DestroyList _PARAMS((list *l));
extern mylink *MylinkAlloc _PARAMS((ptr e, mylink *n));
extern int CompString _PARAMS((char **s1, char **s2));
extern void PrintArcList _PARAMS((MetanetGraph *, list *l, int level));
extern void PrintNodeList _PARAMS((MetanetGraph *,list *l, int level));


/* load.c */

extern MetanetGraph *NewGraph _PARAMS((int win));
extern MetanetGraph *LoadGraph _PARAMS((int win));
extern int LoadNamedGraph _PARAMS((char *name));
extern int MenuGetFileName _PARAMS((char *res));
extern MetanetGraph *LoadComputeGraph _PARAMS((int win,char *name));
extern void ChangeDirectory _PARAMS((void));

/* menu.c */

extern int get_arc_name_info  _PARAMS((char *name));
extern int get_node_name_info  _PARAMS((char *name));
extern void GraphSelect _PARAMS((int win,int number));
extern void ModifySelect _PARAMS((int win,int number));
extern void MenuRedraw _PARAMS((int win));
extern void MenuHelp _PARAMS((int win));
extern void CreateMenus _PARAMS((int win));
extern int DecodeMenus _PARAMS((char *str, int lstr));
extern void DisplayBeginMenu _PARAMS((int win));
extern void DisplayStudyMenu _PARAMS((int win));
extern void DisplayModifyMenu _PARAMS((int win));
extern void Graphics _PARAMS((void));

/* message.c */

extern void AddMessage _PARAMS((char *description));

/* metanet.c */ 

extern void SetTitle _PARAMS((int win,int menu,char *gname));
extern int main _PARAMS((unsigned int argc, char **argv));
extern void MetanetQuit _PARAMS((int win));
extern void SetGraphWinName _PARAMS(( int win ,  char *gname));

/* movedraw.c */ 

extern void GetDrawGeometry _PARAMS((MetanetGraph *,int *x, int *y, int *w, int *h));

/* myhsearch.c */ 

extern int myhcreate _PARAMS((unsigned int nel));
extern void myhdestroy _PARAMS((void));

/* name.c */ 

extern void NameObject _PARAMS((   MetanetGraph *MG));
extern void AutomaticName _PARAMS((MetanetGraph *MG));
extern void NameArc _PARAMS((MetanetGraph *,arc *a));
extern void ChangeArcName _PARAMS((MetanetGraph *,arc *a, char *str));
extern void NameNode _PARAMS((MetanetGraph *,node *nod));
extern void ChangeNodeName _PARAMS((MetanetGraph *,node *n, char *));


/* save.c */ 

extern int Named _PARAMS((MetanetGraph *));
extern int SaveGraph _PARAMS((MetanetGraph *));
extern void WriteGraphToGraphFile _PARAMS((FILE *f, graph *g));
extern void WriteArcToGraphFile _PARAMS((FILE *f, arc *a));
extern void WriteNodeToGraphFile _PARAMS((FILE *f, node *n));
extern int RenameSaveGraph _PARAMS((MetanetGraph *));

/* text.c */ 
extern void StartAddText _PARAMS((void));
extern void AddText _PARAMS((char *description));
extern void EndAddText _PARAMS((void));

#ifdef __ENTRY 
extern ENTRY *myhsearch _PARAMS((ENTRY item, ACTION  a));
#endif

#endif 


