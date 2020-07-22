#!/bin/bash

# This script checks cloud trail in each region and if finds ConsoleLogin it sends an alert to slack.
#
# Update below values before running:
# <path to aws cli, jq>
# <CHANNEL>
# <USERNAME>
# <SLACK_HOOK>
#
# Requires: aws cli, curl, jq
# fiveminutesago needs changing as originally this was checking for ConsoleLogin in the last five minutes...

timestamp=$(date +"%s")
fiveminutesago=$( expr $timestamp - 1800)
# 300 = 5 minutes, 600=10m, 900=15m, 1200=20m, 1500=25, 1800=30m, 2100=35m, 2400=40m, 2700=45m, 3000=50m, 3600=1h

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo ""
for region in `/usr/local/bin/aws ec2 describe-regions --output text | cut -f4`
    do
        console_login_json=$(/usr/local/bin/aws --region $region cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin --start-time $fiveminutesago --end-time $timestamp --output json | /usr/bin/jq -r .Events[].CloudTrailEvent | /usr/bin/jq -r '.userIdentity.userName, .eventTime, .awsRegion, .sourceIPAddress, .responseElements.ConsoleLogin, .eventID')
        if [ -z "$console_login_json" ]
            then
                echo "No login detected in $region at $dt"
            else
                echo "Login detected in $region at $dt. Sending Alert."
                curl -s -X POST --data "payload={\"channel\": \"<CHANNEL>\", \"username\": \"<USERNAME>\", \"text\": \"Console login \n ${console_login_json} \"}" <SLACK_HOOK>
  fi
done
echo ""
