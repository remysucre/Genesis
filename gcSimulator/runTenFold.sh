for Trace in `ls /data/remy/*short`
  do
    cp "$Trace" "/data/remy/temp.trace"
    for Hs in `ls *short.hs `
      do
        cp "$Hs" Main.hs && cabal run > /dev/null && mv timing.temp "$Hs"."$Trace"timing.log 
#        echo "$Trace"."$Hs"
      done
  done
