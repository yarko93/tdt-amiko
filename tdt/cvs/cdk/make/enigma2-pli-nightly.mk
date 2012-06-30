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

$(DIR_enigma2_pli)/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsipp python libxml2 libxslt elementtree zope_interface twisted pyopenssl pythonwifi lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(DIR_enigma2_pli) && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)


$(DEPDIR)/enigma2-pli-nightly.do_compile: $(DIR_enigma2_pli)/config.status
	cd $(DIR_enigma2_pli) && \
		$(MAKE) all
	touch $@

DESCRIPTION_enigma2_pli := a framebuffer-based zapping application (GUI) for linux
SRC_URI_enigma2_pli := git://openpli.git.sourceforge.net/gitroot/openpli/enigma2
FILES_enigma2_pli := /usr/lib/ /etc/enigma2 /usr/local/share /usr/local/bin

$(DEPDIR)/enigma2-pli-nightly: enigma2-pli-nightly.do_prepare enigma2-pli-nightly.do_compile
	$(call parent_pk,enigma2_pli)
	$(start_build)
	$(get_git_version)
	$(MAKE) -C $(DIR_enigma2_pli) install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/bin/enigma2 ]; then \
		$(target)-strip $(PKDIR)/usr/bin/enigma2; \
	fi
	if [ -e $(PKDIR)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(PKDIR)/usr/local/bin/enigma2; \
	fi
	mkdir -p $(PKDIR)/usr/local/bin
	$(tocdk_build)
	cp $(PKDIR)/usr/bin/enigma2 $(PKDIR)/usr/local/bin/
	$(toflash_build)
	touch $@
enigma2-pli-nightly-clean:
	cd $(DIR_enigma2_pli) && \
		$(MAKE) clean
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile

enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(DIR_enigma2_pli)
	rm -rf $(DIR_enigma2_pli).newest
	rm -rf $(DIR_enigma2_pli).org
	rm -rf $(DIR_enigma2_pli).patched

