#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = elemlib
NAM = SCI/macros/elem

MACROS = acos.sci acosm.sci acosh.sci acoshm.sci asin.sci asinm.sci \
	asinh.sci asinhm.sci atanh.sci atanhm.sci cosh.sci coshm.sci\
	cotg.sci coth.sci cothm.sci log10.sci sinh.sci sinhm.sci \
	tan.sci tanm.sci tanh.sci tanhm.sci log2.sci\
	logm.sci  atanm.sci cosm.sci signm.sci sinm.sci sqrtm.sci\
	null.sci fix.sci smooth.sci squarewave.sci sinc.sci\
	toeplitz.sci pertrans.sci \
	modulo.sci pmodulo.sci interpln.sci \
	intl.sci intc.sci integrate.sci \
	erf.sci erfc.sci erfcx.sci binomial.sci \
	speye.sci spzeros.sci sprand.sci spones.sci \
	intsplin.sci inttrap.sci GLoad.sci \
	isinf.sci isnan.sci \
	lex_sort.sci unique.sci union.sci setdiff.sci intersect.sci \
	isempty.sci isequal.sci nextpow2.sci convertindex.sci

include ../Make.lib.mak
