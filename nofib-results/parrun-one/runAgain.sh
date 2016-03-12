PATH_TO_NOFIB=~
/usr/bin/time -a -o sorting.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/sorting 15 13 7 &>> sorting.log 2>&1 &
/usr/bin/time -a -o gen_regexps.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 15 13 7 &>> gen_regexps.log 2>&1 &
/usr/bin/time -a -o fannkuch-redux.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fannkuch-redux 15 13 7 &>> fannkuch-redux.log 2>&1 &
/usr/bin/time -a -o binary-trees.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/binary-trees 15 13 7 &>> binary-trees.log 2>&1 &
/usr/bin/time -a -o n-body.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/n-body 15 13 7 &>> n-body.log 2>&1 ;
/usr/bin/time -a -o anna.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/anna 15 13 7 &>> anna.log 2>&1 &
/usr/bin/time -a -o expert.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/expert 15 13 7 &>> expert.log 2>&1 &
/usr/bin/time -a -o fluid.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fluid 15 13 7 &>> fluid.log 2>&1 &
/usr/bin/time -a -o fulsom.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fulsom 15 13 7 &>> fulsom.log 2>&1 &
/usr/bin/time -a -o multiplier.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/multiplier 15 13 7 &>> multiplier.log 2>&1 &
/usr/bin/time -a -o power.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/power 15 13 7 &>> power.log 2>&1 &
/usr/bin/time -a -o symalg.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/symalg 15 13 7 &>> symalg.log 2>&1 

# /usr/bin/time -a -o wheel-sieve2.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve2 15 13 7 &>> wheel-sieve2.log 2>&1 &
# /usr/bin/time -a -o cacheprof.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/cacheprof 15 13 7 &>> cacheprof.log 2>&1 &
# /usr/bin/time -a -o fem.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fem 15 13 7 &>> fem.log 2>&1 &
# /usr/bin/time -a -o gamteb.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gamteb 15 13 7 &>> gamteb.log 2>&1 &
# /usr/bin/time -a -o gg.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gg 15 13 7 &>> gg.log 2>&1 &
# /usr/bin/time -a -o hidden.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/hidden 15 13 7 &>> hidden.log 2>&1 &
# /usr/bin/time -a -o infer.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/infer 15 13 7 &>> infer.log 2>&1 &
# /usr/bin/time -a -o pic.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/pic 15 13 7 &>> pic.log 2>&1 &
# /usr/bin/time -a -o prolog.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/prolog 15 13 7 &>> prolog.log 2>&1 &
# /usr/bin/time -a -o reptile.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/reptile 15 13 7 &>> reptile.log 2>&1 &
# /usr/bin/time -a -o rsa.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/rsa 15 13 7 &>> rsa.log 2>&1 ;
# /usr/bin/time -a -o scs.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/scs 15 13 7 &>> scs.log 2>&1 &
# /usr/bin/time -a -o atom.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/atom 15 13 7 &>> atom.log 2>&1 &
# /usr/bin/time -a -o awards.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/awards 15 13 7 &>> awards.log 2>&1 &
# /usr/bin/time -a -o boyer2.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/boyer2 15 13 7 &>> boyer2.log 2>&1 &
# /usr/bin/time -a -o calendar.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/calendar 15 13 7 &>> calendar.log 2>&1 &
# /usr/bin/time -a -o cichelli.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cichelli 15 13 7 &>> cichelli.log 2>&1 &
# /usr/bin/time -a -o clausify.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 15 13 7 &>> clausify.log 2>&1 &
# /usr/bin/time -a -o cse.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cse 15 13 7 &>> cse.log 2>&1 &
# /usr/bin/time -a -o gcd.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 15 13 7 &>> gcd.log 2>&1 &
# /usr/bin/time -a -o life.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 15 13 7 &>> life.log 2>&1 &
# /usr/bin/time -a -o minimax.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/minimax 15 13 7 &>> minimax.log 2>&1 &
# /usr/bin/time -a -o pretty.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/pretty 15 13 7 &>> pretty.log 2>&1 &
# /usr/bin/time -a -o scc.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/scc 15 13 7 &>> scc.log 2>&1 &
# /usr/bin/time -a -o simple.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/simple 15 13 7 &>> simple.log 2>&1 &
# /usr/bin/time -a -o treejoin.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/treejoin 15 13 7 &>> treejoin.log 2>&1 &
# /usr/bin/time -a -o bernouilli.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/bernouilli 15 13 7 &>> bernouilli.log 2>&1 &
# /usr/bin/time -a -o exp3_8.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/exp3_8 15 13 7 &>> exp3_8.log 2>&1 &
# /usr/bin/time -a -o gen_regexps.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 15 13 7 &>> gen_regexps.log 2>&1 &
# /usr/bin/time -a -o integrate.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/integrate 15 13 7 &>> integrate.log 2>&1 &
# /usr/bin/time -a -o kahan.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/kahan 15 13 7 &>> kahan.log 2>&1 &
# /usr/bin/time -a -o paraffins.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/paraffins 15 13 7 &>> paraffins.log 2>&1 &
# /usr/bin/time -a -o primes.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/primes 15 13 7 &>> primes.log 2>&1 &
# /usr/bin/time -a -o queens.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/queens 15 13 7 &>> queens.log 2>&1 &
# /usr/bin/time -a -o rfib.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/rfib 15 13 7 &>> rfib.log 2>&1 &
# /usr/bin/time -a -o tak.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/tak 15 13 7 &>> tak.log 2>&1 ;
# /usr/bin/time -a -o wheel-sieve1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve1 15 13 7 &>> wheel-sieve1.log 2>&1 &
# /usr/bin/time -a -o x2n1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/x2n1 15 13 7 &>> x2n1.log 2>&1 &
# /usr/bin/time -a -o maillist.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/maillist 15 13 7 &>> maillist.log 2>&1 &
# /usr/bin/time -a -o fasta.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fasta 15 13 7 &>> fasta.log 2>&1 &
# /usr/bin/time -a -o pidigits.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/pidigits 15 13 7 &>> pidigits.log 2>&1 &
# /usr/bin/time -a -o ansi.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/ansi 15 13 7 &>> ansi.log 2>&1 &
# /usr/bin/time -a -o banner.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/banner 15 13 7 &>> banner.log 2>&1 &
# /usr/bin/time -a -o clausify.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 15 13 7 &>> clausify.log 2>&1 &
# /usr/bin/time -a -o cryptarithm1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm1 15 13 7 &>> cryptarithm1.log 2>&1 &
# /usr/bin/time -a -o cryptarithm2.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm2 15 13 7 &>> cryptarithm2.log 2>&1 &
# /usr/bin/time -a -o eliza.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/eliza 15 13 7 &>> eliza.log 2>&1 &
# /usr/bin/time -a -o fish.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/fish 15 13 7 &>> fish.log 2>&1 ;
# /usr/bin/time -a -o gcd.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 15 13 7 &>> gcd.log 2>&1 &
# /usr/bin/time -a -o integer.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/integer 15 13 7 &>> integer.log 2>&1 &
# /usr/bin/time -a -o lcss.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lcss 15 13 7 &>> lcss.log 2>&1 &
# /usr/bin/time -a -o life.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 15 13 7 &>> life.log 2>&1 &
# /usr/bin/time -a -o puzzle.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/puzzle 15 13 7 &>> puzzle.log 2>&1 
