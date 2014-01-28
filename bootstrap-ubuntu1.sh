#!/usr/bin/env bash

apt-get -y update

echo 'mysql-server mysql-server/root_password password foobar' |  debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password foobar' |  debconf-set-selections

apt-get -qqy install mysql-server
service mysql restart

mysql -u root -pfoobar < /vagrant/init.sql
