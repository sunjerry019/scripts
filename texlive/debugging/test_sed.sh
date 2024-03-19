#!/bin/bash

YEAR=$(date +"%Y")
LYEAR=$((YEAR-1))

sudo sed -i "s,texlive/$LYEAR,texlive/$YEAR,g" tex.sh tex.csh