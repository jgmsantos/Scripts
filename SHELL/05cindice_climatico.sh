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
DIR_SHAPE="../shapefile"
DIR_PROCESSADO="../processado"
TMP="201001.nc"
R="3"  # Limiar de precipitação.
N="4"  # Quantas vezes o período consecutivo se repete no intervalo de 4 dias.

rm -f {DIR_TMP}/tmp??.*.nc ${DIR_TMP}/tmp??.????.txt

for nome_arquivo in ${DIR_INPUT}/*.nc
do
    nome_saida=$(basename ${nome_arquivo})
    cdo -s eca_cdd,${R},${N} ${nome_arquivo} ${DIR_TMP}/tmp01.${nome_saida}
    for zona in pantanal
    do
	echo "${nome_saida} - ${zona} - R: ${R} (mm/dia) - N: ${N}"
        cdo -s remapbil,${DIR_INPUT}/${TMP} ${DIR_SHAPE}/${zona}.nc ../tmp/tmp02.${zona}.nc
        cdo -s -nint -fldmean -ifnotthen ../tmp/tmp02.${zona}.nc ${DIR_TMP}/tmp01.${nome_saida} ${DIR_TMP}/tmp03.${zona}.${nome_saida}
	cdo -s cat ${DIR_TMP}/tmp03.${zona}.${nome_saida} ${DIR_TMP}/tmp04.${zona}.nc
    done
done

for zona in pantanal
do
    echo "Separa as variáveis: ${zona}"
    cdo -s splitvar ${DIR_TMP}/tmp04.${zona}.nc ${DIR_TMP}/tmp05.${zona}.
done

# Não esquece de alterar o nome dos arquivos abaixo de acordo o nome da linha acima.
cdo -s splityear ${DIR_TMP}/tmp05.pantanal.consecutive_dry_days_index_per_time_period.nc ${DIR_TMP}/tmp06.pantanal.consecutive_dry_days_index_per_time_period.
cdo -s splityear ${DIR_TMP}/tmp05.pantanal.number_of_cdd_periods_with_more_than_4days_per_time_period.nc ${DIR_TMP}/tmp07.pantanal.number_of_cdd_periods_with_more_than_4days_per_time_period.

for ano in $(seq 2010 2020)
do
    cdo -s output ${DIR_TMP}/tmp06.pantanal.consecutive_dry_days_index_per_time_period.${ano}.nc | xargs >> ${DIR_TMP}/tmp08.${ano}.txt
    cdo -s output ${DIR_TMP}/tmp07.pantanal.number_of_cdd_periods_with_more_than_4days_per_time_period.${ano}.nc | xargs >> ${DIR_TMP}/tmp09.${ano}.txt
done

cat ${DIR_TMP}/tmp08.????.txt | sed 's/ /;/g' > ${DIR_PROCESSADO}/eca_cdd_R.txt
cat ${DIR_TMP}/tmp09.????.txt | sed 's/ /;/g' > ${DIR_PROCESSADO}/eca_cdd_N.txt

rm -f ${DIR_TMP}/tmp??.*.nc ${DIR_TMP}/tmp??.*.txt

#####################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
#####################################
