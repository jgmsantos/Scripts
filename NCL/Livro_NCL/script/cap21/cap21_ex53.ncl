; Nome do script: cap21_ex53.ncl

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

numPetals = 8              ; 8 é o número de direções 
                           ; (N,NE,E,SE,S,SW,W,NW) da rosa
                           ; dos ventos. Esse é o valor padrão.
circFr    = 10.0           ; Frequência com que os círculos aparecem 
                           ; na figura.
spdBounds = (/2.,3.,4.,5./); Limites de velocidade para a linha mais 
                           ; espessa.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex53")

res               = True
res@tiMainString  = "Rosa dos ventos"

plot = WindRoseThickLine(wks,velv,dirv,numPetals,circFr,spdBounds,res)

end
