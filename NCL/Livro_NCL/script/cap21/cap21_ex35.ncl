; Nome do script: cap21_ex35.ncl

begin

f = addfile("../../dados/uwnd.vwnd.nc","r") 

; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex35")

res                              = True
res@tiMainString                 = "Vento zonal"
res@cnLevelSpacingF              = 5.0 ; Espaçamento entre 
                                       ; as isolinhas.
res@gsnContourZeroLineThicknessF = 5.  ; Espessura da linha
                                       ; do contorno zero.
res@gsnContourNegLineDashPattern = 1   ; Fixa as isolinhas 
                                       ; negativas com o padrão 1
                                       ; (linhas tracejadas).

plot = gsn_csm_pres_hgt(wks,u(0,:,{0},:),res)

end
