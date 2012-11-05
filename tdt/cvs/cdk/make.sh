#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-3)"
 echo "Parameter 2: kernel (1-4)"
 echo "Parameter 3: debug (Y/N)"
 echo "Parameter 4: player (1-2)"
 echo "Parameter 5: Media Framework (1-2)"
 echo "Parameter 6: External LCD support (1-2)"
 echo "Parameter 7: Image  (1-5)"
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
echo "			     ___  ______         ______		
                            / _ \ | ___ \        | ___ \	
  ___   _ __    ___  _ __  / /_\ \| |_/ / ______ | |_/ /	
 / _ \ | '_ \  / _ \| '_ \ |  _  ||    / |______||  __/	
| (_) || |_) ||  __/| | | || | | || |\ \         | |	
 \___/ | .__/  \___||_| |_|\_| |_/\_| \_|        \_|	
       | |	
       |_|  "
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
	1) TARGET="--enable-hl101";;
	2) TARGET="--enable-spark";;
	3) TARGET="--enable-spark7162";;
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
	1) KERNEL="--enable-stm24 --enable-p0207";STMFB="stm24";;
	2) KERNEL="--enable-stm24 --enable-p0209";STMFB="stm24";;
	3) KERNEL="--enable-stm24 --enable-p0210";STMFB="stm24";;
	4) KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
	*) KERNEL="--enable-stm24 --enable-p0210";STMFB="stm24";;
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
cd - &>/dev/null

##############################################

echo -e "\nPlayer:"
echo "   1) Player 179 & Multicom 3.2.2 "
echo "   2) Player 191 & Multicom 3.2.4 (Recommended)"
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
       cd - &>/dev/null

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_179 player2
       echo "export CONFIG_PLAYER_179=y" >> .config
       cd - &>/dev/null

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd - &>/dev/null
       MULTICOM="--enable-multicom322"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       cd - &>/dev/null

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       echo "export CONFIG_MULTICOM322=y" >> .config
       cd - &>/dev/null
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
       cd - &>/dev/null

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_191 player2
       echo "export CONFIG_PLAYER_191=y" >> .config
       cd - &>/dev/null

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd - &>/dev/null
       MULTICOM="--enable-multicom324"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s ../multicom-3.2.4/include multicom
       cd - &>/dev/null

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.4 multicom
       echo "export CONFIG_MULTICOM324=y" >> .config
       cd - &>/dev/null
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
       cd - &>/dev/null

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_191 player2
       echo "export CONFIG_PLAYER_191=y" >> .config
       cd - &>/dev/null

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd - &>/dev/null
       MULTICOM="--enable-multicom324"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s ../multicom-3.2.4/include multicom
       cd - &>/dev/null

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.4 multicom
       echo "export CONFIG_MULTICOM324=y" >> .config
       cd - &>/dev/null
    ;;
esac

##############################################

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

echo -e "\nSelect Image (Enigma2/PLI, Neutrino, XBMC, VDR): "
echo "   1) Enigma2PLI"
echo "   2) Enigma2"
echo "   3) Neutrino"
echo "   4) XBMC"
echo "   5) VDR"
case $8 in
        [1-5]) REPLY=$8
        echo -e "\nSelected Image: $REPLY\n"
        ;;
        *)
        read -p "Select Image (1-5)? ";;
