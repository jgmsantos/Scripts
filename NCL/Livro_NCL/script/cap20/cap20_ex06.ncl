; Nome do script: cap20_ex06.ncl

begin

wks  = gsn_open_wks("pdf", "../../figuras/cap20/cap20_ex06")

; Geração do primeiro mapa (mapa sobre a América do Sul).

res                       = True        ; Habilita os recursos do mapa.
res@gsnMaximize           = True        ; A figura ocupa toda a página.
res@gsnFrame              = False       ; Não avança o frame.
res@gsnDraw               = False       ; Não desenha.
res@mpFillOn              = False       ; Mapa sem preenchimento.
res@mpOutlineBoundarySets = "National"  ; Mostra divisão dos países.
res@mpDataSetName         = "Earth..4"  ; Para a mostrar a divisão 
                                        ; dos estados      
res@mpDataBaseVersion     = "MediumRes" ; brasileiros, são necessárias 
res@mpOutlineSpecifiers   = (/"Brazil:states"/); estas três linhas.
res@mpMinLatF             = -60.               ; Latitude sul.
res@mpMaxLatF             = 20.                ; Latitude norte.
res@mpMinLonF             = -100.              ; Longitude oeste.
res@mpMaxLonF             = -20.               ; Longitude leste.
res@gsnMajorLonSpacing    = 10    ; Espaçamento do eixo x da longitude.
res@gsnMajorLatSpacing    = 10    ; Espaçamento do eixo y da latitude.
res@tmXBMinorOn           = False ; Desabilita os traços secundários dos 
res@tmYLMinorOn           = False ; eixos x e y.

base_map = gsn_csm_map_ce(wks,res) ; Cria somente o mapa.

; Geração do segundo mapa (mapa global).

mpres                       = True   ; Habilita os recursos para o mapa.
mpres@gsnFrame              = False  ; Não desenha o mapa.
mpres@gsnDraw               = False  ; Não avança o frame.
mpres@pmTickMarkDisplayMode = "Always" ; Habilita os tickmark 
                                       ; (tracinhos) do mapa.
mpres@tmXBLabelFontHeightF  = 0.01   ; Tamanho da fonte do eixo x. 
mpres@tmYLLabelFontHeightF  = 0.01   ; Tamanho da fonte do eixo y. 
mpres@mpOutlineOn           = True   ; Desenha as linhas no entorno 
                                     ; do mapa.
mpres@vpHeightF             = 0.3    ; Torna o segundo mapa
mpres@vpWidthF              = 0.3    ; um pouco menor.

map2 = gsn_csm_map_ce(wks,mpres)

; Anexa um mapa sobre o outro mapa.

amres                  = True      ; Habilita os recursos para anotação.
amres@amParallelPosF   = 0.105     ; Desloca a figura na direção x.
amres@amOrthogonalPosF = 0.44      ; Desloca a figura na direção y.
amres@amJust           = "BottomLeft" ; Posicionamento da figura 
                                      ; (parte inferior esquerda).

; Anexa o mapa a outro mapa. O map2 é anexado ao base_map.
map_anno = gsn_add_annotation(base_map,map2,amres)  

draw(base_map)
frame(wks)

end
