; Nome do script: cap22_ex05.ncl

begin

; Anomalia mensal de SST na região do NINO3.4.

f = addfile ("../../dados/sst.anom.nino3.4.nc" , "r") 

vNames = getfilevarnames(f) ; Obtém a lista com os nomes das variáveis 
                            ; do arquivo f.

print (vNames) ; (0)	lon
               ; (1)	lat
               ; (2)	zlev
               ; (3)	time
               ; (4)	sst

time   = f->$vNames(3)$       ; Importação da variável "time" do arquivo.
YYYYMM = cd_calendar(time,-1) ; Converte uma data do calendário 
                              ; juliano/gregoriano
                              ; para o formato AAAAMM (opção -1) 
                              ; da variável time.
anoi   = 196601               ; Data inicial no formato AAAAMM.
anof   = 201512               ; Data final no formato AAAAMM.
istr   = ind(YYYYMM.eq.anoi ) ; Índice que será utilizado
iend   = ind(YYYYMM.eq.anof ) ; para selecionar o período de interesse.

; Importação da variável sst do arquivo f.
; short sst ( time, zlev, lat, lon )
;              600   1     1    1
; É uma série temporal de anomalia de sst. Por isso, fixou-se o 
; zlev, lat e lon.
ssta = short2flt(f->$vNames(4)$(istr:iend,0,0,0))

ntim = dimsizes(ssta) ; Número de tempos da variável.

; O uso da função filwgts_lanczos retorna os valores da frequência 
; (freq) e amplitude (resp) do filtro. Eles podem ser acessados via 
; símbolo "@". Exemplo: freq = wgtq@fre ou amp = wgtq@resp.

ihp   = 0      ; 0 = filtro passa-baixa, 1 = passa-alta e 2 = passa-banda.
sigma = 1.0    ; Fator sigma de Lanczos.
nWgt  = 49     ; Perda de 24 meses no início e fim da série.
fca   = 1./24. ; 2 anos => 1.0/24.0 = 0.042 é o valor do fca.
wgtq  = filwgts_lanczos(nWgt,ihp,fca,-999.,sigma)

printVarSummary(wgtq)  ; Number Of Attributes: 2
                       ; resp :	<ARRAY of 101 elements>
                       ; freq :	<ARRAY of 101 elements>
resposta   = wgtq@resp ; Será utilizada para gerar a figura
frequencia = wgtq@freq ; Frequência (x) versus Resposta de frequência (y).

wgtqs = wgt_runave(ssta,wgtq,0)  ; 2 anos. wgtqs => suavização da série
                                 ; pela função wgt_runave que cálcula a 
                                 ; média móvel.

plot = new(3,"graphic") ; Cria uma variável do tipo graphic para
                        ; armazenar as 3 figuras (painel de figuras).

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex05")

res1                 = True ; Personalização da figura.
res1@gsnDraw         = False; Não desenha.
res1@gsnFrame        = False; Não avança o frame.
res1@vpHeightF       = 0.4  ; Altura da figura.
res1@vpWidthF        = 0.8  ; Largura da figura.
res1@trYMinF         = -3.0 ; Mínimo valor do eixo y.
res1@trYMaxF         =  3.0 ; Máximo valor do eixo y.
res1@trXMinF         = istr ; Mínimo valor do eixo x.
res1@trXMaxF         = iend ; Máximo valor do eixo x.
res1@vpXF            = 0.1  ; Posição na página onde será criada a figura.
res1@gsnYRefLine     = 0.0  ; Cria linha de referência no valor 0.   
res1@gsnCenterString = "Anomalia de SST no NINO3.4" ; Título da figura. 
res1@tmXBMode        = "Explicit"   ; Formata o eixo x do meu jeito.
res1@tmXBValues      = ispan(istr,iend,12)      ; Valores do eixo x.
res1@tmXBLabels      = YYYYMM(istr:iend:12)/100 ; Rótulos que vão aparecer
                                                ; no eixo x.
res1@tmXBLabelAngleF = 90                       ; Rotaciona os rótulos 
                                                ; do eixo x.
res1@tmXBLabelJust   = "CenterRight"            ; Posicionamento dos 
                                                ; rótulos do eixo x.
