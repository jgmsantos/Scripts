; Nome do script: cap20_ex01.ncl

begin

f = addfile("../../dados/ppt.clima.nc","r")

ppt = f->precip

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex01")

drawNDCGrid(wks) ; Desenha as linhas de grade para selecionar 
                 ; o local  da janela gráfica para mostrar 
                 ; a figura.

plot = gsn_csm_y(wks,ppt(:,0,0),False)

end
