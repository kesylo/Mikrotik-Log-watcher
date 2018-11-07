#!/usr/bin/env bash
# must install inotifywait tools first

FILE='/home/pi/Documents/scripts/host-watch/hosts'

# Patterns
ERROR='kings foine'

# temp variables

mkdir /home/pi/Documents/ran

inotifywait -q -m -e close_write $FILE |
while read -r filename event; do
	# get number of lines in file
	NBRLINES=`wc -l $FILE | awk '{ print $1 }'`
	# get string at specific line
	STRING=`sed $NBRLINES'!d' $FILE`
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
