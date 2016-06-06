for J in `ls *json` 
  do echo $J && diff objects.json $J | wc -l 
  done
