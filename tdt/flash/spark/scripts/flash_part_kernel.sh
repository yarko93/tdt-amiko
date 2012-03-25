#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPBOOTDIR=$4
TMPFWDIR=$5

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPBOOTDIR   = $TMPBOOTDIR"
echo "TMPFWDIR     = $TMPFWDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
SUMTOOL=$TUFSBOXDIR/host/bin/sumtool
#MUP=$CURDIR/mup

OUTFILE=$OUTDIR/e2jffs2.img
OUTFILE2=$OUTDIR/e2jffs2.img.sum 

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
fi

cp $TMPBOOTDIR/uImage $OUTDIR/uImage

# Create a kathrein update file for fw's 
# Offset on NAND Disk = 0x00400000
$MKFSJFFS2 -l -e0x20000 -n -pv -d $TMPFWDIR  -o $OUTFILE << EOF
$SUMTOOL -i $OUTFILE -o $OUTFILE2

EOF

#$OUTDIR/* zip $OUTFILE.zip $OUTDIR