; Nome do script: cap20_ex15.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex15")

res                = True            ; Habilita personalização do gráfico.
res@cnFillOn       = True            ; Gráfico preenchido.
res@lbOrientation  = "vertical"      ; Legenda de cores na vertical. 
                                     ; O padrão é horizontal.
res@cnFillPalette  = "precip2_17lev" ; Define o mapa de cores.

plot = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res)

end
