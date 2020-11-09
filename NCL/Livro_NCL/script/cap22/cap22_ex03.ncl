; Nome do script: cap22_ex03.ncl

begin 

f = addfile("../../dados/slp.jan1979.dez2003.nc","r")

latS   =  25.0  ; Latitude sul.
latN   =  80.0  ; Latitude norte.
lonW   = -70.0  ; Longitude oeste.
lonE   =  40.0  ; Longitude leste.

yrStrt = 1979   ; Ano inicial.
yrLast = 2003   ; Ano final.

season = "DJF"  ; Escolha da estação a ser feita a EOF.

neof   = 3      ; Número de EOF's a serem calculadas.

optEOF      = True ; Personaliza a EOF.      
optEOF@jopt = 0    ; 0 = Usa a matrix de covariância para calcular a EOF.
                   ; Esse é o padrão.
                   ; 1 = Usa a matrix de correlação para calcular a EOF.
                   
optETS = False     ; Não personaliza a série temporal da EOF.

TIME = f->time     ; Importação da variável time do arquivo f.
YYYY = cd_calendar(TIME,-1)/100 ; Tempo no formato AAAAMM (opção -1). 
                                ; A divisão por 100 mostra apenas os 
                                ; anos no formato AAAA.
iYYYY = ind(YYYY.ge.yrStrt.and.YYYY.le.yrLast) ; Seleciona os índices 
                                               ; entre 1979 e 2003.

slp = f->slp(iYYYY,:,:) ; Seleciona a variável slp apenas no período 
                        ; de 1979 a 2003.

printVarSummary(slp) ; [time | 300] x [lat | 73] x [lon | 144]
                     ; time: [1569072..1787472]
                     ; lat: [90..-90]
                     ; lon: [ 0..357.5]

slp = lonFlip(slp)   ; Longitude no formato -180 a 180. Isso facilita 
                     ; Definer a longitude.

printVarSummary(slp) ; lon: [-180..177.5]

SLP  = month_to_season(slp,season) ; Extrai apenas a média de DJF.
nyrs = dimsizes(SLP&time)          ; Número de anos.

printVarSummary(SLP) ; [time | 25] x [lat | 73] x [lon | 144] => 25 DJF's

rad = 4.0*atan(1.0)/180.0  ; Conversão de graus para radianos.
clat = f->lat              ; Importa a variável lat do arquivo f.
clat = sqrt(cos(rad*clat)) ; Cria os valores que serão utilizados na 
                           ; ponderação.

wSLP           = SLP ; Copia os metadados de SLP para wSLP.
wSLP           = SLP*conform(SLP,clat,1) ; O valor 1 corresponde a 
                                         ; dimensão de clat que 
                                         ; equivale a SLP.
wSLP@long_name = "Wgt: "+wSLP@long_name  ; Atributo long_name foi 
                                         ; adicionado a wSLsP.

; Reordena as dimensões de wSLP para x(lat,lon,time) porque antes era 
; x(time,lat,lon).
x = wSLP({lat|latS:latN},{lon|lonW:lonE},time|:) 

eof    = eofunc_Wrap(x,neof,optEOF)    ; Calcula a EOF.      
eof_ts = eofunc_ts_Wrap(x,eof,optETS)  ; Calcula a série temporal da EOF.

print("==> " +eof@matrix)

printVarSummary(eof)    
; Dimensions and sizes:	[evn | 3] x [lat | 23] x [lon | 45]

printVarSummary(eof_ts) 
; Dimensions and sizes:	[evn | 3] x [time | 25]

; Normalização da série temporal.
dimx   = dimsizes(x) ; (0) 23 
                     ; (1) 45
                     ; (2) 25
mln    = dimx(1)     ; Número de pontos de longitude (45 pontos).
sumWgt = mln*sum(clat({lat|latS:latN}))  ; 45 * 17.1868
eof_ts = eof_ts/sumWgt                   ; Normaliza a série temporal. 
yyyymm = cd_calendar(eof_ts&time,-2)/100 ; Extrai apenas o ano e o mês 
                                         ; da série temporal no
                                         ; formato AAAAMM.

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex03a")

gsn_define_colormap(wks,"BlWhRe")        ; Escolha do mapa de cores.

plot = new(neof,graphic) ; Cria um arranjo gráfico para criar o painel
                         ; com as 3 figuras.

