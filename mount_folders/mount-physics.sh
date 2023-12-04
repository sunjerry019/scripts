#!/bin/bash

if [ ! -f ./physics.conf ]; then
	echo "physics.conf not found!"
	exit
fi

# https://stackoverflow.com/a/12488589
# https://phoenixnap.com/kb/bash-read#piping
# https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/
filename='./physics.conf'
cat "$filename" | tr -s "\n" | grep -v '^#' | tr -s "\t" | 
	while read remote local
	do 
		echo "mounting $remote to $local"
		sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/$remote -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) $local
	done

# sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/ -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) /mnt/lrz/dfsextern

# sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/homes/Yudong.Sun -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) /mnt/lrz/cip-home/

# sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/project/cip/2023-SS-NQP/Sun -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) /mnt/lrz/cip-home/0_modules/NQP/23_NQP_Mount/

# sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/project/theorie/y/Yudong.Sun -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) /mnt/lrz/theorie-home/
