#!/bin/bash
# linux script to set up a sniffing bridge. insert this between a router
# and modem (or host & router) to do inline sniffing. no arp spoofing makes
# detecting it more difficult. balance this against the ability to take
# the two hosts down. 
#
# written with the guru server in mind.
###########################################################################

############
### VARS ###
############

BR_A=eth0               # bridge endpoint A
BR_B=eth1               # bridge endpoint B

MANAGE=1                # use a management interface
MAN_SH="/root/wicli.sh"       
                        # script or command to set up management interface

# file to store captures in
CAPFILE=/root/capture.dump

# bridge control
BRCTL=$(which brctl)

# tcpdump
TCPDUMP=$(which tcpdump)
SNAPLEN=1600            # should be big enough unless you're running das
                        # über jumbo frames


#################
# BRIDGE SET UP #
#################
# SET UP BRIDGE
echo "[+] creating bridge..."
$BRCTL addbr br0
$BRCTL addif br0 ${BR_A}
$BRCTL addif br0 ${BR_B}
$BRCTL stp br0 off
ifconfig br0 up

# SET UP MANAGEMENT INTERFACE
if [ $MANAGE -ne 0 ]; then
    echo "[+] setting up management interface..."
    $MAN_SH
fi

# RUN TCPDUMP
echo "[+] starting tcpdump..."
$TCPDUMP -s ${SNAPLEN} -i br0 -w ${CAPFILE} &

exit 0
# this is going in rc.local, needs to exit 0 OR BAD JUJU HOMIE
