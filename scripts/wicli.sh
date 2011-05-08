#!/bin/bash
# wicli.sh
# wireless client to allow remote access to the bridge

# wireless settings
WLAN="wlan0"
NWID="linksys"

# MAC address allowed to connect via SSH
MACADDR="00:de:ad:be:ef:00"
MACFILTER=0

# program locations
IFCONFIG=$(which ifconfig)
IWCONFIG=$(which iwconfig)
IPTABLES=$(which iptables)
DHCP="$(which dhclient) ${WLAN}"


# connect to wireless
echo "[+] bringing up ${WLAN} on wireless network ${NWID}..."
$IWCONFIG ${WLAN} essid ${NWID}
echo "[+] requesting DHCP address..."
$DHCP

# allow comms only from one host
if [ $MACFILTER -eq 1 ]; then
    $IPTABLES -A INPUT -i ${WLAN} -j DROP
    $IPTABLES -A INPUT -i ${WLAN} -m mac --mac-source ${MACADDR} -j ACCEPT
fi
