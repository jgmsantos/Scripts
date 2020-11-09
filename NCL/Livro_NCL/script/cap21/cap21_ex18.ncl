; Nome do script: cap21_ex18.ncl

begin

a = addfile("../../dados/u.2011.2012.nc","r")
b = addfile("../../dados/v.2011.2012.nc","r")

u = short2flt(a->uwnd)
v = short2flt(b->vwnd)

vel = sqrt(u^2+v^2)

copy_VarCoords(u,vel)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex18")

res                         = True
res@tiMainString            = "Vetor velocidade do vento em 200hPa"
res@gsnLeftString           = "NCEP/R2"
res@gsnCenterString         = "Dezembro"
res@gsnRightString          = "m s~S~-1"
res@vpXF                    = 0.1  ; Posição (vpX,vpY) onde será 
res@vpYF                    = 0.85 ; desenhada figura.
res@gsnMajorLonSpacing      = 10      ; Variação da escala do eixo x.
res@gsnMajorLatSpacing      = 10      ; Variação da escala do eixo y.
res@vcRefMagnitudeF         = 15.0    ; Magnitude de vetor.
res@vcRefLengthF            = 0.050   ; Comprimento do vetor.
res@vcGlyphStyle            = "CurlyVector"; Efeito de curvatura nos 
                                           ; vetores.
res@vcMinDistanceF          = 0.01    ; Espessura dos vetores.
res@vcRefAnnoOrthogonalPosF = -1.0    ; Deslocamento da legenda da 
                                      ; velocidade.
res@mpMinLonF               = -90.0   ; Longitude oeste.
res@mpMaxLonF               = -30.0   ; Longitude leste.
res@mpMinLatF               = -60.0   ; Latitude sul.
res@mpMaxLatF               =  20.0      ; Latitude norte.
res@mpOutlineBoundarySets   = "National" ; Mostra a divisão dos países.
res@mpDataSetName           = "Earth..4"
res@mpDataBaseVersion       = "MediumRes"
res@mpOutlineOn             = True
res@mpOutlineSpecifiers     = (/"Brazil:states"/) ; Divisão dos estados 
                                                  ; brasileiros.
res@mpFillOn                = False       ; Mapa com fundo branco.
res@lbOrientation           = "Vertical"  ; Orientação da legenda.

plot=gsn_csm_vector_scalar_map_ce(wks,u(11,{200},:,:),v(11,{200},:,:),\
                                    vel(11,{200},:,:), res)

end
