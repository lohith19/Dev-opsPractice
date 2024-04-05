#!/bin/bash

echo "Enter the file path"
read FILE

if [ -f $FILE ]
    then 
        echo " $FILE is a file"
elif [ -d $FILE ]
    then
        echo " $FILE is to a directory"
else
    echo " $FILE is unknown type"
fi

ls -l $FILE