#
# libboost
#
BEGIN[[
libboost
  boost-1.53.0
  boost_1_53_0
  extract:http://prdownloads.sourceforge.net/sourceforge/boost/boost_1_53_0.tar.bz2
  patch:file://{PN}.diff
  remove:TARGETS/include/boost
  move:boost:TARGETS/usr/include/boost
;
]]END

$(DEPDIR)/libboost: bootstrap $(DEPENDS_libboost)
	$(PREPARE_libboost)
	cd $(DIR_libboost) && \
		$(INSTALL_libboost)
#	@DISTCLEANUP_libboost@
	touch $@

#
# libz
#
BEGIN[[
libz
  1.2.8
  zlib-{PV}
  extract:http://zlib.net/zlib-{PV}.tar.gz
  patch:file://zlib-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libz = "Compression library implementing the deflate compression method found in gzip and PKZIP"
FILES_libz = \
/usr/lib/*

LIBZ_ORDER = binutils-dev

$(DEPDIR)/libz.do_prepare: bootstrap $(DEPENDS_libz) $(if $(LIBZ_ORDER),| $(LIBZ_ORDER))
	$(PREPARE_libz)
	touch $@

$(DEPDIR)/libz.do_compile: $(DEPDIR)/libz.do_prepare
	cd $(DIR_libz) && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--shared && \
		$(MAKE)
	touch $@

$(DEPDIR)/libz: \
$(DEPDIR)/%libz: $(DEPDIR)/libz.do_compile
	$(start_build)
	cd $(DIR_libz) && \
		$(INSTALL_libz)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libz@
	touch $@

#
# libreadline
#
BEGIN[[
libreadline
  6.2
  readline-{PV}
  extract:ftp://ftp.cwru.edu/pub/bash/readline-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libreadline = GNU readline library
FILES_libreadline = \
/usr/lib

$(DEPDIR)/libreadline.do_prepare: bootstrap ncurses-dev $(DEPENDS_libreadline)
	$(PREPARE_libreadline)
	touch $@

$(DEPDIR)/libreadline.do_compile: $(DEPDIR)/libreadline.do_prepare
	cd $(DIR_libreadline) && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libreadline: \
$(DEPDIR)/%libreadline: $(DEPDIR)/libreadline.do_compile
	$(start_build)
	cd $(DIR_libreadline) && \
		$(INSTALL_libreadline)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libreadline@
	touch $@

#
# FREETYPE_OLD
#
BEGIN[[
freetype_old
  2.1.4
  freetype-{PV}
  extract:file://freetype-{PV}.tar.bz2
  patch:file://libfreetype.diff
  make:install:DESTDIR=BUILD/freetype-{PV}/install_dir
;
]]END

$(DEPDIR)/freetype-old.do_prepare: bootstrap $(DEPENDS_freetype_old)
	$(PREPARE_freetype_old)
	touch $@

$(DEPDIR)/freetype-old.do_compile: $(DEPDIR)/freetype-old.do_prepare
	cd $(DIR_freetype_old) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/freetype-old: $(DEPDIR)/freetype-old.do_compile
	cd $(DIR_freetype_old) && \
		$(INSTALL_freetype_old)
	cd freetype-2.1.4; \
		$(INSTALL_DIR) $(crossprefix)/bin; \
		cp install_dir/usr/bin/freetype-config $(crossprefix)/bin/freetype-old-config; \
		$(INSTALL_DIR) $(targetprefix)/usr/include/freetype-old; \
		$(CP_RD) install_dir/usr/include/* $(targetprefix)/usr/include/freetype-old/; \
		$(INSTALL_DIR) $(targetprefix)/usr/lib/freetype-old; \
		$(CP_RD) install_dir/usr/lib/libfreetype.{a,so*} $(targetprefix)/usr/lib/freetype-old/; \
		sed 's,-I$${prefix}/include/freetype2,-I$(targetprefix)/usr/include/freetype-old -I$(targetprefix)/usr/include/freetype-old/freetype2,g' -i $(crossprefix)/bin/freetype-old-config; \
		sed 's,/usr/include/freetype2/,$(targetprefix)/usr/include/freetype-old/freetype2/,g' -i $(crossprefix)/bin/freetype-old-config
#	@DISTCLEANUP_freetype_old@
	touch $@

#
# freetype
#
BEGIN[[
freetype
  2.4.9
  {PN}-{PV}
  extract:http://download.savannah.gnu.org/releases/{PN}/{PN}-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_freetype = "freetype"

FILES_freetype = \
/usr/lib/*.so* \
/usr/bin/freetype-config

$(DEPDIR)/freetype.do_prepare: bootstrap $(DEPENDS_freetype)
	$(PREPARE_freetype)
	touch $@

$(DEPDIR)/freetype.do_compile: $(DEPDIR)/freetype.do_prepare
	cd $(DIR_freetype) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/freetype: \
$(DEPDIR)/%freetype: $(DEPDIR)/freetype.do_compile
	$(start_build)
	cd $(DIR_freetype) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config && \
		ln -sf $(crossprefix)/bin/freetype-config $(crossprefix)/bin/$(target)-freetype-config && \
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype && \
		$(INSTALL_freetype)
		rm -f $(targetprefix)/usr/bin/freetype-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_freetype@
	touch $@

#
# lirc
#
BEGIN[[
lirc
  0.9.0
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}-try_first_last_remote.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lirc ="lirc"
PKGR_lirc = r3
FILES_lirc = \
/usr/bin/lircd \
/usr/lib/*.so* \
/etc/lircd*

$(DEPDIR)/lirc.do_prepare: bootstrap $(DEPENDS_lirc)
	$(PREPARE_lirc)
	touch $@

$(DEPDIR)/lirc.do_compile: $(DEPDIR)/lirc.do_prepare
	cd $(DIR_lirc) && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -Os -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed && \
		$(MAKE) all
	touch $@

$(DEPDIR)/lirc: \
$(DEPDIR)/%lirc: $(DEPDIR)/lirc.do_compile
	$(start_build)
	cd $(DIR_lirc) && \
		$(INSTALL_lirc)
	$(tocdk_build)
	$(INSTALL_DIR) $(PKDIR)/etc
	$(INSTALL_DIR) $(PKDIR)/var/run/lirc/
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)).conf $(PKDIR)/etc/lircd.conf
ifdef ENABLE_SPARK
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(SPARK),_$(SPARK)).conf.09_00_0B $(PKDIR)/etc/lircd.conf.09_00_0B
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(SPARK),_$(SPARK)).conf.09_00_07 $(PKDIR)/etc/lircd.conf.09_00_07
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(SPARK),_$(SPARK)).conf.09_00_08 $(PKDIR)/etc/lircd.conf.09_00_08
	$(INSTALL_FILE) $(buildprefix)/root/etc/lircd$(if $(SPARK),_$(SPARK)).conf.09_00_1D $(PKDIR)/etc/lircd.conf.09_00_1D
endif
	$(toflash_build)
#	@DISTCLEANUP_lirc@
	touch $@

#
# jpeg
#
BEGIN[[
jpeg
  8d
  {PN}-{PV}
  extract:http://www.ijg.org/files/{PN}src.v{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_jpeg = "jpeg"

FILES_jpeg = \
/usr/lib/*.so* 

$(DEPDIR)/jpeg.do_prepare: bootstrap $(DEPENDS_jpeg)
	$(PREPARE_jpeg)
	touch $@

$(DEPDIR)/jpeg.do_compile: $(DEPDIR)/jpeg.do_prepare
	cd $(DIR_jpeg) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--enable-static \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/jpeg: \
$(DEPDIR)/%jpeg: $(DEPDIR)/jpeg.do_compile
	$(start_build)
	cd $(DIR_jpeg) && \
		$(INSTALL_jpeg)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_jpeg@
	touch $@

#
# jpeg-6b
#
BEGIN[[
libjpeg6b
  6b1
  jpeg-{PV}
  extract:http://ftp.de.debian.org/debian/pool/main/libj/libjpeg6b/{PN}_{PV}.orig.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libjpeg6b = "libjpeg6b"

FILES_libjpeg6b = \
/usr/lib/libjpeg.so.* 

$(DEPDIR)/libjpeg6b.do_prepare: bootstrap $(DEPENDS_libjpeg6b)
	$(PREPARE_libjpeg6b)
	touch $@

$(DEPDIR)/libjpeg6b.do_compile: $(DEPDIR)/libjpeg6b.do_prepare
	cd $(DIR_libjpeg6b) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--enable-static \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libjpeg6b: \
$(DEPDIR)/%libjpeg6b: $(DEPDIR)/libjpeg6b.do_compile
	$(start_build)
	cd $(DIR_libjpeg6b) && \
		$(INSTALL_libjpeg6b)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libjpeg6b@
	touch $@

#
# libpng
#
BEGIN[[
libpng
  1.5.6
  {PN}-{PV}
  extract:http://www.fhloston-paradise.de/{PN}-{PV}.tar.gz
  nothing:file://{PN}.diff
  patch:file://{PN}-{PV}-workaround_for_stmfb_alpha_error.patch
  make:install:prefix=PKDIR/usr
;
]]END

DESCRIPTION_libpng = "libpng"

FILES_libpng = \
/usr/lib/*.so*

$(DEPDIR)/libpng.do_prepare: bootstrap libz $(DEPENDS_libpng)
	$(PREPARE_libpng)
	touch $@

$(DEPDIR)/libpng.do_compile: $(DEPDIR)/libpng.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libpng) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng: \
$(DEPDIR)/%libpng: $(DEPDIR)/libpng.do_compile
	$(start_build)
	cd $(DIR_libpng) && \
		sed -e "s,^prefix=,prefix=$(PKDIR)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		$(INSTALL_libpng)
		rm -f $(PKDIR)/usr/bin/libpng*-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libpng@
	touch $@

#
# libpng12
#
BEGIN[[
libpng12
  1.2.49
  libpng-{PV}
  extract:http://ftp.de.debian.org/debian/pool/main/libp/libpng/libpng_{PV}.orig.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libpng12 = "libpng12"

FILES_libpng12 = \
/usr/lib/libpng12.so*

$(DEPDIR)/libpng12.do_prepare: bootstrap libz $(DEPENDS_libpng12)
	$(PREPARE_libpng12)
	touch $@

$(DEPDIR)/libpng12.do_compile: $(DEPDIR)/libpng12.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libpng12) && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng12: \
$(DEPDIR)/%libpng12: $(DEPDIR)/libpng12.do_compile
	$(start_build)
	cd $(DIR_libpng12) && \
		sed -e "s,^prefix=,prefix=$(PKDIR)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		$(INSTALL_libpng)
		rm -f $(PKDIR)/usr/bin/libpng*-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libpng12@
	touch $@

#
# libungif
#
BEGIN[[
libungif
  4.1.4
  {PN}-{PV}
  extract:http://heanet.dl.sourceforge.net/sourceforge/giflib/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libungif = "libungif"

FILES_libungif = \
/usr/lib/*.so*

$(DEPDIR)/libungif.do_prepare: bootstrap $(DEPENDS_libungif)
	$(PREPARE_libungif)
	touch $@

$(DEPDIR)/libungif.do_compile: $(DEPDIR)/libungif.do_prepare
	cd $(DIR_libungif) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libungif: \
$(DEPDIR)/%libungif: $(DEPDIR)/libungif.do_compile
	$(start_build)
	cd $(DIR_libungif) && \
		$(INSTALL_libungif)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libungif@
	touch $@

#
# libgif
#
BEGIN[[
libgif
  4.1.6
  giflib-{PV}
  extract:http://heanet.dl.sourceforge.net/sourceforge/giflib/giflib-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libgif = "libgif"

FILES_libgif = \
/usr/lib/*.so*

$(DEPDIR)/libgif.do_prepare: bootstrap $(DEPENDS_libgif)
	$(PREPARE_libgif)
	touch $@

$(DEPDIR)/libgif.do_compile: $(DEPDIR)/libgif.do_prepare
	cd $(DIR_libgif) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libgif: \
$(DEPDIR)/%libgif: $(DEPDIR)/libgif.do_compile
	$(start_build)
	cd $(DIR_libgif) && \
		$(INSTALL_libgif)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libgif@
	touch $@

#
# libcurl
#
BEGIN[[
curl
  7.30.0
  {PN}-{PV}
  extract:http://{PN}.haxx.se/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_curl = "Curl is a command line tool for transferring data specified with URL syntax"

FILES_curl = \
/usr/lib/*.so* \
/usr/bin/curl

$(DEPDIR)/curl.do_prepare: bootstrap openssl rtmpdump libz $(DEPENDS_curl)
	$(PREPARE_curl)
	touch $@

$(DEPDIR)/curl.do_compile: $(DEPDIR)/curl.do_prepare
	cd $(DIR_curl) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-ssl \
			--disable-debug \
			--disable-verbose \
			--disable-manual \
			--mandir=/usr/share/man \
			--with-random && \
		$(MAKE) all
	touch $@

$(DEPDIR)/curl: \
$(DEPDIR)/%curl: $(DEPDIR)/curl.do_compile
	$(start_build)
	cd $(DIR_curl) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config && \
		$(INSTALL_curl)
		rm -f $(PKDIR)/usr/bin/curl-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_curl@
	touch $@

#
# libfribidi
#
BEGIN[[
libfribidi
  0.19.5
  fribidi-{PV}
  extract:http://fribidi.org/download/fribidi-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libfribidi = "libfribidi"

FILES_libfribidi = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/libfribidi.do_prepare: bootstrap $(DEPENDS_libfribidi)
	$(PREPARE_libfribidi)
	touch $@

$(DEPDIR)/libfribidi.do_compile: $(DEPDIR)/libfribidi.do_prepare
	cd $(DIR_libfribidi) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-memopt && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libfribidi: \
$(DEPDIR)/%libfribidi: $(DEPDIR)/libfribidi.do_compile
	$(start_build)
	cd $(DIR_libfribidi) && \
		$(INSTALL_libfribidi)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libfribidi@
	touch $@

#
# libsigc
#
BEGIN[[
libsigc
  1.2.7
  {PN}++-{PV}
  extract:http://ftp.gnome.org/pub/GNOME/sources/{PN}++/1.2/{PN}++-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libsigc = "libsigc"

FILES_libsigc = \
/usr/lib/*.so*

$(DEPDIR)/libsigc.do_prepare: bootstrap libstdc++-dev $(DEPENDS_libsigc)
	$(PREPARE_libsigc)
	touch $@

$(DEPDIR)/libsigc.do_compile: $(DEPDIR)/libsigc.do_prepare
	cd $(DIR_libsigc) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libsigc: \
$(DEPDIR)/%libsigc: $(DEPDIR)/libsigc.do_compile
	$(start_build)
	cd $(DIR_libsigc) && \
		$(INSTALL_libsigc)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libsigc@
	touch $@

#
# libmad
#
BEGIN[[
libmad
  0.15.1b
  {PN}-{PV}
  extract:ftp://ftp.mars.org/pub/mpeg/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmad = "libmad - MPEG audio decoder library"

FILES_libmad = \
/usr/lib/*.so*

$(DEPDIR)/libmad.do_prepare: bootstrap $(DEPENDS_libmad)
	$(PREPARE_libmad)
	touch $@

$(DEPDIR)/libmad.do_compile: $(DEPDIR)/libmad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmad) && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		autoheader && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libmad: \
$(DEPDIR)/%libmad: $(DEPDIR)/libmad.do_compile
	$(start_build)
	cd $(DIR_libmad) && \
		$(INSTALL_libmad)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libmad@
	touch $@

#
# libid3tag
#
BEGIN[[
libid3tag
  0.15.1b
  {PN}-{PV}
  extract:ftp://ftp.mars.org/pub/mpeg/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libid3tag = "libid3tag"

FILES_libid3tag = \
/usr/lib/*.so*

$(DEPDIR)/libid3tag.do_prepare: bootstrap libz $(DEPENDS_libid3tag)
	$(PREPARE_libid3tag)
	touch $@

$(DEPDIR)/libid3tag.do_compile: $(DEPDIR)/libid3tag.do_prepare
	cd $(DIR_libid3tag) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared=yes && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libid3tag: \
$(DEPDIR)/%libid3tag: %libz $(DEPDIR)/libid3tag.do_compile
	$(start_build)
	cd $(DIR_libid3tag) && \
		$(INSTALL_libid3tag)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libid3tag@
	touch $@

#
# libvorbisidec
#
BEGIN[[
libvorbisidec
  1.0.2+svn16259
  {PN}-{PV}
  extract:http://ftp.debian.org/debian/pool/main/libv/{PN}/{PN}_{PV}.orig.tar.gz
  patch:file://tremor.diff
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libvorbisidec = "libvorbisidec"

FILES_libvorbisidec = \
/usr/lib/*.so*

$(DEPDIR)/libvorbisidec.do_prepare: bootstrap $(DEPENDS_libvorbisidec)
	$(PREPARE_libvorbisidec)
	touch $@

$(DEPDIR)/libvorbisidec.do_compile: $(DEPDIR)/libvorbisidec.do_prepare
	cd $(DIR_libvorbisidec) && \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libvorbisidec: $(DEPDIR)/libvorbisidec.do_compile
	$(start_build)
	cd $(DIR_libvorbisidec) && \
		$(INSTALL_libvorbisidec)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libvorbisidec@
	touch $@

#
# libglib2
# You need libglib2.0-dev on host system
#
BEGIN[[
glib2
  2.28.3
  glib-{PV}
  extract:http://ftp.acc.umu.se/pub/GNOME/sources/glib/2.28/glib-{PV}.tar.gz
  patch:file://glib-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_glib2 = "libglib2"

FILES_glib2 = \
/usr/lib/*.so*

$(DEPDIR)/glib2.do_prepare: bootstrap libz $(DEPENDS_glib2)
	$(PREPARE_glib2)
	touch $@

$(DEPDIR)/glib2.do_compile: $(DEPDIR)/glib2.do_prepare
	echo "glib_cv_va_copy=no" > $(DIR_glib2)/config.cache
	echo "glib_cv___va_copy=yes" >> $(DIR_glib2)/config.cache
	echo "glib_cv_va_val_copy=yes" >> $(DIR_glib2)/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> $(DIR_glib2)/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> $(DIR_glib2)/config.cache
	echo "glib_cv_stack_grows=no" >> $(DIR_glib2)/config.cache
	echo "glib_cv_uscore=no" >> $(DIR_glib2)/config.cache
	cd $(DIR_glib2) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) all
	touch $@

$(DEPDIR)/glib2: \
$(DEPDIR)/%glib2: $(DEPDIR)/glib2.do_compile
	$(start_build)
	cd $(DIR_glib2) && \
		$(INSTALL_glib2)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_glib2@
	touch $@

#
# libiconv
#
BEGIN[[
libiconv
  1.14
  {PN}-{PV}
  extract:http://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libiconv = "libiconv"

FILES_libiconv = \
/usr/lib/*.so* \
/usr/bin/iconv

$(DEPDIR)/libiconv.do_prepare: bootstrap $(DEPENDS_libiconv)
	$(PREPARE_libiconv)
	touch $@

$(DEPDIR)/libiconv.do_compile: $(DEPDIR)/libiconv.do_prepare
	cd $(DIR_libiconv) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libiconv: \
$(DEPDIR)/%libiconv: $(DEPDIR)/libiconv.do_compile
	$(start_build)
	cd $(DIR_libiconv) && \
		cp ./srcm4/* $(hostprefix)/share/aclocal/ && \
		$(INSTALL_libiconv)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libiconv@
	touch $@

#
# libmng
#
BEGIN[[
libmng
  1.0.10
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmng = "libmng - Multiple-image Network Graphics"

FILES_libmng = \
/usr/lib/*.so*

$(DEPDIR)/libmng.do_prepare: bootstrap libz jpeg lcms $(DEPENDS_libmng)
	$(PREPARE_libmng)
	touch $@

$(DEPDIR)/libmng.do_compile: $(DEPDIR)/libmng.do_prepare
	cd $(DIR_libmng) && \
		cat unmaintained/autogen.sh | tr -d \\r > autogen.sh && chmod 755 autogen.sh && \
		[ ! -x ./configure ] && ./autogen.sh --help || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static \
			--with-zlib \
			--with-jpeg \
			--with-gnu-ld \
			--with-lcms && \
		$(MAKE)
	touch $@

$(DEPDIR)/libmng: \
$(DEPDIR)/%libmng: $(DEPDIR)/libmng.do_compile
	$(start_build)
	cd $(DIR_libmng) && \
		$(INSTALL_libmng)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libmng@
	touch $@	
#
# lcms
#
BEGIN[[
lcms
  1.17
  {PN}-{PV}
  extract:http://dfn.dl.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lcms = "lcms"

FILES_lcms = \
/usr/lib/*

$(DEPDIR)/lcms.do_prepare: bootstrap libz jpeg $(DEPENDS_lcms)
	$(PREPARE_lcms)
	touch $@

$(DEPDIR)/lcms.do_compile: $(DEPDIR)/lcms.do_prepare
	cd $(DIR_lcms) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static && \
		$(MAKE)
	touch $@

$(DEPDIR)/lcms: \
$(DEPDIR)/%lcms: $(DEPDIR)/lcms.do_compile
	$(start_build)
	cd $(DIR_lcms) && \
		$(INSTALL_lcms)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_lcms@
	touch $@
#
# directfb
#
BEGIN[[
directfb
  1.4.11
  DirectFB-{PV}
  extract:http://{PN}.org/downloads/Core/DirectFB-1.4/DirectFB-{PV}.tar.gz
  patch:file://{PN}-{PV}+STM2010.12.15-4.diff
  patch:file://{PN}-{PV}+STM2010.12.15-4.no-vt.diff
  patch:file://{PN}-libpng.diff
  patch:file://{PN}-{PV}+STM2010.12.15-4.enigma2remote.diff
  make:install:DESTDIR=PKDIR:LD=sh4-linux-ld
;
]]END

DESCRIPTION_directfb = "directfb"

FILES_directfb = \
/usr/lib/*.so* \
/usr/lib/directfb-1.4-5/gfxdrivers/*.so* \
/usr/lib/directfb-1.4-5/inputdrivers/*.so* \
/usr/lib/directfb-1.4-5/interfaces/*.so* \
/usr/lib/directfb-1.4-5/systems/libdirectfb_stmfbdev.so \
/usr/lib/directfb-1.4-5/wm/*.so* \
/usr/bin/*

$(DEPDIR)/directfb.do_prepare: bootstrap freetype $(DEPENDS_directfb)
	$(PREPARE_directfb)
	touch $@

$(DEPDIR)/directfb.do_compile: $(DEPDIR)/directfb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_directfb) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--disable-sdl \
			--disable-x11 \
			--disable-devmem \
			--disable-multi \
			--with-gfxdrivers=stgfx \
			--with-inputdrivers=linuxinput,enigma2remote \
			--without-software \
			--enable-stmfbdev \
			--disable-fbdev \
			--enable-mme=yes && \
			export top_builddir=`pwd` && \
		$(MAKE)
	touch $@

$(DEPDIR)/directfb: \
$(DEPDIR)/%directfb: $(DEPDIR)/directfb.do_compile
	$(start_build)
	cd $(DIR_directfb) && \
		$(INSTALL_directfb)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_directfb@
	touch $@

#
# DFB++
#
BEGIN[[
dfbpp
  1.0.0
  DFB++-{PV}
  extract:http://www.directfb.org/downloads/Extras/DFB++-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_dfbpp = ""

FILES_dfbpp = \
/usr/lib/*.so*

$(DEPDIR)/dfbpp.do_prepare: bootstrap libz jpeg directfb $(DEPENDS_dfbpp)
	$(PREPARE_dfbpp)
	touch $@

$(DEPDIR)/dfbpp.do_compile: $(DEPDIR)/dfbpp.do_prepare
	cd $(DIR_dfbpp) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/dfbpp: \
$(DEPDIR)/%dfbpp: $(DEPDIR)/dfbpp.do_compile
	$(start_build)
	cd $(DIR_dfbpp) && \
		$(INSTALL_dfbpp)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_dfbpp@
	touch $@

#
# LIBSTGLES
#
BEGIN[[
libstgles
  git
  {PN}-{PV}
  plink:../apps/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libstgles = "libstgles"
SRC_URI_libstgles = "https://code.google.com/p/tdt-amiko/"
PKGR_libstgles =r1
FILES_libstgles = \
/usr/lib/*

$(DEPDIR)/libstgles.do_prepare: bootstrap directfb $(DEPENDS_libstgles)
	$(PREPARE_libstgles)
	touch $@

$(DEPDIR)/libstgles.do_compile: $(DEPDIR)/libstgles.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libstgles) && \
	cp --remove-destination $(hostprefix)/share/libtool/config/ltmain.sh . && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/libstgles: \
$(DEPDIR)/%libstgles: $(DEPDIR)/libstgles.do_compile
	$(start_build)
	cd $(DIR_libstgles) && \
		$(INSTALL_libstgles)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libstgles@
	touch $@

#
# expat
#
BEGIN[[
expat
  2.1.0
  {PN}-{PV}
  extract:http://prdownloads.sourceforge.net/sourceforge/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_expat = "Expat is an XML parser library written in C. It is a stream-oriented parser in which an application registers handlers for things the parser might find in the XML document"

FILES_expat = \
/usr/lib/libexpat.so* \
/usr/bin/xmlwf

$(DEPDIR)/expat.do_prepare: bootstrap $(DEPENDS_expat)
	$(PREPARE_expat)
	touch $@

$(DEPDIR)/expat.do_compile: $(DEPDIR)/expat.do_prepare
	cd $(DIR_expat) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/expat: \
$(DEPDIR)/%expat: $(DEPDIR)/expat.do_compile
	$(start_build)
	cd $(DIR_expat) && \
		$(INSTALL_expat)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_expat@
	touch $@

#
# fontconfig
#
BEGIN[[
fontconfig
  2.10.2
  {PN}-{PV}
  extract:http://{PN}.org/release/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_fontconfig = "Fontconfig is a library for configuring and customizing font access."

FILES_fontconfig = \
/etc \
/usr/lib/*

$(DEPDIR)/fontconfig.do_prepare: bootstrap libz libxml2 freetype $(DEPENDS_fontconfig)
	$(PREPARE_fontconfig)
	touch $@

$(DEPDIR)/fontconfig.do_compile: $(DEPDIR)/fontconfig.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_fontconfig) && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os -I$(targetprefix)/usr/include/libxml2" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(crossprefix)/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts && \
		$(MAKE)
	touch $@

$(DEPDIR)/fontconfig: \
$(DEPDIR)/%fontconfig: $(DEPDIR)/fontconfig.do_compile
	$(start_build)
	cd $(DIR_fontconfig) && \
		$(INSTALL_fontconfig)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_fontconfig@
	touch $@

#
# libxmlccwrap
#
BEGIN[[
libxmlccwrap
  0.0.12
  {PN}-{PV}
  extract:http://www.ant.uni-bremen.de/whomes/rinas/{PN}/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxmlccwrap = "libxmlccwrap is a small C++ wrapper around libxml2 and libxslt "

FILES_libxmlccwrap = \
/usr/lib/*.so*

$(DEPDIR)/libxmlccwrap.do_prepare: bootstrap libxslt $(DEPENDS_libxmlccwrap)
	$(PREPARE_libxmlccwrap)
	touch $@

$(DEPDIR)/libxmlccwrap.do_compile: $(DEPDIR)/libxmlccwrap.do_prepare
	cd $(DIR_libxmlccwrap) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxmlccwrap: \
$(DEPDIR)/%libxmlccwrap: libxmlccwrap.do_compile
	$(start_build)
	cd $(DIR_libxmlccwrap) && \
		$(INSTALL_libxmlccwrap) && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(PKDIR)/usr/lib,g" -i $(PKDIR)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(PKDIR)/usr/lib,g" -i $(PKDIR)/usr/lib/libxmlccwrap.la
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libxmlccwrap@
	touch $@

#
# a52dec
#
BEGIN[[
a52dec
  0.7.4
  {PN}-{PV}
  extract:http://liba52.sourceforge.net/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_a52dec = "liba52 is a free library for decoding ATSC A/52 streams. It is released under the terms of the GPL license"

FILES_a52dec = \
/usr/lib/*

$(DEPDIR)/a52dec.do_prepare: bootstrap $(DEPENDS_a52dec)
	$(PREPARE_a52dec)
	touch $@

$(DEPDIR)/a52dec.do_compile: $(DEPDIR)/a52dec.do_prepare
	cd $(DIR_a52dec) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/a52dec: \
$(DEPDIR)/%a52dec: a52dec.do_compile
	$(start_build)
	cd $(DIR_a52dec) && \
		$(INSTALL_a52dec)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_a52dec@
	touch $@

#
# libdvdcss
#
BEGIN[[
libdvdcss
  1.2.12
  {PN}-{PV}
  extract:http://download.videolan.org/pub/{PN}/{PV}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libdvdcss = "libdvdcss"

FILES_libdvdcss = \
/usr/lib/libdvdcss.so*

$(DEPDIR)/libdvdcss.do_prepare: bootstrap $(DEPENDS_libdvdcss)
	$(PREPARE_libdvdcss)
	touch $@

$(DEPDIR)/libdvdcss.do_compile: $(DEPDIR)/libdvdcss.do_prepare
	cd $(DIR_libdvdcss) && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-doc \
		&& \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdcss: \
$(DEPDIR)/%libdvdcss: libdvdcss.do_compile
	$(start_build)
	cd $(DIR_libdvdcss) && \
		$(INSTALL_libdvdcss)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdvdcss@
	touch $@

#
# libdvdnav
#
BEGIN[[
libdvdnav
  4.1.3
  {PN}-{PV}
  extract:http://www.mplayerhq.hu/MPlayer/releases/dvdnav-old/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-3.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libdvdnav = "libdvdnav"

FILES_libdvdnav = \
/usr/lib/*.so* \
/usr/bin/dvdnav-config

$(DEPDIR)/libdvdnav.do_prepare: bootstrap libdvdread $(DEPENDS_libdvdnav)
	$(PREPARE_libdvdnav)
	touch $@

$(DEPDIR)/libdvdnav.do_compile: $(DEPDIR)/libdvdnav.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvdnav) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			--with-dvdread-config=$(crossprefix)/bin/dvdread-config && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdnav: \
$(DEPDIR)/%libdvdnav: libdvdnav.do_compile
	 $(start_build)
	 cd $(DIR_libdvdnav) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdnav-config > $(crossprefix)/bin/dvdnav-config && \
		chmod 755 $(crossprefix)/bin/dvdnav-config && \
		$(INSTALL_libdvdnav)
		rm -f $(targetprefix)/usr/bin/dvdnav-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdvdnav@
	touch $@

#
# libdvdread
#
BEGIN[[
libdvdread
  4.1.3
  {PN}-{PV}
  extract:http://www.mplayerhq.hu/MPlayer/releases/dvdnav-old/{PN}-{PV}.tar.bz2
  patch:file://{PN}_{PV}-5.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libdvdread = "libdvdread"

FILES_libdvdread = \
/usr/lib/*.so* \
/usr/bin/dvdread-config

$(DEPDIR)/libdvdread.do_prepare: bootstrap $(DEPENDS_libdvdread)
	$(PREPARE_libdvdread)
	touch $@

$(DEPDIR)/libdvdread.do_compile: $(DEPDIR)/libdvdread.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvdread) && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-static \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdread: \
$(DEPDIR)/%libdvdread: libdvdread.do_compile
	$(start_build)
	cd $(DIR_libdvdread) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdread-config > $(crossprefix)/bin/dvdread-config && \
		chmod 755 $(crossprefix)/bin/dvdread-config && \
		$(INSTALL_libdvdread)
		rm -f $(targetprefix)/usr/bin/dvdread-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdvdread@
	touch $@

#
# ffmpeg
#
BEGIN[[
ffmpeg
  1.2
  {PN}-{PV}
  extract:http://{PN}.org/releases/{PN}-{PV}.tar.gz
  patch:file://{PN}-1.0.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_ffmpeg = "ffmpeg"

FILES_ffmpeg = \
/usr/lib/*.so* \
/sbin/ffmpeg

$(DEPDIR)/ffmpeg.do_prepare: bootstrap libass rtmpdump $(DEPENDS_ffmpeg)
	$(PREPARE_ffmpeg)
	touch $@

$(DEPDIR)/ffmpeg.do_compile: $(DEPDIR)/ffmpeg.do_prepare
	cd $(DIR_ffmpeg) && \
	$(BUILDENV) \
	./configure \
		--disable-vfp \
		--disable-runtime-cpudetect \
		--disable-static \
		--enable-shared \
		--enable-cross-compile \
		--disable-ffserver \
		--disable-ffplay \
		--disable-altivec \
		--disable-debug \
		--disable-asm \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-fma4 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-neon \
		--disable-vis \
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-indevs \
		--disable-outdevs \
		--disable-muxers \
		--enable-muxer=ogg \
		--enable-muxer=flac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=mpeg1video \
		--enable-muxer=mpeg2video \
		--enable-muxer=image2 \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=png \
		--enable-encoder=mpeg1video \
		--enable-encoder=mpeg2video \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=mp3 \
		--enable-decoder=theora \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h264 \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=png \
		--enable-decoder=mjpeg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		--enable-decoder=dvbsub \
		--enable-decoder=iff_byterun1 \
		--enable-small \
		--enable-avresample \
		--enable-pthreads \
		--enable-bzlib \
		--enable-librtmp \
		--pkg-config="pkg-config" \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--extra-cflags="-fno-strict-aliasing" \
		--enable-stripping \
		--prefix=/usr
	touch $@

$(DEPDIR)/ffmpeg: \
$(DEPDIR)/%ffmpeg: $(DEPDIR)/ffmpeg.do_compile
	$(start_build)
	cd $(DIR_ffmpeg) && \
		$(INSTALL_ffmpeg)
	$(tocdk_build)
	mv $(PKDIR)/usr/bin $(PKDIR)/sbin
	$(toflash_build)
#	@DISTCLEANUP_ffmpeg@
	touch $@

#
# libass
#
BEGIN[[
libass
  0.10.1
  {PN}-{PV}
  extract:http://{PN}.googlecode.com/files/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libass = "libass"

FILES_libass = \
/usr/lib/*.so*

$(DEPDIR)/libass.do_prepare: bootstrap freetype libfribidi $(DEPENDS_libass)
	$(PREPARE_libass)
	touch $@

$(DEPDIR)/libass.do_compile: $(DEPDIR)/libass.do_prepare
	cd $(DIR_libass) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--disable-enca \
		--prefix=/usr
	touch $@

$(DEPDIR)/libass: \
$(DEPDIR)/%libass: $(DEPDIR)/libass.do_compile
	$(start_build)
	cd $(DIR_libass) && \
		$(INSTALL_libass)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libass@
	touch $@

#
# WebKitDFB
#
BEGIN[[
webkitdfb
  2010-11-18
  {PN}_{PV}
  extract:http://www.duckbox.info/files/packages/{PN}_{PV}.tar.gz
  patch:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_webkitdfb = "webkitdfb"
RDEPENDS_webkitdfb = lite enchant fontconfig sqlite cairo enchant
FILES_webkitdfb = \
/usr/lib*

$(DEPDIR)/webkitdfb.do_prepare: bootstrap glib2 icu4c libxml2 enchant lite curl fontconfig sqlite libsoup cairo jpeg $(DEPENDS_webkitdfb)
	$(PREPARE_webkitdfb)
	touch $@

$(DEPDIR)/webkitdfb.do_compile: $(DEPDIR)/webkitdfb.do_prepare
	export PATH=$(buildprefix)/$(DIR_icu4c)/host/config:$(PATH) && \
	cd $(DIR_webkitdfb) && \
	$(BUILDENV) \
	./autogen.sh \
		--with-target=directfb \
		--without-gtkplus \
		--host=$(target) \
		--prefix=/usr \
		--with-cairo-directfb \
		--disable-shared-workers \
		--enable-optimizations \
		--disable-channel-messaging \
		--disable-javascript-debugger \
		--enable-offline-web-applications \
		--enable-dom-storage \
		--enable-database \
		--disable-eventsource \
		--enable-icon-database \
		--enable-datalist \
		--disable-video \
		--enable-svg \
		--enable-xpath \
		--disable-xslt \
		--disable-dashboard-support \
		--disable-geolocation \
		--disable-workers \
		--disable-web-sockets \
		--with-networking-backend=soup
	touch $@

$(DEPDIR)/webkitdfb: \
$(DEPDIR)/%webkitdfb: $(DEPDIR)/webkitdfb.do_compile
	$(start_build)
	cd $(DIR_webkitdfb) && \
		$(INSTALL_webkitdfb)
	$(tocdk_build)
	$(e2extra_build)
#	@DISTCLEANUP_webkitdfb@
	touch $@

#
# icu4c
#
BEGIN[[
icu4c
  4_4_1
  icu/source
  extract:http://download.icu-project.org/files/{PN}/4.4.1/{PN}-4_4_1-src.tgz
  nothing:file://{PN}-4_4_1_locales.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_icu4c = "icu4c"

FILES_icu4c = \
/usr/lib/*.so* \
/usr/bin/* \
/usr/sbin/*

$(DEPDIR)/icu4c.do_prepare: bootstrap $(DEPENDS_icu4c)
	$(PREPARE_icu4c)
	cd $(DIR_icu4c) && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < $(buildprefix)/Patches/icu4c-4_4_1_locales.patch;
	touch $@

$(DEPDIR)/icu4c.do_compile: $(DEPDIR)/icu4c.do_prepare
	echo "Building host icu"
	mkdir -p $(DIR_icu4c)/host && \
	cd $(DIR_icu4c)/host && \
	sh ../configure --disable-samples --disable-tests && \
	unset TARGET && \
	make
	echo "Building cross icu"
	cd $(DIR_icu4c) && \
	$(BUILDENV) \
	./configure \
		--with-cross-build=$(buildprefix)/$(DIR_icu4c)/host \
		--host=$(target) \
		--prefix=/usr \
		--disable-extras \
		--disable-layout \
		--disable-tests \
		--disable-samples
	touch $@

$(DEPDIR)/icu4c: \
$(DEPDIR)/%icu4c: $(DEPDIR)/icu4c.do_compile
	$(start_build)
	cd $(DIR_icu4c) && \
		unset TARGET && \
		$(INSTALL_icu4c)
	$(tocdk_build)
	$(e2extra_build)
#	@DISTCLEANUP_icu4c@
	touch $@

#
# enchant
#
BEGIN[[
enchant
  1.5.0
  {PN}-{PV}
  extract:http://www.abisource.com/downloads/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_enchant = "libenchant -- Generic spell checking library"

FILES_enchant = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/enchant.do_prepare: bootstrap $(DEPENDS_enchant)
	$(PREPARE_enchant)
	touch $@

$(DEPDIR)/enchant.do_compile: $(DEPDIR)/enchant.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_enchant) && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--disable-aspell \
		--disable-ispell \
		--disable-myspell \
		--disable-zemberek \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/enchant: \
$(DEPDIR)/%enchant: $(DEPDIR)/enchant.do_compile
	$(start_build)
	cd $(DIR_enchant) && \
		$(INSTALL_enchant)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_enchant@
	touch $@

#
# lite
#
BEGIN[[
lite
  0.9.0
  {PN}-{PV}+git0.7982ccc
  extract:http://www.duckbox.info/files/packages/{PN}-{PV}+git0.7982ccc.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lite = "LiTE is a Toolkit Engine"

FILES_lite = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/lite.do_prepare: bootstrap directfb $(DEPENDS_lite)
	$(PREPARE_lite)
	touch $@

$(DEPDIR)/lite.do_compile: $(DEPDIR)/lite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_lite) && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-debug
	touch $@

$(DEPDIR)/lite: \
$(DEPDIR)/%lite: $(DEPDIR)/lite.do_compile
	$(start_build)
	cd $(DIR_lite) && \
		$(INSTALL_lite)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_lite@
	touch $@

#
# sqlite
#
BEGIN[[
sqlite
  3.7.11
  {PN}-autoconf-3071100
  extract:http://www.{PN}.org/{PN}-autoconf-3071100.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_sqlite = "sqlite"

FILES_sqlite = \
/usr/lib/*.so* \
/usr/bin/sqlite3

$(DEPDIR)/sqlite.do_prepare: bootstrap $(DEPENDS_sqlite)
	$(PREPARE_sqlite)
	touch $@

$(DEPDIR)/sqlite.do_compile: $(DEPDIR)/sqlite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sqlite) && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-tcl \
		--disable-debug
	touch $@

$(DEPDIR)/sqlite: \
$(DEPDIR)/%sqlite: $(DEPDIR)/sqlite.do_compile
	$(start_build)
	cd $(DIR_sqlite) && \
		$(INSTALL_sqlite)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_sqlite@
	touch $@

#
# libsoup
#
BEGIN[[
libsoup
  2.33.90
  {PN}-{PV}
  extract:http://download.gnome.org/sources/{PN}/2.33/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libsoup = "libsoup is an HTTP client/server library"

FILES_libsoup = \
/usr/lib/*.so*

$(DEPDIR)/libsoup.do_prepare: bootstrap $(DEPENDS_libsoup)
	$(PREPARE_libsoup)
	touch $@

$(DEPDIR)/libsoup.do_compile: $(DEPDIR)/libsoup.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libsoup) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-more-warnings \
		--without-gnome
	touch $@

$(DEPDIR)/libsoup: \
$(DEPDIR)/%libsoup: $(DEPDIR)/libsoup.do_compile
	$(start_build)
	cd $(DIR_libsoup) && \
		$(INSTALL_libsoup)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libsoup@
	touch $@

#
# pixman
#
BEGIN[[
pixman
  0.18.0
  {PN}-{PV}
  extract:http://cairographics.org/releases/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_pixman = "pixman is a library that provides low-level pixel manipulation"

FILES_pixman = \
/usr/lib/*.so*

$(DEPDIR)/pixman.do_prepare: bootstrap $(DEPENDS_pixman)
	$(PREPARE_pixman)
	touch $@

$(DEPDIR)/pixman.do_compile: $(DEPDIR)/pixman.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_pixman) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/pixman: \
$(DEPDIR)/%pixman: $(DEPDIR)/pixman.do_compile
	$(start_build)
	cd $(DIR_pixman) && \
		$(INSTALL_pixman)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pixman@
	touch $@

#
# cairo
#
BEGIN[[
cairo
  1.8.10
  {PN}-{PV}
  extract:http://{PN}graphics.org/releases/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_cairo = "Cairo - Multi-platform 2D graphics library"

FILES_cairo = \
/usr/lib/*.so*

$(DEPDIR)/cairo.do_prepare: bootstrap libpng pixman $(DEPENDS_cairo)
	$(PREPARE_cairo)
	touch $@

$(DEPDIR)/cairo.do_compile: $(DEPDIR)/cairo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_cairo) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-gtk-doc \
		--enable-ft=yes \
		--enable-png=yes \
		--enable-ps=no \
		--enable-pdf=no \
		--enable-svg=no \
		--disable-glitz \
		--disable-xcb \
		--disable-xlib \
		--enable-directfb \
		--program-suffix=-directfb
	touch $@

$(DEPDIR)/cairo: \
$(DEPDIR)/%cairo: $(DEPDIR)/cairo.do_compile
	$(start_build)
	cd $(DIR_cairo) && \
		$(INSTALL_cairo)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_cairo@
	touch $@

#
# libogg
#
BEGIN[[
libogg
  1.2.2
  {PN}-{PV}
  extract:http://downloads.xiph.org/releases/ogg/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libogg = "distribution includes libogg and nothing else"

FILES_libogg = \
/usr/lib/*.so*

$(DEPDIR)/libogg.do_prepare: bootstrap $(DEPENDS_libogg)
	$(PREPARE_libogg)
	touch $@

$(DEPDIR)/libogg.do_compile: $(DEPDIR)/libogg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libogg) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/libogg: \
$(DEPDIR)/%libogg: $(DEPDIR)/libogg.do_compile
	$(start_build)
	cd $(DIR_libogg) && \
		$(INSTALL_libogg)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libogg@
	touch $@

#
# libflac
#
BEGIN[[
libflac
  1.2.1
  flac-{PV}
  extract:http://ignum.dl.sourceforge.net/project/flac/flac-src/flac-{PV}-src/flac-{PV}.tar.gz
  patch:file://flac-{PV}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libflac = "libflac is Open Source lossless audio codec"

FILES_libflac = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/libflac.do_prepare: bootstrap $(DEPENDS_libflac)
	$(PREPARE_libflac)
	touch $@

$(DEPDIR)/libflac.do_compile: $(DEPDIR)/libflac.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libflac) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-ogg \
		--disable-oggtest \
		--disable-id3libtest \
		--disable-asm-optimizations \
		--disable-doxygen-docs \
		--disable-xmms-plugin \
		--without-xmms-prefix \
		--without-xmms-exec-prefix \
		--without-libiconv-prefix \
		--without-id3lib \
		--with-ogg-includes=. \
		--disable-cpplibs
	touch $@

$(DEPDIR)/libflac: \
$(DEPDIR)/%libflac: $(DEPDIR)/libflac.do_compile
	$(start_build)
	cd $(DIR_libflac) && \
		$(INSTALL_libflac)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libflac@
	touch $@


##############################   PYTHON   #####################################

#
# elementtree
#
BEGIN[[
elementtree
  1.2.6-20050316
  {PN}-{PV}
  extract:http://effbot.org/media/downloads/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_elementtree = "Provides light-weight components for working with XML"
FILES_elementtree = \
$(PYTHON_DIR)

$(DEPDIR)/elementtree.do_prepare: bootstrap $(DEPENDS_elementtree)
	$(PREPARE_elementtree)
	touch $@

$(DEPDIR)/elementtree.do_compile: $(DEPDIR)/elementtree.do_prepare
	touch $@

$(DEPDIR)/elementtree: \
$(DEPDIR)/%elementtree: $(DEPDIR)/elementtree.do_compile
	$(start_build)
	cd $(DIR_elementtree) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_elementtree@
	$(tocdk_build)
	$(remove_pyo)
	$(toflash_build)
	touch $@

#
# libxml2
#
BEGIN[[
libxml2
  2.9.0
  {PN}-{PV}
  extract:http://xmlsoft.org/sources/{PN}-{PV}.tar.gz
  patch:file://{PN}-{PV}.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxml2 = "XML parsing library, version 2"
FILES_libxml2 = \
/usr/lib/libxml2* \
$(PYTHON_DIR)/site-packages/*libxml2.py

$(DEPDIR)/libxml2.do_prepare: bootstrap $(DEPENDS_libxml2)
	$(PREPARE_libxml2)
	touch $@

$(DEPDIR)/libxml2.do_compile: $(DEPDIR)/libxml2.do_prepare
	cd $(DIR_libxml2) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-python=$(crossprefix)/bin \
			--without-c14n \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/libxml2: \
$(DEPDIR)/%libxml2: $(DEPDIR)/libxml2.do_compile
	$(start_build)
	cd $(DIR_libxml2) && \
		$(INSTALL_libxml2) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config && \
		chmod 755 $(crossprefix)/bin/xml2-config
	$(tocdk_build_start)
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(ipkgbuilddir)/libxml2/usr/lib/xml2Conf.sh
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(ipkgbuilddir)/libxml2/usr/lib/xml2Conf.sh
	$(call do_build_pkg,install,cdk)
	$(toflash_build)
#	@DISTCLEANUP_libxml2@
	touch $@

#
# libxslt
#
BEGIN[[
libxslt
  1.1.28
  {PN}-{PV}
  extract:http://xmlsoft.org/sources/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libxslt = "XML stylesheet transformation library"
FILES_libxslt = \
/usr/lib/libxslt* \
/usr/lib/libexslt* \
$(PYTHON_DIR)/site-packages/libxslt.py

$(DEPDIR)/libxslt.do_prepare: bootstrap libxml2 $(DEPENDS_libxslt)
	$(PREPARE_libxslt)
	touch $@

$(DEPDIR)/libxslt.do_compile: $(DEPDIR)/libxslt.do_prepare
	cd $(DIR_libxslt) && \
		$(BUILDENV) \
		./configure \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2 -Os" \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libxml-prefix="$(crossprefix)" \
			--with-libxml-include-prefix="$(targetprefix)/usr/include" \
			--with-libxml-libs-prefix="$(targetprefix)/usr/lib" \
			--with-python=$(crossprefix)/bin \
			--without-crypto \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxslt: \
$(DEPDIR)/%libxslt: %libxml2 libxslt.do_compile
	$(start_build)
	cd $(DIR_libxslt) && \
		$(INSTALL_libxslt) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config
	$(tocdk_build_start)
	sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(ipkgbuilddir)/libxslt/usr/lib/xsltConf.sh
	sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(ipkgbuilddir)/libxslt/usr/lib/xsltConf.sh
	$(call do_build_pkg,install,cdk)
	$(toflash_build)
#	@DISTCLEANUP_libxslt@
	touch $@

#
# lxml
#
BEGIN[[
lxml
  2.2.8
  {PN}-{PV}
  extract:http://launchpad.net/{PN}/2.2/{PV}/+download/{PN}-{PV}.tgz
;
]]END

DESCRIPTION_lxml = "Python binding for the libxml2 and libxslt libraries"
FILES_lxml = \
$(PYTHON_DIR)

$(DEPDIR)/lxml.do_prepare: bootstrap python $(DEPENDS_lxml)
	$(PREPARE_lxml)
	touch $@

$(DEPDIR)/lxml.do_compile: $(DEPDIR)/lxml.do_prepare
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/lxml: \
$(DEPDIR)/%lxml: $(DEPDIR)/lxml.do_compile
	$(start_build)
	cd $(DIR_lxml) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_lxml@
	$(tocdk_build)
	$(remove_pyo)
	$(extra_build)
	touch $@

#
# setuptools
#
BEGIN[[
setuptools
  0.6c11
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/s/{PN}/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_setuptools = "setuptools"

FILES_setuptools = \
$(PYTHON_DIR)/site-packages/*.py \
$(PYTHON_DIR)/site-packages/*.pyo \
$(PYTHON_DIR)/site-packages/setuptools/*.py \
$(PYTHON_DIR)/site-packages/setuptools/*.pyo \
$(PYTHON_DIR)/site-packages/setuptools/command/*.py \
$(PYTHON_DIR)/site-packages/setuptools/command/*.pyo

$(DEPDIR)/setuptools.do_prepare: bootstrap $(DEPENDS_setuptools)
	$(PREPARE_setuptools)
	touch $@

$(DEPDIR)/setuptools.do_compile: $(DEPDIR)/setuptools.do_prepare
	cd $(DIR_setuptools) && \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/setuptools: \
$(DEPDIR)/%setuptools: $(DEPDIR)/setuptools.do_compile
	$(start_build)
	cd $(DIR_setuptools) && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
#	@DISTCLEANUP_setuptools@
	touch $@

#
# gdata
#
BEGIN[[
gdata
  2.0.17
  gdata-{PV}
  extract:http://gdata-python-client.googlecode.com/files/gdata-{PV}.tar.gz
;
]]END

DESCRIPTION_gdata = "The Google Data APIs (Google Data) provide a simple protocol for reading and writing data on the web. Though it is possible to use these services with a simple HTTP client, this library provides helpful tools to streamline your code and keep up with server-side changes. "
FILES_gdata = \
$(PYTHON_DIR)/site-packages/atom/*.py \
$(PYTHON_DIR)/site-packages/atom/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/*.py \
$(PYTHON_DIR)/site-packages/gdata/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/youtube/*.py \
$(PYTHON_DIR)/site-packages/gdata/youtube/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/geo/*.py \
$(PYTHON_DIR)/site-packages/gdata/geo/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/media/*.py \
$(PYTHON_DIR)/site-packages/gdata/media/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/oauth/*.py \
$(PYTHON_DIR)/site-packages/gdata/oauth/*.pyo \
$(PYTHON_DIR)/site-packages/gdata/tlslite/*.py \
$(PYTHON_DIR)/site-packages/gdata/tlslite/*.pyo

$(DEPDIR)/gdata.do_prepare: bootstrap setuptools $(DEPENDS_gdata)
	$(PREPARE_gdata)
	touch $@

$(DEPDIR)/gdata.do_compile: $(DEPDIR)/gdata.do_prepare
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/gdata: \
$(DEPDIR)/%gdata: $(DEPDIR)/gdata.do_compile
	$(start_build)
	cd $(DIR_gdata) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_gdata@
	$(tocdk_build)
	$(remove_pyo)
	$(e2extra_build)
	touch $@
#
# twisted
#
BEGIN[[
twisted
  13.0.0
  Twisted-{PV}
  extract:http://twistedmatrix.com/Releases/Twisted/13.0/Twisted-{PV}.tar.bz2
;
]]END

DESCRIPTION_twisted = "Asynchronous networking framework written in Python"
FILES_twisted = \
$(PYTHON_DIR)/site-packages/twisted/copyright.* \
$(PYTHON_DIR)/site-packages/twisted/cred \
$(PYTHON_DIR)/site-packages/twisted/im.* \
$(PYTHON_DIR)/site-packages/twisted/__init__.* \
$(PYTHON_DIR)/site-packages/twisted/internet \
$(PYTHON_DIR)/site-packages/twisted/persisted \
$(PYTHON_DIR)/site-packages/twisted/plugin.* \
$(PYTHON_DIR)/site-packages/twisted/plugins \
$(PYTHON_DIR)/site-packages/twisted/protocols \
$(PYTHON_DIR)/site-packages/twisted/python \
$(PYTHON_DIR)/site-packages/twisted/spread \
$(PYTHON_DIR)/site-packages/twisted/_version.py \
$(PYTHON_DIR)/site-packages/twisted/_version.pyo \
$(PYTHON_DIR)/site-packages/twisted/web

$(DEPDIR)/twisted.do_prepare: bootstrap setuptools $(DEPENDS_twisted)
	$(PREPARE_twisted)
	touch $@

$(DEPDIR)/twisted.do_compile: $(DEPDIR)/twisted.do_prepare
	cd $(DIR_twisted) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/twisted: \
$(DEPDIR)/%twisted: $(DEPDIR)/twisted.do_compile
	$(start_build)
	cd $(DIR_twisted) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_twisted@
	$(tocdk_build)
	$(remove_pyo)
	$(toflash_build)
	touch $@

#
# twistedweb2
#
BEGIN[[
twistedweb2
  8.1.0
  TwistedWeb2-{PV}
  extract:http://twistedmatrix.com/Releases/Web2/8.1/TwistedWeb2-{PV}.tar.bz2
;
]]END

DESCRIPTION_twistedweb2 = "twistedweb2"

FILES_twistedweb2 = \
$(PYTHON_DIR)/site-packages/twisted/*.py \
$(PYTHON_DIR)/site-packages/twisted/*.pyo \
$(PYTHON_DIR)/site-packages/twisted/web2 \
$(PYTHON_DIR)/site-packages/twisted/plugins  

$(DEPDIR)/twistedweb2.do_prepare: bootstrap setuptools $(DEPENDS_twistedweb2)
	$(PREPARE_twistedweb2)
	touch $@

$(DEPDIR)/twistedweb2.do_compile: $(DEPDIR)/twistedweb2.do_prepare
	cd $(DIR_twistedweb2) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/twistedweb2: \
$(DEPDIR)/%twistedweb2: $(DEPDIR)/twistedweb2.do_compile
	$(start_build)
	cd $(DIR_twistedweb2) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_twistedweb2@
	touch $@

#
# pilimaging
#
BEGIN[[
pilimaging
  1.1.7
  Imaging-{PV}
  extract:http://effbot.org/downloads/Imaging-{PV}.tar.gz
  patch:file://pilimaging-fix-search-paths.patch
;
]]END

DESCRIPTION_pilimaging = "pilimaging"
FILES_pilimaging = \
$(PYTHON_DIR)/site-packages \
/usr/bin/*

$(DEPDIR)/pilimaging: bootstrap python $(DEPENDS_pilimaging)
	$(PREPARE_pilimaging)
	$(start_build)
	cd $(DIR_pilimaging) && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build && \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr && \
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pilimaging@
	touch $@

#
# pycrypto
#
BEGIN[[
pycrypto
  2.5
  {PN}-{PV}
  extract:http://ftp.dlitz.net/pub/dlitz/crypto/{PN}/{PN}-{PV}.tar.gz
  patch:file://python-{PN}-no-usr-include.patch
;
]]END

DESCRIPTION_pycrypto = pycrypto
FILES_pycrypto = \
$(PYTHON_DIR)/site-packages/Crypto/*


$(DEPDIR)/pycrypto.do_prepare: bootstrap setuptools $(DEPENDS_pycrypto)
	$(PREPARE_pycrypto)
	touch $@

$(DEPDIR)/pycrypto.do_compile: $(DEPDIR)/pycrypto.do_prepare
	cd $(DIR_pycrypto) && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr
	touch $@

$(DEPDIR)/pycrypto: \
$(DEPDIR)/%pycrypto: $(DEPDIR)/pycrypto.do_compile
	$(start_build)
	cd $(DIR_pycrypto) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pycrypto@
	touch $@

#
# pyusb
#
BEGIN[[
pyusb
  1.0.0a3
  {PN}-{PV}
  extract:http://pypi.python.org/packages/source/p/{PN}/{PN}-{PV}.tar.gz
;
]]END

DESCRIPTION_pyusb = pyusb
FILES_pyusb = \
$(PYTHON_DIR)/site-packages/usb/*

$(DEPDIR)/pyusb.do_prepare: bootstrap setuptools $(DEPENDS_pyusb)
	$(PREPARE_pyusb)
	touch $@

$(DEPDIR)/pyusb.do_compile: $(DEPDIR)/pyusb.do_prepare
	cd $(DIR_pyusb) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyusb: \
$(DEPDIR)/%pyusb: $(DEPDIR)/pyusb.do_compile
	$(start_build)
	cd $(DIR_pyusb) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pyusb@
	touch $@

#
# pyopenssl
#
BEGIN[[
pyopenssl
  0.11
  pyOpenSSL-{PV}
  extract:http://launchpad.net/pyopenssl/main/{PV}/+download/pyOpenSSL-{PV}.tar.gz
;
]]END

DESCRIPTION_pyopenssl = "Python wrapper module around the OpenSSL library"
FILES_pyopenssl = \
$(PYTHON_DIR)/site-packages/OpenSSL/*py \
$(PYTHON_DIR)/site-packages/OpenSSL/*so

$(DEPDIR)/pyopenssl.do_prepare: bootstrap setuptools $(DEPENDS_pyopenssl)
	$(PREPARE_pyopenssl)
	touch $@

$(DEPDIR)/pyopenssl.do_compile: $(DEPDIR)/pyopenssl.do_prepare
	cd $(DIR_pyopenssl) && \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/python$(PYTHON_VERSION)" \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyopenssl: \
$(DEPDIR)/%pyopenssl: $(DEPDIR)/pyopenssl.do_compile
	$(start_build)
	cd $(DIR_pyopenssl) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_pyopenssl@
	$(tocdk_build)
	$(remove_pyo)
	$(toflash_build)
	touch $@

#
# python
#
BEGIN[[
ifdef ENABLE_PY27
python
  2.7.3
  {PN}-{PV}
  extract:http://www.{PN}.org/ftp/{PN}/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://{PN}_{PV}.diff
  patch:file://{PN}_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://{PN}_{PV}-pgettext.diff
;
else
python
  2.6.6
  {PN}-{PV}
  extract:http://www.{PN}.org/ftp/{PN}/{PV}/Python-{PV}.tar.bz2
  pmove:Python-{PV}:{PN}-{PV}
  patch:file://{PN}_{PV}.diff
  patch:file://{PN}_{PV}-ctypes-libffi-fix-configure.diff
  patch:file://{PN}_{PV}-pgettext.diff
endif
;
]]END

PACKAGES_python = python python_ctypes

DESCRIPTION_python = "A high-level scripting language"
FILES_python = \
/usr/bin/python* \
/usr/lib/libpython$(PYTHON_VERSION).* \
$(PYTHON_DIR)/*.py \
$(PYTHON_DIR)/encodings \
$(PYTHON_DIR)/hotshot \
$(PYTHON_DIR)/idlelib \
$(PYTHON_DIR)/json \
$(PYTHON_DIR)/config \
$(PYTHON_DIR)/lib-dynload \
$(PYTHON_DIR)/lib-tk \
$(PYTHON_DIR)/lib2to3 \
$(PYTHON_DIR)/logging \
$(PYTHON_DIR)/multiprocessing \
$(PYTHON_DIR)/sqlite3 \
$(PYTHON_DIR)/wsgiref \
$(PYTHON_DIR)/xml \
$(PYTHON_DIR)/plat-linux2 \
/usr/include/python$(PYTHON_VERSION)/pyconfig.h \
$(PYTHON_DIR)/plat-linux3


DESCRIPTION_python_ctypes = python ctypes module
FILES_python_ctypes = \
$(PYTHON_DIR)/ctypes

$(DEPDIR)/python.do_prepare: bootstrap host_python openssl-dev sqlite $(DEPENDS_python)
	$(PREPARE_python)
	touch $@

$(DEPDIR)/python.do_compile: $(DEPDIR)/python.do_prepare
	( cd $(DIR_python) && \
		CONFIG_SITE= \
		$(BUILDENV) \
		autoreconf -Wcross --verbose --install --force Modules/_ctypes/libffi && \
		autoconf && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--disable-ipv6 \
			--without-cxx-main \
			--with-threads \
			--with-pymalloc \
			--with-signal-module \
			--with-wctype-functions \
			HOSTPYTHON=$(crossprefix)/bin/python \
			OPT="$(TARGET_CFLAGS)" && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			PYTHON_MODULES_INCLUDE="$(prefix)/$*cdkroot/usr/include" \
			PYTHON_MODULES_LIB="$(prefix)/$*cdkroot/usr/lib" \
			CROSS_COMPILE_TARGET=yes \
			CROSS_COMPILE=$(target) \
			HOSTARCH=sh4-linux \
			CFLAGS="$(TARGET_CFLAGS) -fno-inline" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			all ) && \
	touch $@

$(DEPDIR)/python: \
$(DEPDIR)/%python: $(DEPDIR)/python.do_compile
	$(start_build)
	( cd $(DIR_python) && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			install DESTDIR=$(PKDIR) ) && \
	$(LN_SF) ../../libpython$(PYTHON_VERSION).so.1.0 $(PKDIR)$(PYTHON_DIR)/config/libpython$(PYTHON_VERSION).so
	$(LN_SF) $(PKDIR)$(PYTHON_INCLUDE_DIR) $(PKDIR)/usr/include/python
#	@DISTCLEANUP_python@
	$(tocdk_build)
	$(remove_pyc)
	$(toflash_build)
	touch $@

#
# pythonwifi
#
BEGIN[[
pythonwifi
  0.5.0
  python-wifi-{PV}
  extract:http://freefr.dl.sourceforge.net/project/{PN}.berlios/python-wifi-{PV}.tar.bz2
;
]]END

DESCRIPTION_pythonwifi = "pythonwifi"
FILES_pythonwifi =\
$(PYTHON_DIR)/site-packages/pythonwifi

$(DEPDIR)/pythonwifi.do_prepare: bootstrap setuptools $(DEPENDS_pythonwifi)
	$(PREPARE_pythonwifi)
	touch $@

$(DEPDIR)/pythonwifi.do_compile: $(DEPDIR)/pythonwifi.do_prepare
	cd $(DIR_pythonwifi) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythonwifi: \
$(DEPDIR)/%pythonwifi: $(DEPDIR)/pythonwifi.do_compile
	$(start_build)
	cd $(DIR_pythonwifi) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pythonwifi@
	touch $@

#
# pythoncheetah
#
BEGIN[[
pythoncheetah
  2.4.4
  Cheetah-{PV}
  extract:http://pypi.python.org/packages/source/C/Cheetah/Cheetah-{PV}.tar.gz
;
]]END

DESCRIPTION_pythoncheetah = "pythoncheetah"
FILES_pythoncheetah = \
$(PYTHON_DIR)/site-packages/Cheetah

$(DEPDIR)/pythoncheetah.do_prepare: bootstrap setuptools $(DEPENDS_pythoncheetah)
	$(PREPARE_pythoncheetah)
	touch $@

$(DEPDIR)/pythoncheetah.do_compile: $(DEPDIR)/pythoncheetah.do_prepare
	cd $(DIR_pythoncheetah) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythoncheetah: \
$(DEPDIR)/%pythoncheetah: $(DEPDIR)/pythoncheetah.do_compile
	$(start_build)
	cd $(DIR_pythoncheetah) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_pythoncheetah@
	touch $@

#
# zope interface
#
BEGIN[[
zope_interface
  4.0.1
  zope.interface-{PV}
  extract:http://pypi.python.org/packages/source/z/zope.interface/zope.interface-{PV}.tar.gz
;
]]END

DESCRIPTION_zope_interface = "Zope Interfaces for Python2"
FILES_zope_interface = \
$(PYTHON_DIR)

$(DEPDIR)/zope_interface.do_prepare: bootstrap python setuptools $(DEPENDS_zope_interface)
	$(PREPARE_zope_interface)
	touch $@

$(DEPDIR)/zope_interface.do_compile: $(DEPDIR)/zope_interface.do_prepare
	cd $(DIR_zope_interface) && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/zope_interface: \
$(DEPDIR)/%zope_interface: $(DEPDIR)/zope_interface.do_compile
	$(start_build)
	cd $(DIR_zope_interface) && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(PKDIR) --prefix=/usr
#	@DISTCLEANUP_zope_interface@
	$(tocdk_build)
#	$(remove_pyo)
	$(toflash_build)
	touch $@



##############################   GSTREAMER + PLUGINS   #########################

#
# GSTREAMER
#
BEGIN[[
gstreamer
  0.10.36
  {PN}-{PV}
  extract:http://{PN}.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gstreamer = "GStreamer Multimedia Framework"

FILES_gstreamer = \
/usr/bin/gst-* \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstcoreelements.so \
/usr/lib/gstreamer-0.10/libgstcoreindexers.so

$(DEPDIR)/gstreamer.do_prepare: bootstrap glib2 libxml2 $(DEPENDS_gstreamer)
	$(PREPARE_gstreamer)
	touch $@

$(DEPDIR)/gstreamer.do_compile: $(DEPDIR)/gstreamer.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gstreamer) && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-docs-build \
		--disable-dependency-tracking \
		--disable-check \
		ac_cv_func_register_printf_function=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gstreamer: \
$(DEPDIR)/%gstreamer: $(DEPDIR)/gstreamer.do_compile
	$(start_build)
	$(BUILDENV) \
	cd $(DIR_gstreamer) && \
		$(INSTALL_gstreamer)
#	@DISTCLEANUP_gstreamer@
	$(tocdk_build)
	sh4-linux-strip --strip-unneeded $(PKDIR)/usr/bin/gst-launch*
	$(toflash_build)
	touch $@
	

#
# GST-PLUGINS-BASE
#
BEGIN[[
gst_plugins_base
  0.10.36
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_base = "GStreamer Multimedia Framework base plugins"

FILES_gst_plugins_base = \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstalsa.so \
/usr/lib/gstreamer-0.10/libgstapp.so \
/usr/lib/gstreamer-0.10/libgstaudioconvert.so \
/usr/lib/gstreamer-0.10/libgstaudioresample.so \
/usr/lib/gstreamer-0.10/libgstdecodebin.so \
/usr/lib/gstreamer-0.10/libgstdecodebin2.so \
/usr/lib/gstreamer-0.10/libgstogg.so \
/usr/lib/gstreamer-0.10/libgstplaybin.so \
/usr/lib/gstreamer-0.10/libgstsubparse.so \
/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so

$(DEPDIR)/gst_plugins_base.do_prepare: bootstrap glib2 gstreamer libogg libalsa libvorbis $(DEPENDS_gst_plugins_base)
	$(PREPARE_gst_plugins_base)
	touch $@

$(DEPDIR)/gst_plugins_base.do_compile: $(DEPDIR)/gst_plugins_base.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_base) && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-theora \
		--disable-gnome_vfs \
		--disable-pango \
		--disable-x \
		--disable-examples \
		--with-audioresample-format=int && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_base: \
$(DEPDIR)/%gst_plugins_base: $(DEPDIR)/gst_plugins_base.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_base) && \
		$(BUILDENV) \
		$(INSTALL_gst_plugins_base)
#	@DISTCLEANUP_gst_plugins_base@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-GOOD
#
BEGIN[[
gst_plugins_good
  0.10.31
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.29_avidemux_only_send_pts_on_keyframe.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_good = "GStreamer Multimedia Framework good plugins"

FILES_gst_plugins_good = \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstaudioparsers.so \
/usr/lib/gstreamer-0.10/libgstautodetect.so \
/usr/lib/gstreamer-0.10/libgstavi.so \
/usr/lib/gstreamer-0.10/libgstflac.so \
/usr/lib/gstreamer-0.10/libgstflv.so \
/usr/lib/gstreamer-0.10/libgsticydemux.so \
/usr/lib/gstreamer-0.10/libgstid3demux.so \
/usr/lib/gstreamer-0.10/libgstmatroska.so \
/usr/lib/gstreamer-0.10/libgstrtp.so \
/usr/lib/gstreamer-0.10/libgstrtpmanager.so \
/usr/lib/gstreamer-0.10/libgstrtsp.so \
/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so \
/usr/lib/gstreamer-0.10/libgstudp.so \
/usr/lib/gstreamer-0.10/libgstapetag.so \
/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so \
/usr/lib/gstreamer-0.10/libgstisomp4.so \
/usr/lib/gstreamer-0.10/libgstwavparse.so

$(DEPDIR)/gst_plugins_good.do_prepare: bootstrap gstreamer gst_plugins_base libsoup libflac $(DEPENDS_gst_plugins_good)
	$(PREPARE_gst_plugins_good)
	touch $@

$(DEPDIR)/gst_plugins_good.do_compile: $(DEPDIR)/gst_plugins_good.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_good) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-esd \
		--disable-aalib \
		--disable-esdtest \
		--disable-aalib \
		--disable-shout2 \
		--disable-shout2test \
		--disable-x  && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_good: \
$(DEPDIR)/%gst_plugins_good: $(DEPDIR)/gst_plugins_good.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_good) && \
		$(INSTALL_gst_plugins_good)
#	@DISTCLEANUP_gst_plugins_good@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-BAD
#
BEGIN[[
gst_plugins_bad
  0.10.23
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.22-mpegtsdemux_remove_bluray_pgs_detection.diff
  patch:file://{PN}-0.10.22-mpegtsdemux_speedup.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_bad = "GStreamer Multimedia Framework bad plugins"

FILES_gst_plugins_bad = \
/usr/lib/libgst* \
/usr/lib/gstreamer-0.10/libgstassrender.so \
/usr/lib/gstreamer-0.10/libgstcdxaparse.so \
/usr/lib/gstreamer-0.10/libgstfragmented.so \
/usr/lib/gstreamer-0.10/libgstmpegdemux.so \
/usr/lib/gstreamer-0.10/libgstvcdsrc.so \
/usr/lib/gstreamer-0.10/libgstmpeg4videoparse.so \
/usr/lib/gstreamer-0.10/libgsth264parse.so \
/usr/lib/gstreamer-0.10/libgstneonhttpsrc.so \
/usr/lib/gstreamer-0.10/libgstrtmp.so

$(DEPDIR)/gst_plugins_bad.do_prepare: bootstrap gstreamer gst_plugins_base libmodplug $(DEPENDS_gst_plugins_bad)
	$(PREPARE_gst_plugins_bad)
	touch $@

$(DEPDIR)/gst_plugins_bad.do_compile: $(DEPDIR)/gst_plugins_bad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_bad) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no \
		--disable-sdl \
		--disable-modplug \
		ac_cv_openssldir=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_bad: \
$(DEPDIR)/%gst_plugins_bad: $(DEPDIR)/gst_plugins_bad.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_bad) && \
		$(INSTALL_gst_plugins_bad)
#	@DISTCLEANUP_gst_plugins_bad@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-UGLY
#
BEGIN[[
gst_plugins_ugly
  0.10.19
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_ugly = "GStreamer Multimedia Framework ugly plugins"

FILES_gst_plugins_ugly = \
/usr/lib/gstreamer-0.10/libgstasf.so \
/usr/lib/gstreamer-0.10/libgstdvdsub.so \
/usr/lib/gstreamer-0.10/libgstmad.so \
/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so \
/usr/lib/gstreamer-0.10/libgstmpegstream.so

$(DEPDIR)/gst_plugins_ugly.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_plugins_ugly)
	$(PREPARE_gst_plugins_ugly)
	touch $@

$(DEPDIR)/gst_plugins_ugly.do_compile: $(DEPDIR)/gst_plugins_ugly.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_ugly) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-mpeg2dec && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_ugly: \
$(DEPDIR)/%gst_plugins_ugly: $(DEPDIR)/gst_plugins_ugly.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_ugly) && \
		$(INSTALL_gst_plugins_ugly)
#	@DISTCLEANUP_gst_plugins_ugly@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-FFMPEG
#
BEGIN[[
gst_ffmpeg
  0.10.13
  {PN}-{PV}
  extract:http://gstreamer.freedesktop.org/src/{PN}/{PN}-{PV}.tar.bz2
  patch:file://{PN}-0.10.12_lower_rank.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_ffmpeg = "GStreamer Multimedia Framework ffmpeg module"

FILES_gst_ffmpeg = \
/usr/lib/gstreamer-0.10/libgstffmpeg.so \
/usr/lib/gstreamer-0.10/libgstffmpegscale.so \
/usr/lib/gstreamer-0.10/libgstpostproc.so

$(DEPDIR)/gst_ffmpeg.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_ffmpeg)
	$(PREPARE_gst_ffmpeg)
	touch $@

$(DEPDIR)/gst_ffmpeg.do_compile: $(DEPDIR)/gst_ffmpeg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_ffmpeg) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		\
		--with-ffmpeg-extra-configure=" \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffmpeg \
		--disable-ffprobe \
		--enable-postproc \
		--enable-gpl \
		--enable-static \
		--enable-pic \
		--disable-protocols \
		--disable-devices \
		--disable-network \
		--disable-hwaccels \
		--disable-filters \
		--disable-doc \
		--enable-optimizations \
		--enable-cross-compile \
		--target-os=linux \
		--arch=sh4 \
		--cross-prefix=$(target)- \
		\
		--disable-muxers \
		--disable-encoders \
		--disable-decoders \
		--enable-decoder=ogg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		\
		--disable-demuxers \
		--enable-demuxer=ogg \
		--enable-demuxer=vorbis \
		--enable-demuxer=flac \
		--enable-demuxer=mpegts \
		\
		--disable-bsfs \
		--enable-pthreads \
		--enable-bzlib"
	touch $@

$(DEPDIR)/gst_ffmpeg: \
$(DEPDIR)/%gst_ffmpeg: $(DEPDIR)/gst_ffmpeg.do_compile
	$(start_build)
	cd $(DIR_gst_ffmpeg) && \
		$(INSTALL_gst_ffmpeg)
#	@DISTCLEANUP_gst_ffmpeg@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# GST-PLUGINS-FLUENDO-MPEGDEMUX
#
BEGIN[[
gst_plugins_fluendo_mpegdemux
  0.10.71
  gst-fluendo-mpegdemux-{PV}
  extract:http://core.fluendo.com/gstreamer/src/gst-fluendo-mpegdemux/gst-fluendo-mpegdemux-{PV}.tar.gz
  patch:file://{PN}-0.10.69-add_dts_hd_detection.diff
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_fluendo_mpegdemux = "GStreamer Multimedia Framework fluendo"
FILES_gst_plugins_fluendo_mpegdemux = \
/usr/lib/gstreamer-0.10/*.so


$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare: bootstrap gstreamer gst_plugins_base $(DEPENDS_gst_plugins_fluendo_mpegdemux)
	$(PREPARE_gst_plugins_fluendo_mpegdemux)
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_fluendo_mpegdemux) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux: \
$(DEPDIR)/%gst_plugins_fluendo_mpegdemux: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile
	$(start_build)
	cd $(DIR_gst_plugins_fluendo_mpegdemux) && \
		$(INSTALL_gst_plugins_fluendo_mpegdemux)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_gst_plugins_fluendo_mpegdemux@
	touch $@

#
# GST-PLUGIN-SUBSINK
#
BEGIN[[
gst_plugin_subsink
  git
  {PN}
  nothing:git://openpli.git.sourceforge.net/gitroot/openpli/gstsubsink:r=8182abe751364f6eb1ed45377b0625102aeb68d5
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugin_subsink = GStreamer Multimedia Framework gstsubsink
PKGR_gst_plugin_subsink = r1
FILES_gst_plugin_subsink = \
/usr/lib/gstreamer-0.10/*.so

$(DEPDIR)/gst_plugin_subsink.do_prepare: bootstrap gstreamer gst_ffmpeg gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugins_fluendo_mpegdemux $(DEPENDS_gst_plugin_subsink)
	$(PREPARE_gst_plugin_subsink)
	touch $@

$(DEPDIR)/gst_plugin_subsink.do_compile: $(DEPDIR)/gst_plugin_subsink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugin_subsink) && \
	touch NEWS README AUTHORS ChangeLog && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	autoheader && \
	autoconf && \
	automake --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugin_subsink: \
$(DEPDIR)/%gst_plugin_subsink: $(DEPDIR)/gst_plugin_subsink.do_compile
	$(start_build)
	cd $(DIR_gst_plugin_subsink) && \
		$(INSTALL_gst_plugin_subsink)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_gst_plugin_subsink@
	touch $@

#
# GST-PLUGINS-DVBMEDIASINK
#
BEGIN[[
gst_plugins_dvbmediasink
  git
  {PN}-{PV}
  plink:$(appsdir)/misc/tools/{PN}:{PN}-{PV}
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_gst_plugins_dvbmediasink = "GStreamer Multimedia Framework dvbmediasink"
SRC_URI_gst_plugins_dvbmediasink = "https://code.google.com/p/tdt-amiko/"

FILES_gst_plugins_dvbmediasink = \
/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so \
/usr/lib/gstreamer-0.10/libgstdvbvideosink.so

$(DEPDIR)/gst_plugins_dvbmediasink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugin_subsink $(DEPENDS_gst_plugins_dvbmediasink)
	$(PREPARE_gst_plugins_dvbmediasink)
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink.do_compile: $(DEPDIR)/gst_plugins_dvbmediasink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gst_plugins_dvbmediasink) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink: \
$(DEPDIR)/%gst_plugins_dvbmediasink: $(DEPDIR)/gst_plugins_dvbmediasink.do_compile
	$(start_build)
	$(get_git_version)
	cd $(DIR_gst_plugins_dvbmediasink) && \
		$(INSTALL_gst_plugins_dvbmediasink)
#	@DISTCLEANUP_gst_plugins_dvbmediasink@
	$(tocdk_build)
	$(toflash_build)
	touch $@



##############################   EXTERNAL_LCD   ################################

#
# libusb
#
BEGIN[[
libusb
  0.1.12
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libusb = "libusb is a library which allows userspace application access to USB devices."

FILES_libusb = \
/usr/lib/libusb* \
/usr/lib/libusbpp*

$(DEPDIR)/libusb.do_prepare: $(DEPENDS_libusb)
	$(PREPARE_libusb)
	touch $@

$(DEPDIR)/libusb.do_compile: $(DEPDIR)/libusb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libusb) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--disable-build-docs \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libusb: \
$(DEPDIR)/%libusb: $(DEPDIR)/libusb.do_compile
	$(start_build)
	cd $(DIR_libusb) && \
		$(INSTALL_libusb)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libusb@
	touch $@

#
# graphlcd
#
BEGIN[[
graphlcd
  git
  {PN}-{PV}
  nothing:git://projects.vdr-developer.org/{PN}-base.git:r=281feef328f8e3772f7a0dde0a90c3a5260c334d:b=touchcol
  patch:file://{PN}.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_graphlcd = "Driver and Tools for LCD4LINUX"
PKGR_graphlcd =r1
FILES_graphlcd = \
/usr/bin/* \
/usr/lib/libglcddrivers* \
/usr/lib/libglcdgraphics* \
/usr/lib/libglcdskin* \
/etc/graphlcd.conf

$(DEPDIR)/graphlcd.do_prepare: bootstrap libusb $(DEPENDS_graphlcd)
	$(PREPARE_graphlcd)
	touch $@

$(DEPDIR)/graphlcd.do_compile: $(DEPDIR)/graphlcd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_graphlcd) && \
	$(BUILDENV) \
		$(MAKE) all
	touch $@

$(DEPDIR)/graphlcd: \
$(DEPDIR)/%graphlcd: $(DEPDIR)/graphlcd.do_compile
	$(start_build)
	install -d $(PKDIR)/etc
	cd $(DIR_graphlcd) && \
		$(INSTALL_graphlcd)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_graphlcd@
	touch $@

##############################   LCD4LINUX   ###################################

#
#
# libgd2
#
BEGIN[[
libgd2
  2.0.35
  gd-{PV}
  extract:http://www.chipsnbytes.net/downloads/gd-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libgd2 = "A graphics library for fast image creation"

FILES_libgd2 = \
/usr/lib/libgd* \
/usr/bin/*

$(DEPDIR)/libgd2.do_prepare: bootstrap libz libpng jpeg libiconv freetype fontconfig $(DEPENDS_libgd2)
	$(PREPARE_libgd2)
	touch $@

$(DEPDIR)/libgd2.do_compile: $(DEPDIR)/libgd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libgd2) && \
	chmod +w configure && \
	libtoolize -f -c && \
	autoreconf --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)

$(DEPDIR)/libgd2: \
$(DEPDIR)/%libgd2: $(DEPDIR)/libgd2.do_compile
	$(start_build)
	cd $(DIR_libgd2) && \
		$(INSTALL_libgd2)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libgd2@
	touch $@

#
# libusb2
#
BEGIN[[
libusb2
  1.0.8
  libusb-{PV}
  extract:http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-{PV}/libusb-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libusb2 = "libusb2"
FILES_libusb2 = \
/usr/lib/*.so*

$(DEPDIR)/libusb2.do_prepare: bootstrap $(DEPENDS_libusb2)
	$(PREPARE_libusb2)
	touch $@

$(DEPDIR)/libusb2.do_compile: $(DEPDIR)/libusb2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libusb2) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all

$(DEPDIR)/libusb2: \
$(DEPDIR)/%libusb2: $(DEPDIR)/libusb2.do_compile
	$(start_build)
	cd $(DIR_libusb2) && \
		$(INSTALL_libusb2)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libusb2@
	touch $@

#
# libusbcompat
#
BEGIN[[
libusbcompat
  0.1.3
  libusb-compat-{PV}
  extract:http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-{PV}/libusb-compat-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libusbcompat = "A compatibility layer allowing applications written for libusb-0.1 to work with libusb-1.0"
FILES_libusbcompat = \
/usr/lib/*.so*

$(DEPDIR)/libusbcompat.do_prepare: bootstrap libusb2 $(DEPENDS_libusbcompat)
	$(PREPARE_libusbcompat)
	touch $@

$(DEPDIR)/libusbcompat.do_compile: $(DEPDIR)/libusbcompat.do_prepare
	cd $(DIR_libusbcompat) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)

$(DEPDIR)/libusbcompat: \
$(DEPDIR)/%libusbcompat: $(DEPDIR)/libusbcompat.do_compile
	$(start_build)
	cd $(DIR_libusbcompat) && \
		$(INSTALL_libusbcompat)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libusbcompat@
	touch $@

##############################   END EXTERNAL_LCD   #############################


#
# eve-browser
#
BEGIN[[
evebrowser
  svn
  {PN}-{PV}
  svn://eve-browser.googlecode.com/svn/trunk/
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_evebrowser = evebrowser for HbbTv
#RDEPENDS_evebrowser = webkitdfb
FILES_evebrowser = \
/usr/lib/*.so* \
/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-sh4 \
/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/*.py

$(DEPDIR)/evebrowser.do_prepare: bootstrap $(DEPENDS_evebrowser)
	$(PREPARE_evebrowser)
	touch $@

$(DEPDIR)/evebrowser.do_compile: $(DEPDIR)/evebrowser.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_evebrowser) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/evebrowser: \
$(DEPDIR)/%evebrowser: $(DEPDIR)/evebrowser.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/ && \
	cd $(DIR_evebrowser) && \
		$(INSTALL_evebrowser) && \
		cp -ar enigma2/HbbTv $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/ && \
		rm -r $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-mipsel && \
		rm -r $(PKDIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/HbbTv/bin/hbbtvscan-powerpc && \
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_evebrowser@
	touch $@

#
# brofs
#
BEGIN[[
brofs
  1.2
  BroFS{PV}
  extract:http://www.avalpa.com/assets/freesoft/other/BroFS{PV}.tgz
  make:install:prefix=/usr/bin:DESTDIR=PKDIR
;
]]END

DESCRIPTION_brofs = "BROFS (BroadcastReadOnlyFileSystem)"
FILES_brofs = \
/usr/bin/*

$(DEPDIR)/brofs.do_prepare: bootstrap $(DEPENDS_brofs)
	$(PREPARE_brofs)
	touch $@

$(DEPDIR)/brofs.do_compile: $(DEPDIR)/brofs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_brofs) && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/brofs: \
$(DEPDIR)/%brofs: $(DEPDIR)/brofs.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/usr/bin/
	cd $(DIR_brofs) && \
		$(INSTALL_brofs)
		mv -b $(PKDIR)/BroFS $(PKDIR)/usr/bin/ && \
		mv -b $(PKDIR)/BroFSCommand $(PKDIR)/usr/bin/ && \
		rm -r $(PKDIR)/BroFSd && \
		cd $(PKDIR)/usr/bin/ && \
		ln -sf BroFS BroFSd && \
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_brofs@
	touch $@

#
# libcap
#
BEGIN[[
libcap
  2.22
  {PN}-{PV}
  extract:http://mirror.linux.org.au/linux/libs/security/linux-privs/{PN}2/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libcap = "This is a library for getting and setting POSIX"
FILES_libcap = \
/usr/lib/*.so* \
/usr/sbin/*

$(DEPDIR)/libcap.do_prepare: bootstrap $(DEPENDS_libcap)
	$(PREPARE_libcap)
	touch $@

$(DEPDIR)/libcap.do_compile: $(DEPDIR)/libcap.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libcap) && \
	$(MAKE) \
	DESTDIR=$(PKDIR) \
	PREFIX=$(PKDIR)/usr \
	LIBDIR=$(PKDIR)/usr/lib \
	SBINDIR=$(PKDIR)/usr/sbin \
	INCDIR=$(PKDIR)/usr/include \
	BUILD_CC=gcc \
	PAM_CAP=no \
	LIBATTR=no \
	CC=sh4-linux-gcc
	touch $@

$(DEPDIR)/libcap: \
$(DEPDIR)/%libcap: $(DEPDIR)/libcap.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	$(start_build)
	cd $(DIR_libcap) && \
		$(INSTALL_libcap) \
		DESTDIR=$(PKDIR)/ \
		PREFIX=$(PKDIR)/usr \
		LIBDIR=$(PKDIR)/usr/lib \
		SBINDIR=$(PKDIR)/usr/sbin \
		INCDIR=$(PKDIR)/usr/include \
		BUILD_CC=gcc \
		PAM_CAP=no \
		LIBATTR=no \
		CC=sh4-linux-gcc
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libcap@
	touch $@

	
#
# alsa-lib
#
BEGIN[[
libalsa
  1.0.26
  alsa-lib-{PV}
  extract:http://alsa.cybermirror.org/lib/alsa-lib-{PV}.tar.bz2
  #patch:file://alsa-lib-{PV}-soft_float.patch
  make:install:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libalsa = "ALSA library"

FILES_libalsa = \
/usr/lib/libasound*

$(DEPDIR)/libalsa.do_prepare: bootstrap $(DEPENDS_libalsa)
	$(PREPARE_libalsa)
	touch $@

$(DEPDIR)/libalsa.do_compile: $(DEPDIR)/libalsa.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libalsa) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-debug=no \
		--enable-shared=no \
		--enable-static \
		--disable-python && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libalsa: \
$(DEPDIR)/%libalsa: $(DEPDIR)/libalsa.do_compile
	$(start_build)
	cd $(DIR_libalsa) && \
		$(INSTALL_libalsa)
#	@DISTCLEANUP_libalsa@
	$(tocdk_build)
	$(toflash_build)
	touch $@

#
# rtmpdump
#
BEGIN[[
rtmpdump
  2.4
  {PN}-{PV}
  extract:http://{PN}.mplayerhq.hu/download/{PN}-{PV}.tar.gz
  pmove:{PN}:{PN}-{PV}
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
DESCRIPTION_rtmpdump = "rtmpdump is a tool for dumping media content streamed over RTMP."

FILES_rtmpdump = \
/usr/bin/rtmpdump \
/usr/lib/librtmp* \
/usr/sbin/rtmpgw

$(DEPDIR)/rtmpdump.do_prepare: bootstrap openssl openssl-dev libz $(DEPENDS_rtmpdump)
	$(PREPARE_rtmpdump)
	touch $@

$(DEPDIR)/rtmpdump.do_compile: $(DEPDIR)/rtmpdump.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_rtmpdump) && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	$(BUILDENV) \
		make CROSS_COMPILE=$(target)-
	touch $@

$(DEPDIR)/rtmpdump: \
$(DEPDIR)/%rtmpdump: $(DEPDIR)/rtmpdump.do_compile
	$(start_build)
	cd $(DIR_rtmpdump) && \
		$(INSTALL_rtmpdump)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_rtmpdump@
	touch $@

#
# libdvbsi++
#
BEGIN[[
libdvbsipp
  0.3.6
  libdvbsi++-{PV}
  extract:http://www.saftware.de/libdvbsi++/libdvbsi++-{PV}.tar.bz2
  patch:file://libdvbsi++-{PV}.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
PKGR_libdvbsipp = r0

DESCRIPTION_libdvbsipp = "libdvbsi++ is a open source C++ library for parsing DVB Service Information and MPEG-2 Program Specific Information."

FILES_libdvbsipp = \
/usr/lib/libdvbsi++*

$(DEPDIR)/libdvbsipp.do_prepare: bootstrap $(DEPENDS_libdvbsipp)
	$(PREPARE_libdvbsipp)
	touch $@

$(DEPDIR)/libdvbsipp.do_compile: $(DEPDIR)/libdvbsipp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdvbsipp) && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdvbsipp: \
$(DEPDIR)/%libdvbsipp: $(DEPDIR)/libdvbsipp.do_compile
	$(start_build)
	cd $(DIR_libdvbsipp) && \
		$(INSTALL_libdvbsipp)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdvbsipp@
	touch $@

#
# tuxtxtlib
#
BEGIN[[
tuxtxtlib
  1.0
  libtuxtxt
  nothing:git://git.code.sf.net/p/openpli/tuxtxt:r=4ff8fff:sub=libtuxtxt
  patch:file://libtuxtxt-{PV}-fix_dbox_headers.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_tuxtxtlib = "tuxtxt library"
PKGR_tuxtxtlib = r1
FILES_tuxtxtlib = \
/usr/lib/libtuxtxt*

$(DEPDIR)/tuxtxtlib.do_prepare: bootstrap $(DEPENDS_tuxtxtlib)
	$(PREPARE_tuxtxtlib)
	touch $@

$(DEPDIR)/tuxtxtlib.do_compile: $(DEPDIR)/tuxtxtlib.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tuxtxtlib) && \
	$(BUILDENV) \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	libtoolize --force && \
	automake --foreign --add-missing && \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxtlib: \
$(DEPDIR)/%tuxtxtlib: $(DEPDIR)/tuxtxtlib.do_compile
	$(start_build)
	$(AUTOPKGV_tuxtxtlib)
	cd $(DIR_tuxtxtlib) && \
		$(INSTALL_tuxtxtlib)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_tuxtxtlib@
	touch $@

#
# tuxtxt32bpp
#
BEGIN[[
tuxtxt32bpp
  1.0
  tuxtxt
  nothing:git://git.code.sf.net/p/openpli/tuxtxt:r=4ff8fff:sub=tuxtxt
  patch:file://{PN}-{PV}-fix_dbox_headers.diff
  make:install:prefix=/usr:DESTDIR=PKDIR
# overwrite after make install
  install -m644 -D:file://../root/usr/tuxtxt/tuxtxt2.conf:PKDIR/etc/tuxtxt/tuxtxt2.conf
;
]]END

DESCRIPTION_tuxtxt32bpp = "tuxtxt plugin"
PKGR_tuxtxt32bpp = r2
FILES_tuxtxt32bpp = \
/usr/lib/libtuxtxt32bpp* \
/usr/lib/enigma2/python/Plugins/Extensions/Tuxtxt/* \
/etc/tuxtxt/tuxtxt2.conf

$(DEPDIR)/tuxtxt32bpp.do_prepare: tuxtxtlib $(DEPENDS_tuxtxt32bpp)
	$(PREPARE_tuxtxt32bpp)
	touch $@

$(DEPDIR)/tuxtxt32bpp.do_compile: $(DEPDIR)/tuxtxt32bpp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tuxtxt32bpp) && \
	$(BUILDENV) \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	libtoolize --force && \
	automake --foreign --add-missing && \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxt32bpp: \
$(DEPDIR)/%tuxtxt32bpp: $(DEPDIR)/tuxtxt32bpp.do_compile
	$(start_build)
	$(AUTOPKGV_tuxtxt32bpp)
	cd $(DIR_tuxtxt32bpp) && \
		$(INSTALL_tuxtxt32bpp)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_tuxtxt32bpp@
	touch $@

#
# libdreamdvd
#
BEGIN[[
libdreamdvd
  git
  {PN}
  plink:../apps/misc/tools/{PN}:{PN}
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libdreamdvd = "libdreamdvd"
PKGR_libdreamdvd = r1
FILES_libdreamdvd = \
/usr/lib/libdreamdvd*

SRC_URI_libdreamdvd = "libdreamdvd"

$(DEPDIR)/libdreamdvd.do_prepare: bootstrap $(DEPENDS_libdreamdvd)
	$(PREPARE_libdreamdvd)
	touch $@

$(DEPDIR)/libdreamdvd.do_compile: $(DEPDIR)/libdreamdvd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdreamdvd) && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd: \
$(DEPDIR)/%libdreamdvd: $(DEPDIR)/libdreamdvd.do_compile
	$(start_build)
	cd $(DIR_libdreamdvd) && \
		$(INSTALL_libdreamdvd)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdreamdvd@
	touch $@

#
# libdreamdvd2
#
BEGIN[[
libdreamdvd2
  git
  libdreamdvd
  nothing:git://github.com/mirakels/libdreamdvd.git:r=1bdc2c33f912b9e87cb7e204485a57c6a08a0e8c
  patch:file://libdreamdvd-1.0-support_sh4.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libdreamdvd2 = ""
PKGR_libdreamdvd2 = r1
FILES_libdreamdvd2 = \
/usr/lib/*

$(DEPDIR)/libdreamdvd2.do_prepare: bootstrap $(DEPENDS_libdreamdvd2)
	$(PREPARE_libdreamdvd2)
	touch $@

$(DEPDIR)/libdreamdvd2.do_compile: $(DEPDIR)/libdreamdvd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libdreamdvd2) && \
	autoreconf -i && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd2: \
$(DEPDIR)/%libdreamdvd2: $(DEPDIR)/libdreamdvd2.do_compile
	$(start_build)
	cd $(DIR_libdreamdvd2) && \
		$(INSTALL_libdreamdvd2)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libdreamdvd2@
	touch $@

#
# libmpeg2
#
BEGIN[[
libmpeg2
  0.5.1
  {PN}-{PV}
  extract:http://{PN}.sourceforge.net/files/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmpeg2 = "libmpeg2 is a free library for decoding mpeg-2 and mpeg-1 video streams. It is released under the terms of the GPL license."

FILES_libmpeg2 = \
/usr/lib/libmpeg2.* \
/usr/lib/libmpeg2convert.* \
/usr/bin/*

$(DEPDIR)/libmpeg2.do_prepare: bootstrap $(DEPENDS_libmpeg2)
	$(PREPARE_libmpeg2)
	touch $@

$(DEPDIR)/libmpeg2.do_compile: $(DEPDIR)/libmpeg2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmpeg2) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmpeg2: \
$(DEPDIR)/%libmpeg2: $(DEPDIR)/libmpeg2.do_compile
	$(start_build)
	cd $(DIR_libmpeg2) && \
		$(INSTALL_libmpeg2)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libmpeg2@
	touch $@

#
# libsamplerate
#
BEGIN[[
libsamplerate
  0.1.8
  {PN}-{PV}
  extract:http://www.mega-nerd.com/SRC/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libsamplerate = "libsamplerate (also known as Secret Rabbit Code) is a library for perfroming sample rate conversion of audio data."

FILES_libsamplerate = \
/usr/bin/sndfile-resample \
/usr/lib/libsamplerate.*

$(DEPDIR)/libsamplerate.do_prepare: bootstrap $(DEPENDS_libsamplerate)
	$(PREPARE_libsamplerate)
	touch $@

$(DEPDIR)/libsamplerate.do_compile: $(DEPDIR)/libsamplerate.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libsamplerate) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libsamplerate: \
$(DEPDIR)/%libsamplerate: $(DEPDIR)/libsamplerate.do_compile
	$(start_build)
	cd $(DIR_libsamplerate) && \
		$(INSTALL_libsamplerate)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libsamplerate@
	touch $@

#
# libvorbis
#
BEGIN[[
libvorbis
  1.3.2
  {PN}-{PV}
  extract:http://downloads.xiph.org/releases/vorbis/{PN}-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END
DESCRIPTION_libvorbis = "The libvorbis reference implementation provides both a standard encoder and decoder"

FILES_libvorbis = \
/usr/lib/libvorbis*

$(DEPDIR)/libvorbis.do_prepare: bootstrap $(DEPENDS_libvorbis)
	$(PREPARE_libvorbis)
	touch $@

$(DEPDIR)/libvorbis.do_compile: $(DEPDIR)/libvorbis.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libvorbis) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libvorbis: \
$(DEPDIR)/%libvorbis: $(DEPDIR)/libvorbis.do_compile
	$(start_build)
	cd $(DIR_libvorbis) && \
		$(INSTALL_libvorbis)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libvorbis@
	touch $@

#
# libmodplug
#
BEGIN[[
libmodplug
  0.8.8.4
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/project/modplug-xmms/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmodplug = "the library for decoding mod-like music formats"

FILES_libmodplug = \
/usr/lib/lib*

$(DEPDIR)/libmodplug.do_prepare: bootstrap $(DEPENDS_libmodplug)
	$(PREPARE_libmodplug)
	touch $@

$(DEPDIR)/libmodplug.do_compile: $(DEPDIR)/libmodplug.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmodplug) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmodplug: \
$(DEPDIR)/%libmodplug: $(DEPDIR)/libmodplug.do_compile
	$(start_build)
	cd $(DIR_libmodplug) && \
		$(INSTALL_libmodplug)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libmodplug@
	touch $@

#
# tiff
#
BEGIN[[
tiff
  4.0.1
  {PN}-{PV}
  extract:ftp://ftp.remotesensing.org/pub/lib{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_tiff = "TIFF Software Distribution"

FILES_tiff = \
/usr/lib/libtiff* \
/usr/bin/*

$(DEPDIR)/tiff.do_prepare: bootstrap $(DEPENDS_tiff)
	$(PREPARE_tiff)
	touch $@

$(DEPDIR)/tiff.do_compile: $(DEPDIR)/tiff.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_tiff) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tiff: \
$(DEPDIR)/%tiff: $(DEPDIR)/tiff.do_compile
	$(start_build)
	cd $(DIR_tiff) && \
		$(INSTALL_tiff)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_tiff@
	touch $@

#
# lzo
#
BEGIN[[
lzo
  2.06
  {PN}-{PV}
  extract:http://www.oberhumer.com/opensource/{PN}/download/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_lzo = "LZO -- a real-time data compression library"

FILES_lzo = \
/usr/lib/*

$(DEPDIR)/lzo.do_prepare: $(DEPENDS_lzo)
	$(PREPARE_lzo)
	touch $@

$(DEPDIR)/lzo.do_compile: $(DEPDIR)/lzo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_lzo) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/lzo: \
$(DEPDIR)/%lzo: $(DEPDIR)/lzo.do_compile
	$(start_build)
	cd $(DIR_lzo) && \
		$(INSTALL_lzo)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_lzo@
	touch $@

#
# yajl
#
BEGIN[[
yajl
  2.0.1
  {PN}-{PV}
  nothing:git://github.com/lloyd/{PN}:r=f4b2b1af87483caac60e50e5352fc783d9b2de2d
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_yajl = "Yet Another JSON Library"
PKGR_yajl = r1
FILES_yajl = \
/usr/lib/libyajl.* \
/usr/bin/json*

$(DEPDIR)/yajl.do_prepare: bootstrap $(DEPENDS_yajl)
	$(PREPARE_yajl)
	touch $@

$(DEPDIR)/yajl.do_compile: $(DEPDIR)/yajl.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_yajl) && \
	$(BUILDENV) \
	./configure \
		--prefix=/usr && \
	sed -i "s/install: all/install: distro/g" Makefile && \
	$(MAKE) distro
	touch $@

$(DEPDIR)/yajl: \
$(DEPDIR)/%yajl: $(DEPDIR)/yajl.do_compile
	$(start_build)
	cd $(DIR_yajl) && \
		$(INSTALL_yajl)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_yajl@
	touch $@

#
# libpcre (shouldn't this be named pcre without the lib?)
#
BEGIN[[
libpcre
  8.30
  pcre-{PV}
  extract:ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-{PV}.tar.bz2
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libpcre = "Perl-compatible regular expression library"

FILES_libpcre = \
/usr/lib/* \
/usr/bin/pcre*

$(DEPDIR)/libpcre.do_prepare: bootstrap $(DEPENDS_libpcre)
	$(PREPARE_libpcre)
	touch $@

$(DEPDIR)/libpcre.do_compile: $(DEPDIR)/libpcre.do_prepare
	cd $(DIR_libpcre) && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--enable-utf8 \
		--enable-unicode-properties && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libpcre: \
$(DEPDIR)/%libpcre: $(DEPDIR)/libpcre.do_compile
	$(start_build)
	cd $(DIR_libpcre) && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
		chmod 755 $(crossprefix)/bin/pcre-config && \
		$(INSTALL_libpcre)
		rm -f $(targetprefix)/usr/bin/pcre-config
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libpcre@
	touch $@

#
# libcdio
#
BEGIN[[
libcdio
  0.83
  {PN}-{PV}
  extract:ftp://ftp.gnu.org/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libcdio = "The libcdio package contains a library for CD-ROM and CD image access"

FILES_libcdio = \
/usr/lib/* \
/usr/bin/*

$(DEPDIR)/libcdio.do_prepare: bootstrap $(DEPENDS_libcdio)
	$(PREPARE_libcdio)
	touch $@

$(DEPDIR)/libcdio.do_compile: $(DEPDIR)/libcdio.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libcdio) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libcdio: \
$(DEPDIR)/%libcdio: $(DEPDIR)/libcdio.do_compile
	$(start_build)
	cd $(DIR_libcdio) && \
		$(INSTALL_libcdio)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libcdio@
	touch $@

#
# jasper
#
BEGIN[[
jasper
  1.900.1
  {PN}-{PV}
  extract:http://www.ece.uvic.ca/~frodo/{PN}/software/{PN}-{PV}.zip
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_jasper = "JasPer is a collection \
of software (i.e., a library and application programs) for the coding \
and manipulation of images.  This software can handle image data in a \
variety of formats"

FILES_jasper = \
/usr/bin/* 

$(DEPDIR)/jasper.do_prepare: bootstrap $(DEPENDS_jasper)
	$(PREPARE_jasper)
	touch $@

$(DEPDIR)/jasper.do_compile: $(DEPDIR)/jasper.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_jasper@/@DIR_jasper) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/jasper: \
$(DEPDIR)/%jasper: $(DEPDIR)/jasper.do_compile
	$(start_build)
	cd $(DIR_jasper@/@DIR_jasper) && \
		$(INSTALL_jasper)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_jasper@
	touch $@

#
# mysql
#
BEGIN[[
mysql
  5.1.40
  {PN}-{PV}
  extract:http://downloads.{PN}.com/archives/{PN}-5.1/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_mysql = "MySQL"

FILES_mysql = \
/usr/bin/*

$(DEPDIR)/mysql.do_prepare: bootstrap $(DEPENDS_mysql)
	$(PREPARE_mysql)
	touch $@

$(DEPDIR)/mysql.do_compile: $(DEPDIR)/mysql.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_mysql) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--with-atomic-ops=up --with-embedded-server --prefix=/usr --sysconfdir=/etc/mysql --localstatedir=/var/mysql --disable-dependency-tracking --without-raid --without-debug --with-low-memory --without-query-cache --without-man --without-docs --without-innodb && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mysql: \
$(DEPDIR)/%mysql: $(DEPDIR)/mysql.do_compile
	$(start_build)
	cd $(DIR_mysql) && \
		$(INSTALL_mysql)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_mysql@
	touch $@

#
# xupnpd
#
BEGIN[[
xupnpd
  svn
  {PN}-{PV}
  svn://tsdemuxer.googlecode.com/svn/trunk/xupnpd/src/
  patch-0:file://{PN}.diff
  make:install:DESTDIR=PKDIR
;
]]END


DESCRIPTION_xupnpd = eXtensible UPnP agent
FILES_xupnpd = \
/

$(DEPDIR)/xupnpd.do_prepare: bootstrap $(DEPENDS_xupnpd)
	$(PREPARE_xupnpd)
	touch $@

$(DEPDIR)/xupnpd.do_compile: $(DEPDIR)/xupnpd.do_prepare
	cd $(DIR_xupnpd) && \
	    $(BUILDENV) \
	$(MAKE) embedded
	touch $@

$(DEPDIR)/xupnpd: \
$(DEPDIR)/%xupnpd: $(DEPDIR)/xupnpd.do_compile
	$(start_build)
	cd $(DIR_xupnpd)  && \
	  install -d 0644  $(PKDIR)/{etc,usr/bin}; \
	  install -m 0755 xupnpd- $(PKDIR)/usr/bin/xupnpd; \
	  install -d 0644  $(PKDIR)/usr/share/xupnpd/{ui,www,plugins,config,playlists}; \
	  install -m 0644 *.lua $(PKDIR)/usr/share/xupnpd; \
	  install -m 0644 ui/* $(PKDIR)/usr/share/xupnpd/ui; \
	  install -m 0644 www/* $(PKDIR)/usr/share/xupnpd/www; \
	  install -m 0644 plugins/* $(PKDIR)/usr/share/xupnpd/plugins; \
	  cp -a playlists/*.m3u $(PKDIR)/usr/share/xupnpd/playlists; \
	  $(LN_SF)  /usr/share/xupnpd/xupnpd.lua $(PKDIR)/etc/xupnpd.lua
#	  install -D -m 0755 xupnpd-init.file $(PKDIR)/etc/init.d/xupnpd

	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_xupnpd@
	touch $@
   
#
# libmicrohttpd
#
BEGIN[[
libmicrohttpd
  0.9.19
  {PN}-{PV}
  extract:http://ftp.halifax.rwth-aachen.de/gnu/{PN}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libmicrohttpd = ""

FILES_libmicrohttpd = \
/usr/lib/libmicrohttpd.*

$(DEPDIR)/libmicrohttpd.do_prepare: bootstrap $(DEPENDS_libmicrohttpd)
	$(PREPARE_libmicrohttpd)
	touch $@

$(DEPDIR)/libmicrohttpd.do_compile: $(DEPDIR)/libmicrohttpd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libmicrohttpd) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmicrohttpd: \
$(DEPDIR)/%libmicrohttpd: $(DEPDIR)/libmicrohttpd.do_compile
	$(start_build)
	cd $(DIR_libmicrohttpd) && \
		$(INSTALL_libmicrohttpd)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libmicrohttpd@
	touch $@

#
# libexif
#
BEGIN[[
libexif
  0.6.20
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libexif = "libexif is a library for parsing, editing, and saving EXIF data."

FILES_libexif = \
/usr/lib/libexif.*

$(DEPDIR)/libexif.do_prepare: bootstrap $(DEPENDS_libexif)
	$(PREPARE_libexif)
	touch $@

$(DEPDIR)/libexif.do_compile: $(DEPDIR)/libexif.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_libexif) && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/libexif: \
$(DEPDIR)/%libexif: $(DEPDIR)/libexif.do_compile
	$(start_build)
	cd $(DIR_libexif) && \
		$(INSTALL_libexif)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libexif@
	touch $@

#
# minidlna
#
BEGIN[[
minidlna
  1.0.25
  {PN}-{PV}
  extract:http://netcologne.dl.sourceforge.net/project/{PN}/{PN}/{PV}/{PN}_{PV}_src.tar.gz
  patch:file://{PN}-{PV}.patch
  make:install:prefix=/usr:DESTDIR=PKDIR
;
]]END

DESCRIPTION_minidlna = "The MiniDLNA daemon is an UPnP-A/V and DLNA service which serves multimedia content to compatible clients on the network."

FILES_minidlna = \
/usr/lib/* \
/usr/sbin/*
$(DEPDIR)/minidlna.do_prepare: bootstrap ffmpeg libflac libogg libvorbis libid3tag sqlite libexif jpeg $(DEPENDS_minidlna)
	$(PREPARE_minidlna)
	touch $@

$(DEPDIR)/minidlna.do_compile: $(DEPDIR)/minidlna.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_minidlna) && \
	libtoolize -f -c && \
	$(BUILDENV) \
	DESTDIR=$(prefix)/cdkroot \
	$(MAKE) \
	PREFIX=$(prefix)/cdkroot/usr \
	LIBDIR=$(prefix)/cdkroot/usr/lib \
	SBINDIR=$(prefix)/cdkroot/usr/sbin \
	INCDIR=$(prefix)/cdkroot/usr/include \
	PAM_CAP=no \
	LIBATTR=no
	touch $@

$(DEPDIR)/minidlna: \
$(DEPDIR)/%minidlna: $(DEPDIR)/minidlna.do_compile
	$(start_build)
	cd $(DIR_minidlna) && \
		$(INSTALL_minidlna)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_minidlna@
	touch $@

#
# vlc
#
BEGIN[[
vlc
  1.1.13
  {PN}-{PV}
  extract:http://download.videolan.org/pub/videolan/{PN}/{PV}/{PN}-{PV}.tar.bz2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_vlc = "VLC player"

FILES_vlc = \
/usr/bin/* \
/usr/lib/libvlc* \
/usr/lib/vlc/plugins/access/*.so \
/usr/lib/vlc/plugins/access_output/*.so \
/usr/lib/vlc/plugins/audio_filter/*.so \
/usr/lib/vlc/plugins/audio_mixer/*.so \
/usr/lib/vlc/plugins/audio_output/*.so \
/usr/lib/vlc/plugins/codec/*.so \
/usr/lib/vlc/plugins/control/*.so \
/usr/lib/vlc/plugins/demux/*.so \
/usr/lib/vlc/plugins/gui/*.so \
/usr/lib/vlc/plugins/meta_engine/*.so \
/usr/lib/vlc/plugins/misc/*.so \
/usr/lib/vlc/plugins/mux/*.so \
/usr/lib/vlc/plugins/packetizer/*.so \
/usr/lib/vlc/plugins/services_discovery/*.so \
/usr/lib/vlc/plugins/stream_filter/*.so \
/usr/lib/vlc/plugins/stream_out/*.so \
/usr/lib/vlc/plugins/video_chroma/*.so \
/usr/lib/vlc/plugins/video_filter/*.so \
/usr/lib/vlc/plugins/video_output/*.so \
/usr/lib/vlc/plugins/visualization/*.so

$(DEPDIR)/vlc.do_prepare: bootstrap libstdc++-dev libfribidi ffmpeg $(DEPENDS_vlc)
	$(PREPARE_vlc)
	touch $@

$(DEPDIR)/vlc.do_compile: $(DEPDIR)/vlc.do_prepare
	cd $(DIR_vlc) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--prefix=/usr \
		--disable-xcb \
		--disable-glx \
		--disable-qt4 \
		--disable-mad \
		--disable-postproc \
		--disable-a52 \
		--disable-qt4 \
		--disable-skins2 \
		--disable-remoteosd \
		--disable-lua \
		--disable-libgcrypt \
		--disable-nls \
		--disable-mozilla \
		--disable-dbus \
		--disable-sdl \
		--enable-run-as-root
	touch $@

$(DEPDIR)/vlc: \
$(DEPDIR)/%vlc: $(DEPDIR)/vlc.do_compile
	$(start_build)
	cd $(DIR_vlc) && \
		$(INSTALL_vlc)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_vlc@
	touch $@

#
# djmount
#
BEGIN[[
djmount
  0.71
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_djmount = djmount is a UPnP AV client. It mounts as a Linux filesystem the media content of compatible UPnP AV devices.
RDEPENDS_djmount = fuse
FILES_djmount = \
/usr/bin/* \
/usr/lib/*

$(DEPDIR)/djmount.do_prepare: bootstrap fuse $(DEPENDS_djmount)
	$(PREPARE_djmount)
	touch $@

$(DEPDIR)/djmount.do_compile: $(DEPDIR)/djmount.do_prepare
	cd $(DIR_djmount) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/djmount: \
$(DEPDIR)/%djmount: $(DEPDIR)/djmount.do_compile
	$(start_build)
	cd $(DIR_djmount) && \
		$(INSTALL_djmount)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_djmount@
	touch $@

#
# libupnp
#
BEGIN[[
libupnp
  1.6.17
  {PN}-{PV}
  extract:http://sourceforge.net/projects/upnp/files/latest/download/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libupnp = "The portable SDK for UPnP™ Devices (libupnp) provides developers with an API and open source code for building control points"

FILES_libupnp = \
/usr/lib/*.so*

$(DEPDIR)/libupnp.do_prepare: bootstrap $(DEPENDS_libupnp)
	$(PREPARE_libupnp)
	touch $@

$(DEPDIR)/libupnp.do_compile: $(DEPDIR)/libupnp.do_prepare
	cd $(DIR_libupnp) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libupnp: \
$(DEPDIR)/%libupnp: $(DEPDIR)/libupnp.do_compile
	$(start_build)
	cd $(DIR_libupnp) && \
		$(INSTALL_libupnp)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libupnp@
	touch $@

#
# rarfs
#
BEGIN[[
rarfs
  0.1.1
  {PN}-{PV}
  extract:http://sourceforge.net/projects/{PN}/files/{PN}/{PV}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_rarfs = ""

FILES_rarfs = \
/usr/lib/*.so* \
/usr/bin/*

$(DEPDIR)/rarfs.do_prepare: bootstrap libstdc++-dev fuse $(DEPENDS_rarfs)
	$(PREPARE_rarfs)
	touch $@

$(DEPDIR)/rarfs.do_compile: $(DEPDIR)/rarfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_rarfs) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os -D_FILE_OFFSET_BITS=64" \
	./configure \
		--host=$(target) \
		--disable-option-checking \
		--includedir=/usr/include/fuse \
		--prefix=/usr
	touch $@

$(DEPDIR)/rarfs: \
$(DEPDIR)/%rarfs: $(DEPDIR)/rarfs.do_compile
	$(start_build)
	cd $(DIR_rarfs) && \
		$(INSTALL_rarfs)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_rarfs@
	touch $@

#
# sshfs
#
BEGIN[[
sshfs
  2.4
  {PN}-fuse-{PV}
  extract:http://fossies.org/linux/misc/{PN}-fuse-{PV}.tar.bz2
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/sshfs.do_prepare: bootstrap fuse $(DEPENDS_sshfs)
	$(PREPARE_sshfs)
	touch $@

$(DEPDIR)/sshfs.do_compile: $(DEPDIR)/sshfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_sshfs) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/sshfs: \
$(DEPDIR)/%sshfs: $(DEPDIR)/sshfs.do_compile
	cd $(DIR_sshfs) && \
		$(INSTALL_sshfs)
#	@DISTCLEANUP_sshfs@
	touch $@

#
# gmediarender
#
BEGIN[[
gmediarender
  0.0.6
  {PN}-{PV}
  extract:http://savannah.nongnu.org/download/gmrender/{PN}-{PV}.tar.bz2
  patch:file://{PN}.patch
  make:install:DESTDIR=TARGETS
;
]]END

$(DEPDIR)/gmediarender.do_prepare: bootstrap libstdc++-dev gst_plugins_dvbmediasink libupnp $(DEPENDS_gmediarender)
	$(PREPARE_gmediarender)
	touch $@

$(DEPDIR)/gmediarender.do_compile: $(DEPDIR)/gmediarender.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_gmediarender) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-libupnp=$(targetprefix)/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/gmediarender: \
$(DEPDIR)/%gmediarender: $(DEPDIR)/gmediarender.do_compile
	cd $(DIR_gmediarender) && \
		$(INSTALL_gmediarender)
#	@DISTCLEANUP_gmediarender@
	touch $@
#
# mediatomb
#
BEGIN[[
mediatomb
  0.12.1
  {PN}-{PV}
  extract:http://downloads.sourceforge.net/{PN}/{PN}-{PV}.tar.gz
  patch:file://{PN}_metadata.patch
#  patch:file://{PN}_libav_support.patch
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_mediatomb = MediaTomb is an open source (GPL) UPnP MediaServer with a nice web user interfaces
FILES_mediatomb = \
/usr/bin/* \
/usr/share/mediatomb/*

$(DEPDIR)/mediatomb.do_prepare: bootstrap libstdc++-dev ffmpeg curl sqlite expat $(DEPENDS_mediatomb)
	$(PREPARE_mediatomb)
	touch $@

$(DEPDIR)/mediatomb.do_compile: $(DEPDIR)/mediatomb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(DIR_mediatomb) && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-ffmpegthumbnailer \
		--disable-libmagic \
		--disable-mysql \
		--disable-id3lib \
		--disable-taglib \
		--disable-lastfmlib \
		--disable-libexif \
		--disable-libmp4v2 \
		--disable-inotify \
		--with-avformat-h=$(targetprefix)/usr/include \
		--disable-rpl-malloc \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mediatomb: \
$(DEPDIR)/%mediatomb: $(DEPDIR)/mediatomb.do_compile
	$(start_build)
	cd $(DIR_mediatomb) && \
		$(INSTALL_mediatomb)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_mediatomb@
	touch $@

#
# tinyxml
#
BEGIN[[
tinyxml
  2.6.2
  {PN}-{PV}
  extract:http://ignum.dl.sourceforge.net/project/tinyxml/tinyxml/{PV}/tinyxml_2_6_2.tar.gz
  pmove:{PN}:{PN}-{PV}
  patch:file://{PN}{PV}.patch
  make:install:PREFIX=PKDIR/usr:LD=sh4-linux-ld
;
]]END

DESCRIPTION_tinyxml = tinyxml
FILES_tinyxml = \
/usr/lib/*

$(DEPDIR)/tinyxml.do_prepare: $(DEPENDS_tinyxml)
	$(PREPARE_tinyxml)
	touch $@

$(DEPDIR)/tinyxml.do_compile: $(DEPDIR)/tinyxml.do_prepare
	cd $(DIR_tinyxml) && \
	libtoolize -f -c && \
	$(BUILDENV) \
	$(MAKE)
	touch $@

$(DEPDIR)/tinyxml: \
$(DEPDIR)/%tinyxml: $(DEPDIR)/tinyxml.do_compile
	$(start_build)
	cd $(DIR_tinyxml) && \
		$(INSTALL_tinyxml)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_tinyxml@
	touch $@

#
# libnfs
#
BEGIN[[
libnfs
  git
  {PN}
  git://github.com/sahlberg/libnfs.git:r=c0ebf57b212ffefe83e2a50358499f68e7289e93
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_libnfs = nfs
PKGR_libnfs = r1
FILES_libnfs = \
/usr/lib/*

$(DEPDIR)/libnfs.do_prepare: bootstrap $(DEPENDS_libnfs)
	$(PREPARE_libnfs)
	touch $@

$(DEPDIR)/libnfs.do_compile: $(DEPDIR)/libnfs.do_prepare
	cd $(DIR_libnfs) && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libnfs: \
$(DEPDIR)/%libnfs: $(DEPDIR)/libnfs.do_compile
	$(start_build)
	cd $(DIR_libnfs) && \
		$(INSTALL_libnfs)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_libnfs@
	touch $@

#
# taglib
#
BEGIN[[
taglib
  1.8
  {PN}-{PV}
  extract:https://github.com/downloads/{PN}/{PN}/{PN}-{PV}.tar.gz
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_taglib = taglib
FILES_taglib = \
/usr/*

$(DEPDIR)/taglib.do_prepare: bootstrap $(DEPENDS_taglib)
	$(PREPARE_taglib)
	touch $@

$(DEPDIR)/taglib.do_compile: $(DEPDIR)/taglib.do_prepare
	cd $(DIR_taglib) && \
	$(BUILDENV) \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_RELEASE_TYPE=Release . && \
	$(MAKE) all
	touch $@

$(DEPDIR)/taglib: \
$(DEPDIR)/%taglib: $(DEPDIR)/taglib.do_compile
	$(start_build)
	cd $(DIR_taglib) && \
		$(INSTALL_taglib)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_taglib@
	touch $@

#
# e2-rtmpgw
#
BEGIN[[
e2_rtmpgw
  git
  {PN}
  git://github.com/zakalibit/e2-rtmpgw.git:b=gw-e2
  make:install:DESTDIR=PKDIR
;
]]END

DESCRIPTION_e2_rtmpgw = A toolkit for RTMP streams
PKGR_e2_rtmpgw = r1
FILES_e2_rtmpgw = \
/usr/sbin/rtmpgw2

$(DEPDIR)/e2_rtmpgw.do_prepare: bootstrap openssl openssl-dev libz $(DEPENDS_e2_rtmpgw)
	$(PREPARE_e2_rtmpgw)
	touch $@

$(DEPDIR)/e2_rtmpgw.do_compile: $(DEPDIR)/e2_rtmpgw.do_prepare
	cd $(DIR_e2_rtmpgw) && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/e2_rtmpgw: \
$(DEPDIR)/%e2_rtmpgw: $(DEPDIR)/e2_rtmpgw.do_compile
	$(start_build)
	cd $(DIR_e2_rtmpgw) && \
		$(INSTALL_e2_rtmpgw)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_e2_rtmpgw@
	touch $@
