; Nome do script: cap20_ex11.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex11")

plot = new(2,graphic) ; Variável necessária para criar o 
                      ; painel com duas figuras.

res                = True            ; Habilita personalização do gráfico.
res@cnFillOn       = True            ; Gráfico preenchido.
res@cnFillPalette  = "precip2_17lev" ; Define o mapa de cores.
res@lbOrientation  = "Vertical"      ; Orientação da legenda da figura.
res@gsnDraw        = False           ; Não desenha.
res@gsnFrame       = False           ; Não avança o frame.

plot(0) = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res) ; Plot da primeira 
                                                     ; figura.

res@lbLabelFontHeightF = 0.02 ; Altera o tamanho da fonte da legenda
                              ; de cores.

plot(1) = gsn_csm_contour_map(wks,ppt(0,:,:),res)  ; Plot da segunda
                                                   ; figura.

; Criação do painel.
resP                            = True
resP@gsnPanelYWhiteSpacePercent = 10   ; Espaçamento vertical entre 
                                       ; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)

end
