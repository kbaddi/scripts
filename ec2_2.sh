#!/bin/bash

# Function to check the State of the instance

# Capture the Arguments in variables

$inst_tag=$1
$inst_action=$2

inst_details() { 

	# First lets get the instance ID

	inst_id=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'"   --query 'Reservations[].Instances[].[ InstanceId]' --output text)
	# echo $inst_id
	# Lets get the Status of the Instance
	inst_state=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].State[].Name' --output text)
	# echo -e " The Status of the instance is $inst_state"
	# Find the Instance PublicDns and store it in inst_PublicDnsName variable 
	inst_PublicDnsName=$(aws ec2 describe-instances --filter "Name=tag:Name,Values='$inst_tag'" --query 'Reservations[].Instances[].PublicDnsName' --output text)
}

start_inst() {
		#start the instance 
		inst_details()
		aws ec2 start-instances --instance-ids $inst_id > /dev/null
		sleep 0
		exit 
}
connect_inst(){
	# Check the Status of the instance
	inst_details()	
	if [[ $inst_state == "running" ]]
	then

		# Take the key as input into inst_key variable
		echo -e "Enter the ssh key (if it's in a different folder enter the full path): "
		read inst_key
		#Take username used to login to instance and store it inst_user variable
		echo -e "Enter user name for the instance ex: (ec2-user for RedHat, ubuntu for Ubuntu): "
		read inst_user
		sleep 30
		#connecting to the  instance
		ssh -i $inst_key $inst_user@$inst_PublicDnsName
		sleep 30
	elif[[ $inst_state == "stopped" ]]
	then	
		start_inst()

}	
		
aws ec2 stop-instances --instance-ids $inst_id  > /dev/null 
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













