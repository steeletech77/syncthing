#!/bin/bash

rsync -r -v --ignore-existing /data/Photos/ /home/scott/cloudrive/photos/ --log-file=/home/scott/.local/output.txt --exclude '*.db'

filename="/home/scott/.local/output.txt"

mapfile -t array < $filename

if [ "${#array[@]}" -ne 3 ]
then
    printf '%s\n' "${array[@]}" | mail -s "Photo sync" myemail@mailserver.com
fi

rm /home/scott/.local/output.txt
