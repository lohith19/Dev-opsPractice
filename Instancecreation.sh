AMI=ami-0f3c7d07486cad139
SG_ID=sg-05d820f83c44da063
INSTANCES=("mongodb" "redis" "rabbitmq" "mysql" "catalogue" "cart" "payments" "shipping" "user" "web" "dispatch")
ZONEID=Z08855142DA447RL45P7Z
DOMAINNAME=lohith.online

for i in "${INSTANCES[@]}"
do
        if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

IPADDRESS=$(aws ec2 run-instances --image-id $AMI  --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
echo " $i: $IPADDRESS"

#route53 records
#Note: Delete existing records incase of running sthe script again. This script need to be developed to check if record aleady exists and not create in record exists.
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONEID \
  --change-batch "
  {
    "Comment": "Testing creating a record set"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "$i.$DOMAINNAME"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "$IPADDRESS"
        }]
      }
    }]
  }
  "

done
