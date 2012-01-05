#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4

cp -a $RELEASEDIR/* $TMPROOTDIR

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage


# --- ROOT ---
if [  -e $CURDIR/extras/dev_ufs910.tar.gz ]; then
  sudo tar -xzf $CURDIR/extras/dev_ufs910.tar.gz -C $TMPROOTDIR/dev/
fi
rm -rf  $TMPROOTDIR/dev/dvb/adapter0/ca1 
	  cd $TMPROOTDIR/dev/dvb/adapter0 
	   pwd
	  ln -s   ca0 $TMPROOTDIR/dev/dvb/adapter0/ca1

