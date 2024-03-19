#!/bin/bash

if [ ! -f ./physics.conf ]; then
	echo "physics.conf not found!"
	exit
fi

# https://stackoverflow.com/a/12488589
# https://phoenixnap.com/kb/bash-read#piping
# https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/
filename='./physics.conf'
rootpath="dfsextern"
mtfailed=0
cat "$filename" | tr -s "\n" | grep -v '^#' | tr -s "\t" |
	while read remote local
	do
		echo "mounting $remote to $local"
		sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/$rootpath/$remote -o noperm,credentials=/home/yudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g) $local
		if [ $? -ne 0 -a $mtfailed -eq 0 ]; then
			echo "Attempting to mount on dfsroot"
			rootpath="dfsroot"
			mtfailed=1
		fi
	done

