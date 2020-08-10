#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/libcomm.lib

OBJSC = buf_dynam.obj communicat.obj format_mess.obj \
	gest_memoire.obj gest_messages.obj list_chainees.obj \
	utilitaires.obj

OBJSF =

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak

buf_dynam.obj: gestion_memoire.h listes_chainees.h buffer_dynamiques.h
communicat.obj: gestion_memoire.h formatage_messages.h utilitaires.h libCom.h \
	gestion_messages.h communications.h
format_mess.obj: gestion_memoire.h buffer_dynamiques.h utilitaires.h \
	formatage_messages.h libCom.h
gest_memoire.obj: gestion_memoire.h
gest_messages.obj: utilitaires.h libCom.h formatage_messages.h \
	 gestion_memoire.h gestion_messages.h
list_chainees.obj: listes_chainees.h
utilitaires.obj: gestion_memoire.h buffer_dynamiques.h utilitaires.h

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.libmk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile
