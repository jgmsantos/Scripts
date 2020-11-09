; Nome do script: cap21_ex48.ncl

begin

; Variáveis necessárias: 
; Componente u [u] em níveis verticais (m/s).
; Componente v [v] em níveis verticais (m/s).
; Temperatura do ar [air] em níveis verticais (°C).
; Umidade relativa do ar [rhum] em níveis verticais (%).
; Precipitação (mm/hora).
; Temperatura à superfície (°C).

; As dimensões de u, v, air e rhum precisam ter a seguinte disposição 
; level e time e não time e level, sem isso, vai dar erro. Por isso, é 
; feita a reordenação das dimensões. 

f = addfile("../../dados/meteograma.uwnd.vwnd.air.pres.prec.t2m.nc","r")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Altere as informações abaixo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
datai = 1979010100 ; Data inical no formato AAAMMDDHH.
dataf = 1979010418 ; Data final no formato AAAMMDDHH.
dt    = 6          ; Intervalo dos dados de entrada (00, 06, 12 e 18, 
                   ; por isso, 6(h)).
z1    = 1000       ; Nível vertical inferior.
z2    = 400        ; Nível vertical superior.
lat   = -23        ; Latitude de interesse.
lon   = 314        ; Longitude de interesse.
no    = 4          ; Número de observações por dia. Dia 1 = 0,6,12,18. 
                   ; Dia 2 = 0,6,12,18 e etc.
nlocal= "S"+atilde+"o Paulo" ; Digite apenas o nome do local.
u     = "uwnd"     ; Nome da variável u. 
v     = "vwnd"     ; Nome da variável v.
t     = "air"      ; Nome da variável t.
ur    = "rhum"     ; Nome da variável ur.
ppt   = "pre"      ; Nome da variável ppt.
tsfc  = "tmp"      ; Nome da variável tsfc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

anoi       = str_get_cols(tostring(datai),0,3) ; Guarda o ano inicial 
                                               ; do datai para usar em 
                                               ; yyyymmddhh. O datai foi 
                                               ; convertido para string
anof       = str_get_cols(tostring(dataf),0,3) ; Guarda o ano final do 
                                               ; dataf para usar em 
                                               ; yyyymmddhh. O dataf foi
                                               ; convertido para string
yyyymmddhh = yyyymmddhh_time(tointeger(anoi),tointeger(anof),dt, \ 
                             "integer")
ti         = ind(datai.eq.yyyymmddhh) ; Índice que será utilizado na 
                                      ; dimensão tempo para selecionar 
tf         = ind(dataf.eq.yyyymmddhh) ; o período de interesse.
nd         = ((tf-ti)+1)/no           ; Número de dias desejado.
nt         = (nd*no*dt)-1             ; Calcula o tempo total a ser 
                                      ; feito.
diai       = str_get_cols(tostring(datai),6,7)
mes        = str_get_cols(tostring(datai),4,5)
ano        = str_get_cols(tostring(datai),0,3)
horai      = str_get_cols(tostring(datai),8,9)
dlocal     = diai+"/"+mes+"/"+ano+" 00"+horai+"z"
nome_data  = nlocal+" - "+dlocal

if (mes.eq."01") then mesc = "Jan" end if
if (mes.eq."02") then mesc = "Fev" end if
if (mes.eq."03") then mesc = "Mar" end if
if (mes.eq."04") then mesc = "Abr" end if
if (mes.eq."05") then mesc = "Mai" end if
if (mes.eq."06") then mesc = "Jun" end if
if (mes.eq."07") then mesc = "Jul" end if
if (mes.eq."08") then mesc = "Ago" end if
if (mes.eq."09") then mesc = "Set" end if
if (mes.eq."10") then mesc = "Out" end if
if (mes.eq."11") then mesc = "Nov" end if
if (mes.eq."12") then mesc = "Dez" end if

; short air(time, level, lat, lon) 
;            20 ,   12 , 73 , 144
; Como foram fixadas as dimensões lat e lon, houve a redução de 4 para 
; 2 dimensões, isto é, time e level.
tempisobar  = short2flt(f->$t$(ti:tf,{z1:z2},{lat},{lon})) 

; Reordenando de time e level para level e time e convertendo de Kelvin
; para Celsius.
tempisobarN = tempisobar(level|:,time|:)-273.15 

levels = f->level(0:6)  ; Dimensions and sizes: [level | 7]

taus = ispan(0,nt,dt) ; Horário da observação. 0,6,12,18,24,30,36,...,114.

; short (time, level, lat, lon) = 20,12,73,144
rh = short2flt(f->$ur$(ti:tf,{z1:z2},{lat},{lon})) 
rhN = rh(level|:,time|:) ; Reordenando as dimensões para level e time.

; short (time, level, lat, lon) = 20,12,73,144
ugrid = short2flt(f->$u$(ti:tf,{z1:z2},{lat},{lon})) 
ugridN = ugrid(level|:,time|:) ; Reordenando as dimensões para level 
                               ; e time.

; short (time, level, lat, lon) = 20,12,73,144
vgrid = short2flt(f->$v$(ti:tf,{z1:z2},{lat},{lon})) 
vgridN = vgrid(level|:,time|:) ; Reordenando as dimensões para level 
                               ; e time.

