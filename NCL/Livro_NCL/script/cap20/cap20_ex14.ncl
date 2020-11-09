; Nome do script: cap20_ex14.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex14")

res                = True            ; Habilita personalização do gráfico.
res@cnFillOn       = True            ; Gráfico preenchido.
res@cnFillPalette  = "precip2_17lev" ; Define o mapa de cores.

; Para desabilitar a legenda de cores, basta definir o seguinte recurso:
; res@lbLabelBarOn = False

plot = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res) ; Plot da figura.

end
