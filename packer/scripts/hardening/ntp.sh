#!/bin/sh

# Borrowed from: https://github.com/fcaviggia/hardened-centos7-kickstart/blob/master/config/hardening/supplemental.sh

## Secured NTP Configuration
cat <<EOF > /etc/ntp.conf
restrict default kod nomodify notrap nopeer noquery
# by default act only as a basic NTP client
restrict -6 default kod nomodify notrap nopeer noquery
restrict -4 default kod nomodify notrap nopeer noquery
# allow NTP messages from the loopback address, useful for debugging
restrict 127.0.0.1
# no IPv6 by default
#restrict ::1
# poll server at higher rate to prevent drift
server 169.254.169.123 maxpoll 17
# server(s) we time sync to
##server 192.168.0.1
##server 2001:DB9::1
#server time.example.net
EOF

#### CIS 2.2.1.2 Ensure ntp is configured

if rpm -q ntp >/dev/null; then
    egrep -q "^\s*restrict(\s+-4)?\s+default(\s+\S+)*(\s*#.*)?\s*$" /etc/ntp.conf && sed -ri "s/^(\s*)restrict(\s+-4)?\s+default(\s+[^[:space:]#]+)*(\s+#.*)?\s*$/\1restrict\2 default kod nomodify notrap nopeer noquery\4/" /etc/ntp.conf || echo "restrict default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf
    egrep -q "^\s*restrict\s+-6\s+default(\s+\S+)*(\s*#.*)?\s*$" /etc/ntp.conf && sed -ri "s/^(\s*)restrict\s+-6\s+default(\s+[^[:space:]#]+)*(\s+#.*)?\s*$/\1restrict -6 default kod nomodify notrap nopeer noquery\3/" /etc/ntp.conf || echo "restrict -6 default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf
    egrep -q "^(\s*)OPTIONS\s*=\s*\"(([^\"]+)?-u\s[^[:space:]\"]+([^\"]+)?|([^\"]+))\"(\s*#.*)?\s*$" /etc/sysconfig/ntpd && sed -ri '/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/ {/^(\s*)OPTIONS\s*=\s*\"[^\"]*-u\s+\S+[^\"]*\"(\s*#.*)?\s*$/! s/^(\s*)OPTIONS\s*=\s*\"([^\"]*)\"(\s*#.*)?\s*$/\1OPTIONS=\"\2 -u ntp:ntp\"\3/ }' /etc/sysconfig/ntpd && sed -ri "s/^(\s*)OPTIONS\s*=\s*\"([^\"]+\s+)?-u\s[^[:space:]\"]+(\s+[^\"]+)?\"(\s*#.*)?\s*$/\1OPTIONS=\"\2\-u ntp:ntp\3\"\4/" /etc/sysconfig/ntpd || echo "OPTIONS=\"-u ntp:ntp\"" >> /etc/sysconfig/ntpd
    echo "Ensure ntp is configured - server not configured."
fi

sed -i -e "s/^ExecStart=.*/ExecStart=\/usr\/sbin\/ntpd -u ntp:ntp \$OPTIONS/g" /etc/yum.conf
sed -i -e 's/^OPTIONS=.*/OPTIONS="-g -u ntp:ntp -p \/var\/run\/ntpd.pid"/g' /etc/sysconfig/ntpd

# The Amazon Time Sync Service is available through NTP at the 169.254.169.123 IP address for any instance running in a VPC. Your instance does not require access to the internet, and you do not have to configure your security group rules or your network ACL rules to allow access. Use the following procedures to configure the Amazon Time Sync Service on your instance using the chrony client.

# Basically, setting the Magic IP for the NTP server in Ec2 instances
#echo "server 169.254.169.123" >> /etc/ntp.conf