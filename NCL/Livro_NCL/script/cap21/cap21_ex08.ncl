; Nome do script: cap21_ex08.ncl

begin

arquivo = "co2.1980.2005.RCP85.txt" ; Nome do arquivo.

nlin = numAsciiRow("../../dados/" + arquivo)
ncol = numAsciiCol("../../dados/" + arquivo)

f = asciiread("../../dados/" + arquivo,(/nlin,ncol/),"float")

x  = toint(f(:,0)) ; x é um vetor float de anos que foi convertido para 
                   ; inteiro (toint).
y  = f(:,1)        ; y (CO2) é um vetor float.

y@_FillValue = -999 ; Defino o valor indefinido caso haja no arquivo.

nanos = max(x)-min(x) + 1 ; Total de anos.

rc = regline(x,y) ; Calcula a regressão linear.
r  = escorc(x,y)  ; Correlação de Pearson.
r2 = r*r          ; Coeficiente de determinção. 

printVarSummary(rc)

; Parte do resultado do comando printVarSummary(rc):
;
;Number Of Attributes: 7
;  _FillValue :	-999
;  yintercept :	-3161.886
;  yave :	366.5367
;  xave :	1997.5
;  nptxy :	36
;  rstd :	0.02959174
;  tval :	59.693

; O valor 2 abaixo significa quantas curvas serão geradas.

pltarry      = new ((/2,nanos/),typeof(y),y@_FillValue)
pltarry(0,:) = y  ; A primeira curva (0) é o valor de CO2.
pltarry(1,:) = rc*(x-rc@xave) + rc@yave ; A segunda curva (1)
                                        ; é a reta de regressão.

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex08")

res                     = True
res@gsnDraw             = False
res@gsnFrame            = False
res@tiMainString        = "RCP8.5 CO~B~2~N~ (ppm): "+ min(x) + \ 
                          " - " + max(x)
res@gsnMaximize         = True             ; A figura ocupa todo o 
                                           ; espaço da tela.
res@xyLineColors        = (/"blue","red"/) ; Cores das linhas.
res@xyMarkerSizeF       = 0.008            ; Tamanho do marcador.
res@xyDashPatterns      = (/0,0/)          ; Padrão da linha de cada 
                                           ; curva.
res@xyLineThicknesses   = (/1,3/)          ; Espessura de cada curva.
res@xyMarkLineModes     = (/"Markers","Lines"/) ; Estilo de linha de 
                                           ; cada curva.
res@trXMinF             = min(x)           ; Mínimo valor do eixo x.
res@trXMaxF             = max(x)           ; Máximo valor do eixo x.
res@trYMinF             = 300.0            ; Mínimo valor do eixo y.
res@trYMaxF             = 420.0            ; Máximo valor do eixo y.
res@tiXAxisString       = "Anos"           ; Título do eixo x.
res@tiYAxisString       = "CO~B~2~N~ (ppm)"; Título do eixo y.
res@tmXBLabelAngleF     = -90              ; Rotaciona em -90 graus os 
                                           ; rótulos de x.
res@xyMarkers           =   (/16,0/)       ; Tipo de marcador para cada
                                           ; curva.
res@xyMarkerColors      = (/"blue","red"/) ; Cor do marcador para cada
                                           ; curva.
res@tmXBLabelJust       = "CenterRight"    ; Alinhamento dos rótulos 
                                           ; do eixo x.
res@tmXBLabelStride     = 2                ; Ajusta quantos valores 
                                           ; serão mostrados no eixo x.
res@tmXBMode            = "Explicit"       ; Eixo x do meu jeito.
res@tmXBValues          = ispan(min(x),max(x),1) ; Valores do eixo x.
res@tmXBLabels          = ispan(min(x),max(x),1) ; Rótulo do eixos.

plot  = gsn_csm_xy(wks,x,pltarry,res) ; Plot da figura.

; Inserindo a equação y = mx + b na posição x,y do gráfico. 
; Onde m = rc | b = yave.
; Inseri também o R2.

txres1                        = True
txres1@txFontHeightF          = 0.025          ; Tamanho do texto.
txres1@txFontColor            = "red"          ; Cor do texto.
txres1@txBackgroundFillColor  = "transparent"  ; Fundo do texto. Pode 
                                               ; usar "transparent".
txres1@txJust                 = "CenterLeft"   ; Alinhamento do texto.

; "1981" é o valor do eixo x e o "412" valor do eixo y. Foi feita a 
; quebra de linha com o símbolo "\".
dum1 = gsn_add_text(wks,plot,"y = "+sprintf("%4.3f",rc)+"x + "+ \ 
                                    sprintf("%4.3f",rc@yave),1981, \
                                    412,txres1) 

; "1981" é o valor do eixo x e o "404" valor do eixo y.
dum2 = gsn_add_text(wks,plot,"R~S~2~N~ = "+sprintf("%4.3f",r2),1981, \ 
                                           404,txres1) 

; Insere o marcador círculo azul na posição x,y do gráfico.

pmres               = True
pmres@gsMarkerColor = "blue" ; Cor do marcador.
pmres@gsMarkerIndex = 16     ; Tipo do marcador.
pmres@gsMarkerSizeF = 0.02   ; Tamanho do marcador.

dum3 = gsn_add_polymarker(wks,plot,1981.5,396,pmres)

; Insere o texto CO2 azul na posição x,y do gráfico.

txres2                        = True
txres2@txFontHeightF          = 0.025          ; Tamanho do texto.
txres2@txFontColor            = "blue"         ; Cor do texto.
txres2@txBackgroundFillColor  = "transparent"  ; Fundo do texto. Pode 
                                               ; usar "transparent".
txres2@txJust                 = "CenterLeft"   ; Alinhamento do texto.

; "1982.5" é o valor do eixo x e o "395.5" valor do eixo y.
dum4 = gsn_add_text(wks,plot,"CO~B~2",1982.5,395.5,txres2) 

draw(plot)

end
