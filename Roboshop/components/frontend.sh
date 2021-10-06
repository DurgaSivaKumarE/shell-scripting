#!/bin/bash

source components/common.sh

Print "Install Nginx\t\t"
yum install nginx -y &>>$LOG
Status_Check $?

Print "Download frontend Archive"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
 Status_Check $?

Print "Extract Frontend Archive"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG && mv static/* . &>>$LOG
Status_Check $?

Print "Update Nginx"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
Status_Check $?

Print "Restart Nginx\t\t"
systemctl restart nginx && systemctl enable nginx &>>$LOG
Status_Check $?