; double pre(time, lat, lon) = 20,73,144
rain = f->$ppt$(ti:tf,{lat},{lon}) 

; double tmp(time, lat, lon) = 20,73,144
tempht = f->$tsfc$(ti:tf,{lat},{lon}) 

; Suavização da temperatura e umidade relativa. Opcional.
smothtemp = smth9(tempisobarN,0.50,-0.25,False)
smothrh   = smth9(rhN,0.50,-0.25,False)

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex48")

; Define novas cores.
colors = (/                                                          \
             (/255,255,255/),   (/  0,  0,  0/),   (/255,255,255/),  \
             (/255,255,255/),   (/255,255,255/),   (/240,255,240/),  \
             (/220,255,220/),   (/190,255,190/),   (/120,255,120/),  \
             (/ 80,255, 80/),   (/ 50,200, 50/),   (/ 20,150, 20/),  \
             (/255,  0,  0/)                                         \
             /) / 255.0

gsn_define_colormap(wks,colors) ; Cria um mapa de cores com as cores 
                                ; acima.

; Habilita a personalização das variáveis.
rh_res      = True
temp_res    = True
uv_res      = True
rain_res    = True
tempsfc_res = True

; Recursos para rh_res, temp_res e uv_res.
rh_res@trYReverse   = True     ; Inverte os valores do eixo y.
rh_res@gsnDraw      = False    ; 
rh_res@gsnFrame     = False    ; 
rh_res@vpXF         = 0.15     ; Localização em x da figura.
rh_res@vpYF         = 0.90     ; Localização em y da figura.
rh_res@vpWidthF     = 0.7      ; Largura.
rh_res@vpHeightF    = 0.40     ; Altura.

temp_res            = rh_res   ; Copia até aqui os recursos de rh_res 
uv_res              = rh_res   ; para temp_res e uv_res.

; Recursos para a umidade relativa.
rh_res@gsnSpreadColors   =  True     ; Utiliza todas as cores.
rh_res@gsnSpreadColorEnd = -2        ; Salva a última cor.
rh_res@cnFillOn          = True      ; Gráfico preenchido.
rh_res@tiMainString      = nome_data ; Título da figura.
rh_res@sfXArray          = taus      ; Valores do eixo x.
rh_res@sfYArray          = levels    ; Valores do eixo y.
rh_res@tiYAxisString     = "Press"+atilde+"o (hPa)" ; Título do eixo y.
rh_res@cnInfoLabelOn     = False  ; Desabilita as informações do 
                                  ; contorno.

; Personalização do eixo y esquerdo do gráfico de seção vertical.
rh_res@tmYLMode          = "Explicit" ; Defino o eixo y esquerdo (L) do 
                                      ; meu jeito.
rh_res@tmYLValues        = levels     ; Valores do eixo y.
rh_res@tmYLLabels        = levels     ; Rótulos para cada valor do 
                                      ; eixo y.

; Personalização do eixo x inferior do gráfico de seção vertical.
rh_res@tmXBMode          = "Explicit" ; Defino o eixo x inferior (B) do 
                                      ; meu jeito.
rh_res@tmXBValues        = taus       ; Valores do eixo x.
                           ; Rótulos do eixo x.
rh_res@tmXBLabels        = (/tointeger(diai)+mesc  ,"06z","12z","18z",\
                             tointeger(diai)+1+mesc,"06z","12z","18z",\
                             tointeger(diai)+2+mesc,"06z","12z","18z",\ 
                             tointeger(diai)+3+mesc,"06z","12z","18z",\
                             tointeger(diai)+4+mesc,"06z","12z","18z"/)
rh_res@tmXBLabelAngleF      = 90. ; Gira os rótulos do eixo x inferior.
rh_res@tmXBLabelJust        = "CenterCenter" ; Alinhamento dos rótulos 
                                             ; do eixo x inferior (B).
rh_res@tmXBLabelFontHeightF = 0.016          ; Tamanho da fonte do eixo
                                             ; x inferior (B).

; Recursos para a temperatura do ar.
temp_res@sfXArray           = taus            ; Valores do eixo x.
temp_res@sfYArray           = levels          ; Valores do eixo y.
temp_res@cnLineThicknessF   = 4.0             ; Espessura das linhas de
                                              ; contorno.
temp_res@cnLineColor        = "Red"           ; Cor da linha.
temp_res@cnInfoLabelOn      = False           ; Desabilita as 
                                              ; informações do contorno.
temp_res@gsnContourZeroLineThicknessF = 6.0   ; Espessura do contorno 
                                              ; de valor zero de 
                                              ; temperatura.

; Recursos para a velocidade do vento.
uv_res@vfXArray            = taus       ; Valores do eixo x.
uv_res@vfYArray            = levels     ; Valores do eixo y.
uv_res@vcRefAnnoOn         = False      ; Desabilita o vetor 
                                        ; de referência.
