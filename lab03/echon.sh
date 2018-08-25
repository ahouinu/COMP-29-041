#!/bin/sh

if test $# != 2
then
	echo 'Usage: ./echon.sh <number of lines> <string>'
	exit 1
fi
if echo "$1" | egrep -qv '^([0-9]|[1-9][0-9]*)$'
then
	echo './echon.sh: argument 1 must be a non-negative integer' >&2
	exit 1
fi
i=0
while (( i < "$1" ))
do
	echo "$2"
	i=$(( i + 1))
done
