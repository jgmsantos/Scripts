#!/bin/bash

# Uso do CDO e funções para processar dados usando Shell.
# Guilherme Martins - 16/08/2023 - 16h15.
# E-mail: jgmsantos@gmail.com.
# https://guilherme.readthedocs.io/en/latest
# Manual do CDO: https://drive.google.com/file/d/15UT8bdlLlwxwazTvRk2IK28oys89Z4nl/view

###########################################################################################
############################### FUNÇÕES ###################################################
###########################################################################################

function gera_anomalia {
    # Função para gerar a anomalia mensal.
    # Anomalia = valor_observado - média (climatologia).

    # São utilizados 5 parâmetros.
    # $1: o arquivo a ser processado.
    # $2: o arquivo de climatologia a ser gerado.
    # $3: o ano inicial.
    # $4: o ano final.
    # $5: o arquivo de anomalia a ser gerado.

    # Este trecho recorta os anos de interesse para gerar a climatologia (ymonmean).
    echo "Selecionando os anos: $3 a $4 para calcular a climatologia do arquivo: $1"
    cdo -s --no_history selyear,$3/$4 $1 $2

    # Cálculo propriamente dito da anomalia.
    echo "Cálculo da anomalia."
    cdo -s --no_history -ymonsub $1 -ymonmean $2 $5
    
    echo "Removendo o arquivo de climatologia -> $2"
    rm -f $2
}

###########################################################################################
############################### SCRIPT PRINCIPAL ##########################################
###########################################################################################

# Para executar basta digitar:
# bash anomalia.sh

# Nome do arquivo a ser usado para calcular a climatologia. Este arquivo está no computador.
Nome_Arquivo="/mnt/c/Users/guilherme.martins/guilherme/base_dados/PRECIPITACAO/CHIRPS/input/chirps.nc"
# Nome do arquivo de climatologia a ser gerado no computador.
Nome_Arquivo_Climatologia="climatologia.nc"
# Nome do arquivo de anomalia a ser gerado no computador. Caso queira salvar em outro local, 
# basta incluir o caminho.
Nome_Arquivo_Anomalia="anomalia.nc"
Ano_Inicial="1991" # Usado para calcular 
Ano_Final="1992" # a climatologia.

# Execução da função para calcular a anomalia. Nota-se o uso de 5 parâmetros de acordo com a função.
# Parâmetro          $1                     $2                   $3           $4                $5
gera_anomalia ${Nome_Arquivo} ${Nome_Arquivo_Climatologia} ${Ano_Inicial} ${Ano_Final} ${Nome_Arquivo_Anomalia}
