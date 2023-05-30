#!/bin/bash

# Script que baixa as previsões do modelo GFS.

# Criar um diretório chamado "gfs" com o comando abaixo:
# mkdir gfs
# Criar os subdiretórios dentro do diretório "gfs":
# mkdir output scripts tmp

# Mover o arquivo "download_gfs.sh" para o diretório "script".

# Para executar, basta digitar o comando abaixo dentro do diretório script: 
# bash download_gfs.sh

# Instalar o CDO por meio do comando abaixo no seu ambiente virtual de trabalho:
# O CDO será utilizado para realizar alguns processamentos.
# conda install -c conda-forge cdo

# Link de consulta do GFS para baixar as simulações:
# https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?dir=%2Fgfs.20230321%2F00%2Fatmos
# Basta alterar a data.

# ------------------------------------------------------------
# Autor: Guilherme Martins - jgmsantos@gmail.com - 22/03/2023.
# https://guilherme.readthedocs.io/en/latest/index.html
# ------------------------------------------------------------

PREV=6    # Horário que começa a previsão de interesse.
PRAZO=18  # Quantidade de previsões em horas desejadas. O máximo é 384 horas (16 dias).
dPREV=6   # Intervalo temporal em horas entre cada previsão desejada.

RESOLUCAO="0p25" # 0p25 | 0p50 | 1p00 -> Resolução espacial do modelo.
HORA="00" # Hora da simulação.

#DATA=$(date +"%Y%m%d") # Executar o script de forma automática pela data corrente.
DATA="20230321" # Executar na mão pela data de interesse.

# Área de interesse:
LonW="-90"
LonE="-30"
LatS="-60"
LatN="10"

DIRETORIO_OUTPUT="../output/${DATA}${HORA}"
DIRETORIO_TMP="../tmp"

# Cria o diretório caso ele não exista.
if [ ! -e ${DIRETORIO_OUTPUT} ] ; then mkdir -p ${DIRETORIO_OUTPUT} ; fi

# Loop nas horas de previsão.
while [[ ${PREV} -le ${PRAZO} ]]
do

    # Nome no formato com 3 dígitos na previsão (006)-> Exemplo: 2023032100_006.grb, 2023032100_012.grb, 
	fcst=`echo ${PREV} | awk '{printf("%.3d",$1)}'` 

    echo "Baixando dia: $DATA - Previsão: ${fcst}"

    # Nome do arquivo Grib2.
	FILE_OUT_GRIB="${DATA}${HORA}f${fcst}.grb2"

    # Nome do arquivo NetCDF.
	FILE_OUT_NC="${DATA}${HORA}f${fcst}.nc"

    # Download de cada previsão. Link utilizado para baixar as previsões.
	curl -s "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t00z.pgrb2.0p25.f${fcst}&lev_1000_mb=on&lev_100_mb=on&lev_150_mb=on&lev_200_mb=on&lev_300_mb=on&lev_350_mb=on&lev_400_mb=on&lev_450_mb=on&lev_500_mb=on&lev_550_mb=on&lev_600_mb=on&lev_650_mb=on&lev_700_mb=on&lev_750_mb=on&lev_800_mb=on&lev_850_mb=on&lev_900_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&var_UGRD=on&var_VGRD=on&var_VVEL=on&subregion=&leftlon=${LonW}&rightlon=${LonE}&toplat=${LatN}&bottomlat=${LatS}&dir=%2Fgfs.${DATA}%2F00%2Fatmos" -o ${DIRETORIO_TMP}/${FILE_OUT_GRIB}

    # Converte de Grib2 para NetCDF.
    cdo -s --no_history -f nc -copy ${DIRETORIO_TMP}/${FILE_OUT_GRIB} ${DIRETORIO_TMP}/${FILE_OUT_NC}
	
	let PREV=${PREV}+${dPREV}
done

cdo -s --no_history -O mergetime ${DIRETORIO_TMP}/${DATA}00f???.nc ${DIRETORIO_TMP}/GFS_${DATA}00.nc

# --------------------------------------------------------------------------------------------------------
# A informação abaixo foi obtida por meio do comando do CDO:
# cdo zaxisdes GFS_2023032100.nc
# Onde: GFS_2023032100.nc é o arquivo que está no diretório "tmp".

# Trecho que conserta as informações da coordenada vertical que está em Pa. A ideia é alterar de Pa para hPa.
cat << EOF > ${DIRETORIO_TMP}/grade_z.txt
#
# zaxisID 1
#
zaxistype = pressure
size      = 20
name      = level
longname  = "Pressure"
units     = "hPa"
levels    = 100 150 200 300 350 400 450 500 550 600 650 700 
            750 800 850 900 925 950 975 1000
axis = "Z"

EOF

# Conserta a coordenada vertical do arquivo.
cdo -s --no_history -setzaxis,${DIRETORIO_TMP}/grade_z.txt ${DIRETORIO_TMP}/GFS_${DATA}00.nc ${DIRETORIO_OUTPUT}/GFS_${DATA}00.nc

# Remove todos os arquivos do diretório "tmp".
rm -f ${DIRETORIO_TMP}/*