#!/bin/sh
#set -x
key=$1
zid=`whoami`
TMP_PAGE_UD=/tmp/courses_tmp_page_ud.$zid.$$
TMP_PAGE_PG=/tmp/courses_tmp_page_pg.$zid.$$
TMP_STRING_UD=/tmp/courses_tmp_string_ud.$zid.$$
TMP_STRING_PG=/tmp/courses_tmp_string_pg.$zid.$$
COURSE_UD=/tmp/courses_ud.$zid.$$
COURSE_PG=/tmp/courses_pg.$zid.$$
#COURSE=/tmp/courses.$$

query_ud='http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr='$key
query_pg='http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr='$key

# scraping UD courses
wget -q -O- "$query_ud" > "$TMP_PAGE_UD"
grep 'TD.*A href' "$TMP_PAGE_UD" > "$TMP_STRING_UD"
cut -d'<' -f3 "$TMP_STRING_UD" | cut -c 68- | sed 's/.html">/ /g' > "$COURSE_UD"

# scraping PG courses
wget -q -O- "$query_pg" > "$TMP_PAGE_PG"
grep 'TD.*A href' "$TMP_PAGE_PG" > "$TMP_STRING_PG"
cut -d'<' -f3 "$TMP_STRING_PG" | cut -c 67- | sed 's/.html">/ /g' > "$COURSE_PG"

# merging same courses
## !!Bug found, course TELE9751 with url ending with ELEC9751.html
## Thus, this program will return both TELE9751 and ELEC9751
## fixed on 11 Aug, by adding a small filter to the last result
sort "$COURSE_UD" "$COURSE_PG" | uniq -w 8 | grep "$1"


# cleaning tmp files...
rm -f /tmp/course*
