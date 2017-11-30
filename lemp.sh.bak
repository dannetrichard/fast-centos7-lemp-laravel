#!/bin/bash
#centos 7
#https://www.google.co.jp/amp/s/www.hostinger.com/tutorials/how-to-install-lemp-centos7/amp/
#nginx
yum install epel-release -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx

#mysql(mariadb)
yum install mariadb-server mariadb -y
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
#password jinjun123

#php
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm
yum install yum-utils -y
yum-config-manager --enable remi-php71
yum --enablerepo=remi,remi-php71 install php-fpm php-common
yum --enablerepo=remi,remi-php71 install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-Tokenizer -y

sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/listen.owner = nobody/listen.owner = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/listen.group = nobody/listen.group = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9000\nlisten = \/var\/run\/php-fpm.sock/g' /etc/php-fpm.d/www.conf
systemctl start php-fpm.service
systemctl enable php-fpm.service

#composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer config -g repo.packagist composer https://packagist.phpcomposer.com

#certbot
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto