#!/bin/bash

rm -f estacao_???.nc # Remove os arquivos para não gerar error.

ncols=6 # Número de variáveis.

# Cada coluna do arquivo texto é representada 
# pelo nome da variável/unidade na lista abaixo.
#               Col1  Col2  Col3   Col4 Col5  Col6
nome_variavel=("prec" "vel" "temp" "HR" "SWR" "LWR")
unidade_variavel=("mm" "m/s" "C" "HR" "W/m2" "W/m2")

# Altere a data conforme a resolução temporal do seu 
# arquivo. A unidade pode ser: hour, day, mon e year.
# O arquivo a ser gerado terá resolução temporal a cada
# 3 horas (3hour) começando em 01/01/1950.
time="1950-01-01,00:00:00,3hour"

k=1

for var in $(ls data_*) ; do 

   id=$(echo ${k} | awk '{printf("%.3d",$1)}')  # Nome do arquivo de saída.
   lat=$(echo ${var} | cut -d "_" -f 2)  # Latitude do local.
   lon=$(echo ${var} | cut -d "_" -f 3)  # Longitude do local.
   
   # Descrição do domínio a ser gerado.
   cat << EOF > grid.txt
   gridtype = lonlat
   xsize    = 1
   ysize    = 1
   xvals    = ${lon}
   yvals    = ${lat}
EOF

   j=0
   
   # Loop sobre todas as variáveis.
   for i in $(seq 1 ${ncols}) ; do
       echo "ID: ${id} -> variavel: ${nome_variavel[j]}"
	   
       $(cat  ${var} | cut -d " " -f ${i} > tmp.txt)
       cdo -s -f nc -setattribute,${nome_variavel[$j]}@units=${unidade_variavel[$j]} -settaxis,${time} -setname,${nome_variavel[$j]} \
                    -setmissval,-999 -input,grid.txt out_${i}.nc < tmp.txt
       j=$(expr $j + 1)
   done

   # Junta todos os arquivos em um NetCDF para cada localidade.
   cdo -s -O merge out_*.nc estacao_${id}.nc

   # Remove arquivos desnecessários.
   rm -f out_*.nc tmp.txt grid.txt

   k=$(expr $k + 1)
done
