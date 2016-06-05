for Thing in `ls *timing*`
  do
    echo " ,"$Thing
    grep "mutator_wall" $Thing
    grep "GC_wall" $Thing
  done
