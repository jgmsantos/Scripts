; Nome do script: cap20_ex18.ncl

begin

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex18")

res                       = True
res@gsnFrame              = False               ; Não avança o frame.
res@mpMinLatF             = -60.                ; Latitude sul.
res@mpMaxLatF             = 20.                 ; Latitude norte.
res@mpMinLonF             = -90.                ; Longitude leste.  
res@mpMaxLonF             = -30.                ; Longitude oeste.
res@mpOutlineBoundarySets = "National"          ; Divisão dos países.
res@mpDataSetName         = "Earth..4"          ;
res@mpDataBaseVersion     = "MediumRes"         ;
res@mpOutlineSpecifiers   = (/"Brazil:states"/) ; Divisão do estados 
                                                ; brasileiros.
res@mpFillOn              = False               ; Mapa com fundo transparente.

plot = gsn_csm_map_ce(wks,res) ; Gera somente o mapa.

; Caixa sobre a Amazônia.

; Valores de latitude para desenhar a caixa.
boxlat = (/-13.7,-13.7,  2.0,  2.0,-13.7 /)

; Valores de longitude para desenhar a caixa. 
boxlon = (/290.7,312.0,312.0,290.7,290.7 /)

; Desenha a caixa.
lnres                   = True  ; Habilita a personalização.
lnres@gsLineColor       = "red" ; Cor da linha da caixa.
lnres@gsLineThicknessF  = 5.0   ; Espessura da linha da caixa.

caixa = gsn_add_polyline(wks,plot,boxlon,boxlat,lnres) ; Desenha a caixa.

; Adiciona um texto dentro da caixa.
txres               = True  ; Habilita a personalização.
txres@txFontHeightF = 0.025 ; Tamanho do texto que está dentro da caixa.
txres@txFontColor   = "red" ; Cor do texto que está dentro da caixa.

midlon = 0.5 * (max(boxlon)+min(boxlon)) ; Define o centro da caixa 
midlat = 0.5 * (max(boxlat)+min(boxlat)) ; para inserir o texto AMZ.

; Adiciona o texto AMZ a caixa.
texto = gsn_add_text(wks,plot,"AMZ",midlon,midlat,txres) 

draw(plot)
frame(wks)

end
