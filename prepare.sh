#!/bin/bash
# Full preparation of machine for DoS attack using russian IP addresses.
# Installs Docker, Tor, configures Tor to use russian IP.
# Created for Debian-based Linux, I used Ubuntu20.04. Feel free to change script to work on your distro.
# Author: Pavlo P.

# Docker install start
apt update && apt upgrade -y

apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt install docker-ce docker-ce-cli containerd.io -y
# Docker install finish

# Install tor
apt install tor -y

sed  '/ControlPort/s/^#//g' -i /etc/tor/torrc
sed 's/#CookieAuthentication 1/CookieAuthentication 0/' -i /etc/tor/torrc
echo "ExitNodes {ru}" >> /etc/tor/torrc # here we specify RU exit nodes (tor servers)
systemctl restart tor 2> /dev/null

echo "IP/Location before tor connection: $(curl --silent https://freegeoip.app/csv/$(wget -qO - https://api.ipify.org; echo))"
source torsocks on
echo "IP/Location after tor connection: $(curl --silent https://freegeoip.app/csv/$(wget -qO - https://api.ipify.org; echo))"

# Location should be RF, BUT SOMETIMES CHANGES TO US, idk why tbh. In the following script I just skip iteration, if IP is not russian.