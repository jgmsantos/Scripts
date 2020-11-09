; Nome do script: cap21_ex56.ncl

begin

; O arquivo pr.djf.cx2.txt possui 4 colunas na ordem a
; baixo com valores de precipitação (mm/dia) para o 
; nordeste da Amazônia para os meses de DJF (1979 a 2005).
; Col1   Col2      Col3      Col4   
; GPCP ACCESS1-0 BCC-CSM1.1 CANESM2

atxt     = "../../dados/pr.djf.cx2.txt"  ; Nome do arquivo no formato txt.
nlinhas  = numAsciiRow(atxt) ; Número de linhas do arquivo.
ncolunas = numAsciiCol(atxt) ; Número de colunas do arquivo.

f = asciiread(atxt,(/nlinhas,ncolunas/),"float") 

modelos = (/"GPCP","ACCESS1-0","BCC-CSM1.1","CANESM2"/) 

opt           = True ; Habilita personalização 
                     ; da estatística.
opt@PrintStat = True ; Mostra na tela o resultado
                     ; da estátistica da função stat_dispersion. 

y = new((/dimsizes(modelos),nlinhas,ncolunas+1/),float)

x = ispan(1,ncolunas,1) ; Valores para o eixo x.

do j = 0,dimsizes(modelos)-1
   g = stat_dispersion(f(:,j),opt)
   y(j,:,0) = g(2)  ; Tamanho da haste inferior.
   y(j,:,1) = g(7)  ; Primeiro quartil.
   y(j,:,2) = g(8)  ; Mediana.
   y(j,:,3) = g(11) ; Terceiro quartil.
   y(j,:,4) = g(14) ; Tamanho da haste superior.
end do

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex56")

res                 = True         ; Personalização do boxplot.
res@tmXBLabels      = modelos      ; Rótulos do eixo x.
res@tiMainString    = "Precipita"+cedil+atilde+ \ 
                      "o sobre o nordeste da Amaz"+ocirc+"nia"
res@trYMinF         = 0.0         ; Mínimo valor do eixo y.      
res@trYMaxF         = 12.0        ; Máximo valor do eixo y.
res@tmYLMode        = "Manual"	  ; Eixo y esquerdo (YL) de forma
                                  ; manual.
res@tmYLTickStartF  = res@trYMinF ; Onde começam os valores do eixo y.
res@tmYLTickEndF    = res@trYMaxF ; Onde terminam os valores do eixo y.
res@tmYLTickSpacingF= 1           ; Espaçamento entre os rótulos.
res@tmYLMinorOn     = False       ; Desliga o minortick do eixo y 
                                  ; esquerdo.
res@tmYRBorderOn    = True        ; Habilita a borda do eixo y direito.
res@tmXTBorderOn    = True        ; Habilita a borda do eixo x superior.
res@tmXBLabelFontHeightF = 0.014  ; Tamanho da fonte do eixo x inferior.
res@tiYAxisString   = "Precipita"+cedil+atilde+"o (mm/dia)"

llres                   = True   ; Personalização das linhas do boxplot.
llres@gsLineThicknessF  = 2.5    ; Espessura da linha.

opti           = True ; Habilita personalização da caixa.
opti@boxWidth  = 0.35 ; Largura da caixa do boxplot.
opti@boxColors = (/"blue","red","green","orange"/) ; Cores de cada caixa.

plot = boxplot(wks,x,y(:,dimsizes(modelos),:),opti,res,llres)

draw(wks)
frame(wks)

end
