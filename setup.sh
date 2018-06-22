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

if [[ $OS == "Debian*" || $OS == "Ubuntu" ]];
then
	sudo apt update -y && sudo apt upgrade -y
	sudo apt install git -y
	sudo sh ./installdocker.sh
fi



