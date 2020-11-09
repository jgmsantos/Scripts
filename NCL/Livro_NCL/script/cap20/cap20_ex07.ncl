; Nome do script: cap20_ex07.ncl

begin

; GPCP    ACCESS1-0 CCSM4   HADGEM2-CC HADGEM2-ES => primeira linha
; 1804.4  1779.7    1893.3  1739.0     1898.5     => segunda linha

f = asciiread("../../dados/pr.obs.model.txt",(/2,5/),"float")

y = f(1,:)        ; Lê a segunda linha (1) e todos os seus valores (:).
x = (/1,2,3,4,5/) ; Valores para o eixo x.

labels = (/"GPCP","ACCESS1-0","CCSM4","HADGEM2-CC","HADGEM2-ES"/)

nboxes = dimsizes(labels) ; Número de legendas.

cores  = (/"firebrick","red","orange","green","navy"/)

wks = gsn_open_wks("pdf","../../figuras/cap20/cap20_ex07")

res                       = True  ; Habilita personalização do gráfico.         
res@gsnDraw               = False ; Não gera a figura.
res@gsnFrame              = False ; Não avançao o frame.
res@gsnXYBarChart         = True  ; Habilita gráfico de barras.
res@gsnXYBarChartBarWidth = 0.75  ; Espessura do gráfico de barras.
res@gsnXYBarChartColors   = cores ; Cores das barras.
res@tmXBOn                = False ; Desabilita o tickmarks do eixo x 
                                  ; inferior.
res@tmXTOn                = False
res@trYMinF               = 0     ; Mínimo valor do eixo y.
res@trYMaxF               = 2500  ; Máximo valor do eixo y.
res@tmYLMode              = "Manual"
res@tmYLTickStartF        = res@trYMinF ; Para personalizar o eixo y 
                                        ; esquerdo (YL)
res@tmYLTickEndF          = res@trYMaxF ; do gráfico de forma manual.
res@tmYLTickSpacingF      = 500         ; Espaçamento do eixo y.
res@tmYLMinorOn           = False
res@trXMinF               = 0           ; Mínimo valor do eixo x.
res@trXMaxF               = 6           ; Máximo valor do eixo x.
res@tiMainString          = "Precipita"+cedil+atilde+ \
                            "o anual na Amaz"+ocirc+"nia"

plot = gsn_csm_xy (wks,x,y,res) ; Geração do gráfico de barras.

; Criação da legenda.
   
lbres                    = True
lbres@lbAutoManage       = True        ; Necessário para controlar o 
                                       ; tamanho das legendas.
lbres@vpWidthF           = 0.2         ; Largura da legenda.
lbres@vpHeightF          = 0.15        ; Altura da legenda.
lbres@lbBoxMajorExtentF  = 0.75        ; Espaçamento entre os nomes na
                                       ; legenda.
lbres@lbFillColors       = cores       ; Cores de cada barra da legenda.
lbres@lbMonoFillPattern  = True        ; Preechimento das barras da
                                       ; legenda.
lbres@lbLabelFontHeightF = 0.08        ; Tamanho da fonte da legenda.
lbres@lbLabelJust        = "CenterLeft"; Posição da legenda.
lbres@lbPerimOn          = False       ; Não desenha borda em torno
                                       ; da legenda.

lbid = gsn_create_labelbar(wks,nboxes,labels,lbres) ; Gera a legenda.

; Criação das duas figuras em uma só.

amres                  = True
amres@amJust           = "TopRight" ; Local onde ficará a legenda.
amres@amParallelPosF   =  -0.17     ; Posição em x em relação a figura.
amres@amOrthogonalPosF = -0.5       ; Posição em y em relação a figura.

annoid = gsn_add_annotation(plot,lbid,amres) ; Anexa a legenda (lbid) a 
                                             ; figura de barras (plot).
draw(plot)
frame(wks)

end