res1@tiYAxisString   = "Anomalia de SST (~S~o~N~C)"
res1@tmXBLabelStride = 3  ; Mostra os rótulos do eixo x a cada 3 valores.
res1@gsnAboveYRefLineColor = "red"  ; Cor vermelho para os valores 
                                    ; acima de 0.
res1@gsnBelowYRefLineColor = "blue" ; Cor azul para os valores abaixo
                                    ; de 0.
res1@tmXTOn                = False  ; Desabilita o minortick do eixo x
                                    ; superior (XT).
 
; Cria a primeira figura (superior).
plot(0) = gsn_csm_xy(wks,ispan(istr,iend,1),ssta,res1)

res1@xyMonoDashPattern = True ; Defino o tipo de linha. O padrão é sólido.
res1@xyLineThicknessF  = 2    ; Espessura da linha.
res1@gsnCenterString   = "Filtro passa-baixa: 2 anos" ; Título da gráfico.

; Cria a figura do meio.
plot(1) = gsn_csm_xy(wks,ispan(istr,iend,1),wgtqs,res1) 

res2                  = True  ; Habilita personalização da figura.
res2@trXMinF          = 0.0   ; Mínimo valor do eixo x.
res2@trXMaxF          = 0.12  ; Máximo valor do eixo x.
res2@trYMinF          = -0.2  ; Mínimo valor do eixo y.
res2@trYMaxF          = 1.2   ; Máximo valor do eixo y.
res2@vpHeightF        = 0.4   ; Altura da figura.
res2@vpWidthF         = 0.8   ; Largura da figura.
res2@gsnDraw          = False ; Não desenha.
res2@gsnFrame         = False ; Não avança o frame.
res2@tiXAxisString    = "Frequ"+ecirc+"ncia" ; Título do eixo x.
res2@tiYAxisString    = "Resposta de frequ"+ecirc+"ncia"
res2@tmXBMode         = "Manual"     ; Formata o eixo x do meu jeito.
res2@tmXBTickStartF   = res2@trXMinF ; Mínimo valor do eixo x.
res2@tmXBTickSpacingF = 0.01         ; Incremento do eixo x.
res2@tmXBTickEndF     = res2@trXMaxF ; Máximo valor do eixo x.
res2@tmXBMinorOn      = False        ; Desabilita os traços secundários do 
                                     ; eixo x.
res2@tmYLMode         = "Manual"     ; Formata o eixo y do meu jeito.
res2@tmYLTickStartF   = res2@trYMinF ; Mínimo valor do eixo y.
res2@tmYLTickSpacingF = 0.2          ; Incremento do eixo y.
res2@tmYLTickEndF     = res2@trYMaxF ; Máximo valor do eixo y.
res2@tmYLMinorOn      = False        ; Desabilita os traços secundários
                                     ; do eixo y.
res2@xyLineThicknessF = 4            ; Espessura da linha.
res2@xyLineColors     = "red"        ; Cor de cada linha.
res2@tmXBFormat       = "0@;*.2f"    ; Formata os números do eixo x 
                                     ; inferior (XB). 

; Frequência (x) versus Resposta de frequência (y).
plot(2) = gsn_csm_xy(wks,frequencia,resposta,res2) 

; Desenha as linhas horizontal e vertical (cor azul no gráfico).
lnres                   = True   ; Habilita a personalização.
lnres@gsLineColor       = "blue" ; Cor da linha da caixa.
lnres@gsLineThicknessF  = 2.0    ; Espessura da linha da caixa.
lnres@gsLineDashPattern = 2      ; Estilo de linha.

x = (/0.0,fca,fca,res2@trXMaxF/); Coordenadas onde desenhar as linhas  
y = (/1.0,1.0,0.0,0.0/)       ; horizontal e vertical no gráfico inferior. 

caixa = gsn_add_polyline(wks,plot(2),x,y,lnres) ; Desenha as linhas.

; Cria o painel com as 3 figuras.
resP               = True    
resP@gsnMaximize   = True

gsn_panel(wks,plot,(/3,1/),resP) ; Painel com 3 linhas e 1 coluna.

end
