# for Trace in `ls /data/remy/*short`
#   do
#     mv "$Trace" "/data/remy/temp.trace"
#     ./runGenesis.sh gcSimulator 13 15 7
#     mv gcSimulatorSurvivor.hs "$Trace.hs"
#     mv gcSimulator.log "$Trace.log"
#   done
for Js in `ls aeson-benchmarks/json-data/chicago*.json`
  do
    cp "$Js" json-data/objects.json
    ./runGenesis.sh aeson-benchmarks 13 15 7
    # ./runGenesis.sh aeson-benchmarks 1 1 1
    mv aeson-benchmarksSurvivor.hs "$Js".hs
    mv aeson-benchmarks.log "$Js".log
  done
