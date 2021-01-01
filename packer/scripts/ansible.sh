#!/usr/bin/env bash

#curl -O https://bootstrap.pypa.io/get-pip.py
#python get-pip.py --user
#export PATH=~/.local/bin:$PATH
#python get-pip.py
#sudo pip install ansible
#sudo pip install boto3 botocore

yum -y update --nogpgcheck
yum -y install epel-release --nogpgcheck
yum -y install dkms tar --nogpgcheck

curl --silent -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
export PATH=~/.local/bin:$PATH

pip install awscli
pip install ansible
pip install boto3 botocore

pip --version
aws --version
ansible --version

