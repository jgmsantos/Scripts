#!/bin/bash -x

# Script que calcula a Umidade Relativa (%) a partir da Temperatura (T) e Temperatura do Ponto de Orvalho (Td).
# Guilherme Martins - jgmsantos@gmail.com. 28/02/2022.
# Os arquivos possuem o nome: ERA5.d2m.YYYY.nc e ERA5.t2m.YYYY.nc, onde YYYY representa o ano com 4 digítos.

# Referência: https://drive.google.com/file/d/15UT8bdlLlwxwazTvRk2IK28oys89Z4nl/view
# Página: 78, item: 7.18 Calculando a Umidade Relativa.

DIR_INPUT="../processado/diario"  # Diretório dos arquivos de entrada.
DIR_TMP="../tmp"  # Diretório para processamento temporário.
NOME_VARIAVEL_TD="d2m"  # Nome da variável do arquivo referente a Temperatura do Ponto de Orvalho a 2 metros.
NOME_VARIAVEL_TT="t2m"  # Nome da variável do arquivo referente a Temperatura a 2 metros.

for ano in {1980..2021}
do
     echo $ano
     cdo -s expr,'e = 6.1078 * 10^( (7.5*'$NOME_VARIAVEL_TD') / (237.3+'$NOME_VARIAVEL_TD') )' $DIR_INPUT/ERA5.d2m.$ano.nc $DIR_TMP/e.nc
     cdo -s expr,'es = 6.1078 * 10^( (7.5*'$NOME_VARIAVEL_TT') / (237.3+'$NOME_VARIAVEL_TT') )' $DIR_INPUT/ERA5.t2m.$ano.nc $DIR_TMP/es.nc
     cdo -s -O merge $DIR_TMP/e.nc $DIR_TMP/es.nc $DIR_TMP/e.es.nc
     cdo -s -setattribute,rh2m@units="%" -setattribute,rh2m@long_name="Umidade Relativa a 2 metros" -expr,'rh2m=(e/es)*100.0' $DIR_TMP/e.es.nc $DIR_INPUT/ERA5.rh2m.${ano}.nc
     rm -f ../tmp/e.nc ../tmp/es.nc ../tmp/e.es.nc  # Remove arquivos desnecessários.
done
