; Nome do script: cap22_ex10.ncl

begin

; Anomalia mensal de precipitação sobre a América do Sul (1979 a 2014).
in   = addfile("../../dados/anom.SA.GPCP.prec.1979.2014.nc","r")
appt = in->precip(:,0,0)

; detrending opt: 0=>remove a média e 1=>remove a média e a tendência.
d = 0

; Suavização do periodograma. Deve ser ímpar e valor mínimo de 3.
sm = 7

; Porcentagem de suaviação: (0.0 <= pct <= 1.0) sendo o valor 0.10 o 
; mais comum.
pct = 0.10

spec = specx_anal(appt,d,sm,pct) ; Calcula o espectro.

printVarSummary(spec)

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

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex10")

res               = True
res@tiMainString  = "Precipita"+cedil+atilde+"o - 1979 a 2014"
res@tiXAxisString = "Frequ"+ecirc+"ncia (ciclos/m"+ecirc+"s)"
res@tiYAxisString = "Vari"+acirc+"ncia"

plot=gsn_csm_xy(wks,spec@frq,spec@spcx,res)

end
