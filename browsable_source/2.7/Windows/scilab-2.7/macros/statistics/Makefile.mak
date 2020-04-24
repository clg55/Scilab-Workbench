#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = statslib
NAM = SCI/macros/statistics

MACROS = center.sci cmoment.sci correl.sci covar.sci ftest.sci ftuneq.sci \
	geomean.sci harmean.sci iqr.sci mad.sci mean.sci meanf.sci median.sci \
	moment.sci msd.sci \
	mvcorrel.sci mvvacov.sci nand2mean.sci nanmax.sci nanmean.sci  \
	nanmeanf.sci nanmedian.sci nanmin.sci nanstdev.sci nansum.sci  \
	nfreq.sci pca.sci perctl.sci quart.sci regress.sci stdev.sci st_deviation.sci  \
	stdevf.sci strange.sci tabul.sci thrownan.sci trimmean.sci  \
	variance.sci variancef.sci wcenter.sci

include ../Make.lib.mak
