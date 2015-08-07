##issues
- Genetic:
  - [Genetic.hs](https://github.com/remysucre/comp150-FP/blob/master/Genetic.hs) `mutateStrand` Cannot get to later bangs because size is incorrectly interpreted as bit vector. Corrected. 
  - First generation generated by randomly mutating copies of original program + original. 
  - Next generation born out of mutating randomly merged children and their parents keeping original parents
  - Selection happens in canonical function `geneticAlg`, better move
  - parameters: global or as arguments? 
- Tour of the Space Leak Zoo:
  - [thunk2 analysis](https://github.com/remysucre/comp150-FP/blob/master/profile/hsleak/thunk2/thunk2.hs)
  - Encountered 2 new kinds of thunk leak: 
    - [recursive data](http://stackoverflow.com/questions/29958541/space-leak-with-recursive-list-zipwith)
      - [simplified](https://github.com/remysucre/comp150-FP/blob/master/profile/zipw3/zipw3.hs)
    - multiple threading 
    - list comprehension

##todo
- [x] understand the small examples
- genetics
  - [ ] where does first gene come from
  - [ ] how does regeneration happen
  - [ ] where does repetition come from: accumulation or bad randomization
- [ ] think about proving strict independency

##issues
- mind-blowing: sequence on list
- [gene-time map](https://github.com/remysucre/comp150-FP/blob/master/myfile.result): 
  - only flips bangs in the [first level](https://github.com/remysucre/comp150-FP/blob/master/genemap.log)
  - lots of repetitions, caused by not recognizing the same program text
  - however, statistics shows second bang matters!
- [spine strict](https://github.com/remysucre/comp150-FP/blob/master/profile/hsleak/thunk2/thunk2.hs): 
  - [evaluation semantics](http://hackage.haskell.org/package/base-4.8.1.0/docs/Control-Exception-Base.html#v:evaluate)
- created [cabal file](https://github.com/remysucre/comp150-FP/blob/master/GeneticStrictness.cabal): a lot of dependencies, are they all necessary?
- Is it possible to prove that: 
  - If a Bang improves space efficiency in a certain context, it will improve space efficiency in any context

##species in the thunk leak zoo
- accumulating parameter
- spine strict (evaluate)
- recursive data
- multi-threading

##space leak examples
- [ ] [space leak zoo](http://blog.ezyang.com/2011/05/space-leak-zoo/)
- [x] [sum](https://github.com/remysucre/comp150-FP/blob/master/profile/sumacc/3x51.hs)
- [x] [fib](https://github.com/remysucre/comp150-FP/blob/master/profile/fib/fibsum.hs)
- [x] [hsleak](https://github.com/remysucre/comp150-FP/tree/master/profile/hsleak)
- [ ] [strictlist](http://stackoverflow.com/questions/6630782/thunk-memory-leak-as-a-result-of-map-function/6667023#6667023)
- [x] [recursive list](https://github.com/remysucre/comp150-FP/blob/master/profile/zipw3/zipw3.hs)
  - relevant: [sequence](http://stackoverflow.com/questions/3190098/space-leak-in-list-program), [zip](http://stackoverflow.com/questions/29958541/space-leak-with-recursive-list-zipwith)
- [ ] [hash table](http://stackoverflow.com/questions/7855323/fixing-a-particularly-obscure-haskell-space-leak)
- [ ] [hash 2](http://stackoverflow.com/questions/23163125/haskell-space-leak-in-hash-table-insertion)
- [x] [string](http://stackoverflow.com/questions/19355344/space-leak-in-simple-string-generation-why)
- [ ] [multi threading](http://stackoverflow.com/questions/7768536/space-leaks-in-haskell)
- [ ] [lazy tree](http://stackoverflow.com/questions/6638126/lazy-tree-with-a-space-leak)

##notes: 
- [SCC pragma](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/profiling.html#scc-pragma) 
- partition
  - when compiling we still want the actual pack info
    - from [SO](http://stackoverflow.com/questions/31343246/get-package-version-to-cpp/31343829#31343829)
  - #include macro
  - last in do block must be exp

##ICFP wishlist

##goal: 
- get 10 profilable packages
  - small examples
  - hackage
  - nofib
- make genetic faster & better
  - limit code coverage: only one bang, strictness annotation
  - timeout space instead of time
  - ensure code coverage, optimize wider range of input

##strategies: 
- use profile/analysis to break down code (prevent premature opt.)
- use genetic etc. for machine learning
- potentially improve each function/module independently according to call graph/profile
- TODO: add a picture here?

##ideas: 
- dont run until finish, stop when heap grows too big
- simulated anealing
- simulated quantum state collaps?
- thoughts on parsing/building in scale: 
  - difficult because people like to introduce accents to the language
  - learning all the accents/dialects might well be a separate project. machine learning?

##questions we can ask about packages
- how many bangs?
- how big
- use what lib

##helpful resources:
- Cyrus random gen
- glob lib for shell cmd
- [GPC](http://book.realworldhaskell.org/read/testing-and-quality-assurance.html) has pretty rendering, but no call tree
- simulated annealing

##further project
- better parser: support CPP
- better cabal profiling
- machine learning language 