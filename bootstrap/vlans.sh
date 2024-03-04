#!/usr/bin/env bash

tee -a /etc/network/interfaces > /dev/null <<-EOD
auto bond0.${VLAN}
    iface bond0.${VLAN} inet static
    pre-up sleep 5
    address ${IP}
    netmask ${NETMASK}
    vlan-raw-device bond0
EOD

systemctl restart networking.service