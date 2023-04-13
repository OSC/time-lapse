## Intro
While computers are ubiquitous in society, the most powerful "supercomputers" still evoke a sense of awe and exclusivity for most of the general public.  Research computing centers that manage and operate high performance computing systems frequently have public communications strategies and techniques to help raise awareness of their resources and services within client and stakeholder communities.  At the Ohio Supercomputer Center (OSC), one such technique is to publish time-lapse videos of the installation of new computer clusters, which help the public better understand the scale and complexity of OSC's systems.  The author has been responsible for the creation of OSC's time-lapse videos for many years and has developed a variety of tools and best practices that are documented in this repo, which other research computing centers will be able to utilize for their own videos.

## Scripts
All of the scripts that OSC utilizes are written in the BASH shell scripting language in order to make them as system independent as possible.  The author typically utilizes his existing staff account to store and execute the scripts.  The software and system commands that are needed by the scripts are listed below, all of which are typically installed at a system level in the /usr/bin directory (with the exception of FFmpeg).  Items with an asterisk are usually available by default in any modern Linux-based operating system: 
* compare (part of the ImageMagick suite) 
* cron*
* curl*
* find*
* FFmpeg (usually installed in /usr/local)
* gawk*
* mutt*
* sleep*
* touch*
* xargs*

Absolute paths are typically utilized to avoid any confusion regarding the locations of data, particularly since these scripts are reused each time a new system is installed. In order to adapt them for other systems, the following will need to be changed:
* Replace PROJECTPATH with the local path to the project directory
* Replace CAMERANAME with the hostname of each camera
* Update the /usr/local/ffmpeg version directory as appropriate
* Set all scripts to executable with "chmod +x SCRIPTNAME.sh"
