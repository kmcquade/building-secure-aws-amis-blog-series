#!/bin/sh

/bin/cat >/etc/ssh/ssh_banner <<EOF
+---------------------------------------------------------------------+
|                       Authorized use only                           |
+---------------------------------------------------------------------+
| This System is the property of Acme Corporation and is solely for   |
| use by authorized users for official business purposes only.        |
| Individuals using this System should have no expectation of         |
| privacy and are subject to having all activities monitored and      |
| recorded.  Use of this System evidences an express consent to       |
| such monitoring and agreement that if such monitoring reveals       |
| evidence of possible abuse or criminal activity, System personnel   |
| may provide the results of such monitoring to appropriate officials.|
+---------------------------------------------------------------------+
EOF
/bin/cat >/etc/issue <<EOF
+---------------------------------------------------------------------+
|                       Authorized use only                           |
+---------------------------------------------------------------------+
| This System is the property of Acme Corporation and is solely for   |
| use by authorized users for official business purposes only.        |
| Individuals using this System should have no expectation of         |
| privacy and are subject to having all activities monitored and      |
| recorded.  Use of this System evidences an express consent to       |
| such monitoring and agreement that if such monitoring reveals       |
| evidence of possible abuse or criminal activity, System personnel   |
| may provide the results of such monitoring to appropriate officials.|
+---------------------------------------------------------------------+
EOF
/bin/cp -p /etc/issue /etc/issue.net

/bin/cat > /etc/motd <<EOF
###########################################################
#Property    of   Acme               Corporation          #
#This system is solely for the use of authorized          #
#users for   official    purposes. You  have  no          #
#expectation   of privacy in   its use.                   #
#Use of this system evidences an express consent          #
#to monitoring and agreement that if such monitoring      #
#reveals evidence of possible abuse or criminal activity, #
#system personnel may provide the results of such         #
#monitoring to appropriate officials.                     #
###########################################################
EOF
#
/bin/sed -i.orig -e "/^splashimage/s|^.*splashimage|\#splashimage|; /kernel \/vmlinuz.*/ s/ rhgb / quiet /" /boot/grub2/grub.cfg