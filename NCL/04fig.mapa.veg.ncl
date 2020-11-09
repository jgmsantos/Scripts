load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
begin

; Para consertar o mapa de vegetação:
; cdo -f nc -remaplaf,IGBP_MAPBIOMA_2016_v2.3_BR_001_RF.nc -gtc,0 -topo topo.nc
; ncatted -a missing_value,Band1,d,c,"" -a _FillValue,Band1,d,c,"" IGBP_MAPBIOMA_2016_v2.3_BR_001_RF.nc tmp1.nc
; cdo setmissval,-999 tmp1.nc tmp2.nc
; cdo ifthen topo.nc tmp2.nc tmp3.nc

diretorio_entrada = "/mnt/vol_queimadas_1/produtos/meteorologia/mapa_veg/MCD12Q1v6_MAPBIOMAv3.0/1km/"
diretorio_entrada = "../"
diretorio_saida   = "../output/"
arquivo_veg       = "IGBP_c6_MAPBIOMA_v3_2017_001_RF_cnew.nc"

colorscheme = (/"cadetblue1", "gold", "mistyrose","tan1","red","green","royalblue","darkgreen"/) 
; Classe					0				1			2			  3	  4		5			6				7

info = (/                               \
        " 7 Ombr"+oacute+"fila densa"                     ,\ 
        " 6 Florestas dec"+iacute+"duas e sazonais"      ,\
        " 5 Floresta de contato; Campinarana"       ,\
        " 4 Savana arb"+oacute+"rea; Caatinga fechada"      ,\
        " 3 Savana; Caatinga aberta"       ,\
        " 2 Agricultura e diversos"             ,\
        " 1 Pastagens e gram"+iacute+"neas"          ,\
        " 0 Gelo ou Corpos de "+aacute+"gua"           /)

ninfo = dimsizes(info) 

f = addfile(diretorio_entrada+arquivo_veg,"r")

veg = f->Band1

wks = gsn_open_wks("png",diretorio_saida+"fig_mapa_veg")

res1                          = True 
res1@gsnDraw                  = False
res1@gsnFrame                 = False
res1@cnFillOn                 = True
res1@cnFillMode               = "RasterFill"
res1@cnLinesOn                = False
res1@cnLevelSelectionMode     = "ExplicitLevels"
res1@cnLevels                 = tobyte(ispan(1,ninfo-1,1))
res1@cnFillPalette            = colorscheme
res1@gsnSpreadColors          = False
res1@lbOrientation            = "vertical" 
res1@lbLabelPosition          = "Center"
res1@lbLabelAlignment         = "BoxCenters"
res1@lbLabelStrings           = ispan(0,ninfo,1)  
res1@pmLabelBarHeightF        =  0.75
res1@pmLabelBarWidthF         =  0.15
res1@pmLabelBarOrthogonalPosF = 0.02
res1@pmLabelBarParallelPosF   = 0.56
res1@lbTitleOn                =  True
res1@lbTitleString            = ""
;res1@tiMainString             = "Mapa de vegeta"+cedil+atilde+"o"
res1@gsnLeftString            = ""
res1@gsnRightString           = ""
res1@gsnCenterString          = ""
res1@mpMinLonF                = -120.
res1@mpMaxLonF                = -33.
res1@mpMinLatF                = -56.
res1@mpMaxLatF                =  32.
res1@mpOutlineBoundarySets    = "National"
res1@gsnMajorLonSpacing       = 10
res1@gsnMajorLatSpacing       = 10
res1@mpOutlineOn              = True
res1@gsnAddCyclic             = False
res1@tmXBMinorOn              = False
res1@tmYLMinorOn              = False
res1@vpYF                     = 0.9
res1@mpDataSetName            = "Earth..4"
res1@mpDataBaseVersion        = "MediumRes"
res1@mpOutlineSpecifiers      = (/"Brazil:states"/)
res1@lbTitleFontHeightF       = .017
res1@lbTitleDirection         = "Across"
res1@lbLabelFont              = "Helvetica-Bold"
res1@tmXBLabelFontHeightF     = 0.015
res1@tmYLLabelFontHeightF     = 0.015

plot = gsn_csm_contour_map_ce(wks,veg,res1)

rtxt               = True
rtxt@txJust        = "TopLeft"
rtxt@txFontHeightF = 0.012

nrow = 8
ncol = 1

n  = -1
xx = 0.1 ; arbitrary

do nc=0,ncol-1
   yy = 0.45
   do nr=0,nrow-1
      n = n+1
      if (n.le.(ninfo-1)) then
         gsn_text_ndc (wks,info(n),xx,yy,rtxt)
         yy = yy - 3*rtxt@txFontHeightF
      end if
   end do
   xx = xx + 0.25
end do

draw(plot)
frame(wks)

;system("convert -trim -units PixelsPerCentimeter ../output/fig_mapa_veg.png -density 300 ../output/fig_mapa_veg.png")

system("convert -trim -transparent white -geometry +10+10 ../output/fig_mapa_veg.png ../output/fig_mapa_veg.png")

end
