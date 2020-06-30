#!/bin/sh
. /opt/sage/bin/instance_env_vars.sh  && sed -i "s/EC2_INSTANCE_ID/$EC2_INSTANCE_ID/g" /etc/apache2/sites-available/proxy.conf
systemctl restart apache2
