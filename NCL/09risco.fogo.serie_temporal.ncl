load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

g = addfile("../input/RF.serie.julaout2020.nc","r")

rf = g->rf

numero_tempos = 123

wks = gsn_open_wks("png","../figuras/RF.julaout2020.serie")

res                        = True
res@trYMaxF                = 1.1
res@trYMinF                = 0.
res@tmYLMode               = "Explicit"
res@tmYLValues             = (/0,0.15,0.4,0.7,0.95,1/)
res@tmYLLabels             = (/"0","0.15","0.4","0.7","0.95","1"/)
res@trXMinF                = 1.
res@trXMaxF                = numero_tempos
res@tmXBMode               = "Explicit"
res@tmXBValues             = (/1,15,32,46,63,77,93,107,123/)
res@tmXBLabels             = (/"01jul","15jul","01ago","15ago","01set","15set","01out","15out","31out"/)
res@tiMainString           = ""
res@tiYAxisString          = "Risco de Fogo"
res@tmYLMinorOn            = False
res@tmXBMinorOn            = False
res@gsnStringFontHeightF   = 0.03 
res@xyMarkLineMode         = "MarkLines"
res@xyMarkers              = (/16/)
res@xyMarkerColors         = (/"black"/)
res@xyLineColors           = res@xyMarkerColors
res@xyLineThicknesses      = (/4/)
res@lgLabelFontHeightF     = 0.016
res@xyDashPattern          = 0
res@gsnStringFontHeightF   = 0.02
res@tmXBLabelFontHeightF   = 0.02
res@tmYLLabelFontHeightF   = 0.02
res@gsnDraw                = False
res@gsnFrame               = False
res@tmXBLabelAngleF        = 90
res@tmXBLabelJust          = "CenterRight"
res@tiMainString           = "Serra do Cip"+oacute+" - 2020"

plot = gsn_csm_xy(wks,ispan(1,numero_tempos,1),rf(:,0,0),res)

pres1                  = True
pres1@gsLineThicknessF = 3.0
pres1@gsLineColor      = "darkgreen"

pres2                  = True
pres2@gsLineThicknessF = 3.0
pres2@gsLineColor      = "chartreuse"

pres3                  = True
pres3@gsLineThicknessF = 3.0
pres3@gsLineColor      = "yellow"

pres4                  = True
pres4@gsLineThicknessF = 3.0
pres4@gsLineColor      = "orange"

pres5                  = True
pres5@gsLineThicknessF = 3.0
pres5@gsLineColor      = "red"

dum1 = gsn_add_polyline(wks,plot,(/1,numero_tempos/),(/0.15,0.15/),pres1)
dum2 = gsn_add_polyline(wks,plot,(/1,numero_tempos/),(/0.4,0.4/),pres2)
dum3 = gsn_add_polyline(wks,plot,(/1,numero_tempos/),(/0.70,0.70/),pres3)
dum4 = gsn_add_polyline(wks,plot,(/1,numero_tempos/),(/0.95,0.95/),pres4)
dum5 = gsn_add_polyline(wks,plot,(/1,numero_tempos/),(/1,1/),pres5)

draw(plot)
frame(wks)

system("convert -trim ../figuras/RF.julaout2020.serie.png ../figuras/RF.julaout2020.serie.png")

end