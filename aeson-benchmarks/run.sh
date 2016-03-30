#!/bin/bash

for input in `cat test-data`
do
    for i in `ls aesonresults/*.hs`
    do
        cp $i Main.hs && cabal run $input && cat timing.temp >> $i.log
    done
done
