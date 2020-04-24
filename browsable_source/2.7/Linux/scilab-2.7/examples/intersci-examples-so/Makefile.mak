.SUFFIXES: .desc .sce .dia  $(SUFFIXES)

SCIDIR=../..
SCIDIR1=..\..

DUMPEXTS="$(SCIDIR1)\bin\dumpexts"
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib
INTERSCI="$(SCIDIR1)\bin\intersci-n"
F2C="$(SCIDIR1)\bin\f2c.exe"

include ../../Makefile.incl.mak 

FFLAGS = $(FC_OPTIONS) -DFORDLL
CFLAGS = $(CC_OPTIONS) -DFORDLL 

.desc.c: 
	@echo  generating $*.c 
	@$(INTERSCI) $* 

all	:: message 

TESTS=ex01.dia ex02.dia ex03.dia ex04.dia ex05.dia ex06.dia ex07.dia ex08.dia \
	ex09.dia ex10.dia ex11.dia ex12.dia ex13.dia ex14.dia ex15.dia ex16.dia ex17.dia


message:
	@echo ------------------------------------------;
	@echo At Scilab prompt, enter:;
	@echo -->exec exXX.sce; 
	@echo to execute example XX 
	@echo ------------------------------------------;
	@echo Type nmake /f Makefile.mak tests 
	@echo to run all tests 
	@echo ------------------------------------------;

tests	: $(TESTS) 

distclean	::
	@del *.obj 
	@del *.dia
	@del *.dll
	@del *.ilib 
	@del *.pdk
	@del *.pdb
	@del *.ilk 
	@del *.def
	@del *.exp 
	@del *_builder.sce
	@del *.tmp
	@del *fi.c 
	@del libex*

.sce.dia:
	@"$(SCIDIR1)\bin\scilex.exe"  -nwni -e scitest('$*.sce',%t);quit
