#!/bin/bash

TC='\e['

Bold="${TC}1m"    # Bold text only, keep colors
Rst="${TC}0m"     # Reset all coloring and style

Green="${TC}32m";

# https://stackoverflow.com/a/33099739
find ./ -iregex ".*\.MPG" > filelist.txt
#i=0
#total=$(wc -l filelist.txt | awk '{print $1}')
#while read f; do
#	base=$(echo "$f" | sed -r "s/.mpg$//gi")
#	echo ffmpeg -i "$f" -c:v libx265 -preset slow -x265-params crf=22 -c:a copy "$base.mp4" 2>&1 | tee -a "$base.log"
#	#echo "$base.mp4"
#	let i++
#	# https://stackoverflow.com/questions/12147040/division-in-script-and-floating-point
#	percent=$(printf "%.3f" "$(bc <<< "scale = 10; ($i/$total)*100")")
#	# http://tldp.org/LDP/abs/html/arithexp.html
#	printf "${Bold}${Green} $f Done\t$i/$total\t$percent%% Complete\n${Rst}"
#done < filelist.txt
sed -i -r "s/.mpg//gi" filelist.txt 
cat filelist.txt | xargs -I {} -n1 sh -c 'ffmpeg -i "{}.MPG" -c:v libx265 -preset slow -x265-params crf=22 -c:a copy "{}.mp4" 2>&1 | tee -a "{}.log"'


# <<< text
# << standard input
# < filename

# ffmpeg -i M2U00001.MPG -c:v libx265 -preset slow -x265-params crf=22 -c:a copy output.mp4
# ffmpeg -i input -c:v libx265 -preset slow -x265-params crf=22 -c:a libmp3lame -b:a 128k output.mp4
# https://askubuntu.com/a/718300