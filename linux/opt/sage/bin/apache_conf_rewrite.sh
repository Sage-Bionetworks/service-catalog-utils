#!/bin/sh

# This script adds a route in the Apache config for web requests with the URI that identifies the
# notebook. The path of this request gets rewritten by the proxy so that information identifying the
# notebook gets stripped out before the traffic is received by the notebook web server.
# We did it this way because the Apache module we use for rewrite did not support regular expressions.

EC2_INSTANCE_ID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
sed -i "s/^.*<LocationMatch.*\/.*\/>.*$/<LocationMatch \/$EC2_INSTANCE_ID\/>/g" /etc/apache2/sites-available/proxy.conf

# oh boy regular expresions are FUN. I wish everything was written in regular expresssions...
# (RewriteRule\s\/)  = finding "RewriteRule" followed by a space and forward slash - set as regex group_1
# .*    = the part we are trying to replace
# (\/\()     =  find forward slash and open parenthesis - set as regex group_2
# Replacement:
# \1$EC2_INSTANCE_ID\2   =  group_1 + $EC2_INSTANCE_ID + group_2
sudo sed  -i -r "s/(RewriteRule\s\/).*(\/\()/\1$EC2_INSTANCE_ID\2/g" /etc/apache2/sites-available/proxy.conf
systemctl restart apache2
