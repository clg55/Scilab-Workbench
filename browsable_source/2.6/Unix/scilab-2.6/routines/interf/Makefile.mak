#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

LIBRARY = $(SCIDIR)/libs/interf.lib

OBJSC = Interf.obj ctest.obj  cs2st.obj getdate.obj stack1.obj stack2.obj stack3.obj

OBJSF = lstelm.obj lstelmi.obj  matdes.obj matdsc.obj matdsr.obj matelm.obj\
	lstops.obj intl_e.obj intl_i.obj \
	matio.obj intdeff.obj intdiary.obj intdisp.obj intexec.obj intexecstr.obj intgetf.obj \
	intgetpid.obj inthost.obj intlib.obj intprint.obj intrat.obj intread.obj intread4b.obj \
	intreadb.obj intwritb.obj intwrite.obj intwrite4b.obj oldloadsave.obj intfile.obj \
	intgetenv.obj intmgetl.obj intfilestat.obj intgetio.obj\
	matimp.obj matlu.obj matnew.obj matode.obj matops.obj matopt.obj\
	matqr.obj matqz.obj matric.obj matsvd.obj matsys.obj \
	polaut.obj polelm.obj polops.obj strelm.obj strops.obj fmlelm.obj\
	logic.obj logelm.obj xawelm.obj misops.obj stack0.obj \
	where.obj indxg.obj defint.obj\
	matodc.obj dasrti.obj\
	intg.obj int2d.obj int3d.obj feval.obj bva.obj comm.obj specfun.obj\
	isany.obj \
	followpath.obj newsave.obj insertfield.obj v2unit.obj v2cunit.obj \
	hmcreate.obj


include ../../Makefile.incl.mak

#CFLAGS = $(CC_OPTIONS) -DNODCD -DNOMETANET -DNOSCICOS -DNOSIGNAL -DNOSOUND -DNOSPARSE

CFLAGS = $(CC_OPTIONS)

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak

bva.obj: ../stack.h
comm.obj: ../stack.h
coselm.obj: ../stack.h
dasrti.obj: ../stack.h
defint.obj: ../stack.h
feval.obj: ../stack.h
fmlelm.obj: ../stack.h
indxg.obj: ../stack.h
intclear.obj: ../stack.h
intcos.obj: ../stack.h
intg.obj: ../stack.h
int2d.obj: ../stack.h
int3d.obj: ../stack.h
logelm.obj: ../stack.h
logic.obj: ../stack.h
lspops.obj: ../stack.h
lstelm.obj: ../stack.h
lstops.obj: ../stack.h
matdes.obj: ../stack.h ../stack-c.h
matdsc.obj: ../stack.h
matdsr.obj: ../stack.h
matelm.obj: ../stack.h
matimp.obj: ../stack.h
matio.obj: ../stack.h
matlu.obj: ../stack.h
matnew.obj: ../stack.h
matodc.obj: ../stack.h
matode.obj: ../stack.h
matops.obj: ../stack.h
matopt.obj: ../stack.h
matqr.obj: ../stack.h
matqz.obj: ../stack.h
matric.obj: ../stack.h
matsvd.obj: ../stack.h
matsys.obj: ../stack.h
metane.obj: ../stack.h
misops.obj: ../stack.h
polaut.obj: ../stack.h
polelm.obj: ../stack.h
polops.obj: ../stack.h
sigelm.obj: ../stack.h
specfun.obj: ../stack.h
spelm.obj: ../stack.h
spops.obj: ../stack.h
stack.obj: ../stack.h
strelm.obj: ../stack.h
strops.obj: ../stack.h
where.obj: ../stack.h
xawelm.obj: ../stack.h
stack1.obj: ../callinter.h
intwhat.obj: ../stack.h
intwrite4b.obj: ../stack.h
intread4b.obj: ../stack.h
intdeff.obj : ../stack.h
intdiary.obj : ../stack.h
intdisp.obj : ../stack.h
intexec.obj : ../stack.h
intexecstr.obj : ../stack.h
intgetf.obj : ../stack.h
intgetpid.obj : ../stack.h
inthost.obj : ../stack.h
intlib.obj : ../stack.h
intprint.obj : ../stack.h
intrat.obj : ../stack.h
intread.obj : ../stack.h
intread4b.obj: ../stack.h
intreadb.obj : ../stack.h
intwritb.obj : ../stack.h
intwrite.obj : ../stack.h
intwrite4b.obj : ../stack.h
oldloadsave.obj : ../stack.h
intfile.obj : ../stack.h
intgetenv.obj : ../stack.h
intmgetl.obj: ../stack.h
stack0.obj stack1.obj stack2.obj: ../stack.h
getdate.obj: ../machine.h



Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.amk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile
