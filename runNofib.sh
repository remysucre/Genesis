PATH_TO_NOFIB=~
 
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 1 1 1 >> gen_regexps.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve2 1 1 1 >> wheel-sieve2.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/PolyGP 1 1 1 >> PolyGP.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/anna 1 1 1 >> anna.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/cacheprof 1 1 1 >> cacheprof.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/compress 1 1 1 >> compress.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/compress2 1 1 1 >> compress2.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/ebnf2ps 1 1 1 >> ebnf2ps.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fem 1 1 1 >> fem.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fluid 1 1 1 >> fluid.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fulsom 1 1 1 >> fulsom.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gamteb 1 1 1 >> gamteb.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/gg 1 1 1 >> gg.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/hidden 1 1 1 >> hidden.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/infer 1 1 1 >> infer.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/parser 1 1 1 >> parser.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/pic 1 1 1 >> pic.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/prolog 1 1 1 >> prolog.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/reptile 1 1 1 >> reptile.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/rsa 1 1 1 >> rsa.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/scs 1 1 1 >> scs.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/symalg 1 1 1 >> symalg.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/veritas 1 1 1 >> veritas.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/reverse-complement 1 1 1 >> reverse-complement.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/spectral-norm 1 1 1 >> 1 1 1 spectral-norm.log 2>&1 &
#Remy got 1 1 1 >> these.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/atom 1 1 1 >> atom.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/awards 1 1 1 >> awards.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/boyer2 1 1 1 >> boyer2.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/calendar 1 1 1 >> calendar.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cichelli 1 1 1 >> cichelli.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 1 1 1 >> clausify.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/constraints 1 1 1 >> constraints.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cse 1 1 1 >> cse.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/expert 1 1 1 >> expert.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 1 1 1 >> gcd.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lambda 1 1 1 >> lambda.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/last-piece 1 1 1 >> last-piece.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 1 1 1 >> life.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/mandel2 1 1 1 >> mandel2.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/mate 1 1 1 >> mate.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/minimax 1 1 1 >> minimax.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/multiplier 1 1 1 >> multiplier.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/power 1 1 1 >> power.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/pretty 1 1 1 >> pretty.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/scc 1 1 1 >> scc.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/simple 1 1 1 >> simple.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/sorting 1 1 1 >> sorting.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/treejoin 1 1 1 >> treejoin.log 2>&1 &
#stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/triangle 1 1 1 >> triangle.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/bernouilli 1 1 1 >> bernouilli.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/exp3_8 1 1 1 >> exp3_8.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 1 1 1 >> gen_regexps.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/integrate 1 1 1 >> integrate.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/kahan 1 1 1 >> kahan.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/paraffins 1 1 1 >> paraffins.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/primes 1 1 1 >> primes.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/queens 1 1 1 >> queens.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/rfib 1 1 1 >> rfib.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/tak 1 1 1 >> tak.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/wheel-sieve1 1 1 1 >> wheel-sieve1.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/x2n1 1 1 1 >> x2n1.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/maillist 1 1 1 >> maillist.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/binary-trees 1 1 1 >> binary-trees.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fannkuch-redux 1 1 1 >> fannkuch-redux.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fasta 1 1 1 >> fasta.log 2>&1 &
# stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/k-nucleotide # 1 1 1 >> k-nucleotide #.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/n-body 1 1 1 >> n-body.log 2>&1 ;
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/pidigits 1 1 1 >> pidigits.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/ansi 1 1 1 >> ansi.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/banner 1 1 1 >> banner.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/clausify 1 1 1 >> clausify.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm1 1 1 1 >> cryptarithm1.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cryptarithm2 1 1 1 >> cryptarithm2.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/eliza 1 1 1 >> eliza.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/fish 1 1 1 >> fish.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/gcd 1 1 1 >> gcd.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/integer 1 1 1 >> integer.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/lcss 1 1 1 >> lcss.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/life 1 1 1 >> life.log 2>&1 &
stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/puzzle 1 1 1 >> puzzle.log 2>&1 
