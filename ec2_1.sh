#!/bin/bash

# This program is to run manage ec2 instances from CLI using tags
echo -e "Tag of the Instance"
read inst_tag

# First lets get the instance ID

inst_id=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'"   --query 'Reservations[].Instances[].[ InstanceId]' --output text)
# echo $inst_id

# Lets get the Status of the Instance

inst_state=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].State[].Name' --output text)
# echo $inst_state

if [ "$inst_state" == "running" ]
then
	echo -e "The instance is running \nWhat do you wanna do (connect(C)/Stop(S))"
	read inst_action
	if [ "$inst_action" == "C" ]
	then
		# Take the key as input into inst_key variable
		echo -e "Enter the ssh key (if it's in a different folder enter the full path): "
		read inst_key
		
		#Find the Instance PublicDns and store it in inst_PublicDnsName variable 
		inst_PublicDnsName=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='Ubuntu-0'" --query 'Reservations[].Instances[].PublicDnsName' --output text)
		echo $inst_PublicDnsName
		#Take username used to login to instance and store it inst_user variable
		echo -e "Enter user name for the instance ex: (ec2-user for RedHat, ubuntu for Ubuntu): "
		read inst_user
		
		#connecting to the  instance
		ssh -i $inst_key $inst_user@$inst_PublicDnsName
	fi
fi


# To be continued
