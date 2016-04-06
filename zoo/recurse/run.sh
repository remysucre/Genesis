#!/bin/sh

ghc -O2 --make $1.hs -prof -auto-all -caf-all -fforce-recomp -rtsopts
time ./$1 1e6 +RTS -h -p -K400M 
hp2ps -e8in -c $1.hp
gnome-open $1.ps
rm *.o *.hi *aux
