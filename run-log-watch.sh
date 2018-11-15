#!/usr/bin/env bash
#	Must install inotifywait tools first

#	Global variables
DEVICE='CSR-W52-Bxl'
LOGFILE="/var/log/mikrotik-crs-w52.log"

#	Patterns
DHCPLEASE='offering lease|without success'
FAMOCOPROD="fam-prod: disconnected"
GKT='group key timeout'
EXTENSIVE='extensive data loss'

#	Functions
function notify_admin() {
secret_key="3H5MYW9_mDaB7Cw83TG8V"
value1=$1
value2=$2
value3=$3
json="{\"value1\":\"${value1}\",\"value2\":\"${value2}\",\"value3\":\"${value3}\"}"
curl -X POST -H "Content-Type: application/json" -d "${json}" https://maker.ifttt.com/trigger/log-watch/with/key/${secret_key}
}

#	echo "$PRODCOUNT" >> /home/pi/Documents/scripts/host-watch/hosts

while inotifywait -e modify $LOGFILE; do
#	Dhcp offering lease without success
	if tail -n1 $LOGFILE | grep -E "$DHCPLEASE"; then
		MESSAGE=`tail -n1 $LOGFILE`
		MESSAGEtemp=${MESSAGE// /_}
		DHCPLEASEtemp=${DHCPLEASE// /_}
		notify_admin $DHCPLEASEtemp $DEVICE $MESSAGEtemp
	fi
#	Extensive data loss
	if tail -n1 $LOGFILE | grep "$EXTENSIVE"; then
		MESSAGE=`tail -n1 $LOGFILE`
		MESSAGEtemp=${MESSAGE// /_}
		EXTENSIVEtemp=${EXTENSIVE// /_}
		notify_admin $EXTENSIVEtemp $DEVICE $MESSAGEtemp
	fi
#	Famoco Prod disconnected
	if tail -n1 $LOGFILE | grep "$FAMOCOPROD"; then
		MESSAGE=`tail -n1 $LOGFILE`
		MESSAGEtemp=${MESSAGE// /_}
		FAMOCOPRODtemp=${FAMOCOPROD// /_}
	fi
#	Group key timeout
	if tail -n1 $LOGFILE | grep "$GKT"; then
		MESSAGE=`tail -n1 $LOGFILE`
		MESSAGEtemp=${MESSAGE// /_}
		GKTtemp=${GKT// /_}
		notify_admin $GKTtemp $DEVICE $MESSAGEtemp
	fi
done
