#!/bin/sh

# Ensure cron daemon is enabled
echo
echo "Ensure cron daemon is enabled"
systemctl enable crond.service

sudo rm /etc/cron.deny
# Ensure at/cron is restricted to authorized users
echo
echo "Ensure at/cron is restricted to authorized users"
rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod g-r-w-x,o-r-w-x /etc/cron.allow
chmod g-r-w-x,o-r-w-x /etc/at.allow

# Ensure filesystem integrity is regularly checked
(crontab -u root -l; crontab -u root -l | egrep -q "^0 5 \* \* \* /usr/sbin/aide --check$" || echo "0 5 * * * /usr/sbin/aide --check" ) | crontab -u root -

chmod 600 /etc/crontab
chmod 600 /etc/cron.hourly/
chmod 600 /etc/cron.daily/
chmod 600 /etc/cron.weekly/
chmod 600 /etc/cron.monthly/
chmod 600 /etc/cron.d/