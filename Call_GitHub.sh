#!/bin/sh

stty -echo
printf Token:
read token
stty echo
if [ "$1"x != "x" ]; then
        FileName=$1
else
        echo FileName:
        read FileName
fi
Username="ZoltanJu"
Repo="Scripts"

curl -s -H "Authorization: token $token" -H 'Accept: application/vnd.github.v3.raw' -L "https://api.github.com/repos/$Username/$Repo/contents/$FileName" | sh
