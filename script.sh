#!/bin/bash
# https://github.com/GreatMedivack/files/blob/master/test.txt
curl -o list.out https://raw.githubusercontent.com/GreatMedivack/files/master/list.out

if [ -n "$1" ]
then
    SERVER="$1"
else
    SERVER="noname"
fi

DATE="`date +'%e_%m_%Y'`"
FILE_NAME=""$SERVER"_"$DATE"_running.out"

touch $FILE_NAME

while INPUT_FILE= read -r line
do
    if [[ "$line" == *"Running"* ]]
    then
        line="`echo $line | cut -f1 -d' '`"
        echo "$line" >> $FILE_NAME
    fi
done < list.out

DIR="./archives/"

if [ ! -d "$DIR" ]
then
    mkdir ./archives
fi
 
if [ -f "./archives/""$SERVER"_"$DATE".tar.gz"" ]
then
    echo -e "\033[37;1;41mERROR: File already exists.\033[0m"
    if [ "`tar -tzf ./archives/""$SERVER"_"$DATE".tar.gz" > /dev/null && echo "ok"`" == "ok" ]
    then        
        echo -e "\033[42mOK: The previous file is ok.\033[0m" 
    else 
        echo -e "\033[37;1;41mERROR: The previous file is damaged.\033[0m"
    fi
else
    tar -czf ./archives/""$SERVER"_"$DATE".tar.gz" "$FILE_NAME"
    if [ "`tar -tzf ./archives/""$SERVER"_"$DATE".tar.gz" > /dev/null && echo "ok"`" == "ok" ]
    then        
        echo -e "\033[42mOK: Backup is good!\033[0m" 
    else 
        echo -e "\033[37;1;41mERROR: The file is damaged.\033[0m"
    fi
fi

rm -f $FILE_NAME list.out
