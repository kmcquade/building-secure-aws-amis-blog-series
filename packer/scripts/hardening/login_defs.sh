#!/bin/sh
set -x

# 1072: Set Password Minimum Age
var_accounts_minimum_age_login_defs="7"

grep -q ^PASS_MIN_DAYS /etc/login.defs && \
  sed -i "s/PASS_MIN_DAYS.*/PASS_MIN_DAYS     $var_accounts_minimum_age_login_defs/g" /etc/login.defs
if ! [ $? -eq 0 ]; then
    echo "PASS_MIN_DAYS      $var_accounts_minimum_age_login_defs" >> /etc/login.defs
fi

echo "Set Max Password days to 90 for new users (not current users)"
# Delete first, then insert in next step
sudo sed -i '/PASS_MAX_DAYS\t90.*/d' /etc/login.defs

# Title   Ensure the Logon Failure Delay is Set Correctly in login.defs
# Title   Ensure Home Directories are Created for New Users
cat <<EOF >> /etc/login.defs

PASS_MAX_DAYS	90
FAIL_DELAY 4
CREATE_HOME yes
EOF