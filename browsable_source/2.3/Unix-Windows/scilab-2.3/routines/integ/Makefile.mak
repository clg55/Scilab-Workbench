SHELL = /bin/sh
SCIDIR=../..

LIBRARY = $(SCIDIR)/libs/integ.lib

OBJSC =

OBJSF = ainvg.obj bnorm.obj cfode.obj  ewset.obj fnorm.obj intdy.obj lsoda.obj lsode.obj \
	lsodi.obj prepj.obj prepji.obj prja.obj rscma1.obj rscom1.obj solsy.obj stoda.obj \
	stode.obj stodi.obj svcma1.obj svcom1.obj vmnorm.obj vnorm.obj xerrwv.obj xsetf.obj \
	xsetun.obj dqag0.obj dqags.obj epsalg.obj quarul.obj order.obj \
	rgk4.obj lsdisc.obj lsodar.obj rscar1.obj svcar1.obj rchek.obj roots.obj ddassl.obj \
	colnew.obj ddasrt.obj rkf45.obj rksimp.obj

include ../../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS)

include ../Make.lib.mak 

ddassl.obj: ../stack.h
lsdisc.obj: ../stack.h
xerrwv.obj: ../stack.h
