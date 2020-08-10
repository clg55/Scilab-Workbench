SCIDIR1 = ..\..

!include $(SCIDIR1)\Makefile.incl.mak

all	:: builder.sce 
	@echo running builder
	echo predef(0) > job.sce 
	type builder.sce >> job.sce
	echo quit >> job.sce 
	$(SCIDIR1)\bin\scilex.exe -nwni -f job.sce 
	del job.sce 

clean	::
	Makesubdirs.bat clean 

distclean:: clean 
	Makesubdirs.bat distclean 
