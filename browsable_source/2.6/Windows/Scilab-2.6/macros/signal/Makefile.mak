#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = siglib
NAM = SCI/macros/signal

MACROS = %k.sci %asn.sci %sn.sci analpf.sci bilt.sci \
	buttmag.sci  casc.sci cheb1mag.sci cheb2mag.sci chepol.sci \
	cspect.sci czt.sci dft.sci ell1mag.sci eqfir.sci cepstrum.sci \
	eqiir.sci faurre.sci ffilt.sci findm.sci find_freq.sci \
	frfit.sci frmag.sci fsfirlin.sci  group.sci hank.sci \
	hilb.sci iir.sci iirgroup.sci iirlp.sci iirmod.sci intdec.sci \
	jmat.sci kalm.sci lattn.sci lev.sci levin.sci yulewalk.sci \
	lindquist.sci mese.sci mfft.sci mrfit.sci phc.sci pspect.sci \
	remezb.sci sinc.sci sincd.sci srfaur.sci sskf.sci convol.sci \
	srkf.sci system.sci trans.sci wfir.sci wiener.sci \
	wigner.sci window.sci zpbutt.sci zpch1.sci zpch2.sci zpell.sci
W=fwiir.sci
include ../Make.lib.mak
