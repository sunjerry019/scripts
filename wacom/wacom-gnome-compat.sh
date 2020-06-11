#!/bin/bash

# Consumer Wacom devices (i.e. most Bamboo devices like the Bamboo Pen & Touch,
# Bamboo Fun, Bamboo Connect; and the newer non-pro Intuos devices like the
# Intuos Draw and Intuos Art) have a hardware button mapping that is incompatible
# with GNOME. This incompatibility prevents the GNOME Control Center's Wacom panel
# from working properly, and often also prevents at least one button from working
# entirely.
#
# This script can be used to discover a software mapping that can be applied by
# the xf86-input-wacom driver to allow these devices to work peroperly. When
# run with the ID of a Bamboo pad device (use xsetwacom list if unsure), it will
# reset any mapping that may be present and then ask you to press each tablet
# button in turn followed by 'q' to quit. After pressing all the buttons and
# pressing 'q', the buttons will be remapped and the script will display what
# xsetwacom commands were necessary. The buttons should work properly within
# the GNOME Control Center now.
#
# The changes made by this script are temporary and will be undone if the tablet
# is disconnected and reconnected or if the X server is restarted. To make the
# changes more permanant, you should copy/paste the displayed xorg.conf.d
# configuration snippet into a new file at the listed path so that it can be
# automatically applied whenever the tablet is connected or when the X server
# restarts.
#
# For more information, please visit the following URL:
#   http://linuxwacom.sourceforge.net/wiki/index.php?title=Consumer_Tablet_ExpressKey_Mapping_Issue

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <pad device id>"
	exit 1
fi

ID=$1
NAME=$(xsetwacom list | grep "id: $ID" | awk 'BEGIN {FS="[a-z]+: "} {gsub(/[ \t]+$/,"",$1); print $1}')
TYPE=$(xsetwacom list | grep "id: $ID" | awk 'BEGIN {FS="[a-z]+: "} {gsub(/[ \t]+$/,"",$3); print $3}')

if [[ "$NAME" == "" ]]; then
	echo "No wacom device with id '${ID}' known."
	exit 2
elif [[ "$TYPE" != "PAD" ]]; then
	echo "'${NAME}' is not a wacom pad device (${TYPE})."
	exit 3
fi

echo "Overriding default mapping..."
for B in {1..9}; do
	xsetwacom set "$NAME" button $B key $B 2> /dev/null
done

N=1
MAP=()
while true; do
	echo "Press button ${N} on ${NAME} or 'q' when finished"
	read -s -n 1 X > /dev/null
	if [[ "$X" == 'q' ]]; then
		break
	fi
	MAP[$N]=$X
	N=$(($N+1))
done

echo
echo "Setting up a GNOME-compatible mapping with the following commands:"
for PHYSICAL in ${!MAP[*]}; do
	LOGICAL=${MAP[$PHYSICAL]}
	echo "xsetwacom set \"$NAME\" button ${LOGICAL} button +${PHYSICAL}"
	xsetwacom set "$NAME" button ${LOGICAL} button +${PHYSICAL}
done

echo
echo "To have these settings apply automatically, please add the following"
echo "to /etc/X11/xorg.conf.d/52-wacom-options.conf and then logout:"
echo "---------- [ cut here ] ----------"
echo "Section \"InputClass\""
echo "    Identifier \"$NAME GNOME compatibility\""
echo "    MatchDriver \"wacom\""
echo "    MatchProduct \"$NAME\""
echo
for PHYSICAL in ${!MAP[*]}; do
	LOGICAL=${MAP[$PHYSICAL]}

	# wacom option syntax uses semi-physical button numbers
	# so we need to convert the logical numbers first
	if [[ $LOGICAL -ge 4 ]]; then
		LOGICAL=$(($LOGICAL - 4))
	fi

	echo "    Option \"Button${LOGICAL}\" \"${PHYSICAL}\""
done
echo "EndSection"
echo "---------- [ cut here ] ----------"
