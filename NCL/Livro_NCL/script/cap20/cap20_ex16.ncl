; Nome do script: cap20_ex16.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex16")

res                          = True
res@cnFillOn                 = True       ; Gráfico preenchido.
res@lbLabelAngleF            = 90         ; Inclinação em graus dos 
                                          ; nomes na legenda.
res@lbLabelFontHeightF       = 0.025      ; Tamanho dos valores da
                                          ; legenda.
res@lbTitleOn                = True       ; Habilita um título para a 
                                          ; legenda.
res@lbTitleString            = "(mm/dia)" ; Título da legenda.
res@lbTitleFontHeightF       = 0.025      ; Tamanho da fonte do título
                                          ; da legenda.
res@pmLabelBarOrthogonalPosF = 0.15       ; Deslocamento na direção y
                                          ; da barra de legenda.
res@cnFillPalette  = "precip2_17lev"      ; Define o mapa de cores.

plot = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res) ; Plot da figura.

end
