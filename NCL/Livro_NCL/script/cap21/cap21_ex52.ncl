; Nome do script: cap21_ex52.ncl

begin

; As informações que aparecem no topo da rosa 
; dos ventos significam:
; SpdAve = velocidade média do vento.
; SpdStd = desvio padrão médio do vento.
; DirAve = direção média do vento.
; No Calm Reports = Sem vento calmo reportado.
; Nwnd = número de observações do dado.
; O número na ponta de cada direção representa sua velocidade média.

f = addfile("../../dados/uv.10m.jan1979.dez2014.nc","r")

; short uwnd(time, level, lat, lon) = 432, 1, 1, 1
u = short2flt(f->uwnd(:,0,0,0)) 
; short vwnd(time, level, lat, lon) = 432, 1, 1, 1
v = short2flt(f->vwnd(:,0,0,0)) 

dirv = wind_direction(u,v,0) ; Calcula a direção do vento em graus.
velv = wind_speed(u,v)       ; Calcula a velocidade do vento (m/s).

numPetals = 8    ; Número de direções da rosa dos ventos: 
                 ; N,NE,E,SE,S,SW,W,NW. 
                 ; Esse é o valor padrão.
circFr    = 10.0 ; Frequência com que os círculos aparecem na figura.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex52")

res               = True
res@tiMainString  = "Rosa dos ventos"

plot = WindRoseBasic(wks,velv,dirv,numPetals,circFr,res)

end
