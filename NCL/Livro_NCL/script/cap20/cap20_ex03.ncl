; Nome do script: cap20_ex03.ncl

begin

f = addfile("../../dados/ppt.clima.nc","r")
g = addfile("../../dados/olr.clima.nc","r")

ppt = f->precip
olr = short2flt(g->olr)

printVarSummary(ppt) ; Imprime um resumo sobre a variável ppt.
printVarSummary(olr) ; Imprime um resumo sobre a variável olr.

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex03")

plot = gsn_csm_y(wks,ppt(:,0,0),False) ; Plot da precipitação.

plot = gsn_csm_y(wks,olr(:,0,0),False) ; Plot da OLR.

end
