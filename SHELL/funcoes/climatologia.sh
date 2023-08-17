#!/bin/bash

# Uso do CDO e funções para processar dados usando Shell.
# Guilherme Martins - 16/08/2023 - 16h15.
# E-mail: jgmsantos@gmail.com.
# https://guilherme.readthedocs.io/en/latest
# Manual do CDO: https://drive.google.com/file/d/15UT8bdlLlwxwazTvRk2IK28oys89Z4nl/view

###########################################################################################
############################### FUNÇÕES ###################################################
###########################################################################################

function gera_climatologia {
    # Função que calcula a climatologia mensal fornecido 
    # os anos inicial e final para qualquer variável.

    # São utilizados 4 parâmetros.
    # $1: o arquivo a ser processado.
    # $2: o arquivo a ser gerado.
    # $3: o ano inicial.
    # $4: o ano final.

    echo "Arquivo a ser processado: $1"
    echo "Arquivo a ser gerado: $2"
    echo "Calculando a climatologia: $3 a $4"

    cdo -s --no_history -setmissval,-999 -ymonmean -selyear,$3/$4 $1 $2
}

###########################################################################################
############################### SCRIPT PRINCIPAL ##########################################
###########################################################################################

# Para executar basta digitar:
# bash climatologia.sh

# Nome do arquivo a ser usado para calcular a climatologia. Este arquivo está no computador.
Nome_Arquivo="/mnt/c/Users/guilherme.martins/guilherme/base_dados/PRECIPITACAO/CHIRPS/input/chirps.nc"
# Nome do arquivo de climatologia a ser gerado no computador. Caso queira salvar em outro local, 
# basta incluir o caminho.
Nome_Arquivo_Climatologia="climatologia.nc"
# Nome do arquivo de anomalia a ser gerado no computador.
Nome_Arquivo_Anomalia="anomalia.nc"
Ano_Inicial="1991" # Usado para calcular 
Ano_Final="2020" # a climatologia.

# Execução da função para calcular a climatologia. Nota-se o uso de 4 parâmetros de acordo com a função.
# Parâmetro              $1                    $2                     $3           $4
gera_climatologia ${Nome_Arquivo} ${Nome_Arquivo_Climatologia} ${Ano_Inicial} ${Ano_Final}
