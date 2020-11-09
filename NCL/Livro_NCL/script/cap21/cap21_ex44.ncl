; Nome do script: cap21_ex44.ncl

begin

a = addfile("../../dados/precip.mon.mean.nc","r")

dSizes = getfiledimsizes(a)  

p = a->precip(0,:,:) ; [time | 442] x [lat | 72] x [lon | 144]

p&lon = p&lon-360    ; O dado precisa estar no formato -180 a 180
                     ; por causa do shapefile que trabalha apenas
                     ; neste formato de longitude. Por isso, a 
                     ; conversão para o formato -180 to 180.

; Importação do shapefile.
data_mask = shapefile_mask_data(p,\
            "../../dados/bacia_amaz/amazlm_1608.shp",True)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex44")

res                       = True
res@gsnAddCyclic          = False
res@mpMinLonF             = -90.0 
res@mpMaxLonF             = -30.0 
res@mpMinLatF             = -40.0
res@mpMaxLatF             = 10.0 
res@gsnDraw               = False
res@gsnFrame              = False
res@mpDataBaseVersion     = "MediumRes"
res@mpFillOn              = False
res@mpOutlineBoundarySets = "National"

; Personalização da linha do shapefile.
lnres                     = True
lnres@gsLineColor         = "blue"
lnres@gsLineThicknessF    = 2.0

; Gera o mapa de precipitação mascarado com o uso do shapefile.
map_mask = gsn_csm_contour_map(wks,data_mask,res)

; Adiciona a linha do contorno do shapefile ao gráfico.
line_mask = gsn_add_shapefile_polylines(wks,map_mask,\
            "../../dados/bacia_amaz/amazlm_1608.shp",lnres)

draw(map_mask)
frame(wks)

end
