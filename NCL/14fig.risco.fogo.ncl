load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

f = addfile("./RF.ANL.2021021800.nc.nc","r")

rbf = f->rbf(0,:,:)

wks = gsn_open_wks("png","./figura/fig_RF_20210218")

gsn_define_colormap(wks,"wgne15")

res                       = True
res@gsnAddCyclic          = False
res@mpMinLonF             = -115.
res@mpMaxLonF             = -30.
res@mpMinLatF             = -60.
res@mpMaxLatF             =  30.
res@cnFillOn              = True
res@cnLinesOn             = False
res@lbOrientation         = "Vertical"
res@mpFillOn              = False
res@cnFillMode            = "RasterFill"
res@mpOutlineBoundarySets = "National"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineOn           = True
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@gsnMajorLonSpacing    = 10
res@gsnMajorLatSpacing    = 10
res@gsnCenterString       = "Risco de Fogo Observado"
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels              = (/0.15,0.4,0.7,0.95/)
res@cnFillColors          = (/7,8,12,14,15/)
res@lbOrientation         = "horizontal"
res@lbLabelPosition       = "Center"
res@lbLabelAlignment      = "BoxCenters"
res@lbLabelStrings        =  (/"M"+iacute+"nimo","Baixo","M"+eacute+"dio","Alto","Cr"+iacute+"tico"/) 
res@vpYF                  = 0.9
res@tmXBMinorOn           = False
res@tmYLMinorOn           = False
res@tmXBLabelFontHeightF     = 0.013
res@tmYLLabelFontHeightF     = 0.013

plot = gsn_csm_contour_map(wks,rbf,res) ; Geração do mapa.

system("convert -trim -transparent white -geometry +10+10 ./figura/fig_RF_20210218.png ./figura/fig_RF_20210218.png")
system("convert -units PixelsPerInch ./figura/fig_RF_20210218.png -density 300 ./figura/fig04.jpg")
system("rm -f ./figura/fig_RF_20210218.png")

end

