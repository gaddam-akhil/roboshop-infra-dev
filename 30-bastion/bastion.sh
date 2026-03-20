#!/bin/bash

# we are creating 50GB root disc,but only 20GB partitioned
#remaining 30GB we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L+30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

#terraform installation
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform