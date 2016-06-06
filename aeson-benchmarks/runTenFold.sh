for Js in `ls json-data/chicago*.json`
  do
    cp "$Js" "json-data/objects.json"
    for Hs in `ls chicago*.hs`
      do
        cp "$Hs" Main.hs && cabal run > /dev/null && mv timing.temp "$Js"."$Hs"timing.log 
        echo "$Js"."$Hs"
      done
  done
