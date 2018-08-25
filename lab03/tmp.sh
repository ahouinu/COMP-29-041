#!/bin/sh
# set -x

tmp=`grep 'TD.*A href' comp_page.txt`
tmp_2=`echo $tmp | tr '</A></TD> ' '\n'`
echo $tmp_2
strings=''
#for t in $tmp
#do
	#str=`echo $t | cut -d'<' -f3`
#	str+=$'\n'
	#echo $str
#	strings+="$str"
#done
#echo $strings

courses=''
for s in $strings
do
#	code=`echo $s | grep 'COMP'`
	#name=`echo $s | cut -d'>' -f2`
#	echo $code
	#echo $name
#	courses+=$course
	#echo '$course added in list'
	#echo $s
	#echo ''
done
# echo $courses
