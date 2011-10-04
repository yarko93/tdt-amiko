#!/bin/sh
CURDIR=`pwd`
NRELDIR='../../tufsbox/release'
CHANGEDIR='../../tufsbox'
TARGET=`cat $CURDIR/lastChoice | awk -F '--enable-' '{print $5}' | cut -d ' ' -f 1`
BUILDDIR='../../cvs/cdk'

# originally created by schischu and konfetti
# fedora parts prepared by lareq
# fedora/suse/ubuntu scripts merged by kire pudsje (kpc)

# make sure defines have not already been defined
UBUNTU=
FEDORA=
SUSE=
# Try to detect the distribution
if `which lsb_release > /dev/null 2>&1`; then 
	case `lsb_release -s -i` in
		Debian*) UBUNTU=1; USERS="su -c";;
		Fedora*) FEDORA=1; USERS="sudo";;
		SUSE*)   SUSE=1;   USERS="su";;
		Ubuntu*) UBUNTU=1; USERS="sudo";;
	esac
fi
# Not detected by lsb_release, try release files
if [ -z "$FEDORA$SUSE$UBUNTU" ]; then
	if   [ -f /etc/redhat-release ]; then FEDORA=1; USERS="sudo"; 
	elif [ -f /etc/fedora-release ]; then FEDORA=1; USERS="sudo"; 
	elif [ -f /etc/SuSE-release ];   then SUSE=1; USERS="su";
	elif [ -f /etc/debian_version ]; then UBUNTU=1; USERS="su -c";
	fi
fi

function make_default() {
	echo "Erstelle Standard /dev für alle Boxen..."
	echo "${MAKEDEV} std" > $CURDIR/.fakeroot
	echo "${MAKEDEV} bpamem" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} console" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} ttyAS0 ttyAS1 ttyAS2 ttyAS3" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} ttyusb" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} tun" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} sd" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} scd0 scd1" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} sg" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} st0 st1" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} ptyp ptyq ptmx" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} input i2c mtd" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} dvb mme" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} ppp busmice" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} fd" >> $CURDIR/.fakeroot
	echo "${MAKEDEV} video" >> $CURDIR/.fakeroot
	echo "ln -sf /dev/input/mouse0 mouse" >> $CURDIR/.fakeroot
	echo "mkdir -p pts" >> $CURDIR/.fakeroot
	echo "mkdir -p shm" >> $CURDIR/.fakeroot
	echo "mknod -m 0666 fuse c 10 229" >> $CURDIR/.fakeroot
	echo "mknod -m 0666 vfd c 147 0" >> $CURDIR/.fakeroot
}

function make_devs() {
	rm -rf $CURDIR/tmpdev && rm -f $CURDIR/tempdevs.tar.gz && mkdir -p $CURDIR/tmpdev && cd $CURDIR/tmpdev
	echo "tar czf $CURDIR/tempdevs.tar.gz ./" >> $CURDIR/.fakeroot
	chmod 755 $CURDIR/.fakeroot && fakeroot -- $CURDIR/.fakeroot && rm -f $CURDIR/.fakeroot
	cd ..
	rm -rf $CURDIR/tmpdev
	$USERS tar -xzf $CURDIR/tempdevs.tar.gz -C $NRELDIR/dev/ && rm $CURDIR/tempdevs.tar.gz
}

[ -e $NRELDIR/dev/ ] && [ -e $NRELDIR/dev/vfd ] && exit;

case $TARGET in
	ufs910)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		make_devs
	;;
	flash_ufs910)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_flash"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		echo "ln -sf /dev/mtdblock2 root" >> $CURDIR/.fakeroot
		make_devs
	;;
	ufs912)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		make_devs
	;;
	ufs922)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	tf7700)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	fortis_hdbox)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		echo "mknod -m 666 rc c 147 1" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci0 c 253 0" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci1 c 253 1" >> $CURDIR/.fakeroot
		make_devs
	;;
	hl101)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	vip)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_mini)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_mini2)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_250hd)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_no_CI"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_9500hd)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_2000hd)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_no_CI"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	cuberevo_mini_fta)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_no_CI"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	homecast5101)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	octagon1008)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		echo "mknod -m 666 rc c 147 1" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci0 c 169 0" >> $CURDIR/.fakeroot
		make_devs
	;;
	spark)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		echo "mknod -m 666 rc c 147 1" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci0 c 169 0" >> $CURDIR/.fakeroot
		make_devs
	;;
	atevio7500)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
		make_default
		echo "Erstelle weitere /dev für $TARGET..."
		echo "mknod -m 666 rc c 147 1" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci0 c 169 0" >> $CURDIR/.fakeroot
		echo "mknod -m 666 sci1 c 169 1" >> $CURDIR/.fakeroot
		make_devs
	;;
	spark7162)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	ipbox9900)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_dual_tuner"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	ipbox99)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_no_CI"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	ipbox55)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV_no_CI"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
	hs7810a)
		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
	;;
esac
echo "src/gz AR-P http://amiko.sat-universum.de" | cat - $NRELDIR/etc/opkg/official-feed.conf > $NRELDIR/etc/opkg/official-feed
mv $NRELDIR/etc/opkg/official-feed $NRELDIR/etc/opkg/official-feed.conf
echo config.usage.blinking_display_clock_during_recording=true >> $NRELDIR/etc/enigma2/settings
echo config.usage.e1like_radio_mode=true >> $NRELDIR/etc/enigma2/settings
echo config.usage.multibouquet=true >> $NRELDIR/etc/enigma2/settings
echo config.usage.setup_level=expert >> $NRELDIR/etc/enigma2/settings
echo config.usage.quickzap_bouquet_change=true >> $NRELDIR/etc/enigma2/settings
echo config.usage.multiepg_ask_bouquet=true >> $NRELDIR/etc/enigma2/settings
echo config.skin.primary_skin=AmikoSkin/skin.xml >> $NRELDIR/etc/enigma2/settings
echo config.audio.volume=30 >> $NRELDIR/etc/enigma2/settings
echo "--- Erledigt ---"
exit
