#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
export PATH=/usr/sbin:/sbin:$PATH
CONFIGPARAM=`cat lastChoice`


echo "
                                                db        MM°°°Mq.          MM°°°Mq.
                                               ;MM        MM    MM.         MM    MM
 ,pW°Wq.    MMooMAo.  .gP°Ya    MMpMMMb.      ,V^MM.      MM   ,M9          MM   ,M9
6W'    Wb   MM    Wb ,M'   Yb   MM    MM     ,M   MM      MMmmdM9           MMmmdM9  
8M     M8   MM    M8 8M°°°°°°   MM    MM     AbmmmqMA     MM  YM.   mmmmm   MM       
YA.   ,A9   MM   ,AP YM.    ,   MM    MM    A'     VML    MM    Mb          MM       
  Ybmd9     MMbmmd'    Mbmmd   JMML  JMML  AMA     AMMA  JMML   JMM        JMML      
            MM                                                                       
           JMML"

echo && \
echo "Performing autogen.sh..." && \
echo "------------------------" && \
./autogen.sh && \
echo && \
echo "Performing configure..." && \
echo "-----------------------" && \
echo && \
./configure $CONFIGPARAM

echo "-----------------------"
echo "Your build enivroment is ready :-)"
echo "Your next step could be:"
case "$CONFIGPARAM" in
        *--enable-e2pd*)
        echo "make yaud-enigma2-pli-nightly"
        echo "make yaud-enigma2-pli-nightly-full";;
        *--enable-e2d*)
        echo "make yaud-enigma2-nightly";;
        *--enable-nhd*)
        echo "make yaud-neutrino-hd2";;
        *--enable-xbd*)
        echo "make yaud-xbmc-nightly";;
        *--enable-vdr*)
        echo "make yaud-vdr";;
        *)
        echo "Run ./make.sh an select Image!";;
esac
echo "-----------------------"
