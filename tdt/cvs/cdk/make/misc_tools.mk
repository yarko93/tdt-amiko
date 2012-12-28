# misc/tools

DESCRIPTION_misc_tools = "misc tools for box"
SRC_URI_misc_tools = "git://gitorious.org/~schpuntik/open-duckbox-project-sh4/tdt-amiko.git"
DIR_misc_tools = $(appsdir)/misc/tools


#$(appsdir)/misc/tools/config.status: bootstrap libpng
$(appsdir)/misc/tools/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/misc/tools && \
	libtoolize -f -c && \
	$(CONFIGURE) --prefix= \
	$(if $(MULTICOM322), --enable-multicom322) $(if $(MULTICOM324), --enable-multicom324)

$(DEPDIR)/misc-tools: $(DEPDIR)/%misc-tools: driver libstdc++-dev libdvdnav libdvdcss libpng jpeg ffmpeg expat fontconfig bzip2 $(appsdir)/misc/tools/config.status
	$(start_build)
	$(get_git_version)
	$(MAKE) -C $(appsdir)/misc/tools all install DESTDIR=$(PKDIR) \
	CPPFLAGS="\
	$(if $(SPARK), -DPLATFORM_SPARK) \
	$(if $(SPARK7162), -DPLATFORM_SPARK7162) \
	$(if $(HL101), -DPLATFORM_HL101) \
	$(if $(PLAYER179), -DPLAYER179) \
	$(if $(PLAYER191), -DPLAYER191) \
	$(if $(VDR1722), -DVDR1722) \
	$(if $(VDR1727), -DVDR1727)"
	$(tocdk_build)
	$(toflash_build)
	[ "x$*" = "x" ] && touch $@ || true

misc-tools-clean:
	-$(MAKE) -C $(appsdir)/misc/tools distclean
