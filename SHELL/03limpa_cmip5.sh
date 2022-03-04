#!/bin/bash

#########################################
# Obtenção do tempo de máquina utilizado. 
# NÃO DELETAR ESSA LINHA!
datainicial=`date +%s` 
#########################################

####################################################################################################
# Esse script conserta as datas das simulações diárias de precipitação do modelo HADGEM2-ES do CMIP5. 
# Esse modelo possui apenas 360 dias de dados para os cenários historical, rcp26 e rcp85, 
# ou seja, os dias 31 não existem no arquivo. Este escript complementa esses dias faltantes, 
# isto é, o dia 31 de cada mês para cada ano abordado.
# Outro detalhe sobre este modelo está no fato de que para anos bissextos, o dia 01 de março 
# é duplicado, e para anos normais, os dias 01 e 02 são duplicados. Essas datas duplicadas são 
# removidas.
# Nome dos arquivos: 
# 1) prec.HADGEM2-ES.historical.nc,
# 2) prec.HADGEM2-ES.rcp26.nc e 
# 3) prec.HADGEM2-ES.rcp85.nc.
# Nome da variável do arquivo: pr. Unidade: mm/dia. Cobertural espacial: Globo.
# Instrução de uso: chmod +x limpa.sh e para executar: ./limpa.sh
# Crie um diretório e coloque os seus arquivos e este script no mesmo local.
# Autor: Guilherme Martins -> E-mail: jgmsantos@gmail.com -> Site: guilherme.readthedocs.io 
# Data: 23/06/2020 - 22h15 BRT.
# Tempo total de execução: Aproximadamente 00:05:00 para cada cenário.
####################################################################################################

modelo="HADGEM2-ES"  # Nome do modelo
nome_variavel="pr"  # Nome da variável do arquivo.
DIR_OUTPUT="./processado"
DIR_TMP="./tmp"

# Os diretórios abaixo serão criados, caso eles não existam.
if [ ! -e ${DIR_OUTPUT} -a ! -e ${DIR_TMP} ]
then
   mkdir -p ${DIR_INPUT} ${DIR_TMP}
fi

