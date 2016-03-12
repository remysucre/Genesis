PATH_TO_NOFIB=~
/usr/bin/time -a -o gen_regexps.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 5 5 2 &>> gen_regexps.log 2>&1 
