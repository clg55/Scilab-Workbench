#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

SCIDIR=../..
SCIDIR1=..\..

include ../../Makefile.incl.mak

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = mtlblib
NAM = SCI/macros/mtlb

MTLB = mtlb.sci mtlb_e.sci mtlb_i.sci mtlb_is.sci mtlb_eval.sci \
	mtlb_max.sci mtlb_min.sci \
	mtlb_ones.sci mtlb_zeros.sci mtlb_eye.sci mtlb_rand.sci mtlb_length.sci\
	mtlb_fscanf.sci \
	mtlb_all.sci mtlb_any.sci mtlb_sum.sci mtlb_cumsum.sci \
	mtlb_prod.sci mtlb_cumprod.sci mtlb_median.sci mtlb_std.sci mtlb_mean.sci\
	mtlb_ifft.sci  mtlb_fft.sci mtlb_filter.sci mtlb_choices.sci  \
	mtlb_findstr.sci mtlb_exist.sci  mtlb_qz.sci \
	mtlb_load.sci mtlb_save.sci mtlb_fread.sci mtlb_fwrite.sci\
	fseek_origin.sci mtlb_sscanf.sci mtlb_fprintf.sci mtlb_sprintf.sci \
	mtlb_diff.sci mtlb_fliplr.sci mtlb_flipud.sci mtlb_isreal.sci \
        mtlb_find.sci mtlb_isa.sci\
	%s_m_b.sci %b_m_s.sci %s_x_b.sci %b_x_s.sci %b_g_s.sci %b_h_s.sci \
	%s_a_b.sci %b_a_s.sci %s_s_b.sci %b_s_s.sci \
	%b_c_s.sci %b_f_s.sci %s_c_b.sci %s_f_b.sci %s_g_b.sci %s_h_b.sci \
	%b_sum.sci %b_prod.sci

M5 = mtlb_cell.sci  cell.sci struct.sci  \
	%ce_string.sci %st_string.sci \
	%s_i_st.sci %b_i_st.sci %i_i_st.sci %sp_i_st.sci \
	%c_i_st.sci %ce_i_st.sci %p_i_st.sci \
	%l_i_st.sci %st_i_st.sci %r_i_st.sci %lss_i_st.sci\
	%spb_i_st.sci %mc_i_st.sci %hm_i_st.sci\
	%st_p.sci %st_e.sci \
        %ce_e.sci %ce_p.sci %ce_size.sci  \
	%b_i_ce.sci %ce_i_ce.sci %i_i_ce.sci %p_i_ce.sci  \
	%s_i_ce.sci %spb_i_ce.sci %c_i_ce.sci %hm_i_ce.sci \
	%lss_i_ce.sci  %r_i_ce.sci  %sp_i_ce.sci \
	%ce_c_ce.sci %ce_f_ce.sci \
	%ce_c_s.sci %ce_f_s.sci %s_f_ce.sci %s_c_ce.sci \
	%c_c_ce.sci %c_f_ce.sci %ce_f_c.sci %ce_c_c.sci \
	%i_c_ce.sci %i_f_ce.sci %ce_f_i.sci %ce_c_i.sci \
	createstruct.sci

PLOT= mtlb_plot.sci mtlb_subplot.sci mtlb_get.sci mtlb_clf.sci \
	mtlb_hold.sci mtlb_ishold.sci mtlb_mesh.sci mtlb_meshdom.sci \
	mtlb_semilogx.sci mtlb_semilogy.sci mtlb_loglog.sci \
	mtlb_image.sci mtlb_pcolor.sci 

UTIL=enlarge_shape.sci


MACROS =$(MTLB) $(M5) $(PLOT) $(UTIL)

include ../Make.lib.mak

