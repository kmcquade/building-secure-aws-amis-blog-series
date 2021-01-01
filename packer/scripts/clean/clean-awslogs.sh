#!/usr/bin/env bash


logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT $0: $1"
}

logger "Cleanup awslogs files"

systemctl stop awslogs
rm -rf /var/awslogs/state/*
rm -f /var/log/awslogs.log

logger "restorecon for etc filesystem to avoid excessive SELinux errors"
restorecon -R -v /etc/