; Nome do script: cap21_ex15.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

t = short2flt(f->air) ; Descompactando o dado com a função
                      ; short2flt.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex15")

; Plota o primeiro tempo (0), primeiro nível vertical (1000hPa), 
; todas as latitudes (:) e todas as longitudes (:)

plot = gsn_csm_contour_map_ce(wks,t(0,{1000},:,:),False)

end
