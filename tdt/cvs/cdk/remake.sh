#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
export PATH=/usr/sbin:/sbin:$PATH
CONFIGPARAM=`cat lastChoice`
##############################################
echo "			     ___  ______         ______		
                            / _ \ | ___ \        | ___ \	
  ___   _ __    ___  _ __  / /_\ \| |_/ / ______ | |_/ /	
 / _ \ | '_ \  / _ \| '_ \ |  _  ||    / |______||  __/	
| (_) || |_) ||  __/| | | || | | || |\ \         | |	
 \___/ | .__/  \___||_| |_|\_| |_/\_| \_|        \_|	
       | |	
       |_|  "
##############################################
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
