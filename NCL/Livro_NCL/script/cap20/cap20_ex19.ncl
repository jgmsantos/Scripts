; Nome do script: cap20_ex19.ncl

begin

nlinhas  = 336 ; Número de linhas do arquivo.
ncolunas = 2   ; Número de colunas do arquivo.

; Abertura do arquivo lat_lon.txt.
data = asciiread("../../dados/lat_lon.txt",(/nlinhas,ncolunas/),"float") 
lat  = data(:,0) ; Primeira coluna do arquivo => valores de latitude.
lon  = data(:,1) ; Segunda coluna do arquivo  => valores de longitude.

wks  = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex19")

res                       = True
res@gsnFrame              = False               ; Não avança o frame.
res@mpMinLatF             = -60.                ; Latitude sul.
res@mpMaxLatF             = 20.                 ; Latitude norte.
res@mpMinLonF             = -90.                ; Longitude leste.  
res@mpMaxLonF             = -30.                ; Longitude oeste.
res@mpOutlineBoundarySets = "National"          ; Divisao dos países.
res@mpDataSetName         = "Earth..4"          ;
res@mpDataBaseVersion     = "MediumRes"         ;
res@mpOutlineSpecifiers   = (/"Brazil:states"/) ; Divisão do estados 
										  						; brasileiros.
res@mpFillOn              = False       ; Mapa com fundo transparente.
res@gsnMajorLonSpacing    = 10          ; Espaçamento da longitude.
res@gsnMajorLatSpacing    = 10          ; Espaçamento da latitude.

map = gsn_csm_map(wks,res)              ; Gera o mapa.

; Gera os  marcadores.
mkres               = True  ; Habilita a personalização dos marcadores. 
mkres@gsMarkerIndex = 2     ; Tipo de marcador. 2 = Cruz.
mkres@gsMarkerColor = "Blue"; Cor do marcador.

do k = 0,nlinhas-1
   gsn_polymarker(wks,map,lon(k),lat(k),mkres)
end do

; Desenha no mapa no canto superior direito o marcador (+). Como se 
; fosse uma legenda.
gsres                    = True   ; Habilita personalização.
gsres@gsMarkerIndex      = 2      ; Tipo de marcador.
gsres@gsMarkerColor      = "Blue" ; Cor do marcador.
gsres@gsMarkerThicknessF = 3.0    ; Espessura do marcador.
gsres@gsMarkerSizeF      = 0.015  ; Tamanho do marcador.

; Adiciona o marcador na posição x=0.63 e y=0.82.
gsn_polymarker_ndc(wks,0.63,0.82,gsres) 

; Adiciona o nome "AMZ LEGAL" no canto superior direito.
txres               = True       ; Habilita personalização.
txres@txFontHeightF = 0.015      ; Tamanho da fonte.
txres@txFontColor   = "Blue"     ; Cor da fonte.

; Desenha o nome "AMZ LEGAL" no canto superior direito  na posição 
; x=0.70 e y=0.82.
gsn_text_ndc(wks,"AMZ LEGAL",0.70,0.82,txres) 

frame(wks)

end
