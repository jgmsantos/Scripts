; Nome do script: cap14_ex02.ncl

begin

;***********************************************************
; Abertura do arquivo
;***********************************************************
f   = addfile("../../dados/gpcp.mensal.1979.2012.nc","r")                          
ppt = f->precip ; float precip(time, lat, lon)
;***********************************************************
; Calcula a climatologia
;***********************************************************
clima = clmMonTLL(ppt)
;***********************************************************
; Calcula a anomalia mensal usando a climatologia
;***********************************************************
pptAnom = calcMonAnomTLL(ppt,clima)

printVarSummary(pptAnom)

end
