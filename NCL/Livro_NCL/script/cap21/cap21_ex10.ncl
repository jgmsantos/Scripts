; Nome do script: cap21_ex10.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

u = short2flt(f->air)
u = u - 273.15

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex10")

res               = True
res@gsnXYBarChart = True ; Habilita gráfico de barras.

plot = gsn_csm_xy(wks,ispan(1,12,1),u(0:11,{1000},{-2},{300}),res)

end
