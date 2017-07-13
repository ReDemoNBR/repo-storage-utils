eval set -- $(getopt -n $0 -o "mglh" -l "mauricio,gustavo,lontra,herzog,marcelo" -- "$@")
declare m g l h
while [ $# -gt 0 ] ; do
    case "$1" in
        -m) m=true ; shift ;;
        -g) g=true ; shift ;;
        -l) l=true ; shift ;;
        -h) h=true ; shift ;;
		--mauricio) m=true ; shift ;;
        --gustavo) g=true ; shift ;;
        --lontra) l=true ; shift ;;
        --herzog) h=true ; shift ;;
        --marcelo) h=true ; shift ;;
        --*) echo "bad option '$1'" ; exit 1 ;;
		--) shift ;;
        -*) echo "bad option '$1'" ; exit 1 ;;
     esac
done
# show help message
if [[ "$h" == true ]]; then
	echo "HELP!"
	exit 0
fi

if [[ -z $archsystem ]]; then
    echo "Missing argument with the location of the ArchLinux ARM file (.tag.gz)"
    exit 1
fi