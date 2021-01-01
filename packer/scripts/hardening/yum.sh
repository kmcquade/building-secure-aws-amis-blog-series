#!/usr/bin/env bash

set -x

#### GPG Checks

# Title: Ensure gpgcheck Enabled In Main Yum Configuration
# Rule ID: ensure_gpgcheck_globally_activated

echo "Ensure gpgcheck is globally activated"
egrep -q "^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$" /etc/yum.conf && sed -ri "s/^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$/\1gpgcheck=1\2/" /etc/yum.conf || echo "gpgcheck=1" >> /etc/yum.conf
for file in /etc/yum.repos.d/*; do
  egrep -q "^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$" $file && sed -ri "s/^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$/\1gpgcheck=1\2/" $file || echo "gpgcheck=1" >> $file
done

# Title: Ensure YUM Removes Previous Package Versions
# Rule: clean_components_post_updating

if grep --silent ^clean_requirements_on_remove /etc/yum.conf ; then
        sed -i "s/^clean_requirements_on_remove.*/clean_requirements_on_remove=1/g" /etc/yum.conf
else
        echo -e "\n# Set clean_requirements_on_remove to 1 per security requirements" >> /etc/yum.conf
        echo "clean_requirements_on_remove=1" >> /etc/yum.conf
fi

# Title: Ensure gpgcheck Enabled for Repository Metadata
# Rule: ensure_gpgcheck_repo_metadata

if grep --silent ^repo_gpgcheck /etc/yum.conf ; then
        sed -i "s/^repo_gpgcheck.*/repo_gpgcheck=1/g" /etc/yum.conf
else
        echo -e "\n# Set repo_gpgcheck to 1 per security requirements" >> /etc/yum.conf
        echo "repo_gpgcheck=1" >> /etc/yum.conf
fi

# Title: Ensure gpgcheck Enabled for Local Packages
# Rule: ensure_gpgcheck_local_packages

if grep --silent ^localpkg_gpgcheck /etc/yum.conf ; then
        sed -i "s/^localpkg_gpgcheck.*/localpkg_gpgcheck=1/g" /etc/yum.conf
else
        echo -e "\n# Set localpkg_gpgcheck to 1 per security requirements" >> /etc/yum.conf
        echo "localpkg_gpgcheck=1" >> /etc/yum.conf
fi

#######
# Title: Ensure YUM Removes Previous Package Versions
# Rule: clean_components_post_updating

if grep --silent ^clean_requirements_on_remove /etc/yum.conf ; then
        sed -i "s/^clean_requirements_on_remove.*/clean_requirements_on_remove=1/g" /etc/yum.conf
else
        echo -e "\n# Set clean_requirements_on_remove to 1 per security requirements" >> /etc/yum.conf
        echo "clean_requirements_on_remove=1" >> /etc/yum.conf
fi


#yum -y install yum-cron
yum -y install nss
yum -y install cronie
yum -y install aide

yum -y install yum-utils
yum update --security

# CIS 2.2.2 Ensure X Window System is not installed
# These packages were causing issues
# xorg-x11-fonts-Type1
# xorg-x11-font-utils
yum -y remove xorg-x11*
yum -y remove xorg-x11-font-utils xorg-x11-fonts-Type1