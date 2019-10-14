# temperpy-nagios
nagios plugin for Temper.py

https://pypi.org/project/temper-py/
https://github.com/ccwienk/temper

# help from the tool

```
This bash script reads temperature from https://pypi.org/project/temper-py/ 
and returns in a format that is consumeable by Nagios. Also provides info for graphing.

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
```
