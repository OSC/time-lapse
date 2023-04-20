#!/bin/bash       

#The expected command line to execute this script is "./getimg.sh  cam_name interval" with the following parameters:
# - cam_name corresponds to the hostname of the camera (e.g. XXXX_cam1.osc.edu)
# - interval corresponds to seconds delay. This will repeat for a total of 60 seconds. Typical usage is 10, meaning that one execution of the script will retrieve 6 images total (e.g. every 10 seconds over a minute).

cam_name="$1"
interval="$2"
count=0
while [[ $count -lt 60 ]]
do
        /usr/bin/curl -s http://$cam_name/axis-cgi/jpg/image.cgi --output \
        PROJECTPATH/$cam_name/image_`date +%j-%H-%M-%S`.jpg
        /usr/bin/sleep $interval
        ((count=$count+$interval))
done
