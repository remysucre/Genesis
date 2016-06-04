for Source in `ls rnf*.hs` 
  do
    for Js in `ls json-data/chicago*`
      do
        echo $Js
        cp $Js json-data/objects.json
        cp $Source Main.hs && cabal run && mv timing.temp "$Js$Source".timing
      done
  done

# nonrnfgen.hs  rnfgen.hs  rnfnobangs.hs
