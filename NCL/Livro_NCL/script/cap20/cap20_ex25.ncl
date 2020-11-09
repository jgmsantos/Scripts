; Nome do script: cap20_ex25.ncl

begin

f = addfile("../../dados/SA.CRU.prec.anual.1979.2013.nc","r")
 
ppt = f->pre ; Importação da variável.

years  = ispan(1979,2013,1) ; Cria os valores do eixo x.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex25")

plot = new(2,graphic) ; Arranjo gráfico para a criação do painel com as
		      ; duas figuras.

res                 = True                ; Habilita personalização.
res@gsnDraw         = False               ; Não gera a figura.
res@gsnFrame        = False               ; Não avança o frame.
res@vpWidthF        = 0.8                 ; Largura da figura.
res@vpHeightF       = 0.3                 ; Altura da figura.
res@trYMinF         = 4.0                 ; Mínimo valor do eixo y.
res@trYMaxF         = 5.0                 ; Máximo valor do eixo y.
res@trXMinF         = min(years)          ; Mínimo valor do eixo x.
res@trXMaxF         = max(years)          ; Máximo valor do eixo x.
res@tmXBMode        = "Manual"	          ; Eixo x inferior (XB) de 
                                          ; forma manual.
res@tmXBTickStartF  = res@trXMinF         ; Onde começam os valores do
                                          ; eixo x.
res@tmXBTickEndF    = res@trXMaxF         ; Onde terminam os valores 
                                          ; do eixo x.
res@tmXBTickSpacingF= 5                   ; Espaçamento entre os 
                                          ; rótulos.
res@gsnLeftString   = "tmXBMode = Manual" ; Título da figura no lado 
                                          ; esquerdo.
  
plot(0)=gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico de linha.

res@tmXBMode        = "Explicit"	      ; Eixo x inferior (XB) 
                                              ; de forma explícita.
res@tmXBValues      = (/1980,1990,2000,2010/) ; Valores que vão 
                                              ; aparecer no eixo x.
res@tmXBLabels      = res@tmXBValues          ; Rótulos do eixo x 
                                              ; inferior.
res@tmXBMinorValues = ispan(1978,2014,1)      ; Intervalo do minortick
                                              ; secundário.
res@gsnLeftString   = "tmXBMode = Explicit"   ; Título da figura no 
                                              ; lado esquerdo.

plot(1)=gsn_csm_xy(wks,years,ppt(:,0,0),res) ; Gera o gráfico de linha.

; Criação dos paineis.
resP                            = True
resP@gsnPanelYWhiteSpacePercent = 10    ; Espaçamento vertical entre 
                                        ; as figuras.

gsn_panel(wks,plot,(/2,1/),resP)        ; Gera o painel.

end
