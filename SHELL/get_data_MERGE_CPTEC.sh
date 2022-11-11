#!/bin/bash

# Script que converte os dados diários no formato grib2 do produto de precipitação 
# do MERGE/CPTEC para o formato NetCDF.
# Os dados no formato grib2 estão em: http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY
# Autor: Guilherme Martins - jgmsantos@gmail.com.
# Data: 28/01/2022.

DIR_TMP="../tmp"  # Diretório temporário para processamento.
DIR_OUTPUT="../diario"  # Diretório dos dados de saída no formato netcdf.

data_inicial="20220501" # Data inicial no formato YYYYMMDD.
data_final="20220531" # Data final no formato YYYYMMDD.

# Endereço dos dados.
URL="http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY"

rm -f lista??.{txt,log}

# Checa se os diretórios existem, e no caso negativo, cria-os.
if [ ! -d $DIR_TMP -a ! -d $DIR_OUTPUT  ]
then
   echo "================================================================"
   echo "Os diretório $DIR_TMP e $DIR_OUTPUT não existem e serão criados."
   echo "================================================================"   
   mkdir -p $DIR_OUTPUT $DIR_TMP
fi

while [ ${data_inicial} -le ${data_final} ]
do

      echo "================================="
      echo "Processando o dia ${data_inicial}"
      echo "================================="

      ano=${data_inicial:0:4}  # Armazena a string ano.
      mes=${data_inicial:4:2}  # Armazena a string mes.
      dia=${data_inicial:6:2}  # Armazena a string dia.
 
      # O wget baixa o arquivo (opção -P) para o diretório "tmp".
      echo "wget -P $DIR_TMP http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY/${ano}/${mes}/MERGE_CPTEC_${data_inicial}.grib2" >> lista01.txt
 
      # Converte de grib2 para NetCDF.
      echo "wgrib2 $DIR_TMP/MERGE_CPTEC_"$data_inicial".grib2 -netcdf $DIR_TMP/MERGE_CPTEC_"$data_inicial".nc" >> lista02.txt
 
      # Seleciona somente a variável de interesse e corrige alguns atributos.
      echo "cdo -s -f nc4 -z zip9 -copy -setunit,"mm/day" -setmissval,-999 -setname,prec -selname,PREC_surface -settaxis,$ano-$mes-$dia,00:00:00,1day -sellonlatbox,-75,-33,-34,7 $DIR_TMP/MERGE_CPTEC_"$data_inicial".nc $DIR_OUTPUT/MERGE_CPTEC_"$data_inicial".nc" >> lista03.txt
      
data_inicial=`date -u +"%Y%m%d" -d "${data_inicial} 1 day "`
done

nohup parallel -j 4 < lista01.txt > lista01.log
nohup parallel -j 4 < lista02.txt > lista02.log
nohup parallel -j 4 < lista03.txt > lista03.log

#rm -f $DIR_TMP/MERGE_CPTEC_*.{grib2,nc}  # Remove arquivos desnecessários.
