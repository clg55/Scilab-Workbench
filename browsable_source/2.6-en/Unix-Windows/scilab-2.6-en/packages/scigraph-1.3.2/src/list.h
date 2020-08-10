#ifndef __METANET_LIST 
#define  __METANET_LIST 

#include "machine.h"

typedef int type_id;
#define ARC 1
#define NODE 2

typedef char *ptr;

typedef struct mylinkdef {
  ptr element;
  struct mylinkdef *next;
} mylink;

typedef struct listdef {
  mylink *first;
} list;

extern void AddListElement _PARAMS((ptr e, list *l));
extern void RemoveListElement _PARAMS((ptr e, list *l));
extern int FindInLarray _PARAMS((char *s, char **lar));
extern list *ListAlloc _PARAMS((void));
extern void SortLarray _PARAMS((char **lar));


#endif /**  __METANET_LIST  **/
