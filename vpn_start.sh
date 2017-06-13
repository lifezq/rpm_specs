#!/bin/bash

# const
VPN_NAME='vpn000'
VPN_SERVER='127.0.0.1'
VPN_USER='vpnuser'
VPN_PASS='vpnpass'

INTERFACE=`pptpsetup --create $VPN_NAME --server $VPN_SERVER --username $VPN_USER --password $VPN_PASS --encrypt --start | grep 'interface' | awk '{print $NF}'`
if [ "$INTERFACE"x = ""x ]; then
	echo "start vpn failed"
	exit 1
fi

route add default dev $INTERFACE

sed -i '/8.8.8.8/d' /etc/resolv.conf
sed -i '1a nameserver 8.8.8.8' /etc/resolv.conf

echo "start vpn successed"
