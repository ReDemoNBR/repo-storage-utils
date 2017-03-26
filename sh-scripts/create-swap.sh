#!/bin/bash
size=$1
filepath=$2

echo $size
echo $filepath


#sudo fallocate -l $size $filepath
#sudo chmod 600 $filepath
#sudo mkswap $filepath
#sudo swapon $filepath

# add this line to this file: /etc/fstab
# $filepath none swap defaults 0 0