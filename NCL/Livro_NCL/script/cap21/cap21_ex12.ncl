; Nome do script: cap21_ex12.ncl

begin

; float precip(time, lat, lon)
f1 = addfile("../../dados/SA.GPCP.prec.1979.2013.nc","r")
; float precip(time, lat, lon)
f2 = addfile("../../dados/SA.CRU.prec.1979.2013.nc","r")  

; f1 =  Dimensions and sizes: [time | 420] x [lat | 1] x [lon | 1]
; f2 =  Dimensions and sizes: [time | 420] x [lat | 1] x [lon | 1]

; O dado possui time,lat,lon apesar de ser um dado pontual, é necessário
; fixar a lat e a lon para que ocorra a redução de dimensão de 3 para 
; apenas 1, no caso, a dimensão time. Por isso, é importante conhecer 
; o dado antes de realizar qualquer tarefa.
 
;***********************************************************************
; Leitura da dimensão tempo para criar os rótulos do eixo x.
;***********************************************************************
time    = f1->time          
TIME    = cd_calendar(time, 0) ; Tipo float.
year    = toint(TIME(:,0))     ; Guarda o ano.
month   = toint(TIME(:,1))     ; Guarda o mês.
day     = toint(TIME(:,2))     ; Guarda o dia.
ddd     = day_of_year(year,month,day) ; Retorna o dia do ano no formato 
                                      ; 365 ou 366 dias.
YYYYMM  = year*100 + month     
anoi    = 197901               ; Data inicial no formato AAAAMM.
anof    = 198012               ; Data final no formato AAAAMM.
datai   = ind(YYYYMM.eq.anoi)  ; Índice que será utilizado na dimensão 
                               ; tempo para selecionar o período de 
dataf   = ind(YYYYMM.eq.anof)  ; interesse.
nt      = (dataf-datai)+1      ; Número total de tempos.
dt      = 0.15                 ; Incremento para "desenhar" as barras.

x1 = fspan(datai-dt,dataf-dt,nt) ; Valores de x para a primeira curva.
x2 = fspan(datai+dt,dataf+dt,nt) ; Valores de x para a segunda curva.

y1 = f1->precip(datai:dataf,0,0) ; Tempo de interesse para y1.   
y2 = f2->pre(datai:dataf,0,0)    ; Houve redução de dimensão de 3 para 
                                 ; 1, pois o objetivo é gerar uma série
                                 ; temporal.

printVarSummary(y1)              ; Dimensions and sizes: [time | 12]
printVarSummary(y2)              ; Dimensions and sizes: [time | 12]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex12")

; Recursos para os eixos x e y.
res                       = True
res@gsnXYBarChart         = True
res@tmXBLabelAngleF       = -90           ; Inclinação dos rótulos do 
                                          ; eixo x.
res@tmXBLabelJust         = "CenterRight" ; Alinhamento dos rótulos do 
                                          ; eixo x.
res@tmXBLabelStride       = 1             ; Ajusta quantos valores serão
                                          ; mostrados no eixo x.
res@trXMinF               = datai-1       ; Mínimo valor do eixo x.
res@trXMaxF               = dataf+1       ; Máximo valor do eixo x.
res@trYMaxF               = 7.0           ; Máximo valor do eixo y.
res@trYMinF               = 0.0           ; Mínimo valor do eixo y.
res@tmXBMode              = "Explicit"    ; Formata o eixo x do meu jeito.
res@tmXBValues            = ispan(datai,dataf,2)
res@tmXBLabels            = YYYYMM(datai:dataf:2)
res@tiYAxisString         = "Precipita"+cedil+atilde+"o (mm/dia)"
res@tiMainString          = "Precipita"+cedil+atilde+"o CRU x GPCP"  
res@gsnXYBarChartBarWidth = 0.22  ; Largura das barras.
res@gsnDraw               = True
res@gsnFrame              = False
res@tmYLMinorOn           = False ; Desliga os traços secundários do 
                                  ; eixo y.
res@tmYLLabelFontHeightF  = 0.02  ; tamanho do texto do eixo y.
res@tmXBLabelFontHeightF  = 0.02  ; tamanho do texto do eixo x.
res@vpXF                  = 0.125 ; Onde desenhar o gráfico em 
res@vpYF                  = 0.75  ; coordenadas NDC.
res@vpHeightF             = 0.43  ; Altura da figura.
res@vpWidthF              = 0.7   ; Largura da figura.

res@gsnXYBarChartColors   = "blue" ; Cor da primeira barra.
plot1 = gsn_csm_xy(wks,x1,y1,res)  ; Plot da primeira barra.

res@gsnXYBarChartColors   = "red"  ; Cor da segunda barra.
plot2 = gsn_csm_xy(wks,x2,y2,res)  ; Plot da segunda barra.

; Parte responsável pela formatação da legenda.
lbres                    = True
lbres@vpWidthF           = 0.25             ; Largura da legenda.
lbres@vpHeightF          = 0.08             ; Altura da legenda.
lbres@lbBoxMajorExtentF  = 0.8              ; Espaço entre as legendas.
lbres@lbFillColors       = (/"red","blue"/) ; Cores da legenda.
lbres@lbMonoFillPattern  = True             ; Habilita o preenchimento 
                                            ; da legenda.
lbres@lbLabelFontHeightF = 0.02             ; Tamanho da fonte da legenda.
lbres@lbLabelJust        = "CenterLeft"     ; Justificativa da legenda.
lbres@lbPerimOn          = False            ; Não desenha borda em torno da 
                                            ; legenda.
labels                   = (/"CRU","GPCP"/) ; Rótulos que vão aparecer 
                                            ; na legenda.

; drawNDCGrid(wks) ; Mostra as linhas de grade das coordenadas NDC. 
                   ; Útil para desenhar textos e acrescentar legendas.

; Desenha a legenda na posição x (0.1), y (0.75) do gráfico.
; 2 quer dizer quantos textos vão aparecer. 
; O labels é o texto que vai aparecer.

gsn_labelbar_ndc(wks,2,labels,0.1,0.75,lbres) 

end
