load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
begin

diretorio_entrada = "./"
diretorio_saida   = "./figura/"
arquivo_prec      = "PREC.IMERG.2021021800.nc"
arquivo_mcga      = "RH2M.TEMP2M.GFS.ANL.2021021818.nc"

f = addfile(diretorio_entrada+arquivo_prec,"r")
g = addfile(diretorio_entrada+arquivo_mcga,"r")

prec    = f->prec
tempsfc = g->TEMP2m
tempsfc = tempsfc-273.15
ursfc   = g->RH2m

plot = new(3,graphic)

wks = gsn_open_wks("png",diretorio_saida+"fig_prec_temp_ur")

res1                       = True 
res1@lbOrientation         = "vertical"
res1@cnLinesOn             = False
res1@tiMainString          = "Precipita"+cedil+atilde+"o (mm dia~S~-1~N~) - IMERG"
;res1@gsnLeftString         = "19/05 a 15/09/2017"
res1@gsnLeftString         = ""
;res1@gsnRightString        = "(mm/dia)"
res1@gsnRightString        = ""
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
res1@gsnDraw               = False
res1@gsnFrame              = False
res1@cnLevelSelectionMode  = "ExplicitLevels"
res1@cnLevels              = (/1,50,150,200,250,500,1000,1500,2000/)
res1@cnLevels              = (/1,2,3,4,5,10,15,20,30/)
res1@cnFillPalette         = "precip3_16lev"
res1@tmXBMinorOn           = False
res1@tmYLMinorOn           = False
res1@tmXBLabelFontHeightF     = 0.019
res1@tmYLLabelFontHeightF     = 0.019
res1@lbLabelFontHeightF = 0.03

res2                       = res1
res2@tiMainString          = "Temperatura "+agrave+" superf"+iacute+"cie (~S~o~N~C) - GFS"
;res2@gsnLeftString         = "15/09/2017"
;res2@gsnRightString        = "(~S~o~N~C)"
res2@gsnLeftString         = ""
res2@gsnRightString        = ""
res2@gsnCenterString       = ""
res2@cnLevelSelectionMode  = "ManualLevels"
res2@cnMinLevelValF        = 0
res2@cnMaxLevelValF        = 36
res2@cnLevelSpacingF       = 2
res2@lbLabelStride         = 2
res2@cnFillPalette         = "gui_default"
res2@tmXBLabelFontHeightF     = 0.019
res2@tmYLLabelFontHeightF     = 0.019
res2@lbLabelFontHeightF = res1@lbLabelFontHeightF

res3                       = res1
res3@tiMainString          = "Umidade Relativa "+agrave+" superf"+iacute+"cie (%) - GFS"
;res3@gsnLeftString         = "15/09/2017"
;res3@gsnRightString        = "(D"+eacute+"cimos)"
res3@gsnLeftString         = ""
res3@gsnRightString        = ""
res3@gsnCenterString       = ""
res3@cnLevelSelectionMode  = "ExplicitLevels"
;res3@cnLevels             := (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9/)
res3@cnLevels             := (/10,20,30,40,50,60,70,80,90/)
res3@cnFillPalette         = "grads_rainbow"
res3@tmXBLabelFontHeightF     = 0.019
res3@tmYLLabelFontHeightF     = 0.019
res3@lbLabelFontHeightF = res1@lbLabelFontHeightF

plot(0) = gsn_csm_contour_map_ce(wks,prec(0,:,:),res1)
plot(1) = gsn_csm_contour_map_ce(wks,tempsfc(0,:,:),res2)
plot(2) = gsn_csm_contour_map_ce(wks,ursfc(0,:,:),res3)

pres                                  = True
pres@gsnPanelRowSpec                  = True
;pres@gsnPanelFigureStrings            = (/"a)","b)","c)"/)
pres@amJust                           = "TopLeft"
pres@gsnPanelYWhiteSpacePercent       = 5
pres@gsnPanelXWhiteSpacePercent       = 5
pres@gsnPanelFigureStringsFontHeightF = 0.02

gsn_panel(wks,plot,(/1,2/),pres)

system("convert -trim -transparent white -geometry +10+10 ./figura/fig_prec_temp_ur.png ./figura/fig_prec_temp_ur.png")
system("convert -units PixelsPerInch ./figura/fig_prec_temp_ur.png -density 300 ./figura/fig03.jpg")
system("rm -f ./figura/fig_prec_temp_ur.png")

end
