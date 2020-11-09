#!/bin/bash

rm -f datas?.txt

for ano in $(seq 2001 2020)
do
    if [ $ano = 2020 ] # O ano de 2020 tem dados até julho.
    then
       mesc="01 02 03 04 05 06 07"
    else
       mesc="01 02 03 04 05 06 07 08 09 10 11 12"
    fi

    for mes in ${mesc}
     do
        # Linha de comando para juntar os arquivos.
        echo "cdo -s -O mergetime ../PREC.CPC.${ano}${mes}??00.nc tmp/PREC.CPC.${ano}${mes}.nc" >> datas1.txt
        # Linha de comando para mascarar os dados apenas sobre o Brasil e recorte do dado apenas na ára de interesse.
        echo "cdo -s -O -sellonlatbox,-75,-33,-35,6 -ifthen mask.nc tmp/PREC.CPC.${ano}${mes}.nc tmp/PREC.${ano}${mes}.nc" >> datas2.txt
    done
done

nohup parallel -j 12 < datas1.txt > datas1.log  # Comando parallel para juntar os arquivos.
nohup parallel -j 12 < datas2.txt > datas2.log  # Comando parallel para mascarar e recortar os arquivos.
