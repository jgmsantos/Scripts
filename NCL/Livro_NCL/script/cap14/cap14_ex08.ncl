; Nome do script: cap14_ex08.ncl

begin

f = addfile("../../dados/ppt.2005.nc","r")

ppt = f->PREC ; [time | 365] x [lat | 180] x [lon | 360]
                
; Calcula a média a cada 7 dias (padrão). O valor "0" 
; refere-se a dimensão para realizar a estatística, ou seja, 
; a dimensão tempo. 
; Como os dados possuem 365 dias / 7 = 52 semanas.

xSegAvg = calculate_segment_values(ppt,"avg",0,False)
xSegSum = calculate_segment_values(ppt,"sum",0,False)
xSegMin = calculate_segment_values(ppt,"min",0,False)
xSegMax = calculate_segment_values(ppt,"max",0,False)

printVarSummary(xSegAvg) ; Imprime um resumo da variável xSegAvg.

end
