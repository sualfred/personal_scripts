#!/bin/bash

##FTP
HOST=''
USER=''
PASSWD=''
DIR=''

##WebGrab
WEBGRAB='/opt/scripts/webgrab/.wg++'
FILE='guide.xml'

upload_guide() {
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd $DIR
put $FILE
quit
END_SCRIPT
}

run_webgrab() {
run.sh
}

send_data() {
cat $FILE | sudo socat - UNIX-CONNECT:/home/hts/.hts/tvheadend/epggrab/xmltv.sock
}

cd $WEBGRAB && run_webgrab && send_data && upload_guide
