#!/bin/bash

# This script sets up environment variables in RStudio so that the installed embedded SynapseR client 
# can retrieve Synapse user token that was stored in SSM Parameter Store

# Requires the following environment variables to be defined:
# SERVICE_CATALOG_PREFIX - prefix to use for service catalog synapse cred name
# SSM_PARAMETER_SUFFIX - suffix for the SSM Parameter name

# In case I am bad at programming
set -e; set -u; set -o pipefail

AWS_REGION=$(/usr/bin/curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | /usr/bin/jq -r .region)
EC2_INSTANCE_ID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)

SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME="/$SERVICE_CATALOG_PREFIX/$EC2_INSTANCE_ID/$SSM_PARAMETER_SUFFIX"

# create directory if does not exist
if [ ! -d "/etc/R" ]; then
  mkdir -p /etc/R
fi

# set environment variable for R
echo "SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME=$SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME" >> /etc/R/Renviron.site
echo "AWS_DEFAULT_REGION=$AWS_REGION" >> /etc/R/Renviron.site
# there does not appear to be a need to restart RStudio server
