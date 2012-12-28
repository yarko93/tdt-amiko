#
# INIT-SCRIPTS customized
#

DESCRIPTION_init_scripts_vdr = init scripts and rules for system start
init_scripts_initd_vdr_files = \
halt \
hostname \
inetd \
initmodules \
mountall \
mountsysfs \
networking \
reboot \
sendsigs \
telnetd \
syslogd \
lircd \
umountfs

define postinst_init_scripts
#!/bin/sh
$(foreach f,$(init_scripts_initd_vdr_files), initdconfig --add $f
)
endef

define prerm_init_scripts
#!/bin/sh
$(foreach f,$(init_scripts_initd_vdr_files), initdconfig --del $f
)
endef

$(DEPDIR)/init-scripts-vdr: @DEPENDS_init_scripts_vdr@
	@PREPARE_init_scripts_vdr@
	$(start_build)
	$(INSTALL_DIR) $(PKDIR)/etc/init.d

# select initmodules
	cd $(DIR_init_scripts_vdr) && \
	mv initmodules$(if $(SPARK),_vdr_$(SPARK))$(if $(SPARK7162),_vdr_$(SPARK7162))$(if $(HL101),_vdr_$(HL101)) initmodules
# select halt
	cd $(DIR_init_scripts_vdr) && \
	mv halt$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) halt
# init.d scripts
	cd $(DIR_init_scripts_vdr) && \
		$(INSTALL) inittab_vdr $(PKDIR)/etc/inittab && \
		$(INSTALL) -m 755 rc $(PKDIR)/etc/init.d/rc && \
		$(foreach f,$(init_scripts_initd_vdr_files), $(INSTALL) -m 755 $f $(PKDIR)/etc/init.d && ) true
	$(toflash_build)
	touch $@
	
# auxiliary targets for model-specific builds
release_vdr_common_utils:
# opkg config
	mkdir -p $(prefix)/release/etc/opkg
	mkdir -p $(prefix)/release/usr/lib/locale
	cp -f $(buildprefix)/root/release/official-feed.conf $(prefix)/release/etc/opkg/
	cp -f $(buildprefix)/root/release/opkg.conf $(prefix)/release/etc/
	$(call initdconfig,$(shell ls $(prefix)/release/etc/init.d))

# Copy video_7105
	$(if $(SPARK7162),cp -f $(archivedir)/boot/video_7105.elf $(prefix)/release/boot/video.elf)
# Copy audio_7105
	$(if $(SPARK7162),cp -f $(archivedir)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf)
# Copy video_7109
	$(if $(HL101),cp -f $(archivedir)/boot/video_7109.elf $(prefix)/release/boot/video.elf)
# Copy audio_7109
	$(if $(HL101),cp -f $(archivedir)/boot/audio_7109.elf $(prefix)/release/boot/audio.elf)
# Copy video_7111
	$(if $(SPARK),cp -f $(archivedir)/boot/video_7111.elf $(prefix)/release/boot/video.elf)
# Copy audio_7111
	$(if $(SPARK),cp -f $(archivedir)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf )
	
