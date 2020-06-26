#!/bin/bash

DIR_INPUT=""
DIR_TMP=""
DIR_PROCESSADO=""

rm -f lista.txt

for ano in $(seq 2010 2020)
do
    if [ $ano = 2020 ]
    then 
       mes="01 02 03 04 05"
    else
       mes="01 02 03 04 05 06 07 08 09 10 11 12"
    fi
    for mes in $mes
    do
        echo "cdo -O -s mergetime ${DIR_INPUT}/PREC.IMERG.${ano}${mes}*.nc ${DIR_TMP}/${ano}${mes}.nc" >> lista1
        echo "cdo -s -sellonlatbox,-75,-33,-35,6 -ifthen ../shapefile/brasil.nc ${DIR_TMP}/${ano}${mes}.nc ${DIR_PROCESSADO}/${ano}${mes}.nc" >> lista2
    done
done

num_processadores="100" # Número de processadores a serem utilizados.

for lista in lista1 lista2
do
    split -l ${num_processadores} ${lista} ${lista}_
    rm -f comandos.sh
    for arq in $(ls -1 ${lista}_*); do
	echo "parallel -j ${num_processadores} -- < $arq" >> script.sh
    done
    chmod +x script.sh
    ./script.sh
done

rm -f lista* script.sh ../${DIR_TMP}/??????.nc
