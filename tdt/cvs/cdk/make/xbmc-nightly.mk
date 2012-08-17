# tuxbox/enigma2

$(DEPDIR)/xbmc-nightly.do_prepare: @DEPENDS_xbmc_nightly@
	@PREPARE_xbmc_nightly
	touch $@

#			PYTHON_LDFLAGS='-L$(targetprefix)/usr/include/python2.6 -lpython2.6' \
#			PYTHON_VERSION='2.6' \
#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap libboost directfb libstgles libass libmpeg2 libmad jpeg libsamplerate libogg libvorbis libmodplug curl libflac bzip2 tiff lzo libz fontconfig libfribidi freetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink expat
	cd $(appsdir)/xbmc-nightly && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PYTHON_SITE_PKG=$(targetprefix)/usr/lib/python2.6/site-packages \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python2.6 \
			PY_PATH=$(targetprefix)/usr \
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
			--disable-udev \
			--disable-libusb \
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

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/xbmc.bin; \
	fi
	touch $@

xbmc-nightly-clean xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(appsdir)/xbmc-nightly
	rm -rf $(appsdir)/xbmc-nightly.newest
	rm -rf $(appsdir)/xbmc-nightly.org
	rm -rf $(appsdir)/xbmc-nightly.patched

