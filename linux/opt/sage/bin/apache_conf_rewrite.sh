#!/bin/sh
EC2_INSTANCE_ID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
sed -i "s/^.*<LocationMatch.*\/.*\/>.*$/<LocationMatch \/$EC2_INSTANCE_ID\/>/g" /etc/apache2/sites-available/proxy.conf
systemctl restart apache2
