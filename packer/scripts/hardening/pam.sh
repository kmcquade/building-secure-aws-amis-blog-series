#!/bin/sh

set -x

yum -y install oddjob oddjob-mkhomedir
systemctl enable oddjobd
systemctl start oddjobd
# Borrowed some content from https://github.com/RedHatGov/ssg-el7-kickstart/blob/master/config/hardening/ipa-pam-configuration.sh, which is under the Apache 2.0 License.

# Backup original configuration
if [ ! -e /etc/pam.d/system-auth-local.orig ]; then
  cp /etc/pam.d/system-auth-local /etc/pam.d/system-auth-local.orig
fi
if [ ! -e /etc/pam.d/password-auth-local.orig ]; then
  cp /etc/pam.d/password-auth-local /etc/pam.d/password-auth-local.orig
fi

# System-auth

# Note: In the RedHatGov script, the below was originally named "system-auth-local" and then it created a soft link between system-auth-local and system-auth. I decided to just go with system-auth instead.
cat <<EOF > /etc/pam.d/system-auth-local
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_faildelay.so delay=2000000
auth        required      pam_faillock.so preauth audit silent deny=5 unlock_time=900
auth        sufficient    pam_unix.so try_first_pass remember=5
auth        sufficient    pam_faillock.so authsucc audit deny=5 unlock_time=900
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        [success=1 default=bad] pam_unix.so
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3
password    sufficient    pam_unix.so sha512 shadow  try_first_pass use_authtok remember=5
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     optional      pam_systemd.so
session     optional      pam_oddjob_mkhomedir.so umask=0077
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
ls -al /etc/pam.d/
ln -sf /etc/pam.d/system-auth-local /etc/pam.d/system-auth
ls -al /etc/pam.d/
cp -f /etc/pam.d/system-auth-local /etc/pam.d/system-auth-ac
chattr +i /etc/pam.d/system-auth-local

touch /etc/pam.d/password-auth-local
chmod 644 /etc/pam.d/password-auth-local

# Password-auth
# Note: In the RedHatGov script, the below was originally named "password-auth-local" and then it created a soft link between password-auth-local and password-auth. I decided to just go with password-auth instead.
cat <<EOF > /etc/pam.d/password-auth-local
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        required      pam_faildelay.so delay=2000000
auth        required      pam_faillock.so preauth audit silent deny=5 unlock_time=900
auth        sufficient    pam_unix.so nullok try_first_pass remember=5
auth        sufficient    pam_faillock.so authsucc audit deny=5 unlock_time=900
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        [success=1 default=bad] pam_unix.so
auth        [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok

password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
session     optional      pam_systemd.so
session     optional      pam_oddjob_mkhomedir.so umask=0077
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF

ln -sf /etc/pam.d/password-auth-local /etc/pam.d/password-auth
cp -f /etc/pam.d/password-auth-local /etc/pam.d/password-auth-ac
chattr +i /etc/pam.d/password-auth-local

exit 0