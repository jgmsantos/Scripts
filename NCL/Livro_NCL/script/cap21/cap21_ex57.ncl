; Nome do script: cap21_ex57.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r")
g = addfile("../../dados/hgt.jan.mar.1979.nc","r")

 ; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u    = short2flt(f->uwnd)
 ; short vwnd ( time, level, lat, lon ) = 3, 12, 73, 144
v    = short2flt(f->vwnd)
wspd = wind_speed(u,v)
; short hgt ( time, level, lat, lon )  = 3, 12, 73, 144
geo  = short2flt(g->hgt)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex57")

; Personalização da variável vento.
resv                         = True
resv@gsnDraw                 = False  ; Não gera a figura.
resv@gsnFrame                = False  ; Não avança o frame.
resv@vcRefLengthF            = 0.025  ; Tamanho do vetor de referência.
resv@vcRefMagnitudeF         = 20.0   ; Velocidade do vetor de 
                                      ; referência.
resv@gsnLeftString           = ""     ; Não adiciona título no lado 
                                      ; esquerdo da figura.
resv@gsnCenterString         = ""     ; Não adiciona título no centro
                                      ;  da figura.
resv@gsnRightString          = ""     ; Não adiciona título no lado 
                                      ; direito da figura.
resv@lbOrientation           = "vertical"     ; Orientação da legenda.
resv@vcRefAnnoOrthogonalPosF = -1.0           ; Deslocamento do vetor de
                                              ; referência.
resv@vcGlyphStyle            = "CurlyVector"  ; Aplica efeito de 
                                              ; curvatura aos vetores.
resv@vcLineArrowThicknessF   = 2.0            ; Espessura dos vetores.
resv@lbTitleString           = "(m/s)"        ; Título da legenda.
resv@lbTitlePosition         = "Top"          ; Posição do título da 
                                              ; legenda.
resv@lbTitleFontHeightF      = 0.025          ; Tamanho da fonte da 
                                              ; legenda.
resv@vcLevelSelectionMode    = "ManualLevels" ; Fixa de forma manual os
                                              ; contornos.
resv@vcMinLevelValF          = 10.0           ; Fixa o mínimo valor do
                                              ; contorno.
resv@vcMaxLevelValF          = 40.0           ; Fixa o máximo valor do
                                              ; contorno.
resv@vcLevelSpacingF         = 5.0            ; Fixa o intervalo dos 
                                              ; contornos.

; Personalização da variável geopotencial.
resc                      = True
resc@gsnDraw              = False             ; Não gera a figura.
resc@gsnFrame             = False             ; Não avança o frame.
resc@cnFillOn             = True              ; Habilita preenchimento.
resc@cnLinesOn            = False             ; Desabilita as linhas de
                                              ; contorno.
resc@mpMaxLatF            = 20.0              ; Latitude sul.       
resc@mpMinLatF            = -60.0             ; Latitude norte.
resc@mpMinLonF            = -100.0            ; Longitude oeste.
resc@mpMaxLonF            = -10.0             ; Longitude leste.
resc@gsnLeftString        = ""                ; Não adiciona título no
                                              ; lado esquerdo da figura.
resc@gsnCenterString      = ""                ; Não adiciona título no
                                              ; centro da figura.
resc@gsnRightString       = ""                ; Não adiciona título no 
                                              ; lado direito da figura.
resc@tiMainString         = "Alt. geopot. (shaded) e vento em 200hPa"
resc@gsnMajorLonSpacing   = 10                ; Espaçamento do eixo x 
                                              ; da longitude.
resc@gsnMajorLatSpacing   = 10                ; Espaçamento do eixo y 
                                              ; da latitude.
resc@tmXBMinorOn          = False             ; Desabilita os traços 
                                              ; secundários do eixo x. 
resc@tmYLMinorOn          = False             ; Desabilita os traços 
                                              ; secundários do eixo y.
resc@lbTitleString        = "(m)"             ; Título da legenda.
resc@lbTitlePosition      = "Bottom"          ; Posição do título da 
                                              ; legenda.  
resc@lbTitleFontHeightF   = 0.02              ; Tamanho da fonte do 
                                              ; título da legenda.
resc@cnLevelSelectionMode = "ManualLevels"    ; Fixa de forma manual 
                                              ; os contornos.
resc@cnMinLevelValF       = 5000.0            ; Fixa o mínimo valor 
                                              ; do contorno.
resc@cnMaxLevelValF       = 5800.0            ; Fixa o máximo valor 
                                              ; do contorno.
resc@cnLevelSpacingF      = 100.0             ; Fixa o intervalo dos 
                                              ; contornos.
resc@cnFillPalette        = "prcp_1"          ; Definição da tabela 
                                              ; de cores.

; Cria o plot dos vetores e velocidade (m/s).
plot1  = gsn_csm_contour_map(wks,geo(0,{500},:,:),resc) 
; Cria o plot da altura geopotencial (m).
plot2 = gsn_csm_vector_scalar(wks,u(0,{200},:,:),v(0,{200},:,:), \ 
                               wspd(0,{200},:,:),resv)

; Essas linhas são necessárias para fazer a sobreposição dos campos.
overlay(plot1,plot2) ; Sobreposição do plot2 (altura geopotencial) 
                     ; sobre o plot1 (vento).
draw(plot1)          ; Gera o plot do vento.
frame(wks)           ; Avança o frame.

end
