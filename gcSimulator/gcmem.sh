cp nobangs.hs Main.hs && cabal run > /dev/null && mv timing.temp nobangstiming.log &&
cp bangs.hs Main.hs && cabal run > /dev/null && mv timing.temp bangstiming.log &&
cp gen.hs Main.hs && cabal run > /dev/null && mv timing.temp gentiming.log &&
# cp gen2.hs Main.hs && cabal run > /dev/null && mv timing.temp gen2timing.log 
mkdir train && mv *timing* train

# cp /data/remy/tradebeans.trace /data/remy/temp.trace &&
# cp nobangs.hs Main.hs && cabal run && mv timing.temp nobangstiming.log &&
# cp bangs.hs Main.hs && cabal run && mv timing.temp bangstiming.log &&
# cp gen.hs Main.hs && cabal run && mv timing.temp gentiming.log &&
# mkdir tradebeans && mv *timing* tradebeans &&
# 
# cp /data/remy/tradesoap.trace /data/remy/temp.trace &&
# cp nobangs.hs Main.hs && cabal run && mv timing.temp nobangstiming.log &&
# cp bangs.hs Main.hs && cabal run && mv timing.temp bangstiming.log &&
# cp gen.hs Main.hs && cabal run && mv timing.temp gentiming.log &&
# mkdir tradesoap && mv *timing* tradesoap 
