; Nome do script: cap21_ex34.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex34")

; Plot da figura pressão (y) versus longitude (x). 
; Latitude escolhida "0". Com o símbolo "{}" pode-se
; utilizar a coordenada de latitude.

plot = gsn_csm_pres_hgt(wks,u(0,:,{0},:),False)

end
