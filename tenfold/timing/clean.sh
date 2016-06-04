for Log in `ls *log`
  do 
    echo " ,"$Log && grep "GC_wall" $Log && grep "mutator_wall" $Log
  done
