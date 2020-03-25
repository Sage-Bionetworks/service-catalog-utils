#! /bin/bash

EC2_INSTANCE_ID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
ROOT_DISK_ID=$(/usr/bin/aws ec2 describe-volumes \
  --region $AWS_REGION \
  --filters Name=attachment.instance-id,Values=$EC2_INSTANCE_ID \
  --query Volumes[].VolumeId --out text)
EC2_INSTANCE_TAGS=$(aws --region $AWS_REGION \
  ec2 describe-tags \
  --filters Name=resource-id,Values=$EC2_INSTANCE_ID)
extract_tag_value() {
  echo $EC2_INSTANCE_TAGS | jq -j --arg KEYNAME "$1" '.Tags[] | select(.Key == $KEYNAME).Value '
}
DEPARTMENT=$(extract_tag_value Department)
PROJECT=$(extract_tag_value Project)
PROVISIONING_PRINCIPAL_ARN=$(extract_tag_value 'aws:servicecatalog:provisioningPrincipalArn')
OWNER_EMAIL=${!PROVISIONING_PRINCIPAL_ARN##*/}

echo "export AWS_REGION=$AWS_REGION" > /opt/sage/bin/instance_env_vars.sh
echo "export STACK_NAME=$STACK_NAME" >> /opt/sage/bin/instance_env_vars.sh
echo "export STACK_ID=$STACK_ID" >> /opt/sage/bin/instance_env_vars.sh
echo "export EC2_INSTANCE_ID=$EC2_INSTANCE_ID" >> /opt/sage/bin/instance_env_vars.sh
echo "export ROOT_DISK_ID='$ROOT_DISK_ID'" >> /opt/sage/bin/instance_env_vars.sh
echo "export DEPARTMENT=$DEPARTMENT" >> /opt/sage/bin/instance_env_vars.sh
echo "export PROJECT=$PROJECT" >> /opt/sage/bin/instance_env_vars.sh
echo "export OWNER_EMAIL=$OWNER_EMAIL" >> /opt/sage/bin/instance_env_vars.sh
chmod +x /opt/sage/bin/instance_env_vars.sh
