#!/bin/sh

UPDATE=10
WHITE="#9d9d9d"
GRAY="#444444"

while :; do 
	# Drive Space
	HOMED=`df -h | grep /dev/sda4 | awk '{print $4}' | sed -e 's/G/GB/g'`
	XSTOR=`df -h | grep /dev/sdb1 | awk '{print $4}' | sed -e 's/G/GB/g'`
	if [ $XSTOR == ""]; then XSTOR="N/A"; fi	

	#Battery
	STATE=$(acpi | awk '{print $3}')
	TIME=$(acpi | awk '{print $4}' | sed 's/,//')
	if [ "$STATE"  == "Discharging," ]; 
	then BATTICON="^i(/home/cas/.xmonad/dzen2/icons/power-bat2.xbm)";
	else BATTICON="^i(/home/cas/.xmonad/dzen2/icons/power-ac.xbm)";
	fi

	# Date
	DATE=$(date +"%a %b %d %H:%M")
	# Load
	LOAD=$(uptime |  sed 's/.*://; s/,//g')
	LOADICON="^i(/home/cas/.xmonad/dzen2/icons/load.xbm)";
	# Memory
	MEM=$(free -m | grep "buffers/cache" | awk '{print $3}')
	MEMICON="^i(/home/cas/.xmonad/dzen2/icons/mem.xbm)";
	
	# CPU Temp
	CPU=`sensors | grep "Core 1" | awk '{print $3}' | sed -e 's/+//g' | sed -e 's/\..*//'`
	
	if [ "$CPU" -lt 60 ]; then CPU="^fg($WHITE)$CPU"C"^fg()";
		elif [[ "$CPU" -gt 49 && "$CPU" -lt 85 ]]; then CPU="^fg(#cc6600)$CPU"C"^fg()";
		else CPU="^fg(red)$CPU"C"^fg()";
	fi
	CPUICON="^i(/home/cas/.xmonad/dzen2/icons/temp.xbm)"

	echo "|  home:^fg($WHITE)$HOMED^fg()  xstor:^fg($WHITE)$XSTOR^fg()  |  $MEMICON^fg($WHITE)$MEM"/5872MB"^fg()  $CPUICON$CPU  $LOADICON^fg($WHITE)$LOAD^fg()  $BATTICON^fg($WHITE)$TIME^fg()  |  ^fg($WHITE)$DATE^fg()  "

	sleep $UPDATE

done | dzen2 -x 650 -y 0 -h 16 -w 1216 -ta r -fg '#444444' -bg '#0f0f0f' -fn '-*-terminus-normal-*-*-*-12-*-*-*-*-*-iso8850-1' 


