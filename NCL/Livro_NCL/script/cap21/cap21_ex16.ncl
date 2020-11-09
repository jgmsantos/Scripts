; Nome do script: cap21_ex16.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

t = short2flt(f->air)
t = t - 273.15

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex16")

res                      = True
res@tiMainString         = "Temperatura - 1000hPa" ; Título principal 
                                                   ; da figura.
res@gsnLeftString        = "Fonte: NCEP/R2" ; Título do lado esquerdo.
res@gsnCenterString      = "Janeiro"        ; Título central.
res@gsnRightString       = "~S~o~N~C"       ; Título do lado direito.
res@cnLevelSelectionMode = "ManualLevels"   ; Fixa os valores manualmente.
res@cnMinLevelValF       = -40.0            ; Fixa o mínimo valor do
                                            ; contorno.
res@cnMaxLevelValF       = 40.0             ; Fixa o máximo valor do
                                            ; contorno.
res@cnLevelSpacingF      = 10.0             ; Fixa o espaçamento do 
                                            ; contorno.
res@cnInfoLabelOn        = False            ; Desabilita as informações 
                                            ; do contorno.

; Plota o primeiro tempo (0), primeiro nível vertical (1000hPa), 
; todas as latitudes (:) e todas as longitudes (:)

plot = gsn_csm_contour_map_ce(wks,t(0,{1000},:,:),res)

end
