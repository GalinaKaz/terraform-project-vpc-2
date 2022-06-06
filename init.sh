#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install php8.0 mariadb10.5 
sudo yum install -y httpd git
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
bash
sudo chown -R ec2-user:apache /var/wwwsudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www
mkdir inc
cd inc
echo "<?php

define('DB_SERVER', '${end-point}');
define('DB_USERNAME', '${user}');
define('DB_PASSWORD', '${password}');
define('DB_DATABASE', '${db-name}');

?>" >> dbinfo.inc
cd /var/www/html
git clone "${app-repo}" .