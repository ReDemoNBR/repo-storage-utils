#!/bin/bash
#
# Created by San 'ReDemoN' Monico
# https://github.com/redemonbr
#
###########################################################
# Screenshot the whole screen and prompts you to save the file in ~/Pictures folder
# Useful to be bound to Print Screen key
#
#########################################
# To use it, bind this script to an event. Example:
# -Binding it to the "printscreen" key:
#	1: Download this script
# 	2: Go to "Application Shortcuts" from Keyboard settings
#	3: Add a new event
#	4: Add this command:
#		sh /path/to/this/script/printscreen.sh
#	5: And add "printscreen" key to it

xfce4-screenshooter --mouse --fullscreen --save ~/Pictures

