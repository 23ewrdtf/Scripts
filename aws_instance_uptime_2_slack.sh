#!/bin/bash

# This script takes public IP adress from AWS instances based on specific tags.
# Connects using SNMP to each instance and if uptime is more than 24h it sends a slack alert.
#
# Update below values before running:
# <path to aws cli>
# <REGION>
# <TAG>
# <COMMUNITY>
# <CHANNEL>
# <USERNAME>
# <SLACK_HOOK>
#
# Requires: aws cli, curl, snmp, snmp configured on each instance and allowed on firewall

dt=$(date '+%d/%m/%Y %H:%M:%S');

for machine in `/usr/local/bin/aws --region <REGION> ec2 describe-instances --filters Name=tag:<TAG>,Values=<TAG> --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`
do
    snmp_check=$(snmpget -v 2c -c <COMMUNITY> ${machine} .1.3.6.1.2.1.1.3.0 2>&1)
        if [[ "$(echo $snmp_check)" == *"Timeout"* ]];
            then
                echo "${machine} is down. Nothing to do. Checked at $dt"
            else
                snmp_uptime_ticks=$(echo $snmp_check | awk -F"[()]" '{print $2}')
                    if (( $snmp_uptime_ticks > 8640000 ));
                        then
                            echo "${machine} is up at $dt. Sending Alert."
                            snmp_uptime_ticks_hours=$(($snmp_uptime_ticks / 360000))
                            curl -s -X POST --data "payload={\"channel\": \"<CHANNEL>\", \"username\": \"<USERNAME>\", \"text\": \"${machine} is running for more than 24h. SNMP uptime in hours is ${snmp_uptime_ticks_hours} \n \"}"  <SLACK_HOOK>
                        else
				echo "SNMP check ${snmp_check}. SNMP ticks ${snmp_uptime_ticks} SNMP in Hours ${snmp_uptime_ticks}"
                            echo "${machine} is up with uptime ${snmp_uptime_ticks_hours} less than 24h at $dt. No Alert this time."
            fi
        fi
done
