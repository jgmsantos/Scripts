#!/bin/bash

# -Início da função --------------------------------------------------------------------------------------------------
# Função que calcula o percentil.
function calcula_percentil() {

    if [ "$#" -ne 4 ]; then
      printf "************************************************************\r\n\t"
      echo "Faltam parâmetros para executar o script."
      printf "************************************************************\r\n\t"
      echo "Uso do script: $0 <Arquivo diário de chuva> <valor do percentil> <Nome da variavel do arquivo de chuva> <Nome do arquivo a ser gerado>"
      printf "************************************************************\r\n"
      exit 1
    fi

    # Opções do CDO utilizadas:
    # -s = modo silencioso do cdo.
    # --no_history = não armazena no NetCDF o atributo "history".
    # -O = sobrescrita de arquivos.
    
    echo "Processando o arquivo em (mm/dia): $1"
    
    echo "Selecionando os pontos de grade onde a precipitação é maior que 1 mm/dia."
    # Quando a chuva for maior igual a 1 mm/dia, recebe 1, caso contrário, recebe 0.
    cdo -s --no_history -gec,1 $1 tmp01.nc
    
    echo "Aplicando máscara de valores 0 e 1 no arquivo de chuva ($1)."
    # Multiplica (-mul) o arquivo de chuva pelo arquivo que contém valores 0 e 1 (tmp01.nc).
    # Define o valor 0 como undef (-setmissval) e depois troco o valor 0 para o undef -999.
    cdo -s --no_history -setmissval,-999 -setmissval,0 -mul $1 tmp01.nc tmp02.nc
    
    echo "Calculando percentil $2% do arquivo: $1."
    # Calcula o percentil (-timpctl) do arquivo "tmp02.nc" onde só tem chuva acima de 1 mm/dia.
    # -setname = define o nome da variável que o usuário deseja.
    # Link para a documentação do cálculo do percentil:
    # https://code.mpimet.mpg.de/projects/cdo/embedded/cdo.pdf
    # 2.8.18. TIMPCTL - Percentile values over all timesteps
    # Página 141.
    cdo -s --no_history -setname,p$2 -timpctl,$2 tmp02.nc -timmin tmp02.nc -timmax tmp02.nc p95.nc
    
    echo "Juntando os arquivos para calcular o percentil $2%."
    # Junta os arquivos "tmp02.nc" e "p95.nc" em um só, chamado de "merge.nc".
    cdo -s -O --no_history merge tmp02.nc p95.nc merge.nc
    
    echo "Selecionando os pontos de grade onde a precipitação é maior que o percentil $2%."
    # (chuva>p95)?pr:-999 = Quando a chuva for maior que o percentil 95% , recebe o valor 
    # de chuva , caso contrário, recebe o valor "-999".
    # Depois converte o valor "-999" para undef (-setmissval).
    # ppt é um nome qualquer definido pelo usuário.
    # Neste arquivo (tmp03.nc) terão todos os dias em que a chuva foi maior que o percentil 95.
    cdo -s --no_history -setmissval,-999 -expr,"ppt=($3>p$2)?$3:-999" merge.nc tmp03.nc
    
    echo "Somando todos os dias onde a chuva foi maior que o percentil $2%."
    # Soma os dias de um determinado ano em que a chuva foi maior que o p95.
    # chuva_p95_2023.nc = É o arquivo final.
    cdo -s --no_history timsum tmp03.nc $4

    echo "Arquivo gerado: $4"
    
    echo "Removendo arquivos desnecessários."
    # Remove arquivos temporários.
    # Para ver os passos intermediários, descomente a linha abaixo.
    rm -f tmp??.nc p95.nc merge.nc
}
# -Fim da função -----------------------------------------------------------------------------------------------------

# Programa principal. Declara algumas variáveis.
Nome_Do_Arquivo_Diario_De_Chuva="CPC-1981.nc" # Em mm/dia.
percentil="80" # Percentil de interesse. Intervalo válido: 0-100.
Nome_Da_Variavel_Arquivo_De_Chuva="pr" # Nome da variável que está no NetCDF do arquivo "Nome_Do_Arquivo_Diario_De_Chuva".
Nome_Do_Arquivo_Gerado="chuva_p${percentil}_1981.nc" # Arquivo que será gerado na sua máquina.

# Chama a função.
# Ordem dos parâmetros de acordo com a função. São 4 no total.
#                                $1                        $2                      $3                            $4
calcula_percentil "$Nome_Do_Arquivo_Diario_De_Chuva" "$percentil" "${Nome_Da_Variavel_Arquivo_De_Chuva}" "${Nome_Do_Arquivo_Gerado}"
