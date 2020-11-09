; Nome do script: cap21_ex17.ncl

begin

f = addfile ("../../dados/tair.2011.2012.nc","r")

t = short2flt(f->air)
t = t - 273.15

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex17")

res                 = True
res@tiMainString    = "Temperatura em 1000hPa" 
res@gsnLeftString   = "Fonte: NCEP/R2"          
res@gsnCenterString = "Janeiro"                 
res@gsnRightString  = "~S~o~N~C"                
res@cnLinesOn       = False         ; Desabilita o gráfico de contorno.
res@cnFillOn        = True          ; Gráfico com preenchimento.
res@lbOrientation   = "Horizontal"  ; Orientação da legenda (Horizontal 
                                    ; ou Vertical).

; Plota o primeiro tempo (0), primeiro nível vertical (1000 hPa), 
; todas as latitudes (:) e longitudes (:)

plot = gsn_csm_contour_map_ce(wks,t(0,{1000},:,:),res)

end
