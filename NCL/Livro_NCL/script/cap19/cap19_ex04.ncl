; Nome do script: cap19_ex04.ncl

begin

f = addfile("../../dados/prec.2005.nc","r")
 
ppt = f->pre ; Importação da variável.

wks = gsn_open_wks("pdf","../../figuras/cap19/cap19_ex04")

x =ispan(1,15,1) ; Definindo o eixo x do gráfico. 
                 ; Vetor com 15 posições.

res = True

plot = gsn_csm_xy(wks,x,ppt(:,0,0),res)

end
