#!/bin/bash

PATH_TO_NOFIB=~
/usr/bin/time -a -o fannkuch-redux.log stack exec GenesisNF ${PATH_TO_NOFIB}/nofib/shootout/fannkuch-redux 13 15 7 &>> fannkuch-redux.log 2>&1 
