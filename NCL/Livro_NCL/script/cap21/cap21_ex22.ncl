; Nome do script: cap21_ex22.ncl

begin

f = addfile("../../dados/hgt.jan.mar.1979.nc","r") 

; short hgt ( time, level, lat, lon ) = 3, 1, 144, 73
hgt = short2flt(f->hgt) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex22")

res                 = True
res@gsnPolar        = "SH"  ; Hemisfério a ser visualizado.
res@cnFillOn        = True  ; Gráfico do tipo shaded.
res@mpFillOn        = False ; Mapa com fundo branco.
res@cnLinesOn       = False ; Desabilita as linhas de contorno.
res@cnFillMode      = "RasterFill" ; Não interpola o dado (grfill do 
                                   ; GrADS).
res@tiMainString    = "Altura geopotencial em 500hPa" + \
                      " - Fevereiro/1979"
res@gsnCenterString = ""
res@gsnLeftString   = ""
res@gsnRightString  = ""

plot = gsn_csm_contour_map_polar(wks,hgt(1,0,:,:),res)

end
