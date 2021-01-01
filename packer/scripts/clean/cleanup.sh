#!/usr/bin/env bash

set -x

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT $0: $1"
}

logger "Cleanup install artifacts"
sudo rm -rf /tmp/*

logger "Performing cleanup of history"
history -cw

#### AWS Removal tasks
logger "Cleanup AWS install artifacts"
rm -rf /var/lib/cloud/instances/*

#### SSH cleanup
shred -u /etc/ssh/*_key /etc/ssh/*_key.pub
rm /root/.ssh/authorized_keys
rm -f /root/.ssh/authorized_keys
rm -f /root/anaconda-ks.cfg
rm -f /root/original-ks.cfg

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
rm -f /zeros

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

logger "Cleanup complete"

### yum cleanup
yum -y clean all
rm -rf /var/cache/yum

rm -f -v linux.iso
#logger "Delete ec2-user"
#userdel -rf ec2-user
#userdel -rf cloud-user