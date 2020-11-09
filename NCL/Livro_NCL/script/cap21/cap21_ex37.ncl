; Nome do script: cap21_ex37.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

u = short2flt(f->uwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex37")

res                              = True
res@tiMainString                 = "Vento zonal"
res@cnLevelSpacingF              = 5.0   ; Espaçamento entre as 
                                         ; isolinhas.
res@gsnContourZeroLineThicknessF = 5.0 	 ; Espessura da linha 
                                         ; do contorno zero.
res@gsnContourNegLineDashPattern = 1 	 ; Fixa as isolinhas 
                                         ; negativas com o 
                                         ; padrão 1.
res@gsnDraw                      = False ; Não cria a figura.
res@gsnFrame                     = False ; Não avança o frame.
res@tmYRTickSpacingF             = 1     ; Altera o espaçamento 
                                         ; do eixo y de 1 em 1.

plot = gsn_csm_pres_hgt(wks,u(0,:,{0},:),res)

; Personalização do padrão de preenchimento.

opt                  = True
opt@gsnShadeFillType = "pattern" ; Pode ser "color" ou "pattern".
opt@gsnShadeLow      = 17        ; Tipo de preechimento para os
                                 ; menores valores.
opt@gsnShadeHigh     = 3         ; Tipo de preechimento para os 
                                 ; maiores valores.

; Preenche os valores menores que zero com o padrão 17, 
; e os valores acima de 15 com o padrão 3.

plot = gsn_contour_shade(plot,0,15,opt) 

draw(plot)
frame (wks)

end
