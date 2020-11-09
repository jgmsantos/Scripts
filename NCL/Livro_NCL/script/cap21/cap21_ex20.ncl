; Nome do script: cap21_ex20.ncl

begin

; short uwnd ( time, level, lat, lon )
; short vwnd ( time, level, lat, lon )
f = addfile("../../dados/uwnd.vwnd.nc","r") 

; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
u = short2flt(f->uwnd) 
; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
v = short2flt(f->vwnd) 

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex20")

res                         = True
res@vcRefMagnitudeF         = 4.0       ; Define o vetor de referência.
res@vcRefLengthF            = 0.045     ; Define o tamanho do vetor de 
                                        ; referência.
res@vcRefAnnoOrthogonalPosF = -1.0      ; Deslocamento o vetor de 
                                        ; referência.
res@vcGlyphStyle            = "CurlyVector" ; Aplica efeito de curvatura 
                                            ; aos vetores.
res@vcLineArrowColor        = "blue"        ; Muda a cor do vetor de 
                                            ; referência. 
res@vcLineArrowThicknessF   = 2.0           ; Espessura dos vetores.
res@mpMinLonF               = -110.0    ; Aplica 
res@mpMaxLonF               = -20.0     ; um zoom
res@mpMinLatF               = -60.0     ; na áres de
res@mpMaxLatF               =  20.0     ; interesse.
res@gsnLeftString           = "NCEP"    ; Título do lado esquerdo. Caso 
                                        ; não queira plotar nada, 
                                        ; basta colocar "".
res@gsnCenterString         = "Vetor do vento" ; Título central.
res@gsnRightString          = "m/s"     ; Título do lado direito.
res@gsnMajorLonSpacing      = 10        ; Espaçamento do eixo x.
res@gsnMajorLatSpacing      = 10        ; Espaçamento do eixo y.
res@tmXBMinorOn             = False ; Desabilita os traços secundários  
res@tmYLMinorOn             = False ; dos eixos x e y.

; Como o dado é 4D (time,level,lat,lon) é necessário que ele seja do 
; tipo 2D (lat,lon) para gerar a figura. Por isso, a redução de dimensão
; de 4 para 2, isto é, lat e lon mediante a fixação do tempo (0) e 
; nível vertical em 1000hPa (detalhe para o uso do símbolo "{}").

plot = gsn_csm_vector_map_ce(wks,u(0,{1000},:,:),v(0,{1000},:,:),res)

end
