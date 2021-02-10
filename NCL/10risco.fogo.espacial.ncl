load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

mes = (/"Julho","Agosto","Setembro","Outubro"/)

f = addfile("../input/RF.julaout2020.nc","r")

plot = new(dimsizes(mes),graphic)

wks  = gsn_open_wks("png","../figuras/RF.julaout.2020")

gsn_define_colormap(wks,"wgne15")

do t = 0,dimsizes(mes)-1

    print(""+mes(t))

    rf := f->rf(t,:,:)

    res                       = True
    res@gsnDraw               = False
    res@gsnFrame              = False
    res@gsnAddCyclic          = False
    res@mpMinLonF             = -43.6868
    res@mpMaxLonF             = -43.3798
    res@mpMinLatF             = -19.565
    res@mpMaxLatF             = -19.195
    res@cnFillOn              = True
    res@cnLinesOn             = False
    res@mpFillOn              = False
    res@mpOutlineBoundarySets = "National"
    res@mpDataSetName         = "Earth..4"
    res@mpDataBaseVersion     = "MediumRes"
    res@mpOutlineOn           = True
    res@mpOutlineSpecifiers   = (/"Brazil:states"/)
    res@cnLevelSelectionMode  = "ExplicitLevels"
    res@cnLevels              = (/0.15,0.4,0.7,0.95/)
    res@cnFillColors          = (/7,8,12,14,15/)
    res@gsnCenterString       = mes(t)
    res@txFontHeightF         = 0.03
    res@cnFillMode            = "RasterFill"
    res@tmXBOn                = False
    res@tmXTOn                = False
    res@tmYLOn                = False
    res@tmYROn                = False
    res@lbLabelBarOn          = False
    res@pmLabelBarHeightF     = 0.15
    res@gsnStringFontHeightF  = 0.04
    res@tmYLLabelFontHeightF  = 0.02
    res@tmXBLabelFontHeightF  = 0.02

    plot(t) = gsn_csm_contour_map(wks,rf,res)

end do

lnres                  = True
lnres@gsLineColor      = "black"
lnres@gsLineThicknessF = 3.0

line_mask = gsn_add_shapefile_polylines(wks,plot,"../shape/shp/Area_PARNA_SerraCipo.shp",lnres)

pres                            = True
pres@gsnPanelLabelBar           = True
pres@lbLabelPosition            = "Center"
pres@lbLabelAlignment           = "BoxCenters"
pres@lbLabelStrings             = (/"M"+iacute+"nimo","Baixo","M"+eacute+"dio","Alto","Cr"+iacute+"tico"/)
pres@lbLabelFontHeightF         = 0.015
pres@gsnPanelXWhiteSpacePercent = 5
pres@gsnPanelYWhiteSpacePercent = 5
pres@pmLabelBarWidthF           = 0.8
pres@pmLabelBarHeightF          = 0.15
res@gsnPanelMainString          = "2020"

gsn_panel(wks,plot,(/2,2/),pres)

system("convert -trim ../figuras/RF.julaout.2020.png ../figuras/RF.julaout.2020.png ")

end
