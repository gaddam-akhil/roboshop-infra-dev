#!/bin/bash

component=$1
env=$2
app_version=$3
dnf install ansible -y

#/home/ec2-user ane dir clone chestunam
cd /home/ec2-user 
git clone https://github.com/gaddam-akhil/ansible-roboshop-roles-terraform.git

#after cloning moving to ansible-roboshop-roles-terraform folder and excuting below playbook

cd ansible-roboshop-roles-terraform 
git pull
ansible-playbook -e component=$component -e env=$env  -e app_version=$app_version roboshop.yaml 