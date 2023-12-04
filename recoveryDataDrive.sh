#!/bin/bash

# This script is meant to backup and restore the structure and files in /mnt/data from a backup folder
# defaults to backing up

TC='\e['

Bold="${TC}1m"    # Bold text only, keep colors
Rst="${TC}0m"     # Reset all coloring and style

Green="${TC}32m";

restorefiles=0
SILO=0

OPTIONS=rslh
LONGOPTIONS=restore,silo,local,help
HOMEDIR=/home/yudong

# https://stackoverflow.com/a/29754866
# https://www.codebyamir.com/blog/parse-command-line-arguments-using-getopt

# -temporarily store output to be able to check for errors
# -e.g. use “--options” parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -r|--restore)
            restorefiles=1
            shift
            ;;
        -s|--silo)
            # ROOTFOLDER="/mnt/silo/mounts/YDPassport/LenovoLaptopBackup/"
            ROOTFOLDER="/home/sunyudong/0_backup/LenovoLaptop"
            SILO=1
            shift
            ;;
        -l|--local)
            ROOTFOLDER="/run/media/yudong/YDBackupPlus/LenovoLaptopBackup/"
            shift
            ;;
        -h|--help)
            echo -e "Usage: cmd [-s|--silo] [-l|--local]\n\n-s|--silo\tBackup to silo\n-l|--local\tBackup locally (Default)"
            exit 0
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo -e "options error\n\nUsage: cmd [-s] [-l]\n\n-s for backing up to silo\nDefault to -l = local"
            exit 3
            ;;
    esac
done

# https://stackoverflow.com/a/13864829
if [ -z ${ROOTFOLDER+x} ]; then
	ROOTFOLDER="/run/media/yudong/YDBackupPlus/LenovoLaptopBackup/"
fi

# handle non-option arguments
#if [[ $# -ne 1 ]]; then
#    echo "$0: A single input file is required."
#    exit 4
#fi

if [ -d "$ROOTFOLDER" ]; then
	echo -e "Backing up to ${ROOTFOLDER}...\n\n"
elif [[ $SILO == 1 ]]; then
	echo -e "Backing up to arch.yudong.dev:${ROOTFOLDER}...\n\n"
else
	echo "${ROOTFOLDER} not found. Exiting..."
	exit 1
fi

master_dir="/mnt/data"
# backup_dir="/run/media/sunyudong/YDPassport/LenovoLaptopBackup/Data_(D)"
backup_dir="$ROOTFOLDER/Data"

if [[ $SILO == 1 ]]; then
	tmpdir="$HOMEDIR/backup"
	master_filelist="$tmpdir/Data_D_masterfilelist.bak"
	backup_filelist="$ROOTFOLDER/Data_D_backupfilelist.bak"
else
	master_filelist="$backup_dir/../Data_D_masterfilelist.bak"
	backup_filelist="$backup_dir/../Data_D_backupfilelist.bak"
fi

#diff_filelist="$backup_dir/../Data_D_filelist.diff.bak"
#invdiff_filelist="$backup_dir/../Data_D_filelist.diff.inv.bak"

arch_master_dir="/opt/backup"
arch_backup_dir="$ROOTFOLDER/Arch_FS/opt/backup"


#master_dir="/home/sunyudong/1" # trailing slash necessary when running rsync
#backup_dir="/home/sunyudong/2"
#master_filelist="$backup_dir/../masterfilelist.bak"
#backup_filelist="$backup_dir/../backupfilelist.bak"
# diff_filelist="$backup_dir/../filelist.diff.bak"
# invdiff_filelist="$backup_dir/../filelist.diff.inv.bak"

