#!/bin/bash

if [[ ! -f /root/tema1/config.yaml ]]; then
	echo "File does not exist" &> /var/log/system-bootstrap.log

else

	myhostname=$(awk -F"=" '{ print $2 }'  /root/tema1/config.yaml)
	hostnamectl set-hostname $myhostname &> /var/log/system-bootstrap.log
	echo $myhostname &> /var/log/system-bootstrap.log
	
	ifup enp0s8 &> /var/log/system-bootstrap.log
	
	yum check-update &> /var/log/system-bootstrap.log
	
	sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config &> /var/log/system-bootstrap.log
	setenforce 0 &> /var/log/system-bootstrap.log
	
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa &> /var/log/system-bootstrap.log
	ssh-copy-id root@192.168.56.102 &> /var/log/system-bootstrap.log
	sed -i '/^PasswordAuthentication/s/yes/no/' /etc/ssh/sshd_config &> /var/log/system-bootstrap.log
	service sshd restart &> /var/log/system-bootstrap.log

fi
