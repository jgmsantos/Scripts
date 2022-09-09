#!/bin/bash

# Objetivo: Conta o número de dias de temperatura máxima e precipitação 
# dentro de um intervalo de dias usando percentil.

# Dados de entrada: Neste caso, dado de temperatura máxima e precipitação. 
# Pode ser qualquer variável.

# Fonte da dúvida:
# https://code.mpimet.mpg.de/projects/cdo/boards/2
# Não lembro quando esta dúvida foi postada.

prec_file="prec.nc" # Exemplo: arquivo espacial com 30 dias do mês de junho.
tmax_file="tmax.nc" # Exemplo: arquivo espacial com 30 dias do mês de junho.

# Calcula o percentil 75 para temperatura máxima.
# Alterar o valor "-timpctl,75" e "-timpctl,25" de acordo com a sua necessidade.
cdo -s -timpctl,75 $tmax_file -timmin $tmax_file -timmax $tmax_file tsurf_75pctl.nc
# Calcula o percentil 25 para precipitação.
cdo -s -timpctl,25 $prec_file -timmin $prec_file -timmax $prec_file precip_25pctl.nc

# O comando abaixo faz um tipo de "if". Exemplo. Quando o mesmo ponto de grade de tmax.nc 
# for maior que (gt) tsurf_75pctl.nc, este ponto de grade, recebe o valor 1, no caso contrário, 
# recebe 0.
# Cria uma máscara com valores 0, quando a condição não for satisfeita, e 1, quando for satisfeita.
cdo -s -gt  $tmax_file tsurf_75pctl.nc out_tsurf.nc
cdo -s -lt $prec_file precip_25pctl.nc out_precip.nc

# Multiplica (mul) os dois campos, ou seja, as duas máscaras com valores 0 e 1 criadas 
# com o objetivo de coincidir os mesmo pontos de grade.
cdo -s mul out_tsurf.nc out_precip.nc masked_gtT75_ltP25.nc

# Multiplica a grade de tmax.nc pela grade da máscade de masked_gtT75_ltP25.nc.
# Quando o valor for maior que zero (gtc,0), recebe 1, caso contrário, recebe 0.
# E depois soma todos os tempos (timsum) e arredonda (nint) o valor caso tenha valor decimal
# porque o número de dias é um valor inteiro, e não decimal.
cdo -s -nint -timsum -gtc,0 -mul  $tmax_file masked_gtT75_ltP25.nc outfile_tsurf.nc
cdo -s -nint -timsum -gtc,0 -mul $prec_file masked_gtT75_ltP25.nc outfile_precip.nc

# Remove arquivos desnecessários.
rm -f tsurf_75pctl.nc precip_25pctl.nc out_tsurf.nc out_precip.nc masked_gtT75_ltP25.nc