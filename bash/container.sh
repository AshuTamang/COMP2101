#!/bin/bash
#Checking if lxd is installed on the host machine otherwise installs it.


#Look out for installed lxd. it will install if it is not installed.
which lxd >/dev/null
if [ $? -ne 0 ]; then
echo "Installing the lxd - password mght be required"
sudo snap install lxd
if [ $? -ne 0 ]; then
echo "Failed to installed the lxd software"
exit 1
fi
fi

#Looking at IP address for lxdbr0 network interface. it will run the installer if not active.
ip link show | grep -w lxdbr0 >/dev/null
if [ $? -ne 0 ]; then
echo "installing interface"
lxd init --auto
if [ $? -ne 0 ]; then
echo "failed to create an interface"
exit 1
fi
fi

#search forb the container list to see if there is called COMP2101-F22. If not creates it.
#download the Ubuntu server 20.04 image file.
lxc list | grep -w "COMP2101-F22" >/dev/null
if [ $? -ne 0 ]; then
echo "Creating the container COMP2101-F22. This will download ubuntu server"
lxc launch ubuntu:20.04 COMP2101-F22
sleep 5
if [ $? -ne 0 ]; then
echo "Failed to create the COMP2101-F22 container"
exit 1
fi
fi

#Checking to see if the container IP is in the /etc/hosts files. If not, will add or update it.
export hostIP; hostIP=$(grep -w "COMP2101-F22" /etc/hosts | awk '{print $1}')
export conIP; conIP=$(lxc exec COMP2101-F22 -- ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
if [[ "$conIP" != "$hostIP" ]]; then
echo "adding the contianer IP in /etc/hosts"
sudo -- sh -c -e "echo '$conIP  COMP2101-F22' >> /etc/hosts"
if [ $? -ne 0 ]; then
echo "Failed to add the IP in /etc/hosts"
exit 1
fi
else
echo "IP already in /etc/hosts"
fi

#it will install Apache2 into the container. automatic yes to all question and output are hidden on the screen.
which lxc exec COMP2101-F22 -- which apache2 >/dev/null
if [ $? -ne 0 ]; then
echo "installing apache2 in container"
lxc exec COMP2101-F22 -- apt-get -y install apache2 &> /dev/null
echo "Apache2 installed"
if [ $? -ne 0 ]; then
echo "Failed installing apache2 in container"
exit 1
fi
fi

#checking whether the  curl is installed on the host machine.automatic yes to all question and install if missing.
which curl >/dev/null
if [ $? -ne  0 ]; then
echo "No curl found, Installing it now."
sudo apt-get -y install curl &> /dev/null
echo "the curl has been installed"
if [ $? -ne 0 ]; then
echo "Failed Installing Curl"
exit 1
fi
fi

#checking to try to curl the webserver on the container to get a connection.
curl http://COMP2101-F22 >/dev/null
if [ $? = 0 ]; then
echo "Connected"
else
echo "failed, please check the setting"
exit 1
fi 


