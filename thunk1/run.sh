#!/bin/sh
ghc -O0 --make $1.hs -prof -auto-all -caf-all -fforce-recomp -rtsopts
time ./$1 1e6 +RTS -h -p -K400M 
hp2ps -e8in -c $1.hp
display $1.ps
mail -a $1.ps remy.sucre@gmail.com
rm *.o *.hi *aux
