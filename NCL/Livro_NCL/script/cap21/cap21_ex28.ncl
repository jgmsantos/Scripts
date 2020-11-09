; Nome do script: cap21_ex28.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

 ; [time | 3] x [level | 12] x [lat | 73] x [lon | 144]
u = short2flt(f->uwnd)
v = short2flt(f->vwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex28")

res                    = True
res@stArrowLengthF     = 0.008     ; Tamanho das flechas dos vetores.
res@stMinArrowSpacingF = 0.001     ; Espaçamento dos vetores
                                   ; da mesma linha.
res@stArrowStride      = 1         ; Número de vetores em cada linha, 
                                   ; quanto menor o valor, mais vetores.
res@stLineThicknessF   = 1.5       ; Espessura da linha.
res@stLineColor        = "red"     ; Cor da linha.
res@mpMinLonF          = -110.0    ; Aplica 
res@mpMaxLonF          = -20.0     ; um zoom
res@mpMinLatF          = -60.0     ; na área de
res@mpMaxLatF          =  20.0     ; interesse.
res@gsnLeftString      = "NCEP"    ; Título do lado esquerdo. 
                                   ; Caso não queira plotar nada, 
                                   ; basta colocar "".
res@gsnCenterString    = "Linhas de corrente" ; Título central.
res@gsnRightString     = "m/s"     ; Título do lado direito.
res@gsnMajorLonSpacing = 10        ; Espaçamento do eixo x da longitude.
res@gsnMajorLatSpacing = 10        ; Espaçamento do eixo y da latitude.
res@tmXBMinorOn        = False     ; Desabilita os traços secundários 
res@tmYLMinorOn        = False     ; dos eixos x e y.

; Como o dado é 4D (time,level,lat,lon) é necessário que ele seja do 
; tipo 2D (lat,lon) para gerar a figura. Por isso, a redução de dimensão
; de 4 para 2, isto é, lat e lon mediante a fixação do tempo (0) e 
; nível vertical em 850hPa (detalhe para o uso do símbolo "{}").

plot = gsn_csm_streamline_map_ce(wks,u(0,{850},:,:),v(0,{850},:,:),res)

end
