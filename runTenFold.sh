for Trace in `ls /data/remy/*short`
  do
    mv "$Trace" "/data/remy/temp.trace"
    ./runGenesis.sh gcSimulator 13 15 7
    mv gcSimulatorSurvivor.hs "$Trace.hs"
    mv gcSimulator.log "$Trace.log"
  done
