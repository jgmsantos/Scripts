; Nome do script: cap19_ex07.ncl

begin

f = addfile("../../dados/precip.mon.mean.nc","r") 
 
ppt = f->precip

pptN = ppt * 30 ; mm/dia -> mm/mes

printVarSummary(pptN)

; Criação das coordenadas das dimensões latitude e longitude.
pptN!1         = "lat"
pptN!2         = "lon"
pptN&lat       = latGlobeF(72,"lat","latitude","degrees_north")
pptN&lon       = lonGlobeF(144,"lon","longitude","degrees_east")

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex07")

plot = gsn_csm_contour_map_ce(wks,pptN(6,:,:),False)

end
