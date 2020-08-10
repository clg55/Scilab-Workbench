# Generated automatically from Makefile.in by configure.
SHELL = /bin/sh

binary:
	@if test -f .binary; then \
		echo "Humm... this is a binary version"; \
		config/findpath; \
		(cd scripts; make); \
                (cd maple; make); \
		echo "Installation done"; \
	else \
		echo "**********************************"; \
		echo "Humm... this is a source version."; \
		echo "Please read the README file first."; \
		echo "**********************************"; \
	fi

#SCIDIR=.
include Path.incl
include Makefile.incl

all:: bin/scilex  

# Add the object files that are used to compile Scilex
include Makefile.OBJ

include config/Makefile.linux

distclean::
	$(RM) bin/scilex

SUBDIRS = scripts maple macros imp intersci xless \
	tests demos examples packages

scilex-lib::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	cd routines; echo "making all in routines..."; \
		$(MAKE) $(MFLAGS) all;

scilex-lib::
	@cd pvm3; echo "making all in pvm3..."; $(MAKE) $(MFLAGS) "CC=$(CC)";

all::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in $(SUBDIRS) ;\
	do \
		(cd $$i ; echo "making all in $$i..."; \
			$(MAKE) $(MFLAGS) all); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in routines $(SUBDIRS) man;\
	do \
		(cd $$i ; echo "making distclean in $$i..."; \
			$(MAKE) $(MFLAGS)  distclean); \
	done

distclean::
	@cd pvm3; echo "making distclean in pvm3..."; \
	$(MAKE) $(MFLAGS) distclean;

clean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in routines $(SUBDIRS) man;\
	do \
		(cd $$i ; echo "making clean in $$i..."; \
			$(MAKE) $(MFLAGS)  clean); \
	done

# making the man
# whatis must be done first

man: whatis html index

whatis:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in man packages;\
	do \
		(cd $$i ; echo "making whatis in $$i..."; \
			$(MAKE) $(MFLAGS) whatis); \
	done

html:	
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in man packages;\
	do \
		(cd $$i ; echo "making html in $$i..."; \
			$(MAKE) $(MFLAGS) html); \
	done

index:
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	(cd man ; echo "making index in man..."; \
	$(MAKE) $(MFLAGS) index);

manclean:	
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in man packages;\
	do \
		(cd $$i ; echo "making manclean in $$i..."; \
			$(MAKE) $(MFLAGS) manclean); \
	done

#clean::
#	@cd pvm3; echo "making clean in pvm3..."; \
#	$(MAKE) $(MFLAGS)  clean;

tests:
	@echo "Type \"make tests\" in $(SCIDIR)/tests directory "
	@echo "  to test the  distribution"

distclean::
	$(RM) config.cache config.log config.status .binary foo.f foo.o \
	conftest conftest.c so_locations

SCIBASE = scilab-2.6-en

