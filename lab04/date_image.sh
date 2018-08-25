#!/bin/sh
# set -x
if test "$#" -ne 1
then
	echo "Usage: ./data_image.sh <image_file>"
	exit 1
fi

image="$1"

label=`ls -l "$1" | cut -d' ' -f6-8`
convert -gravity south -pointsize 36 -draw "text 0,10 '$label'" "$image" "labelled_$image"

