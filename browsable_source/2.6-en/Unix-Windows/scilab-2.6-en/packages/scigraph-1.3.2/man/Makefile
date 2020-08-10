SHELL = /bin/sh

include ../Path.incl
include $(SCIDIR)/Makefile.incl

whatis:: 
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in eng fr;\
	do \
		(cd $$i ; $(MAKE) $(MFLAGS) whatis); \
	done

html:: 
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in eng fr;\
	do \
		(cd $$i ; $(MAKE) $(MFLAGS) html); \
	done

manclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in eng fr;\
	do \
		(cd $$i ; $(MAKE) $(MFLAGS) manclean); \
	done

distclean::
	@case '${MFLAGS}' in *[ik]*) set +e;; esac; \
	for i in eng fr;\
	do \
		(cd $$i ; $(MAKE) $(MFLAGS) distclean); \
	done
