; Nome do script: cap14_ex16.ncl

begin

f = addfile("../../dados/prec.1986.1989.nc","r")
ppt = f->precip ; float precip ( time, lat, lon ) ou em termos de 
                ; índices das dimensões 0 1 2.

; Calculando média zonal da precipitação. O cálculo será feito na 
; dimensão longitude ou no índice 2.

ppt_zonal = dim_avg_n_Wrap(ppt,2) 
; Dimensions and sizes: [time | 48] x [lat | 28]

; As informações das coordenadas e dimensões não foram perdidas por 
; causa do "_Wrap" na função que as reteve.

printVarSummary(ppt_zonal) 

end
