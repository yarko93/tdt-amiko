#
# Make Extern-Skins
#
#

DESCRIPTION_e2skin := Skins for Enigma2

PKGR_e2skin = r2

NAME_e2skin_meta := enigma2-skins-meta
FILES_e2skin_meta := /usr/share/meta
DESCRIPTION_e2skin_meta := Enigma2 skins metadata
PACKAGES_e2skin = e2skin_meta

$(DEPDIR)/enigma2-skins-sh4.do_prepare: @DEPENDS_e2skin@
	@PREPARE_e2skin@

$(DIR_e2skin)/config.status: enigma2-skins-sh4.do_prepare
	cd $(DIR_e2skin) && \
		autoreconf --force --install -I$(hostprefix)/share/aclocal && \
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

$(DEPDIR)/enigma2-skins-sh4.do_compile: $(DIR_e2skin)/config.status
	cd $(DIR_e2skin) && \
		$(MAKE) all
	touch $@

enigma2_skindir = '/usr/share/enigma2'

$(DEPDIR)/enigma2-skins-sh4: enigma2-skins-sh4.do_compile
	$(call parent_pk,e2skin)
	$(start_build)
	rm -rf $(ipkgbuilddir)/*
	$(flash_prebuild)
	cd $(DIR_e2skin) && \
		$(MAKE) install DESTDIR=$(PKDIR)
	$(crossprefix)/bin/python -c "from split_packages import *; \
	do_split_packages(bb_data, $(enigma2_skindir), '(.*?)/.*', 'enigma2-plugin-skin-%s', 'Enigma2 Skin: %s', recursive=True, match_path=True, prepend=True); \
	do_finish()"
	$(call do_build_pkg,none,extra)
	touch $@

enigma2-skins-sh4-clean:
	rm -f $(DEPDIR)/enigma2-skins-sh4

enigma2-skins-sh4-distclean: enigma2-skins-sh4-clean
	rm -f $(DEPDIR)/enigma2-skins-sh4.do_compile
	rm -f $(DEPDIR)/enigma2-skins-sh4.do_prepare
