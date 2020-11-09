; Nome do script: cap18_ex07.ncl

begin

f1 = addfile("../../dados/uwnd.nc","r")
f2 = addfile("../../dados/vwnd.nc","r")

uwnd = short2flt(f1->uwnd(0,0,:,:))
vwnd = short2flt(f2->vwnd(0,0,:,:))

wks = gsn_open_wks("pdf","../../figuras/cap18/cap18_ex07")

plot = new(2,graphic)

res                      = True
res@gsnDraw              = False
res@gsnFrame             = False
res@mpMinLatF            = -60.0
res@mpMaxLatF            =  15.0
res@mpMinLonF            = -90.0
res@mpMaxLonF            = -30.0
res@gsnAddCyclic         = False
res@cnInfoLabelOn        = False
res@cnFillOn             = True
res@lbLabelBarOn         = False
res@mpFillOn             = False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -8.0
res@cnMaxLevelValF       = 8.0
res@cnLevelSpacingF      = 1.0

plot(0) = gsn_csm_contour_map_ce(wks,uwnd,res)
plot(1) = gsn_csm_contour_map_ce(wks,vwnd,res)

pres                                = True
pres@gsnPanelFigureStrings          = (/"a)","b)"/)
pres@txString                       = "Titulo principal do painel"
pres@gsnPanelLabelBar               = True
pres@amJust                         = "TopRight"
pres@gsnPanelFigureStringsPerimOn   = False

gsn_panel(wks,plot,(/1,2/),pres)

end 
