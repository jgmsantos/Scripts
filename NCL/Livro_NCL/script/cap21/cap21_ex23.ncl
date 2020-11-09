; Nome do script: cap21_ex23.ncl

begin

f = addfile("../../dados/anom.hgt.jan1979.dez2000.nc","r") 

; short hgt ( time, level, lat, lon ) = 3, 1, 144, 73
hgt = short2flt(f->hgt) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex23")

res                              = True
res@gsnPolar                     = "NH"  ; Hemisfério a ser visualizado.
res@mpFillOn                     = False ; Mapa com fundo branco.
res@tiMainString                 = "Anomalia de altura geopotencial - " +\ 
                                   "Fev/1979"
res@gsnCenterString              = ""
res@gsnLeftString                = ""
res@gsnRightString               = ""
res@mpGridLatSpacingF            = 10.0  ; Espaçamento da latitude.
res@mpGridLonSpacingF            = 30.0  ; Espaçamento da longitude.
res@gsnDraw                      = False 
res@gsnFrame                     = False 
res@gsnContourZeroLineThicknessF = 4.0	; Espessura do contorno zero. 
                                        ; Para eliminar o contorno zero, 
                                        ; basta colocar o valor zero.
res@mpCenterLonF                 = -180  ; Ponto de vista do mapa. 
res@gsnPolarLabelDistance        = 1.08  ; Distância das longitudes.
res@gsnPolarLabelFontHeightF     = 0.020 ; Altera o tamanho da fonte 
                                         ; dos rótulos de longitude.
res@cnLineLabelPlacementMode     = "constant" ; Rótulo dos contornos.
res@cnInfoLabelOn                = False ; Desabilita as informações 
                                         ; de contorno.

plot = gsn_csm_contour_map_polar(wks,hgt(1,0,:,:),res)

; Define cores para os valores negativos (blue), zero (black) 
; e positivos (red).
plot = ColorNegDashZeroPosContour(plot,"blue","black","red") 

draw(plot)
frame(wks)

end
