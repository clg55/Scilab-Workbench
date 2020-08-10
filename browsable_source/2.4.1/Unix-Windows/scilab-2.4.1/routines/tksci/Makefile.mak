#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/tksci.lib

OBJSF = 

OBJSC  = tksci.obj TK_ScilabCallback.obj \
	tksci_SciInterf.obj \
	LAB_TK_DoOneEvent.obj \
	LAB_TK_EvalFile.obj \
	LAB_TK_EvalStr.obj \
	LAB_TK_GetVar.obj \
	LAB_TK_SetVar.obj \
	LAB_figure.obj \
	LAB_findobj.obj \
	LAB_get.obj \
	LAB_opentk.obj \
	LAB_set.obj \
	LAB_uicontrol.obj \
	LAB_close.obj \
	LAB_uimenu.obj \
	TK_uicontrol.obj \
	LAB_gcf.obj \
	LAB_essai.obj \
	gvar.obj \
	LAB_setgvar.obj LAB_getgvar.obj


include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) $(XFLAGS) $(TK_INC_PATH) $(TCL_INC_PATH) -I. -I../fraclab

include ../Make.lib.mak


tksci.obj: ../machine.h



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile
