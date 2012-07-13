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
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			--datadir=/usr/share \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)
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
	$(crossprefix)/bin/python -c "from split_packages import *; \
	do_split_packages(bb_data, $(enigma2_skindir), '(.*?)/.*', 'enigma2-skin-%s', 'Enigma2 Skin: %s', recursive=True, match_path=True, prepend=True); \
	do_finish()"
	$(call do_build_pkg,none,extra)

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
