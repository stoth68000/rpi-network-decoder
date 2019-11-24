#!/bin/bash

LOG=/tmp/network-decoder.log
PERMCFG=/home/pi/network-decoder/env.cfg
TMPCFG=/tmp/network-decoder.cfg

echo "Running at `date`" >$LOG

STATE="error";
while [ $STATE == "error" ]; do
    #do a ping and check that its not a default message or change to grep for something else
    STATE=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error)
    if [ $STATE != "ok" ]; then
        echo "Waiting for network to appear" >>$LOG
        sleep 2
    fi
done

cd /home/pi/network-decoder
while [ 1 ]; do
	if [ -f $TMPCFG ]; then
		echo "Using configuration f$TMPCFG" >>$LOG
		source $TMPCFG
	else
		echo "Using configuration from $PERMCFG" >>$LOG
		source $PERMCFG
	fi
	vlc -I dummy $ADDRESS >>$LOG 2>&1
	sleep .5
done
