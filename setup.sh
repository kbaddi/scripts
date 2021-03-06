#!/bin/bash

# Find the distribution and version

if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$NAME
	VER=$VERSION_ID

elif type lsb_release >/dev/null 2>&1; then
	OS=$(lsb_release -si)
	VER=$(lsb_release -sr)

elif [ -f /etc/lsb-release ]; then
	. /etc/lsb-release
	OS=$DISTRIB_ID
	VER=$DISTRIB_RELEASE

elif [ -f /etc/debian_version ] ; then
	OS=Debian
	VER=$(cat /etc/debian_version)

elif [ -f /etc/redhat-release ]; then
	OS=$(cat /etc/redhat-release)   
	VER=$VER  
else
	OS=$(uname -s)
	VER=$(uname -r)

fi

echo -e "The machine's Operating System is ${OS} " >> ./setuplog.txt
echo -e "Version is $VER" >> ./setuplog.txt

echo "$HOSTNAME"
echo "$OS"
echo "$VER"


if [[ $OS == *"Red"* || $OS == "CentOs" ]];
then
    echo "Redhat Distribution"
    sudo yum upgrade -y
    sudo yum install git -y
    sudo yum install vim -y
    sudo sh ./dockerinstall_rhel.sh		

elif [[ $OS == "Debian*" || $OS == "Ubuntu" ]];
then
	sudo apt update -y && sudo apt upgrade -y
	sudo apt install git -y
	sudo sh ./dockerinstall_deb.sh

else
	echo "Unknown Distribution "
fi



