# for Trace in `ls /data/remy/*short`
#   do
#     mv "$Trace" "/data/remy/temp.trace"
#     ./runGenesis.sh gcSimulator 13 15 7
#     mv gcSimulatorSurvivor.hs "$Trace.hs"
#     mv gcSimulator.log "$Trace.log"
#   done
for Js in `ls aeson-benchmarks/json-data/chicago*.json`
  do
    cp "$Js" aeson-benchmarks/json-data/objects.json
    # ./runGenesis.sh aeson-benchmark 13 15 7
    ./runGenesis.sh aeson-benchmark 1 1 1
    mv gcSimulatorSurvivor.hs "$Js".hs
    mv gcSimulator.log "$Js".log
  done
