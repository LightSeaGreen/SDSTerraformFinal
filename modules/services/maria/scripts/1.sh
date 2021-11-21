#!/bin/bash -xe

touch 1.txt

apt update
touch 2.txt

apt install -y mariadb-server
touch 3.txt

systemctl start mariadb
touch 4.txt

mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${db_root_password}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE ${database_name};
CREATE USER '${database_user}'@'%' identified by '${db_root_password}';
grant all privileges on *.* to '${database_user}'@'%' identified by '${db_root_password}' with grant option;
FLUSH PRIVILEGES;
_EOF_
touch 5.txt

systemctl enable mariadb.service
touch 6.txt

sudo sh -c 'echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf'
touch 7.txt

systemctl restart mariadb
touch 8.txt