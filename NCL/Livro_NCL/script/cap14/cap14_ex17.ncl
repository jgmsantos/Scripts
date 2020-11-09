; Nome do script: cap14_ex17.ncl

begin

f = addfile("../../dados/prec.1986.1989.nc","r")

ppt = f->precip ; float precip ( time, lat, lon ) ou em termos de 
                ; índices das dimensões 0 1 2.

; Calculando o mínimo e máximo valor da precipitação. O cálculo 
; será feito na dimensão tempo ou no índice 0.

ppt_min = dim_min_n_Wrap(ppt,0)

ppt_max = dim_max_n_Wrap(ppt,0)

; Como o cálculo foi feito na dimensão tempo, restam apenas 
; duas dimensões (lat e lon).

printVarSummary(ppt_min) ; Dimensions and sizes: [lat | 28] x [lon | 24] 
printVarSummary(ppt_max) ; Dimensions and sizes: [lat | 28] x [lon | 24]

end 
