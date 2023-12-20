#!/bin/bash -x

# Script que calcula a Umidade Relativa (%) a partir da Temperatura (T) e Temperatura do Ponto de Orvalho (Td).
# Guilherme Martins - jgmsantos@gmail.com. 28/02/2022.
# Os arquivos possuem o nome: ERA5.d2m.YYYY.nc e ERA5.t2m.YYYY.nc, onde YYYY representa o ano com 4 dígitos.

# Referência: https://drive.google.com/file/d/15UT8bdlLlwxwazTvRk2IK28oys89Z4nl/view
# Página: 78, item: 7.18 Calculando a Umidade Relativa.

DIR_INPUT="../input/T_Td_2m_horario"
DIR_TMP="../tmp"
DIR_OUTPUT="../output/UR"

rm -f ${DIR_TMP}/script.sh

for ano in {2003..2022}
do
     echo "Processando: ${ano}"
     cmd="cdo -s --no_history -b F32 -subc,273.15 -daymean ${DIR_INPUT}/ERA5_Superficie_T_Td_horario_2m_${ano}.nc ${DIR_TMP}/tmp01_${ano}.nc"
     cmd="${cmd} && cdo -s --no_history expr,'e=6.1078*10^((7.5*d2m)/(237.3+d2m)) ; es=6.1078*10^((7.5*t2m)/(237.3+t2m))' ${DIR_TMP}/tmp01_${ano}.nc ${DIR_TMP}/tmp02_${ano}.nc"
     cmd="${cmd} && cdo -s --no_history -setmissval,-999 -setattribute,rh@units='%' -setattribute,rh@long_name='Umidade Relativa a 2 metros' -expr,'rh=(e/es)*100' ${DIR_TMP}/tmp02_${ano}.nc ${DIR_OUTPUT}/RH_Diario_${ano}.nc"
     echo ${cmd} >> ${DIR_TMP}/script.sh
done

# Executa em paralelo em blocos de 4 arquivos.
parallel -j 4 < ${DIR_TMP}/script.sh

# Junta todos os arquivos em um único arquivão com a umidade relativa diária.
cdo -s -O --no_history -mergetime ${DIR_OUTPUT}/RH_Diario_????.nc ${DIR_OUTPUT}/RH_Diaria.nc

# Junta todos os arquivos em um único arquivão e faz a média mensal.
cdo -s -O --no_history -monmean ${DIR_OUTPUT}/RH_Diaria.nc ${DIR_OUTPUT}/RH_Mensal.nc

# Limpa o diretório.
rm -f ${DIR_TMP}/*