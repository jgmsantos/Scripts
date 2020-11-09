; Nome do script: cap20_ex27.ncl

begin

f = addfile("../../dados/SA.CRU.anom.prec.2013.nc","r") 
 
ppt = f->pre ; Importação da variável.

years  = ispan(1,12,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex27")

plot = new(2,graphic) ; Arranjo gráfico para a criação do painel 
                      ; com as duas figuras.

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
res@tiMainString          = "Titulo principal1"
res@tiXAxisString         = "Titulo do eixo x1" ; Título do eixo x.
res@tiYAxisString         = "Titulo do eixo y1" ; Título do eixo y.

plot(0) = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

res@tiMainString         = "Titulo principal2" ; Título principal.
res@tiMainJust           = "CenterLeft"        ; Alinhamento do texto.
res@tiMainPosition       = "Left"              ; Posição do texto.

res@tiXAxisString        = "Titulo do eixo x2" ; Título do eixo x.
res@tiXAxisJust          = "CenterRight"       ; Alinhamento do texto. 
res@tiXAxisPosition      = "Right"             ; Posição do texto.

res@tiYAxisString        = "Titulo do eixo y2" ; Título do eixo y.
res@tiYAxisJust          = "CenterLeft"        ; Alinhamento do texto.
res@tiYAxisSide          = "Right"             ; Posição do texto.
res@tiYAxisPosition      = "Bottom"          ; Título na parte inferior  
                                             ; do eixo direito.

plot(1) = gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico.

; Criação dos paineis.
resP                            = True
resP@gsnPanelYWhiteSpacePercent = 10    ; Espaçamento vertical entre 
 					; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)        ; Gera o painel.

end
