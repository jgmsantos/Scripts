; Nome do script: cap14_ex01.ncl

begin

fili = "../../dados/GPCP_1DD_v1.2_19970101-20013112.nc"
f    = addfile (fili,"r")                          
;***********************************************************
; Leitura do tempo e criação dele no formato yyyyddd                    
;***********************************************************
time    = f->time
TIME    = cd_calendar(time, 0) ; tipo float 
year    = toint(TIME(:,0))
month   = toint(TIME(:,1))
day     = toint(TIME(:,2)) 
ddd     = day_of_year(year,month,day)
yyyyddd = year*1000 + ddd      ; É necessário como argumento 
                               ; para o cálculo da anomalia.
;***********************************************************
; Leitura do dado
;*********************************************************** 
ppt     = f->PREC
printVarSummary(ppt)
;***********************************************************
; Calcula a climatologia diária bruta e a suavizada.
;***********************************************************
pptClmDay  = clmDayTLL(ppt,yyyyddd) ; Climatologia.
printVarSummary(pptClmDay)    
;***********************************************************
; Calcula a climatologia suavizada usando 2 harmônicos.
;***********************************************************
pptClmDay_sm = smthClmDayTLL(pptClmDay,2)
printVarSummary(pptClmDay_sm)
;***********************************************************
; Calcula a anomalia diária usando a climatologia bruta e a suavizada
;***********************************************************
pptAnom   = calcDayAnomTLL(ppt,yyyyddd,pptClmDay) ; Anomalia bruta.
printVarSummary(pptAnom)
printMinMax(pptAnom,0)

; Anomalia suavizada.
pptAnom_sm = calcDayAnomTLL(ppt,yyyyddd,pptClmDay_sm) 

pptAnom_sm@long_name = "Anomalia da climatologia diária suavizada"
printVarSummary(pptAnom_sm)
printMinMax(pptAnom_sm,0)

end
