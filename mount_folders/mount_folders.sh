#!/bin/bash

locked=1

while [ $locked == 1 ]; do
	read -s -p "[gpg] Enter Passphrase: " GPGPASS
	#set PASS "gpg -d passwords.gpg --passphrase $GPGPASS"
	printf "\n\n"
	printf "Decrypting passwords.gpg...\r"
	PASS="$(echo $GPGPASS | gpg2 --pinentry-mode loopback --no-verbose -q --no-tty --batch --passphrase-fd 0 --armor --decrypt password.gpg)"
	if [ $? -eq 0 ]; then
		locked=0
		printf "Decrypting passwords.gpg...Success\n\n"
	else
		printf "Try again...\n\n"
	fi
done

#echo $PASS
printf ":: mounting Public...\n"
sudo mount -t cifs -o uid=1000,gid=1000,user=,pass= //192.168.1.1/Public /mnt/seagate/public/
printf ":: mounting sunjerry019\n"
sudo mount -t cifs -o uid=1000,gid=1000,user=sunjerry019,pass=$PASS //192.168.1.1/sunjerry019 /mnt/seagate/sunjerry019

#,pass=xkmndasd

#echo ":: mounting tiansun"
#sudo mount -t cifs -o uid=1000,gid=1000,user=tiansun //192.168.1.218/tiansun /mnt/seagate/tiansun
printf ":: done\n"
