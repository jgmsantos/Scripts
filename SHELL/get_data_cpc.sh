#!/bin/bash

LINK="https://downloads.psl.noaa.gov/Datasets/cpc_global_precip/" # Link dos dados.
DIR_INPUT="/mnt/d/gui/base_de_dados/CPC/input" # Diretório de donwload do arquivo.
DIR_OUTPUT="/mnt/d/gui/base_de_dados/CPC/output" # Diretório onde ficarão os arquivos processados.
DIR_TMP="/mnt/d/gui/base_de_dados/CPC/tmp"
txt="${DIR_TMP}/cmd.sh" # Nome do script que será utilizado para processar tudo.

# Abaixo, basta alterar o ano de interesse. Os arquivos são separados por ano.
for ano in {2022..2022}
do
    # Realiza o download do dado via wget.
    cmd="wget -c -P $DIR_INPUT $LINK/precip.${ano}.nc"
    # Recorta o dado na área de interesse.
    cmd="${cmd} && cdo -s sellonlatbox,-75,-33,-35,7 $DIR_INPUT/precip.${ano}.nc $DIR_TMP/precip.${ano}.nc"
    # Como o arquivo é um por ano, eu separo por meses. Ficara assim: cpc.202201.nc, cpc.202202.nc, e por aí vai.
    # Cada arquivo contém todos os dias dentro dele. Exemplo: cpc.202201.nc => contém os 31 dias, desde 01 a 31 de jan/2022.
    cmd="${cmd} && cdo -s splityearmon $DIR_TMP/precip.${ano}.nc $DIR_OUTPUT/cpc."
    echo ${cmd} >> ${txt} # Os comando acima são salvos no arquivo.
done

# Executa em paralelo para o caso de baixar vários anos. Usei 4 porque meu computador tem 8 núcleos. Basta digitar nproc no seu terminal 
# para saber quantos núcleos existem. Uma boa prática é sempre usar a metade dos núcleos. Dependendo do processamento, o PC pode travar 
# por causo do uso excessivo de memória.
# Tem que instalar o parallel:
# sudo apt update
# sudo apt install parallel
parallel --jobs 4 < ${txt}

rm ${txt} # Remove o arquivo (cmd.sh) após o seu uso.