for cenario in "historical" "rcp26" "rcp85" # Cenários a serem processados.
do

    cdo -s griddes prec.${modelo}.${cenario}.nc > ${DIR_TMP}/grid.txt

    if [ ${cenario} = "historical" ]
    then
        anoi="1975"  # Ano inicial.
        anof="1978"  # Ano final.
        timestep1="61"  # Ano bissexto.
        timestep2="60,61"  # Ano normal.
    fi

    if [ ${cenario} = "rcp26" -o ${cenario} = "rcp85" ]
    then
        anoi="2071"  # Ano inicial.
        anof="2074"  # Ano final.
        timestep1="60"  # Ano bissexto.
        timestep2="59,60"  # Ano normal.
    fi

    # Cria um campo constante que será utilizado como o dia 31 de cada mês.
    cdo -s -r -f nc -chname,const,${nome_variavel} -setmissval,-999 -const,-999,${DIR_TMP}/grid.txt ${DIR_TMP}/campo_constante.nc

    # Separa o arquivo por anos.
    cdo -s splityear prec.${modelo}.${cenario}.nc ${DIR_TMP}/ano.

    for ano in $(seq ${anoi} ${anof})
    do
        echo ${cenario} ${ano}

        for mes in 01 03 05 07 08 10 12 # Apenas os meses que possuem 31 dias.
        do
            # Separa o arquivo por meses.
            cdo -s -splitmon ${DIR_TMP}/ano.${ano}.nc ${DIR_TMP}/tmp02.${ano}.mes.

            # Obtém a data final de cada arquivo que contém o mês de 31 dias. 
            data_inicial=$(cdo -s infon ${DIR_TMP}/tmp02.${ano}.mes.${mes}.nc | tail -1 | sed 's/-//g' | awk '{print $3}')
            # Obtém a data final de cada mês de 31 dias. É feita é uma soma de um dia para obter a data real
            # Exemplo: O mês de janeiro será mostrado como dia 30, e a linha abaixo soma mais um dia, para ficar 
            # com o dia correto, isto é, dia 31.
            data_final=$(date '+%Y%m%d' -d "${data_inicial} +1 days")
            # Essa sepação foi feita para consertar a data utilizando o CDO (settaxis).
            ano=${data_final:0:4}
            mes=${data_final:4:2}
            dia=${data_final:6:2}
            # Hora final, essa hora será utilizada no CDO (settaxis).
            hora_inicial=$(cdo -s infon ${DIR_TMP}/tmp02.${ano}.mes.${mes}.nc | tail -1 | awk '{print $4}')
            # Obtém o valor UNDEF para manter o mesmo padrão de valores do arquivo original.
            fillvalue=$(ncdump -h ${DIR_TMP}/tmp02.${ano}.mes.${mes}.nc | grep ${nome_variavel}:_FillValue | awk '{print $3}' | sed 's/f//')

            echo $data_inicial $data_final $hora_inicial

            # Obtido o campo constante, conserta-se sua data, apenas isso.
            cdo -s -setmissval,$fillvalue -settaxis,${ano}-${mes}-${dia},${hora_inicial},1day ${DIR_TMP}/campo_constante.nc ${DIR_TMP}/tmp03.${ano}.mes.${mes}.nc

            # O mergetime tem como objetivo unir os meses com 30 dias com o campo constante (dia 31), gerando assim, um arquivo
            # com 31 dias.
            cdo -s -O mergetime ${DIR_TMP}/tmp02.${ano}.mes.${mes}.nc ${DIR_TMP}/tmp03.${ano}.mes.${mes}.nc ${DIR_TMP}/tmp04.${ano}.mes.${mes}.nc

        done

        # Dessa vez, os meses para um ano em particular são unidos de forma a terem 365 ou 366 dias.
        cdo -s -O mergetime ${DIR_TMP}/tmp04.${ano}.mes.01.nc ${DIR_TMP}/tmp02.${ano}.mes.02.nc \
                            ${DIR_TMP}/tmp04.${ano}.mes.03.nc ${DIR_TMP}/tmp02.${ano}.mes.04.nc  \
                            ${DIR_TMP}/tmp04.${ano}.mes.05.nc ${DIR_TMP}/tmp02.${ano}.mes.06.nc  \
                            ${DIR_TMP}/tmp04.${ano}.mes.07.nc ${DIR_TMP}/tmp04.${ano}.mes.08.nc  \
                            ${DIR_TMP}/tmp02.${ano}.mes.09.nc ${DIR_TMP}/tmp04.${ano}.mes.10.nc  \
                            ${DIR_TMP}/tmp02.${ano}.mes.11.nc ${DIR_TMP}/tmp04.${ano}.mes.12.nc  \
                            ${DIR_TMP}/tmp05.${ano}.nc

        if [ $(expr ${ano} % 4) -eq 0 ]  # Checa se o ano é bissexto ou não.
        then
           # Após ter obtido o arquivo com 366 dias, a linha abaixo, remove a data duplicada, isto é, o dia 01 de março.
           # Isto é feito para cada ano.
           cdo -s -delete,timestep=${timestep1} ${DIR_TMP}/tmp05.${ano}.nc ${DIR_TMP}/tmp06.${ano}.nc  # O mês de março tem o dia 01 duplicado.
        else
           # Após ter obtido o arquivo com 365 dias, a linha abaixo, remove as datas duplicadas, isto é, os dias 01 e 02 de março.
           # Isto é feito para cada ano.
           cdo -s -delete,timestep=${timestep2} ${DIR_TMP}/tmp05.${ano}.nc ${DIR_TMP}/tmp06.${ano}.nc  # O mês de março tem os dias 01 e 02 duplicados.
        fi
    done

    # Por fim, todos os anos são unidos em um único arquivo.
    cdo -s -O mergetime ${DIR_TMP}/tmp06.????.nc ${DIR_OUTPUT}/prec.HADGEM2-ES.${cenario}.corrigido.nc

    # Remove arquivos desnecessários.
    rm -f ${DIR_TMP}/ano.????.nc ${DIR_TMP}/tmp??.*.nc ${DIR_TMP}/campo_constante.nc ${DIR_TMP}/grid.txt

done

#####################################
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
echo " Tempo gasto: $tempo "
#####################################

