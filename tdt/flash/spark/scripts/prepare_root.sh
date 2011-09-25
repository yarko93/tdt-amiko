#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPFWDIR=$4

cp -a $RELEASEDIR/* $TMPROOTDIR

#mv $TMPROOTDIR/boot/uImage $CURDIR/uImage


#echo "/dev/mtdblock3	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab
#echo "/dev/mtdblock5	/root	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab


if [  -e $CURDIR/extras/dev_ufs912.tar.gz ]; then
tar -xzf $CURDIR/extras/dev_ufs912.tar.gz -C $TMPROOTDIR/dev/
fi
  rm -rf  $TMPROOTDIR/dev/dvb/adapter0/ca1 
	  cd $TMPROOTDIR/dev/dvb/adapter0 
	   pwd
	  ln -s   ca0 $TMPROOTDIR/dev/dvb/adapter0/ca1