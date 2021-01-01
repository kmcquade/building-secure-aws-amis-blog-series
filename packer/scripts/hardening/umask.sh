#!/bin/sh
############
# Update the default umask to 027 for users
# Set UMASK 027 in "/etc/profile"; "/etc/bashrc"; "/etc/csh.login"; "/etc/csh.cshrc". This will enable the default rights for all new files created by users to be only readable by the user's group, and no rights to be provided for the other users on the system

/bin/cp -a /etc/profile /etc/profile.orig
/bin/cp -a /etc/bashrc /etc/bashrc.orig
/bin/cp -a /etc/csh.login /etc/csh.login.orig
/bin/cp -a /etc/csh.cshrc /etc/csh.cshrc.orig

# umasks
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n])umask([\ \t]+)[0-9]+/\1umask\2027/g;te;s/$/\n\n#PCI umask\numask 027/;:e' /etc/profile
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n])umask([\ \t]+)[0-9]+/\1umask\2027/g;te;s/$/\n\n#PCI umask\numask 027/;:e' /etc/bashrc
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n])umask([\ \t]+)[0-9]+/\1umask\2027/g;te;s/$/\n\n#PCI umask\numask 027/;:e' /etc/csh.login
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n])umask([\ \t]+)[0-9]+/\1umask\2027/g;te;s/$/\n\n#PCI umask\numask 027/;:e' /etc/csh.cshrc

# conditional umasks. Only update, no adds
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n][\ \t]+)umask([\ \t]+)[0-9]+/\1umask\2027/g' /etc/profile
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n][\ \t]+)umask([\ \t]+)[0-9]+/\1umask\2027/g' /etc/bashrc
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n][\ \t]+)umask([\ \t]+)[0-9]+/\1umask\2027/g' /etc/csh.login
/bin/sed -i -r -e ':a;N;$!ba;s/([\r\n][\ \t]+)umask([\ \t]+)[0-9]+/\1umask\2027/g' /etc/csh.cshrc

############
# Set the default umask to 027 for root
# Set UMASK 027 in "/root/.bash_profile", "/root/.bashrc", "/root/.cshrc, "/root/.tcshrc", "/etc/sysconfig/sysstat". This will enable the default rights for all new files created by root to be only readable by the root's group members, and no rights to be provided for any other users on the system
# /bin/echo "umask 027" >> /root/.bash_profile
/bin/echo "umask 027" >> /root/.bashrc
/bin/echo "umask 027" >> /root/.cshrc
/bin/echo "umask 027" >> /root/.tcshrc
/bin/echo "umask 0027">>/etc/sysconfig/sysstat
