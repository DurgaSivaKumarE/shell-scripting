#1/bin/bash

Status_Check() {
   if [ $1 -eq 0 ]; then 
    echo -e "\e[32mSUCCESS\e[0m"
 else
    echo -e "\e[31mFAILURE\e[0m" 
    exit 2
fi  
}

Print() {
   echo -n -e "$1 \t-"
}

if [ $UID -ne 0 ]; then
    echo -e "\n\e[1;33mYou should execute this script as root User\e[0m\n"
    exit 1
if
