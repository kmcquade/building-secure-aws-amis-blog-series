#!/bin/sh

# Ensure mounting of cramfs filesystems is disabled
echo
echo  "Ensure mounting of cramfs filesystems is disabled"
modprobe -n -v cramfs | grep "^install /bin/true$" || echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^cramfs\s" && rmmod cramfs

# Ensure mounting of freevxfs filesystems is disabled
echo
echo  "Ensure mounting of freevxfs filesystems is disabled"
modprobe -n -v freevxfs | grep "^install /bin/true$" || echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^freevxfs\s" && rmmod freevxfs

# Ensure mounting of jffs2 filesystems is disabled
echo
echo  "Ensure mounting of jffs2 filesystems is disabled"
modprobe -n -v jffs2 | grep "^install /bin/true$" || echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^jffs2\s" && rmmod jffs2

# Ensure mounting of hfs filesystems is disabled
echo
echo  "Ensure mounting of hfs filesystems is disabled"
modprobe -n -v hfs | grep "^install /bin/true$" || echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^hfs\s" && rmmod hfs

# Ensure mounting of hfsplus filesystems is disabled
echo
echo  "Ensure mounting of hfsplus filesystems is disabled"
modprobe -n -v hfsplus | grep "^install /bin/true$" || echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^hfsplus\s" && rmmod hfsplus

# Ensure mounting of squashfs filesystems is disabled
echo ""
echo  "Ensure mounting of squashfs filesystems is disabled"
modprobe -n -v squashfs | grep "^install /bin/true$" || echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^squashfs\s" && rmmod squashfs

# Ensure mounting of udf filesystems is disabled
echo ""
echo  "Ensure mounting of udf filesystems is disabled"
modprobe -n -v udf | grep "^install /bin/true$" || echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^udf\s" && rmmod udf

#sed 's/.*TEXT_TO_BE_REPLACED.*/Replacement string/' /etc/modprobe.d/CIS.conf
#sed -i '/TEXT_TO_BE_REPLACED/c\This line is removed by the admin.' /tmp/foo

echo ""
echo  "Ensure mounting of FAT filesystems is disabled"
lsmod | egrep "^vfat\s" && rmmod vfat
sed -i '/vfat/d' /etc/modprobe.d/CIS.conf
echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
echo ""
cat /etc/modprobe.d/CIS.conf


## New one
echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf

echo "install vfat /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^dccp\s" && rmmod dccp
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^sctp\s" && rmmod sctp
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^rds\s" && rmmod rds
echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^tipc\s" && rmmod tipc
echo "options ipv6 disable=1" >> /etc/modprobe.d/CIS.conf