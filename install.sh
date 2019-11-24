#!/bin/bash

# Webserver. Configure apache, enable cgi-bin, allow /tmp/writes.
sudo apt -y install apache2
sudo perl -spi -e 's!PrivateTmp=true!PrivateTmp=false!g' /lib/systemd/system/apache2.service
pushd /etc/apache2/mods-enabled
  sudo ln -s ../mods-available/cgi.load
popd
sudo systemctl restart apache2
sudo systemctl enable apache2

# Install the cgi bin script
sudo cp setdecoder.cgi /usr/lib/cgi-bin
sudo chmod +x /usr/lib/cgi-bin/setdecoder.cgi
sudo systemctl daemon-reload

# Install network decoder
sudo cp network-decoder.service /lib/systemd/system
sudo chmod 644 /lib/systemd/system/network-decoder.service
sudo systemctl daemon-reload

# Permit www-data (apache cgi-bin) to run the /tmp/restart.sh script
sudo sh -c 'echo "www-data ALL= NOPASSWD: /home/pi/network-decoder/restart.sh" >>/etc/sudoers'
