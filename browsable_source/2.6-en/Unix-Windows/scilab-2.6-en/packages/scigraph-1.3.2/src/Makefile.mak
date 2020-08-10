!include ..\Path.incl

all	: Makelib.mak job message 
	nmake -f Makelib.mak

Makelib.mak : builder.sce
	@echo running builder 
	copy builder.sce  job.sce
	echo quit >> job.sce 
	$(SCIDIR1)\bin\scilex.exe -nwni -f job.sce 
	del job.sce 

job	: 
	nmake -f Makelib.mak

clean  	: 
	nmake -f Makelib.mak clean 
	del Makelib.mak 

distclean::
	del make.exe.stackdump
	del libscigraph.ilk
	del libscigraph.pdb

distclean::
	nmake -f Makelib.mak distclean
	del Makelib.mak 

tests	: all
	@echo no test implemented here 

message:
	@echo ------------------------------------------;
	@echo At Scilab prompt, enter
	@echo "-->exec exXX.sce" to test one example 
	@echo "-->exec libexamples.tst" to test all examples
	@echo ------------------------------------------;
	@echo Type nmake /f Makefile.mak tests 
	@echo to run all tests 
	@echo ------------------------------------------;

