#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPROOTDIR=$4
TMPFWDIR=$5

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"
echo "TMPFWDIR     = $TMPFWDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2  
#MUP=$CURDIR/mup

OUTFILE=$OUTDIR/e2jffs2.img 

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
fi

cp $TMPFWDIR/uImage $OUTDIR/uImage

# Create a kathrein update file for fw's 
# Offset on NAND Disk = 0x00400000
$MKFSJFFS2 -l -e0x20000 -n -pv -d $TMPROOTDIR  -o $OUTFILE << EOF

EOF

#$OUTDIR/* zip $OUTFILE.zip $OUTDIR