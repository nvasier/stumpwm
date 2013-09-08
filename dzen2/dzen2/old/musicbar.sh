#!/bin/bash

UPDATE=1
WHITE="#9d9d9d"
ICON="^i(/home/cas/.xmonad/dzen2/icons/mpd.xbm)"
while :; do
	STATE=$(mpc | grep "\[")
	if [ "$STATE" == "" ]; then echo "^fg(#444444)$ICON STOPPED^fg()" ;
	else {
		BAND=$(mpc -f %artist% | head -n 1 | tr '[:lower:]' '[:upper:]')
		ALBUM=$(mpc -f %album% | head -n 1 | tr '[:lower:]' '[:upper:]')
		TRACK=$(mpc -f %track% | head -n 1)
		TITLE=$(mpc -f %title% | head -n 1| tr '[:lower:]' '[:upper:]')
		POS=$(mpc | grep "\[" | awk '{print $3}' | sed 's/\// \/\ /')
		STATE=$(mpc | grep "\[" | awk '{print $1}')
		if [ "$STATE" == "[playing]" ]; 
		then STATEICON="^i(/home/cas/.xmonad/dzen2/icons/dzen_bitmaps/play.xbm)";
		else STATEICON="^i(/home/cas/.xmonad/dzen2/icons/dzen_bitmaps/pause.xbm)";
		fi
 


		CORNER="/home/cas/.xmonad/dzen2/icons/myicons/corner.xbm"
		echo -n "^fg(#444444)$ICON^fg()"
		echo -n "^p(10)^fg($WHITE)$BAND^fg()^bg()^p(10)"
		echo -n "^fg(#444444)\\^fg()^p(10)^fg($WHITE)$ALBUM^fg()^p(10)"
		echo -n "^fg(#444444)\\^fg()^p(10)^fg($WHITE)$TRACK^fg()^p(10)"
		echo -n "^fg(#444444)\\^fg()^p(10)^fg($WHITE)$TITLE^fg()^p(10)"
		echo	"^p(10)^fg(#444444)$STATEICON^fg() ^fg($WHITE)$POS^fg()"
		
	}
	fi
	sleep $UPDATE

done | dzen2 -x 0 -y 1050 -h 16 -w 1416 -ta l -fg "#222222" -bg "#0f0f0f" -fn '-*-terminus-normal-*-*-*-11-*-*-*-*-*-iso8850-1'
