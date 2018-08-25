#!/bin/sh
#set -x

if test "$#" -le 0
then
	echo 'Usage: ./tag_music.sh <dir_1> [dir_2, dir_3, ...]'
	exit 1
fi

# for each dir in args
for dir in "$@"
do
	#echo "$dir"
	# if dir is empty, skip
	tmp=`ls -A "$dir"`
	if test -z "$tmp"
	then
		#echo "$dir" is empty
		continue
	fi

	# remove trailling '/'s
	dir=`echo "$dir" | sed 's/\/$//'`
	
	# get album and year info from dir_name
	album=`echo "$dir" | cut -d'/' -f2`
	year=`echo "$dir" | cut -d',' -f2 | sed 's/^ *//' | sed 's/ *$//'`
	
	# remove trailling '/'s
	dir=`echo "$dir" | sed 's/\/$//'`

	# for each mp3 file in this dir
	for file_path in "$dir"/*.mp3
	do
		# get title and artist info from file_name
		#echo "$file_name"
		# replacing extra '-'s by '%'
		file_name=`echo "$file_path" | sed -E 's/([^ ])-([^ ])/\1%\2/g'`
		# then replace '%' back to '-', in case there are any '-'s in title or artist
		track=`echo "$file_name" | cut -d'/' -f3 | cut -d' ' -f1 | tr '%' '-'`
		title=`echo "$file_name" | cut -d'-' -f2 | sed 's/^ *//' | sed 's/ *$//' | tr '%' '-'`
		artist=`echo "$file_name" | cut -d'-' -f3 | sed 's/^ *//' | sed 's/\.mp3 *$//' | tr '%' '-'`
		#echo "$track"
		#echo "$album"
		#echo "$year"
		#echo "$title"
		#echo "$artist"
	# write in id3 info
		id3 -a "$artist" -t "$title" -T "$track" -A "$album" -y "$year" "$file_path" > /dev/null
		#id3 -l "$file_name"
	done
done
