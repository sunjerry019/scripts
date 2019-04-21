#!/bin/bash

addr=$1
[ -z "$1" ] && addr="192.168.1.2"

printf ":: using address $addr\n"

locked=1
declare -A passwords

while [ $locked == 1 ]; do
	read -s -p "[gpg] Enter Passphrase: " GPGPASS
	#set PASS "gpg -d passwords.gpg --passphrase $GPGPASS"
	printf "\n\n"
	printf "Decrypting passwords.gpg...\r"
	PASSES="$(echo $GPGPASS | gpg2 --pinentry-mode loopback --no-verbose -q --no-tty --batch --passphrase-fd 0 --armor --decrypt passwords.gpg)"
	if [ $? -eq 0 ]; then
		locked=0
		printf "Decrypting passwords.gpg...Success\n\n"
	else
		printf "Try again...\n\n"
	fi
done

# echo "x:y q:w" | grep -o -E '\w+:\w+' | xargs -n1 echo | sed -r 's/:/\"]=\"/g'
# | sed -r 's/\s+/\" [\"/g'
# "\""   "[\""

# PASSES=$(echo "$PASSES" | xargs -I @ -n1 echo @ | sed -r 's/:/\"]=\"/g' | sed -r 's/^/[\"/g' | sed -r 's/$/\"/g')
# https://askubuntu.com/a/743875
IFS_backup=$IFS

while IFS=':' read name pw; do
    passwords[$name]=$pw
done <<<"$PASSES"

IFS=$IFS_backup
# 

printf ":: mounting Public...\n"
sudo mount -t cifs -o uid=1000,gid=1000,user=,pass= //$addr/Public /mnt/seagate/public/

for name in "${!passwords[@]}"; do 
	printf ":: mounting $name\n"
	#echo "$name - ${passwords[$name]}";
	sudo mount -t cifs -o uid=1000,gid=1000,user="$name",pass="${passwords[$name]}" "//$addr/$name" "/mnt/seagate/$name"
done




#printf ":: mounting sunjerry019\n"
#sudo mount -t cifs -o uid=1000,gid=1000,user=sunjerry019,pass=$PASS //192.168.1.1/sunjerry019 /mnt/seagate/sunjerry019
#printf ":: mounting tiansun\n"
#sudo mount -t cifs -o uid=1000,gid=1000,user=tiansun,pass=$PASS //192.168.1.1/tiansun /mnt/seagate/tiansun

#,pass=xkmndasd

#echo ":: mounting tiansun"
#sudo mount -t cifs -o uid=1000,gid=1000,user=tiansun //192.168.1.218/tiansun /mnt/seagate/tiansun
printf ":: done\n"
