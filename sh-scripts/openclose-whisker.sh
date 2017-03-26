#!/bin/bash
#
# Created by San 'ReDemoN' Monico
# https://github.com/redemonbr
#
##########################################
# Open and closes XFCE4 Whisker Menu when a certain event is fired.
# Recommended to use when the "windows" key from a regular keyboard is pressed in a Linux OS
#
#########################################
# To use it, bind this script to an event. Example:
# -Binding it to the "windows" key:
#	1: Download this script
# 	2: Go to "Application Shortcuts" from Keyboard settings
#	3: Add a new event
#	4: Add this command:
#		sh /path/to/this/script/openclose-whisker.sh
#	5: And add "windows" (aka Super, in Linux) key to it



if [ -z $(ps -C xfce4-popup-whiskermenu -opid=) ]
    then xfce4-popup-whiskermenu
else killall xfce4-popup-whiskermenu
fi
