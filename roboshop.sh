#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0b481e132b1f4fd2d"

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0b481e132b1f4fd2d --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    #Get the Private IP
    if [ $instance != "frontend"]; then
        IP=$(aws ec2 describe-instances --instance-ids i-04b96abdd76b1ab72 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids i-04b96abdd76b1ab72 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi

    echo "$instance: $IP"
done
