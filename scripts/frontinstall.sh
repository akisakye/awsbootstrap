#!/bin/sh

apt-get update -y
apt-get install apache2 -y
systemctl start apache2.service
systemctl enable apache2.service
