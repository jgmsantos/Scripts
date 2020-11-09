; Nome do script: cap21_ex13.ncl

begin

f = addfile("../../dados/anom.SA.GPCP.prec.1979.2014.nc","r")

time    = f->time            ; time:units = "days since 1990-1-1 00:00:00"
TIME    = cd_calendar(time, 0); Tipo float.
year    = toint(TIME(:,0))    ; Guarda o ano.
month   = toint(TIME(:,1))    ; Guarda o mês.
day     = toint(TIME(:,2))    ; Guarda o dia.
ddd     = day_of_year(year,month,day) ; Retorna o dia do ano no formato 
                                      ; 365 ou 366 dias.
YYYYMM  = year*100 + month     
anoi    = 200001            ; Data inicial no formato AAAAMM. Altere aqui.
anof    = 200312             ; Data final no formato AAAAMM. Altere aqui.
datai   = ind(YYYYMM.eq.anoi); Índice que será utilizado na dimensão tempo
dataf   = ind(YYYYMM.eq.anof); para selecionar o período de interesse.
nt      = (dataf-datai)+1    ; Número total de tempos que será utilizado.
dt      = 0.15               ; Incremento para "desenhar" as barras.

x = fspan(datai-dt,dataf-dt,nt) ; Valores de x para a primeira curva.

y = f->precip(datai:dataf,0,0); Seleciona o tempo de interesse para y.   
                             ; Houve redução de dimensão de 3 para 1,
                             ; pois o objetivo é gerar uma série temporal.

printVarSummary(y)            ; Dimensions and sizes: [time | 12]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex13")

; Recursos para os eixos x e y.
res                       = True
res@gsnXYBarChart         = True          ; Habilita gráfico de barra.
res@tmXBLabelAngleF       = -90           ; Inclinação do eixo x.
res@tmXBLabelJust         = "CenterRight" ; Alinhamento do eixo x.
res@tmXBLabelStride       = 2             ; Ajusta quantos valores serão 
                                          ; mostrados no eixo x.
res@trXMinF               = datai-1       ; Mínimo valor do eixo x.
res@trXMaxF               = dataf+1       ; Máximo valor do eixo x.
res@trYMaxF               = 1.0           ; Máximo valor do eixo y.
res@trYMinF               = -1.0          ; Mínimo valor do eixo y.
res@tmYLMode              = "Manual"      ; Formato o eixo y do meu jeito.
res@tmYLTickStartF        = res@trYMinF
res@tmYLTickSpacingF      = 0.5
res@tmYLTickEndF          = res@trYMaxF
res@tmXBMode              = "Explicit"    ; Formata o eixo x do meu jeito.
res@tmXBValues            = ispan(datai,dataf,1)
res@tmXBLabels            = YYYYMM(datai:dataf:1)
res@tiYAxisString         = "Anomalia de precipita"\
                            +cedil+atilde+"o (mm dia ~S~-1~N~)"
res@tiMainString          = "Anomalia mensal do GPCP"  
res@gsnXYBarChartBarWidth = 0.5  ; Largura das barras.
res@tmYLMinorOn           = False; Desliga os traços secundários do y.
res@tmYLLabelFontHeightF  = 0.02 ; tamanho do texto do eixo y.
res@tmXBLabelFontHeightF  = 0.02 ; tamanho do texto do eixo x.
res@vpXF                  = 0.145; Onde desenhar o gráfico em 
res@vpYF                  = 0.75 ; coordenadas NDC.
res@vpHeightF             = 0.43 ; Altura da figura.
res@vpWidthF              = 0.83 ; Largura da figura.
res@gsnYRefLine           = 0.   ; Linha de referência no valor zero.
res@gsnAboveYRefLineColor = "red"; Valor positivo preenche com vermelho.
res@gsnBelowYRefLineColor = "blue"; Valor negativo preenche com azul.

plot = gsn_csm_xy(wks,x,y,res)

end
