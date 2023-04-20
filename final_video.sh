#!/bin/bash

# The expected command line  to execute this script is: "./final_video.sh cam_name threshold startdate enddate" with the following parameters:
# - cam_name corresponds to the hostname of the camera (e.g. XXXX_cam1.osc.edu)
# - threshold refers to an ImageMagik compare metric of visual difference from the previous frame. Above this metric will result in the image being included in the output video. OSC has found that 1350 works well in general, but a reasonable range is generally 1100-1700. This setting is highly dependent on the specific camera location and field of view.
# - startdate and enddate refer to the date range (inclusive) the script should search between, in the format of YYYY-MM-DD.  Because there are potentially hundreds of thousands of images to process, the author has found the best practice is to launch multiple instances of this script (each using their own computational resources), each with a multi-week date range.
    
cd PROJECTPATH
cam_name="$1"
thres="$2"
startdate="$3"
enddate="$4"    
echo "Starting Find - this step can take many minutes"
imglist=()
while IFS= read -r ; do
    imglist+=("$REPLY")
done < <(/usr/bin/find PROJECTPATH/$camname/ -type f -name "image_*" -newermt "$startdate 00:00:01" ! -newermt "$enddate 23:59:59" -print | sort)
listlength=${#imglist[*]}    
echo "Found $listlength"       
((listlength=$listlength-1))
value=1
found=0
time=0
timestamp=$(date +%Y_%m_%d_%H_%M_%S)
filename="PROJECTPATH/filelist_"$camname"_threshold-"$thres"_start-"$startdate"_end-"$enddate"_created-"$timestamp""
echo "file '${imglist[$value]}'" > $filename
while [[ $value -lt $listlength ]]
do
   	imgdiff=$((/usr/bin/compare -metric MAE ${imglist[$value]} ${imglist[$value+1]} null: ) 2>&1)	
    imgdiff=${imgdiff%%.*}
  	imgdiff=${imgdiff%% *}
   	if [ $imgdiff -gt $thres ]
    then
    		echo "file '${imglist[$value+1]}'" >> $filename
    		((found=$found+1))
       	((time=$found%60))
       	if [ $time -eq 0 ]
    		then
    		    ((time=$found/60))
        		echo "# $time seconds mark" >> $filename
       	fi
    fi
   	((remain=$value%100))
  	if [ $remain -eq 0 ]
    then
    		echo $value
   	fi
    ((value=$value+1))
done
echo "file '${imglist[$value]}'" >> $filename        
echo "Found $found"    
((found=$found+2))
/usr/local/ffmpeg/2.8.12/bin/ffmpeg -r 60 -f concat -safe 0 -i \
$filename -vsync vfr -b:v 16M -pix_fmt yuv420p \
./video_-"$camname"_threshold-"$thres"_start-"$startdate"_end-"$enddate"_created-"$timestamp".mp4    
echo "----------------------------"
echo "Threshold of $thres on $camname isolated $found images out of $listlength available"

# Below is an explanation of the FFmpeg parameters used in the script:
# - (-r 60) to set the output framerate to 60 frames per second
# - (-f concat) to concantenate multiple input files, in this case all the single images
# - (-safe 0) to accept any file path / directive, otherwise they would have to be relative paths
# - (-i tempfileslist) to use a text document with each file to concat on a line by itself in the form "file '/path/to/file.jpg'"
# - (-vsync vfr) to drop frames if needed to ensure the fps
# - (-b:v 16M) to set the output bitrate max to be 16 Mbit/s
# - (-pix_fmt yuv420p) to set the chroma subsampling scheme to yuv420p used by H.26x codecs like mp4
