#!/bin/sh

UPDATE=1
WHITE="#9d9d9d"
GRAY="#444444"

while :; do 

	# Internet
	CON=0
	ETH0=$(ip -o addr | grep "eth0.*inet 1.*global" | awk '{print $4}' | sed -e 's/\/.*//g')
	WLAN0=$(ip -o addr | grep "wlan0.*inet 1.*global" | awk '{print $4}' | sed -e 's/\/.*//g')
	if [ "$ETH0" != "" ] 
		then {
			CON=$ETH0;
			CONICON="^i(/home/cas/.xmonad/dzen2/icons/net-wired2.xbm)";}
			elif [ "$WLAN0" != "" ]
				then {
				CON=$WLAN0;
				CONICON="^i(/home/cas/.xmonad/dzen2/icons/net-wifi5.xbm)";}
			else CON="^fg($GRAY)offline^fg()"; fi

	# Volume
	VOL=`amixer sget Master | grep Mono: | awk '{print $4 $6}' | sed -e 's/\%//g' | sed -e 's/\[//' | sed -e 's/\]//' ` 	
	ON=`echo $VOL | grep "on"` 
	if [ "$ON" != "" ]; then 
		ON=`echo $VOL | sed -e 's/\[on\]//'`;
		VOLICON="^i(/home/cas/.xmonad/dzen2/icons/vol-hi.xbm)"
		VOL="^fg($WHITE)$ON^fg()";
	else
		ON=`echo $VOL | sed -e 's/\[off\]//'`;
		VOLICON="^i(/home/cas/.xmonad/dzen2/icons/vol-mute.xbm)"
		VOL="^fg($GRAY)$ON^fg()";
	fi


	echo "^fg($GRAY)|^fg()  ^fg($WHITE)$VOL^fg() ^fg(#444444)$VOLICON | ^fg() ^fg($WHITE)$CON^fg() ^fg(#444444)$CONICON^fg()  "

	sleep $UPDATE

		done | dzen2 -x 1316 -y 1050 -h 16 -w 450 -ta r -fg '#9d9d9d' -bg '#0f0f0f' -fn '-*-terminus-normal-*-*-*-12-*-*-*-*-*-iso8850-1' 


