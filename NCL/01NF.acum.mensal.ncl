load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

system("cdo -s remapbil,../dados/NF.AQUA.ACUM.MENSAL.2020.nc ../dados/so.Brasil.20km.nc ../dados/mask01.nc")
system("cdo -s ifthen ../dados/mask01.nc ../dados/NF.AQUA.ACUM.MENSAL.2020.nc ../dados/out.nc")

f = addfile("../dados/out.nc","r")

nf = f->nf

wks = gsn_open_wks("png","../figuras/NF.AQUA.ACUM.MENSAL")

gsn_define_colormap(wks,"gui_default")

res                       = True
res@cnInfoLabelOn         = False
res@cnFillOn              = True
res@cnFillMode            = "CellFill"
res@gsnLeftString         = ""
res@gsnRightString        = ""
res@mpMinLonF             = -75.
res@mpMaxLonF             = -34.
res@mpMinLatF             = -35.
res@mpMaxLatF             =  6.
res@gsnMajorLonSpacing    = 10.0
res@gsnMajorLatSpacing    = 5.0
res@mpOutlineBoundarySets = "National"
res@mpDataSetName         = "Earth..4"
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineOn           = True
res@mpOutlineSpecifiers   = (/"Brazil:states"/)
res@cnLevelSelectionMode  = "ExplicitLevels"
res@cnLevels              = (/2,4,6,8,10/)
res@cnFillColors          = (/16,17,18,19,20,23/)
res@cnLinesOn             = False
res@cnLineLabelsOn        = False
res@gsnStringFontHeightF  = 0.03
res@tmYLLabelFontHeightF  = 0.02
res@tmXBLabelFontHeightF  = 0.02
res@gsnAddCyclic          = False
res@mpFillOn              = False
res@tmXBMinorOn           = False
res@cnFixFillBleed        = False
;res@tmXBOn                = False
;res@tmXTOn                = False
;res@tmYLOn                = False
;res@tmYROn                = False
res@mpNationalLineColor   = "black"
res@mpOutlineBoundarySets = "NoBoundaries" ; Não desenha os limites dos países.

printMinMax(nf(4,:,:),False)

res@gsnCenterString = "Acumulado Mensal: 01 a 12 de maio"

plot = gsn_csm_contour_map(wks,nf(4,:,:),res) 

system("convert -trim ../figuras/NF.AQUA.ACUM.MENSAL.png ../figuras/NF.AQUA.ACUM.MENSAL.png")

end