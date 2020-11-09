; Nome do script: cap22_ex11.ncl
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/acentos.ncl"
begin

; Anomalia mensal de precipitação sobre a América do Sul (1979 a 2014).
in   = addfile("../../dados/anom.SA.GPCP.prec.1979.2014.nc","r")
appt = in->precip(:,0,0)

; detrending opt: 0=>remove a média e 1=>remove a média e a tendência.
d = 0

; Suavização do periodograma. Deve ser ímpar e valor mínimo de 3.
sm = 21

; Porcentagem de suaviação: (0.0 <= pct <= 1.0) sendo o valor 0.10 o 
; mais comum.
pct = 0.10

sdof = specx_anal(appt,d,sm,pct) ; Calcula o espectro.

printVarSummary(sdof)

; Resultado do printVarSummary(spec) 

;Number Of Attributes: 8
;  xslope :	 0
;  xlag1 :	0.2093593
;  xvaro :	0.04039465
;  xvari :	0.04039465
;  xavei :	-4.850638e-11
;  bw :	0.01436011
;  frq :	<ARRAY of 216 elements>
;  spcx :	<ARRAY of 216 elements>

splt = specx_ci(sdof,0.05,0.95) ; Calcula o intervalo de confiança do 
                                ; ruído vermelho (red noise).

; Graus de liberdade retornado da função specx_anal.
; Limite inferior do intervalo de confiança (0.0 < lowval < 1.). O valor
; típico é de 0.05.
; Limite superior do intervalo de confiança (0.0 < hival < 1.). O valor 
; típico é de 0.95.

printVarSummary(splt)

; O splt resulta em 4 curvas. Essas curvas são utilizadas para gerar o 
; gráfico. Nota-se na figura que há 4 curvas na ordem abaixo.

; splt(0,:) - input spectrum
; splt(1,:) - Markov "Red Noise" spectrum
; splt(2,:) - lower confidence bound for Markov
; splt(3,:) - upper confidence bound for Markov

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex11")

res                        = True  ; Habilita personalização do gráfico.
res@tiMainString           = "Precipita"+cedil+atilde+"o - 1979 a 2014"
res@tiXAxisString          = "Frequ"+ecirc+"ncia (ciclos/m"+ecirc+"s)"
res@tiYAxisString          = "Vari"+acirc+"ncia" 
res@xyLineThicknesses      = (/2.,1.,1.,1./)  ; Espessura de cada linha.
res@xyDashPatterns         = (/0,0,1,1/)      ; Tipo de linha.
res@xyLineColors           = (/"foreground","green","blue","red"/)
res@pmLegendDisplayMode    = "Always"    ; Habilita a legenda.
res@pmLegendSide           = "Top"       ; Localização da legenda.
res@pmLegendParallelPosF   = 0.68        ; Move a legenda na direção x.
res@pmLegendOrthogonalPosF = -0.38       ; Move a legenda na direção y.
res@pmLegendWidthF         = 0.1         ; Largura da legenda.
res@pmLegendHeightF        = 0.15        ; Altura da legenda.
res@lgPerimOn              = False       ; Desabilita a caixa em torno 
                                         ; da legenda.
res@lgLabelFontHeightF     = 0.024       ; Tamanho da fonte da legenda.
res@lgItemOrder            = (/3,2,1,0/) ; Reordena os rótulos da legenda.
res@trYMaxF                = 0.22        ; Máximo valor do eixo y.
res@trYMinF                = 0.0         ; Mínimo valor do eixo y.
res@trXMaxF                = 0.5         ; Máximo valor do eixo x.
res@trXMinF                = 0.0         ; Mínimo valor do eixo x.
res@tmYLMode               = "Manual"    ; Personalização do eixo y do 
                                         ; meu jeito.
res@tmYLTickStartF         = res@trYMinF
res@tmYLTickSpacingF       = 0.02
res@tmYLTickEndF           = res@trYMaxF
res@tmXBMode               = "Manual"    ; Personalização do eixo x do 
                                         ;meu jeito.
res@tmXBTickStartF         = res@trXMinF
res@tmXBTickSpacingF       = 0.1
res@tmXBTickEndF           = res@trXMaxF
res@tmYLMinorOn            = False      ; Desabilita o minortick do eixo
                                        ; y esquerdo (YL).
res@tmXBMinorOn            = False      ; Desabilita o minortick do eixo
                                        ; x inferior (XB).
res@tmYLFormat             = "0@;*.2f"  ; Formata os números do eixo y 
                                        ; esquerdo (YL). 
res@xyExplicitLegendLabels = (/"Espectro",                      \
                               "Ru"+iacute+"do vermelho",       \ 
                               "5% de signific"+acirc+"ncia",   \
                               "95% de signific"+acirc+"ncia"/)

plot=gsn_csm_xy(wks,sdof@frq,splt,res) ; Gera o gráfico com as 4 curvas.

end
