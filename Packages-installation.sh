#!/bin/bash
#check if user is root
ID=$(id -u)
#Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#create a log file
Time=$($date +%F-%H-%M-%S)
Logs="/var/$0-$Time.log"

echo "script started executing at $Y $Time $N" &>> $Logs


if [ $ID ne 0 ]
then
    echo "Not root user"
    exit 1 # to exit the script incase of error
else
    for package in $@
    do
        yum list installed $package &>> $Logs # to check if package is already installed.
        if [ $? ne 0] # if not installed
        then
            yum install $package -y &>> $Logs
        else
            echo "$Package is already installed"
        fi
    done
fi

