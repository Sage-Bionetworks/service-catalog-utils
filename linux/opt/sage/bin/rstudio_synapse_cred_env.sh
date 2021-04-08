#!/bin/bash

# This script sets up environment variables in RStudio so that the installed embedded SynapseR client 
# can retrieve Synapse user token that was stored in SSM Parameter Store

# Requires the following environment variables to be defined:
# SYNAPSE_TOKEN_SSM_PARAMETER_NAME - name of SSM Parameter that will be used to
#                                    retrieve Synapse user tokens

# In case I am bad at programming
set -e; set -u; set -o pipefail

AWS_REGION=$(/usr/bin/curl -s http://169.254.169.254/latest/dynamic/instance-identity/document)

# set environment variable for R
echo "SYNAPSE_TOKEN_AWS_SSM_PARAMETER_NAME=$SYNAPSE_TOKEN_SSM_PARAMETER_NAME" >> /etc/R/Renviron.site
echo "AWS_DEFAULT_REGION=$AWS_REGION" >> /etc/R/Renviron.site
# there does not appear to be a need to restart RStudio server
