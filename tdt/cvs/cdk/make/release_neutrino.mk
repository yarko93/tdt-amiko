kernelpath=linux-sh4

#Trick ALPHA-Version ;)
$(DEPDIR)/release_neutrino: $(DEPDIR)/%release_neutrino:
	rm -rf $(prefix)/release_neutrino || true
	$(INSTALL_DIR) $(prefix)/release_neutrino && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/bin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/sbin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/boot && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/dev && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/lib && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/ram && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/etc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C $(DIR_busybox) CONFIG_PREFIX=$(prefix)/release_neutrino && \
	touch $(prefix)/release_neutrino/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_neutrino/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_neutrino/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release_neutrino/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release_neutrino/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(buildprefix)/root/var/etc/.version $(prefix)/release_neutrino/var/etc/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_neutrino/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_neutrino/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release_neutrino/bin/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_neutrino/sbin/ && \
\
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_neutrino/boot/video.elf && \
	$(if $(HL101),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(SPARK7162),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf &&) \
\
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_neutrino/boot/audio.elf && \
	$(if $(HL101), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_neutrino/boot/audio.elf &&) \
	$(if $(SPARK), cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf &&) \
	$(if $(SPARK7162), cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_neutrino/boot/audio.elf &&) \
\
	cp -a $(targetprefix)/dev/* $(prefix)/release_neutrino/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_neutrino/etc/ && \
	mkdir -p $(prefix)/release_neutrino/var/run/lirc
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_neutrino/etc/init.d/ && \
	mkdir -p $(prefix)/release_neutrino/usr/local/share/config/tuxtxt/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_neutrino/usr/local/share/config/tuxtxt/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_neutrino/bin/ && \
	echo "576i50" > $(prefix)/release_neutrino/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_neutrino$(if $(HL101),_$(HL101))$(if $(SPARK),_$(SPARK)$(if $(SPARK7162),_$(SPARK7162)) $(prefix)/release_neutrino/etc/init.d/rcS && \
	cp $(buildprefix)/root/etc/fw_env.config$(if $(SPARK),_$(SPARK)) $(prefix)/release_neutrino/etc/fw_env.config && \
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/getfb.awk $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_neutrino/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_neutrino/lib/ && \
	rm -f $(prefix)/release_neutrino/lib/*.a && \
	rm -f $(prefix)/release_neutrino/lib/*.o && \
	rm -f $(prefix)/release_neutrino/lib/*.la && \
	find $(prefix)/release_neutrino/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
	[ -e $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko $(prefix)/release_neutrino/lib/modules || true
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release_neutrino/sbin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_neutrino/lib/modules/
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_neutrino/lib/modules/)


if ENABLE_SPARK
	echo "Amiko" > $(prefix)/release_neutrino/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_neutrino/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_neutrino/etc/
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_neutrino/lib/modules/
	cp -f $(buildprefix)/root/release/vfd_spark$(KERNELSTMLABEL).ko $(prefix)/release_neutrino/lib/modules/vfd.ko
	cp -f $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko $(prefix)/release_neutrino/lib/modules/encrypt.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

else
if ENABLE_SPARK7162

	echo "spark7162" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

else
if ENABLE_HL101

	echo "hl101" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else

	rm -f $(prefix)/release_neutrino/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_neutrino/etc/init.d/reboot
	chmod 755 $(prefix)/release_neutrino/etc/init.d/reboot
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
endif
endif
endif
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_neutrino/lib/modules/
endif
endif
if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_neutrino/lib/modules/

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino/lib/modules/ || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_neutrino/lib/modules/ || true

	find $(prefix)/release_neutrino/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_neutrino/lib/modules/

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino/lib/modules/ || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_neutrino/lib/modules/ || true

	find $(prefix)/release_neutrino/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

	rm -rf $(prefix)/release_neutrino/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_neutrino/media
	ln -s /hdd $(prefix)/release_neutrino/media/hdd
	$(INSTALL_DIR) $(prefix)/release_neutrino/media/dvd

	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_neutrino/root

	$(INSTALL_DIR) $(prefix)/release_neutrino/proc
	$(INSTALL_DIR) $(prefix)/release_neutrino/sys
	$(INSTALL_DIR) $(prefix)/release_neutrino/tmp

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/bin
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/lib
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_neutrino/usr/bin/

if ENABLE_HL101
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif


	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_neutrino/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_neutrino/usr/sbin/
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/tuxtxt


#######################################################################################
	mkdir -p $(prefix)/release_neutrino/tuxbox/config
	mkdir -p $(prefix)/release_neutrino/var/plugins
	mkdir -p $(prefix)/release_neutrino/lib/tuxbox
	mkdir -p $(prefix)/release_neutrino/usr/lib/tuxbox
	mkdir -p $(prefix)/release_neutrino/var/tuxbox/config
	mkdir -p $(prefix)/release_neutrino/share/tuxbox
	mkdir -p $(prefix)/release_neutrino/var/share/icons
	mkdir -p $(prefix)/release_neutrino/var/usr/local/share/config
	( cd $(prefix)/release_neutrino/share/tuxbox && ln -s /usr/local/share/neutrino )
	( cd $(prefix)/release_neutrino/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_neutrino/ && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/release_neutrino/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
	( cd $(prefix)/release_neutrino/lib/tuxbox && ln -s /var/plugins )
	( cd $(prefix)/release_neutrino/var/tuxbox && ln -s /var/plugins )
	( cd $(prefix)/release_neutrino/usr/lib/tuxbox && ln -s /var/plugins )

#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share

#######################################################################################


#######################################################################################

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_neutrino/usr/share/zoneinfo/

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_neutrino/usr/share/udhcpc/


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	find $(prefix)/release_neutrino/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino/usr/local/bin/ -name  pzapit -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino/usr/local/bin/ -name  sectionsdcontrol -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/share
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_neutrino/usr/local/share/
#	TODO: Channellist ....
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/share/config
	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_neutrino/usr/local/share/config/
	cp -aR $(targetprefix)/usr/local/share/neutrino $(prefix)/release_neutrino/usr/local/share/
#	TODO: HACK (without *.locale are missing!) --- should be not longer needed since path fix
#	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/neutrino/* $(prefix)/release_neutrino/usr/local/share/neutrino
#######################################################################################
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/release_neutrino/usr/local/share/
	mkdir -p $(prefix)/release_neutrino/usr/local/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/tuxtxt.ttf $(prefix)/release_neutrino/usr/local/share/fonts/

#       Font libass
	mkdir -p $(prefix)/release_neutrino/usr/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/release_neutrino/usr/share/fonts/

	cp -aR $(targetprefix)/usr/local/share/fonts/micron.ttf $(prefix)/release_neutrino/usr/local/share/fonts/neutrino.ttf
#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_neutrino/etc/imageinfo
	git describe >> $(prefix)/release_neutrino/etc/imageinfo
	$(buildprefix)/root/release/neutrino_version.sh
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/lib

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_neutrino/usr/lib/
	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_neutrino/usr/lib/
	rm -rf $(prefix)/release_neutrino/usr/lib/alsa-lib
	rm -rf $(prefix)/release_neutrino/usr/lib/alsaplayer
	rm -rf $(prefix)/release_neutrino/usr/lib/engines
	rm -rf $(prefix)/release_neutrino/usr/lib/enigma2
	rm -rf $(prefix)/release_neutrino/usr/lib/gconv
	rm -rf $(prefix)/release_neutrino/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_neutrino/usr/lib/pkgconfig
	rm -rf $(prefix)/release_neutrino/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_neutrino/usr/lib/X11
	rm -f $(prefix)/release_neutrino/usr/lib/*.a
	rm -f $(prefix)/release_neutrino/usr/lib/*.o
	rm -f $(prefix)/release_neutrino/usr/lib/*.la
	mkdir -p $(prefix)/release_neutrino/usr/local/share/neutrino/icons/logo
#
#######################################################################################
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino && ln -s /usr/local/share/neutrino/httpd httpd-y )
	( cd $(prefix)/release_neutrino/var && ln -s /usr/local/share/neutrino/httpd httpd )
	cp $(appsdir)/neutrino/src/nhttpd/web/{Y_Baselib.js,Y_VLC.js} $(prefix)/release_neutrino/usr/local/share/neutrino/httpd/
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo logos )
#######################################################################################
#
	find $(prefix)/release_neutrino/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
#
######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino #############
#	rm $(prefix)/release_neutrino/bin/mount
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/release_neutrino/

######################################################################################

	cp $(kernelprefix)/$(kernelpath)/arch/sh/boot/uImage $(prefix)/release_neutrino/boot/
	touch $@
