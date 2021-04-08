#!/bin/bash

# This script is used to set up environment variables that the Apache reverse proxy will use
# to store Synapse user token into SSM Parameter Store

# Requires the following environment variables to be defined:
# SYNAPSE_TOKEN_SSM_PARAMETER_NAME - name of SSM Parameter that will be used to
#                                    retrieve Synapse user tokens
# KMS_KEY_ALIAS - Name of KMS key alias used to encrypt the SSM Parameter. 
#                 This value should be in the format of 'alias/...'


# In case I am bad at programming
set -e; set -u; set -o pipefail


# set envirronment variable for Apache
echo "export SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME=$SYNAPSE_TOKEN_SSM_PARAMETER_NAME" >> /etc/apache2/envvars
echo "export KMS_KEY_ALIAS=$KMS_KEY_ALIAS" >> /etc/apache2/envvars

systemctl restart apache2
