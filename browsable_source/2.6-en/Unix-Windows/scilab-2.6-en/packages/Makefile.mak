SHELL = /bin/sh

include ../Makefile.incl.mak

SUBDIRS = scigraph-1.3.2 stixbox-1.2.3

all::
	Makesubdirs.bat all

clean::
	Makesubdirs.bat clean

distclean::
	Makesubdirs.bat distclean 
