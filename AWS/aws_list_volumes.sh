for REGION in $(aws --region eu-west-2 ec2 describe-regions --output text --query 'Regions[].[RegionName]') ; 
    do 
    echo $REGION
    aws ec2 describe-volumes --query 'Volumes[*].{VolumeID:VolumeId,Size:Size,Type:VolumeType,AvailabilityZone:AvailabilityZone,InstanceID:Attachments[].InstanceId,State:Attachments[].State,Tag:Tags[?Key==`Name`].Value[]}' --region $REGION; 
done
