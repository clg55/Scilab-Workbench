#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/system2.lib

OBJSC = 

OBJSF = fmttyp.obj getfun.obj chkvar.obj \
	btof.obj btofm.obj ftob.obj \
	bschur.obj bjac.obj bintg.obj bj2.obj bydot.obj boptim.obj bgety.obj bgetx.obj \
	badd.obj bresid.obj bfeval.obj bresd.obj bjacd.obj \
	cvwm.obj cvdm.obj atome.obj iseye.obj \
	matz.obj matc.obj matzs.obj \
	expsum.obj termf.obj bsurf.obj bsurfd.obj tradsl.obj \
	dldsp.obj istrue.obj isnum.obj namstr.obj basnms.obj cmplxt.obj \
	intstr.obj extlarg.obj bcol.obj bsolv.obj bjsolv.obj\
	bydot2.obj rwstack.obj bint2d.obj bint3d.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak


Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.libmk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile



alloc.obj: ../stack.h
back.obj: ../stack.h
badd.obj: ../stack.h ../callinter.h
bcol.obj: ../stack.h ../callinter.h
bfeval.obj: ../stack.h ../callinter.h
bgetx.obj: ../stack.h ../callinter.h
bgety.obj: ../stack.h ../callinter.h
bintg.obj: ../stack.h ../callinter.h
bint2d.obj: ../stack.h ../callinter.h
bint3d.obj: ../stack.h ../callinter.h
bj2.obj: ../stack.h ../callinter.h
bjac.obj: ../stack.h ../callinter.h
bjacd.obj: ../stack.h  ../callinter.h
bjsolv.obj: ../stack.h ../callinter.h
boptim.obj: ../stack.h ../callinter.h
bresd.obj: ../stack.h ../callinter.h
bresid.obj: ../stack.h ../callinter.h
bschur.obj: ../stack.h ../callinter.h
bsolv.obj: ../stack.h ../callinter.h
bsurf.obj: ../stack.h ../callinter.h
bsurfd.obj: ../stack.h ../callinter.h
btof.obj: ../stack.h
btofm.obj: ../stack.h
bydot.obj: ../stack.h ../callinter.h
bydot2.obj: ../stack.h ../callinter.h
cmatptr.obj: ../stack.h
creadchain.obj: ../stack.h
creadmat.obj: ../stack.h
extlarg.obj: ../stack.h
ftob.obj: ../stack.h
getfun.obj: ../stack.h
istrue.obj: ../stack.h
matc.obj: ../stack.h
matptr.obj: ../stack.h
matz.obj: ../stack.h
matzs.obj: ../stack.h
namstr.obj: ../stack.h
readchain.obj: ../stack.h
readmat.obj: ../stack.h
tradsl.obj: ../stack.h
rwstack.obj : ../stack.h
