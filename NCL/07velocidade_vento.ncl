load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"

begin

f = addfile("../dados/VENTO10M.GFS.ANL.2020051218.nc","r")

u = f->u10m
v = f->v10m

wspd = wind_speed(u,v)

wks = gsn_open_wks("png","../figuras/velocidade_vento")

gsn_define_colormap(wks,"GMT_panoply")

resv							= True
resv@gsnDraw					= False
resv@gsnFrame					= False
resv@vcRefLengthF				= 0.020
resv@vcRefMagnitudeF			= 5.0
resv@gsnLeftString				= ""
resv@gsnCenterString			= ""
resv@gsnRightString				= ""
resv@lbOrientation				= "vertical"
resv@vcRefAnnoOrthogonalPosF	= -1.0
resv@vcGlyphStyle				= "CurlyVector"
resv@vcLineArrowThicknessF		= 2.0
resv@lbTitleString				= "(m/s)"
resv@lbTitlePosition			= "Top"
resv@lbTitleFontHeightF			= 0.025
resv@vcLevelSelectionMode		= "ManualLevels"
resv@vcMinLevelValF				= 0.0
resv@vcMaxLevelValF				= 40.0
resv@vcLevelSpacingF			= 10.0
resv@vcMinDistanceF 			= 0.015
resv@vcGlyphStyle				= "WindBarb"

resc						= True
resc@gsnDraw				= False
resc@gsnFrame				= False
resc@cnFillOn				= True
resc@cnLinesOn				= False
resc@mpMinLonF              = -116.
resc@mpMaxLonF              = -30.
resc@mpMinLatF              = -60.
resc@mpMaxLatF              =  30.
resc@gsnMajorLonSpacing     = 10.0
resc@gsnMajorLatSpacing     = 10.0
resc@gsnLeftString			= ""
resc@gsnCenterString		= ""
resc@gsnRightString			= ""
resc@tmXBMinorOn			= False
resc@tmYLMinorOn			= False
resc@cnLevelSelectionMode	= "ExplicitLevels"
resc@cnLevels				= (/2,4,6,8,10,15,20,30,40/) ; 9 níveis
resc@cnFillColors			= (/16,15,14,13,12,10,9,7,6,5/)
resc@cnLevelSpacingF		= 100.0
resc@cnFillPalette			= "prcp_1"
resc@gsnAddCyclic			= False

printMinMax(wspd(0,:,:),False)

plot1  = gsn_csm_contour_map(wks,wspd(0,:,:),resc) 
plot2 = gsn_csm_vector(wks,u(0,:,:),v(0,:,:),resv)

overlay(plot1,plot2)

draw(plot1)
frame(wks)

end