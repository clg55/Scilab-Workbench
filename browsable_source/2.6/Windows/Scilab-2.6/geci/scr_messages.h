/**************************************************/
/* Module de gestion de messages pour le scruteur */
/**************************************************/

#ifndef _SCR_GEST_MESSAGES_
#define _SCR_GEST_MESSAGES_

#include "formatage_messages.h"
#include "params.h"

extern char *Identificateur_application;

extern void envoyer_message __PARAMS((Message message));
extern void envoyer_message_var ();
extern void interpreter_message __PARAMS((Message message));
extern int recevoir_message __PARAMS((int descripteur, Message *message));
extern void envoyer_message_brut __PARAMS((Message message));
extern void envoyer_message_brut_directement __PARAMS((Message message, int destinataire));
extern void erreur_message_actmsg __PARAMS((Message message));

void Erreur_scruteur __PARAMS((char *message_erreur));

#endif
