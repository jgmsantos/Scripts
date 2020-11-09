; Nome do script: cap22_ex01.ncl

begin

; O objetivo desse script é exercitar o cálculo da correlação entre duas
; variáveis (ppt e rol). Elas possuem números de tempos e resolução 
; espacial diferentes.
; Utilizou-se a função f2fosh_Wrap para uniformizar o dado de rol 
; removendo um ponto de latitude para ficar igual ao dado de 
; precipitação. A função cd_calendar e ind são utilizadas para selecionar
; os tempos de interesse. Para utilizar a função f2fosh_Wrap, a 
; latitude deve estar orientada de sul para norte.

; short olr(time, lat, lon)
; O dado vai de jan2000 a dez2009.
; lat: [90..-90] => norte para sul
; lon: [ 0..357.5]

f = addfile("../../dados/olr.jan2000.dez2009.nc","r") 

; float precip(time, lat, lon)
; O dado vai de jan1979 a dez2015.          
; lat: [88.75..-88.75] => norte para sul.
; lon: [1.25..358.75]

g = addfile("../../dados/precip.mon.mean.nc","r") 

; O NCL lê os índices correspondentes a uma determinada data e não a 
; data em si. Nesse caso, foram criadas duas variáveis TIME1 e TIME2 
; porque a data de interesse possui índice diferente no arquivo 
; "f" e "g". Por exemplo, no arquivo "f" a data 200001 corresponde ao 
; índice 0, enquanto que no arquivo "g" essa data corresponde ao 
; índice 252.
 
yrStrt1 = 200001 ; Tempo inicial no formato AAAAMM.
yrLast1 = 200912 ; Tempo final no formato AAAAMM.

TIME1   = f->time ; Exportação da variável time do arquivo "f".
YYYYMM1 = cd_calendar(TIME1,-1)  ; Tempo no formato AAAAMM (-1).
; Índice que corresponde ao tempo yrStrt1.
ti1 = ind(YYYYMM1.eq.yrStrt1)
; Índice que corresponde ao tempo yrLast1.
tf1 = ind(YYYYMM1.eq.yrLast1)

TIME2   = g->time ; Exportação da variável time do arquivo "g".
YYYYMM2 = cd_calendar(TIME2,-1)  ; Tempo no formato AAAAMM (-1)
; Índice que corresponde ao tempo yrStrt1.
ti2 = ind(YYYYMM2.eq.yrStrt1)
; Índice que corresponde ao tempo yrLast1.
tf2 = ind(YYYYMM2.eq.yrLast1)

; Latitude tem que ser de sul para norte (::-1).
rol     = short2flt(f->olr(ti1:tf1,::-1,:)) 
ppt     = g->precip(ti2:tf2,::-1,:)

; Cria média temporal para DJF.
ppt_DJF = month_to_season(ppt,"DJF") 
; Cria média temporal para DJF.
rol_DJF = month_to_season(rol,"DJF") 

; Realiza o regridding para deixar o dado com a mesma 
; resolução espacial de ppt.
x = f2fosh_Wrap(rol_DJF) 
y = ppt_DJF

printVarSummary(x)  ; time: [1753152..1832064]
                    ; lat: [-88.75..88.75]
                    ; lon: [1.25..358.75]

printVarSummary(y)  ; time: [65378..68665]
                    ; lat: [-88.75..88.75]
                    ; lon: [1.25..358.75]

; Calcula a correlação de Pearson na dimensão tempo (0) para as duas
; variáveis.

r = escorc_n(x,y,0,0) 

printVarSummary(r) ; [72] x [144]

; Varíavel auxiliar para copiar as dimensões e coordenadas para r. Como 
; foi fixado o primeiro tempo (poderia ser outro qualquer), com isso, 
; ocorre a redução de dimensão de 3 para 2, dessa forma é possível copiar
; as dimensões de var_aux para r com o copy_VarCoords, uma vez que r 
; possui apenas as dimensões latitude e longitude.

var_aux = ppt(0,:,:)

; Copia as coordenadas e dimensões de var_aux para r.
copy_VarCoords(var_aux,r) 
 
printVarSummary(r)   ; [lat | 72] x [lon | 144]

wks = gsn_open_wks("pdf","../../figuras/cap22/cap22_ex01")

; Definição da escala de cores.
gsn_define_colormap(wks,"CBR_coldhot") 

res                      = True
res@mpMaxLatF            = 20.0   ; Latitude sul.       
res@mpMinLatF            = -60.0  ; Latitude norte.
res@mpMinLonF            = -100.0 ; Longitude oeste.
res@mpMaxLonF            = -10.0 ; Longitude leste.
res@cnFillOn             = True  ; Habilita preenchimento.
res@cnLinesOn            = False ; Desabilita as linhas de contorno.
res@tiMainString         = "Correla"+cedil+atilde+"o" +\
                           " entre prec e ROL"
res@cnFillMode           = "RasterFill" ; (grfill do GrADS).   
; Escala de cores do meu jeito.
res@cnLevelSelectionMode = "ExplicitLevels" 
; Valores que vão aparecer na barra de cores.
res@cnLevels             = (/-0.8,-0.6,-0.4,-0.2,0,0.2, \
                              0.4,0.6,0.8/) 
; Para cada valor está associada uma cor da escala de cores CBR_coldhot.
res@cnFillColors         = (/2,3,4,5,0,0,9,10,11,12/) 
res@gsnMajorLonSpacing   = 10 ; Espaçamento do eixo x.
res@gsnMajorLatSpacing   = 10 ; Espaçamento do eixo y.
res@tmXBMinorOn          = False ; Desabilita os traços 
                                 ; secundários 
res@tmYLMinorOn          = False ; dos eixos x e y.

plot = gsn_csm_contour_map_ce(wks,r,res)

end
