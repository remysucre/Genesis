#!/bin/bash

PATH_TO_NOFIB=~
/usr/bin/time -a -o simple.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/simple 13 15 7 &>> simple.log 2>&1 &
/usr/bin/time -a -o pidigits.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/pidigits 13 15 7 &>> pidigits.log 2>&1 &
/usr/bin/time -a -o n-body.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/n-body 13 15 7 &>> n-body.log 2>&1 &
/usr/bin/time -a -o maillist.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/maillist 13 15 7 &>> maillist.log 2>&1 &
/usr/bin/time -a -o life.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 13 15 7 &>> life.log 2>&1 &
/usr/bin/time -a -o integer.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/integer 13 15 7 &>> integer.log 2>&1 &
/usr/bin/time -a -o fasta.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fasta 13 15 7 &>> fasta.log 2>&1 &
/usr/bin/time -a -o cryptarithm1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm1 13 15 7 &>> cryptarithm1.log 2>&1 &
/usr/bin/time -a -o binary-trees.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/binary-trees 13 15 7 &>> binary-trees.log 2>&1 &
/usr/bin/time -a -o atom.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/atom 13 15 7 &>> atom.log 2>&1 &
/usr/bin/time -a -o anna.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/anna 13 15 7 &>> anna.log 2>&1 

# /usr/bin/time -a -o cacheprof.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/cacheprof 13 15 7 &>> cacheprof.log 2>&1 &
# /usr/bin/time -a -o fem.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fem 13 15 7 &>> fem.log 2>&1 &
# /usr/bin/time -a -o fluid.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fluid 13 15 7 &>> fluid.log 2>&1 &
# /usr/bin/time -a -o fulsom.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fulsom 13 15 7 &>> fulsom.log 2>&1 &
# /usr/bin/time -a -o gamteb.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gamteb 13 15 7 &>> gamteb.log 2>&1 &
# /usr/bin/time -a -o gg.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gg 13 15 7 &>> gg.log 2>&1 &
# /usr/bin/time -a -o hidden.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/hidden 13 15 7 &>> hidden.log 2>&1 &
# /usr/bin/time -a -o infer.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/infer 13 15 7 &>> infer.log 2>&1 &
# /usr/bin/time -a -o pic.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/pic 13 15 7 &>> pic.log 2>&1 &
# /usr/bin/time -a -o prolog.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/prolog 13 15 7 &>> prolog.log 2>&1 &
# /usr/bin/time -a -o reptile.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/reptile 13 15 7 &>> reptile.log 2>&1 &
# /usr/bin/time -a -o rsa.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/rsa 13 15 7 &>> rsa.log 2>&1 ;
# /usr/bin/time -a -o scs.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/scs 13 15 7 &>> scs.log 2>&1 &
# /usr/bin/time -a -o symalg.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/symalg 13 15 7 &>> symalg.log 2>&1 &
# /usr/bin/time -a -o awards.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/awards 13 15 7 &>> awards.log 2>&1 &
# /usr/bin/time -a -o boyer2.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/boyer2 13 15 7 &>> boyer2.log 2>&1 &
# /usr/bin/time -a -o calendar.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/calendar 13 15 7 &>> calendar.log 2>&1 &
# /usr/bin/time -a -o cichelli.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cichelli 13 15 7 &>> cichelli.log 2>&1 &
# /usr/bin/time -a -o cse.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cse 13 15 7 &>> cse.log 2>&1 &
# /usr/bin/time -a -o expert.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/expert 13 15 7 &>> expert.log 2>&1 &
# /usr/bin/time -a -o gcd.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 13 15 7 &>> gcd.log 2>&1 &
# /usr/bin/time -a -o minimax.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/minimax 13 15 7 &>> minimax.log 2>&1 &
# /usr/bin/time -a -o multiplier.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/multiplier 13 15 7 &>> multiplier.log 2>&1 &
# /usr/bin/time -a -o power.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/power 13 15 7 &>> power.log 2>&1 ;
# /usr/bin/time -a -o pretty.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/pretty 13 15 7 &>> pretty.log 2>&1 &
# /usr/bin/time -a -o scc.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/scc 13 15 7 &>> scc.log 2>&1 &
# /usr/bin/time -a -o sorting.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/sorting 13 15 7 &>> sorting.log 2>&1 &
# /usr/bin/time -a -o treejoin.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/treejoin 13 15 7 &>> treejoin.log 2>&1 &
# /usr/bin/time -a -o bernouilli.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/bernouilli 13 15 7 &>> bernouilli.log 2>&1 &
# /usr/bin/time -a -o exp3_8.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/exp3_8 13 15 7 &>> exp3_8.log 2>&1 &
# /usr/bin/time -a -o gen_regexps.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 13 15 7 &>> gen_regexps.log 2>&1 &
# /usr/bin/time -a -o integrate.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/integrate 13 15 7 &>> integrate.log 2>&1 &
# /usr/bin/time -a -o kahan.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/kahan 13 15 7 &>> kahan.log 2>&1 &
# /usr/bin/time -a -o paraffins.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/paraffins 13 15 7 &>> paraffins.log 2>&1 &
# /usr/bin/time -a -o primes.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/primes 13 15 7 &>> primes.log 2>&1 &
# /usr/bin/time -a -o queens.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/queens 13 15 7 &>> queens.log 2>&1 &
# /usr/bin/time -a -o rfib.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/rfib 13 15 7 &>> rfib.log 2>&1 &
# /usr/bin/time -a -o tak.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/tak 13 15 7 &>> tak.log 2>&1 ;
# /usr/bin/time -a -o wheel-sieve1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve1 13 15 7 &>> wheel-sieve1.log 2>&1 &
# /usr/bin/time -a -o x2n1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/x2n1 13 15 7 &>> x2n1.log 2>&1 &
# /usr/bin/time -a -o fannkuch-redux.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fannkuch-redux 13 15 7 &>> fannkuch-redux.log 2>&1 &
# /usr/bin/time -a -o ansi.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/ansi 13 15 7 &>> ansi.log 2>&1 &
# /usr/bin/time -a -o banner.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/banner 13 15 7 &>> banner.log 2>&1 &
# /usr/bin/time -a -o clausify.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 13 15 7 &>> clausify.log 2>&1 &
# /usr/bin/time -a -o cryptarithm2.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm2 13 15 7 &>> cryptarithm2.log 2>&1 &
# /usr/bin/time -a -o eliza.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/eliza 13 15 7 &>> eliza.log 2>&1 &
# /usr/bin/time -a -o fish.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/fish 13 15 7 &>> fish.log 2>&1 ;
# /usr/bin/time -a -o lcss.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lcss 13 15 7 &>> lcss.log 2>&1 &
# /usr/bin/time -a -o puzzle.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/puzzle 13 15 7 &>> puzzle.log 2>&1 
