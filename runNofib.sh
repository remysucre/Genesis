PATH_TO_NOFIB=${PATH_TO_NOFIB}

stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve2 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/PolyGP 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/anna 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/cacheprof 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/compress 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/compress2 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/ebnf2ps 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fem 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fluid 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fulsom 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gamteb 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gg 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/hidden 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/infer 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/parser 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/pic 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/prolog 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/reptile 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/rsa 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/scs 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/symalg 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/veritas 1 1 1 >> gennofib.log 2>&1 ;
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/reverse-complement 1 1 1 >> gennofib.log 2>&1 ;
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/spectral-norm 1 1 1 >> gennofib.log 2>&1 ;

#Remy got these
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/atom 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/awards 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/boyer2 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/calendar 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cichelli 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/constraints 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cse 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/expert 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lambda 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/last-piece 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/mandel2 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/mate 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/minimax 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/multiplier 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/power 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/pretty 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/scc 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/simple 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/sorting 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/treejoin 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/triangle 1 1 1 >> gennofib.log 2>&1 
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/bernouilli 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/exp3_8 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/integrate 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/kahan 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/paraffins 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/primes 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/queens 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/rfib 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/tak 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve1 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/x2n1 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/maillist 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/binary-trees 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fannkuch-redux 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fasta 1 1 1 >> gennofib.log 2>&1 ;
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/k-nucleotide 1 1 1 # >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/n-body 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/pidigits 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/ansi 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/banner 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm1 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm2 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/eliza 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/fish 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/integer 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lcss 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/puzzle 1 1 1 >> gennofib.log 2>&1
