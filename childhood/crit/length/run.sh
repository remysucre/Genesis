#!/bin/sh
ghc -O0 --make $1.hs -prof -auto-all -caf-all -fforce-recomp -rtsopts
# change -h to -hd, -hy to break down profile by type/tycon
time ./$1 +RTS -h -p -K400M
hp2ps -e8in -c $1.hp
gnome-open $1.ps
rm *.o *.hi *aux
