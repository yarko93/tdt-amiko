#!/bin/sh
CURDIR=`pwd`
NRELDIR='../../tufsbox/release_vdrdev2'
CHANGEDIR='../../tufsbox'
TARGET=`cat $CURDIR/lastChoice | awk -F '--enable-' '{print $6}' | cut -d ' ' -f 1`
DIST=`cat $CURDIR/lastChoice | awk -F '--enable-' '{print $4}' | cut -d ' ' -f 1`
BUILDDIR='../../cvs/cdk'


cp -RP ~/enigma2-amiko/vdr/* $NRELDIR/
rm $NRELDIR/lib/modules/pti.ko
if [ $TARGET == p0210 ]; [ $DIST == spark ]; then
  mv $NRELDIR/lib/modules/pti_210.ko $NRELDIR/lib/modules/pti.ko
  rm $NRELDIR/lib/modules/pti_209.ko $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti_207s2.ko $NRELDIR/lib/modules/pti_123.ko
elif [ $TARGET == p0209 ]; [ $DIST == spark ]; then
  mv $NRELDIR/lib/modules/pti_209.ko $NRELDIR/lib/modules/pti.ko
  rm $NRELDIR/lib/modules/pti_210.ko $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti_207s2.ko $NRELDIR/lib/modules/pti_123.ko
elif [ $TARGET == p0207 ]; [ $DIST == spark ]; then
    mv $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti.ko
    rm $NRELDIR/lib/modules/pti_209.ko $NRELDIR/lib/modules/pti_210.ko $NRELDIR/lib/modules/pti_207s2.ko $NRELDIR/lib/modules/pti_123.ko
elif [ $TARGET == p0207 ]; [ $DIST == spark7162 ]; then
    mv $NRELDIR/lib/modules/pti_207s2.ko $NRELDIR/lib/modules/pti.ko
    rm $NRELDIR/lib/modules/pti_209.ko $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti_210.ko $NRELDIR/lib/modules/pti_123.ko
elif [ $TARGET == p0123 ]; [ $DIST == spark ]; then
    mv $NRELDIR/lib/modules/pti_123.ko $NRELDIR/lib/modules/pti.ko
    rm $NRELDIR/lib/modules/pti_209.ko $NRELDIR/lib/modules/pti_207.ko $NRELDIR/lib/modules/pti_207s2.ko $NRELDIR/lib/modules/pti_210.ko
fi
echo "TARGET       = $TARGET"
echo "DIST       = $DIST"
exit
echo "--- Erledigt ---"
exit
