; Nome do script: cap18_ex04.ncl

begin

f1 = addfile("../../dados/psfc.nc","r")
f2 = addfile("../../dados/shum.nc","r")
f3 = addfile("../../dados/uwnd.nc","r")
f4 = addfile("../../dados/vwnd.nc","r")

psfc = f1->pres(0,:,:)
qesp = short2flt(f2->shum(0,0,:,:))
uwnd = short2flt(f3->uwnd(0,0,:,:))
vwnd = short2flt(f4->vwnd(0,0,:,:))

wks = gsn_open_wks("pdf","../../figuras/cap18/cap18_ex04")

plot = new(4,graphic)

res               = True
res@gsnDraw       = False
res@gsnFrame      = False
res@mpMinLatF     = -60.0
res@mpMaxLatF     =  15.0
res@mpMinLonF     = -90.0
res@mpMaxLonF     = -30.0
res@gsnAddCyclic  = False
res@mpFillOn      = False

plot(0) = gsn_csm_contour_map_ce(wks,psfc,res)
plot(1) = gsn_csm_contour_map_ce(wks,qesp,res)
plot(2) = gsn_csm_contour_map_ce(wks,uwnd,res)
plot(3) = gsn_csm_contour_map_ce(wks,vwnd,res)

pres                 = True
pres@gsnPanelRowSpec = True

gsn_panel(wks,plot,(/1,2,1/),pres)

end 
