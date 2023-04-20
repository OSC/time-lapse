#!/bin/bash

# The expected command line to execute this script is "./daily_video.sh cam_name threshold" with the following parameters:
# - cam_name corresponds to the hostname of the camera (e.g. XXXX_cam1.osc.edu)
# - threshold refers to an ImageMagik compare metric of visual difference from the previous frame. Images with compare results above this metric will result in the image being included in the GIF. OSC has found that 1350 works well in general, but a reasonable range is 1100-1700. This setting is highly dependent on the specific camera location and field of view.
   
# Note that the compare program outputs the threshold value to STDERR, not STDOUT, which is why that command line ends in 2>\&1. 
    
cd PROJECTPATH
cam_name="$1"
thres="$2"    
imglist=()
while IFS= read -r ; do
    imglist+=("$REPLY")
done < <(/usr/bin/find PROJECTPATH/$cam_name/ -type f -name "image_*" -mtime -1 -print | sort)
listlength=${#imglist[*]}
((listlength=$listlength-1))
value=1
found=0
echo "file '${imglist[$value]}'" > PROJECTPATH/tempfilelist
while [[ $value -lt $listlength ]]
do
  	imgdiff=$((/usr/bin/compare -metric MAE ${imglist[$value]} ${imglist[$value+1]} null: ) 2>&1)	
   	imgdiff=${imgdiff%%.*}
   	imgdiff=${imgdiff%% *}
   	if [ $imgdiff -gt $thres ]
   	then
       	echo "file '${imglist[$value+1]}'" >> PROJECTPATH/tempfilelist
       	((found=$found+1))
   	fi
   	((remain=$value%100))
    if [ $remain -eq 0 ]
   	then
    		echo $value
    fi
   	((value=$value+1))
done
echo "file '${imglist[$value]}'" >> PROJECTPATH/tempfilelist    
((found=$found+2))
rate=$(bc <<< "scale=2;$found/5")
/usr/local/ffmpeg/2.8.12/bin/ffmpeg -f concat -safe 0 -i PROJECTPATH/tempfilelist \
-vf "fps=$rate,scale=320:-1" -loop 0 -fs 2M \
PROJECTPATH/daily_videos/"$cam_name"_`date +%Y_%m_%d`.gif
rm PROJECTPATH/tempfilelist

# Below is an explanation of the FFmpeg parameters used in the script:
# - (-f concat) to concantenate multiple input files, in this case all the single images
# - (-safe 0) to accept any file path / directive, otherwise they would have to be relative file paths
# - (-i tempfileslist) to read a text document with each file to concat on a line by itself in the form "file '/path/to/file.jpg'"
# - (-vf "fps=\$rate,scale=320:-1") to use a 'filtergraph' that consists of setting the output frames per second to \$rate and scaling the images down to 320 pixels wide with the appropriate height
# - (-loop 0) to make the output GIF loop infinitely
# - (-fs 2M) to truncate the output if it exceeds 2MB in size
  
