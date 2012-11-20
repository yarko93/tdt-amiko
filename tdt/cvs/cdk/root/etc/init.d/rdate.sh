#! /bin/sh
#
# rdate.sh
#
# chkconfig: S 99 0
#

RDATE0=ntp1.ptb.de
RDATE=ntp2.fau.de
RDATE_ALT=ntp3.fau.de

#Date
echo "Running rdate -s $RDATE..."
rdate -s $RDATE || (echo "Running rdate -s $RDATE_ALT..."; rdate -s $RDATE_ALT)
#Test: rdate -p  ntp1.ptb.de
echo "Send time to FP "
/bin/fp_control -s `date +"%H:%M:%S %d-%m-%Y"`
#Time
#echo "Adjusting time..."
#ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

