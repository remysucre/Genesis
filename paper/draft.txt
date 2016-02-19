New ideas: 
    - how to find good parameters for GA? 
    - how to prove GA will guess the right bangs consistently (randomness)? 
    - what is the right heuristics: wall clock or gc time?

Intro
 Problem:
  lazy functional languages & slow performance because of 
laziness
    -> bangs to the rescue
  but,
    non-experts are not able to write correct strictness 
annotations
    library writers can put in annotations for some usage but 
not all
  Solution:
    machine learning to evolve best performing annotation 
combination
      why we use GA
    benefits:
      infers good annotations for non-expert programmers
      customized to particular application (not one-size fits 
all)
      take annotations of library writers as hints
    drawbacks:
      may introduce non-termination or other semantic changes
        non-terminating genes won't survive
        use analysis to make sure all introduced bangs are 
executed during GA.
        static analysis/demand analysis of call graph
        todo: is this sufficient? can we find an example where 
things go awry
        changes to side effects
          users should inspect resulting program as a sanity 
check
      takes a long time to run (quantify)
        isn't part of development compilation cycle
        okay if it runs overnight, better than the alternative
        can tune times based on GA parameters
      useless bangs survive evolution
        complicates understanding program
        todo: be smarter about not adding useless bangs
              try pruning bangs
      not robust on all possible data sets
         although possible to construct examples with this 
property
         not common in practice
         todo: show not common in practice
   Evaluation:
     benchmark set is interesting and representative and as 
large as we can do
       different application areas (aeson, nathan, #?)
       different programs using the same libraries (2-aseon, 
1-nathan, #)
       different input data sources  (#)
     compare performance of
        no annotations, expert annotations, inferred 
annotations
     inferred annotations are faster in most cases
     robustness of inferred annotations for single program 
over multiple datasets

2. Background: what GA are, what strictness annotation are
    Two important ways strictness can affect performance: unneccessary 
    annotation wastes computation; uneccessary laziness causes space leak and
    increases GC work. 

3. Our use of GAs to infer strictness annotations represents a certain
    strictness strategy #define# as a gene #define#, and their performance
    as the fitness score #define#. Since any Haskell program has fixed
    strictness points #better term?#, and adding or removing strictness
    annotations do not change this space, we can use a bit vector of fixed
    length to encode the program's strictness strategy. #example on a small 
    program?# 
    
    In choosing a proper heuristic as the fitness score there are
    several options: to use the program runtime, allocation, GC time or a 
    combination of them. #todo more on this?# This choice depends on how the
    programmer wishes the program to perform, and the most critical heuristic
    should be chosen as the score#if there are several important ones?#. 
    #Should we give some advice on picking the fitness, and how?#

    Besides the choice of the fitness score, there are a few other parameters
    available to the programmer to fine-tune the genetic algorithm: population, 
    generation, mutation rate and crossover rate. A good combination of the 
    parameters can contribute to the productivity of genetic algorithm. 
    #todo translate into English: #
    - larger generation number and population covers more space but increases
      the runtime of optimizer. 
    - larger mutation and crossover rate searches more space, but might miss 
      strictness points #is this true?# 
    #TODO support by data/research in machine learning#
    #TODO do we still want to change parameters over time?#

    The workflow of our optimizer, after setting the above parameters, is as 
    follows: the programmer will feed the initial program source, annotated or
    not, as a starting point for the genetic algorithm. Existing annotations
    serve as hints to the optimizer, and if the mutation rate is low #move to
    previous seciton?#, the hints will likely survive if they contribute to 
    performance. Then we populate an initial generation with a gene representing
    the initial program and its mutations. Based on this initial generation, we
    calculate the fitness score of each gene from the performance of the program
    it represents, pick out the stronger ones among them to generate the next 
    generation #better term?#, and repeat the process. 

    Advantages: not linear to search space #evidence?#, once discovered faster 
    programs won't get any worse

    key issue: how fast a generation can be run
       what have we done to make this run fast?
        make search space as small as possible
        parallelize the benchmarking process

    key issue: picking good values for parameters
       how does running time vary with #genes, #generations
    key issue: preserving semantics
        ??

4. Preserving Semantics
    ???

5. Evaluation
    Sanity check:
     In small cases, we find right bangs.
    Benchmarks: what they are
      todo: more benchmarks
    Evaluation:
       performance naked, expert, inferred
        on as many programs as possible.
       stability across data sets
    Running time of inference as parameters and program size 
change.

6. Related Work
    see earlier email
7. Future work and conclusions

things we'd like to be able to do
 1. guarantee not to change semantics (termination or side 
effects)
 2. minimal bang additions
