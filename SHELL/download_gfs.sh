#!/bin/bash

URL="https://noaa-gfs-bdp-pds.s3.amazonaws.com"
DIRETORIO_TMP="/mnt/c/Users/guilherme.martins/guilherme/testes/gfs/tmp"
DIA_PREVISAO="20250114"

Primeira_Hora_Previsao=1 # Primeira hora de previsão de interesse. De acordo com o diretório, inicia às f000 até f384.
Ultima_Hora_Previsao=384 # Última hora de previsão.
Intervalo_Previsao=1 # Em horas.

rm -f lista.txt

while [[ ${Primeira_Hora_Previsao} -le ${Ultima_Hora_Previsao} ]]
do
    # Previsão no formato f???. Exemplo: f001, f002, f384.
    previsao=$(echo ${Primeira_Hora_Previsao} | awk '{printf("%.3d",$1)}')

    # Incrementa a data e hora da previsão.
    YYYYMMDDHH=$(date -u -d "${DIA_PREVISAO} +${Primeira_Hora_Previsao} hours" +"%Y-%m-%d,%H":00:00)
    echo "Data e hora da previsão: ${Primeira_Hora_Previsao} - ${YYYYMMDDHH}"

    cmd="gdal_translate /vsicurl/${URL}/gfs.${DIA_PREVISAO}/00/atmos/gfs.t00z.pgrb2.0p25.f${previsao} -b 596 -projwin -85 10 -32 -35 -of netcdf -co "FORMAT=NC" ${DIRETORIO_TMP}/tmp01.gfs.t00z.pgrb2.0p25.f${previsao}.nc"
    cmd="${cmd} && cdo -s --no_history -setname,prec -settaxis,${YYYYMMDDHH} ${DIRETORIO_TMP}/tmp01.gfs.t00z.pgrb2.0p25.f${previsao}.nc ${DIRETORIO_TMP}/tmp02.gfs.t00z.pgrb2.0p25.f${previsao}.nc"
    echo ${cmd} >> lista.txt

    # A partir da previsão 120, o intervalo é de 3 em 3 horas.
    if [ ${Primeira_Hora_Previsao} -ge 120 ] ; then Intervalo_Previsao=3 ; fi

    let Primeira_Hora_Previsao=${Primeira_Hora_Previsao}+${Intervalo_Previsao}
done

parallel --jobs 6 < lista.txt

rm -f lista.txt