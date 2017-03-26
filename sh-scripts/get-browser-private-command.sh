#!/bin/bash

# convert the parameter to lowercase
browser=${1,,}

# uses shell pattern matches so it matches even if the sufix does NOT exist.
# this is done because there might be multiple versions with different sufixes, like "-aurora", "-beta",
# "-bin", "-browser", "-canary", "-dev", "-developer", "-esr", "-git", "-gtk", "-gtk2" "-gtk3", "nightly",
# "-qt5", "-snapshot", "-stable" and others (including combinations of those) that are not easy to track

# "min" and "brave" browsers have private mode, but no documentation at this time (22/01/2016) for cli using "--help" and "man", not even "--version" worked

case $browser in
	chromium | chromium-* | chrome | chrome-* | google-chrome | google-chrome-* | inox | inox-* | vivaldi | vivaldi-* | yandex-browser | yandex-browser-*)
		echo --incognito
		;;
	firefox | firefox-* | iceweasel | iceweasel-* | icecat | icecat-*)
		echo --private-window
		;;
	opera | opera-*)
		echo --private
		;;
	epiphany | epiphany-* | gnome-web | gnome-web*)
		echo --incognito-mode
		;;
	seamonkey | seamonkey-*)
		echo -private
		;;
	qupzilla | qupzilla-*)
		echo --private-browsing
		;;
	otter-browser | otter-browser-*)
		echo --new-private-tab
		;;
esac