#!/bin/sh

small_files=''
mid_files=''
large_files=''

for file in *
do
	len=`wc -l "$file" | cut -d' ' -f 1`
	# echo $len
	if test "$len" -lt 10
	then
		small_files+=" $file"
	elif test "$len" -lt 100
	then
		mid_files="$mid_files $file"
	else
		large_files="$large_files $file"
	fi
done

sorted_small_files=`echo $small_files | tr ' ' '\n' | sort | tr '\n' ' '`
echo Small files: $sorted_small_files
sorted_mid_files=`echo $mid_files | tr ' ' '\n' | sort | tr '\n' ' '`
echo Medium-sized files: $sorted_mid_files
sorted_large_files=`echo $large_files | tr ' ' '\n' | sort | tr '\n' ' '`
echo Large files: $sorted_large_files

