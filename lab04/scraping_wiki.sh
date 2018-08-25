#!/bin/sh
#set -x

TMP_WIKI_RAW_TXT=/tmp/$1.`whoami`.$$.raw.txt
TMP_WIKI_RAW_TXT=tmp_wiki
TMP_HOTTEST_RAW_TXT=tmp_hottest
TMP_ALBUM=tmp_album
TMP_SAMPLE=/tmp/$1.`whoami`.$$.sample.mp3

PREFIX="Triple J Hottest 100"
PLACEHOLDER="SuperStupidLongImpossibleNameCreatedBy"`whoami`.$$

if test "$#" -ne 2
then
	echo "Usage: ./create_music.sh <sample.mp3> <directory>"
	exit 1
elif test ! -f "$1"
then
	echo "create_music.sh: No such file: ""$1"
	exit
elif test ! -d "$2"
then
	echo "create_music.sh: No such directory: ""$2"
	exit
fi
sample_file="$1"
fake_dir="$2"
cp "$sample_file" "$TMP_SAMPLE"

#wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw' | #sed 's/\x20\xe2\x80\x93\x20/ - /g' > "$TMP_WIKI_RAW_TXT"


#tail -520 "$TMP_WIKI_RAW_TXT" | 
#head -504 |
#tr -d '\[\]\"\"' > "$TMP_HOTTEST_RAW_TXT"
YEAR_COUNTER=1993
#track=1
while IFS='' read line || test -n "$line"
do
	# echo "Text: $line"
	if echo "$line" | egrep -q "$PREFIX, [0-9]{4}"
	then
		#echo "MATCHED! $line"
		album=`echo "$line" | 
			sed -E "s/.*\|'''(.*)\|.*'''/\1/g"`
		#year=`echo "$album" | cut -d',' -f2 | cut -c 2-`
		year=`echo "$album" | egrep -o '[0-9]{4}'`
		#echo Album: "$album" 
		#echo Year: "$year"
		#echo Creating directory...
		dir_name="$2"/"$album"
		mkdir "$dir_name"
		#mkdir "$2"/"$album"
		track=1
	elif echo "$line" | egrep -q "^#"
	then 
		#echo "MATCHED! $line"
		# dealing with special cases...
		# replace '-' within artist | title name with a super loooong
		# placeholder...
		line=`echo "$line" | sed -E "s/([^ ])-([^ ])/\1$PLACEHOLDER\2/g"`
		# remove comments in '(a-z)'
		#line=`echo "$line" | sed 's/.*([a-z]*)\|//g'`
		# trying to replace /u2013 with a '-', but failed, weird..
		# fixed by replacing all /u2013 into a '-'
		# replace placeholder back to a '-'
		artist=`echo "$line" | cut -d'-' -f1 | sed -E 's/.*\|(.*)/\1/g; s/# *//g; s/ *$//g' | sed "s/$PLACEHOLDER/-/g"`
		title=`echo "$line" | cut -d'-' -f2 | sed -E 's/.*\|(.*)/\1/g; s/^ *//g; s/ *$//g' | sed "s/$PLACEHOLDER/-/g"`
		#echo Title: "$title"
		#echo Artist: "$artist"
		filename="$track - $title - $artist.mp3"
		#echo Will create...
		echo "$dir_name"/"$filename"
		#echo "$filename" >> tmp_filename
		cp "$TMP_SAMPLE" "$dir_name"/"$filename"
		
		track=$(($track + 1))
	fi
done < "$TMP_HOTTEST_RAW_TXT"
