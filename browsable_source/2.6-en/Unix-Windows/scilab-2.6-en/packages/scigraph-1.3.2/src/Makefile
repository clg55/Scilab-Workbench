
include ../Path.incl 

include $(SCIDIR)/Makefile.incl

all	:: Makelib job 
	make -f Makelib

Makelib : builder.sce
	@echo running builder 
	@echo "exec builder.sce;"|$(SCIDIR)/bin/scilab -nw > /dev/null

job	: 
	make -f Makelib

tests	: all
	make -f Makelib tests 

clean	::
	@echo Cleaning 
	@$(RM) -f -r *.o *.lo *.la *.so *.sl *.a *.dia .job.sce so_locations
	@$(RM) -f -r .libs

distclean:: clean 
	@$(RM) -f *.dia  *_gateway.c 
	@$(RM) -f Makelib 

message:
	@echo "------------------------------------------";
	@echo "At Scilab prompt, enter:";
	@echo "-->exec loader.sce";
	@echo "------------------------------------------";

