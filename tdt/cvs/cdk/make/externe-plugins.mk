#
# Make Extern-Plugins
#
#
DESCRIPTION_e2plugin := Additional plugins for Enigma2

PKGR_e2plugin = r2

NAME_e2plugin_meta := enigma2-plugins-meta
FILES_e2plugin_meta := /usr/share/meta
DESCRIPTION_e2plugin_meta := Enigma2 plugins metadata
PACKAGES_e2plugin = e2plugin_meta
DIST_e2plugin = enigma2_plugin_systemplugins_networkbrowser

$(DEPDIR)/enigma2-plugins-sh4.do_prepare: @DEPENDS_e2plugin@
	@PREPARE_e2plugin@
	touch $@

$(DIR_e2plugin)/config.status: enigma2-plugins-sh4.do_prepare
	cd $(DIR_e2plugin) && \
		autoreconf -i -I$(hostprefix)/share/aclocal && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i xml2po.py && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--datadir=/usr/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)

enigma2_plugindir = /usr/lib/enigma2/python/Plugins

$(DEPDIR)/enigma2-plugins-sh4-networkbrowser \
$(DEPDIR)/enigma2-plugins-sh4: \
$(DEPDIR)/enigma2-plugins-sh4%: $(DIR_e2plugin)/config.status
	$(call parent_pk,e2plugin)
#	Don't build meta
	$(if $*,$(eval PACKAGES_e2plugin = ))
	$(start_build)
	cd $(DIR_e2plugin)/`echo $* |sed s/^-//` && \
		$(MAKE) install DESTDIR=$(PKDIR)
	rm -rf $(ipkgbuilddir)/*
	$(flash_prebuild)

	echo -e "\
	from split_packages import * \n\
	#print bb_data \n\
	do_split_packages(bb_data, '$(enigma2_plugindir)', '(.*?/.*?)/.*', 'enigma2-plugin-%s', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True) \n\
	for package in bb_get('PACKAGES').split(): \n\
		pk = bb_get('NAME_' + package).split('-')[-1] \n\
		try: \n\
			read_control_file('$(DIR_e2plugin)/' + pk + '/CONTROL/control') \n\
		except IOError: \n\
			print 'skipping', pk \n\
		for s in ['preinst', 'postinst', 'prerm', 'postrm']: \n\
			try: \n\
				bb_set(s + '_' + package, open('$(DIR_e2plugin)/' + pk + '/CONTROL/' + s).read()) \n\
			except IOError: \n\
				pass \n\
	do_finish() \n\
	" | $(crossprefix)/bin/python

	$(call do_build_pkg,none,extra)
	touch $@

enigma2-plugins-sh4-clean:
	rm -f $(DEPDIR)/enigma2-plugins-sh4
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_compile

enigma2-plugins-sh4-distclean: enigma2-plugins-sh4-clean
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_prepare
	rm -rf $(DIR_e2plugin)
