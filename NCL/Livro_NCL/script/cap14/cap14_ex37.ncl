; Nome do script: cap14_ex37.ncl

begin

f = addfile("../../dados/olr.01jan2000a31dez2004.nc","r")
;***********************************************************
; Leitura do tempo e criação dele no formato yyyyddd.                    
;***********************************************************
time    = f->time
TIME    = cd_calendar(time, 0) ; tipo float 
year    = toint(TIME(:,0))
month   = toint(TIME(:,1))
day     = toint(TIME(:,2)) 
ddd     = day_of_year(year,month,day)
yyyyddd = year*1000 + ddd      ; É necessário como argumento  
                               ; para o cálculo da climatologia.
;***********************************************************
; Leitura do dado
;*********************************************************** 
olr = short2flt(f->olr) ; short olr ( time, lat, lon )
;***********************************************************
; Calcula a climatologia diária em cada ponto de grade.
;***********************************************************
olrClmDay  = clmDayTLL(olr,yyyyddd)
;***********************************************************
; Calcula a climatologia suavizada usando 2 harmônicos.
;***********************************************************
olrClmDay_sm = smthClmDayTLL(olrClmDay,2)

printVarSummary(olrClmDay_sm)

; O resultado do comando printVarSummary(olrClmDay_sm) será:
; Dimensions and sizes:	[year_day | 366] x [lat | 73] x [lon | 144]

end
