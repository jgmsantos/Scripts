; Nome do script: cap21_ex11.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

u = short2flt(f->air)
u = u - 273.15

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex11")

res                       = True
res@gsnXYBarChart         = True    ; Habilita o gráfico de barras.
res@trYMaxF               = 28.     ; Máximo valor de y.
res@trYMinF               = 22.     ; Mínimo valor de y.
res@gsnXYBarChartColors   = "navy"  ; Cor da barra.
res@gsnXYBarChartBarWidth = 0.60    ; Espaçamento entre as barras.
res@tmXBMode              = "Explicit"
res@tmXBValues            = (/1,2,3,4,5,6,7,8,9,10,11,12/)
res@tmXBLabels            = (/"J","F","M","A","M","J","J","A","S",\
                              "O","N","D"/)
res@tiMainString          = "Temperatura do ar em Lat: 2~S~o~N~S e " +\
                            "Lon: 300~S~o~"
res@tiXAxisString         = "M"+ecirc+"s"
res@tiYAxisString         = "Temperatura (~S~o~N~C)"

plot = gsn_csm_xy(wks,ispan(1,12,1),u(0:11,{1000},{-2},{300}),res)

end
