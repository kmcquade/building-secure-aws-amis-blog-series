#!/usr/bin/env bash
yum -y install epel-release
yum -y update
yum -y install dkms tar

yum -y install nano net-tools bind-utils jq dos2unix wget mlocate NetworkManager-tui zip ntp

# For Systems Manager agent
yum -y install libcurl libgcc libpcap
#
# Enhanced Networking optimizations
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-os.html
echo "vm.min_free_kbytes = 1048576" >> /etc/systl.conf
sysctl -p

yum update --security