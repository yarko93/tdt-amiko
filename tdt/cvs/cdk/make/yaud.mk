min-prepare-yaud std-prepare-yaud max-prepare-yaud: \
%prepare-yaud:
	-rm -rf $(prefix)/$*cdkroot
	-rm -rf $(prefix)/$*cdkroot-rpmdb

#
# BOOTSTRAP
#
$(DEPDIR)/min-bootstrap $(DEPDIR)/std-bootstrap $(DEPDIR)/max-bootstrap $(DEPDIR)/bootstrap: \
$(DEPDIR)/%bootstrap: \
		%libtool \
		%$(FILESYSTEM) \
		%$(GLIBC) \
		%$(CROSS_LIBGCC) \
		%$(LIBSTDC)

	@[ "x$*" = "x" ] && touch -r RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm $@ || true

#
# BARE-OS
#
min-bare-os std-bare-os max-bare-os bare-os: \
%bare-os: \
		%bootstrap \
		%$(LIBTERMCAP) \
		%$(NCURSES_BASE) \
		%$(NCURSES) \
		%$(BASE_PASSWD) \
		%$(MAKEDEV) \
		%$(BASE_FILES) \
		%module_init_tools \
		%busybox \
		%libz \
		%grep \
		%$(INITSCRIPTS) \
		%openrdate \
		%$(NETBASE) \
		%$(BC) \
		%$(SYSVINIT) \
		%$(DISTRIBUTIONUTILS) \
		\
		%e2fsprogs \
		%u-boot-utils
#		%diverse-tools
#		%$(RELEASE) \
#		%$(FINDUTILS) \
#

min-net-utils std-net-utils max-net-utils net-utils: \
%net-utils: \
		%$(NETKIT_FTP) \
		%portmap \
		%$(NFSSERVER) \
		%vsftpd \
		%ethtool \
		%opkg \
		%grep \
		%$(CIFS)

min-disk-utils std-disk-utils max-disk-utils disk-utils: \
%disk-utils: \
		%$(XFSPROGS) \
		%util-linux \
		%jfsutils \
		%$(SG3)

#dummy targets
#really ugly
min-:

std-:

max-:


#
# YAUD
#
yaud-stock: yaud-none stock

yaud-vdr: yaud-none \
		stslave \
		lirc \
		openssl \
		openssl-dev \
		boot-elf \
		misc-cp \
		vdr \
		release_vdr

yaud-neutrino-hd2: yaud-none \
		lirc \
		stslave \
		boot-elf \
		firstboot \
		neutrino-hd2 \
		release_neutrino

yaud-enigma2-nightly: yaud-none \
		host_python \
		lirc \
		stslave \
		boot-elf \
		init-scripts \
		enigma2-nightly \
		release

yaud-enigma2-pli-nightly-base: yaud-none \
		host_python \
		lirc \
		boot-elf \
		init-scripts \
		enigma2-pli-nightly

yaud-enigma2-pli-nightly: yaud-enigma2-pli-nightly-base release

yaud-enigma2-pli-nightly-full: yaud-enigma2-pli-nightly-base min-extras release

yaud-xbmc-nightly: yaud-none host_python boot-elf xbmc-nightly init-scripts-xbmc release_xbmc

yaud-none: \
		bare-os \
		opkg-host \
		libdvdcss \
		libdvdread \
		libdvdnav \
		linux-kernel \
		net-utils \
		disk-utils \
		driver \
		udev \
		udev-rules \
		misc-tools 

#
# MIN-YAUD
#
test-kati: min-yaud-stock

min-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none

min-yaud-none: \
%yaud-none:	%bare-os \
		%misc-tools \
		%linux-kernel \
		%net-utils \
		%disk-utils
#
#min-yaud-stock: \
#%yaud-stock: min-prepare-yaud min-yaud-none
#	
#
#min-yaud-none: \
#%yaud-none: %bare-os \
#		%$(RELEASE) \
#		%linux-kernel \
#		%busybox \
#		%libz \
#		%$(GREP)
#	

#
# STD-YAUD
#
yaud-kati: std-yaud-stock

std-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none %stock

std-yaud-none: \
%yaud-none: \
		%bare-os \
		%misc-tools \
		%linux-kernel \
		%net-utils \
		%disk-utils

#
# MAX-YAUD
#
usb-kati: max-yaud-stock

max-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none %stock

max-yaud-none: \
%yaud-none: \
		%bare-os \
		%misc-tools \
		%$(UDEV) \
		%$(HOTPLUG) \
		%linux-kernel \
		%net-utils \
		%disk-utils
#
# EXTRAS
#
min-extras: \
	usb_modeswitch \
	pppd \
	modem-scripts \
	ntfs_3g \
	enigma2_openwebif \
	enigma2-plugins-sh4-networkbrowser \
	$(addsuffix -openpli,$(openpli_plugin_distlist)) \
	wireless_tools
	
all-extras: \
	usb_modeswitch \
	pppd \
	modem-scripts \
	oscam \
	enigma2-plugins \
	xupnpd \
	ntfs_3g \
	wireless_tools \
	enigma2-skins-sh4 \
	ntpclient \
	udpxy \
	package-index

#
# FLASH IMAGE
#

flash-enigma2-pli-nightly: yaud-enigma2-pli-nightly
	echo "Create image"
	$(if $(SPARK)$(SPARK7162), \
	cd $(prefix)/../flash/spark && \
		echo -e "1\n1" | ./spark.sh \
	)