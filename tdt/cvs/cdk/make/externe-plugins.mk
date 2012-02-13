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
FILES_e2plugin_meta := /usr/local/share/meta
DESCRIPTION_e2plugin_meta := Enigma2 plugins metadata
PACKAGES_e2plugin = e2plugin_meta
RDEPENDS_e2plugin := enigma2

enigma2-plugins-sh4:
$(DEPDIR)/enigma2-plugins-sh4.do_prepare:

	rm -rf $(appsdir)/plugins; \
	clear; \
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		git clone git://github.com/schpuntik/enigma2-plugins-sh4.git $(appsdir)/plugins;\
	fi
	git clone git://github.com/schpuntik/enigma2-plugins-sh4.git $(appsdir)/plugins
	cd $(appsdir)/plugins ; ln -s ../../../tufsbox/cdkroot/usr/include/enigma2/lib lib ; \
	ln -s ../../../tufsbox/cdkroot/usr/include/enigma2/connection.h connection.h ; \
	ln -s ../../../tufsbox/cdkroot/usr/include/enigma2/libsig_comp.h libsig_comp.h ; \
	git checkout master; cd "$(buildprefix)"; \
	touch $@

$(appsdir)/plugins/config.status:
	cd $(appsdir)/plugins && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i $(appsdir)/plugins/xml2po.py && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--datadir=/usr/local/share \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI_FTA -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_250HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_2000HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_9500HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS922),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS922 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(TF7700),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_TF7700 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-tf7700) \
			$(if $(FLASH_UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FLASH_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FORTIS_HDBOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(ATEVIO7500),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEVIO7500 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HS7810A),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS7810A -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HS7110),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS7110 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-hl101) \
			$(if $(VIP1_V2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP1_V2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip1_v2) \
			$(if $(VIP2_V1),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP2_V1 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip2_v1) \
			$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS912),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS912 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(SPARK),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")  \
			$(if $(SPARK7162),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK7162 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(ADB_BOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ADB_BOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-adb_box) \
			$(if $(IPBOX9900),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX9900 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(IPBOX99),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX99 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(IPBOX55),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX55 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

$(DEPDIR)/enigma2-plugins-sh4.do_compile: $(appsdir)/plugins/config.status
	cd $(appsdir)/plugins && \
		$(MAKE) all
	touch $@

PKGV_e2plugin = 3.2git$(shell cd $(appsdir)/plugins && git log -1 --format=%cd --date=short |sed s/-//g)
PKGR_e2plugin = r0
enigma2_plugindir = /usr/lib/enigma2/python/Plugins

enigma2-plugins-sh4-package: export PARENT_PK = e2plugin
enigma2-plugins-sh4-package: enigma2-plugins-sh4.do_compile
	$(MAKE) -C $(appsdir)/plugins install DESTDIR=$(ipkprefix)
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

enigma2-plugins-sh4-clean enigma2-plugins-sh4-distclean:
	rm -f $(DEPDIR)/enigma2-plugins-sh4
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_compile
	rm -f $(DEPDIR)/enigma2-plugins-sh4.do_prepare
	rm -rf $(appsdir)/plugins
enigma2-sh4-package-distclean:
	rm -rf $(ipkgbuilddir)
	rm -rf $(ipkprefix)
