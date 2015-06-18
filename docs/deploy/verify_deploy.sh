#!/bin/bash
while true
do
   ATIME=`stat -c %Z /home/deploy/discourse-dev.rgadev.com/deploy/tmp/deploy.txt`
   if [[ "$ATIME" != "$LTIME" ]]
   then
       /home/deploy/discourse-dev.rgadev.com/deploy/deploy.sh
       
       LTIME=$ATIME
   fi
   sleep 5
done


#@reboot /home/deploy/discourse-dev.rgadev.com/deploy/verify_deploy.sh