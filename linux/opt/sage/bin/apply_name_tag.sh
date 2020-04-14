#! /bin/bash

set -xe

source /opt/sage/bin/instance_env_vars.sh
RESOURCE_ID=${STACK_ID##*/}
PRODUCTS=$(/usr/bin/aws --region $AWS_REGION \
  servicecatalog search-provisioned-products \
  --filters SearchQuery=$RESOURCE_ID )
NUM_PRODUCTS=$(echo $PRODUCTS | jq '.TotalResultsCount')
if ["$NUM_PRODUCTS" -ne 1]
then
  echo "ERROR: there are $NUM_PRODUCTS provisioned products, cannot isolate a name for tagging."
  exit 1
fi
NAME=$(echo $PRODUCTS | jq '.ProvisionedProducts[0].Name')
ACCESS_APPROVED_ROLEID=$(echo $PRODUCTS | jq '.ProvisionedProducts[0].AccessApprovedRoleId')
/usr/bin/aws ec2 create-tags --region $AWS_REGION \
  --resources $EC2_INSTANCE_ID \
  --tags Key=Name,Value=$NAME Key=OwnerEmail,Value=$OWNER_EMAIL Key=AccessApprovedCaller,Value=$ACCESS_APPROVED_ROLEID$OIDC_USER_ID
