#todo
- change to bv
- modularize
#issues:
 - how to walk tree (strict points & edit bangs):
    1. declare ast as an instance of functor/foldable/some other type class
    2. any kind of treeZipper that zips the bang nodes with a bangVec?
 - decision to make: gene as bitvector v.s. as as
    1. ast challenge: 
      - how to generate random entity?
      - how to control randomness when mutating/crossover?
