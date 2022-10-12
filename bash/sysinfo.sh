#!/bin/bash

echo -e "report for myvm"
echo ===============
echo -e "fqdn:\t\t"`hostname --fqdn` 
#to find fqdn
echo -e `hostnamectl | grep "Operating System"`
#to find the name and version of OS
echo -e "System Main IP:\t\t"`hostname -I` 
#find the ip address of device
echo -e "Root Filesystem Free Space:\t\t" `df -h /root` 
#to find free disk space
echo ===============


