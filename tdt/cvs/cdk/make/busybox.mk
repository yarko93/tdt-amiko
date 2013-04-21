#
# busybox
#

PKGR_busybox = r1
BEGIN[[
busybox
  1.21.0
  {PN}-{PV}
  extract:http://www.{PN}.net/downloads/{PN}-{PV}.tar.bz2
  patch:file://{PN}-{PV}-mdev.patch
  patch:file://{PN}-{PV}-platform.patch
  patch:file://{PN}-{PV}-xz.patch
  nothing:file://{PN}-{PV}.config
  pmove:{PN}-{PV}/{PN}-{PV}.config:{PN}-{PV}/.config
  make:install:CONFIG_PREFIX=PKDIR
;
]]END

$(DEPDIR)/busybox.do_prepare: bootstrap $(DEPENDS_busybox)
	$(PREPARE_busybox)
	touch $@

$(DEPDIR)/busybox.do_compile: $(DEPDIR)/busybox.do_prepare
	cd $(DIR_busybox) && \
		$(MAKE) all \
			CROSS_COMPILE=$(target)- \
			CFLAGS_EXTRA="$(TARGET_CFLAGS)"
	touch $@

DESCRIPTION_busybox = "Utilities for embedded systems"

$(DEPDIR)/busybox: \
$(DEPDIR)/%busybox: $(DEPDIR)/busybox.do_compile
	$(start_build)
	cd $(DIR_busybox) && \
		export CROSS_COMPILE=$(target)- && \
		$(INSTALL_busybox)
#		@CLEANUP_busybox@
	install -m644 -D /dev/null $(PKDIR)/etc/shells
	export HHL_CROSS_TARGET_DIR=$(PKDIR) && $(hostprefix)/bin/target-shellconfig --add /bin/ash 5
	$(tocdk_build)
	$(toflash_build)
	touch $@


$(eval $(call guiconfig,busybox))
