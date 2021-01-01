#!/usr/bin/env bash

export AWS_REGION="us-east-1"
export SSH_USERNAME="centos"
export ENVIRONMENT="sbx"
export INSTANCE_TYPE="t2.small"

# Change the value of this to the name of your private key on your machine
export SSH_PRIVATE_KEY_FILE="~/.ssh/my-private-key.pem"
# This should be your private key pair name recognized by AWS.
export SSH_KEYPAIR_NAME="my-private-key"
