; Nome do script: cap20_ex13.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex13")

plot = new(2,graphic) ; Variável necessária para criar o painel com 
		      ; duas figuras.

res                = True       ; Habilita personalização do gráfico.
res@cnFillPalette  = "wgne15"   ; Define o mapa de cores.
res@lbOrientation  = "Vertical" ; Orientação da legenda da figura.
res@gsnDraw        = False      ; Não desenha.
res@gsnFrame       = False      ; Não avança o frame.
res@mpMinLonF      = -90.0      ; Aplica 
res@mpMaxLonF      = -20.0      ; um zoom
res@mpMinLatF      = -30.0      ; na áres de
res@mpMaxLatF      =  20.0      ; interesse.

plot(0) = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res) ; Plot da primeira
																     ; figura.

res@cnLineLabelFontHeightF   = 0.03  ; Tamanho da fonte dos rótulos 
											    ; dos contornos.
res@cnInfoLabelFontHeightF   = 0.03  ; Tamanho da fonte das informações
				    							 ; dos rótulos dos contornos.

plot(1) = gsn_csm_contour_map(wks,ppt(0,:,:),res) ; Plot da segunda 
																  ; figura.

; Criação do painel.
resP                            = True 
resP@gsnPanelYWhiteSpacePercent = 10   ; Espaçamento vertical entre 
				      							; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)

end
