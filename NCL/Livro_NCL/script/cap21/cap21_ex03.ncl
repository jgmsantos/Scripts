; Nome do script: cap21_ex03.ncl

begin

f = addfile("../../dados/tair.2011.2012.nc","r")

u = short2flt(f->air)
	
u = u-273.15 ; Converte de Kelvin para Celsius.
	
wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex03")
	
res               = True
res@tiMainString  = "Temperatura do ar em 2~S~o~N~S e 300~S~o~N~W"
res@tiXAxisString = "M"+ecirc+"s"
res@tiYAxisString = "Temperatura (~S~o~N~C)"
res@trXMinF       = 1.0
res@tmXBMode      = "Explicit"
res@tmXBValues    = (/1,2,3,4,5,6,7,8,9,10,11,12/)
res@tmXBLabels    = (/"J","F","M","A","M","J","J","A","S","O","N","D"/)
res@trYMinF       =  24.0
res@trYMaxF       =  27.0
	
plot = gsn_csm_xy(wks,ispan(1,12,1),u(0:11,{1000},{-2},{300}),res)

end
