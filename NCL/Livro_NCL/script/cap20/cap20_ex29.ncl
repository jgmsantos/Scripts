; Nome do script: cap20_ex29.ncl

begin

f = addfile("../../dados/SA.CRU.anom.prec.2013.nc","r") 
 
ppt = f->pre ; Importação da variável.

years  = ispan(1,12,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex29")

res                       = True       ; Habilita personalização.
res@vpWidthF              = 0.8        ; Largura da figura.
res@vpHeightF             = 0.3        ; Altura da figura.
res@trYMinF               = -1.0       ; Mínimo valor do eixo y.
res@trYMaxF               = 1.0        ; Máximo valor do eixo y.
res@trXMinF               = min(years) ; Mínimo valor do eixo x.
res@trXMaxF               = max(years) ; Máximo valor do eixo x.
res@gsnXYBarChart         = True       ; Habilita gráfico de barras.
res@gsnYRefLine           = 0.         ; Linha de referência no valor
                                       ; zero.
res@gsnAboveYRefLineColor = "Red"      ; Cor vermelho para valores positivos.
res@gsnBelowYRefLineColor = "Blue"     ; Cor azul para valores negativos.
res@tiMainString          = "Titulo principal"; Título principal.
res@tiXAxisString         = "Eixo x"          ; Título do eixo x.
res@tiYAxisString         = "Eixo y"          ; Título do eixo y.
res@tiMainFontHeightF     = 0.05              ; Tamanho da fonte do 
                                              ; título principal.
res@tiXAxisFontHeightF    = 0.03 ; Tamanho da fonte do título do eixo x.
res@tiYAxisFontHeightF    = 0.03 ; Tamanho da fonte do título do eixo y.

plot = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

end
