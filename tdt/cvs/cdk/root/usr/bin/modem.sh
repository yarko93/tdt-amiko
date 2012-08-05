#!/bin/sh

# echo $1 $2 $3 $4 >> /tmp/modem.log

. /etc/modem.conf

[ -z "$MODEMTYPE" ] && MODEMTYPE=0
[ -z "$MODEMPORT" ] && MODEMPORT="ttyUSB0"
[ -z "$MODEMSPEED" ] && MODEMSPEED=""
[ -z "$APN" ] && APN="internet"
[ -z "$MODEMUSERNAME" ] && MODEMUSERNAME=""
[ -z "$MODEMPASSWORD" ] && MODEMPASSWORD=""
[ -z "$MODEMMTU" ] && MODEMMTU="1460"
[ -z "$MODEMMRU" ] && MODEMMRU="1460"
[ -z "$MODEMPPPDOPTS" ] && MODEMPPPDOPTS=""
[ -z "$DIALNUMBER" ] && DIALNUMBER="*99#"
[ -z "$DISABLEAUTOSTART" ] && DISABLEAUTOSTART="0"

[ $MODEMPORT = "auto" ] &&  MODEMPORT=`cat /etc/modem.list | grep "$3\:$4"|cut -f 3 -d : -s`
if [ -z $MODEMPORT ]; then
echo "Unknown modem $3\:$4 Please specify the modem port manually" >> /tmp/modem.log 
# [ $MODEMTYPE = "0" ] && MODEMPORT=ttyUSB0 || MODEMPORT=ttyACM0
fi
[ $2 != $MODEMPORT ] &&  exit 0
[ $DISABLEAUTOSTART = "1" ] && [ $1 = "add" ] &&  exit 0

killall pppd
rm -rf /etc/ppp/peers/0.chat
rm -rf /etc/ppp/peers/1.chat
rm -rf /etc/ppp/peers/dialup
rm -rf /etc/ppp/resolv.conf
[ $1 = "remove" ] &&  exit 0

[ -d /etc/ppp/peers ] || mkdir -p /etc/ppp/peers
echo "ABORT '~'
ABORT 'BUSY'
ABORT 'NO CARRIER'
ABORT 'ERROR'
REPORT 'CONNECT'
'' 'ATZ'
SAY 'Calling WCDMA/UMTS/GPRS'
'' 'AT+CGDCONT=1,\"IP\",\"$APN\"'
'OK' 'ATD$DIALNUMBER'
'CONNECT' ''" > /etc/ppp/peers/0.chat

echo "ABORT '~'
ABORT 'BUSY'
ABORT 'NO CARRIER'
ABORT 'ERROR'
ABORT 'NO DIAL TONE'
ABORT 'NO ANSWER'
ABORT 'DELAYED'
REPORT 'CONNECT'
'' 'ATZ'
SAY 'Calling CDMA/EVDO'
'OK' 'ATDT#777'
'CONNECT' 'ATO'
'' ''" > /etc/ppp/peers/1.chat

echo "debug
/dev/$MODEMPORT
$MODEMSPEED
crtscts
noipdefault
lock
ipcp-accept-local
lcp-echo-interval 60
lcp-echo-failure 6
mtu $MODEMMTU
mru $MODEMMRU
usepeerdns
defaultroute
noauth
maxfail 0
holdoff 5
$MODEMPPPDOPTS
nodetach
persist
user $MODEMUSERNAME
password $MODEMPASSWORD
connect \"/sbin/chat -s -S -V -t 60 -f /etc/ppp/peers/$MODEMTYPE.chat 2>/tmp/chat.log\"" > /etc/ppp/peers/dialup

[ -c /dev/ppp ] ||  mknod /dev/ppp c 108 0
pppd call dialup & >> /tmp/chat.log
