; Nome do script: cap20_ex08.ncl

begin

f = addfile("../../dados/ppt.clima.nc","r")

ppt = f->precip

printVarSummary(ppt) ; [time | 12] x [lat | 1] x [lon | 1]

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex08")

; Geração do primeiro mapa.
res                        = True
res@gsnFrame               = False      ; Não avança o frame.
res@gsnDraw                = False      ; Não desenha.
res@mpFillOn               = False      ; Mapa sem preenchimento.
res@mpOutlineBoundarySets  = "National" ; Mostra divisão dos países.
res@mpDataSetName          = "Earth..4" ; Para mostrar a divisão dos 
res@mpDataBaseVersion      = "MediumRes"; estados brasileiros são 
res@mpOutlineSpecifiers    = (/"Brazil:states"/); necessárias estas linhas.
res@mpMinLatF              = -30.    ; Latitude sul.
res@mpMaxLatF              = 10.     ; Latitude norte.
res@mpMinLonF              = -80.    ; Longitude oeste.
res@mpMaxLonF              = -30.    ; Longitude leste.
res@gsnMajorLonSpacing     = 5       ; Espaçamento do eixo x
                                     ; da longitude.
res@gsnMajorLatSpacing     = 5       ; Espaçamento do eixo y
                                     ; da latitude.
res@tmXBMinorOn            = False   ; Desabilita os traços 
                                     ; secundários dos 
res@tmYLMinorOn            = False   ; eixos x e y.
res@mpGeophysicalLineColor = "gray"  ; Cor da linha do contorno do 
                                     ; continente.
res@mpNationalLineColor    = "gray"  ; Cor da linha do contorno dos 
                                     ; países.
res@mpProvincialLineColor  = "gray"  ; Cor da linha do contorno da 
                                     ; divisão dos estados brasileiros.
res@tiMainString           = "Precipita"+cedil+atilde+"o: m"+eacute+ \
                             "dia na "+aacute+"rea"  

base_map = gsn_csm_map_ce(wks,res) ; Plot apenas do mapa.

; Geração do gráfico de linha de precipitação.
mpres                  = True
mpres@gsnFrame         = False         ; Não desenha o mapa.
mpres@gsnDraw          = False         ; Não avança o frame.
mpres@vpHeightF        = 0.21          ; Torna o segundo mapa
mpres@vpWidthF         = 0.21          ; um pouco menor.
mpres@xyMarkLineModes  = "MarkLines"   ; Linha com marcadores.
mpres@xyMarkers        =  16           ; Tipo de marcador.
mpres@xyMarkerColor    = "red"         ; Cor do marcador.
mpres@xyLineColors     = "red"         ; Cor da linha.
mpres@xyMarkerSizeF    = 0.01          ; Tamanho do marcador.
mpres@trYMaxF          = 10.0          ; Máximo valor do eixo y.
mpres@trYMinF          = 0.0           ; Mínimo valor do eixo y.
mpres@trXMinF          = 1.0           ; Mínimo valor do eixo x.
mpres@tmXBMode         = "Explicit"    ; Formata o eixo x do meu jeito.
mpres@tmXBValues       = ispan(1,12,1) ; Valores do eixo x.
mpres@tmXBLabels       = (/"J","F","M","A","M","J","J","A","S","O", \ 
                           "N","D"/) ; Rótulos do eixo x.
mpres@tiYAxisString        = "Precipita"+cedil+atilde+ \ 
                             "o (mm dia ~S~-1~N~)"  ; Título.
mpres@tmYLMinorOn          = False     ; Desabilita o minortick 
                                       ; secundário da eixo y.
mpres@tmXBLabelFontHeightF = 0.012     ; Tamanho da fonte do eixo x 
                                       ; inferior (XB).
mpres@tmYLLabelFontHeightF = 0.012     ; Tamanho da fonte do eixo y 
                                       ; esquerdo (YL).
mpres@tiYAxisFontHeightF   = 0.012     ; Tamanho da fonte do título do 
                                       ; eixo y.
mpres@tmXBLabelJust        = "CenterCenter" ; Alinhamento dos rótulos 
                                            ; do eixo x.

plot = gsn_csm_xy(wks,ispan(1,12,1),ppt(:,0,0),mpres)

; Anexa o gráfico de linha ao mapa.
amres                  = True         ; Habilita os recursos para 
                                      ; anotação.
amres@amParallelPosF   = -0.30        ; Desloca a figura na direção x.
amres@amOrthogonalPosF = 0.25         ; Desloca a figura na direção y.
amres@amJust           = "BottomLeft" ; Posicionamento da figura 
                                      ; (parte inferior esquerda).

; Anexa o gráfico de linha ao mapa. O plot é anexado ao base_map.
map_anno = gsn_add_annotation(base_map,plot,amres)  

draw(base_map)
frame(wks)

end
