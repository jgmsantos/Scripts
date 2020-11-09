; Nome do script: cap21_ex58.ncl

begin

; float precip(time, lat, lon) - jan1979 a out2015
f = addfile("../../dados/precip.mon.mean.nc","r")
; short olr(time, lat, lon)    - jan2000 a dez2009
g = addfile("../../dados/olr.jan2000.dez2009.nc","r") 

data = 200001 ; Data de interesse.

yrStrt1 = data    
TIME1   = f->time                ; Importa a variável time do arquivo f.
YYYYMM1 = cd_calendar(TIME1,-1)  ; Data no formato YYYYMM (-1).
ti1     = ind(YYYYMM1.eq.yrStrt1); Encontra o índice correspondente a 
                                 ; yrStrt1.

yrStrt2 = data                    
TIME2   = g->time                ; Importa a variável time do arquivo g.
YYYYMM2 = cd_calendar(TIME2,-1)  ; Data no formato YYYYMM (-1).
ti2     = ind(YYYYMM2.eq.yrStrt2); Encontra o índice correspondente a 
                                 ; yrStrt1.

ppt = f->precip(ti1,::-1,:)      ; Inverte a latitude porque estava de
                                 ; norte para sul.
                                 ; Agora => lat: [-88.75..88.75] => Sul
                                 ; para norte  
rol = short2flt(g->olr(ti2,::-1,:)) ; Inverte a latitude porque estava 
                                    ; de norte para sul.  
                                    ; Agora => lat: [-90..90] => Sul 
                                    ; para norte

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex58")

gsn_define_colormap(wks,"precip2_17lev") ; Define a tabela de cores para 
                                         ; gráfico.

res1                    = True
res1@gsnDraw            = False          ; Não gera a figura.
res1@gsnFrame           = False          ; Não avança o frame.
res1@cnFillOn           = True           ; Habilita preenchimento.
res1@cnLinesOn          = False          ; Desabilita as linhas de 
                                         ; contorno.
res1@mpMaxLatF          = 20.0           ; Latitude sul.       
res1@mpMinLatF          = -60.0          ; Latitude norte.
res1@mpMinLonF          = -100.0         ; Longitude oeste.
res1@mpMaxLonF          = -10.0          ; Longitude leste.
res1@gsnLeftString      = ""             ; Não adiciona título no lado 
                                         ; esquerdo da figura.
res1@gsnCenterString    = ""             ; Não adiciona título no centro
                                         ; da figura.
res1@gsnRightString     = ""             ; Não adiciona título no lado 
                                         ; direito da figura.
res1@gsnMajorLonSpacing = 10             ; Espaçamento do eixo x da 
                                         ; longitude.
res1@gsnMajorLatSpacing = 10             ; Espaçamento do eixo y da 
                                         ; latitude.
res1@tmXBMinorOn        = False          ; Desabilita os traços 
                                         ; secundários do eixo x. 
res1@tmYLMinorOn        = False          ; Desabilita os traços
                                         ; secundários do eixo y.
res1@tiMainString       = "Precipita"+cedil+atilde+ \ 
                           "o (shaded) e ROL (contorno)"

res2                          = True
res2@gsnDraw                  = False       ; Não gera a figura.
res2@gsnFrame                 = False       ; Não avança o frame.
res2@cnLineLabelPlacementMode = "constant"  ; Define como os rótulos  
                                            ; serão mostrados.
res2@cnInfoLabelOn            = False       ; Não mostra as informações
                                            ; do contorno.
res2@gsnLeftString            = ""          ; Não adiciona título no 
                                            ; lado esquerdo da figura.
res2@gsnCenterString          = ""          ; Não adiciona título no 
                                            ; centro da figura.
res2@gsnRightString           = ""          ; Não adiciona título no 
                                            ; lado direito da figura.

plot1 = gsn_csm_contour_map(wks,ppt,res1) ; Cria o plot da 
                                          ; precipitação (mm/dia).
plot2 = gsn_csm_contour(wks,rol,res2)     ; Cria o plot da radiação 
                                          ; de onlda longa (W/m^2).

; Essas linhas são necessárias para fazer a sobreposição dos campos.
overlay(plot1,plot2) ; Sobreposição do plot2 (ROL) sobre o plot1 
                     ; (precipitação).
draw(plot1)          ; Gera o plot da precipitação.
frame(wks)           ; Avança o frame.

end