uv_res@vcRefLengthF        = 0.040      ; Define o comprimento do vetor.
uv_res@vcGlyphStyle        = "WindBarb" ; Habilita barbela do vento.
uv_res@vcMapDirection      = False      ; Necessário para dissociar o 
                                        ; plano de coordendas a 
                                        ; a partir da barbela do vento.
          
; Recursos para a precipitação (gráfico de linha).
rain_res@vpXF             = 0.15          ; Posição x para desenhar
                                          ; a figura.
rain_res@vpYF             = 0.40          ; Posição y para desenhar 
                                          ; a figura.
rain_res@vpWidthF         = 0.70          ; Largura da figura.
rain_res@vpHeightF        = 0.10          ; Altura da figura.
rain_res@trYMinF          = 0.0           ; Mínimo valor do eixo y.
rain_res@trYMaxF          = max(rain)+1.0 ; Máximo valor do eixo y.
rain_res@trXMinF          = min(taus)     ; Mínimo valor do eixo x.
rain_res@trXMaxF          = max(taus)     ; Máximo valor do eixo x.
rain_res@tiXAxisString    = ""            ; Título do eixo x.
rain_res@tiYAxisString    = "Prec total "+dt+"h" ; Título do eixo y.
rain_res@tmXBMode         = "Explicit"     ; Defino o eixo x inferior 
                                           ; (B) do meu jeito.
rain_res@tmXBValues       = taus           ; Valores para o eixo x 
                                           ; inferior (B).
                            ; Rótulos do eixo x.
rain_res@tmXBLabels       = (/tointeger(diai)+mesc,"06z","12z","18z",\
                              tointeger(diai)+1+mesc,"06z","12z","18z",\
                              tointeger(diai)+2+mesc,"06z","12z","18z",\
                              tointeger(diai)+3+mesc,"06z","12z","18z",\
                              tointeger(diai)+4+mesc,"06z","12z","18z"/) 
rain_res@tmXTOn           = False  ; Desabilita os traços do eixo x 
                                   ; superior (T).
rain_res@gsnDraw          = False          
rain_res@gsnFrame         = False          
rain_res@gsnYRefLine      = 0.0   ; Cria linha de referência 
                                  ; no valor 0.0.
rain_res@gsnAboveYRefLineColor = "orange" ; Cor acima da linha de 
                                          ; referência.
rain_res@gsnXYBarChart    = True          ; Habilita gráfico de barras.


; Recursos para a temperatura à superfície (gráfico de linha).
tempsfc_res@vpXF          = 0.15   ; Posição x para desenhar a figura.
tempsfc_res@vpYF          = 0.22   ; Posição y para desenhar a figura.
tempsfc_res@vpWidthF      = 0.70   ; Largura da figura.
tempsfc_res@vpHeightF     = 0.10   ; Altura da figura.
tempsfc_res@trXMaxF       = max(taus)       ; Máximo valor do eixo x.
tempsfc_res@trYMaxF       = max(tempht)+.5  ; Máximo valor do eixo y.
tempsfc_res@trYMinF       = min(tempht)-.5  ; Mínimo valor do eixo y.
tempsfc_res@tiYAxisString = "Temp a 2m"     ; Título do eixo y da figura.
tempsfc_res@tmXBMode      = "Explicit" ; Defino o eixo x inferior (B) 
                                       ; do meu jeito.
tempsfc_res@tmXBValues    = taus       ; Valores do eixo x inferior (B).
tempsfc_res@tmXBLabels    = (/tointeger(diai)+mesc,"06z","12z","18z",\
                              tointeger(diai)+1+mesc,"06z","12z","18z",\
                              tointeger(diai)+2+mesc,"06z","12z","18z",\
                              tointeger(diai)+3+mesc,"06z","12z","18z",\
                              tointeger(diai)+4+mesc,"06z","12z","18z"/)
tempsfc_res@tmXTOn        = False    ; Desabilita os traços do eixo x 
                                     ; superior (T).
tempsfc_res@xyLineThicknesses = 2    ; Espessura da linha.
tempsfc_res@xyLineColor    =  "red"  ; Define cor da linha.
tempsfc_res@gsnDraw         = False        
tempsfc_res@gsnFrame        = False        

; Gerando as figuras.
rhfill    = gsn_contour(wks,smothrh,rh_res)
templine  = gsn_contour(wks,smothtemp,temp_res)
templine  = ColorNegDashZeroPosContour(templine,"blue","black","red")
windlayer = gsn_vector(wks,ugridN,vgridN,uv_res)
rainhist  = gsn_csm_xy(wks,taus,rain,rain_res)
temptmsz  = gsn_csm_xy(wks,taus,tempht,tempsfc_res)

; Sobreposição dos campos para gerar a figura final.
overlay(rhfill,templine)   ; Sobreposição do campo templine sobre o 
                           ; rhfill.
overlay(rhfill,windlayer)  ; Sobreposição do campo windlayer sobre os 
                           ; dois campos.
draw(rhfill)               ; Gera a sobreposição.
draw(rainhist)             ; Gera o gráfico de barras.
draw(temptmsz)             ; Gera o gráfico de linha.
frame(wks)                 ; E finalmente, avança o frame para juntar 
                           ; todas as páginas.

end
