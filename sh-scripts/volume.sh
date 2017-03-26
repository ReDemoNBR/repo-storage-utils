#!/bin/bash
pactl set-sink-mute 1 false
pactl set-sink-volume 1 "$1"1%