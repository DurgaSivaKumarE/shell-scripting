#!/bin/bash

source components/common.sh

Print "Setup Mongo Repo"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
Status_Check $?

Print "Install MySQL Service"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG 
Status_Check $?

Print "Start MySQL Service"
systemctl enable mysqld &>>$LOG && systemctl start mysqld &>>$LOG
Status_Check $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

Print "Reset Default Password"
echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG
if [ $? -eq 0 ]; then 
    echo "Root Password is already set" &>>$LOG
else    
    echo "ALTER USER 'rootf'@'localhost' IDENTIFIED NY 'RoboShop@1';" >/tmp/reset.sql 
    mysql --connect-expired-password -u root -p"${DEFAULT_PASSWORD}" </tmp/reset.sql &>>$LOG
 fi   
Status_Check $?
exit