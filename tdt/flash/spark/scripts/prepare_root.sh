#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4

cp -a $RELEASEDIR/* $TMPROOTDIR

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage


#<<<<<<< HEAD
# --- ROOT ---
#if [  -e $CURDIR/extras/dev_ufs910.tar.gz ]; then
#  sudo tar -xzf $CURDIR/extras/dev_ufs910.tar.gz -C $TMPROOTDIR/dev/
#fi
#rm -rf  $TMPROOTDIR/dev/dvb/adapter0/ca1 
#	  cd $TMPROOTDIR/dev/dvb/adapter0 
#	   pwd
#	  ln -s   ca0 $TMPROOTDIR/dev/dvb/adapter0/ca1
#=======
# --- ROOT ---i
cd $TMPROOTDIR/dev/
MAKEDEV="sudo $TMPROOTDIR/sbin/MAKEDEV -p $TMPROOTDIR/etc/passwd -g $TMPROOTDIR/etc/group"
${MAKEDEV} std
${MAKEDEV} fd
${MAKEDEV} hda hdb
${MAKEDEV} sda sdb sdc sdd
${MAKEDEV} scd0 scd1
${MAKEDEV} st0 st1
${MAKEDEV} sg
${MAKEDEV} ptyp ptyq
${MAKEDEV} console
${MAKEDEV} ttyAS0 ttyAS1 ttyAS2 ttyAS3
${MAKEDEV} lp par audio video fb rtc lirc st200 alsasnd mme bpamem
${MAKEDEV} ppp busmice
${MAKEDEV} input i2c mtd
${MAKEDEV} dvb
cd -
#>>>>>>> duckbox/master

