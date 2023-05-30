#!/bin/bash

# Script que converte o arquivo no formato Grib2 para o formato NetCDF.
# Guilherm Martins - jgmsantos@gmail.com - 28/03/2023.

# Como executar o script?
# Ir para o diretório "scripts" e digitar no terminal "bash extrai.sh" 

DIRETORIO_INPUT="../input" # Onde estão armazenados os dados no formato Grib2.
DIRETORIO_OUTPUT="../output"  # Onde serão gerados os arquivos no formato NetCDF.

# Ver o nome das variáveis do arquivo.
# wgrib2 -s <nome_arquivo.grib2>
# Exemplo: 
# wgrib2 -s gfs.0p25.2018042200.f006.grib2
# Exemplo: Quero a varável u e v, o nome delas serão: UGRD e VGRD, respectivamente.

# Nome das variáveis de interesse:
Lista_Variaveis="TMP|VGRD|UGRD|HGT"
# Lista dos níveis verticais de interesse.
Lista_Niveis="200|250|300|350|400|450|500|550|600|650|700|750|800|850|900|925|950|975|1000"
# Conta com base na Lista_Niveis quantos níveis verticais serão utilizados.
Quantidade_Niveis_Verticais=$(echo $Lista_Niveis | sed 's/|/\n/g' | wc -l)

i=1 # Inicia o contador.
for Nome_Arquivo in $(ls ${DIRETORIO_INPUT}/*.grib2) # Faz um "ls" dentro do diretório dos arquivos Grib2.
do
     # Nome do arquivo Grib2.
     Nome_Arquivo_Grib2=${Nome_Arquivo}
     # Nome do arquivo NetCDF.
     Nome_Arquivo_NetCDF=$(basename ${Nome_Arquivo_Grib2} .grib2).nc
     
     echo "-----------------------------------------------------------------"
     echo "Processando arquivo: $i: ${Nome_Arquivo_Grib2}"
     echo "-----------------------------------------------------------------"
     
     # Extrai as variáveis de interesse nos níveis verticais selecionados.
     wgrib2 ${DIRETORIO_INPUT}/${Nome_Arquivo_Grib2} -nc_nlev ${Quantidade_Niveis_Verticais} -match "(${Lista_Variaveis}):(${Lista_Niveis}) mb:" -netcdf ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF}
     
     # Checa se o arquivo foi criado. Caso não tenha sido criado, para a execução do script. 
     if [ ! -e ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF} ]
     then
        echo "----------------------------------------------------------------------------"
        echo "O arquivo --> ${DIRETORIO_OUTPUT}/${Nome_Arquivo_NetCDF} <-- não foi criado."
        echo "----------------------------------------------------------------------------"
        exit 0
     fi
     i=$((i+1))
done
