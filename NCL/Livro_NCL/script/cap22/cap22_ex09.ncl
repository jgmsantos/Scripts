; Nome do script: cap22_ex09.ncl

begin

f = addfile("../../dados/anom.SA.GPCP.prec.1979.2014.nc","r")

appt = f->precip(:,0,0) ; float precip(time, lat, lon)
                        ;               432   1    1

opt          = True  ; Habilita a personalização da função pdfx.
opt@bin_nice = True  ; Valores razoáveis do limite bin e espaçamento 
                     ; serão calculados.

ap  = pdfx(appt,35,True) ; Cálculo da PDF. Serão mostrados 50 bins.

printVarSummary(ap)

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex09")

res                     = True      ; Habilita personalização do gráfico.
res@xyLineThicknessF    = 2         ; Espessura da linha.
res@tiYAxisString       = "PDF (%)" ; Título do eixo y.
res@gsnCenterString     = "Anomalia de precipita"+cedil+atilde+ \ 
                          "o sobre a AS - 1979/2014"
res@gsnXYBarChart       = True       ; Habilita gráfico de barras.
res@gsnXYBarChartColors = "gray"     ; Cor da barra.
res@trYMaxF             = 12.0       ; Máximo valor do eixo y.
res@trYMinF             = 0.0        ; Mínimo valor do eixo y.
res@trXMaxF             = 0.8        ; Máximo valor do eixo x.
res@trXMinF             = -0.8       ; Mínimo valor do eixo x.
res@tmYLMode            = "Manual"   ; Personalização do eixo y do meu 
                                     ; jeito.
res@tmYLTickStartF      = res@trYMinF
res@tmYLTickSpacingF    = 2
res@tmYLTickEndF        = res@trYMaxF
res@tmXBMode            = "Manual"   ; Personalização do eixo x do meu 
                                     ; jeito.
res@tmXBTickStartF      = res@trXMinF
res@tmXBTickSpacingF    = 0.2
res@tmXBTickEndF        = res@trXMaxF
res@tmYLMinorOn         = False      ; Desabilita o minortick do eixo y 
                                     ; esquerdo (YL).
res@tmXBMinorOn         = False      ; Desabilita o minortick do eixo x 
                                     ; inferior (XB).
res@tmXBFormat          = "0@;*.2f"  ; Formata os números do eixo x 
                                     ; inferior (XB). 

plot = gsn_csm_xy(wks,ap@bin_center,ap,res)

end
