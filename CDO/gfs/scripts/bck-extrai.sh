#!/bin/bash

DIRETORIO_INPUT="../input"
DIRETORIO_TMP="../tmp"
DIRETORIO_OUTPUT="../output"

# Ver o nome das variáveis do arquivo.
# wgrib2 -s <nome_arquivo.grib2>
# Exemplo: 
# wgrib2 -s gfs.0p25.2018042200.f006.grib2
# Exemplo: Quero a varável u e v, o nome delas serão: UGRD e VGRD, respectivamente.

# Nome das variáveis de interesse:
Lista_Variaveis="TMP|VGRD|UGRD"
# Lista dos níveis verticais de interesse.
Lista_Niveis="200|250|300|350|400|450|500|550|600|650|700|750|800|850|900|925|950|975|1000"
# Conta com base na Lista_Niveis quantos níveis verticais serão utilizados.
Quantidade_Niveis_Verticais=$(echo $Lista_Niveis | sed 's/|/\n/g' | wc -l)

i=1
for Nome_Arquivo in $(ls ${DIRETORIO_INPUT}/*.grib2)
do

     # Nome do arquivo Grib2.
     Nome_Arquivo_Grib2=${Nome_Arquivo}
     # Nome do arquivo NetCDF.
     Nome_Arquivo_NetCDF=$(basename ${Nome_Arquivo_Grib2} .grib2).nc
     
     echo "------------------------------------------------------"
     echo "Processando arquivo: $i ${Nome_Arquivo_Grib2}"
     echo "-------------------------------------------------------"
     
     # Extrai as variáveis de interesse nos níveis verticais de interesse.

     # Opção 1: Extrai TODOS os níveis verticais do arquivo:
     # -nc_nlev 31 -> quer dizer que o arquivo original tem 31 níveis verticais.
     #wgrib2 ${DIRETORIO_INPUT}/${Nome_Arquivo_Grib2} -nc_nlev 31 -match "(${Lista_Variaveis}):[0-9]* mb:" -netcdf ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF}
     
     # Opção 2: Seleciona os níveis verticais de interesse:
     #wgrib2 ${DIRETORIO_INPUT}/${Nome_Arquivo_Grib2} -nc_nlev ${Quantidade_Niveis_Verticais} -match "(${Lista_Variaveis}):(${Lista_Niveis}) mb:" -netcdf ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF}
     
     if [ ! -e ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF} ]
     then
        echo "----------------------------------------------------------------------------"
        echo "O arquivo --> ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF} <-- não foi criado."
        echo "----------------------------------------------------------------------------"
     fi
     i=$((i+1))
done