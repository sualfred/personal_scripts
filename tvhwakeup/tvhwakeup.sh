#!/bin/sh
logger "Running TVH Recording Wake-Up Script"

while true
do
    next_recording=`curl -s http://kodi:kodi@localhost:9981/api/dvr/entry/grid_upcoming | tr , '\n' | grep start_real | sed "s/.*start_real.:\([0-9]*\).*/\1/" | sort -n | head -1`
    next_recording_converted=`date -d @$next_recording`
    if [ "$next_recording" = "" ]; then
        logger "TVH WakeUp: No recordings..."
    else
        wakeup=$((next_recording-600))
        wakeup_converted=`date -d @$wakeup`
        logger "TVH WakeUp: Next recording $next_recording_converted - Timestamp $next_recording"
        logger "TVH WakeUp: Set wake up time $wakeup_converted - Timestamp $wakeup"
        /usr/bin/sudo /usr/sbin/rtcwake -l -m no -t $wakeup
    fi

logger "TVH WakeUp: Wait 15 minutes"
sleep 15m

done
