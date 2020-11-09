; Nome do script: cap20_ex26.ncl

begin

; Abertura do arquivo de anomalia de precipitação para o ano de 
; 2013 (jan a dez).

f = addfile("../../dados/SA.CRU.anom.prec.2013.nc","r") 
 
ppt = f->pre ; Importação da variável.

years  = ispan(1,12,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex26")

res                       = True         ; Habilita personalização.
res@vpWidthF              = 0.8          ; Largura da figura.
res@vpHeightF             = 0.3          ; Altura da figura.
res@trYMinF               = -1.0         ; Mínimo valor do eixo y.
res@trYMaxF               = 1.0          ; Máximo valor do eixo y.
res@trXMinF               = min(years)-1 ; Mínimo valor do eixo x.
res@trXMaxF               = max(years)+1 ; Máximo valor do eixo x.
res@gsnXYBarChart         = True         ; Habilita gráfico de barras.
res@gsnYRefLine           = 0.           ; Linha de referência no 
                                         ; valor zero.
res@gsnAboveYRefLineColor = "Blue"       ; Cor azul para valores negativos.
res@gsnBelowYRefLineColor = "Red"        ; Cor vermelho para valores positivos.
res@trYReverse            = True         ; Inverte o eixo y.
res@tmXBLabelAngleF       = 45           ; Ângulo dos rótulos do eixo x 
                                         ; inferior (XB).
res@tmXBLabelDeltaF       = 1.5          ; Distância dos rótulos do 
                                         ; eixo x do seu eixo. 
res@tmXBLabelFontColor    = "orange"     ; Cor dos rótulos do eixo x.
  
plot=gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico de linha.

end
