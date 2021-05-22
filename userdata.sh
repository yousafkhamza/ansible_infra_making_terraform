#!/bin/bash

sudo mkdir -p /root/.aws
cat <<EOF > /root/.aws/config
[default]
output = json
region = -REGION-
EOF

aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=[client*] --query "Reservations[*].Instances[*].{Instance:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value}" --output text > txt

ipone=`cat txt | grep one | awk {'print $1'}`
iptwo=`cat txt | grep two | awk {'print $1'}`

sudo amazon-linux-extras install ansible2 -y