#!/bin/bash

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
    echo -n "Are you want to install Redis? [y]/N: "
    read in_redis
fi

# install
yum -y install vim rsync wget screen lsof

# install mysql
if [[ $in_all = "y" || $in_mysql = "y" ]]; then
    echo "Starting install MySQL...."
    rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
    yum -y install mysql-community-server.x86_64
    echo "port=3333" >> /etc/my.cnf
    echo "skip-grant-tables" >> /etc/my.cnf
    echo -e "UPDATE mysql.user SET authentication_string=password('xdwizzno1') WHERE user='root' AND Host = 'localhost';" >> chgpass1.sql
    echo -e "set global validate_password_policy=0;\n\
    set global validate_password_length=4;\n\
    SET PASSWORD = PASSWORD('xdwizzno1');\n\
    flush privileges;" >> chgpass2.sql;
    
    systemctl start mysqld
    mysql -u root mysql<chgpass1.sql
    systemctl stop mysqld
    sed -i 's/skip-grant-tables//' /etc/my.cnf
    systemctl start mysqld
    mysql -u root -p=xdwizzno1 mysql<chgpass2.sql
    rm -rf chgpass*
fi

# install java
if [[ $in_all = "y" || $in_java = "y" ]]; then
    wget http://cdn.zhengsj.top/jdk-8u181-linux-x64.tar.gz
    tar -xvf jdk-8u181-linux-x64.tar.gz -C /opt/
    echo "export JAVA_HOME=/opt/jdk1.8.0_181" >> /etc/profile
    echo "export PATH=\$PATH:/opt/jdk1.8.0_181/bin" >> /etc/profile
fi

# install nginx
if [[ $in_all = "y" || $in_nginx = 'y' ]]; then
    echo -e "[nginx]\n\
name=nginx repo\n\
baseurl=http://nginx.org/packages/centos/7/\$basearch/\n\
gpgcheck=0\n\
enabled=1" > /etc/yum.repos.d/nginx.repo
    yum -y install nginx
    chmod u+s /usr/sbin/nginx  # 使非root也可以配置NGINX
    chmod -R 777 /etc/nginx/conf.d
    nginx  # 不能使用service，因为子用户没有service权限
fi

# install maven
if [[ $in_all = "y" || $in_maven = 'y' ]]; then
    wget http://cdn.zhengsj.top/apache-maven-3.6.0-bin.tar.gz
    tar -xvf apache-maven-3.6.0-bin.tar.gz -C /opt/
    echo "export PATH=\$PATH:/opt/apache-maven-3.6.0/bin" >> /etc/profile
fi

# install redis
if [[ $in_all = "y" || $in_redis = 'y' ]]; then
    yum -y install epel-release
    yum -y install redis
    sed -i 's/port 6379/port 6666/' /etc/redis.conf
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis.conf
    echo "requirepass xdwizzno1" >> /etc/redis.conf
    systemctl start redis
fi

echo "MySQL Port: 3333, Password: xdwizzno1"
echo "Redis Port: 6666, Password: xdwizzno1"
echo "NGINX Project configuration: /etc/nginx/conf.d/"
echo "Java Version: 1.8"
echo "请执行 source /etc/profile 使环境变量生效"
