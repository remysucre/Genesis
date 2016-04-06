- [x] genesis readme
- [x] get criterion working
- [x] run genetic, also turn on opt on exp
- milestone
- experiment
  * full coverage, avg score sorted by genes
  * genetic, avg score & generation #

#todo
- now: overnight run, log file, how to trace coverage/avg score
- [x] how to generate next gen
- [x] add config module
- experiment
  - [x] add hint manually
  - [ ] log: 
    - link to git hash
    - generation #
    - population
    - search space(out)
    - score(out)
- space leak zoo
- papers

##on-file
- Randomness 
  * Main.hs:  -- TODO parse CLI arguments here.  Need to determine runs and cliSeed.  
  * random seed: file hash
- Better profiling Main.hs:  -- TODO for the future, check out criterion `measure`
- Accept diverse input program: assuming only one file w/o input
- algorithms: wrapper-filter, hill-climbing, neuro networks
- shrink search space
- concurrency

#goal: 
- get 10 profilable packages
  - small examples
  - hackage
  - nofib
- make genetic faster & better
  - limit code coverage: only one bang, strictness annotation
  - timeout space instead of time
  - ensure code coverage, optimize wider range of input

#strategies: 
- use profile/analysis to break down code (prevent premature opt.)
- use genetic etc. for machine learning
- potentially improve each function/module independently according to call graph/profile

#ideas: 
- simulated anealing
- simulated quantum state collapse?
- artificial neuro network
- thoughts on parsing/building in scale: 
  - difficult because people like to introduce accents to the language
  - learning all the accents/dialects might well be a separate project. machine learning?


#inbox
- [Genetic Main](https://github.com/remysucre/Genesis/blob/master/Main.hs)
- [paper](http://www.ccs.neu.edu/racket/pubs/esop12-cf.pdf)
- [acovea](https://donsbot.wordpress.com/2009/03/09/evolving-faster-haskell-programs/)
- [strictify](http://hackage.haskell.org/package/strictify)

##species in the thunk leak zoo
- accumulating parameter
- spine strict (evaluate)
- recursive data
- multi-threading

##space leaks
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

##questions we can ask about packages
- how many bangs?
- how big
- use what lib

##helpful resources:
- Cyrus random gen
- glob lib for shell cmd
- [GPC](http://book.realworldhaskell.org/read/testing-and-quality-assurance.html) has pretty rendering, but no call tree
- simulated annealing

##people
- philip wadler, benjamin pierce, cyrus cousins, imalsogreg ta gmail.com, brent yorgy, facebook haskell guy, matthias f

##further project
- better parser: support CPP
- better criterion: benchmark cabal project
- machine learning language 
