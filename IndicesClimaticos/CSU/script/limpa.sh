#!/bin/bash

DIR_INPUT="/mnt/d/gui/base_de_dados/ERA5/processado/diario"
DIR_TMP="../tmp"
DIR_PROCESSADO="../processado"
ShapefileBrasil="../../../shapefiles/netcdf/so.Brasil.1km.nc"

LIMIAR_TEMPERATURA_CELSIUS="30"  # Usado no cálculo do índice. Este valor é dado em CELSIUS.

# Cria máscara somente sobre o Brasil.
cdo -s remapbil,$DIR_INPUT/ERA5.t2m.2021.nc \
                 $ShapefileBrasil \
                 $DIR_TMP/mask.nc

for ano in {1981..2021}
do
       echo $ano
       # Separa por meses (01, 02, ..., 12).
       cdo -s splitmon $DIR_INPUT/ERA5.t2m.${ano}.nc $DIR_TMP/mes.

       for mes in {01..12}
       do
             # Aplica o índice, seleciona a variável de interesse e altera o nome para "csu".
             # Observação: A temperatura do arquivo utilizada no índice está em KELVIN. Isso mesmo!!!
             cdo -s -setname,csu \
                    -selname,consecutive_summer_days_index_per_time_period \
                    -eca_csu,$LIMIAR_TEMPERATURA_CELSIUS \
                    $DIR_TMP/mes.${mes}.nc \
                    $DIR_TMP/csu.${mes}.nc
       done
       
       # Junta os arquivos por meses.
       cdo -s -O mergetime $DIR_TMP/csu.??.nc $DIR_TMP/csu.$ano.nc

       # Aplica a máscara do Brasil sobre os dados.
       # O índice gera valores 0 (quando a condição NÃO é satisfeito) e 1, no caso contrário.
       # O trecho "-setmissval,-999 -setmissval,0" define o valor 0 como UNDEF, e posteriormente, 
       # altera-se o valore UNDEF = 0 para -999 para padronizar os valores ausentes.
       cdo -s -setmissval,-999 \
              -setmissval,0 \
              -sellonlatbox,-75,-33,-35,7 \
              -ifthen \
              $DIR_TMP/mask.nc \
              $DIR_TMP/csu.$ano.nc \
              $DIR_PROCESSADO/csu.$ano.nc

       rm -f $DIR_TMP/csu.{??,????}.nc $DIR_TMP/mes.??.nc  # Remove arquivos desnecessários.
done

rm -f $DIR_TMP/mask.nc # Remove arquivos desnecessários.

# Calcula a climatologia do CSU (1981-2010).
cdo -s -setmissval,-999 \
       -setmissval,0 -nint \
       -ymonmean \
       -mergetime \
       $DIR_PROCESSADO/csu.{1981..2010}.nc \
       $DIR_PROCESSADO/csu.climatologia.1981.2010.nc

# Cálculo da anomalia (Anomalia = Valor - Climatologia).
# O "nint" arredonda os valores caso sejam decimais. Não faz sentido número de dias quebrados, 
# mas sim, inteiros.
for ano in {1981..2021}
do
       echo $ano
       cdo -s -nint \
              -sub \
              $DIR_PROCESSADO/csu.$ano.nc \
              $DIR_PROCESSADO/csu.climatologia.1981.2010.nc \
              $DIR_PROCESSADO/csu.anomalia.$ano.nc
done