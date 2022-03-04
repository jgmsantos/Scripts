#!/bin/bash

DIR_INPUT="../../base_de_dados/MERGE_CPTEC/diario/"
DIR_OUTPUT="../tmp"
ShapefileBrasil="../../shapefiles/netcdf/so.Brasil.1km.nc"

DataFinal=`date +"%Y%m%d" -d '1 day ago'` # Data para calcular o evento no formato YYYYMMDD.

for NumeroDias in "10" "20" "30"
do

      DataInicial=`date +"%Y%m%d" -d "${DataFinal} $(($NumeroDias-1)) days ago"`
      
      echo "Período: $DataFinal $DataInicial - Número de dias: $NumeroDias"

      rm -f lista??.txt  # Remove arquivos desnecessários.
      
      while [ ${DataInicial} -le ${DataFinal} ]
      do
           # Cria a lista com todos os arquivos e salva em um "".txt".
           echo "$DIR_INPUT/MERGE_CPTEC_$DataInicial.nc" >> lista01.txt
      
           DataInicial=`date -u +"%Y%m%d" -d "${DataInicial} 1 day "`
      done
      
      ListaArquivos=$(cat lista01.txt | xargs)  # Converte linhas em colunas com o xargs.
      
      # Junta os 30 arquivos em um arquivão.
      cdo -s -O mergetime $ListaArquivos $DIR_OUTPUT/tmp01.nc
      
      # Calcula o Número Máximo de Dias Consecutivos Sem Chuva dado um limiar (R < 1.1 mm/dia).
      cdo -s -setname,ndsc -selname,consecutive_dry_days_index_per_time_period -eca_cdd,1.1 $DIR_OUTPUT/tmp01.nc $DIR_OUTPUT/tmp02.nc
      
      # Interpola o shapefile do Brasil para o domínio espacial do arquivo.
      cdo -s remapbil,$DIR_OUTPUT/tmp02.nc $ShapefileBrasil $DIR_OUTPUT/mask.nc
      # Masca o dado e recorta apenas no domínio espacial do Brasil.
      cdo -s -sellonlatbox,-75,-33,-35,7 -ifthen $DIR_OUTPUT/mask.nc $DIR_OUTPUT/tmp02.nc $DIR_OUTPUT/NDCSC_Max_${NumeroDias}Dias.nc
      
      # Remove arquivos desnecessários.
      rm -f $DIR_OUTPUT/mask.nc $DIR_OUTPUT/tmp??.nc lista01.txt
done