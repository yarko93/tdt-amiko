# tuxbox/enigma2

DIR_enigma2_pli := $(appsdir)/enigma2-pli-nightly

$(DEPDIR)/enigma2-pli-nightly.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://gitorious.org/open-duckbox-project-sh4/guigit.git"; \
	rm -rf $(DIR_enigma2_pli).org; \
	rm -rf $(DIR_enigma2_pli).newest; \
	rm -rf $(DIR_enigma2_pli).patched; \
	clear; \
	echo "Media Framwork: $(MEDIAFW)"; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 17 Mar 2012 19:51 - E2 OpenPli 945aeb939308b3652b56bc6c577853369d54a537"; \
	echo "2) Sat, 18 May 2012 15:26  - E2 OpenPli 839e96b79600aba73f743fd39628f32bc1628f4c"; \
	echo "3) Sat, 18 May 2012 15:26  - E2 OpenPli current Amiko"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="experimental"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="945aeb939308b3652b56bc6c577853369d54a537" && REPO="git://openpli.git.sourceforge.net/gitroot/openpli/enigma2"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="839e96b79600aba73f743fd39628f32bc1628f4c" && REPO="git://openpli.git.sourceforge.net/gitroot/openpli/enigma2"; \
	[ "$$REPLY" == "3" ] && DIFF="3" && REPO="git://github.com/technic/amiko-e2-pli.git"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(DIR_enigma2_pli)" ] && \
	git pull $(DIR_enigma2_pli) $$HEAD;\
	[ -d "$(DIR_enigma2_pli)" ] || \
	git clone -b $$HEAD $$REPO $(DIR_enigma2_pli); \
	cp -ra $(DIR_enigma2_pli) $(DIR_enigma2_pli).newest; \
	[ "$$REVISION" == "" ] || (cd $(DIR_enigma2_pli); git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(DIR_enigma2_pli) $(DIR_enigma2_pli).org; \
	cd $(DIR_enigma2_pli) && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.diff"; \
	cd $(DIR_enigma2_pli) && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.$(MEDIAFW).diff"; \
	[ "$(EXTERNALLCD_DEP)" == "" ] || (cd $(DIR_enigma2_pli) && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.graphlcd.diff" ); \
	cp -ra $(DIR_enigma2_pli) $(DIR_enigma2_pli).patched
	touch $@

$(DIR_enigma2_pli)/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline font-valis-enigma \
		enigma2-pli-nightly.do_prepare \
		libdvbsipp python libxml2 libxslt elementtree zope_interface twisted pyopenssl pythonwifi lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(DIR_enigma2_pli) && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)


$(DEPDIR)/enigma2-pli-nightly.do_compile: $(DIR_enigma2_pli)/config.status
	cd $(DIR_enigma2_pli) && \
		$(MAKE) all
	touch $@

# Select enigma2 keymap.xml
enigma2_keymap_file = keymap$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2)$(VIP2_V1),_vip2)$(if $(UFS912),_$(UFS912))$(if $(SPARK)$(SPARK7162),_spark)$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD),_cuberevo)$(if $(HOMECAST5101),_ufs910)$(if $(IPBOX9900)$(IPBOX99)$(IPBOX55),_ipbox)$(if $(ADB_BOX),_$(ADB_BOX)).xml

DESCRIPTION_enigma2_pli := a framebuffer-based zapping application (GUI) for linux
PKGR_enigma2_pli = r2
SRC_URI_enigma2_pli := git://openpli.git.sourceforge.net/gitroot/openpli/enigma2
FILES_enigma2_pli := /usr/lib/ /etc/enigma2 /usr/share /usr/bin

$(DEPDIR)/enigma2-pli-nightly: enigma2-pli-nightly.do_compile
	$(call parent_pk,enigma2_pli)
	$(start_build)
	$(get_git_version)
	cd $(DIR_enigma2_pli) && \
		$(MAKE) install DESTDIR=$(PKDIR)
	$(target)-strip $(PKDIR)/usr/bin/enigma2
	cp -f $(buildprefix)/root/usr/local/share/enigma2/$(enigma2_keymap_file) $(PKDIR)/usr/share/enigma2/keymap.xml
	$(tocdk_build)
	$(toflash_build)
	touch $@

enigma2-pli-nightly-clean:
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile

enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(DIR_enigma2_pli)
	rm -rf $(DIR_enigma2_pli).newest
	rm -rf $(DIR_enigma2_pli).org
	rm -rf $(DIR_enigma2_pli).patched

