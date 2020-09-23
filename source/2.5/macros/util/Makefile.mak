#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = utillib
NAM = SCI/macros/util

MACROS = sysconv.sci readc_.sci lin.sci halt.sci bloc2exp.sci \
	pol2tex.sci texprint.sci bloc2ss.sci \
	cmb_lin.sci eval.sci evstr.sci solve.sci \
	trianfml.sci trisolve.sci sci2map.sci \
	logspace.sci linspace.sci ssprint.sci ssrand.sci \
	sysdiag.sci syslin.sci syssize.sci trfmod.sci manedit.sci \
	x_matrix.sci typeof.sci isdef.sci zeros.sci edit.sci \
	getvalue.sci usermenu.sci macrovar.sci input.sci sci2exp.sci \
	demos.sci whereami.sci projaff.sci\
	printf.sci fprintf.sci sprintf.sci scanf.sci fscanf.sci sscanf.sci \
	xdialog.sci unix_g.sci unix_s.sci unix_x.sci unix_w.sci \
	x_choices.sci odeoptions.sci whos.sci newest.sci\
	excel2sci.sci dec2hex.sci hex2dec.sci getd.sci genlib.sci\
	%b_diag.sci %b_tril.sci %b_triu.sci %c_diag.sci %c_eye.sci\
	%c_ones.sci %c_rand.sci %c_tril.sci %c_triu.sci\
	%lss_eye.sci %lss_inv.sci %lss_ones.sci %lss_rand.sci %lss_size.sci\
	%p_det.sci %p_inv.sci %p_prod.sci %p_sum.sci\
	%r_clean.sci %r_det.sci %r_diag.sci %r_eye.sci %r_inv.sci\
	%r_ones.sci %r_rand.sci %r_size.sci %r_tril.sci %r_triu.sci\
	%s_pow.sci %s_sort.sci %s_simp.sci %p_simp.sci %r_simp.sci\
	%sp_ceil.sci %sp_cos.sci %sp_diag.sci %sp_exp.sci\
	%sp_floor.sci %sp_imag.sci %sp_int.sci %sp_inv.sci\
	%sp_real.sci %sp_round.sci %sp_sin.sci %sp_sort.sci\
	%sp_sqrt.sci %sp_sum.sci %sp_tril.sci %sp_triu.sci\
	%spb_diag.sci %spb_tril.sci %spb_triu.sci %sp_norm.sci \
	G_make.sci hypermat.sci menubar.sci \
	getclick.sci stripblanks.sci define.sci\
	mfile2sci.sci translatepaths.sci \
	adj2sp.sci sp2adj.sci mps2linpro.sci date.sci

OLD=g_ones.sci g_rand.sci g_eye.sci g_diag.sci g_triu.sci g_tril.sci \
	g_size.sci g_inv.sci g_det.sci  g_sort.sci \
	g_real.sci g_imag.sci g_int.sci g_floor.sci g_ceil.sci g_pow.sci \
	g_sin.sci g_cos.sci g_round.sci g_exp.sci g_sqrt.sci po_sum.sci\
	sp_sum.sci c_sort.sci 

include ../Make.lib.mak
