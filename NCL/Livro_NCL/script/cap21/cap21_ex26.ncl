; Nome do script: cap21_ex26.ncl

begin

; short uwnd ( time, level, lat, lon )
f = addfile("../../dados/uwnd.vwnd.nc","r") 

; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
u   = short2flt(f->uwnd)
v   = short2flt(f->vwnd)
vel = wind_speed(u,v)    ; Calcula a velocidade do vento.
 
wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex26")

res                          = True
res@gsnPolar                 = "NH"  ; Hemisfério a ser visualizado.
res@gsnScalarContour         = True  ; Vetores sobre um campo escalar.
res@cnFillOn                 = True  ; Habilita gráfico shaded.
res@cnLevelSpacingF          = 2.0   ; Intervalo do espaçamento.
res@cnLinesOn                = False ; Sem linhas de contorno.
res@mpFillOn                 = False ; Mapa com fundo branco.
res@tiMainString             = "Vetor do vento e velocidade - Fev/1979"
res@gsnCenterString          = ""
res@gsnLeftString            = ""
res@gsnRightString           = ""
res@mpGridLatSpacingF        = 30.0  ; Espaçamento da latitude.
res@mpGridLonSpacingF        = 90.0  ; Espaçamento da longitude.
res@mpCenterLonF             = -90   ; Ponto de vista do mapa. 
res@gsnPolarLabelDistance    = 1.06  ; Distância das longitudes.
res@gsnPolarLabelFontHeightF = 0.020 ; Altera o tamanho da fonte 
                                     ; dos rótulos de longitude.
res@vcRefMagnitudeF          = 10.0  ; Define o vetor de referência.
res@vcRefLengthF             = 0.050 ; Define o tamanho do vetor
                                     ; de referência.
res@vcMinDistanceF           = 0.02  ; Densidade de vetores.
res@vcGlyphStyle             = "CurlyVector" ; Aplica efeito de 
                                             ; curvatura.
res@vcRefAnnoArrowLineColor  = "black"       ; Cor do vetor de 
                                             ; referência.
res@vcRefAnnoArrowUseVecColor= False
res@mpGeophysicalLineThicknessF = 4.0   ; Espessura da linha dos países.
res@mpGeophysicalLineColor      = "red" ; Cor da linha dos países.

plot = gsn_csm_vector_scalar_map_polar(wks,u(1,0,:,:),v(1,0,:,:),\
                                         vel(1,0,:,:),res)

end
