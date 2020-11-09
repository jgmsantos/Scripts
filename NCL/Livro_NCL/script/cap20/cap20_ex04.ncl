; Nome do script: cap20_ex04.ncl

begin

f = addfile("../../dados/ppt.clima.nc","r")
g = addfile("../../dados/olr.clima.nc","r")

ppt = f->precip
olr = short2flt(g->olr)

printVarSummary(ppt) ; Imprime um resumo sobre a variável ppt.
printVarSummary(olr) ; Imprime um resumo sobre a variável olr.

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex04")

res           = True
res@gsnFrame  = False ; Não avança o frame.
res@vpWidthF  = 0.4   ; Largura da figura.
res@vpHeightF = 0.4   ; Altura da figura.
res@vpXF      = 0.08  ; Posição x onde será desenhada a primeira 
                      ; figura.

plot = gsn_csm_y(wks,ppt(:,0,0),res) ; Plot da precipitação.

res@vpXF      = 0.57  ; Posição x onde será desenhada a segunda 
                      ; figura.

plot = gsn_csm_y(wks,olr(:,0,0),res)

frame(wks)

end
