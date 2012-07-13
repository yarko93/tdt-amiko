#
# Make Extern-Skins
#
#

DESCRIPTION_e2skin := Skins for Enigma2
MAINTAINER_e2skin := Ar-P team
BRANCH_e2skin := bbhack-test
REPO_e2skin := git://github.com/schpuntik/enigma2-skins-sh4.git
SRC_URI_e2skin := $(REPO_e2skin);branch=$(BRANCH_e2skin)
PACKAGE_ARCH_e2skin := all
NAME_e2skin_meta := enigma2-skins-meta
FILES_e2skin_meta := /usr/share/meta
DESCRIPTION_e2skin_meta := Enigma2 skins metadata
PACKAGES_e2skin = e2skin_meta

enigma2-skins-sh4:
$(DEPDIR)/enigma2-skins-sh4.do_prepare:
	rm -rf $(appsdir)/skins;
	if [ ! -e $(targetprefix)/usr/bin/enigma2 ]; then \
		echo Enigma2 not builded; \
	fi
	git clone $(REPO_e2skin) $(appsdir)/skins
	cd $(appsdir)/skins && git checkout $(BRANCH_e2skin);
	touch $@

$(appsdir)/skins/config.status: 
	cd $(appsdir)/skins && \
		./autogen.sh && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--datadir=/usr/share \
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
	touch $@	    

$(DEPDIR)/enigma2-skins-sh4.do_compile: $(appsdir)/skins/config.status
	cd $(appsdir)/skins && \
		$(MAKE) all
	touch $@

PKGR_e2skin = r1
DIR_e2skin = $(appsdir)/skins
enigma2_skindir = '/usr/share/enigma2'

enigma2-skins-sh4-package: enigma2-skins-sh4.do_compile
	$(call parent_pk,e2skin)
	$(start_build)
	$(get_git_version)
	rm -rf $(ipkgbuilddir)/*
	$(flash_prebuild)
	$(MAKE) -C $(appsdir)/skins install DESTDIR=$(packagingtmpdir)
	@echo 'next variables are exported to enviroment:'
	@echo $(EXPORT_ENV) | tr ' ' '\n'
	$(crossprefix)/bin/python -c "from split_packages import *; \
	print bb_data; \
	do_split_packages(bb_data, $(enigma2_skindir), '(.*?)/.*', 'enigma2-skin-%s', 'Enigma2 Skin: %s', recursive=True, match_path=True, prepend=True); \
	do_finish()"
	$(call do_build_pkg,none,flash)

$(DEPDIR)/enigma2-skins-sh4: enigma2-skins-sh4.do_prepare enigma2-skins-sh4.do_compile enigma2-skins-sh4-package
	touch $@

enigma2-skins-sh4-clean:
	rm -f $(DEPDIR)/enigma2-skins-sh4
	rm -f $(DEPDIR)/enigma2-skins-sh4.do_compile
enigma2-skins-sh4-distclean:
	rm -f $(DEPDIR)/enigma2-skins-sh4
	rm -f $(DEPDIR)/enigma2-skins-sh4.do_compile
	rm -f $(DEPDIR)/enigma2-skins-sh4.do_prepare
	rm -rf $(appsdir)/skins
