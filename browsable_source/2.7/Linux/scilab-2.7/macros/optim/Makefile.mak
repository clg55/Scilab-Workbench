#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = optlib
NAM = SCI/macros/optim

MACROS = linpro.sci quapro.sci karmarkar.sci pack.sci unpack.sci \
	lmitool.sci \
	lmisolver.sci vec2list.sci list2vec.sci pencost.sci \
	aplat.sci fit_dat.sci leastsq.sci datafit.sci numdiff.sci \
	NDcost.sci

include ../Make.lib.mak
