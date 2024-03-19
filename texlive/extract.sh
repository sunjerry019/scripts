#!/bin/bash

cd ~/tex/

YEAR=$(date +"%Y")
LYEAR=$((YEAR-1))

cd $YEAR

# https://linuxhint.com/bash_wait_keypress/
echo "Press any key to continue"
while [ true ] ; do
	read -t 3 -n 1
	if [ $? = 0 ] ; then
		break
	else
		echo -ne "waiting for the keypress\r"
	fi
done

temp=$(pwd)
cd /usr/share/fonts/
sudo rm latex_*
sudo ln -s /usr/local/texlive/$YEAR/texmf-dist/fonts/opentype/ latex_opentype
sudo ln -s /usr/local/texlive/$YEAR/texmf-dist/fonts/truetype/ latex_truetype
cd $temp

# mkdir /mnt/data/Linux/working/texlive/$YEAR
# ln -s /mnt/data/Linux/working/texlive/$YEAR /usr/local/texlive/$YEAR

cd $(ls -d */ | head -n 1)
sudo ./install-tl --repository="http://ftp.fau.de/ctan/systems/texlive/tlnet"

