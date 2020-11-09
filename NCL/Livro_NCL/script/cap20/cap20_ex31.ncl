; Nome do script: cap20_ex31.ncl

begin

f = addfile("../../dados/SA.CRU.anom.prec.2013.nc","r") 
 
ppt = f->pre ; Importação da variável.

years  = ispan(1,12,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex31")

res                            = True       ; Habilita personalização.
res@vpWidthF                   = 0.8        ; Largura da figura.
res@vpHeightF                  = 0.3        ; Altura da figura.
res@trYMinF                    = -1.0       ; Mínimo valor do eixo y.
res@trYMaxF                    = 1.0        ; Máximo valor do eixo y.
res@trXMinF                    = min(years) ; Mínimo valor do eixo x.
res@trXMaxF                    = max(years) ; Máximo valor do eixo x.
res@gsnXYBarChart              = True       ; Habilita gráfico de barras.
res@gsnYRefLine                = 0.         ; Linha de referência no 
                                            ; valor zero.
res@gsnAboveYRefLineColor      = "Red"      ; Cor vermelho para valores positivos.
res@gsnBelowYRefLineColor      = "Blue"     ; Cor azul para valores negativos.
res@gsnLeftString              = "Esquerdo" ; Adiciona texto do lado 
                                            ; esquerdo.
res@gsnCenterString            = "Centro"   ; Adiciona texto no centro.
res@gsnRightString             = "Direito"  ; Adiciona texto do lado 
                                            ; direito.
res@gsnLeftStringFontHeightF   = 0.02       ; Tamanho da fonte do título 
                                            ; do lado esquerdo.
res@gsnCenterStringFontHeightF = 0.025      ; Tamanho da fonte do título 
                                            ; central.
res@gsnRightStringFontHeightF  = 0.03       ; Tamanho da fonte do título 
                                            ; do lado direito.

plot = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

end
