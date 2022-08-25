#!/bin/bash

# SCRIPT ALTERNATIVO para calcular o Índice Z-Score de Risco de Fogo.
# Não foi feito em Python porque dá estouro de memória. A solução foi gerar um 
# arquivo de desvio padrão para evitar o carregamento de muitos arquivos em memória.
# Guilherme Martins - 16/08/2022

RAIZ="/mnt/vol_queimadas_2/INPE_FireRiskModel/data/output/dados_mensais/Risco_Fogo"
DIR_OUTPUT="/mnt/vol_queimadas_2/censipam/zscore/risco_fogo"
DIR_TMP="/home/queimadas/tmp"
txt="cmd.sh"

rm -f ${txt}

ano="2022" # Ano de interesse.

for mes in {01..07} # Meses de interesse.
do
     OBSERVADO="${RAIZ}/media_mensal/netcdf/${ano}/INPE_FireRiskModel_${ano}${mes}.nc"
     CLIMATOLOGIA="${RAIZ}/climatologia/netcdf/INPE_FireRiskModel_Climatologia_2001_2021.mes.${mes}.nc"
     cmd="cdo -s sub $OBSERVADO $CLIMATOLOGIA ${DIR_TMP}/anomalia.${mes}.nc"
     cmd="${cmd} && cdo -s -timstd -selyear,2001/2021 -mergetime ${RAIZ}/media_mensal/netcdf/????/INPE_FireRiskModel_????${mes}.nc ${DIR_TMP}/desvio_padrao.${mes}.nc"
     cmd="${cmd} && cdo -s div ${DIR_TMP}/anomalia.${mes}.nc ${DIR_TMP}/desvio_padrao.${mes}.nc ${DIR_TMP}/zscore.risco_fogo_${ano}${mes}.nc"
     cmd="${cmd} && cdo -s expr,'rf=(rf>4)?4:rf' ${DIR_TMP}/zscore.risco_fogo_${ano}${mes}.nc ${DIR_TMP}/tmp01.${mes}.nc"
     cmd="${cmd} && cdo -s expr,'rf=(rf<-4)?-4:rf' ${DIR_TMP}/tmp01.${mes}.nc ${DIR_OUTPUT}/${ano}/zscore.risco_fogo_${ano}${mes}.nc"
     cmd="${cmd} && gdal_translate -of GTiff -a_srs EPSG:4326 ${DIR_OUTPUT}/${ano}/zscore.risco_fogo_${ano}${mes}.nc ${DIR_OUTPUT}/${ano}/zscore.risco_fogo_${ano}${mes}.tif"
     cmd="${cmd} && rm -f ${DIR_TMP}/anomalia.${mes}.nc ${DIR_TMP}/desvio_padrao.${mes}.nc ${DIR_TMP}/zscore.risco_fogo_${ano}${mes}.nc ${DIR_TMP}/tmp??.${mes}.nc ${DIR_OUTPUT}/${ano}/zscore.risco_fogo_${ano}${mes}.nc"
     echo ${cmd} >> ${txt}
done

nohup parallel -j 12 < ${txt}