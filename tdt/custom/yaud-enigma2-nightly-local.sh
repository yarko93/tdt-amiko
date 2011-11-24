#!/bin/sh
CURDIR=`pwd`
NRELDIR='../../tufsbox/release'
CHANGEDIR='../../tufsbox'
TARGET=`cat $CURDIR/lastChoice | awk -F '--enable-' '{print $5}' | cut -d ' ' -f 1`
BUILDDIR='../../cvs/cdk'

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
echo config.misc.epgcache_filename=/var/epg.dat >> $NRELDIR/etc/enigma2/settings
rm  $NRELDIR/usr/local/share/enigma2/keymap_*.xml
cp -RP ~/enigma2-amiko/enigma2/* $NRELDIR/
# make sure defines have not already been defined
#UBUNTU=
#FEDORA=
#SUSE=
# Try to detect the distribution
#if `which lsb_release > /dev/null 2>&1`; then 
#	case `lsb_release -s -i` in
#		Debian*) UBUNTU=1; USERS="su -c";;
#		Fedora*) FEDORA=1; USERS="sudo";;
#		SUSE*)   SUSE=1;   USERS="su";;
#		Ubuntu*) UBUNTU=1; USERS="sudo";;
#	esac
#fi
# Not detected by lsb_release, try release files
#if [ -z "$FEDORA$SUSE$UBUNTU" ]; then
#	if   [ -f /etc/redhat-release ]; then FEDORA=1; USERS="sudo"; 
#	elif [ -f /etc/fedora-release ]; then FEDORA=1; USERS="sudo"; 
#	elif [ -f /etc/SuSE-release ];   then SUSE=1; USERS="su";
#	elif [ -f /etc/debian_version ]; then UBUNTU=1; USERS="su -c";
#	fi
#fi

#function make_default() {
#	echo "Erstelle Standard /dev für alle Boxen..."
#	echo "${MAKEDEV} std" > $CURDIR/.fakeroot
#	echo "${MAKEDEV} bpamem" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} console" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} ttyAS0 ttyAS1 ttyAS2 ttyAS3" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} ttyusb" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} tun" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} sd" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} scd0 scd1" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} sg" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} st0 st1" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} ptyp ptyq ptmx" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} input i2c mtd" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} dvb mme" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} ppp busmice" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} fd" >> $CURDIR/.fakeroot
#	echo "${MAKEDEV} video" >> $CURDIR/.fakeroot
#	echo "ln -sf /dev/input/mouse0 mouse" >> $CURDIR/.fakeroot
#	echo "mkdir -p pts" >> $CURDIR/.fakeroot
#	echo "mkdir -p shm" >> $CURDIR/.fakeroot
#	echo "mknod -m 0666 fuse c 10 229" >> $CURDIR/.fakeroot
#	echo "mknod -m 0666 vfd c 147 0" >> $CURDIR/.fakeroot
#}

#function make_devs() {
#	rm -rf $CURDIR/tmpdev && rm -f $CURDIR/tempdevs.tar.gz && mkdir -p $CURDIR/tmpdev && cd $CURDIR/tmpdev
#	echo "tar czf $CURDIR/tempdevs.tar.gz ./" >> $CURDIR/.fakeroot
#	chmod 755 $CURDIR/.fakeroot && fakeroot -- $CURDIR/.fakeroot && rm -f $CURDIR/.fakeroot
#	cd ..
#	rm -rf $CURDIR/tmpdev
#	$USERS tar -xzf $CURDIR/tempdevs.tar.gz -C $NRELDIR/dev/ && rm $CURDIR/tempdevs.tar.gz
#}
#
#[ -e $NRELDIR/dev/ ] && [ -e $NRELDIR/dev/vfd ] && exit;

#case $TARGET in
#	hl101)
#		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
#		echo -e "Erstelle weitere /dev für $TARGET...\nSorry, $TARGET wird derzeit nicht unterstützt."
#		make_devs
#	;;
#	spark)
#		MAKEDEV="$CURDIR/root/sbin/MAKEDEV"
#		make_default
#		echo "Erstelle weitere /dev für $TARGET..."
#		echo "mknod -m 666 rc c 147 1" >> $CURDIR/.fakeroot
#		echo "mknod -m 666 sci0 c 169 0" >> $CURDIR/.fakeroot
#		make_devs
#	;;
#esac
#if [ -e $CHANGEDIR/release_with_dev ]; then
#	$USERS rm -rf $CHANGEDIR/release_with_dev
#fi
#mv $CHANGEDIR/release $CHANGEDIR/release_with_dev
#mv $CHANGEDIR/release_with_dev/lib/modules/stm24_pti.ko $CHANGEDIR/release_with_dev/lib/modules/pti.ko
#$CHANGEDIR/host/bin/mkfs.jffs2 -r $CHANGEDIR/release_with_dev/ -o ../../flash/spark/e2jffs2.img -e 0x20000 -pn
#	exit
#fi
echo "--- Erledigt ---"
exit
