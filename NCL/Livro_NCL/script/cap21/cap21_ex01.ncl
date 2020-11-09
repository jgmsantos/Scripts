; Nome do script: cap21_ex01.ncl

begin

f = addfile("../../dados/tair.2011.2012.nc","r")
t = short2flt(f->air)
wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex01")
plot = gsn_csm_xy(wks,ispan(1,12,1),t(0:11,{1000},{-2},{300}),False)

end
