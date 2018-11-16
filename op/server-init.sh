#!/bin/bash

cd /usr/local

in_all="n"
if [[ -n $1 && $1 = "a" ]]; then
    in_all = "y"
else
    echo -n "Are you want to install MySQL? [y]/N: "
    read in_mysql
    echo -n "Are you want to install Java? [y]/N: "
    read in_java
    echo -n "Are you want to install NGINX? [y]/N: "
    read in_nginx
    echo -n "Are you want to install Maven? [y]/N: "
    read in_maven
    echo -n "Are you want to install Node? [y]/N: "
    read in_node
fi

# install mysql
if [[ $in_all = "y" || $in_mysql = "y" ]]; then
    echo "Starting install MySQL...."
    rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
    yum -y install mysql-community-server.x86_64
    systemctl start mysqld
fi

# install java
if [[ $in_all = "y" || $in_java = "y" ]]; then
    wget http://cdn.zhengsj.top/jdk-8u181-linux-x64.tar.gz
    tar -xvf jdk-8u181-linux-x64.tar.gz -C /opt/
    echo "export PATH=\$PATH:/opt/jdk1.8.0_181/bin" >> /etc/profile
    echo "export JAVA_HOME=/opt/jdk1.8.0_181" >> /etc/profile
fi

# install nginx
if [[ $in_all = "y" || $in_nginx = 'y' ]]; then
    echo -e "[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/centos/7/\$basearch/\n\
gpgcheck=0\n\
enabled=1" > /etc/yum.repos.d/nginx.repo
    yum -y install nginx
    service nginx start
fi

# install maven
if [[ $in_all = "y" || $in_maven = 'y' ]]; then
    wget http://cdn.zhengsj.top/apache-maven-3.6.0-bin.tar.gz
    tar -xvf apache-maven-3.6.0-bin.tar.gz -C /opt/
    echo "export PATH=\$PATH:/opt/apache-maven-3.6.0/bin" >> /etc/profile
fi


# install node


source /etc/profile
cd 