#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPFWDIR=$4
NFSDIR=$6
TARGET=$7

if [  -e $TARGET ]; then
  rm -rf $TARGET/*
else
  mkdir $TARGET
fi

cp -a $RELEASEDIR/* $TARGET


if [  -e $CURDIR/extras/dev_ufs912.tar.gz ]; then
tar -xzf $CURDIR/extras/dev_ufs912.tar.gz -C $TARGET/dev/
fi
  rm -rf  $TARGET/dev/dvb/adapter0/ca1 
	  cd $TARGET/dev/dvb/adapter0 
	   pwd
	  ln -s   ca0 $TARGET/dev/dvb/adapter0/ca1