#!/bin/bash
avr_ip="192.168.0.16"
cmd_on="http://192.168.0.21/cm?user=&password=&cmnd=Backlog%20Power%20on"
cmd_off="http://192.168.0.21/cm?user=&password=&cmnd=Backlog%20Power%20off"
loop_sleep_timer=5s

# Loop
while true
do

	sleep "$loop_sleep_timer"

	avr_json=$(curl -s "http://$avr_ip/YamahaExtendedControl/v1/main/getStatus")
	avr_power=$(echo "$avr_json" | jq -r '.power')


	if [[ "$avr_power" = "on" ]]; then
		echo $avr_power
		loop_sleep_timer=15s
		curl -s $cmd_on
	else		
		echo $avr_power
		loop_sleep_timer=5s
		curl -s $cmd_off
	fi

done
