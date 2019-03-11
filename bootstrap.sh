#!/bin/bash

if [[ ! -f config.yaml ]]; then
	echo "File does not exist"
else
	myhostname=$(awk -F"=" '{ print $2 }' config.yaml)
	echo $myhostname > /var/log/system-bootstrap.log
	ifup enp0s8 > /var/log/system-bootstrap.log
	#yum check-update > /var/log/system-bootstrap.log
	
	sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0 > /var/log/system-bootstrap.log

	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
	if [ ! -d ~/.ssh ]; then
		mkdir -p ~/.ssh/
	fi


# Check for existence of passphrase
	if [ ! -f ~/.ssh/id_rsa.pub ]; then
        	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
        	echo "Execute ssh-keygen --[done]"
	fi	
	if [ ! -f ~/.ssh/authorized_keys ]; then
   		touch ~/.ssh/authorized_keys
      		echo "Create ~/.ssh/authorized_keys --[done]"
       		chmod 700 ~/.ssh/authorized_keys
       		cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
       		echo "Append the public keys id_rsa into authorized keys --[done]"
        	chmod 400 ~/.ssh/authorized_keys
        	chmod 700 ~/.ssh/
	fi

# Create user's ssh config it not exist
	if [ ! -f ~/.ssh/config ]; then
        	touch ~/.ssh/config
        	echo "StrictHostKeyChecking no" > ~/.ssh/config
        	echo "StrictHostKeyChecking no --[done]"
        	chmod 644 ~/.ssh/config
	fi
fi

