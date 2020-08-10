/*************************************************************************************
 * GeCI
 *************************************************************************************/

#ifndef _SCRUTEUR_
#define _SCRUTEUR_

#ifdef aix
#include <sys/select.h>
#endif

#include "params.h"

extern fd_set readfds, writefds, exceptfds;
extern int socket_com;
void Erreur_scruteur __PARAMS((char *message_erreur));

#endif
