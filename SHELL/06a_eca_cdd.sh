#!/bin/bash

rm -f datas?.txt

for ano in $(seq 2001 2020)
do
    if [ $ano = 2020 ]
    then
       mesc="01 02 03 04 05 06 07"
    else
       mesc="01 02 03 04 05 06 07 08 09 10 11 12"
    fi

    for mes in ${mesc}
     do
        echo "cdo -s -O mergetime ../PREC.CPC.${ano}${mes}??00.nc tmp/PREC.CPC.${ano}${mes}.nc" >> datas1.txt
        echo "cdo -s -O -sellonlatbox,-75,-33,-35,6 -ifthen mask.nc tmp/PREC.CPC.${ano}${mes}.nc tmp/PREC.${ano}${mes}.nc" >> datas2.txt

    done
done

nohup parallel -j 12 < datas1.txt > datas1.log
nohup parallel -j 12 < datas2.txt > datas2.log