; Personalização da EOF.
res                      = True
res@gsnDraw              = False  ; Não desenha a figura.
res@gsnFrame             = False  ; Não avança o plot.
res@gsnAddCyclic         = False  ; Quando o dado for regional.
res@mpMinLatF            = latS   ; Aplica zoom ao mapa.
res@mpMaxLatF            = latN
res@mpMinLonF            = lonW
res@mpMaxLonF            = lonE
res@cnFillOn             = True   ; Habilita o preenchimento do mapa.
res@cnLinesOn            = False  ; Desabilita as linhas de contorno.
res@lbLabelBarOn         = False  ; Desabilita a barra de cores para 
                                  ; cada figura.
symMinMaxPlt(eof,16,False,res)    ; Define o valor mínimo e máximo. 
                                  ; 16 representa o número de
                                  ; contornos desejados. False quer 
                                  ; dizer que os valores estão dentro 
                                  ; do valor máx/min. Útil para criar 
                                  ; escalas de valores para a barra 
                                  ; de cores.

; Personalização do painel de figuras.
resP                    = True  ; Habilita personalização dos paineis.
resP@gsnMaximize        = True  ; A figura ocupa todo o espaço da página.
resP@gsnPanelLabelBar   = True  ; Barra de cores comum para todos os 
                                ; gráficos.

yStrt                   = yyyymm(0)/100      ; Extrai o primeiro ano.
yLast                   = yyyymm(nyrs-1)/100 ; Extrai o último ano.

resP@txString           = "SLP: "+season+": "+yStrt+"-"+yLast ; Título
 							      ; da figura.

do n=0,neof-1
   res@gsnLeftString  = "EOF "+(n+1)  ; Título do lado esquerdo da 
                                      ; figura.
   ; Título do lado direito da figura.
   res@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%" 
   ; Gera o plot das 3 EOF's.
   plot(n)=gsn_csm_contour_map_ce(wks,eof(n,:,:),res)       
end do

; Cria o painel com as 3 figuras (3 linhas e 1 coluna).
gsn_panel(wks,plot,(/neof,1/),resP) 

; Geração da figura da série temporal da EOF.

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex03b")

; Extrai apenas o ano, sem a divisão por 100, o valor sai como AAAAMM.
year = yyyymm/100 

rts                       = True   ; Habilita a personalização da série
                                   ; temporal.
rts@gsnDraw               = False  ; Não desenha a figura.
rts@gsnFrame              = False  ; Não avança o frame.
rts@vpHeightF             = 0.40   ; Altura da figura.
rts@vpWidthF              = 0.85   ; Largura da figura.
rts@vpXF                  = 0.10   ; Posição na página onde 
rts@vpYF                  = 0.75   ; ficará a figura.
rts@tiYAxisString         = "hPa"  ; Título do eixo y.      
rts@gsnYRefLine           = 0.0    ; Linha de referência em zero.   
rts@gsnXYBarChart         = True   ; Habilita gráfico de barras.
rts@gsnAboveYRefLineColor = "red"  ; Cor "red" acima da linha de 
                                   ; referência.
rts@gsnBelowYRefLineColor = "blue" ; Cor "blue" abaixo da linha de 
                                   ; referência.
rts@trYMaxF               = 0.15   ; Máximo valor do eixo y.
rts@trYMinF               = -0.15  ; Mínimo valor do eixo y.
rts@tmYLMinorOn           = False  ; Desliga os traços secundários do 
                                   ; eixo y.
rts@tmXBMode              = "Explicit"   ; Formata o eixo x do meu jeito.
rts@tmXBValues            = ispan(yStrt,yLast,1) ; Valores do eixo x.
rts@tmXBLabels            = year   ; Rótulos do eixo x inferior.
rts@tmXBLabelAngleF       = -90    ; Inclinação dos rótulos do eixo x.
rts@tmXBLabelJust         = "CenterRight" ; Alinhamento dos rótulos 
                                          ; do eixo x.
rts@tmXBLabelStride       = 2  ; Intervalo de valores que serão 
                               ; mostrados no eixo x.

; Personalização do painel para as 3 figuras.
rtsP             = True  ; Habilita personalização.
rtsP@gsnMaximize = True  ; A figura ocupa todo o espaço na página.
rtsP@txString    = "SLP: "+season+": "+yStrt+"-"+yLast ; Título da figura.

; Criação individual das figuras.
do n=0,neof-1
   rts@gsnLeftString  = "EOF "+(n+1) ; Título no lado esquerdo da 
                                     ; figura.
   ; Título no lado direito da figura.
   rts@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%" 
   plot(n) = gsn_csm_xy (wks,year,eof_ts(n,:),rts) ; Geração das figuras.
end do

; Cria o painel com as 3 figuras (3 linhas e 1 coluna).
gsn_panel(wks,plot,(/neof,1/),rtsP) 

end
