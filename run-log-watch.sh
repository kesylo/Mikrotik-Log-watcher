#!/usr/bin/env bash
# must install inotifywait tools first

LOGFILE="/var/log/mikrotik-crs-w52.log"

# Patterns
ERROR='Nov  7'

# temp variables
mkdir /home/pi/Documents/out

inotifywait -q -m -e close_write $LOGFILE |
while read -r filename event; do
	
	mkdir /home/pi/Documents/enter

	# get number of lines in file
	NBRLINES=`wc -l $LOGFILE | awk '{ print $1 }'`

	# get string at specific line
	STRING=`sed $NBRLINES'!d' $LOGFILE`

	# Search at that line for given patterns
	if echo "$STRING" | grep -w "$ERROR"; then
		echo "matched";
		mkdir /home/pi/Documents/match
		echo "$ERROR" >> temp1
	# attendre 4h avant de ressend cet event si ca se repette
	else
		echo "no match";
		mkdir /home/pi/Documents/notmatch
		echo "$ERROR" >> temp
	fi
done
