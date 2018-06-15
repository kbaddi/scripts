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
	OS=$OS  # Dumy Values need to be updated 
	VER=$VER  # Dumy Values need to be updated

else
	OS=$(uname -s)
	VER=$(uname -r)

fi

echo -e "The machine's Operating System is ${OS} "
echo -e "Version is $VER"


