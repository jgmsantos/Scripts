#!/bin/bash

# Para pegar apenas a coluna com os valores de chuva.
# cat chuva_original.dat | awk '{print $3}' > chuva.txt

# Definição do domínio espacial (grade do dado).
cat << EOF > grid.txt
gridtype = lonlat
gridsize = 9009
xname = lon
xlongname = longitude
xunits = degrees_east
yname = lat
ylongname = latitude
yunits = degrees_north
xsize = 99
ysize = 91
xfirst = -82.0
xinc = 0.5
yfirst = -35.0
yinc = 0.5
EOF

# Definição de atributos para melhor entendimento do dado.
cat << EOF > atributos.txt
var1@long_name='Precipitação'
var1@units='mm/dia'
title='Precipitação'
source='MERGE'
EOF

cdo -s -f nc -setmissval,-999 -settaxis,2024-03-08,00:00:00,1day -input,grid.txt tmp.nc < chuva.txt

cdo -s -chname,var1,prec -setattribute,FILE=atributos.txt tmp.nc chuva_diaria.nc

rm tmp.nc atributos.txt grid.txt
