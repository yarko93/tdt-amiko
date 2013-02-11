#Trick ALPHA-Version ;)

release_vdr:
	rm -rf $(prefix)/release_vdr || true
	$(INSTALL_DIR) $(prefix)/release_vdr && \
	$(INSTALL_DIR) $(prefix)/release_vdr/bin && \
	$(INSTALL_DIR) $(prefix)/release_vdr/sbin && \
	$(INSTALL_DIR) $(prefix)/release_vdr/boot && \
	$(INSTALL_DIR) $(prefix)/release_vdr/dev && \
	$(INSTALL_DIR) $(prefix)/release_vdr/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-pre-down.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/network/if-post-up.d && \
	$(INSTALL_DIR) $(prefix)/release_vdr/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_vdr/hdd && \
	$(INSTALL_DIR) $(prefix)/release_vdr/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_vdr/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_vdr/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_vdr/lib && \
	$(INSTALL_DIR) $(prefix)/release_vdr/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_vdr/ram && \
	$(INSTALL_DIR) $(prefix)/release_vdr/var && \
	$(INSTALL_DIR) $(prefix)/release_vdr/var/etc && \
	$(INSTALL_DIR) $(prefix)/release_vdr/var/run/lirc && \
	export CROSS_COMPILE=$(target)- && \
	$(MAKE) install -C $(DIR_busybox) CONFIG_PREFIX=$(prefix)/release_vdr && \
	touch $(prefix)/release_vdr/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_vdr/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_vdr/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/release_vdr/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_vdr/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_vdr/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_vdr/bin/ && \
	$(if $(SPARK7162),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_vdr/boot/video.elf &&) \
	$(if $(SPARK7162),cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_vdr/boot/audio.elf &&) \
	$(if $(HL101),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdr/boot/video.elf &&) \
	$(if $(HL101),cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_vdr/boot/audio.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_vdr/boot/video.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_vdr/boot/audio.elf &&) \
	cp -a $(targetprefix)/dev/* $(prefix)/release_vdr/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_vdr/etc/ && \
##	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_vdr/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_vdr/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_vdr/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_vdr/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_vdr/etc/init.d/ && \
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_vdr/sbin/ && \
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdr/etc/init.d/ && \
	chmod 755 $(prefix)/release_vdr/etc/init.d/umountfs && \
	chmod 755 $(prefix)/release_vdr/etc/init.d/rc && \
	chmod 755 $(prefix)/release_vdr/etc/init.d/sendsigs && \
	mkdir -p $(prefix)/release_vdr/etc/rc.d/rc0.d && \
	ln -s ../init.d $(prefix)/release_vdr/etc/rc.d && \
	ln -fs halt $(prefix)/release_vdr/sbin/reboot && \
	ln -fs halt $(prefix)/release_vdr/sbin/poweroff && \
	ln -s ../init.d/sendsigs $(prefix)/release_vdr/etc/rc.d/rc0.d/S20sendsigs && \
	ln -s ../init.d/umountfs $(prefix)/release_vdr/etc/rc.d/rc0.d/S40umountfs && \
	ln -s ../init.d/halt $(prefix)/release_vdr/etc/rc.d/rc0.d/S90halt && \
	mkdir -p $(prefix)/release_vdr/etc/rc.d/rc6.d && \
	ln -s ../init.d/sendsigs $(prefix)/release_vdr/etc/rc.d/rc6.d/S20sendsigs && \
	ln -s ../init.d/umountfs $(prefix)/release_vdr/etc/rc.d/rc6.d/S40umountfs && \
	ln -s ../init.d/reboot $(prefix)/release_vdr/etc/rc.d/rc6.d/S90reboot && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_vdr/etc/init.d/ && \
	echo "576i50" > $(prefix)/release_vdr/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_vdrdev2$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) $(prefix)/release_vdr/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_vdr/etc/init.d/rcS && \
	mkdir -p $(prefix)/release_vdr/usr/local/share/vdr && \
	mkdir -p $(prefix)/release_vdr/usr/local/share/vdr/plugins && \
	mkdir -p $(prefix)/release_vdr/usr/local/share/vdr/plugins/setup && \
	mkdir -p $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin && \
	mkdir -p $(prefix)/release_vdr/usr/local/share/vdr/themes && \
	mkdir -p $(prefix)/release_vdr/usr/local/bin && \
	mkdir -p $(prefix)/release_vdr/usr/lib/locale && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_vdr/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/var/vdr/channels.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/diseqc.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/keymacros.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/remote.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/setup.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/sources.conf $(prefix)/release_vdr/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/plugins/mplayersources.conf $(prefix)/release_vdr/usr/local/share/vdr/plugins && \
	cp $(buildprefix)/root/usr/local/bin/mplayer.sh $(prefix)/release_vdr/usr/local/bin/ && \
        chmod 755 $(prefix)/release_vdr/usr/local/bin/mplayer.sh && \
	cp -rd $(buildprefix)/root/var/vdr/themes/* $(prefix)/release_vdr/usr/local/share/vdr/themes/ && \
	cp $(buildprefix)/root/usr/local/bin/runvdrdev2 $(prefix)/release_vdr/usr/local/bin/runvdr && \
	chmod 755 $(prefix)/release_vdr/usr/local/bin/runvdr && \
	cp $(buildprefix)/root/usr/local/bin/vdrshutdown $(prefix)/release_vdr/usr/local/bin/ && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_vdr/etc/init.d/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_vdr/bin/ && \
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_vdr/usr/bin/ && \
	cp -rd $(buildprefix)/root/usr/lib/locale/* $(prefix)/release_vdr/usr/lib/locale/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_vdr/lib/ && \
	rm -f $(prefix)/release_vdr/lib/*.a && \
	rm -f $(prefix)/release_vdr/lib/*.o && \
	rm -f $(prefix)/release_vdr/lib/*.la && \
	find $(prefix)/release_vdr/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/release_vdr/lib/modules/
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_vdr/boot/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_vdr/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_vdr/etc/

ifdef ENABLE_VDR1722
	cp $(buildprefix)/root/var/vdr/plugins_vdrdev2.load $(prefix)/release_vdr/usr/local/share/vdr/plugins.load 
endif
ifdef ENABLE_VDR1727
	cp $(buildprefix)/root/var/vdr/plugins.load $(prefix)/release_vdr/usr/local/share/vdr/plugins.load
	cp $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/setup/examples/x-vdr/vdr-menu.xml $(prefix)/release_vdr/usr/local/share/vdr/plugins/setup
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/PearlHD $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/anthra_1280_FS $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/anthra_1920_OSo $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/EgalT2 $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/HD-Ready-anthras $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
	cp -dpR $(appsdir)/vdr/vdr-1.7.27/PLUGINS/src/NarrowHD $(prefix)/release_vdr/usr/local/share/vdr/plugins/text2skin
endif
	

ifdef ENABLE_SPARK
	echo "spark" > $(prefix)/release_vdr/etc/hostname
	rm -f $(prefix)/release_vdr/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdr/sbin/
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release_vdr/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_vdr/lib/modules/
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_vdr/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_vdr/sbin
	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release_vdr/etc/lircd.conf
	mv $(prefix)/release_vdr/lib/firmware/component_7111_mb618.fw $(prefix)/release_vdr/lib/firmware/component.fw
	rm $(prefix)/release_vdr/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdr/bin/evremote
	rm -f $(prefix)/release_vdr/bin/gotosleep

else
ifdef ENABLE_SPARK7162
	echo "spark7162" > $(prefix)/release_vdr/etc/hostname
	rm -f $(prefix)/release_vdr/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdr/sbin/
	cp $(buildprefix)/root/release/halt_spark7162 $(prefix)/release_vdr/etc/init.d/halt
	chmod 755 $(prefix)/release_vdr/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_vdr/lib/modules/
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_vdr/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_vdr/sbin
	cp -dp $(buildprefix)/root/etc/lircd_spark7162.conf $(prefix)/release_vdr/etc/lircd.conf
	mv $(prefix)/release_vdr/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_vdr/lib/firmware/component.fw
	rm $(prefix)/release_vdr/lib/firmware/component_7111_mb618.fw

	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdr/bin/evremote
	rm -f $(prefix)/release_vdr/bin/gotosleep

else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_vdr/lib/modules/

	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx21143.fw
endif
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_vdr/lib/modules/
ifdef !ENABLE_SPARK
ifdef !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_vdr/lib/modules/
endif
endif

ifdef ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_vdr/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_vdr/lib/modules/
	find $(prefix)/release_vdr/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_vdr/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_vdr/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_vdr/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

ifdef ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_vdr/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_vdr/lib/modules/
	find $(prefix)/release_vdr/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		sound/kreplay/kreplay.ko \
		sound/kreplay/kreplay-fdma.ko \
		sound/ksound/ktone.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_vdr/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_vdr/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_vdr/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

	rm -rf $(prefix)/release_vdr/lib/autofs
	rm -rf $(prefix)/release_vdr/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_vdr/media
	ln -s /hdd $(prefix)/release_vdr/media/hdd
	$(INSTALL_DIR) $(prefix)/release_vdr/media/dvd

	$(INSTALL_DIR) $(prefix)/release_vdr/mnt
	$(INSTALL_DIR) $(prefix)/release_vdr/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_vdr/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_vdr/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_vdr/root

	$(INSTALL_DIR) $(prefix)/release_vdr/proc
	$(INSTALL_DIR) $(prefix)/release_vdr/sys
	$(INSTALL_DIR) $(prefix)/release_vdr/tmp

	$(INSTALL_DIR) $(prefix)/release_vdr/usr
	$(INSTALL_DIR) $(prefix)/release_vdr/usr/bin
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_vdr/usr/bin/
	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_vdr/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_vdr/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/tuxtxt


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/share

#######################################################################################


#######################################################################################

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_vdr/usr/share/zoneinfo/

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_vdr/usr/share/udhcpc/


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/local

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/local/bin
	cp -rd $(targetprefix)/usr/local/bin/vdr $(prefix)/release_vdr/usr/local/bin/
	find $(prefix)/release_vdr/usr/local/bin/ -name  vdr -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################

#	$(INSTALL_DIR) $(prefix)/release_vdr/usr/local/share
#	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_vdr/usr/local/share/
#	TODO: Channellist ....
#	$(INSTALL_DIR) $(prefix)/release_vdr/usr/local/share/config
#	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_vdr/usr/local/share/config/
#	cp -aR $(targetprefix)/usr/local/share/vdr $(prefix)/release_vdr/usr/local/share/
#	TODO: HACK
#	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/vdr/* $(prefix)/release_vdr/usr/local/share/vdr
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/release_vdr/usr/local/share/
#	ln -s /usr/local/share/fonts/micron.ttf $(prefix)/release_vdr/usr/local/share/fonts/vdr.ttf
	mkdir -p $(prefix)/release_vdr/usr/share/fonts
	mkdir -p $(prefix)/release_vdr/etc/fonts
	cp -d $(buildprefix)/root/usr/share/fonts/seg.ttf $(prefix)/release_vdr/usr/share/fonts/vdr.ttf
	cp -d $(targetprefix)/etc/fonts/fonts.conf $(prefix)/release_vdr/etc/fonts/


#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_vdr/etc/imageinfo
	git describe >> $(prefix)/release_vdr/etc/imageinfo
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/lib

	mkdir -p $(prefix)/release_vdr/usr/local/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_vdr/usr/lib/
#	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_vdr/usr/lib/
	cp -rd $(targetprefix)/usr/lib/libfontconfi* $(prefix)/release_vdr/usr/lib/
	mkdir -p $(prefix)/release_vdr/usr/lib/vdr/

	cp -rd $(targetprefix)/usr/lib/vdr/lib*.1.7.* $(prefix)/release_vdr/usr/lib/vdr/
	cp -rd $(targetprefix)/usr/lib/vdr/lib*.1.7.* $(prefix)/release_vdr/usr/lib/vdr/

	rm -rf $(prefix)/release_vdr/usr/lib/alsa-lib
	rm -rf $(prefix)/release_vdr/usr/lib/alsaplayer
	rm -rf $(prefix)/release_vdr/usr/lib/engines
	rm -rf $(prefix)/release_vdr/usr/lib/enigma2

	rm -rf $(prefix)/release_vdr/usr/lib/gconv/*
	cp -rd $(targetprefix)/usr/lib/gconv/gconv-modules $(prefix)/release_vdr/usr/lib/gconv/
#cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-1.so $(prefix)/release_vdr/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-9.so $(prefix)/release_vdr/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-15.so $(prefix)/release_vdr/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/UTF-32.so $(prefix)/release_vdr/usr/lib/gconv/

	rm -rf $(prefix)/release_vdr/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_vdr/usr/lib/pkgconfig
	rm -rf $(prefix)/release_vdr/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_vdr/usr/lib/X11
	rm -f $(prefix)/release_vdr/usr/lib/*.a
	rm -f $(prefix)/release_vdr/usr/lib/*.o
	rm -f $(prefix)/release_vdr/usr/lib/*.la
	find $(prefix)/release_vdr/usr/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/vdr #############
	cp -RP $(buildprefix)/own_build/vdr/* $(prefix)/release_vdr/
	ln -sf /usr/share/zoneinfo/CET $(prefix)/release_vdr/etc/localtime
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/include/boost

#	mkdir -p $(prefix)/release_vdr/usr/include/boost/
#	cp -rd $(targetprefix)/usr/include/boost/shared_container_iterator.hpp $(prefix)/release_vdr/usr/include/boost/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/share/locale

#	mkdir -p $(prefix)/release_vdr/usr/share/locale/
	cp -rd $(targetprefix)/usr/share/locale/* $(prefix)/release_vdr/usr/share/locale

	mkdir -p $(prefix)/release_vdr/usr/local/share/locale
#	cp -rd $(targetprefix)/usr/local/share/locale/* $(prefix)/release_vdr/usr/local/share/locale
	cp -rd $(targetprefix)/usr/local/share/locale/* $(prefix)/release_vdr/usr/local/share/locale/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdr/usr/share/locale

	mkdir -p $(prefix)/release_vdr/var/vdr
#	cp -rd $(targetprefix)/var/vdr/remote.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/sources.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/channels.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr $(prefix)/release_vdr/var/vdr/

#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release_vdr/boot/

ifdef STM24
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_vdr/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_vdr/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_vdr/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_vdr/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_vdr/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_vdr/lib/modules || true
endif
