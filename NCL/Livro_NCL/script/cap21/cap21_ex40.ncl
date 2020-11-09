; Nome do script: cap21_ex40.ncl

begin

f = addfile("../../dados/uwnd.mensal.2000.2005.nc","r")

timeUnits = f->time@units

ti = cd_inv_calendar(2000,01,01,00,0,0,timeUnits,0)
tf = cd_inv_calendar(2001,12,01,00,0,0,timeUnits,0)

timeUnits = "days since 1800-01-01 00:00:00"

 ; short uwnd ( time, level, lat, lon ) = 3, 12, 73, 144
u = short2flt(f->uwnd({ti:tf},:,:,:))

; uN teve a ordem das dimensões alterada de time, level, lat, lon para 
; level, time, lat, lon.
 
; A dimensão nível vertical deve ser a primeira dimensão,
; para gerar esse tipo de gráfico em que a pressão está no
; eixo y e o tempo no eixo x, por isso, foi feita a 
; reordenação das dimensões.

uN = u(level|:,time|:,lat|:,lon|:)

uN&time = ut_convert( uN&time, timeUnits )

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex40")

res                  = True
res@tmXBLabelAngleF  = -90   ; Inclinação dos rótulos 
                             ; do eixo x.
res@tmXBLabelJust    = "CenterRight" ; Alinhamento dos 
                                     ; rótulos do eixo x.

; Personaliza o eixo x (dimensão tempo).
resTick                = True
resTick@ttmFormat      = "%c%Y"  ; %c é o mês no formato 
                                 ; Mmm (Jan) e %Y é o ano no 
                                 ; formato AAAA (2000). 
resTick@ttmAxis        = "XB"    ; Qual eixo formatar? 
                                 ; XB = eixo "X" e "B" = bottom.
resTick@ttmMajorStride = 2       ; Intervalo dos rótulos do eixo x.

; Fixa recursos necessários para padronizar a dimensão tempo.

time_axis_labels(uN&time,res,resTick)

; Plot da figura pressão (y) versus tempo (x). 
; Lat/lon escolhida "0"/"300". Com o símbolo "{}" 
; pode-se utilizar a coordenada de latitude e longitude.

plot = gsn_csm_pres_hgt(wks,uN(:,:,{0},{300}),res) 

end
