; Nome do script: cap21_ex24.ncl

begin

f = addfile("../../dados/anom.hgt.jan1979.dez2000.nc","r") 

; short hgt ( time, level, lat, lon ) = 3, 1, 144, 73
hgt = short2flt(f->hgt) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex24")

gsn_define_colormap(wks,"BlueDarkRed18") ; Defini a tabela de cores.

res                              = True
res@gsnPolar                     = "NH"  ; Hemisfério a ser visualizado.
res@mpFillOn                     = False ; Mapa com fundo branco.
res@tiMainString                 = "Anomalia de altura geopotencial - " +\
                                   "Fev/1979"
res@gsnCenterString              = ""
res@gsnLeftString                = ""
res@gsnRightString               = ""
res@mpGridLatSpacingF            = 30.0  ; Espaçamento da latitude.
res@mpGridLonSpacingF            = 90.0  ; Espaçamento da longitude.
res@gsnContourZeroLineThicknessF = 4.0	 ; Espessura do contorno zero. 
                                         ; Para eliminar o contorno zero
                                         ; basta colocar o valor zero.
res@mpCenterLonF                 = -90   ; Ponto de vista do mapa. 
res@gsnPolarLabelDistance        = 1.08  ; Distância das longitudes.
res@gsnPolarLabelFontHeightF     = 0.020 ; Altera o tamanho da fonte dos 
                                         ; rótulos de longitude.
res@cnFillOn                     = True  ; Gráfico preenchido (shaded).
res@cnLinesOn                    = False ; Desabilita as linhas de 
                                         ; contorno.
res@cnFillOpacityF               = 0.7   ; Opacidade do preenchimento. 
                                         ; 0 (mais opaco) e 
                                         ; 1 (menos opaco).
res@cnLevelSelectionMode         = "ExplicitLevels"
res@cnLevels                     = ispan(-200,200,50)
res@cnFillColors                 = (/3,4,5,6,0,0,14,15,16,17/)

plot = gsn_csm_contour_map_polar(wks,hgt(1,0,:,:),res)

end
