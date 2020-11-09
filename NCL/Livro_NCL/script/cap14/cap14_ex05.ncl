; Nome do script: cap14_ex05.ncl

begin

f = addfile("../../dados/010120090000UTCa310320091800UTC.nc","r")

t = short2flt(f->air) 

; Informações da variável t:
; [time | 360] x [level | 12] x [lat | 73] x [lon | 144]
; short air ( time, level, lat, lon )
; Como o dado é do tipo short (visto com o ncl_filedump), 
; será necessário descompactá-lo para o tipo float 
; com a função short2flt.

opt           = True
opt@nval_crit = 4     ; Requer pelo menos 4 valores para 
                      ; calcular a média.

; Calcula a média mensal. O valor "0" refere-se a dimensão para 
; realizar a estatística, ou seja, a dimensão tempo.

xdayAvg = calculate_daily_values(t,"avg",0,opt)

printVarSummary(xdayAvg)

end
