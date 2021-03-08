#!/bin/bash 

datainicial=`date +%s` # Calculo inicial para saber o tempo de máquina utilizado. NÃO DELETAR ESSA LINHA!

#################################################################################
# get_MERGE.sh  - Script que realiza o download dos dados de precipitação (kg/m^2 = mm/dia) do MERGE/CPTEC.
# A resolução do dado é de 0.1° ou ~10km.
# 
# Requisito: CDO instalado.
# 
# Autor  : Guilherme Martins - <queimadas@inpe.br>
# 
# Este programa recebe como parâmetro a data (AAAAMMDD) e realiza 
# o download do arquivo de precipitação.
# 
# Para executar: ./get_MERGE.sh AAAAMMDD
# 
# Onde: AAAA = ano, MM = mês e DD = dia.
# 
# Exemplo: ./get_MERGE.sh 20200101
# 
# Antes de executar o script, criar os diretórios com o comando abaixo:
# 1) Digitar: mkdir -p precipitacao/script
#  - Com o comando acima será criado o diretório "precipitacao" e dentro dele, o diretório "script"
#  - Colocar este script (get_MERGE.sh) dentro do diretório "script".
# 2) Digitar: mkdir -p precipitacao/output/MERGE
#  - Com o comando acima será criado o diretório "output" e "MERGE".
# 
# Link para os dados: http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY
#################################################################################

# Para executar de forma automática no crontab.
data_atual=`date +"%Y%m%d" -d '1 day ago'` 

dia=${data_atual:6:2}
mes=${data_atual:4:2}
ano=${data_atual:0:4}

echo "=============================="
echo "Processando data: ${data_atual}"
echo "=============================="

DIR_OUTPUT="../output/MERGE"
DIR_TMP="../tmp"

# Download do arquivo no formato ".grib2"
wget -c -P "${DIR_TMP}" http://ftp.cptec.inpe.br/modelos/tempo/MERGE/GPM/DAILY/${ano}/${mes}/MERGE_CPTEC_${data_atual}.grib2

# Checa se o arquivo foi gerado ou não.
if [ ! -e "${DIR_TMP}/MERGE_CPTEC_${data_atual}.grib2" ]
then
   echo "O arquivo não foi gerado: ${DIR_TMP}/MERGE_CPTEC_${data_atual}.grib2"
   exit 0
fi

# Converte o "grib2" para o formato NetCDF comprimido para ocupar menos espaço em disco, seleciona apenas a variável "prec" 
# porque há duas variáveis no arquivo, isto é, "prec" e "prmsl".
cdo -s -f nc4 -z zip9 -copy \
                         -setmissval,-999 \
                         -selname,prec \
                         -settaxis,$ano-$mes-$dia,00:00:00,1day \
                         ${DIR_TMP}/MERGE_CPTEC_${data_atual}.grib2 \
                         ${DIR_OUTPUT}/PREC.MERGE.CPTEC.${data_atual}00.nc

rm -f ${DIR_TMP}/MERGE_CPTEC_${data_atual}.grib2

#######################################################################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "