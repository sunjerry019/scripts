#!/bin/bash

/home/yudong/scripts/fix-brightness/update-brightness.sh

dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" |
  while read x; do
    case "$x" in 
      # *"boolean true"*) echo SCREEN_LOCKED;;
      *"boolean false"*) /home/yudong/scripts/fix-brightness/update-brightness.sh;;  
    esac
  done
