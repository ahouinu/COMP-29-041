#!/bin/sh
#set -x

# read all jpg files
for jpg_file in *.jpg
do
	png_file=`echo "$jpg_file" | sed 's/\.jpg/\.png/'`
	if test -f "$png_file"
	then
		echo "$png_file" already exists
		exit 1
	fi
	convert "$jpg_file" "$png_file"
	rm "$jpg_file"
done
