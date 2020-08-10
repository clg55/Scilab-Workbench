SHELL = /bin/sh

include ../../../../Path.incl
include ../../../../Makefile.incl

DIRS = scigraph

# whatis must be done before html

whatis:
	@for i in $(DIRS) ;\
	do \
		(cd $$i ;\
		echo "Creating whatis.html in $$i"; \
		$(SCIDIR)/bin/scilab -nw -f "$(SCIDIR)/man/fr/make-whatis.sce" > /dev/null) \
	done

html:
	@for i in $(DIRS) ;\
	do \
		(cd $$i ;\
		echo "Processing chapter $$i"; \
		$(SCIDIR)/bin/scilab -nw -l fr -f "$(SCIDIR)/man/fr/make-links.sce" > /dev/null; \
		for j in *.xml2; \
		do if [ $$j != "*.xml2" ]; then \
			echo "   processing $${j%.*}.xml"; \
			sabcmd $(SCIDIR)/man/fr/html.xsl $$j $${j%.*}.html 2> sabcmd.tmp; \
			if (grep Error sabcmd.tmp > /dev/null) then \
				echo "   bad syntax in file: $$j"; \
			fi; \
			rm -f sabcmd.tmp; \
		fi; done; \
		rm -f *.xml2); \
	done

check:
	@for i in $(DIRS) ;\
	do \
		(cd $$i ; echo "Checking xlm in $$i"; \
		for j in *.xml; \
		do xmllint --noout --valid $$j 2> xmllint.tmp; \
			if (grep error xmllint.tmp > /dev/null) then \
				echo "   bad syntax in file: $$j"; \
			fi; \
			rm -f xmllint.tmp; \
		done); \
	done

distclean::
	$(RM)  $(FILES_TO_CLEAN)

manclean:
	$(RM)  $(FILES_TO_CLEAN) */whatis */*.html
