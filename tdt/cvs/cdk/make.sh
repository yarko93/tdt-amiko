#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-28)"
 echo "Parameter 2: kernel (1-12)"
 echo "Parameter 3: debug (Y/N)"
 echo "Parameter 4: player (1-3)"
 echo "Parameter 5: Multicom (1-3)"
 echo "Parameter 6: Media Framework (1-2)"
 echo "Parameter 7: External LCD support (1-2)"
 echo "Parameter 8: VDR (1-3)"
 echo "Parameter 9: Graphic Framework (1-2)"
 exit
fi

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
export PATH=/usr/sbin:/sbin:$PATH

CONFIGPARAM=" \
 --enable-maintainer-mode \
 --prefix=$KATIDIR/tufsbox \
 --with-cvsdir=$KATIDIR/cvs \
 --with-customizationsdir=$KATIDIR/custom \
 --with-archivedir=$HOME/Archive \
 --enable-ccache"

##############################################

echo "
  _______                     _____              _     _         _
 |__   __|                   |  __ \            | |   | |       | |
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/

"

##############################################

# config.guess generates different answers for some packages
# Ensure that all packages use the same host by explicitly specifying it.

# First obtain the triplet
AM_VER=`automake --version | awk '{print $NF}' | grep -oEm1 "^[0-9]+.[0-9]+"`
host_alias=`/usr/share/automake-${AM_VER}/config.guess`

# Then undo Suse specific modifications, no harm to other distribution
case `echo ${host_alias} | cut -d '-' -f 1` in
  i?86) VENDOR=pc ;;
  *   ) VENDOR=unknown ;;
esac
host_alias=`echo ${host_alias} | sed -e "s/suse/${VENDOR}/"`

# And add it to the config parameters.
CONFIGPARAM="${CONFIGPARAM} --host=${host_alias} --build=${host_alias}"

##############################################

echo "Targets:"
echo " 1) SpiderBox HL-101"
echo " 2) SPARK"
echo " 3) SPARK7162"

case $1 in
	[1-3]) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-3)? ";;
esac

case "$REPLY" in
	 7) TARGET="--enable-hl101";;
	18) TARGET="--enable-spark";;
	20) TARGET="--enable-spark7162";;
	 *) TARGET="--enable-spark";;
esac
CONFIGPARAM="$CONFIGPARAM $TARGET"


##############################################

echo -e "\nKernel:"
echo " Maintained:"
echo "   1) STM 24 P0207"
echo "   2) STM 24 P0209"
echo " Experimental:"
echo "   3) STM 24 P0210 (Recommended)"
echo "   4) STM 24 P0211"
case $2 in
        [1-4]) REPLY=$2
        echo -e "\nSelected kernel: $REPLY\n"
        ;;
        *)
        read -p "Select kernel (1-4)? ";;
esac

case "$REPLY" in
	1)  KERNEL="--enable-stm24 --enable-p0207";STMFB="stm24";;
	2) KERNEL="--enable-stm24 --enable-p0209";STMFB="stm24";;
	3) KERNEL="--enable-stm24 --enable-p0210";STMFB="stm24";;
	4) KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
	*)  KERNEL="--enable-stm24 --enable-p0210";STMFB="stm24";;
esac
CONFIGPARAM="$CONFIGPARAM $KERNEL"

##############################################
if [ "$3" ]; then
 REPLY="$3"
 echo "Activate debug (y/N)? "
 echo -e "\nSelected option: $REPLY\n"
else
 REPLY=N
 read -p "Activate debug (y/N)? "
fi
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"

##############################################

cd ../driver/
echo "# Automatically generated config: don't edit" > .config
echo "#" >> .config
echo "export CONFIG_ZD1211REV_B=y" >> .config
echo "export CONFIG_ZD1211=n"		>> .config
cd -

##############################################

echo -e "\nPlayer:"
echo "   1) Player 179"
echo "   2) Player 191 (Recommended)"
case $4 in
        [1-2]) REPLY=$4
        echo -e "\nSelected player: $REPLY\n"
        ;;
        *)
        read -p "Select player (1-2)? ";;
esac

case "$REPLY" in
	1) PLAYER="--enable-player179"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi

       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_179 player2
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_179 player2
       echo "export CONFIG_PLAYER_179=y" >> .config
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -
    ;;
	2) PLAYER="--enable-player191"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi

       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_179 player2
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_191 player2
       echo "export CONFIG_PLAYER_191=y" >> .config
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -
    ;;
	*) PLAYER="--enable-player191"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi

       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_179 player2
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_191 player2
       echo "export CONFIG_PLAYER_191=y" >> .config
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -
    ;;
