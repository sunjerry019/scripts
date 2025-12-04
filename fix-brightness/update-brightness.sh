# Check if actual brightness different from set brighness
# if yes, reset the brightness
# echo "12" | sudo tee /sys/class/backlight/amdgpu_bl0/brightness

ACTUAL=$(cat /sys/class/backlight/amdgpu_bl1/actual_brightness)
SETB=$(cat /sys/class/backlight/amdgpu_bl1/brightness)

# echo "SET: $SETB, ACTUAL: $ACTUAL"
if [[ $ACTUAL -ne $SETB ]]; then
    # echo "Both Numbers are NOT Equal."
    echo "$SETB" >  /sys/class/backlight/amdgpu_bl1/brightness
#else
    # echo "Both Numbers are Equal."
fi
