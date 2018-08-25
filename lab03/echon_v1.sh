#!/bin/sh

if test $# != 2
then
	echo 'Usage: ./echon.sh <number of lines> <string>'
	exit 1
fi
if (! [ "$1" -eq "$1" ] || [ "$1" -lt 0 ]) 2> /dev/null
then
	echo './echon.sh: argument 1 must be a non-negative integer' >&2
	exit 1
fi
i=0
while (( i < $1 ))
do
	echo $2
	i=$(( i + 1))
done
