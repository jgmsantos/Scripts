; Nome do script: cap20_ex10.ncl

begin

f = addfile("../../dados/prec.2014.nc","r")

ppt  = f->precip

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex10")

plot = new(2,graphic) ; Variável necessária para criar o painel 
                      ; com duas figuras.

res                = True            ; Habilita personalização do gráfico.
res@cnFillOn       = True            ; Gráfico preenchido.
res@cnFillPalette  = "precip2_17lev" ; Define o mapa de cores.
res@lbOrientation  = "Vertical"      ; Orientação da legenda da figura.
res@gsnDraw        = False           ; Não desenha.
res@gsnFrame       = False           ; Não avança o frame.

; Plot da primeira figura com o tamanho original da fonte.

plot(0) = gsn_csm_contour_map_ce(wks,ppt(0,:,:),res) 

res@tmXBLabelFontHeightF = 0.02  ; Tamanho da fonte do eixo y inferior.
res@tmYLLabelFontHeightF = 0.02  ; Tamanho da fonte do eixo y esquerdo.
res@lbLabelStride        = 2     ; Intervalo dos rótulos da legenda da
                                 ; figura.
res@tmXBTickSpacingF     = 60.   ; Espaçamento dos rótulos do eixo x 
                                 ; inferior (XB).
res@gsnStringFontHeightF = 0.025 ; Altera o tamanho da fonte de todos 
                                 ; os títulos da figura simultaneamente
                                 ; da segunda figura. Caso seja 
                                 ; necessário alterar individualmente o 
                                 ; tamanho da fonte dos títulos, basta
                                 ; fazer uso dos recursos: 
                                 ; gsnLeftStringFontHeightF, 
                                 ; gsnRightStringFontHeightF e
                                 ; gsnCenterStringFontHeightF.

; Plot da segunda figura com o tamanho dos títulos alterado para 0.025.

plot(1) = gsn_csm_contour_map(wks,ppt(0,:,:),res)  

; Criação do painel.
resP                            = True
resP@gsnPanelYWhiteSpacePercent = 10   ; Espaçamento vertical entre 
                                       ; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)

end
