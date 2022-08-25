#!/bin/bash

DIR_INPUT="/mnt/d/gui/base_de_dados/MERGE_CPTEC/diario"
DIR_TMP="./tmp"

rm -f data.{txt,log}

for ano in {2001..2022}
do
    echo "cdo -s -O -monsum -mergetime $DIR_INPUT/MERGE_CPTEC_${ano}????.nc ${DIR_TMP}/ano.${ano}.nc" >> data.txt
done

parallel -j 2 < data.txt > data.log

# Junta todos os arquivos mensais.
cdo -s -O mergetime ${DIR_TMP}/ano.????.nc $DIR_TMP/tmp01.nc

mes=7
ano=2022

# Seleciona o mês de interesse.
cdo -s -selmon,${mes} -selyear,${ano} $DIR_TMP/tmp01.nc $DIR_TMP/mes_corrente.nc

# Média mensal.
cdo -s -timmean -selmon,${mes} -selyear,2001/2021 $DIR_TMP/tmp01.nc $DIR_TMP/med_mensal.nc

# Desvio padrão.
cdo -s -timstd -selmon,${mes} -selyear,2001/2021 $DIR_TMP/tmp01.nc $DIR_TMP/desv_padrao.nc

# Anomalia.
cdo -s sub $DIR_TMP/mes_corrente.nc $DIR_TMP/med_mensal.nc $DIR_TMP/anomalia.nc

# Z-Score.
cdo -s div $DIR_TMP/anomalia.nc $DIR_TMP/desv_padrao.nc zscore.nc

rm -f $DIR_TMP/tmp01.nc $DIR_TMP/mes_corrente.nc $DIR_TMP/med_mensal.nc $DIR_TMP/desv_padrao.nc $DIR_TMP/anomalia.nc