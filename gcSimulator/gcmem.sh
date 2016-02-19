cp /data/remy/fop.trace temp.trace &&
cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
mkdir fop && mv *timing* fop &&

cp /data/remy/tradebeans.trace temp.trace &&
cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
mkdir tradebeans && mv *timing* tradebeans &&

cp /data/remy/tradesoap.trace temp.trace &&
cp nobangs.hs Main.hs && cabal run && mv timing.log nobangstiming.log &&
cp bangs.hs Main.hs && cabal run && mv timing.log bangstiming.log &&
cp gen.hs Main.hs && cabal run && mv timing.log gentiming.log &&
mkdir tradesoap && mv *timing* tradesoap 
