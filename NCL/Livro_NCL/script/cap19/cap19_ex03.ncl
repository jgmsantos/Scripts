; Nome do script: cap19_ex03.ncl

begin

f = addfile("../../dados/prec.2005.nc","r") 
 
ppt = f->pre

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex03")

res = True

plot=gsn_csm_y(wks,ppt,res)

end
