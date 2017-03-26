#!/bin/bash
#
# Created by San 'ReDemoN' Monico
# https://github.com/redemonbr
#
#############################################################################
# Opens the web page address written in your default browser quickly from your XFCE4 Whisker Menu.
# Automatically opens the secure http protocol (HTTPS) version if available if not mentioned, plus detects if the address needs the "www." in the beginning.
# Supports private/incognito mode in some browsers if ended with "@p", "@priv" or "@private".
# If not mentioned, it will open the regular browsing mode.
#
# To add it, download this file and go to 'Search Actions' from XFCE4 Whisker Menu properties to add the actions:
# **BE SURE NO OTHER SEARCH ACTION CONFLICTS WITH IT!
# -1: Regular Browsing
# 	-Name: Web Browser
#	-Pattern: (?:https?://)?(?:www\.)?[a-z0-9]+\.(?:[a-z]{2,3}|local)(?:\.[a-z]{2})?(?:/[^ ]+)*
#	-Command: sh /path/to/this/file/open-web.sh "\0"
#	-Regular expression: true
#
# -2: Private Web Browsing (using incognito/private mode from browsers, if available)
#	-Name: Private Mode Web Browser
#	-Pattern: (?:https?://)?(?:www\.)?[a-z0-9]+\.(?:[a-z]{2,3}|local)(?:\.[a-z]{2})?(?:/[^ ]+)* (@p|@priv|@private)$
#	-Command: sh /path/to/this/script/open-web.sh "\0"
#	-Regular expression: true
#
##############################################################################


dir=$(dirname $0)
#get user's default web browser
browser=$(sh $dir/get-default-web-browser.sh)

priv=$(echo $1 | cut -f 2 -d '@')
address=$(echo $(echo $1 | cut -f 1 -d '@') | tr -d ' ' )

if [[ $priv = "private" ]] || [[ $priv = "priv" ]] || [[ $priv = "p" ]] || [[ $priv = "incognito" ]]
    then
    browser_name=$(echo $browser | sed 's/\/.*\///g')
    priv=$(sh $dir/get-browser-private-command.sh $browser_name)
else priv=""
fi

# if address is correct
if [[ -n $(curl "$address") ]]
    then $browser $priv $address
# if address needs https
elif [[ -n $(curl "https://$address") ]]
    then $browser $priv "https://$address"
# if address needs https and www
elif [[ -n $(curl "https://www.$address") ]]
    then $browser $priv "https://www.$address"
# if address needs http
elif [[ -n $(curl "http://$address") ]]
    then $browser $priv "http://$address"
# if address needs http and www
elif [[ -n $(curl "http://www.$address") ]]
    then $browser $priv "http://www.$address"
fi