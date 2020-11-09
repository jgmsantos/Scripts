; Nome do script: cap21_ex30.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd) 

uz = zonalAve(u) ; Realiza a média zonal (longitude). 
                 
printVarSummary(uz) 
; Dimensions and sizes: [time | 3] x [level | 12] x [lat | 73]

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex30")

res                              = True
res@tiMainString                 = "M"+eacute+"dia zonal"
res@cnLevelSpacingF              = 5.0 ; Espaçamento entre 
                                       ; as isolinhas.
res@gsnContourZeroLineThicknessF = 5.  ; Espessura da linha 
                                       ; do contorno zero.
res@gsnContourNegLineDashPattern = 1   ; Fixa as isolinhas negativas 
                                       ; com o padrão 1
                                       ; (linhas tracejadas).

plot = gsn_csm_pres_hgt(wks,uz(2,:,:),res)

end
