#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/blas.lib

OBJSC = 

OBJSF = dasum.obj daxpy.obj dcopy.obj ddot.obj dgbmv.obj dgemm.obj dgemv.obj\
	dger.obj dnrm2.obj drot.obj drotg.obj dsbmv.obj dscal.obj dspmv.obj\
	dspr.obj dspr2.obj dswap.obj dsymm.obj dsymv.obj dsyr.obj dsyr2.obj\
	dsyr2k.obj dsyrk.obj dtbmv.obj dtbsv.obj dtpmv.obj dtpsv.obj\
	dtrmm.obj dtrmv.obj dtrsm.obj dtrsv.obj dzasum.obj dznrm2.obj idamax.obj
include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.libmk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile
