PATH_TO_NOFIB=~
/usr/bin/time -a -o awards.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/awards 13 15 7 &>> awards.log 2>&1 &
/usr/bin/time -a -o calendar.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/calendar 13 15 7 &>> calendar.log 2>&1 &
/usr/bin/time -a -o cse.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/cse 13 15 7 &>> cse.log 2>&1 &
/usr/bin/time -a -o expert.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/expert 13 15 7 &>> expert.log 2>&1 &
/usr/bin/time -a -o pretty.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/pretty 13 15 7 &>> pretty.log 2>&1 &
/usr/bin/time -a -o scc.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/scc 13 15 7 &>> scc.log 2>&1 &
/usr/bin/time -a -o sorting.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/sorting 13 15 7 &>> sorting.log 2>&1 &
/usr/bin/time -a -o gen_regexps.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/gen_regexps 13 15 7 &>> gen_regexps.log 2>&1 &
/usr/bin/time -a -o x2n1.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/imaginary/x2n1 13 15 7 &>> x2n1.log 2>&1 &
/usr/bin/time -a -o ansi.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/ansi 13 15 7 &>> ansi.log 2>&1 &
/usr/bin/time -a -o banner.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/banner 13 15 7 &>> banner.log 2>&1 &
/usr/bin/time -a -o eliza.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/spectral/eliza 13 15 7 &>> eliza.log 2>&1
