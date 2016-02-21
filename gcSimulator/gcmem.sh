# cp /data/remy/fop.trace /data/remy/temp.trace &&
cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
cp gen2.hs Main.hs && cabal run && mv timing.log gen2timing.log 
# mkdir fop && mv *timing* fop &&

# cp /data/remy/tradebeans.trace /data/remy/temp.trace &&
# cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
# cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
# cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
# mkdir tradebeans && mv *timing* tradebeans &&
# 
# cp /data/remy/tradesoap.trace /data/remy/temp.trace &&
# cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
# cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
# cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
# mkdir tradesoap && mv *timing* tradesoap 
