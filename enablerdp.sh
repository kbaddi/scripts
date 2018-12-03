#!/bin/bash

# Update Repositories
sudo apt-get update
# Install Xfce
sudo apt-get install xfce4
# Install xrdp
sudo apt-get install xrdp
# Enabled XRDP service
sudo systemctl enable xrdp
#Configure xrdp to use xfce as DE
echo xfce4-session >~/.xsession
#Restart XRDP Service
sudo systemctl restart xrdp