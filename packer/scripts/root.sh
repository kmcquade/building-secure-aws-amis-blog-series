#!/usr/bin/env bash

set -x

if [ $(grep -c sshusers /etc/group) -eq 0 ]; then
	/usr/sbin/groupadd sshusers &> /dev/null
fi

groupadd sshusers

adduser ec2-user --disabled-password
usermod -aG sshusers ${SSH_USERNAME}
usermod -aG sshusers ec2-user
usermod -aG wheel ${SSH_USERNAME}
usermod -aG wheel ec2-user

###########
# Title: Ensure Home Directories are Created for New Users
# Rule ID: accounts_have_homedir_login_defs
echo "CREATE_HOME yes" >> /etc/login.defs

