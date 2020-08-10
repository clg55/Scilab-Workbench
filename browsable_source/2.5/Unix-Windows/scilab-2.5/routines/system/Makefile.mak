#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..
include ../../Version.incl

LIBRARY = $(SCIDIR)/libs/system.lib

OBJSC = System.obj System2.obj Calelm.obj Sun.obj Intersci.obj Blas.obj Lapack.obj helpap.obj \
	scicurdir.obj 

OBJSF = allops.obj  banier.obj sascii.obj \
	clause.obj comand.obj compcl.obj   \
	defmat.obj eqid.obj error.obj showstack.obj expr.obj fact.obj funs.obj \
	getch.obj  getlin.obj getnum.obj getstr.obj getsym.obj \
	getval.obj helpmg.obj inisci.obj \
	logops.obj macro.obj mname.obj nextj.obj parse.obj print.obj \
	prompt.obj putid.obj  run.obj savlod.obj  stackg.obj stackgl.obj \
	ref2val.obj stackp.obj terme.obj xchar.obj  scirun.obj \
	majmin.obj apropo.obj whatln.obj \
	seteol.obj setlnb.obj skpins.obj msgs.obj prntid.obj \
	cvname.obj cvstr.obj compil.obj ptover.obj ptrback.obj \
	isbrk.obj scilab.obj sciquit.obj bexec.obj scilines.obj \
	mrknmd.obj mkindx.obj mklist.obj cmdstr.obj setgetmode.obj\
	typ2cod.obj israt.obj funnam.obj dspdsp.obj lspdsp.obj wspdsp.obj \
	xerbla.obj algebre.obj storeglobal.obj setippty.obj allowptr.obj copyvar.obj \
	lst2vars.obj createref.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) 

FFLAGS = $(FC_OPTIONS)

include ../Make.lib.mak

Makefile.mak	: Makefile
	$(SCIDIR)/util/Mak2VCMak Makefile

Makefile.libmk	: Makefile
	$(SCIDIR)/util/Mak2ABSMak Makefile

include Make.banier.mak

System.obj: ../machine.h
System2.obj: ../machine.h
Calelm.obj: ../machine.h
Sun.obj: ../machine.h
Intersci.obj: ../machine.h
Blas.obj: ../machine.h

allops.obj: ../stack.h
apropo.obj: ../stack.h
bexec.obj: ../stack.h
clause.obj: ../stack.h
cmdstr.obj: ../stack.h
comand.obj: ../stack.h
compcl.obj: ../stack.h
compil.obj: ../stack.h
cvname.obj: ../stack.h
cvstr.obj: ../stack.h
defmat.obj: ../stack.h
eqid.obj: ../stack.h
error.obj: ../stack.h
expr.obj: ../stack.h
fact.obj: ../stack.h
funnam.obj: ../stack.h
funs.obj: ../stack.h
getch.obj: ../stack.h
getlin.obj: ../stack.h
getnum.obj: ../stack.h
getstr.obj: ../stack.h
getsym.obj: ../stack.h
getval.obj: ../stack.h
helpmg.obj: ../stack.h
inisci.obj: ../stack.h
israt.obj: ../stack.h
logops.obj: ../stack.h
macro.obj: ../stack.h
matla0.obj: ../stack.h ../machine.h
mkindx.obj: ../stack.h
mklist.obj: ../stack.h
mname.obj: ../stack.h
mrknmd.obj: ../stack.h
msgs.obj: ../stack.h
msize.obj: ../stack.h
nextj.obj: ../stack.h
parse.obj: ../stack.h
print.obj: ../stack.h
prntid.obj: ../stack.h
prompt.obj: ../stack.h
ptover.obj: ../stack.h
ptrback.obj: ../stack.h
putid.obj: ../stack.h
run.obj: ../stack.h
sascii.obj: ../stack.h
savlod.obj: ../stack.h
scilines.obj: ../stack.h
sciquit.obj: ../stack.h
scirun.obj: ../stack.h ../machine.h ../callinter.h
seteol.obj: ../stack.h
setgetmode.obj: ../stack.h
setlnb.obj: ../stack.h
skpins.obj: ../stack.h
stackg.obj: ../stack.h
stackp.obj: ../stack.h
terme.obj: ../stack.h
typ2cod.obj: ../stack.h
whatln.obj: ../stack.h
xchar.obj: ../stack.h
refval2.obj: ../stack.h
xerbla.obj: ../stack.h

