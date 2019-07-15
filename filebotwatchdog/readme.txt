
Script
1. Edit all paths and adjust to the local download logic
2. chmod 777 filebotwatchdog.sh

Service

1. Edit script path
2. filebotwatchdog.server -> /etc/systemd/system
3. chmod 777 filebotwatchdog.service
4. systemctl daemon-reload
5. systemctl enable filebotwatchdog.service
6. service filebotwatchdog start