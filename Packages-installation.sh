#!/bin/bash
#check if user is root
ID=$(id -u)
#Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#create a log file
Time=$(date +%F-%H-%M-%S)
Logs="/var/$0-$Time.log"

echo -e "script started executing at $Y $Time $N" &>> $Logs

VALIDATE() { # to check if  properly installed 
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R Failed $N"
    else
        echo -e "$2 is $G Success $N"
    fi
}

if [ $ID -ne 0 ]
    then
        echo "$R Not root user $N"
        exit 1 # to exit the script incase user is not admin
else
    for package in $@
        do
         yum list installed $package &>> $Logs # to check if package is already installed.
         if [ $? -ne 0 ] # if not installed
             then
             yum install $package -y &>> $Logs
             VALIDATE $? "Installation of $package"
         else
            echo -e "$Package is already installed "
         fi
    done
fi

