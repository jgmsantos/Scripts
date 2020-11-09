; Nome do script: cap21_ex06.ncl

begin

; double pre(time, lat, lon)
f1 = addfile("../../dados/SA.CRU.prec.1979.2013.nc","r")  
; float precip(time, lat, lon)
f2 = addfile("../../dados/SA.GPCP.prec.1979.2013.nc","r") 

; f1 =  Dimensions and sizes: [time | 420] x [lat | 1] x [lon | 1]
; f2 =  Dimensions and sizes: [time | 420] x [lat | 1] x [lon | 1]

; O dado possui time,lat,lon apesar de ser um dado pontual, é necessário 
; fixar a lat e a lon para que ocorra a redução de dimensão de 3 para 
; apenas 1, no caso, a dimensão time. Por isso, é importante conhecer 
; o dado antes de realizar qualquer tarefa.
 
;***********************************************************************
; Leitura da dimensão tempo. Será utilizada para criar o eixo x
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
datai   = ind(YYYYMM.eq.anoi)  ; Índice que será utilizado no tempo
dataf   = ind(YYYYMM.eq.anof)  ; para selecionar o período de interesse.

x1 = ispan(datai,dataf,1)      ; Valores do eixo x1.
x2 = ispan(datai,dataf,1)      ; Valores do eixo x2.

y1 = f1->pre(datai:dataf,0,0)   ; Seleciona o tempo de interesse para y1   
y2 = f2->precip(datai:dataf,0,0); e y2. Houve redução de dimensão de 3 
                                ; para 1, pois o objetivo é gerar uma 
                                ; série temporal.

printVarSummary(y1) ; Dimensions and sizes: [time | 12]
printVarSummary(y2) ; Dimensions and sizes: [time | 12]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex06")

; Recursos para o eixo x (eixo inferior) e y (eixo da esquerda).
resEB                    = True
resEB@tmXBLabelAngleF    = -90           ; Inclinação dos rótulos do 
                                         ; eixo x.
resEB@tmXBLabelJust      = "CenterRight" ; Alinhamento dos rótulos do 
                                         ; eixo x.
resEB@tmXBLabelStride    = 2             ; Ajusta quantos valores serão 
                                         ; mostrados no eixo x.
resEB@trXMinF            = datai         ; Mínimo valor do eixo x.
resEB@trXMaxF            = dataf         ; Máximo valor do eixo x.
resEB@xyMarkLineModes    = "MarkLines"   ; Linha com marcadores.
resEB@xyMarkers          =  16           ; Tipo de marcador.
resEB@xyMarkerColor      = "red"         ; Cor do marcador.
resEB@xyLineColors       = "red"         ; Cor da linha.
resEB@xyMarkerSizeF      = 0.02          ; Tamanho do marcador.
resEB@trYMaxF            = 7.0           ; Máximo valor do eixo y.
resEB@trYMinF            = 0.0           ; Mínimo valor do eixo y.
resEB@tmXBMode           = "Explicit"    ; Formata o eixo x do meu jeito.
resEB@tmXBValues         = ispan(datai,dataf,1)
resEB@tmXBLabels         = YYYYMM(datai:dataf)
resEB@tiYAxisString      = "Precipita"+cedil+atilde+ \ 
                           "o CRU (mm dia ~S~-1~N~)"
resEB@tiYAxisFontColor   = "red"         ; Cor da fonte do eixo y.
resEB@tmYLLabelFontColor = "red"         ; Cor dos valores do eixo y.
resEB@tmXBLabelFontColor = "red"         ; Cor dos valores do eixo x.
resEB@tiMainString       = "Compara"+cedil+atilde+ \ 
                           "o entre a PREC do CRU e do GPCP"  

; Recursos para o eixo x (eixo superior) e y (eixo da direita).
resDT                     = True
resDT@tmXTLabelAngleF     = -270
resDT@tmXTLabelJust       = "CenterRight"
resDT@tmXTLabelStride     = 2
resDT@trXMinF             = datai
resDT@trXMaxF             = dataf
resDT@xyMarkLineModes     = "MarkLines"
resDT@xyMarkers           =  12
resDT@xyMarkerColor       = "blue"
resDT@xyLineColors        = "blue"
resDT@xyMarkerSizeF       = 0.02
resDT@trYMaxF             = 7.0
resDT@trYMinF             = 0.0
resDT@tmXTMode            = "Explicit"
resDT@tmXTValues          = ispan(datai,dataf,1)
resDT@tmXTLabels          = YYYYMM(datai:dataf)
resDT@tiYAxisString       = "Precipita"+cedil+atilde+ \ 
                            "o GPCP (mm dia ~S~-1~N~)"
resDT@tiYAxisFontColor    = "blue"
resDT@tmYRLabelFontColor  = "blue"
resDT@tmXTLabelFontColor  = "blue"

; O eixo x1 (x2) está associado com o y1 (y2).

plot = gsn_csm_x2y2(wks,x1,x2,y1,y2,resEB,resDT)

end
