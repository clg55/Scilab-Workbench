#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = armalib
NAM = arma

MACROS = armax.sci armax1.sci arsimul.sci \
	noisegen.sci narsimul.sci prbs_a.sci  \
	armac.sci reglin.sci acf.sci sdiff.sci epred.sci

include ../Make.lib.mak
