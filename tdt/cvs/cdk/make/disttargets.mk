if MAINTAINER_MODE
Makefile-archive: $(top_srcdir)/rules-archive $(top_srcdir)/rules-archive.pl
	$(top_srcdir)/rules-archive.pl $(top_srcdir)/rules-archive > Makefile-archive
endif

EXTRA_DIST = \
	rules.pl rules-archive.pl rules-downcheck.pl.in \
	rules-archive \
	smart-rules.pl smart-rules \
	rules-install \
	rules-make

@ARCHIVE@
