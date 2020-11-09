; Nome do script: cap20_ex24.ncl

begin

f = addfile("../../dados/SA.CRU.prec.anual.1979.2013.nc","r")
 
ppt = f->pre ; Importação da variável.

years  = ispan(1979,2013,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex24")

plot = new(2,graphic) ; Arranjo gráfico para a criação 
                      ; do painel com as duas figuras.

res            = True         ; Habilita personalização.
res@gsnDraw    = False        ; Não gera a figura.
res@gsnFrame   = False        ; Não avança o frame.
res@vpWidthF   = 0.8          ; Largura da figura.
res@vpHeightF  = 0.3          ; Altura da figura.
res@trYMinF    = 4.0          ; Mínimo valor do eixo y.
res@trYMaxF    = 5.0          ; Máximo valor do eixo y.
res@trXMinF    = min(years)   ; Mínimo valor do eixo x.
res@trXMaxF    = max(years)   ; Máximo valor do eixo x.
res@tiMainString = "Define o minimo e maximo valor dos eixos x e y"
  
plot(0)=gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico de linha.

res@tiMainString    = "Define o eixo x inferior de forma manual"
res@tmXBMode        = "Manual"    ; Define o eixo x inferior (XB) 
                                  ; de forma manual.
res@tmXBTickStartF  = res@trXMinF ; O valor que começará o tickmark 
                                  ; do eixo x inferior.

plot(1)=gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico de linha.

; Criação dos paineis.
resP                            = True
resP@gsnPanelYWhiteSpacePercent = 10    ; Espaçamento vertical entre 
                                        ; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)        ; Gera o painel.

end
