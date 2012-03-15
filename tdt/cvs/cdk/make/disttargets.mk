EXTRA_DIST = \
	rules.pl rules-archive.pl rules-downcheck.pl.in \
	rules-archive \
	rules-install rules-install-flash \
	smart-rules.pl smart-rules \
	rules-make$(if $(STABLE),,.latest)
