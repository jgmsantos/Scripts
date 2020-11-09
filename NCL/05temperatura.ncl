load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

f = addfile("../dados/RH2M.TEMP2M.GFS.ANL.2020051218.nc","r")

variavel = f->TEMP2m
variavel = f->TEMP2m-273.15

wks = gsn_open_wks("png","../figuras/temperatura")

gsn_define_colormap(wks,"BlAqGrYeOrRe")

res                       = True
res@cnInfoLabelOn         = False
res@cnFillOn              = True
res@cnFillMode            = "CellFill"
res@lbLabelBarOn          = True
res@gsnLeftString         = ""
res@gsnRightString        = ""
res@mpMinLonF             = -116.
res@mpMaxLonF             = -30.
res@mpMinLatF             = -60.
res@mpMaxLatF             =  30.
res@gsnMajorLonSpacing    = 10.0
res@gsnMajorLatSpacing    = 10.0
res@mpOutlineBoundarySets = "National"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineOn           = True
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels              = (/10,12,14,16,18,20,22,24,26,28,30,35,40/) ; 13 níveis
res@cnFillColors          = (/2,11,22,30,38,44,48,50,56,65,74,82,90,101/)
res@cnLinesOn             = False
res@cnLineLabelsOn        = False
res@tmYLLabelFontHeightF  = 0.015
res@tmXBLabelFontHeightF  = 0.015
res@gsnAddCyclic          = False
res@mpFillOn              = False
res@tmXBMinorOn           = False
res@cnFixFillBleed        = False

printMinMax(variavel(0,:,:),False)

plot = gsn_csm_contour_map(wks,variavel(0,:,:),res) 

end