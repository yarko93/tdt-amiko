# tuxbox/enigma2
if ENABLE_MEDIAFWGSTREAMER
ENIGMA2_FLAGS =
else
ENIGMA2_FLAGS = --enable-libeplayer3
endif

if ENABLE_EXTERNALLCD
ENIGMA2_FLAGS_2 = --with-graphlcd
else
ENIGMA2_FLAGS_2 =
endif

$(DEPDIR)/enigma2-pli-nightly.do_prepare: @DEPENDS_enigma2_pli@
	@PREPARE_enigma2_pli@
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
			$(PLATFORM_CPPFLAGS) $(ENIGMA2_FLAGS) $(ENIGMA2_FLAGS_2)


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
	cd $(DIR_enigma2_pli) && $(MAKE) clean

enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(DIR_enigma2_pli)
	rm -rf $(DIR_enigma2_pli).newest
	rm -rf $(DIR_enigma2_pli).org
	rm -rf $(DIR_enigma2_pli).patched