release_vdr_base:
	rm -rf $(prefix)/release || true
	$(INSTALL_DIR) $(prefix)/release && \
	cp -rp $(prefix)/pkgroot/* $(prefix)/release
# filesystem
	$(INSTALL_DIR) $(prefix)/release/bin && \
	$(INSTALL_DIR) $(prefix)/release/sbin && \
	$(INSTALL_DIR) $(prefix)/release/boot && \
	$(INSTALL_DIR) $(prefix)/release/dev && \
	$(INSTALL_DIR) $(prefix)/release/dev.static && \
	$(INSTALL_DIR) $(prefix)/release/etc && \
	$(INSTALL_DIR) $(prefix)/release/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-post-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-pre-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release/etc/enigma2 && \
	$(INSTALL_DIR) $(prefix)/release/media && \
	$(INSTALL_DIR) $(prefix)/release/media/dvd && \
	$(INSTALL_DIR) $(prefix)/release/media/net && \
	$(INSTALL_DIR) $(prefix)/release/mnt && \
	$(INSTALL_DIR) $(prefix)/release/mnt/usb && \
	$(INSTALL_DIR) $(prefix)/release/mnt/hdd && \
	$(INSTALL_DIR) $(prefix)/release/mnt/nfs && \
	$(INSTALL_DIR) $(prefix)/release/root && \
	$(INSTALL_DIR) $(prefix)/release/proc && \
	$(INSTALL_DIR) $(prefix)/release/sys && \
	$(INSTALL_DIR) $(prefix)/release/tmp && \
	$(INSTALL_DIR) $(prefix)/release/usr && \
	$(INSTALL_DIR) $(prefix)/release/usr/bin && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd/picture && \
	ln -sf /media/hdd $(prefix)/release/hdd && \
	$(INSTALL_DIR) $(prefix)/release/lib && \
	$(INSTALL_DIR) $(prefix)/release/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release/lib/firmware && \
	$(INSTALL_DIR) $(prefix)/release/ram && \
	$(INSTALL_DIR) $(prefix)/release/var && \
	$(INSTALL_DIR) $(prefix)/release/var/etc && \
	mkdir -p $(prefix)/release/var/run/lirc && \
	$(INSTALL_DIR) $(prefix)/release/usr/lib/opkg && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/ipkg-cl && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/opkg && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/ipkg
# rc.d directories
	mkdir -p $(prefix)/release/etc/rc.d/rc{0,1,2,3,4,5,6,S}.d
	ln -sf ../init.d $(prefix)/release/etc/rc.d
# zoneinfo
	$(INSTALL_DIR) $(prefix)/release/usr/share/zoneinfo && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release/usr/share/zoneinfo/
# udhcpc
	$(INSTALL_DIR) $(prefix)/release/usr/share/udhcpc && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release/usr/share/udhcpc/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/etc/timezone.xml $(prefix)/release/etc/ && \
	cp -a $(buildprefix)/root/etc/Wireless $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/firmware/*.bin $(prefix)/release/lib/firmware/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release/etc/network/ && \
	cp $(buildprefix)/root/var/vdr/channels.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/diseqc.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/keymacros.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/remote.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/setup.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/sources.conf $(prefix)/release/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/plugins/mplayersources.conf $(prefix)/release/usr/local/share/vdr/plugins && \
	cp $(buildprefix)/root/usr/local/bin/mplayer.sh $(prefix)/release/usr/local/bin/ && \
        chmod 755 $(prefix)/release/usr/local/bin/mplayer.sh && \
	cp -rd $(buildprefix)/root/var/vdr/themes/* $(prefix)/release/usr/local/share/vdr/themes/ && \
	cp $(buildprefix)/root/usr/local/bin/runvdrdev2 $(prefix)/release/usr/local/bin/runvdr && \
	chmod 755 $(prefix)/release/usr/local/bin/runvdr && \
	cp $(buildprefix)/root/usr/local/bin/vdrshutdown $(prefix)/release/usr/local/bin/
# AUTOFS
	if [ -d $(prefix)/release/usr/lib/autofs ]; then \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release/etc/init.d/; \
	fi

# Copy lircd.conf
	cp -f $(buildprefix)/root/etc/lircd$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)).conf $(prefix)/release/etc/lircd.conf

	touch $(prefix)/release/var/etc/.firstboot && \
	cp -f $(buildprefix)/root/release/mme_check $(prefix)/release/etc/init.d/ && \
	cp -f $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release/boot/ && \
	cp -f $(buildprefix)/root/bin/autologin $(prefix)/release/bin/ && \
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release/bin/ && \
	cp -f $(buildprefix)/root/etc/vdstandby.cfg $(prefix)/release/etc/ && \
	cp -f $(buildprefix)/root/etc/init.d/avahi-daemon $(prefix)/release/etc/init.d/ && \
	chmod 777 $(prefix)/release/etc/init.d/avahi-daemon && \
	cp -f $(buildprefix)/root/etc/network/interfaces $(prefix)/release/etc/network/ && \
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release/sbin/ && \
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release/sbin/ && \
	cp -f $(buildprefix)/root/etc/image-version $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/fstab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/hostname $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/inetd.conf $(prefix)/release/etc/ && \
	ln -s /usr/share/zoneinfo/Europe/Berlin $(prefix)/release/etc/localtime && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/profile $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/resolv.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release/etc/ && \
	echo "576i50" > $(prefix)/release/etc/videomode && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/vdr && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/vdr/plugins && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/vdr/plugins/setup && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/vdr/plugins/text2skin && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/vdr/themes && \
	$(INSTALL_DIR) $(prefix)/release/usr/local/bin && \
	$(INSTALL_DIR) $(prefix)/release/usr/lib/locale

release_vdr_spark:
	echo "spark" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf && \
	cp $(buildprefix)/root/etc/lircd_spark.conf.09_00_0B $(prefix)/release/etc/lircd.conf.09_00_0B && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
release_vdr_spark7162:
	echo "spark7162" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien2.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv -f $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf
	cp $(buildprefix)/root/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw
	rm -f $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7106.ko

release_vdr_hl101:
	echo "hl101" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_hl101 $(prefix)/release/etc/fstab
	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/


# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/release_vdr: $(DEPDIR)/%release_vdr:release_vdr_base release_vdr_common_utils release_$(HL101)$(SPARK)$(SPARK7162)
# Post tweaks
	depmod -b $(prefix)/release $(KERNELVERSION)
	touch $@

release-vdr_clean:
	rm -f $(DEPDIR)/release_vdr
	rm -f $(DEPDIR)/release_vdr_base
	rm -f $(DEPDIR)/release_vdr_$(HL101)$(SPARK)$(SPARK7162)
	rm -f $(DEPDIR)/release_vdr_common_utils 
	rm -f $(DEPDIR)/release_vdr_cube_common 
