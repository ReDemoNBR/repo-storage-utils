#!/bin/bash

#vncserver(! ([^ ]+))?

pw=$(echo $(echo $1 | tr -s " ") | sed 's/vncserver//g')
if [[ -z $pw ]]; then
	echo "no password"
	x11vnc -display :0
else x11vnc -display :0 -passwd $pw
fi