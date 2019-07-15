#!/bin/bash
#Generate SSH-Key for scp
#ssh-keygen && ssh-copy-id user@remote-server (as sudo su (root) without Password)
#Replace <domain name> and <path>
cd /etc/letsencrypt/live/<domain name>/ && sudo openssl pkcs12 -export -out cert.pfx -inkey privkey.pem -in cert.pem -certfile chain.pem -passout pass:Emby
scp /etc/letsencrypt/live/<domain name>/cert.pfx root@192.168.0.0:/var/www/<path>
#To skip the password use sshpass (apt-get install sshpass)
#Example:
#sshpass -p "MYPASSWORD" scp /etc/letsencrypt/live/<domain name>/cert.pfx root@192.168.0.0:/var/www/<path>

