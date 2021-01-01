#!/bin/sh

# Borrowed from: https://github.com/fcaviggia/hardened-centos7-kickstart/blob/master/config/hardening/supplemental.sh

########################################
# SSHD Hardening
########################################

sed -i '/Ciphers.*/d' /etc/ssh/sshd_config
sed -i '/MACs.*/d' /etc/ssh/sshd_config
sed -i '/Protocol.*/d' /etc/ssh/sshd_config

### Using sed to replace values in lines that create false positives in STIG report.

# Equivalent of:
# echo "ClientAliveInterval 900" >> /etc/ssh/sshd_config
#egrep -q "^(\s*)ClientAliveInterval\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)ClientAliveInterval\s+\S+(\s*#.*)?\s*$/\1ClientAliveInterval 900\2/" /etc/ssh/sshd_config || echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config

### Set other SSHD parameters
echo "" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config
#echo "MACs hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/ssh_config # For CIS, use "hmac-sha2-512,hmac-sha2-256". For STIG, use hmac-sha2-256,hmac-sha2-512
echo "MACs hmac-sha2-512,hmac-sha2-256" >> /etc/ssh/sshd_config
echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 0" >> /etc/ssh/sshd_config
echo "PrintLastLog yes" >> /etc/ssh/sshd_config
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
echo "Banner /etc/issue" >> /etc/ssh/sshd_config
#echo "RhostsRSAAuthentication no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config # Already set to no by default
echo "KerberosAuthentication no" >> /etc/ssh/sshd_config
echo "IgnoreUserKnownHosts yes" >> /etc/ssh/sshd_config
echo "StrictModes yes" >> /etc/ssh/sshd_config
echo "UsePrivilegeSeparation yes" >> /etc/ssh/sshd_config
echo "Compression delayed" >> /etc/ssh/sshd_config
#echo "X11Forwarding no" >> /etc/ssh/sshd_config
egrep -q "^(\s*)X11Forwarding\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)X11Forwarding\s+\S+(\s*#.*)?\s*$/\1X11Forwarding no\2/" /etc/ssh/sshd_config || echo "X11Forwarding no" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config
#echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
# Disable Password Authentication
#sed -i -e 's/^PasswordA=.*/notify_only=0/g' /etc/yum/pluginconf.d/search-disabled-repos.conf
sed -i -e 's/^PasswordAuthentication yes.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

#grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
# If LDAP is required, set PasswordAuthentication to "yes"
echo "AllowGroups sshusers" >> /etc/ssh/sshd_config
#echo "AllowUsers ${SSH_USERNAME}" >> /etc/ssh/sshd_config

# Qualys Modifications
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
echo "LogLevel INFO"  >> /etc/ssh/sshd_config
echo "LoginGraceTime 60" >>/etc/ssh/sshd_config
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config

## Permit access from corporate IPs only
#echo "Match address 10.0.0.0/8" >> /etc/ssh/sshd_config
#echo -e "\tPasswordAuthentication yes" >> /etc/ssh/sshd_config
