#!/bin/bash
image=~/Pictures/vampeta.jpg
wget http://cultebol.com.br/wp-content/uploads/2014/01/vampeta-fala-sobre-ensaio-nu-para-a-g-magazine.jpg -O $image

connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
activeOutput=$(xrandr | grep -e " connected [^(]" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/") 
connected=$(echo $connectedOutputs | wc -w)

# echo $connectedOutputs
# echo $activeOutput
# echo $connected

for i in {0..3}
do
	for j in 0 1 $connectedOutputs
	do
		xfconf-query -c xfce4-desktop -p "/backdrop/screen0/monitor$j/workspace$i/last-image" -s $image
	done
done