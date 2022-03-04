#!/bin/bash

#########################################
# Obtenção do tempo de máquina utilizado. 
# NÃO DELETAR ESSA LINHA!
datainicial=`date +%s` 
#########################################

# Script que calcula o índice "eca_cdd" disponível em:
# https://guilherme.readthedocs.io/en/latest/pages/tutoriais/cdo.html#indices-climaticos-utilizando-o-cdo 
# Os dados diários de chuva são do IMERG/NASA.
# Tempo total de execução: 00:16:38 

DIR_INPUT="../output"
DIR_TMP="../tmp"
DIR_SHAPE="../shapefile/zonas_divididas_nc/"
DIR_PROCESSADO="../processado"
TMP="201001.nc"
R="3"  # Limiar de precipitação.
N="4"  # Quantas vezes o período consecutivo se repete no intervalo de 4 dias.

rm -f {DIR_TMP}/tmp??.*.nc

for nome_arquivo in ${DIR_INPUT}/*.nc
do
    nome_saida=$(basename ${nome_arquivo})
    cdo -s eca_cdd,${R},${N} ${nome_arquivo} ${DIR_TMP}/tmp01.${nome_saida}
    for zona in zona_01 zona_02 zona_03 zona_04 zona_05 zona_06 zona_07 zona_08 zona_09 zona_10 zona_11 zona_12 zona_13 zona_14 zona_15 zona_16 zona_17 zona_18 zona_19
    do
	    echo "${nome_saida} - ${zona} - R: ${R} (mm/dia) - N: ${N}"
        cdo -s remapbil,${DIR_INPUT}/${TMP} ${DIR_SHAPE}/${zona}.nc ../tmp/tmp02.${zona}.nc
        cdo -s -nint -fldmean -ifthen ../tmp/tmp02.${zona}.nc ${DIR_TMP}/tmp01.${nome_saida} ${DIR_TMP}/tmp03.${zona}.${nome_saida}
		cdo -s cat ${DIR_TMP}/tmp03.${zona}.${nome_saida} ${DIR_TMP}/tmp04.${zona}.nc
	done
done

for zona in zona_01 zona_02 zona_03 zona_04 zona_05 zona_06 zona_07 zona_08 zona_09 zona_10 zona_11 zona_12 zona_13 zona_14 zona_15 zona_16 zona_17 zona_18 zona_19
do
    echo "Separa as variáveis: ${zona}"
    cdo -s splitvar ${DIR_TMP}/tmp04.${zona}.nc ${DIR_TMP}/tmp05.${zona}.
	cdo -s output ${DIR_TMP}/tmp05.${zona}.consecutive_dry_days_index_per_time_period.nc > ${DIR_TMP}/tmp06.${zona}.txt
	cdo -s output ${DIR_TMP}/tmp05.${zona}.number_of_cdd_periods_with_more_than_4days_per_time_period.nc > ${DIR_TMP}/tmp07.${zona}.txt
done

paste ${DIR_TMP}/tmp06.zona_??.txt > ${DIR_TMP}/tmp08.eca_cdd_R.txt
paste ${DIR_TMP}/tmp07.zona_??.txt > ${DIR_TMP}/tmp09.eca_cdd_N.txt

cat ${DIR_TMP}/tmp08.eca_cdd_R.txt | tr -s '\t' ' ' | sed 's/ /;/g ; s/^;//g ; s/;$//g' > ${DIR_PROCESSADO}/eca_cdd_R.txt
cat ${DIR_TMP}/tmp09.eca_cdd_N.txt | tr -s '\t' ' ' | sed 's/ /;/g ; s/^;//g ; s/;$//g' > ${DIR_PROCESSADO}/eca_cdd_N.txt

rm -f ${DIR_TMP}/tmp??.*.nc ${DIR_TMP}/tmp??.*.txt

#####################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
#####################################
