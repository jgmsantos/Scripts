#!/bin/bash

#########################################
# Obtenção do tempo de máquina utilizado. 
# NÃO DELETAR ESSA LINHA!
datainicial=`date +%s` 
#########################################

# Esse script calcula o índice eca_cdd (https://guilherme.readthedocs.io/en/latest/pages/tutoriais/cdo.html#indices-climaticos-utilizando-o-cdo)
# a partir dos dados diários do IMERG/NASA (10 km).
# Período: 20010101-20200709.
# O ca_cdd é obtido sobre o Brasil e depois é separado pelos seis biomas brasileiros, e por fim, gera-se o arquivo texto para cada bioma.
# Criar os diretórios: figuras, input, processado, script, shapefile e tmp.
# Colocar esse script dentro do diretório "script"
# Os arquivos NetCDF dos biomas estão em: https://github.com/jgmsantos/Scripts/tree/master/NetCDF/biomas
# Tempo gasto: 00:03:35

DIR_INPUT="../input"
DIR_TMP="../tmp"
DIR_OUTPUT="../processado"
ARQUIVO_MODELO="../input/PREC.200101.nc"
DIR_SHAPEFILE="../shapefile"
R="1"  # Limiar de precipitação (mm/dia).
N="4"  # Quantas vezes o período consecutivo se repete no intervalo maior que 4 dias.
ANOI="2001"
ANOF="2020"

for ano in $(seq ${ANOI} ${ANOF})
do
    if [ ${ano} = ${ANOF} ]  ; then mesc="01 02 03 04 05 06 07" ; fi
    if [ ${ano} != ${ANOF} ] ; then mesc="01 02 03 04 05 06 07 08 09 10 11 12" ; fi
    for mes in ${mesc}
    do
	echo ${ano}${mes}
	# Calcula o índice eca_cdd.
        cdo -s eca_cdd,${R},${N} ${DIR_INPUT}/PREC.${ano}${mes}.nc ${DIR_TMP}/Brasil.eca_cdd.${ano}${mes}.nc
	done
    for bioma in amazonia caatinga cerrado mata_atlantica pampa pantanal
    do
	echo ${ano} - ${bioma}
	# Junta todos os meses (jan, ..., dez) para ficar separado por ano. 
	cdo -s -O mergetime ${DIR_TMP}/Brasil.eca_cdd.${ano}??.nc ${DIR_OUTPUT}/Brasil.eca_cdd.${ano}.nc
	# Interpola os biomas para a mesma resolução dos arquivos do eca_cdd.
	cdo -s -remapbil,${ARQUIVO_MODELO} ${DIR_SHAPEFILE}/${bioma}.nc ${DIR_TMP}/mask.nc
	# Aplica a máscara para cada bioma.
	cdo -s -O ifnotthen ${DIR_TMP}/mask.nc ${DIR_OUTPUT}/Brasil.eca_cdd.${ano}.nc ${DIR_OUTPUT}/${bioma}.eca_cdd.${ano}.nc
	# Como são duas variáveis, elas são separadas.
	cdo -s splitvar ${DIR_OUTPUT}/${bioma}.eca_cdd.${ano}.nc ${DIR_TMP}/${bioma}.eca_cdd.${ano}.
	# Salva a variável: consecutive_dry_days_index_per_time_period.
	cdo -s output -nint -fldmean ${DIR_TMP}/${bioma}.eca_cdd.${ano}.consecutive_dry_days_index_per_time_period.nc | xargs > ${DIR_TMP}/${bioma}.eca_cdd.${ano}.consecutive_dry_days_index_per_time_period.txt
	# Salva a variável: number_of_cdd_periods_with_more_than_${N}days_per_time_period.
	cdo -s output -nint -fldmean ${DIR_TMP}/${bioma}.eca_cdd.${ano}.number_of_cdd_periods_with_more_than_${N}days_per_time_period.nc | xargs > ${DIR_TMP}/${bioma}.eca_cdd.${ano}.number_of_cdd_periods_with_more_than_${N}days_per_time_period.txt
    done
done

rm -f ${DIR_OUTPUT}/*.eca_cdd.?.txt # Remove porque é feito append nos arquivos.

for bioma in amazonia caatinga cerrado mata_atlantica pampa pantanal
do
    for ano in $(seq 2001 2020)    
    do
	# Salva no formato texto as duas saídas do índice, converte de coluna para linha e adiciona ";" como delimitador.
	cat ${DIR_TMP}/${bioma}.eca_cdd.${ano}.consecutive_dry_days_index_per_time_period.txt | xargs | tr -s ' ' '; ' >> ${DIR_OUTPUT}/${bioma}.eca_cdd.R.txt
	cat ${DIR_TMP}/${bioma}.eca_cdd.${ano}.number_of_cdd_periods_with_more_than_${N}days_per_time_period.txt | xargs | tr -s ' ' '; ' >> ${DIR_OUTPUT}/${bioma}.eca_cdd.N.txt
    done
done

rm -f ${DIR_TMP}/*.nc ${DIR_TMP}/*.txt

#####################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
#####################################
