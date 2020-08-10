#!/bin/sh
RM='rm -f'
SCI=..
FILE='examples.tst'
LOGFILE='get_examples.log'

$RM prov $LOGFILE

echo '//' `date` > prov
echo '' >> prov

MANPATH=$1

do_example()
{
echo '//====================================================' >> prov
echo '//' "$1" >> prov
echo '//====================================================' >> prov

res=`grep '<EXAMPLE>' $1 2> /dev/null`
if test -n "$res"
then
	echo "clear;lines(0);" >> prov
	sed -e '1,/<EXAMPLE>/d' $1 > prov1
	sed -e '/<\/EXAMPLE>/,$d' prov1 >> prov
	$RM prov1
	echo "$1" PROCESSED >> $LOGFILE
else
	echo "$1" NO EXAMPLE >> $LOGFILE
fi
echo "for k=winsid(),xdel(k);end" >> prov
echo '' >> prov

}

for j in $MANPATH/*
do
    if [ -d $j ]; then
	echo -n "Processing $j "
	for f in $j/*.xml
	do
		echo -n '.'
		do_example $f
	done
	echo ""
    fi
done

echo ''
echo `grep PROCESSED $LOGFILE|wc -l` examples extracted from `cat  $LOGFILE|wc -l` manual files.

$RM $FILE

sed -e 's/\\\\/\\/' prov > $FILE

$RM prov
