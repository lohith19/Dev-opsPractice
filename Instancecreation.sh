AMI=ami-0f3c7d07486cad139
SG_ID=sg-05d820f83c44da063
INSTANCES=("mongodb" "redis" "rabbitmq" "mysql" "catalogue" "cart" "payments" "shipping" "user" "web" "dispatch")

for i in "${INSTANCES[@]}"
do
    echo "Instance is $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

aws ec2 run-instances --image-id $AMI  --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance, Tags=[{Key=Name,Value=$i}]"
done
