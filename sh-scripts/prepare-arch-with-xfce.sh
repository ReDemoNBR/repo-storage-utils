#!/bin/bash



# Make your changes here
username="myuser"
userpasswd="mypassword"
rootpasswd="rootpasswd"
hostname="myhostname"
swapfilesize="2G" ## let empty for no swapfile creation
tmpsize="1G" ## let empty for no resize of /tmp
keyboard="/usr/share/kbd/keymaps/i386/qwerty/br-abnt2.map.gz" ## let empty for standard english keyboard
mainlang="en_US.UTF-8 UTF-8"
secondarylangs=("en_US ISO-8859-1" "pt_BR.UTF-8 UTF-8" "pt_BR ISO-8859-1" "en_GB.UTF-8 UTF-8" "en_GB ISO-8859-1")
timezone="/usr/share/zoneinfo/America/Sao_Paulo"



if [[ $EUID -ne 0 ]]; then
    echo "must run as root"
    echo
    exit 1
fi


## change password function to reuse
change_passwd {
	user=$1
	password=$2
	echo -e "$password\n$password" | passwd "$user"
}

## build function to reuse
build_and_install {
	as_user=$1
	package=$2
	su -l "$as_user" --command "mkdir -p /tmp/build"
	su -l "$as_user" --command "cd /tmp/build ; git clone https://aur.archlinux.org/${package}.git $package ; cd $package ; makepkg"
	cd "/tmp/build/${package}"
	pacman -U --noconfirm "${package}*.pkg.tar.xz"
	cd -
	rm -fr /tmp/build
}

# AS ROOT

## Initialize pacman
pacman-key --init
## Refresh pacman
pacman -Syy
## Install ArchLinux and ArchLinuxARM keyrings
pacman -S --needed --noconfirm archlinux-keyring archlinuxarm-keyring
## Install ca-certificates
pacman -S --needed --noconfirm ca-certificates ca-certificates-utils ca-certificates-cacert ca-certificates-mozilla
## Update all packages
pacman -Syu --noconfirm
## Install basic packages
pacman -S --needed --noconfirm base base-devel yajl wget git tk vi vim bash-completion
## Install raspberry-pi required packages (if not already installed
pacman -S --needed --noconfirm raspberrypi-firmware raspberrypi-bootloader raspberrypi-bootloader-x
## Install fake-hwclock as RPi doesn't have RTC
pacman -S --needed --noconfirm fake-hwclock
systemctl enable fake-hwclock.service


## Configuration

### Keyboard layout
if [[ -n $keyboard ]]; then
	loadkeys $keyboard
fi


### Locale
#### Uncomment the desires locales in this file ###### nano /etc/locale.gen
sed -i "/#$mainlang/s/^/#/g" /etc/locale.gen
for lang in $otherlang; do
    sed -i "#$lang/s/^/#/g" /etc/locale.gen
done
#### Then generate the locales
locale-gen
#### configure details in /etc/locale.conf or just add "LANG=en_US.UTF-8" without quotes
lang=$(echo $mainlang | cut -d " " -f 1)
echo "LANG=$lang" > /etc/locale.conf
echo "LC_TELEPHONE=$lang" >> /etc/locale.conf
echo "LC_PAPER=$lang" >> /etc/locale.conf
echo "LC_NUMERIC=$lang" >> /etc/locale.conf
echo "LC_MONETARY=$lang" >> /etc/locale.conf
echo "LC_IDENTIFICATION=$lang" >> /etc/locale.conf
echo "LC_MEASUREMENT=$lang" >> /etc/locale.conf
echo "LC_ADDRESS=$lang" >> /etc/locale.conf
echo "LC_NAME=$lang" >> /etc/locale.conf
echo "LC_TIME=$lang" >> /etc/locale.conf



### Timezone
ln -fs $timezone /etc/localtime


### Hostname
echo $hostname > /etc/hostname
echo "127.0.1.1 localhost.localdomain $hostname" >> /etc/hosts


### Create Swapfile (with 2GB in /swapfile)
if [[ -n $swapfilesize ]]; then
	#### Allocate
	fallocate -l $swapfilesize /swapfile
	#### Adjust permissions
	chmod 600 /swapfile
	#### Create swapfile as swap type
	mkswap /swapfile
	#### Activate
	swapon /swapfile
	#### Add it to fstab so it is mounted on boot
	echo "/swapfile none swap defaults 0 0" | tee -a /etc/fstab
fi

### Resize /tmp to 1GB
if [[ -n $tmpfilesize ]]; then
	echo "tmpfs /tmp tmpfs rw,nodev,nosuid,size=$tmpfilesize 0 0" | tee -a /etc/fstab
fi


### Install HRNG driver
pacman -S --needed --noconfirm rng-tools
echo 'RNGD_OPTS="-o /dev/random -r /dev/hwrng"' > /etc/conf.d/rngd
systemctl enable rngd.service


## Manage users
### Create user $username in wheel group
useradd --create-home --gid users --groups wheel --shell /bin/bash "$username"
### Change $username password
change_passwd "$username" "$userpassword"

### Allow all users from wheel group to execute sudo commands
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers
### Remove the standard user "alarm"
userdel --remove --force alarm
### Change root password
change_passwd root "$rootpasswd"
su -l "$username" --command "cd ~ ; mkdir Documents Downloads Musis Pictures Public Templates Videos"

## Install yaourt
build_and_install "$username" package-query
build_and_install "$username" yaourt


## Install graphical interface
### Install X.org
pacman -S --needed --noconfirm xorg-xinit xorg-server xorg-server-common xterm
### Install video driver
pacman -S --needed --noconfirm mesa xf86-video-vesa xf86-video-fbdev
### Install audio
pacman -S --needed --noconfirm alsa-firmware alsa-utils pulseaudio pulseaudio-alsa
### Install desktop environment (Xfce)
pacman -S --needed --noconfirm xfce4 xfce4-goodies exo thunar thunar-archive-plugin thunar-media-tags-plugin xdg-utils xdg-user-dirs
sudo -u "$username" yaourt -S --noconfirm xdg-su
### Install packages to automount USB
pacman -S --needed --noconfirm gvfs udisks2 thunar-volman
### Install display manager (LightDM GTK Greeter)
pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm.service
### Install network manager
pacman -S --needed --noconfirm networkmanager networkmanager-dispatcher-ntpd networkmanager-openvpn networkmanager-openconnect networkmanager-pptp nm-connection-editor network-manager-applet
systemctl enable dhcpcd.service
systemctl enable NetworkManager.service
### Install bluetooth
pacman -S --needed --noconfirm blueman bluez bluez-utils
systemctl enable bluetooth.service
sudo -u "$username" yaourt -S --noconfirm pi-bluetooth
systemctl enable brcm43438.service
### Install pamac (graphical interface to manage packages)
sudo -u "$username" yaourt -S --noconfirm pamac-aur pamac-tray-appindicator



## Reboot the system
shutdown -r now