BINDISTFILES = \
	$(SCIBASE)/.binary \
	$(SCIBASE)/.pvmd.conf \
	$(SCIBASE)/ACKNOWLEDGEMENTS \
	$(SCIBASE)/CHANGES \
	$(SCIBASE)/Makefile \
        $(SCIBASE)/Makefile.OBJ \
	$(SCIBASE)/Makefile.incl \
	$(SCIBASE)/Makemex \
        $(SCIBASE)/Path.incl \
	$(SCIBASE)/README \
	$(SCIBASE)/Version.incl \
	$(SCIBASE)/configure \
	$(SCIBASE)/libtool \
	$(SCIBASE)/license.txt \
	$(SCIBASE)/licence.txt \
	$(SCIBASE)/scilab.quit \
	$(SCIBASE)/scilab.star \
	$(SCIBASE)/X11_defaults \
	$(SCIBASE)/bin \
	$(SCIBASE)/config \
	$(SCIBASE)/demos \
	$(SCIBASE)/examples \
	$(SCIBASE)/imp/NperiPos.ps \
	$(SCIBASE)/imp/giffonts \
	$(SCIBASE)/macros \
	$(SCIBASE)/man/eng/index.html \
	$(SCIBASE)/man/eng/*/*.html \
	$(SCIBASE)/man/fr/index.html \
	$(SCIBASE)/man/fr/*/*.html \
	$(SCIBASE)/maple \
	$(SCIBASE)/packages/scigraph-1.3.2/README \
	$(SCIBASE)/packages/scigraph-1.3.2/demos \
	$(SCIBASE)/packages/scigraph-1.3.2/help \
	$(SCIBASE)/packages/scigraph-1.3.2/loader.sce \
	$(SCIBASE)/packages/scigraph-1.3.2/macros \
	$(SCIBASE)/packages/scigraph-1.3.2/man/eng/*/*.html \
	$(SCIBASE)/packages/scigraph-1.3.2/man/fr/*/*.html \
	$(SCIBASE)/packages/scigraph-1.3.2/src/libscigraph.so \
	$(SCIBASE)/packages/scigraph-1.3.2/src/loader.sce \
	$(SCIBASE)/packages/stixbox-1.2.3/README \
	$(SCIBASE)/packages/stixbox-1.2.3/data \
	$(SCIBASE)/packages/stixbox-1.2.3/loader.sce \
	$(SCIBASE)/packages/stixbox-1.2.3/macros \
	$(SCIBASE)/packages/stixbox-1.2.3/man/eng/*/*.html \
	$(SCIBASE)/packages/stixbox-1.2.3/man/fr/*/*.html \
	$(SCIBASE)/pvm3/lib/pvm \
	$(SCIBASE)/pvm3/lib/pvmd \
	$(SCIBASE)/pvm3/lib/pvmtmparch \
	$(SCIBASE)/pvm3/lib/pvmgetarch \
	$(SCIBASE)/pvm3/lib/LINUX/pvmd3 \
	$(SCIBASE)/pvm3/lib/LINUX/pvmgs \
	$(SCIBASE)/routines/*.h \
	$(SCIBASE)/routines/Make.lib \
	$(SCIBASE)/routines/default/FCreate \
	$(SCIBASE)/routines/default/Flist \
	$(SCIBASE)/routines/default/README \
	$(SCIBASE)/routines/default/fundef \
	$(SCIBASE)/routines/default/*.c \
	$(SCIBASE)/routines/default/*.f \
	$(SCIBASE)/routines/default/*.h \
	$(SCIBASE)/routines/graphics/Math.h \
	$(SCIBASE)/routines/graphics/Graphics.h \
	$(SCIBASE)/routines/interf/*.h \
	$(SCIBASE)/routines/intersci/sparse.h \
	$(SCIBASE)/routines/menusX/*.h \
	$(SCIBASE)/routines/scicos/scicos.h \
	$(SCIBASE)/routines/sun/*.h \
	$(SCIBASE)/routines/xsci/*.h \
	$(SCIBASE)/scripts \
	$(SCIBASE)/tcl \
	$(SCIBASE)/tests \
	$(SCIBASE)/util

tarbindist:
	touch .binary
	strip $(SCIDIR)/bin/scilex
	cd tests; make distclean
	cd examples; make distclean
	cd .. ; tar cvf $(SCIDIR)/$(SCIBASE)-bin.tar $(BINDISTFILES)
	$(RM) .binary

LIBPREFIX = /usr/lib

install:
	@if test `pwd` != ${LIBPREFIX}/$(SCIBASE); then \
		touch .binary; \
		strip $(SCIDIR)/bin/scilex; \
		(cd tests; make distclean); \
		(cd examples; make distclean); \
		(cd .. ; tar cf - $(BINDISTFILES) | (cd ${LIBPREFIX}; tar xf -)); \
		(cd ${LIBPREFIX}/$(SCIBASE); make); \
		$(RM) .binary; \
	fi
	$(RM) /usr/bin/scilab
	ln -fs ${LIBPREFIX}/$(SCIBASE)/bin/scilab /usr/bin/scilab
	$(RM) /usr/bin/intersci
	ln -fs ${LIBPREFIX}/$(SCIBASE)/bin/intersci /usr/bin/intersci
	$(RM) /usr/bin/intersci-n
	ln -fs ${LIBPREFIX}/$(SCIBASE)/bin/intersci-n /usr/bin/intersci-n

uninstall:
	$(RM) -r ${LIBPREFIX}/$(SCIBASE)
	$(RM) /usr/bin/scilab
	$(RM) /usr/bin/intersci
	$(RM) /usr/bin/intersci-n

