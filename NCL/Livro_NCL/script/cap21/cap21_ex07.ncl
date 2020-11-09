; Nome do script: cap21_ex07.ncl

begin

f1 = addfile("../../dados/SA.olr.2000.2004.nc","r")
f2 = addfile("../../dados/SA.GPCP.prec.2000.2004.nc","r")

; f1 =  Dimensions and sizes: [time | 60] x [lat | 1] x [lon | 1]
; f2 =  Dimensions and sizes: [time | 60] x [lat | 1] x [lon | 1]

; O dado possui time,lat,lon apesar de ser um dado pontual,
; é necessário fixar a lat e a lon para que ocorra a redução de dimensão
; de 3 para apenas 1, no caso, a dimensão time.
 
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
anoi    = 200001               ; Data inicial no formato AAAAMM.
anof    = 200012               ; Data final no formato AAAAMM.
datai   = ind(YYYYMM.eq.anoi)  ; Índice que será utilizado na 
                               ; dimensão tempo para selecionar o 
dataf   = ind(YYYYMM.eq.anof)  ; período de interesse.

x  = ispan(datai,dataf,1)      ; Valores do eixo x.

y1 = f1->olr(datai:dataf,0,0)   ; Seleciona o tempo de interesse para y1   
y2 = f2->precip(datai:dataf,0,0); e y2. Houve redução de dimensão de 3 
                                ; para 1, pois o objetivo é gerar uma 
                                ; série temporal.

printVarSummary(y1) ; Dimensions and sizes: [time | 12]
printVarSummary(y2) ; Dimensions and sizes: [time | 12]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex07")

; Recursos para o eixo x e y (eixo da esquerda).
resEB                    = True
resEB@tmXBLabelAngleF    = -90   ; Inclinação dos rótulos do eixo x.
resEB@tmXBLabelJust      = "CenterRight"; Alinhamento dos rótulos do 
                                        ; eixo x.
resEB@tmXBLabelStride    = 1            ; Ajusta quantos valores serão 
                                        ; mostrados no eixo x.
resEB@trXMinF            = datai        ; Mínimo valor do eixo x.
resEB@trXMaxF            = dataf        ; Máximo valor do eixo x.
resEB@xyMarkLineModes    = "MarkLines"  ; Linha com marcadores.
resEB@xyMarkers          =  16          ; Tipo de marcador.
resEB@xyMarkerColor      = "red"        ; Cor do marcador.
resEB@xyLineColors       = "red"        ; Cor da linha.
resEB@xyMarkerSizeF      = 0.015        ; Tamanho do marcador.
resEB@trYMaxF            = 260.0        ; Máximo valor do eixo y.
resEB@trYMinF            = 220.0        ; Mínimo valor do eixo y.
resEB@tmXBMode           = "Explicit"   ; Formata o eixo x do meu jeito.
resEB@tmXBValues         = ispan(datai,dataf,1)
resEB@tmXBLabels         = YYYYMM(datai:dataf:1)
resEB@tiYAxisString      = "Radia"+cedil+atilde+ \ 
                           "o de Onda Longa (W m~S~-2~N~)"
resEB@tiYAxisFontColor   = "red"         ; Cor da fonte do eixo y.
resEB@tmYLLabelFontColor = "red"         ; Cor dos valores do eixo y.
resEB@tiMainString       = "ROL (NOAA) x PREC (GPCP)"  

; Recursos para o eixo x e y (eixo da direita).
resDT                     = True
resDT@xyMarkLineModes     = "MarkLines"
resDT@xyMarkers           =  12
resDT@xyMarkerColor       = "blue"
resDT@xyLineColors        = "blue"
resDT@xyMarkerSizeF       = 0.01
resDT@trYMaxF             = 5.0
resDT@trYMinF             = 0.0
resDT@tiYAxisString       = "Precipita"+cedil+atilde+ \ 
                            "o GPCP (mm dia ~S~-1~N~)"
resDT@tiYAxisFontColor    = "blue"
resDT@tmYRLabelFontColor  = "blue"

; O eixo x é o mesmo para as duas curvas (y1 e y2).
plot = gsn_csm_xy2(wks,x,y1,y2,resEB,resDT)

end
