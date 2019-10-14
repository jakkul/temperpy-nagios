#!/bin/bash

: <<'END_COMMENT'

This bash script reads temperature from https://pypi.org/project/temper-py/ and returns in a format that is consumeable by Nagios. Also provides info for graphing.

Input parameters:

 -c critical level Celcius (default 30)
 -w warning level Celcius (default 26)
 -i which sensor on the USB are we using (default first one)
 -b BUS to use (default first one)

 be sure to set proper temper.py path and proper entitlements

Output:

 Temperature OK - Sensor XXX ID YYY = 21.38C | temp=21.38;crit=30;warn=26;

 also provides return codes
 0 - OK
 1 - WARNING
 2 - CRITICAL
 3 - UNKNOWN

Dependencies:
  
 temper.py
 bc

Versions:

 0.1 no parameters, but runs

END_COMMENT




echo "A"
