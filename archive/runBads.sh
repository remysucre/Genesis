PATH_TO_NOFIB=~
/usr/bin/time -a -o anna.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/anna 1 1 1 &>> anna.log 2>&1 &
/usr/bin/time -a -o fluid.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fluid 1 1 1 &>> fluid.log 2>&1 &
/usr/bin/time -a -o fulsom.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/fulsom 1 1 1 &>> fulsom.log 2>&1 &
/usr/bin/time -a -o symalg.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/real/symalg 1 1 1 &>> symalg.log 2>&1 &
/usr/bin/time -a -o multiplier.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/multiplier 1 1 1 &>> multiplier.log 2>&1 &
/usr/bin/time -a -o power.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/power 1 1 1 &>> power.log 2>&1 
