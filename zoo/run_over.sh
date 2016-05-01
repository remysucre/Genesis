#!/bin/bash

rm -f times

for i in `ls`
do
    if [ -d $i ]
    then
	echo $i
	pushd $i

	cp mainsave.hs backup
	cp Main.hs mainsave.hs
	mv backup Main.hs

	bash run.sh ./Main > /dev/null 2> $i.times
	BASE=`grep "user" $i.times | cut -f2 | python ../convert_to_sec.py`

	cp mainsave.hs backup
	cp Main.hs mainsave.hs
	mv backup Main.hs

	bash run.sh ./Main > /dev/null 2> $i.times
	OPT=`grep "user" $i.times | cut -f2 | python ../convert_to_sec.py`

	printf "${i}\t${BASE}\t${OPT}\n" >> ../times
	popd
    fi
done