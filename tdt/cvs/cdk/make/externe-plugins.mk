#
# Make Extern-Plugins
#
#
DESCRIPTION_e2plugin := Additional plugins for Enigma2
MAINTAINER_e2plugin := Ar-P team
REPO_e2plugin = git://github.com/schpuntik/enigma2-plugins-sh4.git
SRC_URI_e2plugin = $(REPO_e2plugin)
PACKAGE_ARCH_e2plugin := sh4
NAME_e2plugin_meta := enigma2-plugins-meta
FILES_e2plugin_meta := /usr/share/meta
DESCRIPTION_e2plugin_meta := Enigma2 plugins metadata
PACKAGES_e2plugin = e2plugin_meta

enigma2-plugins-sh4:
$(DEPDIR)/enigma2-plugins-sh4.do_prepare:
	rm -rf $(appsdir)/plugins; \
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		git clone git://github.com/schpuntik/enigma2-plugins-sh4.git $(appsdir)/plugins;\
	fi
	git clone git://github.com/schpuntik/enigma2-plugins-sh4.git $(appsdir)/plugins && \
	cd $(appsdir)/plugins && \
	git checkout master; cd "$(buildprefix)"; \
	touch $@

$(appsdir)/plugins/config.status:
	cd $(appsdir)/plugins && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i $(appsdir)/plugins/xml2po.py && \
		./configure \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/enigma2-plugins-sh4.do_compile: $(appsdir)/plugins/config.status
	cd $(appsdir)/plugins && \
		$(MAKE) all
	touch $@

enigma2-plugins-sh4-package: export PKGV_e2plugin = 3.2git$(shell cd $(appsdir)/plugins && git log -1 --format=%cd --date=short |sed s/-//g)
PKGR_e2plugin = r1
enigma2_plugindir = /usr/lib/enigma2/python/Plugins

enigma2-plugins-sh4-package: enigma2-plugins-sh4.do_compile
	$(call parent_pk,e2plugin)
	rm -rf $(packagingtmpdir)
	mkdir -p $(packagingtmpdir)
	$(MAKE) -C $(appsdir)/plugins install DESTDIR=$(packagingtmpdir)
	rm -rf $(ipkgbuilddir)
	@echo 'next variables are exported to enviroment:'
	@echo $(EXPORT_ENV) | tr ' ' '\n'
	@echo $(enigma2_plugindir)
	echo -e "\
	from split_packages import * \n\
	print bb_data \n\
	do_split_packages(bb_data, '$(enigma2_plugindir)', '(.*?/.*?)/.*', 'enigma2-plugin-%s', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True) \n\
	for package in bb_get('PACKAGES').split(): \n\
		pk = bb_get('NAME_' + package).split('-')[-1] \n\
		try: \n\
			read_control_file('$(appsdir)/plugins/' + pk + '/CONTROL/control') \n\
		except IOError: \n\
			print 'skipping', pk \n\
	do_finish() \n\
	" | $(crossprefix)/bin/python
	for p in `ls $(ipkgbuilddir)`; do \
		ipkg-build -o root -g root $(ipkgbuilddir)/$$p $(ipkprefix); \
	done

$(DEPDIR)/enigma2-plugins-sh4: enigma2-plugins-sh4.do_prepare enigma2-plugins-sh4.do_compile enigma2-plugins-sh4-package
	touch $@

enigma2-plugins-sh4-clean:
	rm -f $(DEPDIR)/enigma2-plugins-sh4
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_compile

enigma2-plugins-sh4-distclean:
	rm -f $(DEPDIR)/enigma2-plugins-sh4
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_compile
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_prepare
	rm -rf $(appsdir)/plugins

enigma2-sh4-package-distclean:
	rm -rf $(ipkgbuilddir)
	rm -rf $(ipkprefix)
