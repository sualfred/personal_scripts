
Script
1. nano tvhwakeup.sh (Edit variables in the head of the file)
2. chmod +x tvhwakeup.sh

Service

1. nano tvhwakeup.service (Edit script paths)
2. cp tvhwakeup.service /etc/systemd/system
3. chmod +x /etc/systemd/system/tvhwakeup.service
4. systemctl daemon-reload
5. systemctl enable tvhwakeup.service
6. service tvhwakeup start

Check if it's working:
1. cat /var/log/syslog | grep TVH  --> Should return the next recording and wake up time
2. rtcwake -m show --> should return the set wake up time of the bios
