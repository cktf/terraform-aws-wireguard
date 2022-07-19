#!/bin/sh

sudo apt update -y
sudo apt install -y wireguard-dkms wireguard-tools

ENI=$(ip route get 8.8.8.8 | awk -- '{printf $5}')

sudo cat > /etc/wireguard/wg0.conf <<- EOF
[Interface]
Address     = 10.0.0.1/8
ListenPort  = 51820
PrivateKey  = ${private_key}
PostUp      = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $ENI -j MASQUERADE
PostDown    = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $ENI -j MASQUERADE

%{ for idx, val in peers }
[Peer]
# ${val.name}
PublicKey = ${val.public_key}
AllowedIPs = ${cidrhost("10.0.0.0/8", idx+2)}/32
PersistentKeepalive = 25
%{ endfor }
EOF

sudo chmod -R og-rwx /etc/wireguard/*
sudo chown -R root:root /etc/wireguard/
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
