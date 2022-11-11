#!/bin/bash

# Dica obtida em: https://code.mpimet.mpg.de/boards/2/topics/10494

# A partir do arquivo ".csv" (360 linhas [latitude] x 720 colunas [longitude]) gera-se o NetCDF espacial 
# na resolução espacial de 0.50º ou 50km.
# Guilherme Martins - jgmsantos@gmail.com - 06/01/2021.

DIR_INPUT="../input/csv"      # Diretório do arquivo de entrada no formato ".csv".
DIR_OUTPUT="../output/netcdf" # Diretório do arquivo de saída no formato NetCDF.
DIR_TMP="../tmp"              # Diretório temporário.

# Definição do domínio espacial (grade do dado).
cat << EOF > $DIR_TMP/gridfile.txt
gridtype = lonlat
gridsize = 259200
xname = lon
xlongname = longitude
xunits = degrees_east
yname = lat
ylongname = latitude
yunits = degrees_north
xsize = 720
ysize = 360
xfirst = -179.75
xinc = 0.5
yfirst = -89.75
yinc = -0.5
EOF

# Definição de atributos para melhor entendimento do dado.
cat << EOF > $DIR_TMP/atributos.txt
var1@long_name='Temperatura Mensal'
var1@units='Graus Celsius'
title='Temperatura Mensal'
source='CRU'
EOF

# Gera o NetCDF (input) e define a data de interesse (settaxis).
# No operador "settaxis" não esquecer de alterar a data conforme a 
# sua data de interesse, aqui defini o ano=1901, mês=01 e dia=01. O valor 
# UNDEF "9e+20" veio do arquivo csv, mas eu alterei para "-999" usando o "setmissval".
cdo -s -f nc -setmissval,-999 \
             -setmissval,9e+20 \
             -settaxis,1901-01-01,00:00:00,1mon \
             -setcalendar,standard \
             -input,$DIR_TMP/gridfile.txt \
             $DIR_TMP/tmp.nc < $DIR_INPUT/ws_2009_1.csv

# Tive que inserir uma nova linha de comando porque o operador "setattribute" 
# não funciona com o operador "input". Alterei o nome da variável de var1 para temp.
cdo -s -chname,var1,temp \
       -setattribute,FILE=$DIR_TMP/atributos.txt \
       $DIR_TMP/tmp.nc $DIR_OUTPUT/ws_2009_1.nc

# Remove arquivos desnecessários
rm -f $DIR_TMP/tmp.nc \
      $DIR_TMP/gridfile.txt \
      $DIR_TMP/atributos.txt
