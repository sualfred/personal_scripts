#!/bin/bash
check_ip=('192.168.2.245')
wol_mac=('70:85:c2:02:c6:31')
wol_ip=('192.168.2.250')
loop_sleep_timer=10s

# Loop
while true
do

        unset found_client

        # Check if client IPs are online
        for client in "${check_ip[@]}"
        do
                ping=$(ping "$client" -c 1 | grep "1 received")
                if ! [ -z "$ping" ]; then

                        found_client="$client"
                        echo "Found $client"
                        break

                fi
        done

        # Wake all required devices as soon as one client IP has been found

        if ! [ -z "$found_client" ]; then

                i=0

                for target in "${wol_mac[@]}"
                do
                        # Ping target to check if it's already online
                        ping=$(ping "${wol_ip[$i]} -c 1" | grep "1 received")

                        # Send WOL if required
                        if [ -z "$ping" ]; then
                                echo "Client $client found and ${wol_ip[$i]} is offline. Sending WOL signal."
                                sudo etherwake "$wake_target"
                                sleep 10s
                        fi

                        ((++i))

                done
        fi

        # Wait for the next round
        sleep "$loop_sleep_timer"
done
