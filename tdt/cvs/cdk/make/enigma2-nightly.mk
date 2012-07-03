# tuxbox/enigma2

#if ENABLE_MEDIAFWGSTREAMER
#MEDIAFW = gstreamer
#else
#MEDIAFW = eplayer4
#endif

$(DEPDIR)/enigma2-nightly.do_prepare:
	REVISION=""; \
	DIFF="0"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo "Media Framwork: $(MEDIAFW)"; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 29 Mar 2011 13:49 - E2 V3.0 e013d09af0e010f15e225a12dcc217abc052ee19"; \
	echo "2) Current E2 gitgui arp-team no gstreamer"; \
	echo "3) Current E2 gitgui arp-team"; \
	echo "4) inactive"; \
	echo "5) Fri,  5 Nov 2010 00:16 - E2 V2.4 libplayer3 7fd4241a1d7b8d7c36385860b24882636517473b"; \
	echo "6) Wed,  6 Jul 2011 11:17 - E2 V3.1 gstreamer  388dcd814d4e99720cb9a6c769611be4951e4ad4"; \
	echo "7) current inactive... comming soon, here is the next stable (case 7 == DIFF=7)"; \
	REPLY=0; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="experimental"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && HEAD="experimental" && REVISION="e013d09af0e010f15e225a12dcc217abc052ee19"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && HEAD="arp-no_gst"; \
	[ "$$REPLY" == "3" ] && DIFF="3" && HEAD="arp-team"; \
	[ "$$REPLY" == "4" ] && DIFF="4" && HEAD="master" && REVISION="be8ccc9f63c4cd79f8dba84087c7348c23657865"; \
	[ "$$REPLY" == "5" ] && DIFF="5" && HEAD="master" && REVISION="7fd4241a1d7b8d7c36385860b24882636517473b"; \
	[ "$$REPLY" == "6" ] && DIFF="6" && HEAD="experimental" && REVISION="388dcd814d4e99720cb9a6c769611be4951e4ad4"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(appsdir)/enigma2-nightly" ] && \
	git pull $(appsdir)/enigma2-nightly $$HEAD;\
	[ -d "$(appsdir)/enigma2-nightly" ] || \
	git clone -b $$HEAD git://gitorious.org/~schpuntik/open-duckbox-project-sh4/amiko-guigit.git $(appsdir)/enigma2-nightly; \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.newest; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.diff"; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.$(MEDIAFW).diff"; \
	[ "$(EXTERNALLCD_DEP)" == "" ] || (cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.graphlcd.diff" ); \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.tuxtxt.diff"
	$(if $(IPBOX9900),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	$(if $(IPBOX99),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	$(if $(IPBOX55),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-nightly/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsi++ python libxml2 libxslt elementtree zope_interface twisted pyopenssl lxml libxmlccwrap ncurses-dev libdreamdvd sdparm opkg-host ipkg-utils $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(appsdir)/enigma2-nightly && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--prefix=/usr \
			--datadir=/usr/local/share \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)


$(DEPDIR)/enigma2-nightly.do_compile: $(appsdir)/enigma2-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

DESCRIPTION_enigma2 := a framebuffer-based zapping application (GUI) for linux
SRC_URI_enigma2 := git://gitorious.org/open-duckbox-project-sh4/guigit.git
# neccecary for get_git_version:
DIR_enigma2 := $(appsdir)/enigma2-nightly
FILES_enigma2 := /usr/bin /usr/lib/ /etc/enigma2 /usr/local/share

#by default PARENT_PK equals $@ How to ovveride see below
#****** word "private" here is critically important!!! Overvise other rules could be broken! only make 3.82
#$(DEPDIR)/enigma2-nightly: private PARENT_PK = enigma2
$(DEPDIR)/enigma2-nightly: enigma2-nightly.do_prepare enigma2-nightly.do_compile
#alternate you can do the following: (see packaging.mk)
	$(call parent_pk,enigma2)
	$(get_git_version)
	@echo $$PKGV_$(PARENT_PK)
	$(start_build)
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/bin/enigma2 ]; then \
		$(target)-strip $(PKDIR)/usr/bin/enigma2; \
	fi
	if [ -e $(PKDIR)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(PKDIR)/usr/local/bin/enigma2; \
	fi
	mkdir -p $(PKDIR)/usr/local/bin
	$(tocdk_build)
	cp $(PKDIR)/usr/bin/enigma2 $(PKDIR)/usr/local/bin/
	rm -rf $(PKDIR)/usr/local/share/meta
	$(toflash_build)
	touch $@
enigma2-nightly-clean:
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) clean
enigma2-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-nightly
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched

#
# dvb/libdvbsi++
#
$(appsdir)/dvb/libdvbsi++/config.status: bootstrap
	cd $(appsdir)/dvb/libdvbsi++ && $(CONFIGURE) CPPFLAGS="$(CPPFLAGS) -I$(driverdir)/dvb/include"

$(DEPDIR)/libdvbsi++: $(appsdir)/dvb/libdvbsi++/config.status
	$(MAKE) -C $(appsdir)/dvb/libdvbsi++ all install
	touch $@
