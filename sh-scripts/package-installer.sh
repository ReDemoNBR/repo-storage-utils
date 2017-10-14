# handle options
eval set -- $(getopt -n $0 -o "IX" -l "install,export" -- "$@")
declare I X
while [ $# -gt 0 ] ; do
	case "$1" in
		-I) I=true ; shift ;;
		-X) X=true ; shift ;;
		--install) I=true ; shift ;;
		--export) X=true ; shift ;;
		# --*) echo "bad option '$1'" ; exit 1 ;;
		--) shift ;;
		-*) echo "bad option '$1'" ; exit 1 ;;
		*) file=("${files[@]}" "$1") ; shift ;;
	esac
done

# show help
if [[ "$h" == true ]]; then
	echo "HELP ME!"
	exit 0
fi

# show error if no file argument (required argument)
if [[ -z $file ]]; then
	echo "Missing argument with file location"
	exit 1
fi

# show error if no install and no export option (required option)
if [[ -z $I ]] && [[ -z $X ]]; then
	echo "Missing option to install or to export"
	exit 1
fi

# show error if install and export options are used together
if [[ "$I" == true ]] && [[ "$X" == true ]]; then
	echo "Invalid options..."
	echo "Select only install or export"
	exit 1
fi

# export the list of installed packages to file
if [[ "$X" == true ]]; then
	pacman -Qi | grep Name | cut -d ":" -f 2 | cut -d " " -f 2 > $file
	exit 0
fi


#installs the shit out
if [[ "$I" == true ]]; then
	pacman="/tmp/rdn-pacman.tmp"
	aur="/tmp/rdn-aur.tmp"
	echo "" > pacman
	echo "" > aur
	echo "Refreshing databases in order to install..."
	yaourt -Syya
	echo "Installing updates..."
	sudo pacman -Su --noconfirm
	echo "Checking for uninstalled packages..."
	while read package in $file; do
		# checks if package is already installed
		if [[ -z pacman -Qi | grep Name | cut -d ":" -f 2 | cut -d " " -f 2 | grep "^${package}$" ]]; then
			# adds package to pacman list
			if [[ -n pacman -Ss "^${package}$" ]]; then
				echo "$package" >> pacman
			# or adds to aur list
			elif [[ -n yaourt -Ss "^${package}$" ]]; then
				echo "$package" >> aur
			fi
		fi
	done
	cat "$pacman" | tr '\n' ' ' > pacman
	cat "$aur" | tr '\n' ' ' > aur
	echo "" >> pacman
	echo "" >> aur
	echo "Installing packages..."
	sudo pacman -Syy --noconfirm $(cat $pacman)
	echo "Installing packages from AUR now"
	yaourt -Sa --noconfirm $(cat $aur)
	echo "Everything is installed"
	exit 0
fi