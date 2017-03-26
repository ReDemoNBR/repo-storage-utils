#!/bin/bash

# get default web browser from xdg-settings (XFCE Preferred Applications)
browser=$(xdg-settings get default-web-browser)

# if it is a custom web browser, then it will get the desktop file that is in XFCE user settings directory
# else it will get it from the desktop file from /usr/share/applications directory
if [[ $browser = "custom-WebBrowser.desktop" ]]
	then
	file=~/.local/share/xfce4/helpers/$browser
	search="X-XFCE-Commands=*"
else
	file=/usr/share/applications/$browser
	search="Exec=*"
fi

# reads line by line until it finds the "X-XFCE-CommandsWithParameter=" (if is a custom web browser) or "Exec=" (if not a custom web browser)
# then gets the command to initiate it
while read line
	do
	if [[ $line = $search ]]
		then
		replace=$(echo $search | sed 's/\*//')
		echo $(echo $(echo $line | sed "s/$replace//") | sed 's/"//g') | sed 's/ %.*$//'
		break;
	fi
done < $file