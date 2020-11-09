; Nome do script: cap21_ex38.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

u = short2flt(f->uwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex38")

res                              = True
res@tiMainString                 = "Vento zonal"
res@gsnContourZeroLineThicknessF = 5.0   ; Espessura da linha 
                                         ; do contorno zero.
res@gsnContourNegLineDashPattern = 1 	  ; Fixa as isolinhas 
                                         ; negativas com o 
                                         ; padrão 1 
                                         ; (linhas tracejadas).
res@cnLevelSelectionMode         = "ManualLevels" ; Fixa os níveis 
                                                  ; de forma manual.
res@cnLevelSpacingF              = 5.0      ; Espaçamento dos valores.
res@cnMinLevelValF               = -50.     ; Mínimo valor.
res@cnMaxLevelValF               =  50.     ; Máximo valor.
res@cnLineLabelsOn               = True     ; Habilita as linhas 
                                            ; de contorno.
res@cnFillOn                     = True     ; Habilita o preechimento
                                            ; do gráfico.
res@cnFillPalette                = "BlWhRe" ; Escolha da tabela de 
                                            ; cores.
res@tiYAxisString                = "Press"+atilde+"o (hPa)" ; Título 
                                                            ; do eixo y.
res@cnLineLabelPlacementMode     = "constant" ; Define o tipo de rótulo
                                              ; dos contornos.
res@gsnLeftString                = ""
res@gsnCenterString              = ""
res@gsnRightString               = ""
res@tmYRMode                     = "Automatic" ; Desabilita o eixo y 
                                               ; da direita (altura).

plot = gsn_csm_pres_hgt(wks,u(0,:,{0},:),res)

end
