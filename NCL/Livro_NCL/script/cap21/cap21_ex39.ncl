; Nome do script: cap21_ex39.ncl

begin

f = addfile("../../dados/tar.mensal.1979.1988.nc","r")

 ; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
t = short2flt(f->air)

; A dimensão nível vertical deve ser a primeira dimensão,
; por isso, foi feita a reordenação das dimensões.

tN = t(level|:,time|:,lat|:,lon|:) 

tN = tN-273.15 ; Tk->Tc

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex39")

; Plot da figura pressão (y) versus tempo (x). 
; Lat/Lon escolhida "0"/"300". Com o símbolo "{}" 
; pode-se utilizar a coordenada de latitude/longitude.

plot = gsn_csm_pres_hgt(wks,tN(:,:,{0},{300}),False) 

end
