#!/bin/bash

YEAR=$(date +"%Y")
LYEAR=$((YEAR-1))

sudo sed -i "s,texlive/$LYEAR,texlive/$YEAR,g" /etc/profile.d/tex.sh /etc/profile.d/tex.csh
