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
echo config.misc.epgcache_filename=/hdd/epg.dat >> $NRELDIR/etc/enigma2/settings
rm  $NRELDIR/usr/local/share/enigma2/keymap_*.xml
cp -RP ~/enigma2-amiko/enigma2/* $NRELDIR/
rm $NRELDIR/lib/modules/pti.ko
mv $NRELDIR/lib/modules/pti_123.ko $NRELDIR/lib/modules/pti.ko
#rm $NRELDIR/lib/modules/pti.ko
#mv $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti.ko
exit
echo "--- Erledigt ---"
exit
