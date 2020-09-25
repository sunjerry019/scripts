#!/bin/bash

WEG=$(dirname $1)
BAS=$(basename $1 .pdf)

# Combine into 2/page
pdfjam "$WEG/$BAS.pdf" --nup 2x1 --landscape --outfile "$WEG/$BAS-noholes.pdf"

# Rotate it
pdftk "$WEG/$BAS-noholes.pdf" cat 1-endwest output "$WEG/$BAS-noholes-rotated.pdf"

# Add space for hole-punching
# pdfjam "$WEG/$BAS-noholes-rotated.pdf" --twoside --offset '0.7cm 0cm' --papersize '{210mm,297mm}' --scale '0.93' --no-landscape --outfile "$WEG/$BAS-print-rotated.pdf"
pdfjam "$WEG/$BAS-noholes-rotated.pdf" --twoside --offset '0.5cm 0cm' --papersize '{210mm,297mm}' --scale '0.95' --no-landscape --outfile "$WEG/$BAS-print-rotated.pdf"

# Rotate it back
pdftk "$WEG/$BAS-print-rotated.pdf" cat 1-endeast output "$WEG/$BAS-print.pdf"

# Cleanup
rm "$WEG/$BAS-noholes.pdf" "$WEG/$BAS-noholes-rotated.pdf" "$WEG/$BAS-print-rotated.pdf"

# Archive
# pdfjam $WEG/$BAS-separated.pdf --nup 2x4 --no-landscape --outfile $WEG/$BAS-print.pdf
# https://lornajane.net/posts/2015/scaling-and-sizing-with-pdfjam
# https://stackoverflow.com/questions/16158435/add-margin-to-pdf-file-when-merging-using-pdftk-or-similar
