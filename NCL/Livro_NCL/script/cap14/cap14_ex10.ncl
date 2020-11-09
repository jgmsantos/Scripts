; Nome do script: cap14_ex10.ncl

begin

f = addfile("../../dados/GPCP_1DD_v1.2_19970101-20013112.nc","r")

;***********************************************************
; Leitura do tempo e criação dele no formato yyyyddd. 
; Será utilizado na função para calcular a climatologia.
;***********************************************************
time    = f->time              
TIME    = cd_calendar(time, 0) ; Tipo float.
year    = toint(TIME(:,0))     ; Guarda o ano.
month   = toint(TIME(:,1))     ; Guarda o mês.
day     = toint(TIME(:,2))     ; Guarda o dia.
ddd     = day_of_year(year,month,day) ; Retorna o dia do ano no  
                                      ; formato 365 ou 366 dias.
yyyyddd = year*1000 + ddd             ; É necessário como argumento 
                                      ; para o cálculo da climatologia.
;***********************************************************
; Leitura do dado
;*********************************************************** 
ppt = f->PREC
;***********************************************************
; Calcula a climatologia
;***********************************************************
pptClmDay = clmDayTLL(ppt,yyyyddd) ; Calcula a climatologia. Será 
                                   ; retornada uma variável com 366 dias
printVarSummary(pptClmDay)

end
