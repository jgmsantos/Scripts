; Nome do script: cap14_ex31.ncl

begin

f = addfile("../../dados/prec.1986.1989.nc","r")

;***********************************************************
; Leitura do tempo e criação dele no formato yyyymm
;***********************************************************
time   = f->time   ; time:units = "days since 1990-1-1 00:00:00"
TIME   = cd_calendar(time,0) ; Tipo float.
year   = toint(TIME(:,0)) 
month  = toint(TIME(:,1))
yyyymm = year*100 + month ; É necessário como argumento para 
                          ; o cálculo.
;***********************************************************

ppt = f->precip

; Soma anual, por isso a opção 0 na função abaixo.

prc_total_anual = month_to_annual_weighted(yyyymm,ppt,0)

printVarSummary(prc_total_anual)

end
