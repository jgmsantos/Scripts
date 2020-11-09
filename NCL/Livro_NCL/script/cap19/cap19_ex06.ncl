; Nome do script: cap19_ex06.ncl

begin

f = addfile("../../dados/precip.mon.mean.nc","r") 
 
ppt = f->precip

pptN = ppt * 30 ; mm/dia -> mm/mes

printVarSummary(pptN)

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex06")

plot = gsn_csm_contour_map_ce(wks,pptN(6,:,:),False)

end
