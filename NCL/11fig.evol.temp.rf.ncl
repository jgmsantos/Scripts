load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"


begin

diretorio_entrada = "./"
diretorio_saida   = "./figura/"
arquivo_texto     = "evolu_tempo_rf.txt"

nlin = numAsciiRow(diretorio_entrada+arquivo_texto) ; nlin = 25
ncol = numAsciiCol(diretorio_entrada+arquivo_texto) ; ncol = 8

f = asciiread(diretorio_entrada+arquivo_texto,(/nlin,ncol/),"float")

f@_FillValue = -999

x = f(:,0)

y = new ((/(ncol-1),nlin/),typeof(f))

do i = 0,ncol-2
   y(i,:) = f(:,i+1)
end do

wks = gsn_open_wks("png",diretorio_saida+"fig_evol_temp_rf")

res								= True
res@xyDashPatterns			= 0
res@trYMinF						= 0.0
res@trYMaxF						= 1.0
res@trXMinF						= 0.0
res@trXMaxF						= 120.0
res@tiXAxisString				= "Dias  de  Secura (PSE)  =  per"+iacute+"odo nominal sem chuva"
res@tiYAxisString				= "Risco de fogo"
;res@tiMainString				= "Evolu"+cedil+atilde+"o Temporal do Risco de Fogo"
res@tmYLMinorOn				= False
res@tmXBMinorOn				= False
res@gsnYRefLine				= 0.8
res@gsnYRefLineThicknessF   = 2.0
res@tmYLMode					= "Manual"
res@tmYLTickStartF			= res@trYMinF
res@tmYLTickEndF				= res@trYMaxF
res@tmYLTickSpacingF			= 0.1
res@tmXBMode					= "Manual"
res@tmXBTickStartF			= res@trXMinF
res@tmXBTickEndF				= res@trXMaxF
res@tmXBTickSpacingF			= 10
res@vpWidthF					= 0.8
res@vpHeightF					= 0.4
res@vpXF							= 0.15
res@vpYF							= 0.8
res@xyLineColors				= (/"springgreen4","blue","orange","gray","black","yellow","red"/)
res@xyLineThicknesses		= (/5,5,5,5,5,5,5/)
res@pmLegendDisplayMode    = "Always"
res@pmLegendSide           = "Top"
res@pmLegendParallelPosF   = 0.78
res@pmLegendOrthogonalPosF = -1.05 ; y
res@pmLegendWidthF         = 0.07
res@pmLegendHeightF        = 0.2
res@lgPerimOn              = False
res@lgLabelFontHeightF     = 0.013
;res@xyExplicitLegendLabels = (/"Everg.Broadl.Forest","Decid.Boradl.Forest", \
;                               "MixForests & Needle Forests","Woody Savannas & Closed Shrublands", \ 
;                               "Woody Savannas & Closed Shrublands","Savannas & Open Shrubland", \ 
;                               "Croplands; Crops_Nat_mosaic","Grasslands"/)

res@xyExplicitLegendLabels = (/	"7 Ombr"+oacute+"fila densa"							,\
											"6 Florestas dec"+iacute+"duas e sazonais"		,\
											"5 Floresta de contato; Campinarana"				,\			
											"4 Savana arb"+oacute+"rea; Caatinga fechada"	,\
											"3 Savana; Caatinga aberta"							,\
											"2 Agricultura e diversos"								,\								       
											"1 Pastagens e gram"+iacute+"neas"					/)

plot = gsn_csm_xy(wks,x,y,res)

;system("convert -trim -units PixelsPerCentimeter ../output/fig_evol_temp_rf.png -density 300 ../output/figura_3.3.png")

system("convert -trim -transparent white -geometry +10+10 ./figura/fig_evol_temp_rf.png ./figura/fig_evol_temp_rf.png")
system("convert -units PixelsPerInch ./figura/fig_evol_temp_rf.png -density 300 ./figura/fig01.jpg")
system("rm -f ./figura/fig_evol_temp_rf.png")

end

