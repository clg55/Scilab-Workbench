#include <string.h>
#include "graphics/Math.h"
#include "metaconst.h"
#include "list.h"
#include "graph.h"
#include "metio.h"
#include "graphics.h"
#include "functions.h"

void NameObject(MG)
     MetanetGraph *MG;
{
  arc *a;
  node *n;
  if (MG->GG.n_hilited_nodes == 0 && MG->GG.n_hilited_arcs == 1) {
    a = (arc*)MG->GG.hilited_arcs->first->element;
    NameArc(MG,a);
    MG->GG.modified = 1;
  }
  else if (MG->GG.n_hilited_nodes == 1 && MG->GG.n_hilited_arcs == 0) {
    n = (node*)MG->GG.hilited_nodes->first->element;
    NameNode(MG,n);
    MG->GG.modified = 1;
  }
}

void AutomaticName (MG)
     MetanetGraph *MG;
{
  mylink *p;
  arc *a; node *n;
  char str[MAXNAM];

  sprintf(Description,"Do you REALLY want to use internal numbers for nodes and arcs names ?");
  if (MetanetYesOrNo()) {
    sprintf(Description,"Possibly old existing names will be DEFINITIVELY lost. Ok ?");
    if (MetanetYesOrNo()) {
      RenumberGraph(MG->Graph);
      sprintf(Description,"Graph %s renumbered\n",MG->Graph->name);
      AddMessage(Description);
	  
      MakeArraysGraph(MG->Graph);

      p = MG->Graph->arcs->first;
      while (p) {
	a = (arc*)p->element;
	sprintf(str,"%d",a->number);
	if ((a->name = 
	     (char*)MALLOC((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	  fprintf(stderr,"Running out of memory\n");
	  return;
	}
	strcpy(a->name,str);
	p = p->next;
      }
      p = MG->Graph->nodes->first;
      while (p) {
	n = (node*)p->element;
	sprintf(str,"%d",n->number);
	if ((n->name = 
	     (char*)MALLOC((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
	  fprintf(stderr,"Running out of memory\n");
	  return;
	}
	strcpy(n->name,str);
	p = p->next;
      }
      MG->GG.modified = 1; 
    }
  }
}

void NameArc(MG,a)
     MetanetGraph *MG;
     arc *a;
{
  char str[MAXNAM];
  char *p;

  sprintf(Description,"New name for highlighted arc %s",a->name);
  if (a->name == 0) {if (!MetanetDialog("",str,Description)) return;}
  else {if (!MetanetDialog(a->name,str,Description)) return;}
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      sprintf(Description,"New arc name must not contain white space");
      MetanetAlert();
      return;
    }
  }
  if (a->name != 0 && !strcmp(a->name,str)) return;
  if (MG->arcNameDisplay) {
    UnhiliteArc(MG,a);
    EraseArc(MG,a);
  }
  ChangeArcName(MG,a,str);
  if (MG->arcNameDisplay) HiliteArc(MG,a);
}

void ChangeArcName(MG,a,str)
     MetanetGraph *MG;
     arc *a;
     char *str;
{
  mylink *p;
  int indic;
  arc *aa;

  indic = 0;
  p = MG->Graph->arcs->first;
  while (p) {
    aa = (arc*)p->element;
    if (aa->name != 0 && strcmp(aa->name,str) == 0) {
      indic = 1;
      break;
    }
    p = p->next;
  }
  if (indic == 1) {
    /* str is already the name of another arc */
    HiliteArc(MG,aa);
    sprintf(Description,"%s is already the name of another highlighted arc",
	    str);
    MetanetAlert();
    UnhiliteArc(MG,aa);
  }
  else {
    free(a->name);
    if ((a->name = 
	 (char*)MALLOC((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return;
    }
    strcpy(a->name,str);
  }
}

void NameNode(MG,nod)
     MetanetGraph *MG;
     node *nod;
{
  char str[MAXNAM];
  char *p;
  
  sprintf(Description,"New name for highlighted node %s",nod->name);
  if (nod->name == 0) {if (!MetanetDialog("",str,Description)) return;}
  else {if (!MetanetDialog(nod->name,str,Description)) return;}
  p = str;
  while (*p != '\0') {
    if (*p++ == ' ') {
      sprintf(Description,"New node name must not contain white space");
      MetanetAlert();
      return;
    }
  }
  if (nod->name != 0 && !strcmp(nod->name,str)) return;
  if (MG->nodeNameDisplay) {
    UnhiliteNode(MG,nod);
    EraseNode(MG,nod);
  }
  ChangeNodeName(MG,nod,str);
  if (MG->nodeNameDisplay) HiliteNode(MG,nod);
}

void ChangeNodeName(MG,n,str)
     MetanetGraph *MG;
     node *n;
     char *str;
{
  mylink *p;
  int indic;
  node *nn;
  indic = 0;

  p = MG->Graph->nodes->first;
  while (p) {
    nn = (node*)p->element;
    if (nn->name != 0 && strcmp(nn->name,str) == 0) {
      indic = 1;
      break;
    }
    p = p->next;
  }

  if (indic == 1) {
    /* n is already the name of another node */
    HiliteNode(MG,nn);
    sprintf(Description,"%s is already the name of another highlighted node",
	    str);
    MetanetAlert();
    UnhiliteNode(MG,nn);
  }
  else {
    free(n->name);
    if ((n->name = 
	 (char*)MALLOC((unsigned)(strlen(str)+1)*sizeof(char))) == NULL) {
      fprintf(stderr,"Running out of memory\n");
      return;
   }

    strcpy(n->name,str);
    DrawNode(MG,n);
  }
}

