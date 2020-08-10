#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh
SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/pvm.lib

OBJSC = lpack.obj pvm_grp.obj pvm_proc_ctrl.obj pvm_send.obj  pvm_info.obj \
	pvm_recv.obj listsci2f77.obj sci2f77.obj
OBJSF = intpvm.obj mycmatptr.obj varpack.obj scipvmf77tosci.obj scipvmscitof77.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)  -I${PVMROOT}/include

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.amk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile

intpvm.obj: ../stack.h
lpack.obj:../stack-c.h ../machine.h
pvm_grp.obj: ../calelm/sci_tools.h ../machine.h
pvm_info.obj: ../machine.h
pvm_proc_ctrl.obj: ../machine.h
pvm_recv.obj:../stack.h ../calelm/sci_tools.h ../machine.h
pvm_send.obj:../stack.h ../calelm/sci_tools.h ../machine.h




