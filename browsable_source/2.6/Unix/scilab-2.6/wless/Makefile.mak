SHELL = /bin/sh

SCIDIR=..
include ../Makefile.incl.mak

CFLAGS = $(CC_OPTIONS) $(XFLAGS)

OBJS =  poppad.obj popfile.obj popfind.obj popfont.obj popprnt.obj 

all:: $(SCIDIR)/bin/xless.exe

RESOURCES= rpoppad.res 

$(SCIDIR)/bin/xless.exe: $(OBJS) $(RESOURCES)
	@echo Linking ../bin/xless.exe
	@$(LINKER) $(LINKER_FLAGS) -SUBSYSTEM:windows -OUT:"../bin/xless.exe" \
	$(OBJS) $(RESOURCES)  $(GUILIBS)
	@echo Linking done

clean::
	del *.obj

distclean::
	del *.obj
	del $(SCIDIR)/bin/xless 
	del $(RESOURCES)

rpoppad.res : rpoppad.rc poppad.h poppad.ico
	$(RC) $(RCVARS) /forpoppad.res rpoppad.rc
