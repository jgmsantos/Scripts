; Nome do script: cap21_ex09.ncl

begin

f = addfile("../../dados/precip.mon.1979.2014.nc","r")

; Inversão da latitude de sul para norte. 
ppt   = f->precip(:,::-1,:)

nlat   = dimsizes(ppt&lat) ; Extrai o número de pontos de latitude (72).

; Calcula a média zonal no primeiro tempo (0), com isso, a dimesão 
; lon "some" restando apenas a dimensão time e lat.
ppt_mz = zonalAve(ppt(0,:,:)) 

printVarSummary(ppt_mz) ; Dimensions and sizes: [lat | 72]

sigma  = 2

xp     = new( (/sigma*nlat/), float ) ; Cria um vetor com 144 posições.
yp     = new( (/sigma*nlat/), float ) ; Cria um vetor com 144 posições.

do k = 0, nlat-1
   dx                 = sqrt(ppt_mz(k)) 
   yp(k)              = ppt_mz(k) + dx  
   xp(k)              = ppt_mz&lat(k)   
   xp(sigma*nlat-1-k) = ppt_mz&lat(k)   
   yp(sigma*nlat-1-k) = ppt_mz(k) - dx  
end do

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex09")

res                  = True
res@gsnDraw          = False                   ; Não desenha a figura.
res@gsnFrame         = False                   ; Gera apenas o frame.
res@xyLineThicknessF = 4.0                     ; Espessura da linha.
res@trYMinF          = -2.0                    ; Mínimo valor do eixo y.
res@trYMaxF          = 10.0                    ; Máximo valor do eixo y.
res@tiMainString     = "Prec zonal - Jan/1979" 
res@tiXAxisString    = "Latitude"              
res@tiYAxisString    = "Prec zonal (mm dia~S~-1 ~N~)"
res@tmYLLabelStride  = 1               ; Intervalo com que aparecem 
                                       ; os números no eixo y.
res@tmYLMode         = "Manual"        ; Formata o eixo y do meu jeito.
res@tmYLTickStartF   = res@trYMinF     ; Mínimo valor do eixo y.
res@tmYLTickSpacingF = 1               ; Incremento do eixo y.
res@tmYLTickEndF     = res@trYMaxF     ; Máximo valor do eixo y.
res@tmYLMinorOn      = False           ; Desabilita os traços 
                                       ; secundários do eixo y.

plot  = gsn_csm_xy (wks,ppt_mz&lat,ppt_mz,res)

; Gera a curva preenchida.

gsres                 = True
gsres@tfPolyDrawOrder = "Predraw"    ; Desenha primeiro o desvio padrão
                                     ; e depois a linha.
gsres@gsFillColor     = "SlateBlue"  ; Cor selecionada.
gsres@gsFillOpacityF  = 0.4          ; Opacidade do preenchimento 
                                     ; 0 (menos opaco) a 1 (mais opaco).

dummy = gsn_add_polygon (wks,plot,xp,yp,gsres)

draw(plot)
frame(wks)

end
