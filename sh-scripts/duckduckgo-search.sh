#!/bin/bash
#
# Created by San 'ReDemoN' Monico
# https://github.com/redemonbr
#
#############################################################################
# Opens your default browser to perform a search on DuckDuckGo, with bangs included, from XFCE4 Whisker Menu search input text area.
# Supports private/incognito mode in some browsers if started with two exclamation marks.
# If started with just one exclamation mark it will do a regular search
#
# To add it, download this file and go to 'Search Actions' from XFCE4 Whisker Menu properties to add the actions:
# -1: Regular Search
# 	-Name: DuckDuckGo Search
#	-Pattern: (^!(?!!).*)
#	-Command: sh /path/to/this/file/duckduckgo-search.sh "\1"
#	-Regular expression: true
#
# -2: Private Search (using incognito/private mode from browsers, if available - uses "./get-browser-private-command.sh")
#	-Name: DuckDuckGo Private Search
#	-Pattern: (^!!.*)
#	-Command: sh /path/to/this/script/duckduckgo-search.sh "\1"
#	-Regular expression: true
#
##############################################################################

#remove multiple spacing, and then possible backslashes, in case it is used from terminals escaping the exclamation mark
dir=$(dirname $0)
val=$(echo $(echo $1 | tr -s " ") | sed 's/\\//g')

#get user's default web browser
browser_cmd=$(sh $dir/get-default-web-browser.sh)

#DuckDuckGo website address
ddg="https:\/\/duckduckgo.com/?q="

#check if it is using double exclamation marks to open in private/incognito mode
if [[ $val = !!* ]]
    then
    browser_name=$(echo $browser_cmd | sed 's/\/.*\///g')
    priv=$(sh $dir/get-browser-private-command.sh $browser_name)
    val=${val:1:${#val}-1} #removes the first "!" that makes it private
    $browser_cmd $priv "$ddg$val"
else $browser_cmd "$ddg$val"
fi