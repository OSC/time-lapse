#!/bin/bash   

# The expected command line  to execute this script is: "./daily_email.sh" 
# Replace EMAILADDRESS with the email address of the desired recipient.
# OSC typically utilizes four cameras, hence the four repeated sections.  
     
cd PROJECTPATH
PROJECTPATH/daily_video.sh CAMERANAME1 1350
PROJECTPATH/daily_video.sh CAMERANAME2 1350
PROJECTPATH/daily_video.sh CAMERANAME3 1350
PROJECTPATH/daily_video.sh CAMERANAME4 1350
echo "<html><body><table align=\"center\" border=\"1\"><tr><td style=\"text-align: center;\">" > \
PROJECTPATH/tempemail
echo "<h2>Camera 1</h2>" >> PROJECTPATH/tempemail       
PROJECTPATH/daily_check.sh 1 >> PROJECTPATH/tempemail
echo "<br><br><img src=\"cid:CAMERANAME1_`date +%Y_%m_%d`.gif\" /><br>" >> \
PROJECTPATH/tempemail
echo "</td><td style=\"text-align: center;\"><h2>Camera 2</h2>" >> \
PROJECTPATH/tempemail        
PROJECTPATH/daily_check.sh 2 >> PROJECTPATH/tempemail
echo "<br><br><img src=\"cid:CAMERANAME2_`date +%Y_%m_%d`.gif\" /><br>" >> \
PROJECTPATH/tempemail
echo "</td></tr><tr><td style=\"text-align: center;\"><h2>Camera 3</h2>" >> \
PROJECTPATH/tempemail
PROJECTPATH/daily_check.sh 3 >> PROJECTPATH/tempemail
echo "<br><br><img src=\"cid:CAMERANAME3_`date +%Y_%m_%d`.gif\" /><br>" >> \
PROJECTPATH/tempemail
echo "</td><td style=\"text-align: center;\"><h2>Camera 4</h2>" >> \
PROJECTPATH/tempemail
PROJECTPATH/daily_check.sh 5 >> PROJECTPATH/tempemail
echo "<br><br><img src=\"cid:CAMERANAME4_`date +%Y_%m_%d`.gif\" /><br>" >> \
PROJECTPATH/tempemail
echo "</td></tr></table></body></html>" >> PROJECTPATH/tempemail
/usr/bin/mutt -e 'set content_type="text/html"' EMAILADDRESS -s \
"Daily Cameras Time Lapse Report for `date +%Y_%m_%d`" \
-a PROJECTPATH/daily_videos/CAMERANAME1_`date +%Y_%m_%d`.gif \
PROJECTPATH/daily_videos/CAMERANAME2_`date +%Y_%m_%d`.gif \
PROJECTPATH/daily_videos/CAMERANAME3_`date +%Y_%m_%d`.gif \
PROJECTPATH/daily_videos/CAMERANAME4_`date +%Y_%m_%d`.gif -- \
< PROJECTPATH/tempemail
rm PROJECTPATH/tempemail
