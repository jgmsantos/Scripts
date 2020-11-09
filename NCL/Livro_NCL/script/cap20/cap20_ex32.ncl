; Nome do script: cap20_ex32.ncl

begin

f = addfile("../../dados/SA.CRU.anom.prec.2013.nc","r") 
 
ppt = f->pre ; Importação da variável.

years  = ispan(1,12,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex32")

plot = new(2,graphic) ; Arranjo gráfico para a criação do painel com 
                      ; as duas figuras.

res                       = True       ; Habilita personalização.
res@gsnDraw               = False      ; Não gera a figura.
res@gsnFrame              = False      ; Não avança o frame.
res@vpWidthF              = 0.8        ; Largura da figura.
res@vpHeightF             = 0.3        ; Altura da figura.
res@trYMinF               = -1.0       ; Mínimo valor do eixo y.
res@trYMaxF               = 1.0        ; Máximo valor do eixo y.
res@trXMinF               = min(years) ; Mínimo valor do eixo x.
res@trXMaxF               = max(years) ; Máximo valor do eixo x.
res@gsnXYBarChart         = True       ; Habilita gráfico de barras.
res@gsnYRefLine           = 0.         ; Linha de referência no 
                                       ; valor zero.
res@gsnAboveYRefLineColor = "Red"      ; Cor vermelho para valores positivos.
res@gsnBelowYRefLineColor = "Blue"     ; Cor azul para valores negativos.
res@gsnLeftString         = "Esquerdo" ; Adiciona texto do lado 
                                       ; esquerdo da figura.
res@gsnCenterString       = "Centro"   ; Adiciona texto no centro 
                                       ; da figura.
res@gsnRightString        = "Direito"  ; Adiciona texto do lado direito
                                       ; da figura.
res@gsnStringFontHeightF  = 0.03       ; Altera o tamanho da fonte 
                                       ; dos títulos esquerdo, central
                                       ; e direito simultaneamente.
res@tiYAxisOn             = False      ; Desliga o título do eixo y.

plot(0) = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

; Desloca a posição do texto da parte central na direção y. Caso fosse
; necessário alterar o lado direito ou esquerdo, basta alterar o nome 
; para Right ou Left, respectivamente.

res@gsnCenterStringOrthogonalPosF = 0.08

plot(1) = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

panres                            = True
panres@gsnPanelYWhiteSpacePercent = 10.0

gsn_panel(wks,plot,(/2,1/),panres)  

end
