; Nome do script: cap21_ex41.ncl

begin

f = addfile("../../dados/uwnd.mensal.2000.2005.nc","r")

timeUnits = f->time@units

ti = cd_inv_calendar(2000,01,01,00,0,0,timeUnits,0)
tf = cd_inv_calendar(2001,12,01,00,0,0,timeUnits,0)

timeUnits = "days since 1800-01-01 00:00:00"

u = short2flt(f->uwnd({ti:tf},:,:,:)) 

; A dimensão nível vertical deve ser a primeira dimensão,
; para gerar esse tipo de gráfico.

uN = u(level|:,time|:,lat|:,lon|:) 

uN&time = ut_convert( uN&time, timeUnits )

wks = gsn_open_wks("pdf","../../figuras/cap21/cap21_ex41")

res                              = True
res@tmXBLabelAngleF              = -90
res@tmXBLabelJust                = "CenterRight"
res@gsnDraw                      = False
res@gsnFrame                     = False
res@gsnContourZeroLineThicknessF = 5.0
res@gsnContourNegLineDashPattern = 1 	 ; Fixa as isolinhas 
                                         ; negativas com o padrão 1

; Personaliza o eixo x (dimensão tempo).
resTick                = True
resTick@ttmFormat      = "%c%Y"  ; %c é o mês no formato 
                                 ; Mmm (Jan) e %Y é o ano no 
                                 ; formato AAAA (2000). 
resTick@ttmAxis        = "XB"    ; XB = eixo "X" e "B" = bottom.
resTick@ttmMajorStride = 2       ; Intervalo dos rótulos do eixo x.

time_axis_labels(uN&time,res,resTick)

plot = gsn_csm_pres_hgt(wks,uN(:,:,{0},{300}),res) 

plot = ShadeLtGtContour(plot,-10.0,3,5.0,17) 

draw (plot)
frame(wks)

end
