#!/bin/bash
CURDIR=`pwd`
BASEDIR=$CURDIR/../..
TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk
SCRIPTDIR=$CURDIR/scripts
TMPDIR=$CURDIR/tmp
TMPROOTDIR=$TMPDIR/ROOT
TMPKERNELDIR=$TMPDIR/KERNEL
LAST=$CDKDIR/lastChoice
OUTDIR=$CURDIR/out

if [ -e $TMPDIR ]; then
  rm -rf $TMPDIR/*
fi
PLAY=`cat $LAST | awk -F '--enable-' '{print $9}' | cut -d ' ' -f 1`
if [ "$PLAY" == "mediafwgstreamer" ]; then
play='_gst'
else
play='_epl3'
fi
OE=`cat $LAST | awk -F '--enable-' '{print $8}' | cut -d ' ' -f 1`
if [ "$OE" == "py27" ]; then
oe='OE2.0'
else
oe='OE1.6'
fi
BOX=`cat $LAST | awk -F '--enable-' '{print $3}' | cut -d ' ' -f 1`
if [ "$BOX" == "spark" ]; then
box='_alien'
elif [ "$BOX" == "spark7162" ]; then
box='_alien2'
fi
KERN=`cat $LAST | awk -F '--enable-' '{print $5}' | cut -d ' ' -f 1`
if [ "$KERN" == "p0211" ]; then
kern='_211'
elif [ "$KERN" == "p0210" ]; then
kern='_210'
elif [ "$KERN" == "p0209" ]; then
kern='_209'
fi
echo "BOX          = $box "
echo "KERN         = $kern"
VERSION="OpenAR-P_$oe$kern$box$play-git-`date +%d-%m-%y`_`git describe --always`"

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "BASEDIR      = $BASEDIR"
echo "TMPDIR       = $TMPDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"
echo "VERSION      = $VERSION"
echo "This script creates flashable images Spark"
echo "Author: Schischu modified by schpuntik"
echo "Date: 01-31-2011"
echo "-----------------------------------------------------------------------"
echo "It's expected that a images was already build prior to this execution!"
echo "-----------------------------------------------------------------------"


mkdir $TMPDIR
mkdir $TMPROOTDIR
mkdir $TMPKERNELDIR

echo "This script creates flashable images for Spark"
echo "Author: Schischu"
echo "Date: 05-01-2012"
echo "-----------------------------------------------------------------------"
echo "It's expected that an image was already build prior to this execution!"
echo "-----------------------------------------------------------------------"

echo "-----------------------------------------------------------------------"

echo "Checking targets..."
echo "Found targets:"
if [  -e $TUFSBOXDIR/release ]; then
  echo "   1) Prepare Enigma2"
  REPLY="1"
fi
if [  -e $TUFSBOXDIR/release_neutrino ]; then
  echo "   2) Prepare Neutrino"
  REPLY="2"
fi
if [  -e $TUFSBOXDIR/release_vdr ]; then
  echo "   3) Prepare VDR"
 REPLY="3"
fi
# read -p "Select target (1-3)? "
case "$REPLY" in
	0)  echo "Skipping...";;
	1)  echo "Preparing Enigma2 Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release $TMPROOTDIR $TMPKERNELDIR;;
	2)  echo "Preparing Neutrino Root..."
		$SCRIPTDIR/prepare_root_neutrino.sh $CURDIR $TUFSBOXDIR/release_neutrino $TMPROOTDIR $TMPKERNELDIR;;
	3)  echo "Preparing VDR Root..."
		$SCRIPTDIR/prepare_root_vdr.sh $CURDIR $TUFSBOXDIR/release_vdr $TMPROOTDIR $TMPKERNELDIR;;
	*)  "Invalid Input! Exiting..."
		exit 2;;
esac
# echo "Root prepared"
# echo "Flashtool fup exists"
# echo "-----------------------------------------------------------------------"
# echo "Checking targets..."
# echo "Found flashtarget:"
# echo "   1) KERNEL with ROOT and FW"
# read -p "Select flashtarget (1)? "
# case "$REPLY" in
# 	1)  echo "Creating KERNEL with ROOT and FW..."
		$SCRIPTDIR/flash_part_w_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPROOTDIR $VERSION
# 	;;
# 	*)  "Invalid Input! Exiting..."
# 		exit 3;;
# esac
# clear
echo "-----------------------------------------------------------------------"
AUDIOELFSIZE=`stat -c %s $TMPROOTDIR/boot/audio.elf`
VIDEOELFSIZE=`stat -c %s $TMPROOTDIR/boot/video.elf`
if [ $AUDIOELFSIZE == "0" ]; then
  echo "!!! WARNING: AUDIOELF SIZE IS ZERO !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo "-----------------------------------------------------------------------"
fi
if [ $VIDEOELFSIZE == "0" ]; then
  echo "!!! WARNING: VIDEOELF SIZE IS ZERO !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo "-----------------------------------------------------------------------"
fi
if [ ! -e $TMPROOTDIR/dev/mtd0 ]; then
  echo "!!! WARNING: DEVS ARE MISSING !!!"
  echo "IF YOUR ARE CREATING THE ROOT PART MAKE SURE THAT YOU USE A CORRECT DEV.TAR"
  echo "-----------------------------------------------------------------------"
fi


echo ""
echo ""
echo ""
echo "-----------------------------------------------------------------------"
echo "Flashimage created:"
echo `ls $OUTDIR`

echo "-----------------------------------------------------------------------"
echo "To flash the created image copy the *.img file to"
echo "your usb drive in the subfolder /enigma2/"
echo ""
echo "To flash the created image rename the *.img file to e2jffs2.img and "
echo "copy it and the uImage to the enigma2 folder (/enigma2) of your usb drive."
echo "Before flashing make sure that enigma2 is the default system on your box."
echo "To set enigma2 as your default system press OK for 5 sec on your box "
echo "while the box is starting. As soon as \"FoYc\" is being displayed press"
echo "DOWN (v) on your box to select \"ENIG\" and press OK to confirm"
echo "To start the flashing process press OK for 5 sec on your box "
echo "while the box is starting. As soon as \"Fact\" is being displayed press"
echo "RIGHT (->) on your box to start the update"
echo ""