function backup
{
	printf "${Bold}${Green} Generating filelist for master directory...\r${Rst}"
		cd $master_dir
		find > "$master_filelist"
		find -not \( -path ./Linux/working -prune \) -not \( -path ./Cloud/Dropbox -prune \) > "$master_filelist.trim"

		if [[ $SILO == 1 ]]; then
			sudo scp -i "/root/.ssh/silo_ed25519" -P 2022 $tmpdir/* sunyudong@arch.yudong.dev:"$ROOTFOLDER"
		fi

	printf "${Bold}${Green} Generating filelist for master directory...Done\n${Rst}"

	printf "${Bold}${Green} Generating filelist for backup directory...\r${Rst}"
		if [[ $SILO == 1 ]]; then
			strng="cd "$backup_dir" && find -not \\\\( -path ./0_Archive -prune \\) > $backup_filelist"
			echo $strng
			sudo ssh -i "/root/.ssh/silo_ed25519" -p 2022 sunyudong@arch.yudong.dev /bin/sh -c \"$strng\"
		else
			cd $backup_dir
			# https://stackoverflow.com/a/16595367
			find -not \( -path ./0_Archive -prune \) > "$backup_filelist"
		fi		
	printf "${Bold}${Green} Generating filelist for backup directory...Done\n${Rst}"

	printf "${Bold}${Green} Running rsync...\n${Rst}"
	tail -n +2 "$master_filelist.trim" > "$master_filelist.trim.cut"

	if [[ $SILO == 1 ]]; then
		sudo rsync -aAuvXz -e "ssh -p 2022 -i /root/.ssh/silo_ed25519" --files-from="$master_filelist.trim.cut" --progress "$master_dir/" sunyudong@arch.yudong.dev:"$backup_dir"
	else
		rsync -aAuvX --files-from="$master_filelist.trim.cut" --progress "$master_dir/" "$backup_dir"
	fi

	rm "$master_filelist.trim.cut"

	#	-a = archive = -rlptgoD
	#		-r = recursive
	#		-l = copy symlinks as symlinks
	#		-p = preserve permissions
	#		-t = preserve timestamps
	#		-g = preserve groups
	#		-o = preserve owner
	#		-D = preserve device files (super user only)
	#	-A = preserve acls
	#	-u = update = skip files that are newer on the receiver
	#	-v = verbose
	#	-X = preserve extended attributes
	#	-z = compress

	printf "${Bold}${Green} Running rsync...Done\n${Rst}"
}

function backup_arch
{
	printf "${Bold}${Green} Backing up arch opt...\n${Rst}"

	if [[ $SILO == 1 ]]; then
		sudo rsync -aAuvXz -e 'ssh -p 2022 -i /root/.ssh/silo_ed25519' --progress "$arch_master_dir/" sunyudong@arch.yudong.dev:"$arch_backup_dir"
	else
		sudo rsync -aAuvX --progress "$arch_master_dir/" "$arch_backup_dir"
	fi

	printf "${Bold}${Green} Backing up arch opt...Done\n${Rst}"
}

function f_restore
{
	# restoring using $master_filelist
	printf "${Bold}${Green} Restoring files using\n\t$master_filelist...\n${Rst}"
	#cd $backup_dir
	#cp --preserve=all --verbose --update --recursive --parents $(cat $diff_filelist) $backup_dir 2>/dev/null
	tail -n +2 "$master_filelist" > "$master_filelist.cut"

	if [[ $SILO == 1 ]]; then
		rsync -aAuHvz -e 'ssh -p 2022' --progress --files-from="$master_filelist.cut" arch.yudong.dev:"$backup_dir/" "$master_dir"
	else
		rsync -aAuHv --progress --files-from="$master_filelist.cut" "$backup_dir/" "$master_dir"
	fi

	rm "$master_filelist.cut"
	printf "${Bold}${Green} Copying new files...Done\n${Rst}"
}


if [ $restorefiles -eq 1 ]; then
	f_restore
else
	backup_arch
	backup
fi

#function backup
#{
#	printf "${Bold}${Green} Generating filelist for master directory...\r${Rst}"
#		cd $master_dir
#		find > $master_filelist
#	printf "${Bold}${Green} Generating filelist for master directory...Done\n${Rst}"
#
#	printf "${Bold}${Green} Generating filelist for backup directory...\r${Rst}"
#		cd $backup_dir
#		# https://stackoverflow.com/a/16595367
#		find -not \( -path ./0_Archive -prune \) > $backup_filelist
#	printf "${Bold}${Green} Generating filelist for backup directory...Done\n${Rst}"
#
#	printf "${Bold}${Green} Generating filelist for files that have yet to be backed up...\r${Rst}"
#	diff $master_filelist $backup_filelist --suppress-common-lines | grep "<" | sed 's/< //' > $diff_filelist
#	printf "${Bold}${Green} Generating filelist for files that have yet to be backed up...Done\n${Rst}"
#
#	# copy new files
#	printf "${Bold}${Green} Copying new files...\n${Rst}"
#	cd $master_dir
#	#cp --preserve=all --verbose --update --recursive --parents $(cat $diff_filelist) $backup_dir 2>/dev/null
#	rsync -aAuHv --progress $master_dir $backup_dir
#	printf "${Bold}${Green} Copying new files...Done\n${Rst}"
#
#	# making any empty directories
#	#printf "${Bold}${Green} Making any empty directories...\n${Rst}"
#	#cd $backup_dir 
#	#mkdir -v $(cat $diff_filelist) 2>/dev/null
#	#printf "${Bold}${Green} Making any empty directories...Done\n${Rst}"
#
#	# Check for updated files
#	printf "${Bold}${Green} Making inverse diff...\r${Rst}"
#	diff $master_filelist $diff_filelist --suppress-common-lines | grep "<" | sed 's/< //'| tail -n +2 > $invdiff_filelist
#	printf "${Bold}${Green} Making inverse diff...Done \n${Rst}"
#
#	while read -u 10 f; do
#		n=$(stat -c %Y "$master_dir/$f")
#		o=$(stat -c %Y "$backup_dir/$f")
#		if [ $n -ne $o ]; then
#			echo $n, $o
#			echo $f
#		fi
#	done 10<$invdiff_filelist
#
#}
