#!/bin/bash

help () {

cat <<'END_COMMENT'

This bash script reads temperature from https://pypi.org/project/temper-py/ 
and returns in a format that is consumeable by Nagios. 
Also provides info for graphing.

Input parameters:

 -c critical level Celcius (default 30)
 -w warning level Celcius (default 26)
 -b BUS/device to use (default first one) (starts with 1)
 -i which sensor on the USB are we using (default first one) (allowed values internal external)

 be sure to set proper temper.py path and proper entitlements

Output:

 OK TEMP is 23.0 C on external at device 2 | temp=23.0;warn=30;crit=26

 also provides return codes
 0 - OK
 1 - WARNING
 2 - CRITICAL
 3 - UNKNOWN

Dependencies:
  
 temper.py
 bc
 getopts 

Versions:

 0.1 runs, kinda, jakkul@gmail.com

END_COMMENT

}

TEMPERPATH=temper.py

DEFAULTCRIT=26
DEFAULTWARN=30
IDdevice=2
SENSOR=internal
SENSOR=external
SENSOR=internal

WARN=$DEFAULTWARN
CRIT=$DEFAULTCRIT

while getopts ":w:c:b:i:h" opt; do
  case ${opt} in
    h ) # help
	    help
	    exit 0
      ;;
    w ) # set warning level
	    WARN=$OPTARG
      ;;
    c ) # set critical
	    CRIT=$OPTARG
      ;;
    b ) # set bus-device
	    IDdevice=$OPTARG
      ;;
    i ) # set sensor
	SENSOR=$OPTARG
      ;;

    \? ) echo "use $0 -h to get a help message"
	    exit 3
      ;;
  esac
done

TEMPEROUT=`$TEMPERPATH | sed -n ${IDdevice}p`
TEMPINTERNAL=`echo $TEMPEROUT | cut -d " " -f 7 | cut -d "C" -f 1`
TEMPEXTERNAL=`echo $TEMPEROUT | cut -d " " -f 10 | cut -d "C" -f 1`

if [ $SENSOR == "external" ]
then
	export TEMPTOCHECK=$TEMPEXTERNAL
fi

if [ $SENSOR == "internal" ]
then
	export	TEMPTOCHECK=$TEMPINTERNAL
fi

case $TEMPTOCHECK in
    ''|*[!0-9.]*) echo bad input ; exit 3 ;;
    *) A=1 ;;
esac


MSG=`echo TEMP is $TEMPTOCHECK C on $SENSOR at device $IDdevice \| temp=$TEMPTOCHECK\;warn=$WARN\;crit=$CRIT`

if (( $(echo "$TEMPTOCHECK < $WARN" | bc -l) ))
then
	echo OK $MSG
	exit 0
fi

if (( $(echo "$TEMPTOCHECK > $CRIT" | bc -l) ))
then
        echo CRIT $MSG
	exit 2
fi
	

if (( $(echo "$TEMPTOCHECK > $WARN" | bc -l) )) && (( $( echo "$TEMPTOCHECK < $CRIT" | bc -l ) ))
then
	echo WARNING $MSG
	exit 1
fi


echo $TEMPEROUT 

exit 3


