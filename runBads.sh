PATH_TO_NOFIB=/data/dan/

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
stack exec GenesisNF ~/nofib/spectral/atom 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/awards 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/boyer2 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/calendar 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/cichelli 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/clausify 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/constraints 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/cse 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/expert 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/gcd 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/lambda 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/last-piece 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/life 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/mandel2 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/mate 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/minimax 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/multiplier 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/power 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/pretty 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/scc 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/simple 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/sorting 1 1 1 >> gennofib.log 2>&1 ;
stack exec GenesisNF ~/nofib/spectral/treejoin 1 1 1 >> gennofib.log 2>&1 ;
#stack exec GenesisNF ~/nofib/spectral/triangle 1 1 1 >> gennofib.log 2>&1 
