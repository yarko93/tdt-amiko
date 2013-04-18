$(DEPDIR)/misc-cp:
	cp $(buildprefix)/root/sbin/hotplug $(targetprefix)/sbin
	cp $(buildprefix)/root/etc/$(LIRCD_CONF) $(targetprefix)/etc/lircd.conf
	cp -rd $(buildprefix)/root/etc/hotplug $(targetprefix)/etc
	cp -rd $(buildprefix)/root/etc/hotplug.d $(targetprefix)/etc
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/misc-e2:
	$(INSTALL_DIR) $(targetprefix)/media/hdd
	$(INSTALL_DIR) $(targetprefix)/media/dvd
	$(INSTALL_DIR) $(targetprefix)/hdd
	$(INSTALL_DIR) $(targetprefix)/hdd/music
	$(INSTALL_DIR) $(targetprefix)/hdd/picture
	$(INSTALL_DIR) $(targetprefix)/hdd/movie
	@[ "x$*" = "x" ] && touch $@ || true

#
# SPLASHUTILS
#
SPLASHUTILS := splashutils
# if STM24
SPLASHUTILS_VERSION := 1.5.4.3-7
SPLASHUTILS_SPEC := stm-target-$(SPLASHUTILS).spec
SPLASHUTILS_SPEC_PATCH :=
SPLASHUTILS_PATCHES :=
# endif STM24

SPLASHUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm

