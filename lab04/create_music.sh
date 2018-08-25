#!/bin/sh
#set -x

TMP_WIKI_RAW_TXT=/tmp/$0.`whoami`.raw.txt.$$
TMP_HOTTEST_RAW_TXT=/tmp/$0.`whoami`.hottest.$$
TMP_SAMPLE=/tmp/$0.`whoami`.sample.mp3.$$

PREFIX="Triple J Hottest 100"
PLACEHOLDER="SuperStupidLongImpossibleNameCreatedBy"`whoami`.$$

if test "$#" -ne 2
then
	echo "Usage: "$0" <sample.mp3> <directory>"
	exit 1
elif test ! -f "$1"
then
	echo "$0"": No such file: ""$1"
	exit 1
elif test ! -d "$2"
then
	# echo "$0"": No such directory: ""$2"
	mkdir "$2"
fi
sample_file="$1"
fake_dir="$2"
cp "$sample_file" "$TMP_SAMPLE"

wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw' | sed 's/\x20\xe2\x80\x93\x20/ - /g' > "$TMP_WIKI_RAW_TXT"


tail -520 "$TMP_WIKI_RAW_TXT" | 
head -504 > "$TMP_HOTTEST_RAW_TXT"

while IFS='' read line || test -n "$line"
do
	if echo "$line" | egrep -q "$PREFIX, [0-9]{4}"
	then
		#echo "MATCHED! $line"
		album=`echo "$line" | 
			sed -E "s/.*\|'''\[\[(.*)\|.*'''/\1/g"`
		
		year=`echo "$album" | egrep -o '[0-9]{4}'`
		#echo Album: "$album" 
		dir_name="$2"/"$album"
		mkdir "$dir_name"
		track=1
	elif echo "$line" | egrep -q "^#"
	then 
		#echo "MATCHED! $line"

		# remove comments in '(a-z)'
		# line=`echo "$line" | sed 's/.*([a-z]*)\|//g'`
		# remove comments in '([0-9]{4}'
		# actually they are in All Time albums, just skip
		#line=`echo "$line" | sed 's/ \([0-9]{4}\) //g'`
		if echo "$line" | egrep -q '\([0-9]{4}\)'
		then
			#echo This is an All Time Album song
			#echo "$line"
			continue
		fi
		# dealing with special cases...
		# replace '-' within artist | title name with a super loooong
		# placeholder...
		line=`echo "$line" | sed -E "s/([^ ])[/-]([^ ])/\1$PLACEHOLDER\2/g"`

		raw_artist=`echo "$line" | cut -d'-' -f1`
		raw_title=`echo "$line" | cut -d'-' -f2`
		#echo RA: "$raw_artist"
		#echo RT: "$raw_title"
		# remove '|'
		#artist=`echo "$raw_artist" | sed -E 's/ \[\[.*\|/ \[\[/g'`
		artist=`echo "$raw_artist" | sed -E 's/\[\[([^\|\[\])*\|//g'`
		title=`echo "$raw_title" | sed -E 's/\[\[.*\|(.*)\]\]/\[\[\1\]\]/g'`
		# remove '[' ']'
		artist=`echo "$artist" | tr -d '\[\]\"\"\#' | sed 's/^ *//g; s/ *$//g' | sed "s/$PLACEHOLDER/-/g"`
		title=`echo "$title" | tr -d '\[\]\"\"' | sed 's/^ *//g; s/ *$//g' | sed "s/$PLACEHOLDER/-/g"`
		#echo Ar: "$artist"
		#echo Ti: "$title"
		filename="$track - $title - $artist.mp3"
		#echo Will create...
		#echo "$dir_name"/"$filename"
		track=$(($track + 1))
		cp "$TMP_SAMPLE" "$dir_name"/"$filename"
		#echo "$filename" >> tmp_file
	fi
done < "$TMP_HOTTEST_RAW_TXT"

# clean up

rm /tmp/$0.`whoami`.*
