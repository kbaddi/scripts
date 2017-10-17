#!/bin/bash

# This program is to run manage ec2 instances from CLI using tags
echo -e "Tag of the Instance"
read inst_tag

# First lets get the instance ID

inst_id=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'"   --query 'Reservations[].Instances[].[ InstanceId]' --output text)
# echo $inst_id

# Lets get the Status of the Instance

inst_state=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].State[].Name' --output text)
echo $inst_state

if [[ $inst_state == "running" ]]
then
	echo -e "The instance is running \nWhat do you wanna do (connect(C)/Stop(S))"
	read inst_action
	if [[ $inst_action == "C" ]]
	then
		# Take the key as input into inst_key variable
		echo -e "Enter the ssh key (if it's in a different folder enter the full path): "
		read inst_key
		
		#Find the Instance PublicDns and store it in inst_PublicDnsName variable 
		inst_PublicDnsName=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].PublicDnsName' --output text)
		echo $inst_PublicDnsName
		#Take username used to login to instance and store it inst_user variable
		echo -e "Enter user name for the instance ex: (ec2-user for RedHat, ubuntu for Ubuntu): "
		read inst_user
		
		#connecting to the  instance
		ssh -i $inst_key $inst_user@$inst_PublicDnsName
	# If the answer is S - Stop; we will proceed to stop the instance
	elif [[ $inst_action == "S" ]]
	then
		aws ec2 stop-instances --instance-ids $inst_id  > /dev/null 
                inst_state=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].State[].Name' --output text)
		if[[ $inst_state == "stopped"]]
			echo -e "Instance with the Tag: $inst_tag Stopped"
		else
			echo -e "Failure in Stopping the instance"	
	        
	fi
elif [[ $inst_state == "stopped" ]] 
then
	echo "The instance is in stopped state \nDo you want to start it Yes(Y)/No(N)"
	read inst_action
	if [[ $inst_action == "Y" ]]
	then
		aws ec2 start-instances --instance-ids $inst_id > /dev/null
	elif [[ $inst_action == "N" ]]
	then
		exit		
	else
		echo -e "Incorrect input \nPlease enter Y to Start No to Exit"
        fi
fi

# To be continued
