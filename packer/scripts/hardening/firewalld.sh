#!/bin/sh

# Utilizing security groups instead of host based firewalls; too repetitive
sudo systemctl disable firewalld.service

touch /etc/hosts.allow

cat <<EOF > /etc/hosts.allow
ALL: ALL
EOF