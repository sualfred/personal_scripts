
Script
1. Edit path
2. chmod 777 tvhwakeup.sh

Service

1. Edit script path
2. tvhwakeup.server -> /etc/systemd/system
3. chmod 777 tvhwakeup.service
4. systemctl daemon-reload
5. systemctl enable tvhwakeup.service
6. service tvhwakeup start

Check if it's working:
1. cat /var/log/syslog | grep TVH  --> Should return the next recording and wake up time
2. rtcwake -m show --> should return the set wake up time of the bios