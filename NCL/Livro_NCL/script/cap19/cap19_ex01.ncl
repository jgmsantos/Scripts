; Nome do script: cap19_ex01.ncl

begin

f = addfile("../../dados/prec.2005.nc",) 

ppt = f->pre

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex02")

plot=gsn_csm_y(wks,ppt,False)

end
