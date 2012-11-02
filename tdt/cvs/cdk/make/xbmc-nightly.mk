# tuxbox/enigma2

$(DEPDIR)/xbmc-nightly.do_prepare: @DEPENDS_xbmc_nightly@
	@PREPARE_xbmc_nightly@
	touch $@

#			PYTHON_LDFLAGS='-L$(targetprefix)/usr/include/python2.6 -lpython2.6' \
#			PYTHON_VERSION='2.6' \
#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap libboost directfb libstgles libass libmpeg2 libmad jpeg libsamplerate libogg libvorbis libmodplug curl libflac bzip2 tiff lzo libz fontconfig libfribidi freetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink expat sdparm lirc
	cd $(appsdir)/xbmc-nightly && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			PKG_CONFIG_SYSROOT_DIR=$(targetprefix) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PYTHON_SITE_PKG=$(targetprefix)/usr/lib/python2.6/site-packages \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python2.6 \
			PY_PATH=$(targetprefix)/usr \
			--includedir=$(targetprefix)/usr/include \
			--libdir=$(PKDIR)/usr/lib \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
			--enable-webserver \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-nfs \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-libcec \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa

$(DEPDIR)/xbmc-nightly.do_compile: $(appsdir)/xbmc-nightly/config.status
	cd $(appsdir)/xbmc-nightly && \
		$(MAKE) all
	touch $@
DESCRIPTION_xbmc_nightly = xbmc
PKGR_xbmc_nightly =r1
SRC_URI_xbmc_nigtly = git://github.com/xbmc/xbmc.git
FILES_xbmc_nigtly = /usr/lib/xbmc/xbmc.bin

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(start_build)
	$(get_git_version)
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(PKDIR)
	if [ -e $(PKDIR)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(PKDIR)/usr/lib/xbmc/xbmc.bin; \
	fi
	$(tocdk_build)
	$(toflash_build)
	touch $@

xbmc-nightly-clean:
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(appsdir)/xbmc-nightly

