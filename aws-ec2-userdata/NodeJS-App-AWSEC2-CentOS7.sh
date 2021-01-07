#!/bin/bash

#stores the private IP from the AWS instance metadata
PRIVATEIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

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

#creates our JS app file
vi hello.js

#stores our base config for the app
cat <<EOT >> hello.js
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(8080, '$PRIVATEIP');
console.log('Server running at http://$PRIVATEIP:8080/');
EOT

#creates our JS app file
vi /lib/systemd/system/hello.service

#stores the service config for the app
cat <<EOT >> /lib/systemd/system/hello.service
[Unit]
Description=hello.js - An example NodeJS app
After=network.target

[Service]
Type=simple
User=centos
ExecStart=/usr/bin/node /hello.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

#reloads the systemctl daemons
systemctl daemon-reload

#launches the app with systemctl
systemctl start hello

#enables the app to start when the machine reboots
systemctl enable hello
