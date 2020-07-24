load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
begin

;x=$(ls *.nc | tail -120 | xargs)
;cdo -s mergetime $x tmp01.nc
;cdo timsum tmp01.nc prec.acum.nc 
;rm -f tmp01.nc prec.acum.nc

f = addfile("../GeoTOPOAmericaSulCentral_V2.nc","r")

prec    = f->Band1

wks1 = gsn_open_wks("png","../output/fig_topografia")

res1                       = True 
res1@lbOrientation         = "vertical"
res1@cnLinesOn             = False
res1@tiMainString          = "Precipita"+cedil+atilde+"o acumulada - IMERG"
res1@gsnLeftString         = "15/12/2019 a 12/04/2020"
res1@gsnRightString        = "(mm/dia)"
res1@gsnCenterString       = ""
res1@mpMinLonF             = -115.
res1@mpMaxLonF             = -30.
res1@mpMinLatF             = -60.
res1@mpMaxLatF             =  30.
res1@cnFillOn              = True
res1@mpOutlineBoundarySets = "National"
res1@gsnMajorLonSpacing    = 10
res1@gsnMajorLatSpacing    = 10
res1@mpDataSetName         = "Earth..4"
res1@mpDataBaseVersion     = "MediumRes"
res1@mpOutlineOn           = True
res1@mpOutlineSpecifiers   = (/"Brazil:states"/)
res1@gsnAddCyclic          = False
res1@cnLevelSelectionMode  = "ExplicitLevels"
res1@cnLevels              = (/1,50,150,200,250,500,1000,1500,2000/)
res1@cnFillPalette         = "precip3_16lev"
res1@tmXBMinorOn           = False
res1@tmYLMinorOn           = False
res1@tmXBLabelFontHeightF     = 0.015
res1@tmYLLabelFontHeightF     = 0.015

plot = gsn_csm_contour_map_ce(wks1,prec,res1)

system("convert -trim -transparent white -geometry +10+10 ../output/fig_prec.png ../output/fig_prec.png")

end
