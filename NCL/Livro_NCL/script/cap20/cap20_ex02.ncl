; Nome do script: cap20_ex02.ncl

begin

f = addfile("../../dados/ppt.clima.nc","r")

ppt = f->precip

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex02")

drawNDCGrid(wks) ; Desenha as linhas de grade para selecionar o local 
                 ; da janela gráfica para mostrar a figura.

res           = True
res@vpWidthF  = 0.7   ; Largura da figura.
res@vpHeightF = 0.4   ; Altura da figura.
res@vpXF      = 0.2   ; Posição x onde será desenhada a figura.
res@vpYF      = 0.6   ; Posição y onde será desenhada a figura.

plot = gsn_csm_y(wks,ppt(:,0,0),res)

end
