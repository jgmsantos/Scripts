; Nome do script: cap19_ex05.ncl

begin

f = addfile("../../dados/precip.mon.mean.nc","r") 
 
ppt = f->precip

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex05")

plot = gsn_csm_contour_map_ce(wks,ppt,False)

end
