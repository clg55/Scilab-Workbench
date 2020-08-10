/**************************************************************************
 * GeCI : Gestionnaire de Communications Interactif
 **************************************************************************/

/* Possibilite d'augmenter le nombre d'entrees pour select */
/* #define FD_SETSIZE 256 */

#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <netdb.h>

#if defined(netbsd)
#include <ieeefp.h>
#endif

#if defined(freebsd)
#include <floatingpoint.h>
#endif

#include "listes_chainees.h"
#include "utilitaires.h"
#include "gestion_memoire.h"

#include "formatage_messages.h"
#include "libCom.h"

#include "scr_liaisons.h"
#include "scr_messages.h"
#include "scr_applications.h"
#include "scruteur.h"
#ifdef __STDC__
#include <stdlib.h>
#include <unistd.h>
#endif 

static void signal_arret_scruteur();

fd_set readfds, writefds, exceptfds;
int socket_com;
char machine_hote[MAXHOSTLEN];

int main(argc,argv)
     int argc;
     char *argv[];
{
  int resultat;
  int statusp, i, w;
  struct hostent *h;
  fd_set r_readfds, r_writefds, r_exceptfds;
  application *application_scrutee;
  Message message, message_recu;
  static struct timeval duree_blocage; 
#if defined (sun) && defined (SYSV)
  sigset_t set,oset;
#endif  

#if defined(netbsd) || defined(freebsd)
  fpsetmask(0);
#endif

  signal(SIGTERM,signal_arret_scruteur);
  signal(SIGQUIT,signal_arret_scruteur);
  signal(SIGINT,signal_arret_scruteur);
#if defined (sun) && defined (SYSV)
  sigemptyset(&set);
  sigemptyset(&oset);
  sigaddset(&set,SIGPIPE);
  sigprocmask(SIG_BLOCK,&set,&oset);
#else
  sigblock(SIGPIPE);
#endif
  
  FD_ZERO (&readfds);
  FD_ZERO (&writefds);
  FD_ZERO (&exceptfds);
  
  if (argc < 2) {
    fprintf(stderr, "Usage : \n\t geci -local <executable file> <args>\nor \n\t geci <file descriptor>\n\n");
    exit(5);
  }
  
  gethostname(machine_hote,MAXHOSTLEN) ;
  /* If host is connected to internet, get canonical name */
  if ((h=gethostbyname(machine_hote))!=NULL)
    strcpy(machine_hote,h->h_name);

  if(!strcmp(argv[1], "-local")) {
    socket_com = -1;
    executer_application(ID_XGeCI,machine_hote,argc-2,argv+2,1);
  }
  else {
    socket_com=atoi(argv[1]);
    if(socket_com==0) {
      fprintf(stderr,"Usage : \n\t geci -local <executable file> \nor \n\t geci <file descriptor>\n\n");
      exit(5);
    }
    ajouter_application(ID_GeCI_local, "INCONNUE", socket_com, socket_com, -2);
  }
  
  /* WHILE */
  while(1) {
    r_readfds=readfds;
    r_writefds=writefds;
    r_exceptfds=exceptfds;
    
    application_scrutee = ldc_rechercher_objet(liste_applications,NULL);
    
    while(application_scrutee != NULL) {
      /* Don't wait more than 1 second in select */
      duree_blocage.tv_sec = 1;
      duree_blocage.tv_usec = 0;
      resultat=select(FD_SETSIZE,&r_readfds,&r_writefds,&r_exceptfds,&duree_blocage);
      application_suivante=ldc_objet_suivant(liste_applications, application_scrutee -> identificateur_appli);
      /* DEBUT IF */
      if ((application_scrutee->pid != -2) &&
	  ((w = waitpid(application_scrutee->pid,&statusp,WNOHANG)) 
	   && (WIFEXITED(statusp) || WIFSIGNALED(statusp)))) 
	/* IF TRUE */
	{
	  /* XGeCI */
	  if (!strcmp(application_scrutee->identificateur_appli,ID_XGeCI)) {
	    supprimer_application(ID_XGeCI);
	    /* Suppression de tous les ateliers presents sur la machine */
	    detruire_applications_scruteur();
	    /* Suppression de tous les scruteurs distants */
	    for (i=0; i<nb_machines; i++) {
	      message.taille=3;
	      message.tableau=allouer_type(char *,message.taille+1);
	      message.tableau[0]=dupliquer_chaine(ID_SCRUTEUR);
	      message.tableau[1]=dupliquer_chaine(ID_SCRUTEUR);
	      message.tableau[2]=dupliquer_chaine(MSG_DESTRUCTION);
	      envoyer_message_brut_directement(message, liste_machines[i].desc);
	      liberer_message(message);
	    }
	    /* Normal exit from geci */
	    exit(0);
	  }
	  
	  /* Autre Atelier */
	  if (socket_com == -1) {/* GeCI local */
	    envoyer_message_var(ID_XGeCI,
				MSG_FIN_APPLI,
				application_scrutee->identificateur_appli,
				NULL);
	  }
	  else /* GeCI distant */
	    envoyer_message_var(ID_GeCI_local,
				MSG_FIN_APPLI, 
				application_scrutee->identificateur_appli,
				NULL);
	  supprimer_application(application_scrutee->identificateur_appli);
	}
      /* IF FALSE */
      else {
 	if (resultat && FD_ISSET (application_scrutee->pipe_vers_scruteur,&r_readfds)) {
	  if (!recevoir_message(application_scrutee->pipe_vers_scruteur,&message_recu))
	    continue;
	  if ((message_recu.taille >= 3) &&
	      (!strcmp(message_recu.tableau[1],Identificateur_application))) {
	    
	    interpreter_message(message_recu);
	    liberer_message(message_recu);
	  }
	  else fprintf(stderr,"Scrutation: <main> incorrect message format\n");
	}}
      /* FIN IF */
      application_scrutee=application_suivante;
    }
  }
  /* END WHILE */
  return 0;
}

static void signal_arret_scruteur()
{
  Erreur_scruteur("<signal_arret_scruteur> : abnormal scrutation stop.");
}


void Erreur_scruteur(message_erreur)
     char *message_erreur;
{
  fprintf(stderr,"Scrutation error: %s\n",message_erreur);
  detruire_applications_scruteur();
  exit(1);
}

