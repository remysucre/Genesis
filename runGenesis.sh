# How to run:
#
# bash runGenesis.sh <path> <pop> <gen> <arch>
#
# <path>: path to directory with the files
# <pop>: Size of population per generation
# <gens>: Number of generations
# <arch>: Number of best genes that survive each generation
/run/current-system/sw/bin/time -a -o "$1".log ./.stack-work/install/*/lts-2.22/7.8.4/bin/Genesis $1 $2 $3 $4 2>&1 | tee "$1".log &&
date >> "$1".log ; git log --pretty=format:'%h' -n 1 >> "$1".log
