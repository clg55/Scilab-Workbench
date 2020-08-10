SCIDIR1 = ..\..

!include $(SCIDIR1)\Makefile.incl.mak

all	:: builder.sce 
	@echo running builder 
	copy builder.sce  job.sce
	echo quit >> job.sce 
	$(SCIDIR1)\bin\scilex.exe -nwni -f job.sce 
	del job.sce 

clean	::
	Makesubdirs.bat clean 

distclean:: clean 
	Makesubdirs.bat distclean 