$(SPLASHUTILS_RPM): \
		$(if $(SPLASHUTILS_SPEC_PATCH),Patches/$(SPLASHUTILS_SPEC_PATCH)) \
		$(if $(SPLASHUTILS_PATCHES),$(SPLASHUTILS_PATCHES:%=Patches/%)) \
		jpeg libmng freetype libpng \
		$(archivedir)/stlinux23-target-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SPLASHUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(SPLASHUTILS_SPEC) < $(buildprefix)/Patches/$(SPLASHUTILS_SPEC_PATCH) ) &&) \
	$(if $(SPLASHUTILS_PATCHES),cp $(SPLASHUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(SPLASHUTILS_SPEC)

$(DEPDIR)/$(SPLASHUTILS): $(DEPDIR)/%$(SPLASHUTILS): $(SPLASHUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	cp root/etc/splash/luxisri.ttf $(targetprefix)/etc/splash/ && \
	cp -rd root/etc/splash/{vdr,liquid,together}_theme $(targetprefix)/etc/splash/ && \
	$(LN_SF) liquid_theme $(targetprefix)/etc/splash/default && \
	$(INSTALL_DIR) $(targetprefix)/lib/lsb && \
	cp root/lib/lsb/splash-functions $(targetprefix)/lib/lsb/ && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true

#
# STSLAVE
#
STSLAVE := stslave
# if STM24
STSLAVE_VERSION := 0.7-25
STSLAVE_SPEC := stm-target-$(STSLAVE).spec
STSLAVE_SPEC_PATCH :=
STSLAVE_PATCHES :=
# endif STM24

STSLAVE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm

$(STSLAVE_RPM): \
		$(if $(STSLAVE_SPEC_PATCH),Patches/$(STSLAVE_SPEC_PATCH)) \
		$(if $(STSLAVE_PATCHES),$(STSLAVE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX:%23=%24)-target-$(STSLAVE)-$(STSLAVE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STSLAVE_SPEC_PATCH),( cd SPECS && patch -p1 $(STSLAVE_SPEC) < $(buildprefix)/Patches/$(STSLAVE_SPEC_PATCH) ) &&) \
	$(if $(STSLAVE_PATCHES),cp $(STSLAVE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STSLAVE_SPEC)

$(DEPDIR)/$(STSLAVE): $(DEPDIR)/%$(STSLAVE): linux-kernel-headers binutils-dev $(STSLAVE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true


#
# OPENSSL
#

OPENSSL := openssl
OPENSSL_DEV := openssl-dev
FILES_openssl_dev = \
/usr/lib
FILES_openssl = \
/usr/lib/*.so*

OPENSSL_VERSION := 1.0.1e-29
OPENSSL_SPEC := stm-target-$(OPENSSL).spec
OPENSSL_SPEC_PATCH :=
OPENSSL_PATCHES :=
OPENSSL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL)-$(OPENSSL_VERSION).sh4.rpm
OPENSSL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL_DEV)-$(OPENSSL_VERSION).sh4.rpm

$(OPENSSL_RPM) $(OPENSSL_DEV_RPM): \
		$(if $(OPENSSL_SPEC_PATCH),Patches/$(OPENSSL_SPEC_PATCH)) \
		$(if $(OPENSSL_PATCHES),$(OPENSSL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(OPENSSL)-$(OPENSSL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(OPENSSL_SPEC_PATCH),( cd SPECS && patch -p1 $(OPENSSL_SPEC) < $(buildprefix)/Patches/$(OPENSSL_SPEC_PATCH) ) &&) \
	$(if $(OPENSSL_PATCHES),cp $(OPENSSL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(OPENSSL_SPEC)

$(DEPDIR)/$(OPENSSL): $(DEPDIR)/%$(OPENSSL): $(OPENSSL_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/libcrypto.pc
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/libssl.pc
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/openssl.pc
	touch $@ || true
	$(start_build)
	$(fromrpm_build)

$(DEPDIR)/$(OPENSSL_DEV): $(DEPDIR)/%$(OPENSSL_DEV): %$(OPENSSL) $(OPENSSL_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true
	$(start_build)
	$(fromrpm_build)

#
# ALSALIB
#
ALSALIB := alsa-lib
ALSALIB_DEV := alsa-lib-dev
# if STM24
ALSALIB_VERSION := 1.0.21a-23
ALSALIB_SPEC := stm-target-$(ALSALIB).spec
ALSALIB_SPEC_PATCH :=
ALSALIB_PATCHES :=
# endif STM24

ALSALIB_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm
ALSALIB_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm

$(ALSALIB_RPM) $(ALSALIB_DEV_RPM): \
		$(if $(ALSALIB_SPEC_PATCH),Patches/$(ALSALIB_SPEC_PATCH)) \
		$(if $(ALSALIB_PATCHES),$(ALSALIB_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(ALSALIB)-$(ALSALIB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSALIB_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSALIB_SPEC) < $(buildprefix)/Patches/$(ALSALIB_SPEC_PATCH) ) &&) \
	$(if $(ALSALIB_PATCHES),cp $(ALSALIB_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSALIB_SPEC)

$(DEPDIR)/$(ALSALIB): $(DEPDIR)/%$(ALSALIB): $(ALSALIB_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true

$(DEPDIR)/$(ALSALIB_DEV): $(DEPDIR)/%$(ALSALIB_DEV): %$(ALSALIB) $(ALSALIB_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true

#
# ALSAUTILS
#
ALSAUTILS := alsa-utils
# if STM24
ALSAUTILS_VERSION := 1.0.16-16
ALSAUTILS_SPEC := stm-target-$(ALSAUTILS).spec
ALSAUTILS_SPEC_PATCH :=
ALSAUTILS_PATCHES :=
# endif STM24

ALSAUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm

$(ALSAUTILS_RPM): \
		$(if $(ALSAUTILS_SPEC_PATCH),Patches/$(ALSAUTILS_SPEC_PATCH)) \
		$(if $(ALSAUTILS_PATCHES),$(ALSAUTILS_PATCHES:%=Patches/%)) \
		$(NCURSES_DEV) $(ALSALIB_DEV) \
		$(archivedir)/$(STLINUX)-target-$(ALSAUTILS)-$(ALSAUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAUTILS_SPEC) < $(buildprefix)/Patches/$(ALSAUTILS_SPEC_PATCH) ) &&) \
	$(if $(ALSAUTILS_PATCHES),cp $(ALSAUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(ALSAUTILS_SPEC)

$(DEPDIR)/$(ALSAUTILS): $(DEPDIR)/%$(ALSAUTILS): $(ALSAUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true

#
# ALSAPLAYER
#
ALSAPLAYER := alsaplayer
ALSAPLAYER_DEV := alsaplayer-dev
ALSAPLAYER_VERSION := 0.99.77-15
ALSAPLAYER_SPEC := stm-target-$(ALSAPLAYER).spec
ALSAPLAYER_SPEC_PATCH :=
ALSAPLAYER_PATCHES :=

ALSAPLAYER_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm
ALSAPLAYER_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER_DEV)-$(ALSAPLAYER_VERSION).sh4.rpm

$(ALSAPLAYER_RPM) $(ALSAPLAYER_DEV_RPM): \
		$(if $(ALSAPLAYER_SPEC_PATCH),Patches/$(ALSAPLAYER_SPEC_PATCH)) \
		$(if $(ALSAPLAYER_PATCHES),$(ALSAPLAYER_PATCHES:%=Patches/%)) \
		libmad libid3tag \
		$(archivedir)/$(STLINUX:%23=%24)-target-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAPLAYER_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAPLAYER_SPEC) < $(buildprefix)/Patches/$(ALSAPLAYER_SPEC_PATCH) ) &&) \
	$(if $(ALSAPLAYER_PATCHES),cp $(ALSAPLAYER_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/include/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSAPLAYER_SPEC)

$(DEPDIR)/$(ALSAPLAYER): $(DEPDIR)/%$(ALSAPLAYER): $(ALSAPLAYER_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true

$(DEPDIR)/$(ALSAPLAYER_DEV): $(DEPDIR)/%$(ALSAPLAYER_DEV): $(ALSAPLAYER_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true


#
# LIBEVENT
#

LIBEVENT := libevent
LIBEVENT_DEV := libevent-dev
FILES_libevent_dev = \
/usr/lib
FILES_libevent = \
/usr/lib/*.so*

LIBEVENT_VERSION := 2.0.19-4
LIBEVENT_SPEC := stm-target-$(LIBEVENT).spec
LIBEVENT_SPEC_PATCH :=
LIBEVENT_PATCHES :=
LIBEVENT_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBEVENT)-$(LIBEVENT_VERSION).sh4.rpm
LIBEVENT_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(LIBEVENT_DEV)-$(LIBEVENT_VERSION).sh4.rpm

$(LIBEVENT_RPM) $(LIBEVENT_DEV_RPM): \
		$(if $(LIBEVENT_SPEC_PATCH),Patches/$(LIBEVENT_SPEC_PATCH)) \
		$(if $(LIBEVENT_PATCHES),$(LIBEVENT_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(LIBEVENT)-$(LIBEVENT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(LIBEVENT_SPEC_PATCH),( cd SPECS && patch -p1 $(LIBEVENT_SPEC) < $(buildprefix)/Patches/$(LIBEVENT_SPEC_PATCH) ) &&) \
	$(if $(LIBEVENT_PATCHES),cp $(LIBEVENT_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(LIBEVENT_SPEC)

$(DEPDIR)/$(LIBEVENT): $(DEPDIR)/%$(LIBEVENT): $(LIBEVENT_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true
	$(start_build)
	$(fromrpm_build)

$(DEPDIR)/$(LIBEVENT_DEV): $(DEPDIR)/%$(LIBEVENT_DEV): %$(LIBEVENT) $(LIBEVENT_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	touch $@ || true
	$(start_build)
	$(fromrpm_build)
