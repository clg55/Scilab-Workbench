SCIDIR = ../..

include $(SCIDIR)/Makefile.incl

all	:: builder.sce 
	@echo "running builder (be patient)"
	@echo "exec builder.sce;"|$(SCIDIR)/bin/scilab -nw > /dev/null
	@echo "At Scilab prompt, enter:";
	@echo "-->exec loader.sce";
	@echo "----------------------------------------------------";

clean	::
	cd src; make clean 
	cd macros ; make clean 
	cd man ; make clean 

distclean::
	cd src; make distclean 
	cd macros ; make distclean 
	cd man ; make distclean 

whatis:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	(cd man ; echo "making whatis in man..."; \
	$(MAKE) $(MFLAGS) whatis);

html:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	(cd man ; echo "making html in man..."; \
	$(MAKE) $(MFLAGS) html);

manclean:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	(cd man ; echo "making manclean in man..."; \
	$(MAKE) $(MFLAGS) manclean);
