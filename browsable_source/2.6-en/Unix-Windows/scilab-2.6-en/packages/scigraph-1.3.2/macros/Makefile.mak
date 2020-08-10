#-----------------------------
# generated from Makefile: DO NOT EDIT
# -----------------------------
SHELL = /bin/sh

include ../Path.incl
include $(SCIDIR)/Makefile.incl.mak
include Names.incl

.SUFFIXES: .sci .bin $(SUFFIXES)

NAME = scigraphlib
NAM =  $(CURRENT_DIR)

MACROS = show_scigraph.sci show_graph.sci

include $(SCIDIR)/macros/Make.lib.mak