esac

##############################################

echo -e "\nMulticom:"
echo "   1) Multicom 3.2.2     (Recommended for Player179)"
echo "   3) Multicom 3.2.4     (Recommended for Player191)"
case $5 in
        [1-3]) REPLY=$5
        echo -e "\nSelected multicom: $REPLY\n"
        ;;
        *)
        read -p "Select multicom (1-3)? ";;
esac

case "$REPLY" in
	1) MULTICOM="--enable-multicom322"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       cd -

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       echo "export CONFIG_MULTICOM322=y" >> .config
       cd -
    ;;
	2 | 3) MULTICOM="--enable-multicom324"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s ../multicom-3.2.4/include multicom
       cd -

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.4 multicom
       echo "export CONFIG_MULTICOM324=y" >> .config
       cd -
    ;;
	*) MULTICOM="--enable-multicom322";;
esac

##############################################

echo -e "\nMedia Framework:"
echo "   1) eplayer3  (Recommended for Enigma1/2, Neutrino/HD, VDR)"
echo "   2) gstreamer (Recommended for Enigma2 / PLI, XBMC)"
case $6 in
        [1-2]) REPLY=$6
        echo -e "\nSelected media framwork: $REPLY\n"
        ;;
        *)
        read -p "Select media framwork (1-2)? ";;
esac

case "$REPLY" in
	1) MEDIAFW="";;
	2) MEDIAFW="--enable-mediafwgstreamer";;
	*) MEDIAFW="";;
esac

##############################################

echo -e "\nExternal LCD support:"
echo "   1) No external LCD"
echo "   2) graphlcd for external LCD"
case $7 in
        [1-2]) REPLY=$7
        echo -e "\nSelected LCD support: $REPLY\n"
        ;;
        *)
        read -p "Select external LCD support (1-2)? ";;
esac

case "$REPLY" in
	1) EXTERNAL_LCD="";;
	2) EXTERNAL_LCD="--enable-externallcd";;
	*) EXTERNAL_LCD="";;
esac

##############################################


##############################################

echo -e "\nVDR-1.7.XX:"
echo "   1) No"
echo "   2) VDR-1.7.22"
echo "   3) VDR-1.7.27"
case $8 in
	[1-3]) REPLY=$8
        echo -e "\nSelected VDR-1.7.XX: $REPLY\n"
        ;;
        *)
        read -p "Select VDR-1.7.XX (1-3)? ";;
esac
case "$REPLY" in
	1) VDR=""
       cd ../apps/vdr/
       if [ -L vdr ]; then
          rm vdr
       fi
       cd -
    ;;
	2) VDR="--enable-vdr1722"
       cd ../apps/vdr/
       if [ -L vdr ]; then
          rm vdr
       fi

       ln -s vdr-1.7.22 vdr
       cd -
    ;;
    	3) VDR="--enable-vdr1727"
       cd ../apps/vdr/
       if [ -L vdr ]; then
          rm vdr
       fi

       ln -s vdr-1.7.27 vdr
       cd -
    ;;
	*) VDR="--enable-vdr1722";;
esac

##############################################

echo -e "\nGraphic Framework:"
echo "   1) Framebuffer (Enigma1/2, Neutrino1/HD, VDR)"
echo "   2) DirectFB    (XBMC for UFS912, UFS913, Atevio7500)"
case $9 in
        [1-2]) REPLY=$9
        echo -e "\nSelected Graphic Framework: $REPLY\n"
        ;;
        *)
        read -p "Select Graphic Framework (1-2)? ";;
esac

case "$REPLY" in
	1) GFW="";;
	2) GFW="--enable-graphicfwdirectfb";;
	*) GFW="";;
esac

##############################################

CONFIGPARAM="$CONFIGPARAM $PLAYER $MULTICOM $MEDIAFW $EXTERNAL_LCD $VDR $GFW"

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

#Dagobert: I find it sometimes useful to know
#what I have build last in this directory ;)
echo $CONFIGPARAM >lastChoice

echo "-----------------------"
echo "Your build enivroment is ready :-)"
echo "Your next step could be:"
echo "make yaud-enigma2-nightly"
echo "make yaud-enigma2-pli-nightly"
echo "make yaud-enigma2-pli-nightly-full"
echo "make yaud-neutrino-hd2"
echo "make yaud-vdr"
echo "make yaud-xbmc-nightly"
echo "-----------------------"