esac
		if [ "$REPLY" == 1 ]; then
		    echo -e "\nChoose enigma2 OpenPli revision:"
			echo "   0) Newest (Can fail due to outdated patch)"
			echo "   1) Sat, 17 Mar 2012 19:51 - E2 OpenPli 945aeb939308b3652b56bc6c577853369d54a537"
			echo "   2) Sat, 18 May 2012 15:26 - E2 OpenPli 839e96b79600aba73f743fd39628f32bc1628f4c"
			echo "   3) Mon, 20 Aug 2012 16:00 - E2 OpenPli 51a7b9349070830b5c75feddc52e97a1109e381e"
			echo "   4) Fri, 24 Aug 2012 23:42 - E2 OpenPli 002b85aa8350e9d8e88f75af48c3eb8a6cdfb880"
			echo "   5) Sun, 16 Sep 2012 14:53 - E2 OpenPli a869076762f6e24305d6a58f95c3918e02a1442a"
			echo "   6) AR-P - E2 OpenPli branch testing"
			echo "   7) AR-P - E2 OpenPli branch last"
			echo "   8) AR-P - E2 OpenPli branch master"
		    read -p "Select enigma2 OpenPli revision (0-8):"
			
			case "$REPLY" in
			0) IMAGE="--enable-e2pd0";;
			1) IMAGE="--enable-e2pd1";;
			2) IMAGE="--enable-e2pd2";;
			3) IMAGE="--enable-e2pd3";;
			4) IMAGE="--enable-e2pd4";;
			5) IMAGE="--enable-e2pd5";;
			6) IMAGE="--enable-e2pd6";;
			7) IMAGE="--enable-e2pd7";;
			8) IMAGE="--enable-e2pd8";;
			*) IMAGE="--enable-e2pd8";;
			esac
		elif [ "$REPLY" == 2 ]; then
		    echo -e "\nChoose enigma2 revisions:"
			echo "	0) Newest (Can fail due to outdated patch)"
			echo "	1) Sat, 29 Mar 2011 13:49 - E2 V3.0 e013d09af0e010f15e225a12dcc217abc052ee19"
			echo "	2) inactive"
			echo "	3) inactive"
			echo "	4) inactive"
			echo "	5) Fri,  5 Nov 2010 00:16 - E2 V2.4 libplayer3 7fd4241a1d7b8d7c36385860b24882636517473b"
			echo "	6) Wed,  6 Jul 2011 11:17 - E2 V3.1 gstreamer  388dcd814d4e99720cb9a6c769611be4951e4ad4"
			echo "	7) Current E2 gitgui arp-team"
			echo "	8) Current E2 gitgui arp-team no gstreamer"
		    read -p "Select enigma2 revision (0-8):"
			case "$REPLY" in
			0) IMAGE="--enable-e2d0";;
			1) IMAGE="--enable-e2d1";;
			2) IMAGE="--enable-e2d2";;
			3) IMAGE="--enable-e2d3";;
			4) IMAGE="--enable-e2d4";;
			5) IMAGE="--enable-e2d5";;
			6) IMAGE="--enable-e2d6";;
			7) IMAGE="--enable-e2d7";;
			8) IMAGE="--enable-e2d8";;
			*) IMAGE="--enable-e2d8";;
			esac
		elif [ "$REPLY" == 3 ]; then
		    echo -e "\nChoose Neutrino revisions:"
			echo "	0) current inactive... comming soon"
			echo "	1) current inactive... comming soon"
			echo "	2) current inactive... comming soon"
		    read -p "Select Neutrino revision (0-2):"
			case "$REPLY" in
			0) IMAGE="--enable-nhd0";;
			1) IMAGE="--enable-nhd1";;
			2) IMAGE="--enable-nhd2";;
			*) IMAGE="--enable-nhd0";;
			esac
		elif [ "$REPLY" == 4 ]; then
		    echo -e "\nChoose XBMC revisions:"
			echo "	0) Newest (Can fail due to outdated patch)"
			echo "	1) Sat, 14 Apr 2012 12:36 - 460e79416c5cb13010456794f36f89d49d25da75"
			echo "	2) Sun, 10 Jun 2012 13:53 - 327710767d2257dad27e3885effba1d49d4557f0"
			echo "	3) Fr,  31 Aug 2012 22:34 - Frodo_alpha5 - 12840c28d8fbfd71c26be798ff6b13828b05b168"
			echo "	4) current inactive... comming soon"
		    read -p "Select XBMC revision (0-2):"
			case "$REPLY" in
			0) IMAGE="--enable-xbd0" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			1) IMAGE="--enable-xbd1" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			2) IMAGE="--enable-xbd2" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			3) IMAGE="--enable-xbd3" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			4) IMAGE="--enable-xbd4" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			*) IMAGE="--enable-xbd0" GFW="--enable-graphicfwdirectfb" MEDIAFW="--enable-mediafwgstreamer";;
			esac
		elif  [ "$REPLY" == 5 ]; then
		    echo -e "\nChoose VDR revisions"
			echo "   1) VDR-1.7.22"
			echo "   2) VDR-1.7.27"
		    read -p "Select VDR-1.7.XX (1-2)? "
			case "$REPLY" in
			1) IMAGE="--enable-vdr1722"
			    cd ../apps/vdr/
			if [ -L vdr ]; then
			    rm vdr
			fi
			    ln -s vdr-1.7.22 vdr
			cd -
			;;
			2) IMAGE="--enable-vdr1727"
			    cd ../apps/vdr/
			if [ -L vdr ]; then
			    rm vdr
			fi
			    ln -s vdr-1.7.27 vdr
			cd -
			;;
			*) IMAGE="--enable-vdr1722";;
			esac
		fi

##############################################

if [[ "$IMAGE" == --enable-e2* ]]; then
  echo -e "\nMedia Framework:"
  echo "   1) eplayer3 "
  echo "   2) gstreamer "
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
fi
##############################################

CONFIGPARAM="$CONFIGPARAM $PLAYER $MULTICOM $MEDIAFW $EXTERNAL_LCD $IMAGE $GFW"

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
case "$IMAGE" in
        --enable-e2pd*)
        echo "make yaud-enigma2-pli-nightly"
        echo "make yaud-enigma2-pli-nightly-full";;
        --enable-e2d*)
        echo "make yaud-enigma2-nightly";;
        --enable-nhd*)
        echo "make yaud-neutrino-hd2";;
        --enable-xbd*)
        echo "make yaud-xbmc-nightly";;
        --enable-vdr*)
        echo "make yaud-vdr";;
        *)
        echo "Run ./make.sh again an select Image!";;
esac   
echo "-----------------------"
