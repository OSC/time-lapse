#!/bin/bash

# The expected command line to execute this script is "./daily_check.sh cam_name" with the following parameters:
# - cam_name corresponds to the hostname of the camera (e.g. XXXX_cam1.osc.edu)
    
cam_name="$1"
/usr/bin/find PROJECTPATH/$cam_name/ -type f -name "image_*" -mtime -1 -print0 | \
/usr/bin/xargs -0 ls -l | /usr/bin/gawk \
'{sum += $5; n++;} END {printf "Total Size: %d MB&nbsp&nbsp&nbsp&nbsp&nbspTotal Files: %d<br>", sum/1024/1024,  n ;}'
