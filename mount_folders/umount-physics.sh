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
		echo "unmounting $local"
		sudo umount $local
	done

