/*****************************************/
/* Gestion de listes doublement chainees */
/*****************************************/

#ifndef _LISTES_D_CHAINEES_
#define _LISTES_D_CHAINEES_
#include "../machine.h"

typedef void *ldc_objet_liste;
typedef void *ldc_element_correspondance;

typedef struct ldc_Liste_chainee *ldc_liste_chainee;
typedef struct ldc_Element_liste *ldc_element_liste;

struct ldc_Liste_chainee
{
    ldc_element_liste premier_element;
    int (*correspondre)();
    void (*desallouer)();
    void (*liberer)();
    void *(*allouer)();
};

struct ldc_Element_liste
{
    ldc_objet_liste objet;
    ldc_element_liste precedent;
    ldc_element_liste suivant;
};

/* Creation d'une liste doublement chainee. correspondance() est une procedure 
   qui verifie une relation entre un objet de la liste et un parametre defini.
   desallouer() libere un objet. liberer() libere un bloc memoire. allouer()
   en alloue un. Les erreurs d'allocations doivent etre traitees par allouer() */
extern ldc_liste_chainee ldc_creer __PARAMS((int (*correspondre) (), void (*desallouer) (), void (*liberer) (), void *(*allouer) ()));

/* Destruction d'une liste chainee. La destruction appelle la procedure desallouer()
   pour chaque element de la liste. */
extern void ldc_detruire __PARAMS((ldc_liste_chainee liste));

ldc_objet_liste ldc_objet_suivant __PARAMS((ldc_liste_chainee liste, ldc_element_correspondance correspondance));

ldc_objet_liste ldc_objet_precedent __PARAMS( (ldc_liste_chainee liste, ldc_element_correspondance correspondance));

extern void ldc_ajouter_objet __PARAMS( (ldc_liste_chainee liste, ldc_objet_liste objet));

/* Suppresion d'un objet de la liste. La supression entraine l'appel a la procedure
  desallouer(). Si l'objet n'a pu etre trouve, la fonction renvoie 0 */
int ldc_supprimer_objet __PARAMS( (ldc_liste_chainee liste, ldc_objet_liste objet));

/* Recherche d'un objet dans la liste. L'objet retourne correspondra au premier objet
   de la liste sur lequel l'application de la fonction correspondre appelee avec le
   paramettre correspondance retournera 1 */
ldc_objet_liste ldc_rechercher_objet __PARAMS( (ldc_liste_chainee liste, ldc_element_correspondance correspondance));

/* Application d'une fonction sur l'ensemble des objets d'une liste */
void ldc_appliquer_liste __PARAMS( (ldc_liste_chainee liste, void (*fonction_sur_objet) (/* ??? */)));

#endif
