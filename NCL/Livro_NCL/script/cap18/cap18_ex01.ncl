; Nome do script: cap18_ex01.ncl

begin

f1 = addfile("../../dados/psfc.nc","r")
f2 = addfile("../../dados/shum.nc","r")
f3 = addfile("../../dados/uwnd.nc","r")
f4 = addfile("../../dados/vwnd.nc","r")

psfc = f1->pres(0,:,:)
qesp = short2flt(f2->shum(0,0,:,:))
uwnd = short2flt(f3->uwnd(0,0,:,:))
vwnd = short2flt(f4->vwnd(0,0,:,:))

wks = gsn_open_wks("pdf","../../figuras/cap18/cap18_ex01")

res               = True  ; Habilita a personalização do gráfico.
res@gsnDraw       = False ; Não desenha a figura.
res@gsnFrame      = False ; Não avança o frame.
res@mpMinLatF     = -60.0 ; Define a 
res@mpMaxLatF     =  15.0 ; área de 
res@mpMinLonF     = -90.0 ; interesse.
res@mpMaxLonF     = -30.0 ;
res@gsnAddCyclic  = False ; Não adiciona ponto cíclico.

plot1 = gsn_csm_contour_map_ce(wks,psfc,res)
plot2 = gsn_csm_contour_map_ce(wks,qesp,res)
plot3 = gsn_csm_contour_map_ce(wks,uwnd,res)
plot4 = gsn_csm_contour_map_ce(wks,vwnd,res)

; Cria o painel no formato 1 linha com 4 colunas.
gsn_panel(wks,(/plot1,plot2,plot3,plot4/),(/1,4/),False) 

end
