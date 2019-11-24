#!/bin/bash

echo -e "Content-type: text/html\n\n"
echo -e '<meta http-equiv="Expires" content="0">'

# call the webserver to reconfigure the decoder:
# with: http://192.168.2.244/cgi-bin/setdecoder.cgi?addr=udp://@234.1.2.91:4091

# Extract the given address from the url
ADDR=`echo $QUERY_STRING | cut -d'=' -f2`

echo "<h1>Setting decoder to address: $ADDR</h1>"

# Write the address to a cfg file that the VLC service can access.
echo "ADDRESS=$ADDR" >/tmp/network-decoder.cfg
chmod 755 /tmp/network-decoder.cfg

#echo 'Environment Variables:'
#echo '<pre>'
#/usr/bin/env
#echo '</pre>'

# /etc/sudoers has been patched to allow www-data to sudo this file
sudo /home/pi/network-decoder/restart.sh

