for Trace in `ls *trace` 
  do
    head -n 35155986 "$Trace" > "$Trace.short"
  done
