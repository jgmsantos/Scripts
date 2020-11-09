; Nome do script: cap14_ex36.ncl

begin

f = addfile("../../dados/shum.air.rhum.pres.nc","r")

t    = f->air   ; (C)     float air(time, level, lat, lon)
q    = f->shum  ; (g/kg)  float shum(time, level, lat, lon)
rh   = f->rhum  ; (%)     float rhum(time, level, lat, lon)
psfc = f->pres  ; (hPa)   float pres(time, lat, lon)

tk = t+273.15 ; Tc->Tk
q  = q*0.001  ; g/kg->kg/kg
p  = psfc*100 ; hPa->Pa. Será utilizado no cálculo de rh.

; Todas as variáveis precisam ter o mesmo número de dimensões. A pressão 
; apresenta apenas 3 (time,lat,lon) enquanto as demais possuem 
; 4 (time,level,lat,lon). Por isso, o uso da função conform para 
; deixar a pressão com o mesmo número de dimensões das demais variáveis.

; p1 = pressão à superfície.
; p1 será usado para calcular "q" que utiliza pressão em hPa. 
p1 = conform(tk,psfc,(/0,2,3/)) ; As dimensões de "tk" que são 
                                ; iguais a "p1" são 0 = time, 
                                ; 2 = lat e 3 = lon

; p2 = pressão à superfície.
; p2 será usado para calcular "rh" que utiliza pressão em Pa.
p2 = conform(tk,p,(/0,2,3/)) ; As dimensões de "tk" que são 
                             ; iguais a "p2" são 0 = time, 
                             ; 2 = lat e 3 = lon.

; Cálculo da razão de mistura que será utilizado para obtenção de "rh".
q = mixhum_ptrh(p1,tk,rh,1) ; q (kg/kg), por isso a opção 1.

; Cálculo da umidade relativa (%).
rh = relhum(tk,q,p2)

rh = rh < 100 ; truque do NCL para fazer com que os valores maiores que 
              ; 100% sejam limitados a 100%.

printVarSummary(rh)

end
