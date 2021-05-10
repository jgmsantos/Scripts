#!/bin/bash

# Script que realiza o download dos dados diários do MERGE/CPTEC no formato grib2 e converte para o NetCDF.

# Colocar o script em um diretório qualquer e alterar a data de interesse.

# Dados disponíveis desde: 02/06/2000 - atual.
# Resolução espacial: 0.1° x 0.1°.
# Tipo de dado: Float 32 bits.
# Domínio espacial: Longitude: -120.05 a -20.05 e Latitude: -60.05 a +32.25.

# Requisitos: 

# 1) wgrib2 instalado (https://guilherme.readthedocs.io/en/latest/pages/tutoriais/wgrib2.html)
# 2) cdo instalado (https://guilherme.readthedocs.io/en/latest/pages/tutoriais/cdo.html)
# 3) parallel instalado: sudo apt install parallel
# 3.1) O parallel é excelente para baixar vários dias de uma só vez, isso reduz o tempo gasto para baixar os dados.
# 3.2) https://guilherme.readthedocs.io/en/latest/pages/tutoriais/variados.html#utilizar-o-parallel-no-linux

# Autor: Guilherme Martins - 10/05/2021 - 13h24.
# jgmsantos@gmail.com
# https://guilherme.readthedocs.io/en/latest/index.html
# https://github.com/jgmsantos

data_inicial="20200101"
data_final="20201231"

rm -f lista??.{txt,log}

DIR_OUTPUT="./tmp"  # Diretório onde ficarão os dados grib2 e NetCDF.

if [ ! -e tmp ] ; then mkdir tmp ; fi  # Cria o diretório "tmp", caso ele não exista.

while [ ${data_inicial} -le ${data_final} ]
do

    echo ${data_inicial}

    ano=${data_inicial:0:4}
    mes=${data_inicial:4:2}
    dia=${data_inicial:6:2}

    echo wget -P $DIR_OUTPUT http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY/$ano/$mes/MERGE_CPTEC_$data_inicial.grib2 >> lista01.txt

    echo wgrib2 $DIR_OUTPUT/MERGE_CPTEC_$data_inicial.grib2 -netcdf $DIR_OUTPUT/tmp01.MERGE_CPTEC_$data_inicial.nc >> lista02.txt

    echo cdo -s -chname,PREC_surface,prec -selname,PREC_surface $DIR_OUTPUT/tmp01.MERGE_CPTEC_$data_inicial.nc $DIR_OUTPUT/tmp02.MERGE_CPTEC_$data_inicial.nc >> lista03.txt

    data_inicial=`date -u +"%Y%m%d" -d "${data_inicial} 1 day "`
done

for lista in lista{01..03}
do
    echo $lista
    nohup parallel -j 120 < $lista.txt > $lista.log
done

# Junta todos os arquivos diários em um arquivão.
cdo -s -O mergetime ./tmp/tmp02.MERGE_CPTEC_????????.nc ./tmp/MERGE_CPTEC.nc

# Remove arquivos desnecessários.
rm -f ./tmp/*.grib2 ./tmp/tmp??.*.nc