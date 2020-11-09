; Nome do script: cap22_ex04.ncl

begin

f = addfile("../../dados/sst.anual.1984.2012.nc","r") ; Dado anual de SST.

neof = 3 ; Número de EOF's a serem feitas.

yrStrt = 1984   ; Ano inicial.
yrLast = 2012   ; Ano final.
TIME   = f->time                  ; Importação da variável time do 
                                  ; arquivo f.
YYYY   = cd_calendar(TIME,-1)/100 ; Tempo no formato AAAAMM (opção -1).
                                  ; A divisão por 100 mostra apenas 
                                  ; os anos no formato AAAA.
iYYYY = ind(YYYY.ge.yrStrt.and.YYYY.le.yrLast) ; Seleciona os índices 
                                               ; entre 1984 e 2012.

x = short2flt(f->sst(iYYYY,0,:,:)) ; Importa a variável sst do arquivo f.

printVarSummary(x) ; [time | 29] x [lat | 31] x [lon | 86]

X = x(lat|:,lon|:,time|:) ; Reordena a variável de forma que a dimensão 
                          ; time seja a dimensão mais a direita.

optEof = True
eof    = eofunc_Wrap(X,neof,optEof)
eof_ts = eofunc_ts_Wrap(X,eof,False)

printVarSummary(eof)    ; [evn | 3] x [lat | 31] x [lon | 86]
printVarSummary(eof_ts) ; [evn | 3] x [time | 29]

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex04a")

gsn_define_colormap(wks,"posneg_1")       ; Define a tabela de cores a 
                                          ; ser utilizada.

plot = new(neof,graphic)                  ; Cria um arranjo gráfico para
                                          ; as 3 figuras.

res                              = True ; Habilita os recursos para a 
                                        ; figura.        
res@gsnDraw                      = False; Não desenha a figura.
res@gsnFrame                     = False; Não avança o plot.
res@gsnAddCyclic                 = False; Quando o dado for regional.
res@mpMinLatF                    = -30. ; Aplica zoom ao mapa.
res@mpMaxLatF                    = 30.  ;
res@mpMaxLonF                    = -70. ;
res@mpMinLonF                    = -180.;
res@gsnMajorLonSpacing           = 10   ; Espaçamento da longitude.
res@gsnMajorLatSpacing           = 10   ; Espaçamento da latitude.
res@gsnContourZeroLineThicknessF = 5. 	; Espessura do contorno zero.
res@cnFillOn                     = True ; Habilita gráfico preenchido.
res@lbLabelBarOn                 = False; Desabilita a legenda individual.
res@cnLineLabelsOn               = False; Desabilita os rótulos dos 
                                        ; contornos.
symMinMaxPlt(eof,16,False,res)          ; Define o valor mínimo e máximo. 
                                        ; 16 representa o número de 
                                        ; contornos desejados. 
                                        ; False quer dizer que os 
                                        ; valores estão dentro 
                                        ; do valor máx/min. Útil para 
                                        ; criar escalas de valores 
                                        ; para a barra de corres.

; Recursos para a criação do painel de figuras.
resP                     = True         ; Habilita os recursos para o 
                                        ; painel.
resP@gsnMaximize         = True         ; A figura ocupa toda a página.
resP@gsnPanelLabelBar    = True         ; Barra de cores comum para 
                                        ; todas as figuras.
resP@lbLabelAutoStride   = True         ; Intervalo dos valores na 
                                        ; escala de cores.
resP@txString            = "SST: "+yrStrt+"-"+yrLast ; Título da figura.

do n=0,neof-1
   res@gsnLeftString  = "EOF "+(n+1) ; Título do lado esquerdo da figura.  
   ; Título do lado direito da figura.
   res@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%" 
   plot(n) = gsn_csm_contour_map_ce(wks,eof(n,:,:),res) ; Cria o plot.
end do

gsn_panel(wks,plot,(/neof,1/),resP) ; Gera o painel com as 3 figuras.

; Plot da série temporal da EOF.

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex04b")

eof_ts@long_name = "Amplitude" ; Adiciona o atributo lon_name a variável.

rts                       = True   ; Habilita a personalização da série 
                                   ; temporal.
rts@gsnDraw               = False  ; Não desenha a figura.
rts@gsnFrame              = False  ; Não avança o frame.
rts@vpHeightF             = 0.40   ; Altura da figura.
rts@vpWidthF              = 0.85   ; Largura da figura.
rts@vpXF                  = 0.10   ; Posição na página onde 
rts@vpYF                  = 0.75   ; ficará a figura.
rts@gsnYRefLine           = 0.0    ; Linha de referência em zero.   
rts@gsnAboveYRefLineColor = "red"  ; Cor "red" acima da linha de 
                                   ; referência.
rts@gsnBelowYRefLineColor = "blue" ; Cor "blue" abaixo da linha de 
                                   ; referência.
rts@trYMaxF               = 30.    ; Máximo valor do eixo y.
rts@trYMinF               = -30.   ; Mínimo valor do eixo y.
rts@tmYLMinorOn           = False  ; Desliga os traços secundários do 
                                   ; eixo y.
rts@tmXBMode              = "Explicit"  ; Formata o eixo x do meu jeito.
rts@tmXBValues            = ispan(yrStrt,yrLast,1) ; Valores do eixo x.
rts@tmXBLabels            = ispan(yrStrt,yrLast,1) ; Rótulos do eixo x 
                                                   ; inferior.
rts@tmXBLabelAngleF       = -90  ; Inclinação dos rótulos do eixo x.
rts@tmXBLabelJust         = "CenterRight" ; Alinhamento dos rótulos 
                                          ; do eixo x.
rts@tmXBLabelStride       = 2 ; Intervalo de valores que serão mostrados 
                              ; no eixo x.
; panel plot only resources
rtsP                     = True ; Habilita personalização do painel.
rtsP@gsnMaximize         = True ; A figura ocupa todo o espaço na página.
rtsP@txString            = "SST: "+yrStrt+"-"+yrLast ; Título da figura.

do n=0,neof-1
   ; Título do lado esquerdo da figura.
   rts@gsnLeftString  = "EOF "+(n+1) 
   ; Título do lado direito da figura.
   rts@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%" 
   plot(n) = gsn_csm_xy (wks,ispan(yrStrt,yrLast,1),eof_ts(n,:),rts)
end do

gsn_panel(wks,plot,(/neof,1/),rtsP) ; Cria o painel com as 3 figuras.

end
