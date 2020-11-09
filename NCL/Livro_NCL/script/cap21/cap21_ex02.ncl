; Nome do script: cap21_ex02.ncl

begin

f = addfile("../../dados/tair.2011.2012.nc","r")

u = short2flt(f->air)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex02")

res               = True
res@tiMainString  = "Temperatura do Ar"
res@tiXAxisString = "M"+ecirc+"s"
res@tiYAxisString = "Temperatura (K)"

plot = gsn_csm_xy(wks,ispan(1,12,1),u(0:11,{1000},{-2},{300}),res)

end
