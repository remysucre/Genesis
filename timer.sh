#!/bin/bash

PROG=$1
TIME=$3
REPS=$2
FILE=$4

#rm -f test.txt
rm -f ${FILE}
for (( i=1; i<=$REPS; i++ ))
    do
    touch ${FILE}
    timeout $TIME time -f "%U" -a -o ${FILE} ${PROG} > /dev/null
    VAL=$?
    if [ "${VAL}" -eq "124" ]
    then echo "-1.0" >> ${FILE}
    fi
done
