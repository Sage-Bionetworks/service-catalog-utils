#! /bin/bash

set -xe

source /opt/sage/bin/instance_env_vars.sh

/usr/bin/aws ec2 create-tags --region $AWS_REGION \
  --resources $EC2_INSTANCE_ID \
  --tags Key=Name,Value=$PRODUCT_NAME Key=OwnerEmail,Value=$OWNER_EMAIL Key='Protected/AccessApprovedCaller',Value=$PRODUCT_ACCESS_APPROVED_ROLEID:$OIDC_USER_ID
