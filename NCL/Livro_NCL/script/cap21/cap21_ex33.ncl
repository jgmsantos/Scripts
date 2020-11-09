; Nome do script: cap21_ex33.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd) 

uz = zonalAve(u) ; Realiza a média zonal (longitude). 

; Dimensions and sizes: [time | 3] x [level | 12] x [lat | 73]                 
printVarSummary(uz) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex33")

res                              = True
res@tiMainString                 = "M"+eacute+"dia zonal"
res@gsnContourZeroLineThicknessF = 5.0 ; Espessura da linha do 
                                       ; contorno zero.
res@gsnContourNegLineDashPattern = 1   ; Fixa as isolinhas negativas
                                       ; com o padrão 1 
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
res@cnFillPalette                = "BlWhRe" ; Escolha da tabela de cores.
res@tiYAxisString                = "Press"+atilde+"o (hPa)"
res@cnLineLabelPlacementMode     = "constant" ; Defini o tipo de 
                                              ; rótulo dos contornos.
res@gsnLeftString                = ""
res@gsnCenterString              = ""
res@gsnRightString               = ""
res@tmYRMode                     = "Automatic"; Desabilita o eixo 
                                              ; y da direita (altura).

plot = gsn_csm_pres_hgt(wks,uz(0,:,:),res)

end
