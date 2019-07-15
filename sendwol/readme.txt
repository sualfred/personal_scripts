Small shell script to wake server, media, or anything else via WOL as soon as one of your clients is available in the network

Script
1. nano sendwol.sh (Edit arrays in the head of the file)
2. chmod +x sendwol.sh

Service

1. nano sendwol.service (Edit script paths)
2. cp sendwol.service /etc/systemd/system
3. chmod +x /etc/systemd/system/sendwol.service
4. systemctl daemon-reload
5. systemctl enable sendwol.service
6. service sendwol start
