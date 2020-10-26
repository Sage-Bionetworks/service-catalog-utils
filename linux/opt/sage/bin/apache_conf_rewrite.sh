#!/bin/sh

# This script adds a route in the Apache config for web requests with the URI that identifies the
# notebook. The path of this request gets rewritten by the proxy so that information identifying the
# notebook gets stripped out before the traffic is received by the notebook web server.
# We did it this way because the Apache module we use for rewrite did not support regular expressions.

EC2_INSTANCE_ID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
sed -i "s/^.*<LocationMatch.*\/.*\/>.*$/<LocationMatch \/$EC2_INSTANCE_ID\/>/g" /etc/apache2/sites-available/proxy.conf
systemctl restart apache2
