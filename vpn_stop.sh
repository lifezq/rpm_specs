#!/bin/bash

killall pppd

#INTERFACE=`route -n | grep 'ppp' | awk '{S[$NF]++} END {for(P in S) print P}'`
#PPPGW=`route -n | grep 'ppp' | awk '{print $1}'`

#route del default dev $INTERFACE
#route del -net $PPPGW gw 0.0.0.0 netmask 255.255.255.255 dev $INTERFACE

sed -i '/8.8.8.8/d' /etc/resolv.conf

echo 'stop vpn successed'
