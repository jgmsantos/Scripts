load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

f = addfile("../dados/NDSC.IMERG.2020051200.nc","r")

variavel = f->ndsc120

wks = gsn_open_wks("png","../figuras/numero_dias_sem_chuva")

gsn_define_colormap(wks,"GMT_panoply")

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
res@cnLevels              = (/2,3,4,5,10,15,20,30,40,50,60,70,80,90,100,110/) ; 17 níveis
;res@cnFillColors          = (/17,16,14,13,12,10,9,7,6,5/)
res@cnLinesOn             = False
res@cnLineLabelsOn        = False
res@tmYLLabelFontHeightF  = 0.015
res@tmXBLabelFontHeightF  = 0.015
res@gsnAddCyclic          = False
res@mpFillOn              = False
res@tmXBMinorOn           = False
res@cnFixFillBleed        = False
res@lbLabelFontHeightF	  = 0.01

printMinMax(variavel(0,:,:),False)

plot = gsn_csm_contour_map(wks,variavel(0,:,:),res) 

end