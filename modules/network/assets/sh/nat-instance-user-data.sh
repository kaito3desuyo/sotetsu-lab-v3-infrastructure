#!/bin/bash
yum -y install iptables-services
iptables -L
iptables -F
echo 1 > /proc/sys/net/ipv4/ip_forward
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -L
service iptables save
systemctl start iptables
systemctl enable iptables
systemctl status iptables