#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/rand.lib

OBJSC = Rand.obj

OBJSF = advnst.obj genbet.obj genchi.obj genexp.obj genf.obj gengam.obj genmn.obj genmul.obj gennch.obj gennf.obj gennor.obj genprm.obj genunf.obj getcgn.obj getsd.obj ignbin.obj ignlgi.obj ignnbn.obj ignpoi.obj ignuin.obj initgn.obj inrgcm.obj lennob.obj mltmod.obj phrtsd.obj qrgnin.obj ranf.obj sdot.obj setall.obj setant.obj setgmn.obj setsd.obj sexpo.obj sgamma.obj snorm.obj spofa.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile



advnst.obj:      ../stack.h
genf.obj:      ../stack.h
gennf.obj:      ../stack.h
getcgn.obj:      ../stack.h
getsd.obj:      ../stack.h
ignuin.obj:      ../stack.h
initgn.obj:      ../stack.h
mltmod.obj:      ../stack.h
setant.obj:      ../stack.h


