load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

usuario = systemfunc("echo $HOME | cut -d / -f3")

f = addfile("../focos.nc","r")

nf = f->nf

wks = gsn_open_wks("png","../output/fig_focos_queimadas")

gsn_define_colormap(wks,"GMT_panoply")

res                       = True
res@vpYF                     = 0.9
res@cnFillOn                 = True
res@cnFillMode               = "RasterFill"
res@cnLinesOn                = False
res@lbLabelBarOn          = True
res@lbOrientation        = "vertical"
res@pmLabelBarHeightF        =  0.75
res@pmLabelBarWidthF         =  0.15
res@pmLabelBarOrthogonalPosF = 0.02
res@pmLabelBarParallelPosF   = 0.5
res@gsnLeftString         = ""
res@gsnRightString        = ""
res@mpMinLonF             = -120.
res@mpMaxLonF             = -33.
res@mpMinLatF             = -56.
res@mpMaxLatF             =  32.
res@gsnMajorLonSpacing    = 10.0
res@gsnMajorLatSpacing    = 10.0
res@mpOutlineBoundarySets = "National"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineOn           = True
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels              = (/1,2,3,4,5,10,15,20,30/)
res@cnFillColors          = (/0,9,10,11,12,13,14,15,16,17/)
res@cnLinesOn             = False
res@cnLineLabelsOn        = False
res@gsnStringFontHeightF  = 0.03
res@tmXBLabelFontHeightF     = 0.015
res@tmYLLabelFontHeightF     = 0.015
res@gsnAddCyclic          = False
res@mpFillOn              = False
res@tmXBMinorOn           = False
res@cnFixFillBleed        = False

plot = gsn_csm_contour_map(wks,nf(0,:,:),res) 

system("convert -trim -transparent white -geometry +10+10 ../output/fig_focos_queimadas.png ../output/fig_focos_queimadas.png")

end
