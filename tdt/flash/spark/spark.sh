CURDIR=`pwd`
BASEDIR=$CURDIR/../..


TUFSBOXDIR=$BASEDIR/tufsbox
#CDKDIR=$BASEDIR/cvs/cdk
RELASEDIR=$BASEDIR/relase

SCRIPTDIR=$CURDIR/scripts
TMPDIR=$CURDIR/tmp
TMPFWDIR=$TMPDIR/ROOT
TMPBOOTDIR=$TMPFWDIR/boot

OUTDIR=$CURDIR/out

if [  -e $TMPDIR ]; then
  rm -rf $TMPDIR/*
else
  mkdir $TMPDIR
fi

mkdir $TMPFWDIR
echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "BASEDIR      = $BASEDIR"
echo "TMPDIR       = $TMPDIR"
echo "TMPFWDIR     = $TMPFWDIR"
echo "TMPBOOTDIR   = $TMPBOOTDIR"
echo "RELASEDIR    = $RELASEDIR"


echo "This script creates flashable images Spark"
echo "Author: Schischu modified by schpuntik"
echo "Date: 01-31-2011"
echo "-----------------------------------------------------------------------"
echo "It's expected that a images was already build prior to this execution!"
echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found targets:"
if [  -e $TUFSBOXDIR/release ]; then
  echo "   1) Prepare Enigma2"
fi
if [  -e $TUFSBOXDIR/release_neutrino ]; then
  echo "   2) Prepare Neutrino"
fi

read -p "Select target (1-2)? "
case "$REPLY" in
	1)  echo "Preparing Enigma2 Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release $TMPROOTDIR $TMPFWDIR $;;
	2)  echo "Preparing Neutrino Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release_neutrino $TMPROOTDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 2;;
esac
echo "Root prepared"
#echo "Checking if flashtool mup exists..."
#if [ ! -e $CURDIR/mup ]; then
#  echo "Flashtool mup is missing, trying to compile it..."
#  cd $CURDIR/mup.src
#  $CURDIR/mup.src/compile.sh
#  mv $CURDIR/mup.src/mup $CURDIR/mup
#  cd $CURDIR
#  if [ ! -e $CURDIR/mup ]; then
#    echo "Compiling failed! Exiting..."
#    exit 3
#  else
#    echo "Compiling successfull"
#  fi
#fi
#echo "Flashtool mup exists"
echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found flashtarget:"
echo "   1) KERNEL vor JFFS2"
echo "   2) KERNEL vor YAFFS2"
#echo "   3) KERNEL"
#echo "   4) FW"
read -p "Select flashtarget (1-4)? "
case "$REPLY" in
	1)  echo "Creating KERNEL jffs2..."
		$SCRIPTDIR/flash_part_kernel.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPBOOTDIR $TMPFWDIR;;
	2)  echo "Creating KERNEL yaffs2..."
		$SCRIPTDIR/flash_part_yaffs.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPBOOTDIR $TMPFWDIR ;;
#	3)  echo "Creating KERNEL..."
#		$SCRIPTDIR/flash_part_kernel.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR;;
#	4)  echo "Creating FW..."
#		$SCRIPTDIR/flash_part_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 3;;
esac
clear
#echo "-----------------------------------------------------------------------"
#AUDIOELFSIZE=`stat -c %s $TMPFWDIR/audio.elf`
#VIDEOELFSIZE=`stat -c %s $TMPFWDIR/video.elf`
#if [ $AUDIOELFSIZE == "0" ]; then
#  echo "!! WARNING: AUDIOELF SIZE IS ZERO !!!"
#  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
#  echo "-----------------------------------------------------------------------"
#fi
#if [ $VIDEOELFSIZE == "0" ]; then
#  echo "!!! WARNING: VIDEOELF SIZE IS ZERO !!!"
#  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
#  echo "-----------------------------------------------------------------------"
#fi
#if [ ! -e $TMPROOTDIR/dev/mtd0 ]; then
#  echo "!!! WARNING: DEVS ARE MISSING !!!"
#  echo "IF YOUR ARE CREATING THE ROOT PART MAKE SURE THAT YOU USE A CORRECT DEV.TAR"
#  echo "-----------------------------------------------------------------------"
#fi

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
