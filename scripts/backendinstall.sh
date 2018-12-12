#!/bin/sh

apt-get update -y
apt-get install mysql-server -y
systemctl start mysql.service
systemctl enable mysql.service
