#!/bin/bash

#https://github.com/piwikla/centos6-nginx

#Install the Required Repositories
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

#Update
sudo yum update
sudo yum upgrade

#Install Nginx
sudo yum install nginx
sudo /etc/init.d/nginx start

#Install MySQL
sudo yum install mysql mysql-server
sudo /etc/init.d/mysqld restart
sudo /usr/bin/mysql_secure_installation

#Install PHP 
sudo yum --enablerepo=remi install php-pecl-apc php-cli php-pear php-pdo php-mysql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml

#config nginx
mkdir /etc/nginx/{sites-available,sites-enabled}
cp /etc/nginx/conf.d/default.conf /etc/nginx/sites-available/piwik.la
ln -s /etc/nginx/sites-available/piwik.la /etc/nginx/sites-enabled
rm /etc/nginx/conf.d/default.conf

#download piwik
mkdir -p /home/piwik/public_html/piwik.la
cd /home/piwik/public_html/piwik.la
wget http://builds.piwik.la/piwik.zip && unzip piwik.zip
rm How\ to\ install\ Piwik.html
cd piwik
mv * ../
cd ../
rm -rf piwik piwik.zip
sudo chmod 755 /home/piwik/public_html

#Restart Service
sudo chkconfig --levels 235 mysqld on
sudo chkconfig --levels 235 nginx on
sudo chkconfig --levels 235 php-fpm on
sudo service php5-fpm restart
sudo service nginx restart
sudo service mysqld restart
