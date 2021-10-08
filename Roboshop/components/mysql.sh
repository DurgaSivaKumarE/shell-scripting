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

exit

Now a default root password will be generated and given in the log file.
# grep temp /var/log/mysqld.log

Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation

You can check the new password working or not using the following command.

# mysql -u root -p