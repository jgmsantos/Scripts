; Nome do script: cap22_ex02.ncl

begin

; Os dados são referentes aos meses de DJF, são 90 meses.
; asst é a anomalia de SST e aprec é a anomalia de precipitação.

f = addfile("../../dados/anom.prec.dez1980.fev2010.nc","r")
g = addfile("../../dados/anom.sst.dez1980.fev2010.nc","r")

aprec = f->precip ; Dado espacial.

; [time | 90] x [lat | 72] x [lon | 144]
; time: [66078..76732]
; lat: [88.75..-88.75]
; lon: [1.25..358.75]

asst  = short2flt(g->anom) ; Série temporal.

; [time | 90] x [zlev | 1] x [lat | 1] x [lon | 1]
; time: [46355..57009]
; zlev: [ 0.. 0]
; lat: [   0..   0]
; lon: [   0..   0]

printVarSummary(aprec)
printVarSummary(asst)

; nt = 90, ny = 72, nx = 144. O que nos interessa é o número de tempos.
dim = dimsizes(aprec)

nt  = dim(0) ; Número de tempos do arquivo

x = aprec(:,::-1,:) ; Inverte a latitude do dado de precipitação.

y = asst(:,0,0,0) ; asst precisar ser uma série temporal. 
                  ; Apenas a dimensão tempo precisar 
                  ; variar, enquanto as demais são fixas.

r = escorc_n(x,y,0,0) ; Calcula a correlação de Pearson 
                      ; entre uma série temporal (asst) 
                      ; e um dado bidimensional (aprec).

printVarSummary(r)  ; [72] x [144]

var_aux = x(0,:,:)  ; Variável auxiliar para copiar as 
                    ; dimensões e coordenadas para a 
                    ; variável r.

copy_VarCoords(var_aux,r) ; Copia as dimensões e as 
                          ; coordenadas de var_aux para r.

printVarSummary(r)   ; [lat | 72] x [lon | 144]
                     ; lat: [-88.75..88.75]
                     ; lon: [1.25..358.75]

prob = rtest(r,nt,0) ; Calcula a estatística
                     ; t = r * sqrt( (Nr-2) / (1-r^2) )
                     ; r = correlação e nt é o tamanho da
                     ; amostra (número de tempos) e 0 não 
                     ; tem uso.

printVarSummary(prob)

copy_VarCoords(var_aux,prob) ; Copia as dimensões e as coordenadas de 
                             ; var_aux para prob.

printVarSummary(prob)

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex02")

; Definição do mapa de cores a ser usado.
gsn_define_colormap(wks,"temp_diff_18lev") 

res1                      = True
res1@cnFillOn             = True    ; Habilita preenchimento.
res1@cnLinesOn            = False   ; Desabilita as linhas de contorno.
res1@tiMainString         = "Correla"+cedil+atilde+  \ 
                            "o entre ASST~B~NINO3.4~N~ e APREC"
res1@gsnCenterString      = "Regi"+atilde+ \ 
                            "o pontilhada: 95% de " +\+
                            "signific"+acirc+"ncia."
res1@cnFillMode           = "RasterFill" ; (grfill do GrADS).   
; Escala de cores do meu jeito.
res1@cnLevelSelectionMode = "ExplicitLevels" 
; Valores que vão aparecer na barra de cores.
res1@cnLevels             = ispan(-9,9,1)/10. 
; res1@cnFillColors => Para cada valor da correlação está 
; associado uma cor da escala de cores da tabela de cores temp_diff_18lev.
res1@cnFillColors         = (/2,3,4,5,6,7,8,9,10,0,0,12,13, \
                             14,15,16,17,18,19,20/)
res1@gsnMajorLonSpacing   = 30 ; Espaçamento do eixo x.
res1@gsnMajorLatSpacing   = 15 ; Espaçamento do eixo y.
res1@tmXBMinorOn          = False ; Desabilita os traços secundários 
res1@tmYLMinorOn          = False ; dos eixos x e y.
res1@gsnFrame             = False ; Não avança o frame.
res1@gsnDraw              = False ; Não desenha.
res1@mpCenterLonF         = -180  ; Centraliza o mapa em -180.

; Cria o plot da correlação.
plot1 = gsn_csm_contour_map(wks,r,res1) 

alfa = 0.207 ; Valor tabelado para 95% de significância e n = 90 = nt.

res2                       = True
res2@gsnFrame              = False ; Não avança o frame.
res2@gsnDraw               = False ; Não desenha.
; Defino a escala dos contornos do meu jeito.
res2@cnLevelSelectionMode  = "ExplicitLevels" 
res2@cnInfoLabelOn         = False ; Desabilita as informações de 
                                   ; contorno.
res2@cnLinesOn             = False ; Desabilita as linhas de contorno.
res2@cnLineLabelsOn        = False ; Desabilita os rótulos dos contornos.
res2@cnFillScaleF          = 0.7   ; Densidade do pontilhado 
                                   ; no mapa. Quanto menor o valor, 
                                   ; maior será a densidade de pontos.

; Cria o mapa da probabilidade.
plot2   = gsn_csm_contour(wks,prob,res2)
; Preenche todas as regiões menores do que alfa com 
; o padrão 17 (pontilhado).      
plot2   = ShadeLtContour(plot2,alfa,17)       

overlay (plot1, plot2) ; Sobrepõe os campos, plot2 sobre o plot1.

draw(wks)

end
