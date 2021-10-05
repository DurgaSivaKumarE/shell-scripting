#1/bin/bash 
 

LID= "lt-06a1704feb566a4ed"
LVER=2


aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$LVER | jq