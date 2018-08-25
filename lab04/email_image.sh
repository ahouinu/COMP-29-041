#!/bin/sh
#set -x

if test "$#" -le 0
then
	echo "Usage: ./email_image.sh <image_1> <image_2> <image_3> ..."
fi

for png in $@
do
	display "$png"
	read -p "Address to email this image to? " email
	read -p "Message to accompany image? " msg
	subject=`echo "$png" | sed s/\.png/!/`
	# echo "$subject"
	echo "$msg" | 
	mutt -s "$subject" -e 'set copy=no' -a "$png" -- "$email"
	echo "$png sent to $email"
done
