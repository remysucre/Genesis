[ ] start eval
[ ] comp w/ exhaustive, random
[ ] find good default parameters/a formula finding good pars: run over fake data
[ ] calculate probability of finding x bangs out of n within i iterations, 
  compare w/ random search, using fake data
[ ] find out if we are getting performance out of safety, from toys
[ ] make optimizer take multiple source files
[ ] run nofib in parallel and report error log
[ ] clean up data

add timeout for nofib
make all of nofib work
run multiple instances of optimizer
runtime of optimizer
calculate coverage from experiment data

[ ] tool: return not only the best gene, but a collection of good ones
[ ] tool: output patch file, not cheekily modify source file

data we have so far: 
nofib                   |others
------------------------|-------------------------
200 total               |nathan: training data
70  compilable          |json: driver & lib
27  optimizable         |nofib/fibon: driver & lib
3   got improvement     |shootout bintree: improve
5   already have bangs  |              upon GHC 02
