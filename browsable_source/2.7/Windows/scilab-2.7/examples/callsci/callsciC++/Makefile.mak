SHELL = /bin/sh

SCIDIR=../../..
SCIDIR1=..\..\..

DUMPEXTS="$(SCIDIR1)\bin\dumpexts"
SCIIMPLIB=$(SCIDIR)/bin/LibScilab.lib

CFLAGS= $(CC_OPTIONS) -DFORDLL -I"$(SCIDIR)/routines"
CPPFLAGS= $(CC_OPTIONS) -DFORDLL -I"$(SCIDIR)/routines"

!include $(SCIDIR)/Makefile.incl.mak 

OBJSC = myprog.obj ccmatrix1.obj 

all:: $(OBJSC)  $(SCIDIR)/bin/prog.exe 

distclean:: clean

clean	::
	@del *.obj 

distclean:: clean 
	@del $(SCIDIR1)\bin\prog.*
	@del libodeex.* loader.sce Makelib.mak

RESOURCES= $(SCIDIR)/routines/wsci/Rscilab.res 

$(SCIDIR)/bin/prog.exe : $(OBJSC)
	@echo "Linking" 
	$(LINKER) $(LINKER_FLAGS) -OUT:"$*.exe"  $(RESOURCES) \
	$(SCIDIR)/routines/f2c/libf2c/main.obj \
		$(OBJSC) $(SCIDIR)/bin/LibScilab.lib $(XLIBS) 
	@echo "done " $(SCIDIR)/bin/prog.exe 
