# vdr
DIR_vdr := ../apps/vdr

$(DEPDIR)/vdr.do_prepare: bootstrap freetype libxml2 jpeg libz libpng fontconfig libpcre bzip2 libcap expat imagemagick driver-ptinp

$(DEPDIR)/vdr.do_compile: 

	cd $(DIR_vdr)/vdr && \
		$(BUILDENV) $(MAKE) all plugins install-bin install-conf install-plugins install-i18n \
		DESTDIR=$(targetprefix) \
		VIDEODIR=/hdd/movie \
		CONFDIR=/usr/local/share/vdr \
		PLUGINLIBDIR=/usr/lib/vdr
	touch $@
$(DEPDIR)/vdr: vdr.do_prepare vdr.do_compile
	$(start_build)
	cd $(DIR_vdr)/vdr && \
		$(BUILDENV) $(MAKE) all plugins install-bin install-conf install-plugins install-i18n \
		DESTDIR=$(targetprefix) \
		VIDEODIR=/hdd/movie \
		CONFDIR=/usr/local/share/vdr \
		PLUGINLIBDIR=/usr/lib/vdr
	if [ -e $(targetprefix)/usr/local/bin/vdr ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/vdr; \
	fi
	$(tocdk_build)
	$(toflash_build)
	touch $@
vdr-clean:
	-rm .deps/vdr
	-rm .deps/vdr.do_compile

vdr-distclean:
	$(MAKE) -C $(DIR_vdr)/vdr clean clean-plugins
	-rm .deps/vdr
	-rm .deps/vdr.do_compile
	-rm .deps/vdr.do_prepare