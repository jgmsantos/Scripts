; Nome do script: cap21_ex42.ncl

begin

f = addfile("../../dados/uwnd.mensal.2000.2005.nc","r")

timeUnits = f->time@units

; Tempo inicial no formato AAAA,MM,DD,HH,MM,SS,unidade do tempo e 
; 0 (não tem nenhum efeito).

ti = cd_inv_calendar(2000,01,01,00,00,00,timeUnits,0) 
tf = cd_inv_calendar(2001,12,01,00,00,00,timeUnits,0) 

u = short2flt(f->uwnd({ti:tf},:,:,:))

; uN teve a ordem das dimensões alterada de time, level, lat, lon 
; para level, time, lat, lon.
 
uN = u(level|:,time|:,lat|:,lon|:)

uN&time = ut_convert( uN&time, timeUnits )

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex42")

gsn_define_colormap(wks,"BlWhRe")

res                              = True
res@tmXBLabelAngleF              = -90
res@tmXBLabelJust                = "CenterRight"
res@cnFillOn                     = True  
res@cnLinesOn                    = False 
res@gsnSpreadColors              = True
res@cnLevelSelectionMode         = "ManualLevels"
res@cnMinLevelValF               = -90.
res@cnMaxLevelValF               =  90.
res@cnLevelSpacingF              =  5
res@tmYRTickSpacingF             = 2
res@pmLabelBarOrthogonalPosF     = -0.063
res@gsnLeftString                = ""
res@gsnCenterString              = ""
res@gsnRightString               = ""
res@tiMainString                 = "Vento zonal (m s~S~-1~N~)"
res@tiYAxisString                = "Press"+atilde+"o (hPa)"
res@tmYRMode                     = "Automatic"

; Personaliza o eixo x (dimensão tempo).
resTick                = True
resTick@ttmFormat      = "%c%Y" ; %c é o mês no formato 
                                ; Mmm (Jan) e %Y é o ano no 
                                ; formato AAAA (2000). 
resTick@ttmAxis        = "XB"   ; XB = eixo "X" e "B" = bottom.
resTick@ttmMajorStride = 2      ; Intervalo dos rótulos do eixo x.

time_axis_labels(uN&time,res,resTick)

plot = gsn_csm_pres_hgt(wks,uN(:,:,{0},{300}),res) 

end
