; Nome do script: cap21_ex14.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

t = f->air ; O dado é do tipo short. Visto com ncl_filedump.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex14")

; Plota o primeiro tempo (0), primeiro nível vertical (1000hPa), 
; todas as latitudes (:) e todas longitudes (:), uma vez que, o 
; dado possui 4 dimensões.

plot = gsn_csm_contour_map_ce(wks,t(0,{1000},:,:),False)

end
