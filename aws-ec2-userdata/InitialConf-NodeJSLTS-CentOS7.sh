#!/bin/bash

#curls the latest versionof nodejs LTS
curl -sL https://rpm.nodesource.com/setup_lts.x | bash -

#upgrades all repos
yum upgrade -y

#updates all repos
yum update -y

#cleans yum cache
yum clean all

#ensure that our yum queries are completed as quickly as possible
yum makecache fast

#installs the nodejs build essentials
yum install -y gcc-c++ make

#installs nodejs
yum install -y nodejs

#installs git
yum install -y git
