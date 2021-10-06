#!/bin/bash

Status_Check() {
   if [ $1 -eq 0 ]; then 
    echo -e "\e[32mSUCCESS\e[0m"
 else
    echo -e "\e[31mFAILURE\e[0m" 
    exit 2
fi  
}

Print() {
   echo -e "\n\t\t---------- $1 ----------\n" >>$LOG
   echo -n -e "$1 \t-"
}

if [ $UID -ne 0 ]; then
    echo -e "\n\e[1;33mYou should execute this script as root User\e[0m\n"
    exit 1
fi

LOG=/tmp/roboshop.log
rm -f $LOG

ADD_APP_USER(){
   Print "Adding Roboshop User"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
    echo "User already there, So skipping" &>>$LOG
else
    useradd roboshop &>>$LOG
fi   

Status_Check $?
}

DOWNLOAD() {
   Print "Downloading ${COMPONENT} Content"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
Status_Check $?
}

NODEJS() {
   Print "Installing NodeJS"
   yum install nodejs make gcc-c++ -y &>>$LOG
   Status_Check $? 

ADD_APP_USER
DOWNLOAD




Print "Extracting Catalogue"
cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>$LOG &&  mv catalogue-main catalogue
Status_Check $? 

Print "Downloading NodeJS Dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>$LOG
Status_Check $?

chown roboshop:roboshop -R /home/roboshop

Print "Update SystemD service"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
Status_Check $?

Print "Setuo systemd service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl restart catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
Status_Check $?
}