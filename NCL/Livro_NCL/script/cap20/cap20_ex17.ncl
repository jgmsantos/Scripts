; Nome do script: cap20_ex17.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex17")

res                          = True
res@cnFillOn                 = True       ; Gráfico preenchido.
res@cnFillPalette            = "precip2_17lev" ; Define o mapa de cores.
res@lbLabelFontHeightF       = 0.015      ; Tamanho dos valores da 
								 					   ; legenda.
res@lbTitleOn                = True       ; Habilita um título para 
                                          ; a legenda.
res@lbTitleString            = "(mm/dia)" ; Título da legenda.
res@lbTitleFontHeightF       = 0.025      ; Tamanho da fonte do título 
								 					   ; da legenda.
res@pmLabelBarOrthogonalPosF = 0.15       ; Deslocamento na direção y 
									 				   ; da barra de legenda.
res@lbTitlePosition          = "Right"    ; Posição do título da legenda.
res@lbTitleDirection         = "Across"   ; Direção do título da legenda.
res@lbLabelFont              = "Helvetica-Bold" ; Tipo de fonte a ser
																; utilizado.
res@lbLabelPosition          = "Center"         ; Posição dos rótulo da
																; legenda.
res@lbLabelAlignment         = "BoxCenters"     ; Orientação dos rótulos.
                               ; Os valores abaixo correspondem aos 
								       ; rótulos que vão aparecer na legenda, 
                               ; ou seja, os próprios valores da variável.
res@lbLabelStrings           =  (/"1","2","3","4","5","6","7","8", \ 
                                  "9","10","11","12"/) 

plot = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res)

end
