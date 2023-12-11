#!/bin/bash

# This script is used to set up environment variables that the Apache reverse proxy will use
# to store Synapse user token into SSM Parameter Store

# Requires the following environment variables to be defined:
# SERVICE_CATALOG_PREFIX - prefix to use for service catalog synapse cred name
# SSM_PARAMETER_SUFFIX - suffix for the SSM Parameter name


# In case I am bad at programming
set -e; set -u; set -o pipefail

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)

INSTANCE_ID_KEY="$SERVICE_CATALOG_PREFIX/$EC2_INSTANCE_ID"

SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME="/$INSTANCE_ID_KEY/$SSM_PARAMETER_SUFFIX"
KMS_KEY_ALIAS="alias/$INSTANCE_ID_KEY"

# set envirronment variable for Apache
echo "export SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME=$SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME" >> /etc/apache2/envvars
echo "export KMS_KEY_ALIAS=$KMS_KEY_ALIAS" >> /etc/apache2/envvars

systemctl restart apache2
