#/bin/bash 

#########################################
# Obtenção do tempo de máquina utilizado. 
# NÃO DELETAR ESSA LINHA!
datainicial=`date +%s` 
#########################################

# Objetivo: Script que extrai os valores de uma latitude/longitude dada uma lista de coordenadas.
# Autor: Guilherme Martins - 19/10/2020.

# Crie um diretório com um nome qualquer, dentro desse diretório devem ter outros 3 diretórios:
# input   => Contém os dados de entrada.
# output  => É o diretório onde ficaram as saídas dos dados processados.
# script  => O script "extrai.sh" e o arquivo "lat_lon.txt" devem ficar neste diretório.
#  Tempo gasto: 00:06:13 

# Para executar o programa, basta digitar no terminal do Linux dentro do diretório script:
# 1) chmod +x extrai.sh  => Torna o programa executável.
# 2) ./extrai.sh         => Executa o script.

input_latlon="lat_lon.txt" # Nome do arquivo de latitude e longitude. Esse arquivo (lat_lon.txt) TEM que ter apenas duas colunas e tem que ficar no diretório script.
                           # A PRIMEIRA coluna é a LONGITUDE e a 
				   # SEGUNDA coluna é a LATITUDE.

lista_arquivos="prec_anual.nc RH_anual.nc tmax_anual.nc u2_anual.nc"  # Lista de arquivos a serem processados. Aqui coloque o nome dos arquivos com a sua extensão.
                                                                      # Como sugestão, faça assim ==> nomevariavel.nc, exemplo, prec.anual.nc; nf.anual.nc. Esse nome será utilizado para o 
                                                                      # arquivo de saída no formato ".txt". A saída será assim => prec.anual.txt; nf.anual.txt.

DIR_INPUT="../input"    # Caminho do diretório dos arquivos de entrada.
DIR_OUTPUT="../output"  # Caminho do diretório dos arquivos processados.

rm -f ${DIR_OUTPUT}/*.txt # Remove os arquivos ".txt" para não dar problemas.

for nome_arquivo in ${lista_arquivos}
do
      
      nome_variavel=$(echo ${DIR_INPUT}/${nome_arquivo} | cut -d / -f3 | sed 's/.nc//g')  # Pega o nome da variável. Exemplo, o nome é prec.anual.nc, será armazenado apenas o nome "prec.anual".	  

      echo "processando o arquivo: $nome_arquivo"

      while read linha
      do

            lon=$(echo ${linha} | awk {'print $1'})  # Pega apenas os valores de longitude.
            lat=$(echo ${linha} | awk {'print $2'})  # Pega apenas os valores de latitude.

            # O arquivo de saída terá 3 colunas: latitude longitude valor.
            eval 'cdo -s -outputtab,nohead,date,lat,lon,value -remapnn,lon="$lon"_lat="$lat" '${DIR_INPUT}/${nome_arquivo}' >> '${DIR_OUTPUT}/${nome_variavel}.txt''

      done < ${input_latlon}
done

#####################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
#####################################
