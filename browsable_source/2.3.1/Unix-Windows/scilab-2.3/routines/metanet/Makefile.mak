SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/metanet.lib

OBJSC = metanet.obj loadg.obj saveg.obj show.obj connex.obj dmtree.obj paths.obj \
	transc.obj files.obj myhsearch.obj

OBJSF = arbor.obj bandred.obj bmatch.obj busack.obj carete.obj cent.obj cfc.obj chcm.obj \
	clique.obj clique1.obj \
	compc.obj compfc.obj compmat.obj deumesh.obj diam.obj dijkst.obj \
	dfs.obj dfs1.obj dfs2.obj eclat.obj flomax.obj floqua.obj fordfulk.obj frang.obj \
	frmtrs.obj ftrans.obj getran.obj hamil.obj hullcvex.obj kilter.obj kiltq.obj \
	knapsk.obj johns.obj l2que.obj match.obj mesh2b.obj meshmesh.obj minty.obj mintyq.obj \
	pcchna.obj permuto.obj prfmatch.obj prim.obj prim1.obj relax.obj seed.obj \
	tconex.obj visitor.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak

metanet.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h
loadg.obj: ../machine.h mysearch.h defs.h
saveg.obj: ../machine.h
show.obj: ../machine.h ../libcomm/libCalCom.h ../libcomm/libCom.h netcomm.h
connex.obj: ../machine.h
dmtree.obj: ../machine.h
paths.obj: ../machine.h
transc.obj: ../machine.h
myhsearch.obj: mysearch.h
