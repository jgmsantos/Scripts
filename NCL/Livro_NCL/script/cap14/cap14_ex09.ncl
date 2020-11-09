; Nome do script: cap14_ex09.ncl

begin

f = addfile("../../dados/ppt.2000.nc","r")
ppt = f->PREC ; [time | 366] x [lat | 180] x [lon | 360]

opt                = True
opt@nval_crit      = 4    ; Requer pelo menos 4 valores para realizar a 
                          ; estatística.
opt@segment_length = 5    ; Média a cada 5 dias. O valor padrão é 1.
                
; Calcula a média a cada 5 dias. O valor "0" refere-se a dimensão para 
; realizar a estatística, ou seja, a dimensão tempo.
; Como os dados possuem 366 dias / 5 = 73 valores de tempo.

xSegAvg = calculate_segment_values(ppt,"avg",0,opt)

printVarSummary(xSegAvg) ; imprime um resumo da variável xSegAvg.

end
