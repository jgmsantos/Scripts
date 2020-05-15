#!/bin/bash

# Dica obtida do link: https://www.monolitonimbus.com.br/scripts-com-wget/

# Script que realiza o download dos dados de umidade do solo do GRACE/NASA.
# Disponibilidade a cada 7 dias.
# Link: https://nasagrace.unl.edu/
# Disponibilidade dos dados: a cada 7 dias, desde 03/02/2003-atual, sendo atualizado a cada 3 dias, em média. A atualização não é em tempo real.
# FTP no formato tif: https://nasagrace.unl.edu/globaldata/
# FTP no formato NetCDF: https://nasagrace.unl.edu/globaldata/NASApublication/data/
# FTP no formato png: https://nasagrace.unl.edu/globaldata/Web/
# Autor: Guilherme Martins - 24/04/2020.

DIR_INPUT_TIF="../input/tif"
DIR_INPUT_NETCDF="../input/netcdf"
DIR_TMP="../tmp"

data_inicial="20200504"

data_final="20200504"

base_url="https://nasagrace.unl.edu/globaldata"

while [ ${data_inicial} -le ${data_final} ]; do

	DIA=${data_inicial:6:2}
	MES=${data_inicial:4:2}
	ANO=${data_inicial:0:4}

	# Checo apenas um dos três arquivos e o status do arquivo para saber se ele existe (0) ou não (8).
	wget -q --spider --quiet ${base_url}/${data_inicial}/gws_perc_025deg_GL_${data_inicial}.tif

	status=`echo $?` # Esse valor pode ser 0 (existe) ou 8 (não existe).
	
	echo "Status de" ${base_url}/${data_inicial}/gws_perc_025deg_GL_${data_inicial}.tif ":" $status

	# Se tiver o arquivo, realiza o seu download.
	if [ "$status" -eq "0" ]; then
		for nome_var in gws rtzsm sfsm 
		do
			# Realiza o download via wget.
			wget -c -P ${DIR_INPUT_TIF} ${base_url}/${data_inicial}/${nome_var}_perc_025deg_GL_${data_inicial}.tif
			# Converte de tif para netcdf.
			gdal_translate -of netcdf -co "FORMAT=NC" ${DIR_INPUT_TIF}/${nome_var}_perc_025deg_GL_${data_inicial}.tif ${DIR_TMP}/${nome_var}_perc_025deg_GL_${data_inicial}.nc
			# Conserta a data e renomeia o nome da variável do arquivo.
			cdo -s -r -settaxis,${ANO}-${MES}-${DIA},00:00:00,7day -chname,Band1,${nome_var} ${DIR_TMP}/${nome_var}_perc_025deg_GL_${data_inicial}.nc ${DIR_INPUT_NETCDF}/${nome_var}_perc_025deg_GL_${data_inicial}.nc
			# Remove arquivo desnecessário.
			rm -f ${DIR_INPUT_TIF}/${nome_var}_perc_025deg_GL_${data_inicial}.tif ${DIR_TMP}/${nome_var}_perc_025deg_GL_${data_inicial}.nc
		done

	else
		echo "========================================================================================"
		echo "O arquivo ${base_url}/${data_inicial}/gws_perc_025deg_GL_${data_inicial}.tif não existe!"
		echo "========================================================================================"
		echo "${data_inicial}" >> Lista_Arquivos_Faltantes.txt
		#break
	fi

	data_inicial=`date -u +"%Y%m%d" -d "${data_inicial} 7 day "`
done
