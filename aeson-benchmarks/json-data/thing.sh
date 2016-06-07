for L in `ls *timing.log` 
  do echo " ,"$L && grep "mutator_wall" $L && grep "GC_wall" $L && grep "max_bytes" $L
  done
