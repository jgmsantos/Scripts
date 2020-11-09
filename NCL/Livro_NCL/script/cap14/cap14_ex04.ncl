; Nome do script: cap14_ex04.ncl

begin

f = addfile("../../dados/010120090000UTCa310320091800UTC.nc","r")

t = short2flt(f->air) 

; Informações da variável t:
; [time | 360] x [level | 12] x [lat | 73] x [lon | 144]
; short air ( time, level, lat, lon )
; Como o dado é do tipo short (visto com o ncl_filedump), 
; será necessário descompactá-lo para o tipo float 
; com a função short2flt.

; Calcula a média diária. O valor "0" refere-se a dimensão para 
; realizar a estatística, ou seja, a dimensão tempo.

xdayAvg = calculate_daily_values(t,"avg",0,False)

printVarSummary(xdayAvg) ; Imprime um resumo da variável xdayAvg.

end
